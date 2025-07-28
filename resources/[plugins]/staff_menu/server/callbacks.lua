-- Get player group callback
ESX.RegisterServerCallback('staff_menu:getPlayerGroup', function(source, cb)
    local group, level = GetPlayerGroupAndLevel(source)
    cb(group, level)
end)

-- Get online players callback
ESX.RegisterServerCallback('staff_menu:getOnlinePlayers', function(source, cb)
    local players = {}
    local xPlayers = ESX.GetExtendedPlayers()
    
    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        local playerData = {
            id = xPlayer.source,
            name = xPlayer.getName(),
            group = xPlayer.getGroup(),
            steamName = GetPlayerName(xPlayer.source),
            health = GetEntityHealth(GetPlayerPed(xPlayer.source)),
            armor = GetPedArmour(GetPlayerPed(xPlayer.source))
        }
        
        -- Get basic needs if available
        TriggerEvent('esx_status:getStatus', xPlayer.source, 'hunger', function(status)
            if status then
                playerData.food = math.floor(status.percent)
            end
        end)
        
        TriggerEvent('esx_status:getStatus', xPlayer.source, 'thirst', function(status)
            if status then
                playerData.water = math.floor(status.percent)
            end
        end)
        
        -- Add some delay to get status values
        Wait(10)
        
        table.insert(players, playerData)
    end
    
    cb(players)
end)

-- Alternative method to get player stats using MySQL
ESX.RegisterServerCallback('staff_menu:getPlayerStats', function(source, cb)
    local players = {}
    local xPlayers = ESX.GetExtendedPlayers()
    
    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        local playerData = {
            id = xPlayer.source,
            name = xPlayer.getName(),
            group = xPlayer.getGroup(),
            steamName = GetPlayerName(xPlayer.source),
            health = GetEntityHealth(GetPlayerPed(xPlayer.source)),
            armor = GetPedArmour(GetPlayerPed(xPlayer.source)),
            food = 50, -- Default values
            water = 50
        }
        
        -- Try to get status from database if esx_status is available
        MySQL.query('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
            if result[1] then
                -- Try to parse status JSON if it exists
                if result[1].status then
                    local status = json.decode(result[1].status)
                    if status then
                        for _, stat in pairs(status) do
                            if stat.name == 'hunger' then
                                playerData.food = math.floor(stat.percent or 50)
                            elseif stat.name == 'thirst' then
                                playerData.water = math.floor(stat.percent or 50)
                            end
                        end
                    end
                end
            end
        end)
        
        table.insert(players, playerData)
    end
    
    cb(players)
end)

-- Get player by ID callback
ESX.RegisterServerCallback('staff_menu:getPlayerById', function(source, cb, targetId)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        cb(nil)
        return
    end
    
    local playerData = {
        id = xTarget.source,
        name = xTarget.getName(),
        group = xTarget.getGroup(),
        steamName = GetPlayerName(xTarget.source),
        identifier = xTarget.identifier,
        health = GetEntityHealth(GetPlayerPed(xTarget.source)),
        armor = GetPedArmour(GetPlayerPed(xTarget.source))
    }
    
    cb(playerData)
end)

-- Ban system callback (if you want to implement database bans)
ESX.RegisterServerCallback('staff_menu:banPlayer', function(source, cb, targetId, reason, duration)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not HasPermission(source, 'ban') then
        cb(false, 'No permission')
        return
    end
    
    if not xTarget then
        cb(false, 'Player not found')
        return
    end
    
    -- You can implement your own ban system here
    -- For now, we'll just kick the player
    local banMessage = string.format('Banned by %s. Reason: %s', xPlayer.getName(), reason)
    
    -- Log the ban
    print(string.format('[STAFF_MENU] %s banned %s for %s days. Reason: %s', 
        xPlayer.getName(), xTarget.getName(), duration, reason))
    
    -- Insert ban into database (you'd need to create a bans table)
    --[[
    MySQL.insert('INSERT INTO bans (identifier, name, reason, banned_by, ban_date, unban_date) VALUES (?, ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? DAY))', 
    {xTarget.identifier, xTarget.getName(), reason, xPlayer.getName(), duration}, function(insertId)
        if insertId then
            DropPlayer(targetId, banMessage)
            cb(true, 'Player banned successfully')
        else
            cb(false, 'Database error')
        end
    end)
    --]]
    
    -- For now, just kick
    DropPlayer(targetId, banMessage)
    cb(true, 'Player kicked (ban system not fully implemented)')
end)

-- Get staff groups callback  
ESX.RegisterServerCallback('staff_menu:getStaffGroups', function(source, cb)
    local groups = {}
    
    for group, data in pairs(Config.StaffGroups) do
        table.insert(groups, {
            value = group,
            label = data.label,
            level = data.level
        })
    end
    
    -- Sort by level (highest first)
    table.sort(groups, function(a, b) return a.level > b.level end)
    
    cb(groups)
end)

-- Change player group callback
ESX.RegisterServerCallback('staff_menu:changePlayerGroup', function(source, cb, targetId, newGroup)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not HasPermission(source, 'changegroup') then
        cb(false, 'No permission')
        return
    end
    
    if not xTarget then
        cb(false, 'Player not found')
        return
    end
    
    if not Config.StaffGroups[newGroup] then
        cb(false, 'Invalid group')
        return
    end
    
    -- Check if trying to set higher level than own
    local playerLevel = GetPlayerGroupAndLevel(source)
    local targetLevel = Config.StaffGroups[newGroup].level
    
    if targetLevel >= playerLevel then
        cb(false, 'Cannot set group higher than or equal to your own')
        return
    end
    
    -- Set the group
    xTarget.setGroup(newGroup)
    
    -- Notify both players
    TriggerClientEvent('esx:showNotification', source, 
        string.format('~g~Changed %s group to %s', xTarget.getName(), Config.StaffGroups[newGroup].label))
    TriggerClientEvent('esx:showNotification', targetId, 
        string.format('~y~Your group was changed to %s by %s', Config.StaffGroups[newGroup].label, xPlayer.getName()))
    
    -- Log action
    print(string.format('[STAFF_MENU] %s changed %s group to %s', 
        xPlayer.getName(), xTarget.getName(), newGroup))
    
    cb(true, 'Group changed successfully')
end)
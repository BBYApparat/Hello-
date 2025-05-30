-- server/main.lua
local ESX = exports['es_extended']:getSharedObject()
local cowCooldowns = {} -- Global cooldowns for all cows

-- Initialize cooldowns
for i = 1, #Config.CowLocations do
    cowCooldowns[i] = 0
end

-- Give milk to player
RegisterServerEvent('cow-milking:giveMilk')
AddEventHandler('cow-milking:giveMilk', function(cowId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if cow exists and is not on cooldown
    if not cowId or cowId < 1 or cowId > #Config.CowLocations then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cow Milking',
            description = 'Invalid cow!',
            type = 'error'
        })
        return
    end
    
    local currentTime = os.time()
    if cowCooldowns[cowId] > currentTime then
        local timeLeft = cowCooldowns[cowId] - currentTime
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cow Milking',
            description = string.format('This cow needs %d more minutes to recover.', math.ceil(timeLeft / 60)),
            type = 'error'
        })
        return
    end
    
    -- Random amount of milk (1-3)
    local milkAmount = math.random(Config.MinMilk, Config.MaxMilk)
    
    -- Check if player can carry the milk
    local canCarry = exports.ox_inventory:CanCarryItem(source, Config.MilkItem, milkAmount)
    
    if canCarry then
        -- Give milk to player
        exports.ox_inventory:AddItem(source, Config.MilkItem, milkAmount)
        
        -- Set cooldown for this cow
        cowCooldowns[cowId] = currentTime + (Config.CowCooldowns[cowId] * 60) -- Convert minutes to seconds
        
        -- Notify player
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cow Milking',
            description = string.format('You received %d %s!', milkAmount, Config.MilkItemLabel),
            type = 'success'
        })
        
        -- Log the action
        print(string.format('[Cow Milking] %s (%s) milked cow #%d and received %d milk', 
            xPlayer.getName(), xPlayer.identifier, cowId, milkAmount))
        
        -- Sync cooldowns to all players
        TriggerClientEvent('cow-milking:syncCooldowns', -1, convertCooldownsToGameTime())
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cow Milking',
            description = 'Your inventory is full!',
            type = 'error'
        })
    end
end)

-- Convert server cooldowns (os.time) to client cooldowns (GetGameTimer)
function convertCooldownsToGameTime()
    local currentTime = os.time()
    local clientCooldowns = {}
    
    for cowId, cooldownTime in pairs(cowCooldowns) do
        if cooldownTime > currentTime then
            local timeLeft = cooldownTime - currentTime
            clientCooldowns[cowId] = GetGameTimer() + (timeLeft * 1000) -- Convert seconds to milliseconds
        else
            clientCooldowns[cowId] = 0
        end
    end
    
    return clientCooldowns
end

-- Get cooldown info for admin/debug
RegisterServerEvent('cow-milking:getCooldownInfo')
AddEventHandler('cow-milking:getCooldownInfo', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player is admin (adjust this according to your admin system)
    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        return
    end
    
    local currentTime = os.time()
    local cooldownInfo = {}
    
    for cowId, cooldownTime in pairs(cowCooldowns) do
        local timeLeft = math.max(0, cooldownTime - currentTime)
        cooldownInfo[cowId] = {
            minutesLeft = math.ceil(timeLeft / 60),
            available = timeLeft <= 0
        }
    end
    
    TriggerClientEvent('cow-milking:receiveCooldownInfo', source, cooldownInfo)
end)

-- Reset all cow cooldowns (admin command)
RegisterServerEvent('cow-milking:resetCooldowns')
AddEventHandler('cow-milking:resetCooldowns', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player is admin
    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Cow Milking',
            description = 'You do not have permission to use this command.',
            type = 'error'
        })
        return
    end
    
    -- Reset all cooldowns
    for i = 1, #Config.CowLocations do
        cowCooldowns[i] = 0
    end
    
    -- Sync to all clients
    TriggerClientEvent('cow-milking:syncCooldowns', -1, {})
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Cow Milking',
        description = 'All cow cooldowns have been reset!',
        type = 'success'
    })
    
    print(string.format('[Cow Milking] %s reset all cow cooldowns', xPlayer.getName()))
end)

-- Player loaded event - sync cooldowns
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId)
    Wait(5000) -- Wait for player to fully load
    TriggerClientEvent('cow-milking:syncCooldowns', playerId, convertCooldownsToGameTime())
end)

-- Save cooldowns to database (optional - for persistent cooldowns across server restarts)
if Config.PersistentCooldowns then
    -- Load cooldowns from database on resource start
    AddEventHandler('onResourceStart', function(resourceName)
        if GetCurrentResourceName() ~= resourceName then return end
        
        MySQL.Async.fetchAll('SELECT * FROM cow_cooldowns', {}, function(results)
            if results then
                for _, row in ipairs(results) do
                    cowCooldowns[row.cow_id] = row.cooldown_time
                end
                print(string.format('[Cow Milking] Loaded cooldowns for %d cows from database', #results))
            else
                -- Create table if it doesn't exist
                MySQL.Async.execute([[
                    CREATE TABLE IF NOT EXISTS cow_cooldowns (
                        cow_id INT PRIMARY KEY,
                        cooldown_time INT DEFAULT 0
                    )
                ]], {}, function()
                    -- Insert initial data
                    for i = 1, #Config.CowLocations do
                        MySQL.Async.execute('INSERT IGNORE INTO cow_cooldowns (cow_id, cooldown_time) VALUES (?, ?)', {i, 0})
                    end
                    print('[Cow Milking] Created cow_cooldowns table and initialized data')
                end)
            end
        end)
    end)
    
    -- Save cooldowns to database periodically
    CreateThread(function()
        while true do
            Wait(Config.SaveInterval * 1000) -- Convert seconds to milliseconds
            
            for cowId, cooldownTime in pairs(cowCooldowns) do
                MySQL.Async.execute('UPDATE cow_cooldowns SET cooldown_time = ? WHERE cow_id = ?', {
                    cooldownTime, cowId
                })
            end
        end
    end)
end

-- Register milk as usable item
exports.ox_inventory:registerHook('usingItem', function(payload)
    if payload.itemName == Config.MilkItem then
        local source = payload.source
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Health',
            description = 'You drank some fresh milk!',
            type = 'success'
        })
        
        -- Trigger client effect
        TriggerClientEvent('cow-milking:drinkMilk', source)
        
        return true -- Allow item consumption
    end
end, {
    itemFilter = {
        [Config.MilkItem] = true
    }
})

-- Alternative method for item usage if the above doesn't work
RegisterServerEvent('cow-milking:useMilk')
AddEventHandler('cow-milking:useMilk', function()
    local source = source
    local hasItem = exports.ox_inventory:GetItemCount(source, Config.MilkItem)
    
    if hasItem > 0 then
        exports.ox_inventory:RemoveItem(source, Config.MilkItem, 1)
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Health',
            description = 'You drank some fresh milk!',
            type = 'success'
        })
        
        TriggerClientEvent('cow-milking:drinkMilk', source)
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    if Config.PersistentCooldowns then
        -- Save final cooldowns to database
        for cowId, cooldownTime in pairs(cowCooldowns) do
            MySQL.Async.execute('UPDATE cow_cooldowns SET cooldown_time = ? WHERE cow_id = ?', {
                cooldownTime, cowId
            })
        end
        print('[Cow Milking] Saved final cooldowns to database')
    end
end)
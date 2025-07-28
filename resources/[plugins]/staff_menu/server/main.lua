local ESX = exports["es_extended"]:getSharedObject()

-- Get player group and level
function GetPlayerGroupAndLevel(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 'user', 0 end
    
    local group = xPlayer.getGroup()
    local level = 0
    
    if Config.StaffGroups[group] then
        level = Config.StaffGroups[group].level
    end
    
    return group, level
end

-- Check if player has permission
function HasPermission(source, action)
    local group, level = GetPlayerGroupAndLevel(source)
    local perm = Config.Permissions[action]
    
    if not perm then return false end
    return level >= perm.minLevel
end

-- Events - Using existing ESX commands for optimization
RegisterServerEvent('staff_menu:teleportToPlayer')
AddEventHandler('staff_menu:teleportToPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'goto') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Use existing ESX goto command for better performance
    ESX.RegisteredCommands['goto'].suggestion.cb(xPlayer, {playerId = xTarget}, function() end)
    
    -- Log action
    print(string.format('[STAFF_MENU] %s teleported to %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:bringPlayer')
AddEventHandler('staff_menu:bringPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'bring') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Use existing ESX bring command for better performance
    ESX.RegisteredCommands['bring'].suggestion.cb(xPlayer, {playerId = xTarget}, function() end)
    
    -- Log action
    print(string.format('[STAFF_MENU] %s brought %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:healPlayer')
AddEventHandler('staff_menu:healPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'heal') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Heal player using native functions for better performance
    local targetPed = GetPlayerPed(targetId)
    SetEntityHealth(targetPed, 200)
    
    -- Heal hunger and thirst if available
    TriggerEvent('esx_status:add', targetId, 'hunger', 1000000)
    TriggerEvent('esx_status:add', targetId, 'thirst', 1000000)
    
    TriggerClientEvent('esx:showNotification', targetId, '~g~You were healed by staff')
    TriggerClientEvent('esx:showNotification', source, '~g~Player healed successfully')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s healed %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:armorPlayer')
AddEventHandler('staff_menu:armorPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'armor') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Use native function for better performance
    local targetPed = GetPlayerPed(targetId)
    SetPedArmour(targetPed, 100)
    
    TriggerClientEvent('esx:showNotification', targetId, '~b~You received armor from staff')
    TriggerClientEvent('esx:showNotification', source, '~b~Armor given successfully')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s gave armor to %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:revivePlayer')
AddEventHandler('staff_menu:revivePlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'revive') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Use optimized revive method
    local targetPed = GetPlayerPed(targetId)
    
    -- Full heal and revive
    SetEntityHealth(targetPed, 200)
    SetPedArmour(targetPed, 0)
    
    -- Clear death status and animations
    TriggerClientEvent('staff_menu:forceRevive', targetId)
    TriggerClientEvent('esx:showNotification', targetId, '~g~You were revived by staff')
    TriggerClientEvent('esx:showNotification', source, '~g~Player revived successfully')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s revived %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:freezePlayer')
AddEventHandler('staff_menu:freezePlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'freeze') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    TriggerClientEvent('staff_menu:toggleFreeze', targetId)
    TriggerClientEvent('esx:showNotification', source, '~y~Player freeze status toggled')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s toggled freeze on %s', xPlayer.getName(), xTarget.getName()))
end)

RegisterServerEvent('staff_menu:kickPlayer')
AddEventHandler('staff_menu:kickPlayer', function(targetId, reason)
    local source = source
    
    if not HasPermission(source, 'kick') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, '~r~Player not found!')
        return
    end
    
    -- Log action
    print(string.format('[STAFF_MENU] %s kicked %s. Reason: %s', xPlayer.getName(), xTarget.getName(), reason))
    
    DropPlayer(targetId, 'Kicked by ' .. xPlayer.getName() .. '. Reason: ' .. reason)
end)

RegisterServerEvent('staff_menu:setWeather')
AddEventHandler('staff_menu:setWeather', function(weather)
    local source = source
    
    if not HasPermission(source, 'weather') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    TriggerClientEvent('esx:setWeather', -1, weather)
    TriggerClientEvent('esx:showNotification', -1, '~y~Weather changed to ' .. weather .. ' by staff')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s changed weather to %s', xPlayer.getName(), weather))
end)

RegisterServerEvent('staff_menu:setTime')
AddEventHandler('staff_menu:setTime', function(hour)
    local source = source
    
    if not HasPermission(source, 'weather') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    TriggerClientEvent('esx:setTime', -1, hour, 0)
    TriggerClientEvent('esx:showNotification', -1, '~y~Time set to ' .. hour .. ':00 by staff')
    
    -- Log action
    print(string.format('[STAFF_MENU] %s set time to %s:00', xPlayer.getName(), hour))
end)

RegisterServerEvent('staff_menu:spawnVehicle')
AddEventHandler('staff_menu:spawnVehicle', function(model)
    local source = source
    
    if not HasPermission(source, 'spawncar') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Use existing ESX car command for optimization
    ESX.RegisteredCommands['car'].suggestion.cb(xPlayer, {car = model}, function() end)
    
    -- Log action
    print(string.format('[STAFF_MENU] %s spawned vehicle: %s', xPlayer.getName(), model))
end)

RegisterServerEvent('staff_menu:adminCar')
AddEventHandler('staff_menu:adminCar', function(targetId)
    local source = source
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = targetId and ESX.GetPlayerFromId(targetId) or nil
    
    -- Use existing admincar command for optimization
    ESX.RegisteredCommands['admincar'].suggestion.cb(xPlayer, {
        car = nil, -- Will use current vehicle or default
        playerId = target
    }, function() end)
    
    -- Log action
    local targetName = target and target.getName() or 'self'
    print(string.format('[STAFF_MENU] %s used admincar on %s', xPlayer.getName(), targetName))
end)

RegisterServerEvent('staff_menu:fixGarage')
AddEventHandler('staff_menu:fixGarage', function(plate)
    local source = source
    
    if not HasPermission(source, 'fixgarage') then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission!')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Use existing fixgarage command for optimization
    ESX.RegisteredCommands['fixgarage'].suggestion.cb(xPlayer, {plate = plate}, function() end)
    
    -- Log action
    print(string.format('[STAFF_MENU] %s used fixgarage on plate: %s', xPlayer.getName(), plate))
end)

RegisterServerEvent('staff_menu:deleteVehicle')
AddEventHandler('staff_menu:deleteVehicle', function(netId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        
        -- Log action
        print(string.format('[STAFF_MENU] %s deleted a vehicle', xPlayer.getName()))
    end
end)

-- Remove unused client events - using server-side natives instead for better performance
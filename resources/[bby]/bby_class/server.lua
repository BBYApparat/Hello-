-- Initialize ESX
ESX = exports.es_extended:getSharedObject()

-- Track active pursuit mode vehicles for syncing
local activePursuitVehicles = {}

-- Sync pursuit mode activation with all players
RegisterServerEvent('bby_class:server:syncActivation')
AddEventHandler('bby_class:server:syncActivation', function(netId, pursuitClass)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    -- Only allow police to activate pursuit mode
    if not xPlayer or not (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
        return
    end
    
    -- Store active pursuit vehicle
    activePursuitVehicles[netId] = {
        pursuitClass = pursuitClass,
        officerId = src,
        officerName = xPlayer.getName(),
        activatedAt = os.time()
    }
    
    -- Broadcast to all clients except source
    TriggerClientEvent('bby_class:client:syncActivation', -1, netId, pursuitClass)
end)

-- Sync deactivation with all players
RegisterServerEvent('bby_class:server:syncDeactivation')
AddEventHandler('bby_class:server:syncDeactivation', function(netId)
    local src = source
    
    -- Check if vehicle had pursuit mode active
    if activePursuitVehicles[netId] then
        -- Remove from active pursuits
        activePursuitVehicles[netId] = nil
        
        -- Broadcast to all clients
        TriggerClientEvent('bby_class:client:syncDeactivation', -1, netId)
    end
end)

-- Clean up when a player disconnects
AddEventHandler('playerDropped', function()
    local src = source
    
    -- Find and remove any pursuit vehicles activated by this player
    for netId, data in pairs(activePursuitVehicles) do
        if data.officerId == src then
            activePursuitVehicles[netId] = nil
        end
    end
end)
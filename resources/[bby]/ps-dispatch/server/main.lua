local calls = {}
local callCount = 0

-- Functions
exports('GetDispatchCalls', function()
    return calls
end)

-- Events
RegisterServerEvent('ps-dispatch:server:notify', function(data)
    callCount = callCount + 1
    data.id = callCount
    data.time = os.time() * 1000
    data.units = {}
    data.responses = {}

    if #calls > 0 then
        if calls[#calls] == data then
            return
        end
    end
        
    if #calls >= Config.MaxCallList then
        table.remove(calls, 1)
    end

    calls[#calls + 1] = data

    TriggerClientEvent('ps-dispatch:client:notify', -1, data)
end)

RegisterServerEvent('ps-dispatch:server:attach', function(id, player)
    for i=1, #calls do
        if calls[i]['id'] == id then
            for j = 1, #calls[i]['units'] do
                local playerIdentifier = player.citizenid or player.identifier
                local unitIdentifier = calls[i]['units'][j]['citizenid'] or calls[i]['units'][j]['identifier']
                if unitIdentifier == playerIdentifier then
                    return
                end
            end
            calls[i]['units'][#calls[i]['units'] + 1] = player
            return
        end
    end
end)

RegisterServerEvent('ps-dispatch:server:detach', function(id, player)
    for i = #calls, 1, -1 do
        if calls[i]['id'] == id then
            if calls[i]['units'] and (#calls[i]['units'] or 0) > 0 then
                for j = #calls[i]['units'], 1, -1 do
                    local playerIdentifier = player.citizenid or player.identifier
                    local unitIdentifier = calls[i]['units'][j]['citizenid'] or calls[i]['units'][j]['identifier']
                    if unitIdentifier == playerIdentifier then
                        table.remove(calls[i]['units'], j)
                    end
                end
            end
            return
        end
    end
end)

-- Callbacks
lib.callback.register('ps-dispatch:callback:getLatestDispatch', function(source)
    return calls[#calls]
end)

lib.callback.register('ps-dispatch:callback:getCalls', function(source)
    return calls
end)

-- Clear all calls for clients
RegisterServerEvent('ps-dispatch:server:clearCalls', function()
    calls = {}
    callCount = 0
    TriggerClientEvent('ps-dispatch:client:clearAll', -1)
end)

-- Commands
lib.addCommand('dispatch', {
    help = locale('open_dispatch')
}, function(source, raw)
    TriggerClientEvent("ps-dispatch:client:openMenu", source, calls)
end)

lib.addCommand('911', {
    help = 'Send a message to 911',
    params = { { name = 'message', type = 'string', help = '911 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "911", false)
end)
lib.addCommand('911a', {
    help = 'Send an anonymous message to 911',
    params = { { name = 'message', type = 'string', help = '911 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "911", true)
end)

lib.addCommand('311', {
    help = 'Send a message to 311',
    params = { { name = 'message', type = 'string', help = '311 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "311", false)
end)

lib.addCommand('311a', {
    help = 'Send an anonymous message to 311',
    params = { { name = 'message', type = 'string', help = '311 Message' }},
}, function(source, args, raw)
    local fullMessage = raw:sub(5)
    TriggerClientEvent('ps-dispatch:client:sendEmergencyMsg', source, fullMessage, "311", true)
end)

-- ESX Compatibility - Add server callbacks
if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    
    -- ESX callback for checking if player has item
    ESX.RegisterServerCallback('ps-dispatch:server:hasItem', function(source, cb, items, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb(false)
            return
        end
        
        amount = amount or 1
        
        if type(items) == 'string' then
            items = {items}
        end
        
        for _, itemName in ipairs(items) do
            local item = xPlayer.getInventoryItem(itemName)
            if item and item.count >= amount then
                cb(true)
                return
            end
        end
        
        cb(false)
    end)
end

-- Clear dispatch command
lib.addCommand('cdp', {
    help = 'Clear all dispatch calls (LEO only)',
    restricted = {'group.admin', 'group.police', 'group.sheriff'}
}, function(source, args, raw)
    calls = {}
    callCount = 0
    TriggerClientEvent('ps-dispatch:client:clearAll', -1)
    if GetResourceState('es_extended') == 'started' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.showNotification('All dispatch calls cleared.', 'success')
        end
    end
end)


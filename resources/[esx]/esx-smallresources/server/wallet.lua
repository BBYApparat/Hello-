-- Server-side script (server.lua)
-- Add this to your server-side file

RegisterNetEvent('npc_wallet:addMoney')
AddEventHandler('npc_wallet:addMoney', function(amount)
    local src = source
    
    -- Validate amount
    if type(amount) ~= 'number' or amount < 1 or amount > 90 then
        return
    end
    
    -- ESX Framework
    --[[
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        xPlayer.addMoney(amount)
    end
    --]]
    
    -- QBCore Framework
    --[[
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', amount)
    end
    --]]
    
    -- Using ox_inventory (works with most frameworks)
    local success = exports.ox_inventory:AddItem(src, 'money', amount)
    if not success then
        -- Fallback: try adding cash item if money doesn't work
        exports.ox_inventory:AddItem(src, 'cash', amount)
    end
end)


ESX = exports['es_extended']:getSharedObject()

local lastHeistTime = 0
local heistActive = false

-- Check cooldown function
ESX.RegisterServerCallback('J0-CashExchangeHeist:checkCooldown', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentTime = os.time()
    local timeSinceLastHeist = currentTime - lastHeistTime
    
    if heistActive then
        cb(false)
        return
    end
    
    if timeSinceLastHeist < J0.heistCooldown and lastHeistTime ~= 0 then
        local secondsRemaining = J0.heistCooldown - timeSinceLastHeist
        local minutesRemaining = math.floor(secondsRemaining / 60)
        local remainingSeconds = secondsRemaining % 60
        cb(false)
        return
    end
    
    if J0.discordLogs then
        sendToDiscord(J0.discordWebHook, 'Cash Exchange Heist', 
            GetPlayerName(source) .. ' started Cash Exchange Heist', 16711680)
    end
    
    -- Only set heistActive, but don't start the timer yet
    -- The timer will start when thermite is planted
    heistActive = true
    cb(true)
end)

-- Start cooldown timer when thermite is planted
RegisterNetEvent('J0-CashExchangeHeist:sv:startCooldown')
AddEventHandler('J0-CashExchangeHeist:sv:startCooldown', function()
    lastHeistTime = os.time()
    
    -- After cooldown period, reset the heist active status
    Citizen.SetTimeout(J0.heistCooldown * 1000, function()
        heistActive = false
    end)
end)

-- Reset cooldown (admin only)
RegisterNetEvent('J0-CashExchangeHeist:sv:resetCooldown')
AddEventHandler('J0-CashExchangeHeist:sv:resetCooldown', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Check if player is admin
    if isPlayerAdmin(source) then
        lastHeistTime = 0
        heistActive = false
        
        -- Log to discord if enabled
        if J0.discordLogs then
            sendToDiscord(J0.discordWebHook, 'Cash Exchange Heist Admin', 
                GetPlayerName(source) .. ' reset the Cash Exchange Heist cooldown', 47103)
        end
        
        TriggerClientEvent('esx:showNotification', source, 'Cash Exchange: Cooldown reset successfully')
    else
        TriggerClientEvent('esx:showNotification', source, 'Cash Exchange: You do not have permission to reset the cooldown')
    end
end)

-- Check if player has an item
ESX.RegisterServerCallback('J0-CashExchangeHeist:checkItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(false)
        return
    end
    
    local itemCount = xPlayer.getInventoryItem(item).count
    cb(itemCount > 0)
end)

-- Remove item from player
RegisterNetEvent('J0-CashExchangeHeist:sv:removeItem')
AddEventHandler('J0-CashExchangeHeist:sv:removeItem', function(item, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    xPlayer.removeInventoryItem(item, count)
end)

-- Sync door hack state across all clients
RegisterNetEvent('J0-CashExchangeHeist:sv:updateDoorHackState')
AddEventHandler('J0-CashExchangeHeist:sv:updateDoorHackState', function(doorId, state)
    -- Broadcast to all clients
    TriggerClientEvent('J0-cashExchange:cl:updateDoorHackState', -1, doorId, state)
end)

-- Sync door permanently disabled state across all clients
RegisterNetEvent('J0-CashExchangeHeist:sv:updateDoorDisabledState')
AddEventHandler('J0-CashExchangeHeist:sv:updateDoorDisabledState', function(doorId, disabled)
    -- Broadcast to all clients
    TriggerClientEvent('J0-cashExchange:cl:updateDoorDisabledState', -1, doorId, disabled)
end)

-- Give item to player (admin only)
RegisterNetEvent('J0-CashExchangeHeist:sv:giveItem')
AddEventHandler('J0-CashExchangeHeist:sv:giveItem', function(item, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player is admin
    if isPlayerAdmin(source) then
        xPlayer.addInventoryItem(item, count)
        
        -- Log to discord if enabled
        if J0.discordLogs then
            sendToDiscord(J0.discordWebHook, 'Cash Exchange Heist Admin', 
                GetPlayerName(source) .. ' gave themselves ' .. count .. 'x ' .. item, 47103)
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Cash Exchange: You do not have permission to use this command')
    end
end)

-- Check if player is admin function
function isPlayerAdmin(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if xPlayer then
        local playerGroup = xPlayer.getGroup()
        return playerGroup == 'admin' or playerGroup == 'superadmin'
    end
    
    return false
end

-- Callback for admin check
ESX.RegisterServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(source, cb)
    cb(isPlayerAdmin(source))
end)

-- Reward function
RegisterNetEvent('J0-CashExchangeHeist:sv:reward')
AddEventHandler('J0-CashExchangeHeist:sv:reward', function(typ)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    if typ == 'cash' then
        local cashAmount = math.random(J0.rewardTable.cash.min, J0.rewardTable.cash.max)
        xPlayer.addMoney(cashAmount)
        
        if J0.discordLogs then
            sendToDiscord(J0.discordWebHook, 'Cash Exchange Heist', 
                GetPlayerName(source) .. ' received $' .. cashAmount, 16711680)
        end
    elseif typ == 'gold' then
        local goldAmount = math.random(J0.rewardTable.gold.min, J0.rewardTable.gold.max)
        local itemName = J0.rewardTable.gold.itemname
        xPlayer.addInventoryItem(itemName, goldAmount)
        
        if J0.discordLogs then
            sendToDiscord(J0.discordWebHook, 'Cash Exchange Heist', 
                GetPlayerName(source) .. ' received ' .. goldAmount .. 'x ' .. itemName, 16711680)
        end
    end
end)

-- Helper function for Discord logs
function sendToDiscord(webhook, title, message, color)
    if webhook == 'https://discord.com/api/webhooks/1370731314759602216/WNeulM3CZgnamXgH2GKzhOINbhvbTffulRzWhKxXkaL6x2hekqbi_HfPphtusZ2Naj8r' then return end
    
    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "J0-CashExchangeHeist • " .. os.date("%x %X"),
            },
        }
    }
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', 
        json.encode({username = "J0-CashExchangeHeist", embeds = embed}), 
        {['Content-Type'] = 'application/json'})
end

-- Add ESX required server events
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    -- You can initialize player-specific data here if needed
end)
ESX = exports['es_extended']:getSharedObject()

-- Config variables
Config = {}

-- Required items to start heist
Config.RequiredItems = {
    "phone",
    "radio"
}

-- Heist location
Config.HeistLocation = vector3(1290.84, -1710.52, 54.47)

-- Tools needed at heist location
Config.RequiredTools = {
    "drill",
    "lockpick"
}

-- Cooldown in minutes
Config.Cooldown = 60

-- Rewards
Config.Rewards = {
    money = {min = 5000, max = 10000},
    items = {"gold_bar", "jewelry", "cash_stack"}
}

-- Variables
local heistActive = false
local heistStartTime = 0
local activeHeistPlayer = nil
local drillAttempts = 0
local lockpickAttempts = 0
local drillCompleted = false
local lockpickCompleted = false

-- Check if player has required items
local function HasRequiredItems(items, source)
    local xPlayer = ESX.GetPlayerFromId(source)
    for _, item in ipairs(items) do
        if xPlayer.getInventoryItem(item).count <= 0 then
            return false
        end
    end
    return true
end

-- Register server callback
ESX.RegisterServerCallback('simple_heist:canStartHeist', function(source, cb)
    if heistActive then
        cb(false, "Someone is already doing the heist")
        return
    end
    
    if os.time() < heistStartTime + (Config.Cooldown * 60) and heistStartTime > 0 then
        local remainingTime = math.ceil((heistStartTime + (Config.Cooldown * 60) - os.time()) / 60)
        cb(false, "Heist is on cooldown. Available in " .. remainingTime .. " minutes")
        return
    end
    
    if HasRequiredItems(Config.RequiredItems, source) then
        heistActive = true
        heistStartTime = os.time()
        activeHeistPlayer = source
        
        -- Reset heist status
        drillAttempts = 0
        lockpickAttempts = 0
        drillCompleted = false
        lockpickCompleted = false
        
        -- Broadcast to all players that heist has started
        TriggerClientEvent('simple_heist:heistStarted', -1, source)
        cb(true, "You can start the heist")
    else
        cb(false, "You don't have all required items")
    end
end)

-- Check if player is the active heist player
RegisterNetEvent('simple_heist:checkActivePlayer')
AddEventHandler('simple_heist:checkActivePlayer', function()
    local source = source
    TriggerClientEvent('simple_heist:setActivePlayer', source, (source == activeHeistPlayer))
end)

-- Update drill attempt counter
RegisterNetEvent('simple_heist:drillAttempt')
AddEventHandler('simple_heist:drillAttempt', function(success)
    local source = source
    
    -- Only process if the player is the active heist player
    if source ~= activeHeistPlayer then
        return
    end
    
    if success then
        drillCompleted = true
        TriggerClientEvent('simple_heist:updateDrillStatus', source, true)
    else
        drillAttempts = drillAttempts + 1
        if drillAttempts >= 3 then
            -- Failed too many times
            TriggerClientEvent('simple_heist:drillFailed', source)
            
            -- End the heist
            heistActive = false
            TriggerClientEvent('simple_heist:heistEnded', -1)
        else
            TriggerClientEvent('simple_heist:updateDrillStatus', source, false, drillAttempts)
        end
    end
end)

-- Update lockpick attempt counter
RegisterNetEvent('simple_heist:lockpickAttempt')
AddEventHandler('simple_heist:lockpickAttempt', function(success)
    local source = source
    
    -- Only process if the player is the active heist player
    if source ~= activeHeistPlayer then
        return
    end
    
    -- Can only lockpick if drill is completed
    if not drillCompleted then
        TriggerClientEvent('simple_heist:notify', source, "You need to drill first!")
        return
    end
    
    if success then
        lockpickCompleted = true
        
        -- Heist completed successfully
        local reward = math.random(Config.Rewards.money.min, Config.Rewards.money.max)
        local randomItem = Config.Rewards.items[math.random(1, #Config.Rewards.items)]
        
        -- Give rewards
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(reward)
        xPlayer.addInventoryItem(randomItem, 1)
        
        TriggerClientEvent('simple_heist:heistCompleted', source, reward, randomItem)
        
        -- End the heist
        heistActive = false
        TriggerClientEvent('simple_heist:heistEnded', -1)
    else
        lockpickAttempts = lockpickAttempts + 1
        if lockpickAttempts >= 3 then
            -- Failed too many times
            TriggerClientEvent('simple_heist:lockpickFailed', source)
            
            -- End the heist
            heistActive = false
            TriggerClientEvent('simple_heist:heistEnded', -1)
        else
            TriggerClientEvent('simple_heist:updateLockpickStatus', source, false, lockpickAttempts)
        end
    end
end)

-- Handle player disconnect during heist
AddEventHandler('playerDropped', function()
    local source = source
    if source == activeHeistPlayer and heistActive then
        heistActive = false
        TriggerClientEvent('simple_heist:heistEnded', -1)
    end
end)
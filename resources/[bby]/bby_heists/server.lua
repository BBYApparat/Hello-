ESX = exports['es_extended']:getSharedObject()

-- Track cooldowns, active robberies, and failed attempts
local Registers = {}
local ActiveRobberies = {}
local FailedAttempts = {}

-- Initialize registers when provided by client
RegisterNetEvent('minimarket:registerLocationsToServer')
AddEventHandler('minimarket:registerLocationsToServer', function(locations)
    for _, coords in ipairs(locations) do
        table.insert(Registers, {
            coords = coords,
            robbed = false,
            cooldown = 0
        })
    end
end)

-- Check if player has required items
local function HasRequiredItems(xPlayer)
    for _, item in ipairs(Config.Server.AllowedItems) do
        if xPlayer.getInventoryItem(item).count > 0 then
            return true
        end
    end
    return false
end

-- Check police count
local function IsEnoughPoliceOnline()
    local xPlayers = ESX.GetExtendedPlayers('job', Config.Server.PoliceJobName)
    return #xPlayers >= Config.Server.RequiredCops
end

-- Alert police function
local function AlertPolice(coords)
    for _, xPlayer in pairs(ESX.GetExtendedPlayers('job', Config.Server.PoliceJobName)) do
        TriggerClientEvent('minimarket:policeAlert', xPlayer.source, coords)
    end
end

-- Track failed attempts
RegisterNetEvent('minimarket:failedAttempt')
AddEventHandler('minimarket:failedAttempt', function(registerId)
    local source = source
    if not FailedAttempts[source] then
        FailedAttempts[source] = {}
    end
    if not FailedAttempts[source][registerId] then
        FailedAttempts[source][registerId] = 0
    end
    FailedAttempts[source][registerId] = FailedAttempts[source][registerId] + 1
end)

RegisterNetEvent('minimarket:startRobbery')
AddEventHandler('minimarket:startRobbery', function(registerId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    local register = Registers[registerId]
    if not register then
        TriggerClientEvent('esx:showNotification', source, 'Invalid register!')
        return
    end

    -- Check failed attempts
    if FailedAttempts[source] and FailedAttempts[source][registerId] and FailedAttempts[source][registerId] >= 2 then
        TriggerClientEvent('esx:showNotification', source, 'You\'ve failed too many times on this register!')
        return
    end

    -- Additional checks
    if not HasRequiredItems(xPlayer) then
        TriggerClientEvent('esx:showNotification', source, 'You need a lockpick to rob this register!')
        return
    end

    if register.robbed then
        TriggerClientEvent('esx:showNotification', source, 'This register has already been robbed!')
        return
    end

    if register.cooldown > os.time() then
        local remaining = math.floor((register.cooldown - os.time()) / 60)
        TriggerClientEvent('esx:showNotification', source, ('This register is on cooldown. Try again in %s minutes'):format(remaining))
        return
    end

    if not IsEnoughPoliceOnline() then
        TriggerClientEvent('esx:showNotification', source, 'Not enough police online!')
        return
    end

    -- Start robbery
    ActiveRobberies[source] = registerId
    AlertPolice(register.coords)
    TriggerClientEvent('minimarket:startRobberyProcess', source, registerId)
end)

RegisterNetEvent('minimarket:finishRobbery')
AddEventHandler('minimarket:finishRobbery', function(registerId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not ActiveRobberies[source] then return end
    
    local register = Registers[registerId]
    if not register then return end

    -- Remove lockpick
    xPlayer.removeInventoryItem(Config.Server.AllowedItems[1], 1)

    -- Give reward
    local reward = math.random(Config.Server.RewardRange[1], Config.Server.RewardRange[2])
    exports.ox_inventory:AddItem(source, 'black_money', reward)
    
    -- Set cooldown
    register.robbed = true
    register.cooldown = os.time() + Config.Server.CooldownTime
    ActiveRobberies[source] = nil
    
    -- Reset failed attempts for this register
    if FailedAttempts[source] then
        FailedAttempts[source][registerId] = 0
    end
    
    TriggerClientEvent('esx:showNotification', source, ('You received $%s from the register!'):format(reward))
    
    -- Reset register after cooldown
    SetTimeout(Config.Server.CooldownTime * 1000, function()
        register.robbed = false
    end)
end)
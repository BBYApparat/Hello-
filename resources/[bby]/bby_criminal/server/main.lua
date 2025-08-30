local ESX = exports['es_extended']:getSharedObject()

-- ================== CAR LOOTING REWARDS ==================

-- Reward player for stealing suitcase
RegisterNetEvent('bby_criminal:rewardPlayer')
AddEventHandler('bby_criminal:rewardPlayer', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Give money reward
    if math.random() < Config.Rewards.money.chance then
        local amount = math.random(Config.Rewards.money.min, Config.Rewards.money.max)
        xPlayer.addMoney(amount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Reward',
            description = ('You found $%s in the suitcase!'):format(amount),
            type = 'success'
        })
    end
    
    -- Give item rewards
    local itemsGiven = {}
    for _, itemData in pairs(Config.Rewards.items) do
        if math.random() < itemData.chance then
            local count = math.random(itemData.min, itemData.max)
            
            -- Check if player can carry the item
            if exports.ox_inventory:CanCarryItem(source, itemData.item, count) then
                exports.ox_inventory:AddItem(source, itemData.item, count)
                table.insert(itemsGiven, {item = itemData.item, count = count})
            end
        end
    end
    
    -- Notify player of items received
    if #itemsGiven > 0 then
        local itemList = {}
        for _, item in pairs(itemsGiven) do
            table.insert(itemList, ('%sx %s'):format(item.count, item.item))
        end
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Items Found',
            description = 'You found: ' .. table.concat(itemList, ', '),
            type = 'info'
        })
    end
    
    -- Log the theft
    print(('[bby_criminal:car] Player %s (ID: %s) stole a suitcase'):format(xPlayer.getName(), source))
end)

-- Alert police dispatch
RegisterNetEvent('bby_criminal:alertPolice')
AddEventHandler('bby_criminal:alertPolice', function(coords)
    local source = source
    
    if Config.AlertDispatch == 'ps-dispatch' then
        -- ps-dispatch integration
        TriggerEvent('ps-dispatch:server:notify', {
            dispatchCode = '10-60',
            firstStreet = '',
            gender = 'Unknown',
            model = nil,
            plate = nil,
            priority = 2,
            firstColor = nil,
            automaticGunfire = false,
            origin = coords,
            dispatchMessage = 'Vehicle Break-In',
            job = {'police', 'sheriff', 'trooper'}
        })
    elseif Config.AlertDispatch == 'cd_dispatch' then
        -- cd_dispatch integration
        local data = {
            id = '10-60',
            code = '10-60',
            title = 'Vehicle Break-In',
            message = 'Someone is breaking into a vehicle',
            coords = coords,
            blip = {
                sprite = 229,
                scale = 1.0,
                colour = 1,
                flashes = false,
                text = '10-60 - Vehicle Break-In',
                time = (5 * 60 * 1000),
            },
            jobs = {'police', 'sheriff'}
        }
        TriggerEvent('cd_dispatch:AddNotification', data)
    elseif Config.AlertDispatch == 'custom' then
        -- Custom dispatch - you can add your own dispatch system here
        -- Example for ESX police notification
        local xPlayers = ESX.GetExtendedPlayers('job', 'police')
        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                title = 'Dispatch',
                description = 'Vehicle break-in reported nearby',
                type = 'error',
                position = 'top'
            })
        end
    end
end)

-- Admin command to give crowbar (for testing)
ESX.RegisterCommand('givecrowbar', 'admin', function(xPlayer, args, showError)
    exports.ox_inventory:AddItem(xPlayer.source, 'crowbar', 1)
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {
        title = 'Admin',
        description = 'You received a crowbar',
        type = 'success'
    })
end, false, {help = 'Give yourself a crowbar'})

-- ================== POSTBOX LOOTING REWARDS ==================

-- Reward player for single envelope (new system)
RegisterNetEvent('bby_criminal:rewardPostboxSingle')
AddEventHandler('bby_criminal:rewardPostboxSingle', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Give single envelope
    if exports.ox_inventory:CanCarryItem(source, 'envelope', 1) then
        exports.ox_inventory:AddItem(source, 'envelope', 1)
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Found!',
            description = 'You found an envelope!',
            type = 'success'
        })
        
        -- Log the theft
        print(('[bby_criminal:postbox] Player %s (ID: %s) got 1 envelope from postbox'):format(xPlayer.getName(), source))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Your pockets are full!',
            type = 'error'
        })
    end
end)

-- Legacy reward function (kept for compatibility but not used)
RegisterNetEvent('bby_criminal:rewardPostbox')
AddEventHandler('bby_criminal:rewardPostbox', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Give envelope rewards (old system - 2-3 at once)
    local envelopeCount = math.random(Config.PostboxRewards.envelope.min, Config.PostboxRewards.envelope.max)
    
    if exports.ox_inventory:CanCarryItem(source, 'envelope', envelopeCount) then
        exports.ox_inventory:AddItem(source, 'envelope', envelopeCount)
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Success',
            description = ('You found %d envelopes!'):format(envelopeCount),
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Your pockets are full!',
            type = 'error'
        })
        return
    end
    
    -- Give extra items
    local extraItems = {}
    for _, itemData in pairs(Config.PostboxRewards.extraItems) do
        if math.random() < itemData.chance then
            local count = math.random(itemData.min, itemData.max)
            
            if exports.ox_inventory:CanCarryItem(source, itemData.item, count) then
                exports.ox_inventory:AddItem(source, itemData.item, count)
                table.insert(extraItems, {item = itemData.item, count = count})
            end
        end
    end
    
    -- Notify about extra items
    if #extraItems > 0 then
        local itemList = {}
        for _, item in pairs(extraItems) do
            table.insert(itemList, ('%sx %s'):format(item.count, item.item))
        end
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Bonus!',
            description = 'Also found: ' .. table.concat(itemList, ', '),
            type = 'info'
        })
    end
    
    -- Log the theft
    print(('[bby_criminal:postbox] Player %s (ID: %s) looted a postbox'):format(xPlayer.getName(), source))
end)

-- Alert police for postbox theft
RegisterNetEvent('bby_criminal:alertPolicePostbox')
AddEventHandler('bby_criminal:alertPolicePostbox', function(coords)
    local source = source
    
    if Config.AlertDispatch == 'ps-dispatch' then
        TriggerEvent('ps-dispatch:server:notify', {
            dispatchCode = '10-90',
            firstStreet = '',
            gender = 'Unknown',
            model = nil,
            plate = nil,
            priority = 2,
            firstColor = nil,
            automaticGunfire = false,
            origin = coords,
            dispatchMessage = 'Postbox Tampering',
            job = {'police', 'sheriff', 'trooper'}
        })
    elseif Config.AlertDispatch == 'custom' then
        local xPlayers = ESX.GetExtendedPlayers('job', 'police')
        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                title = 'Dispatch',
                description = 'Postbox tampering reported',
                type = 'error',
                position = 'top'
            })
        end
    end
end)

-- ================== ADMIN COMMANDS ==================

-- Admin command to give crowbar (for testing)
ESX.RegisterCommand('givecrowbar', 'admin', function(xPlayer, args, showError)
    exports.ox_inventory:AddItem(xPlayer.source, 'crowbar', 1)
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {
        title = 'Admin',
        description = 'You received a crowbar',
        type = 'success'
    })
end, false, {help = 'Give yourself a crowbar'})

-- Admin command to give lockpick (for testing)
ESX.RegisterCommand('givelockpick', 'admin', function(xPlayer, args, showError)
    exports.ox_inventory:AddItem(xPlayer.source, 'lockpick', 1)
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {
        title = 'Admin',
        description = 'You received a lockpick',
        type = 'success'
    })
end, false, {help = 'Give yourself a lockpick'})

-- Version check
CreateThread(function()
    print('^2[bby_criminal]^7 Resource loaded successfully')
    print('^2[bby_criminal]^7 Version: 2.0.0')
    print('^2[bby_criminal]^7 Features: Car Looting, Postbox Theft')
end)
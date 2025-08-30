local ESX = exports['es_extended']:getSharedObject()

-- Reward player for stealing suitcase
RegisterNetEvent('bby_carsuitcase:rewardPlayer')
AddEventHandler('bby_carsuitcase:rewardPlayer', function()
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
    print(('[bby_carsuitcase] Player %s (ID: %s) stole a suitcase'):format(xPlayer.getName(), source))
end)

-- Alert police dispatch
RegisterNetEvent('bby_carsuitcase:alertPolice')
AddEventHandler('bby_carsuitcase:alertPolice', function(coords)
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

-- Version check
CreateThread(function()
    print('^2[bby_carsuitcase]^7 Resource loaded successfully')
    print('^2[bby_carsuitcase]^7 Version: 1.0.0')
end)
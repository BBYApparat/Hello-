-----------------For support, scripts, and more----------------
---------------  /wasabiscripts  -------------
---------------------------------------------------------------
---ESX = exports["es_extended"]:getSharedObject()

ESX = exports["es_extended"]:getSharedObject()

lib.callback.register('wasabi_mining:checkPick', function(source, itemname)
    local item = HasItem(source, itemname)
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_mining:getRockData', function(source)
    local data = Config.rocks[math.random(#Config.rocks)]
    return data
end)

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

RegisterServerEvent("wasabi_mining:mineRock", function(data, index)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Define the items and their associated probabilities
    local items = {
        {name = "copper", chance = 15},
        {name = "silver", chance = 15},
        {name = "steel", chance = 15},
        {name = "aluminium", chance = 10},
        {name = "scrap", chance = 10},
        {name = "rubber", chance = 10},
        {name = "glass", chance = 10},
        {name = "plastic", chance = 10},
        {name = "gold", chance = 5},     
        {name = "emerald", chance = 2}, 
        {name = "diamond", chance = 3}  
    }
    
    local randomNumber = math.random(100) -- Generate a random number between 1 and 100
    local cumulativeChance = 0
    local minedItem = nil

    for _, item in ipairs(items) do
        cumulativeChance = cumulativeChance + item.chance
        if randomNumber <= cumulativeChance then
            minedItem = item.name
            break
        end
    end

    if minedItem then
        xPlayer.addInventoryItem(minedItem, 1)
        TriggerClientEvent('esx:showNotification', source, 'You successfully mined ' .. minedItem .. '!', 'success')
    else
        TriggerClientEvent('esx:showNotification', source, 'You found nothing of value.', 'error')
    end
end)

RegisterServerEvent('wasabi_mining:sellRock', function()
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.sellShop.coords)
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 3 then
        KickPlayer(source, Strings.kicked)
        return
    end
    for i=1, #Config.rocks do
        if HasItem(source, Config.rocks[i].item) >= 1 then
            local rewardAmount = 0
            for j=1, HasItem(source, Config.rocks[i].item) do
                rewardAmount = rewardAmount + math.random(Config.rocks[i].price[1], Config.rocks[i].price[2])
            end
            if rewardAmount > 0 then
                RemoveItem(source, Config.rocks[i].item, HasItem(source, Config.rocks[i].item))
                AddMoney(source, 'money', rewardAmount)
                TriggerClientEvent('wasabi_mining:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, Config.rocks[i].item), Config.rocks[i].label, addCommas(rewardAmount)), 'success')
            end
        end
    end
end)
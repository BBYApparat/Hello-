local ESX, Hooks = exports.es_extended:getSharedObject(), {}

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for i=1, #Hooks do
        exports.ox_inventory:removeHooks(Hooks[i])
    end
end)

CreateThread(function()
    for shop, data in pairs(Config.Locations) do
        local inventory = {}
        
        if Config.Products[data.products] then
            for slot, item in ipairs(Config.Products[data.products]) do
                if item.currency and shop:find("seller_") then
                    local MyItem = exports.ox_inventory:Items(item.currency)

                    inventory[slot] = {
                        name = item.name,
                        count = item.amount,
                        price = item.price,
                        currency = item.currency,
                        jobs = item.requiredJob,
                        metadata = { image = item.currency, label = MyItem.label, description = "Trade a " .. MyItem.label .. " for x" .. item.amount .. " Cash" },
                        license = item.license ~= nil and item.license or false
                    }
                else
                    inventory[slot] = {
                        name = item.name,
                        count = item.amount,
                        price = item.price,
                        currency = item.currency,
                        jobs = item.requiredJob,
                        metadata = {},
                        license = item.license ~= nil and item.license or false
                    }
                end
            end
        
            exports.ox_inventory:RegisterShop(shop, {
                name = data.label,
                blip = {id = 110, colour = 84, scale = 0.8},
                inventory = inventory,
                locations = {vec3(data.coords.x, data.coords.y, data.coords.z)},
            })
        end
    end

    Hooks[1] = exports.ox_inventory:registerHook('buyItem', function(shopData)
        if shopData.shopType:find("seller_") then
            local _source = shopData.toInventory
            local xPlayer = ESX.GetPlayerFromId(_source)
            local AmountToGive = (shopData.fromSlot.count*shopData.count)
            local ItemToAdd = shopData.fromSlot.name
            local ItemToRemove = shopData.fromSlot.currency
            
            if xPlayer.canCarryItem(ItemToAdd, AmountToGive) then
                exports.ox_inventory:AddItem(_source, ItemToAdd, AmountToGive)
                exports.ox_inventory:RemoveItem(_source, ItemToRemove, shopData.count)
                TriggerClientEvent("ox_inventory:closeInventory", _source)
            end
            
            return false
        end
    end, {})
end)

--Events
-- QBCore.Functions.CreateCallback('n_shops:server:SetShopInv', function(_,cb)
--     local shopInvJson = LoadResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile)
--     cb(shopInvJson)
-- end)

-- RegisterNetEvent('n_shops:server:SaveShopInv',function()
--     if not Config.UseTruckerJob then return end
--     local shopinv = {}
--     for k, v in pairs(Config.Locations) do
--         shopinv[k] = {}
--         shopinv[k].products = {}
--         for kk, vv in pairs(v.products) do
--             shopinv[k].products[kk] = {}
--             shopinv[k].products[kk].amount = vv['amount']
--         end
--     end
--     SaveResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile, json.encode(shopinv))
-- end)

-- RegisterNetEvent('n_shops:server:UpdateShopItems', function(shop, itemData, amount)
--     if not Config.UseTruckerJob then return end
--     if not shop or not itemData or not amount then return end
--     Config.Locations[shop].products[itemData.slot].amount -= amount
--     if Config.Locations[shop].products[itemData.slot].amount < 0 then
--         Config.Locations[shop].products[itemData.slot].amount = 0
--     end
--     TriggerEvent('n_shops:server:SaveShopInv')
--     TriggerClientEvent('n_shops:client:SetShopItems', -1, shop, Config.Locations[shop].products)
-- end)

RegisterNetEvent('n_shops:server:RestockShopItems', function(shop)
    -- return
    -- if not shop or not Config.Locations[shop].products then return end
    -- local randAmount = math.random(10, 50)
    -- local items = exports.ox_inventory:GetInventoryItems(shop, false)
    -- print(shop)
    -- print(exports.nyam_snippets:DumpTable(items))

    -- for index, data in pairs(items) do
    --     items[index].count += randAmount
    -- end

    -- exports.ox_inventory:RegisterShop(shop, {
	-- 	name = Config.Locations[shop].label,
	-- 	inventory = items,
	-- 	locations = {
	-- 		locations = {vec3(Config.Locations[shop].coords.x, Config.Locations[shop].coords.y, Config.Locations[shop].coords.z)},
	-- 	}
	-- })
    -- TriggerEvent('n_shops:server:SaveShopInv')
    -- TriggerClientEvent('n_shops:client:RestockShopItems', -1, shop, randAmount)
end)

local ItemList = {["casinochips"] = 1}

RegisterNetEvent('n_shops:server:sellChips', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem then
        for k in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] then
                if ItemList[Player.PlayerData.items[k].name] then
                    local price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    Player.Functions.AddMoney("cash", price, "sold-casino-chips")
                    -- QBCore.Functions.Notify(src, "You sold your chips for $" .. price)
                    -- TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "blue", "**" .. GetPlayerName(src) .. "** got $" .. price .. " for selling the Chips")
                end
            end
        end
    else
        -- QBCore.Functions.Notify(src, "You have no chips..")
    end
end)

RegisterNetEvent('n_shops:server:SetShopList',function()
    local shoplist = {}
    local cnt = 0
    for k, v in pairs(Config.Locations) do
        cnt = cnt + 1
        shoplist[cnt] = {}
        shoplist[cnt].name = k
        shoplist[cnt].type = v.type
        shoplist[cnt].coords = v.delivery
    end
    -- TriggerClientEvent('qb-truckerjob:client:SetShopList',-1,shoplist)
end)

RegisterCommand('restockshops', function(source, args)
    TriggerEvent('n_shops:server:RestockShopItems', args[1])
end)
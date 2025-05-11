local AllShops = {}

CreateThread(function()
    if not Config.UseEyeTarget then return end
    local VendingSettings = Config.VendingMachine
    if not VendingSettings.enabled then return end
    exports[Config.TargetResource]:AddTargetModel(VendingSettings.objects,{
        distance = VendingSettings.distance,
        options = {
            {
                event = "inventory:openVendingMachine",
                icon = VendingSettings.settings.icon,
                label = VendingSettings.settings.label
            }
        }
    })
end)

RegisterNetEvent('inventory:openVendingMachine', function()
    local ShopItems = {}
    ShopItems.label = Config.VendingMachine.inventoryName
    ShopItems.items = Config.VendingMachine.items
    ShopItems.slots = #Config.VendingMachine.items
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
end)

local function SetupItems(shop)
    local products = Config.Locations[shop].products
    local playerJob = PlayerData.job.name
    local items = {}
    for i = 1, #products do
        if ESX.Shared.Items[products[i].name] then
            if not products[i].requiredJob then
                items[#items + 1] = products[i]
            else
                for i2 = 1, #products[i].requiredJob do
                    if playerJob == products[i].requiredJob[i2] then
                        items[#items + 1] = products[i]
                    end
                end
            end
        end
    end
    return items
end

local function SetupShop(data)
    local products = data
    local playerJob = PlayerData.job.name
    local items = {}
    for i = 1, #products do
        if ESX.Shared.Items[products[i].name] then
            if not products[i].requiredJob then
                items[#items + 1] = products[i]
            else
                for i2 = 1, #products[i].requiredJob do
                    if playerJob == products[i].requiredJob[i2] then
                        items[#items + 1] = products[i]
                    end
                end
            end
        end
    end
    return items
end

exports('SetupShop', SetupShop)

local function openShop(shop, data)
    local products = data.products
    local ShopItems = {
        items = SetupItems(shop),
        label = data.label,
        slots = #products
    }
    for k in pairs(ShopItems.items) do
        ShopItems.items[k].slot = k
    end
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_" .. shop, ShopItems)
end

exports('openShop', openShop)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    createBlips()
    Wait(2000)
    createPeds()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createBlips()
        Wait(2000)
        createPeds()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deletePeds()
    end
end)
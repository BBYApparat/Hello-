-- server.lua
-- Server-side script for spray vendor with ESX integration and gang check

-- ESX initialization
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Item configuration
local Config = {
    Items = {
        spraycan = {
            label = "Spray Can",
            basePrice = 500,
            currentPrice = 500,
            purchaseCount = 0,
            maxPurchases = 2
        },
        sprayremover = {
            label = "Spray Remover",
            basePrice = 500,
            currentPrice = 500,
            purchaseCount = 0,
            maxPurchases = 2
        }
    }
}

-- Function to reset prices and purchase counts
function ResetVendor()
    for itemName, itemData in pairs(Config.Items) do
        itemData.currentPrice = itemData.basePrice
        itemData.purchaseCount = 0
    end
    print("Vendor prices and purchase counts have been reset.")
end

-- Function to process item purchase
function ProcessPurchase(source, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = Config.Items[itemName]
    
    if not item then
        return false, "Item does not exist.", "error"
    end
    
    if item.purchaseCount >= item.maxPurchases then
        return false, "Maximum purchase limit reached for this item until server restart.", "error"
    end
    
    -- Check if player has enough money
    if xPlayer.getMoney() < item.currentPrice then
        return false, "Not enough money. The " .. item.label .. " costs $" .. item.currentPrice, "error"
    end
    
    -- Process the purchase using ESX functions
    xPlayer.removeMoney(item.currentPrice)
    xPlayer.addInventoryItem(itemName, 1)
    
    -- Update purchase count and double the price
    item.purchaseCount = item.purchaseCount + 1
    local oldPrice = item.currentPrice
    item.currentPrice = item.currentPrice * 2
    
    return true, "You purchased a " .. item.label .. " for $" .. oldPrice .. ". The price is now $" .. item.currentPrice, "success"
end

-- Event to check player's gang
RegisterNetEvent("sprayVendor:checkGang")
AddEventHandler("sprayVendor:checkGang", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Get player data from MySQL to check gang column
    MySQL.Async.fetchScalar('SELECT gang FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(gang)
        if gang == nil then
            -- No gang affiliation, reject with notification
            TriggerClientEvent("sprayVendor:notify", source, "Do I know you?", "error")
        else
            -- Gang check passed, send item data to client
            TriggerClientEvent("sprayVendor:showMenu", source, Config.Items)
        end
    end)
end)

-- Event to handle purchase requests
RegisterNetEvent("sprayVendor:purchaseItem")
AddEventHandler("sprayVendor:purchaseItem", function(itemName)
    local source = source
    local success, message, notificationType = ProcessPurchase(source, itemName)
    
    -- Notify player of result
    TriggerClientEvent("sprayVendor:notify", source, message, notificationType)
    
    -- If purchase was successful, refresh the menu
    if success then
        TriggerClientEvent("sprayVendor:showMenu", source, Config.Items)
    end
end)

-- Admin command to reset vendor
RegisterCommand("resetsprayvendor", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Check if player is admin
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        ResetVendor()
        TriggerClientEvent("sprayVendor:notify", source, "Spray vendor has been reset.", "success")
    else
        TriggerClientEvent("sprayVendor:notify", source, "You don't have permission to use this command.", "error")
    end
end, false)

-- Event handler for resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Wait for ESX to be ready
    while ESX == nil do
        Citizen.Wait(10)
    end
    
    ResetVendor()
    print("Spray Vendor server script started.")
end)
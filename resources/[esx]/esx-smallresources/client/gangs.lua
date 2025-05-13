-- client.lua
-- Lightweight ESX client script for spray vendor NPC with ox_target integration

-- ESX initialization - using exports for newer ESX versions
local ESX = exports['es_extended']:getSharedObject()

-- Configuration - using local to avoid conflicts with other resources
local Config = {
    NPC = {
        model = "s_m_m_autoshop_01",
        coords = vector3(180.41, -1700.44, 29.29),
        heading = 212.0
    },
    BlipSettings = {
        sprite = 527,
        color = 2,
        scale = 0.8,
        name = "Spray Shop"
    }
}

-- Local variables
local vendorPed = nil
local cooldown = false

-- Purchase item function - Making this global so it can be accessed from the menu
function PurchaseItem(itemName)
    if cooldown then return end
    cooldown = true
    
    TriggerServerEvent("sprayVendor:purchaseItem", itemName)
    
    -- Reset cooldown after short delay
    SetTimeout(500, function()
        cooldown = false
    end)
end

-- Function to create menu options
function CreateMenuOptions(items)
    local options = {}
    
    for itemName, itemData in pairs(items) do
        local purchasesLeft = itemData.maxPurchases - itemData.purchaseCount
        local purchaseStatus = purchasesLeft > 0 and purchasesLeft .. " left" or "SOLD OUT"
        
        table.insert(options, {
            title = itemData.label .. " - $" .. itemData.currentPrice,
            description = "Available: " .. purchaseStatus,
            disabled = purchasesLeft <= 0,
            onSelect = function()
                PurchaseItem(itemName)
            end
        })
    end
    
    return options
end

-- Function to open vendor menu - CRITICAL: Making this global for ox_target to access
function OpenVendorMenu()
    if cooldown then return end
    cooldown = true
    
    -- Check if player belongs to a gang
    TriggerServerEvent("sprayVendor:checkGang")
    
    -- Reset cooldown after short delay
    SetTimeout(500, function()
        cooldown = false
    end)
end

-- Function to spawn the vendor NPC
local function SpawnVendorNPC()
    -- Check if NPC already exists
    if DoesEntityExist(vendorPed) then
        DeleteEntity(vendorPed)
    end
    
    -- Request the model
    local model = GetHashKey(Config.NPC.model)
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then
        print("Failed to load vendor model")
        return nil
    end
    
    -- Create the NPC
    vendorPed = CreatePed(4, model, Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z, Config.NPC.heading, false, true)
    
    -- Set NPC properties
    FreezeEntityPosition(vendorPed, true)
    SetEntityInvincible(vendorPed, true)
    SetBlockingOfNonTemporaryEvents(vendorPed, true)
    
    -- Add blip for the vendor location
    local blip = AddBlipForCoord(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z)
    SetBlipSprite(blip, Config.BlipSettings.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.BlipSettings.scale)
    SetBlipColour(blip, Config.BlipSettings.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipSettings.name)
    EndTextCommandSetBlipName(blip)
    
    -- Set up ox_target
    exports.ox_target:addLocalEntity(vendorPed, {
        {
            name = 'spray_vendor',
            icon = 'fas fa-spray-can',
            label = 'Talk to Spray Vendor',
            distance = 2.0,
            onSelect = function()
                OpenVendorMenu()
            end
        }
    })
    
    return vendorPed
end

-- Event to receive item data from server after gang check passed
RegisterNetEvent("sprayVendor:showMenu")
AddEventHandler("sprayVendor:showMenu", function(items)
    -- FIXED: First register the context menu before showing it
    lib.registerContext({
        id = 'spray_vendor_menu',
        title = 'Spray Shop',
        options = CreateMenuOptions(items)
    })
    
    -- Then show the context menu
    lib.showContext('spray_vendor_menu')
end)

-- Event for notifications
RegisterNetEvent("sprayVendor:notify")
AddEventHandler("sprayVendor:notify", function(message, type)
    -- Using ox_lib notification
    lib.notify({
        title = 'Spray Shop',
        description = message,
        type = type or 'inform'
    })
end)

-- Initialize the resource
CreateThread(function()
    -- Wait for game to load
    Wait(1000)
    
    -- Spawn the vendor
    vendorPed = SpawnVendorNPC()
    print("Spray Vendor NPC spawned with ox_target integration")
end)
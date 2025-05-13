-- client.lua
-- Lightweight ESX client script for spray vendor NPC

-- ESX initialization
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Configuration
local Config = {
    NPC = {
        model = "s_m_m_autoshop_01",
        coords = vector3(180.41, -1700.44, 29.29),
        heading = 212.0
    },
    InteractionDistance = 2.0,
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

-- Function to spawn the vendor NPC
function SpawnVendorNPC()
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
    
    return vendorPed
end

-- Function to open vendor menu
function OpenVendorMenu()
    if cooldown then return end
    cooldown = true
    
    -- Check if player belongs to a gang
    TriggerServerEvent("sprayVendor:checkGang")
    
    -- Reset cooldown after short delay
    Citizen.SetTimeout(500, function()
        cooldown = false
    end)
end

-- Purchase item function
function PurchaseItem(itemName)
    if cooldown then return end
    cooldown = true
    
    TriggerServerEvent("sprayVendor:purchaseItem", itemName)
    
    -- Reset cooldown after short delay
    Citizen.SetTimeout(500, function()
        cooldown = false
    end)
end

-- Event to receive item data from server after gang check passed
RegisterNetEvent("sprayVendor:showMenu")
AddEventHandler("sprayVendor:showMenu", function(items)
    -- Using ox_lib menu
    lib.showContext({
        id = 'spray_vendor_menu',
        title = 'Spray Shop',
        options = CreateMenuOptions(items)
    })
end)

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

-- Main thread for proximity check - ONE THREAD ONLY
Citizen.CreateThread(function()
    -- Wait for game to load
    Citizen.Wait(1000)
    
    -- Wait for ESX to be ready
    while ESX == nil do
        Citizen.Wait(10)
    end
    
    -- Spawn the vendor
    vendorPed = SpawnVendorNPC()
    
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vendorCoords = GetEntityCoords(vendorPed)
        local distance = #(playerCoords - vendorCoords)
        
        -- Optimize by using dynamic wait times based on distance
        if distance < Config.InteractionDistance then
            -- Only show key indicator, no 3D text
            if IsControlJustReleased(0, 38) then -- E key
                OpenVendorMenu()
            end
            
            Citizen.Wait(0) -- Check every frame when close
        elseif distance < 15.0 then
            Citizen.Wait(500) -- Check every half second when somewhat close
        else
            Citizen.Wait(1500) -- Check less frequently when far away
        end
    end
end)
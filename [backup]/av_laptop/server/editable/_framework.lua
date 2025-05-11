Core = nil

CreateThread(function()
    while not Config.Framework and not Config.Inventory do Wait(1) end
   -- print("^2Framework: ^7"..Config.Framework, "^2Inventory: ^7"..Config.Inventory)
    Core = getCore()
    if Config.Inventory == "origen_inventory" and Core == "qb" then
        Core.Functions.CreateUseableItem(Config.LaptopItem, laptop)
    else
        exports['av_laptop']:registerItem(Config.LaptopItem, laptop)
    end
    ready = true -- Framework is loaded and laptop is now ready :)
end)

-- Triggered when u use item laptop
function laptop(source,item,info)
    local src = source
    local identifier = getIdentifier(src)
    local metadata, slot = getMetadata(item, info)
    if Config.Debug then
        print("^3[DEBUG]:^7 ".."open laptop", json.encode(metadata))
    end
    if metadata and not metadata['serial'] then
        local info = {}
        local serial = lib.string.random('..............')
        info['serial'] = serial
        if Config.Debug then
            print("^3[DEBUG]:^7 ".."durability: ", metadata['durability'])
        end
        info['durability'] = metadata['durability'] or 100
        info['password'] = false
        if info['durability'] > 100 then
            if Config.Debug then
                print("^3[DEBUG]:^7 ".."more than 100")
            end
            info['durability'] = 100
        end
        if Config.Debug then
            print("^3[DEBUG]:^7 "..info['durability'])
        end
        allDevices[serial] = os.time()
        setItemMetadata(src, Config.LaptopItem, slot, info)
        TriggerClientEvent("av_laptop:openUI", src, info, slot, true)
    else
        if metadata and metadata.durability then
            if Config.Debug then
                print("^3[DEBUG]:^7 "..metadata['durability'])
            end
            local res = math.random(1, 3)
            local newDurability = (metadata.durability - res)
            if newDurability <= 0 then
                newDurability = 0
            end
            if res == 1 and Config.UseBattery then
                metadata.durability = newDurability
                setItemMetadata(src, Config.LaptopItem, slot, metadata)
            end
        end
        if metadata['serial'] == identifier then
            metadata['serial'] = lib.string.random('..............')
            setItemMetadata(src, Config.LaptopItem, slot, metadata)
        end
        allDevices[metadata['serial']] = os.time()
        TriggerClientEvent("av_laptop:openUI", src, metadata, slot, true)
    end
end

-- Event handlers to get when a player is fully loaded into server
RegisterServerEvent("av_laptop:loaded")
AddEventHandler("QBCore:Server:PlayerLoaded", function(Player)
    TriggerEvent("av_laptop:loaded", Player.PlayerData.source)
end)

AddEventHandler("esx:onPlayerJoined", function(Player)
    local src = Player
    if not src then src = source end
    TriggerEvent("av_laptop:loaded", src)
end)

-- Add Player Metadata
local metadataFields = {
    ['hunger'] = true,
    ['thirst'] = true
}
RegisterServerEvent("av_laptop:addMetadata", function(field, amount) -- used to add thirst/hunger, ESX uses client events for esx_status
    if not metadataFields[field] then return end
    local src = source
    if Config.Framework == "qb" then
        local Player = getPlayer(src)
        if Player then
            local value = Player.Functions.GetMetaData(field)
            value += amount
            Player.Functions.SetMetaData(field, value)
            if field == "hunger" then
                TriggerClientEvent('hud:client:UpdateNeeds', src, value, Player.PlayerData.metadata.thirst)
            else
                TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger, value)
            end
        end
    end
end)

RegisterServerEvent("av_laptop:openStash", function(name,data) -- used for new qb-inventory stash system
    local src = source
    exports[Config.Inventory]:OpenInventory(src, name, data)
end)
ESX = exports["es_extended"]:getSharedObject()

-- Initialize the Stashes table
local Stashes = {}
local UniqueMotels = {}
local UniqueMotelsIdentifiers = {}

local motelRoom = {x = 152.2605, y = -1004.471, z = -98.99999, heading = 0.0} -- Coordinates for the shared motel room

CreateThread(function()
    MySQL.query("SELECT * FROM bby_motels", {}, function(motels)
        for k, motel in pairs(motels) do
            UniqueMotels[motel.roomId] = motel.identifier
            UniqueMotelsIdentifiers[motel.identifier] = motel.roomId
            exports.ox_inventory:RegisterStash(motel.roomId, "Motel Room - " .. motel.roomId, 15, 50000)
        end
    end)
end)

-- Function to assign a motel room
local function assignMotelRoom(playerId)
    Wait(2500)
    
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        if not UniqueMotelsIdentifiers[xPlayer.identifier] then
            local randomRoomId = string.upper(ESX.GetRandomString(3) .. math.random(100, 999) .. ESX.GetRandomString(4))
            
            while true do
                if UniqueMotels[randomRoomId] then
                    randomRoomId = string.upper(ESX.GetRandomString(3) .. math.random(100, 999) .. ESX.GetRandomString(4))
                else
                    UniqueMotels[randomRoomId] = xPlayer.identifier
                    UniqueMotelsIdentifiers[xPlayer.identifier] = randomRoomId
                    break
                end
                Wait(0)
            end
            MySQL.insert.await('INSERT INTO `bby_motels` (roomId, identifier) VALUES (?, ?)', {randomRoomId, xPlayer.identifier})
        end
    end
end

AddEventHandler('esx:playerLoaded', function(playerId)
    assignMotelRoom(playerId)
end)

RegisterNetEvent('motel:enterRoom', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    -- Move the player to a unique instance
    SetPlayerRoutingBucket(playerId, playerId+math.random(100, 999))
    -- TriggerClientEvent('motel:enterRoom', playerId, motelRoom, instanceId, UniqueMotelsIdentifiers[xPlayer.identifier]) -- Τι αλλαγη εγινε εδω και γιατι;
    TriggerClientEvent('motel:enterRoom', playerId, UniqueMotelsIdentifiers[xPlayer.identifier]) 
end)

RegisterNetEvent('motel:leaveRoom')
AddEventHandler('motel:leaveRoom', function()
    local source = source
    -- Move the player back to the main instance
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('motel:leaveRoom', source)
end)

-- RegisterNetEvent('motel:openWardrobe')
-- AddEventHandler('motel:openWardrobe', function()
--     local playerId = source
--     local xPlayer = ESX.GetPlayerFromId(playerId)
--     local stashId = "motel_" .. xPlayer.identifier

--     -- Register the stash for the player's wardrobe
--     print("Registering stash with ID: " .. stashId)

--     exports.ox_inventory:RegisterStash(stashId, "Motel Wardrobe", 15, 100000, xPlayer.identifier)

--     -- Open the inventory for the player
--     exports.ox_inventory:openInventory('stash', stashId)
-- end)

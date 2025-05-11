local Config = require 'config.server'
local Shared = require 'config.shared'

-- Initialize ESX
ESX = nil
ESX = exports["es_extended"]:getSharedObject()
if not ESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

-- Add a wait to ensure ESX is fully loaded
CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    print("ESX initialized in mad-territories")
end)

local graffitis = {}

CreateThread(function()
    fetchGraffitiData() -- Fetch graffiti data
end)

function fetchGraffitiData()
    local result = MySQL.query.await('SELECT * FROM `graffitis`')
    local all_rows = {}
    for _, row in ipairs(result) do
      all_rows[row.key] = {
        key = row.key,
        gang = row.gang,
        model = row.model,
        coords = json.decode(row.coords),
        rotation = json.decode(row.rotation),
      }
    end
    graffitis = all_rows
end

function getGangReputation(gang)
    local result = MySQL.query.await('SELECT rep FROM `gangs_reputation` WHERE `gang` = ?', {gang})
    if not result or #result == 0 then
        return 0
    end
    return result[1].rep
end

function updateGangReputation(gang, dtype, amount)
    amount = amount or 1 -- Default to 1 if no amount specified
    
    local result = MySQL.query.await('SELECT rep FROM `gangs_reputation` WHERE `gang` = ?', {gang})
    if not result or #result == 0 then return end
    
    local newRep = 0
    if dtype == "add" then
        newRep = result[1].rep + (amount * Config.addReputation)
        if newRep > 1000 then
            newRep = 1000
        end
        print("Gang " .. gang .. " rep increased by " .. (amount * Config.addReputation) .. " to " .. newRep)
        MySQL.update.await('UPDATE gangs_reputation SET rep = ? WHERE gang = ?', {
            newRep, gang
        })
    elseif dtype == "remove" then
        newRep = result[1].rep - (amount * Config.removeReputation)
        if newRep < 0 then
            newRep = 0    
        end
        print("Gang " .. gang .. " rep decreased by " .. (amount * Config.removeReputation) .. " to " .. newRep)
        MySQL.update.await('UPDATE gangs_reputation SET rep = ? WHERE gang = ?', {
            newRep, gang
        })
    end
    
    return newRep
end

function UpdateClientGraffitiData()
    TriggerClientEvent("mad-territories:client:updateClientGraffitiData", -1, graffitis)
end

-- Count police officers
lib.callback.register('mad-territories:server:getPoliceCount', function(source)
    local amount = 0
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.job.name == "police" and xPlayer.job.duty then
            amount = amount + 1
        end
    end
    return amount
end)

lib.callback.register('mad-territories:server:fetchGraffitisData', function(source)
    return graffitis
end)

lib.callback.register('mad-territories:server:getGangReputation', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
      --  print("Error: xPlayer is nil for source: " .. tostring(src))
        return 0 -- Default value
    end
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    local gang = result[1].gang or "none"
    
    return getGangReputation(gang)
end)

lib.callback.register('mad-territories:server:getPlayerGang', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return "none" -- Default value
    end
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    return result[1].gang or "none"
end)

lib.callback.register('mad-territories:server:removeSprayCan', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return false
    end
    
    xPlayer.removeInventoryItem("spraycan", 1)
    return true
end)

lib.callback.register('mad-territories:server:removeSprayCleaner', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return false
    end
    
    xPlayer.removeInventoryItem("sprayremover", 1)
    return true
end)

RegisterServerEvent('mad-territories:server:addServerGraffiti', function(model, coords, rotation)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return
    end
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    local gang = result[1].gang or "none"
    
    MySQL.insert.await('INSERT INTO `graffitis` (gang, model, coords, rotation) VALUES (?, ?, ?, ?)', {
        gang,
        model,
        json.encode(coords),
        json.encode(rotation),
    })

    fetchGraffitiData()
    UpdateClientGraffitiData()
end)

RegisterServerEvent('mad-territories:server:syncRemovedClientSpray', function(key)
    local src = source
    if not graffitis[key] then
        print("Error: Graffiti with key " .. tostring(key) .. " does not exist")
        return
    end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local graffitiCoords = vector3(graffitis[key].coords.x, graffitis[key].coords.y, graffitis[key].coords.z)
    local distance = #(playerCoords - graffitiCoords)
    
    if distance > 10 then 
        print("Player " .. GetPlayerName(src) .. " tried to remove graffiti from too far away: " .. distance .. " meters")
        return
    end
    
    TriggerClientEvent("mad-territories:client:syncRemovedClientSpray", -1, key)
end)

RegisterServerEvent('mad-territories:server:removeServerGraffiti', function(key)
    local src = source
    if not graffitis[key] then
        print("Error: Graffiti with key " .. tostring(key) .. " does not exist")
        return
    end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local graffitiCoords = vector3(graffitis[key].coords.x, graffitis[key].coords.y, graffitis[key].coords.z)
    local distance = #(playerCoords - graffitiCoords)
    
    if distance > 10 then 
        print("Player " .. GetPlayerName(src) .. " tried to remove graffiti from too far away: " .. distance .. " meters")
        return
    end

    MySQL.query.await('DELETE FROM `graffitis` WHERE `key` = ?', {
        key
    })

    fetchGraffitiData()
    UpdateClientGraffitiData() 
end)

RegisterServerEvent('mad-territories:server:notifyGang', function(key, ntype, coords)
    local xPlayers = ESX.GetExtendedPlayers()
    
    if not graffitis[key] then
        print("Error: Graffiti with key " .. tostring(key) .. " does not exist")
        return
    end
    
    for _, xPlayer in pairs(xPlayers) do
        -- Get player's gang from gang column in users table
        local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
        local gang = result[1].gang or "none"
        
        if gang == graffitis[key].gang then
            if ntype == "graffiti" then
                TriggerClientEvent("mad-territories:client:alertGangMembers", xPlayer.source, key, ntype)
            elseif ntype == "npc" then
                TriggerClientEvent("mad-territories:client:alertGangMembers", xPlayer.source, key, ntype, coords)
            end
        end
    end
end)

--------------------------Useable Items---------------------------

ESX.RegisterUsableItem('spraycan', function(source)
    local src = source
    print("Spraycan used by Player ID:", src)
    
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        -- print("ERROR: xPlayer is nil for source:", src)
        return
    end
    
    print("Player identifier:", xPlayer.identifier)
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    if not result or #result == 0 then
        print("ERROR: No database result for player")
        TriggerClientEvent('esx:showNotification', src, "Database error: Contact admin")
        return
    end
    
    local gang = result[1].gang or "none"
    print("Player gang:", gang)
    
    if gang == "none" then 
        print("Player has no gang, aborting spraycan use")
        TriggerClientEvent('esx:showNotification', src, Shared.lang["nogang"])
        return 
    end
    
    if not Config.gangs[gang] then
        print("ERROR: Gang configuration not found for:", gang)
        TriggerClientEvent('esx:showNotification', src, "Configuration error for your gang")
        return
    end
    
    print("Triggering graffiti placement with model:", Config.gangs[gang].spraymodel)
    TriggerClientEvent('mad-territories:client:placeGraffiti', src, gang, Config.gangs[gang].spraymodel)
end)


ESX.RegisterUsableItem('sprayremover', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return
    end
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    local gang = result[1].gang or "none"
    
    if gang == "none" then 
        TriggerClientEvent('esx:showNotification', src, Shared.lang["nogang"])
        return 
    end
    
    TriggerClientEvent('mad-territories:client:removeClosestGraffiti', src)
end)

----------------------selling stuff-------------------------------------

RegisterNetEvent('mad-territories:server:toggleEntityDoor', function(netId, door)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return end

    local owner = NetworkGetEntityOwner(entity)
    TriggerClientEvent('mad-territories:toggleEntityDoor', owner, netId, door)
end)

RegisterNetEvent('mad-territories:server:sellDrug', function(drug, drugName, drugAmount, zone)
    if zone == nil then return end
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return
    end
    
    local item = xPlayer.getInventoryItem(drugName)
    local multiplier = 0
    local price = 0
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    local gang = result[1].gang or "none"
    
    if gang ~= "none" then
        if graffitis[zone].gang == gang then
            local rep = getGangReputation(gang)
            if rep ~= 0 then
                multiplier = rep / 1000
            end
            local prevPrice = math.random(Shared.drugsPrices[drug].min, Shared.drugsPrices[drug].max)
            price = math.floor(prevPrice + (prevPrice * multiplier), 0.5)
            print("price: "..price)
            print("sold in your territory")
            updateGangReputation(gang, "add")
        else
            price = math.random(Shared.drugsPrices[drug].min, Shared.drugsPrices[drug].max)
            print("price: "..price)
            print("sold outside territory")
            updateGangReputation(graffitis[zone].gang, "remove")
        end
    else
        price = math.random(Shared.drugsPrices[drug].min, Shared.drugsPrices[drug].max)
        print("price: "..price)
        print("sold without gang")
    end
    
    if item.count >= drugAmount then
        xPlayer.removeInventoryItem(drugName, drugAmount)
        xPlayer.addMoney(price * drugAmount)
    else
        print("Player " .. GetPlayerName(src) .. " tried to sell more drugs than they have")
    end
end)

----------------------Rob Npc Stuff-----------------------------

RegisterNetEvent("mad-territories:server:giveNpcMoney", function(zone)
    local src = source
    if zone == nil then 
        print("Player " .. GetPlayerName(src) .. " tried to rob NPC without being in a territory")
        return 
    end
    
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    
    -- We can't directly use lib.getClosestPed on the server, so we'll trust the client's zone parameter
    -- but implement some basic anti-cheat measures
    
    -- Check if player is in the zone they claim to be in
    local zoneFound = false
    for k, v in pairs(graffitis) do
        if tostring(k) == tostring(zone) then
            local graffitiCoords = vector3(v.coords.x, v.coords.y, v.coords.z)
            local distance = #(coords - graffitiCoords)
            if distance <= Config.graffitiRadius then
                zoneFound = true
                break
            end
        end
    end
    
    if not zoneFound then
        print("Player " .. GetPlayerName(src) .. " tried to rob NPC outside of claimed zone")
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        --print("Error: xPlayer is nil for source: " .. tostring(src))
        return
    end
    
    local price = math.random(Config.robNpcMoney.min, Config.robNpcMoney.max)
    xPlayer.addMoney(price)
    
    -- Get player's gang from gang column in users table
    local result = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {xPlayer.identifier})
    local gang = result[1].gang or "none"
    
    if gang ~= "none" then
        if graffitis[zone].gang == gang then
            -- Minor reputation gain for robbing in your own territory
            updateGangReputation(gang, "add", 0.5) -- Half the normal reputation gain
        else
            -- Decrease reputation of the territory owner
            updateGangReputation(graffitis[zone].gang, "remove", 1.5) -- 1.5x the normal reputation loss
        end
    end
end)
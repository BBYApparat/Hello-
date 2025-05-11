local client = TriggerClientEvent
local server = TriggerEvent
local AEH = AddEventHandler
local RNE = RegisterNetEvent
local komanda = RegisterCommand
local callback = RegisterNUICallback
local CT = CreateThread

local priceDict, stocksDict = {}, {}
GlobalState.Vozila = Shared.Vehicles
local TestSession = {}
TestSession['car'] = false
local NaTestu = nil
local Vozilo = nil

-- Utility function to normalize plates
function NormalizePlate(plate)
    if plate then
        -- Remove spaces and convert to uppercase
        plate = string.gsub(plate, "%s+", "")
        return string.upper(plate)
    end
    return plate
end

-- Initialize price dictionary
for k, v in pairs(Shared.Vehicles.cars) do
    priceDict[v.model] = v.price
end

-- Function to load stocks from database
local function loadStocksFromDB()
    MySQL.Async.fetchAll("SELECT * FROM carStock", {}, function(results)
        if results then
            for _, v in ipairs(results) do
                stocksDict[v.model] = v.stock
            end
            -- print("Loaded " .. #results .. " vehicle stocks from database")
            addMissingStocks()
        else
            print("Failed to load stocks from database")
        end
    end)
end

-- Function to add missing stocks
function addMissingStocks()
    local missingModels = {}
    for k, v in pairs(Shared.Vehicles.cars) do
        if not stocksDict[v.model] then
            stocksDict[v.model] = v.stock or 10  -- Use the stock from config or default to 10
            table.insert(missingModels, {model = v.model, stock = stocksDict[v.model]})
        end
    end
    
    if #missingModels > 0 then
        MySQL.Async.execute('INSERT IGNORE INTO carStock (model, stock) VALUES (@model, @stock)', missingModels, function(rowsChanged)
            if rowsChanged then
                -- print("Added " .. rowsChanged .. " missing vehicle stocks to database")
            else
                print("Failed to add missing stocks to database")
            end
        end)
    end
end

local function startTest(source, model, key, currentCoords)
    TestSession[key] = true
    NaTestu = source
    local player = GetPlayerPed(source)
    local coords = Shared.TestDrive.CarSpawnLocation
    SetEntityCoords(player, coords, false, false, false, false)
    Wait(100)
    
    Vozilo = CreateVehicle(joaat(model), coords, 325.0, true, true)
    
    while not DoesEntityExist(Vozilo) do
        Wait(0)
    end
    
    NetworkGetEntityOwner(Vozilo)
    
    SetVehicleNumberPlateText(Vozilo, "TEST" .. source)
    Wait(100)
    TaskWarpPedIntoVehicle(player, Vozilo, -1)

    CT(function()
        local times = {60, 45, 30, 15, 5}
        for _, time in ipairs(times) do
            sendFloatingText(source, (Shared.Translations.testDriveSeconds):format(tostring(time)), 3000)
            Wait(time == 5 and 5000 or 15000)
        end
        TestSession[key] = false
        NaTestu = nil
        DeleteEntity(Vozilo)
        SetEntityCoords(player, currentCoords, false, false, false, false)
        sendFloatingText(source, Shared.Translations.doneTestDrive, 3000)
    end)
end

local function sendFloatingText(player, text, ms)
    CT(function()
        client("sendNotificationCustom", player, text)
    end)
end

local function kupljenoAuto(name, message, color)
    local embeds = {
        {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "⚠ Vehicle Shop ⚠",
            },
        }
    }
    
    if message == nil or message == '' then return false end
    PerformHttpRequest(Shared.WebHook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RNE('ts-vehicleshop:checkTestSession')
AEH('ts-vehicleshop:checkTestSession', function(key, currentCoords, model)
    local _source = source
    if TestSession[key] then
        client("sendNotificationCustom", _source, Shared.Translations.bussyTestDrive)
    else
        startTest(_source, model, key, currentCoords)
    end
end)

RNE('ts-vehicleshop:setVehicleOwner')
AEH('ts-vehicleshop:setVehicleOwner', function(vehicleProps, photo, ime, model, health, job, garage)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if not xPlayer then 
        print("Error: Player not found when setting vehicle owner")
        return 
    end
    
    if not stocksDict[model] or stocksDict[model] <= 0 then
        client("sendNotificationCustom", _source, Shared.Translations.noStock)
        return
    end

    -- Normalize the plate for consistent storage
    vehicleProps.plate = NormalizePlate(vehicleProps.plate)
    
    -- Debug output
    print("Registering vehicle with plate: " .. vehicleProps.plate .. " for player: " .. xPlayer.identifier)

    -- Check if plate already exists
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = vehicleProps.plate
    }, function(result)
        if result and #result > 0 then
            client("sendNotificationCustom", _source, "This plate is already registered. Please try again.")
            return
        end
        
        -- Reduce stock
        stocksDict[model] = stocksDict[model] - 1

        -- Insert vehicle into database with error handling
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, slika, ime, model, health, job, stored, garage) VALUES (@owner, @plate, @vehicle, @slika, @ime, @model, @health, @job, @stored, @garage)',
        {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@slika'] = photo,
            ['@ime'] = ime,
            ['@model'] = model,
            ['@health'] = json.encode(health),
            ['@job'] = job,
            ['@stored'] = 1,
            ['@garage'] = garage
        }, function (rowsChanged)
            if rowsChanged > 0 then
                -- Update stock in database
                MySQL.Async.execute('UPDATE carStock SET stock = @stock WHERE model = @model', {
                    ['@stock'] = stocksDict[model],
                    ['@model'] = model
                }, function(stockRowsChanged)
                    if stockRowsChanged <= 0 then
                        print("Warning: Failed to update stock for " .. model)
                    end
                end)
                
                -- Notify player and give key
                client("sendNotificationCustom", _source, (Shared.Translations.successfullybuy):format(vehicleProps.plate))
                
                -- Log the purchase
                kupljenoAuto(GetPlayerName(_source), "Vehicle Purchased: " .. model .. " with plate " .. vehicleProps.plate, 65280)
                
                -- If using wasabi_carlock, give key
                if exports.wasabi_carlock then
                    exports.wasabi_carlock:GiveKey(xPlayer.source, vehicleProps.plate)
                end
                
                print("Successfully registered vehicle: " .. vehicleProps.plate)
            else
                -- Registration failed, restore stock
                stocksDict[model] = stocksDict[model] + 1
                client("sendNotificationCustom", _source, "Failed to register your new vehicle. Please contact an admin.")
                print("Error: Failed to register vehicle for " .. xPlayer.identifier)
            end
        end)
    end)
end)

ESX.RegisterServerCallback('ts-vehicleshop:buyVehicleA', function(source, cb, model)
    if not priceDict[model] then 
        print("Error: Price not found for model " .. model)
        return cb(false) 
    end
    
    local xPlayer = ESX.GetPlayerFromId(source) 
    
    if not xPlayer then
        print("Error: Player not found when buying vehicle")
        return cb(false)
    end
    
    if not stocksDict[model] or stocksDict[model] <= 0 then
        client("sendNotificationCustom", source, Shared.Translations.noStock)
        return cb(false)
    end

    if xPlayer.getMoney() >= priceDict[model] then
        xPlayer.removeMoney(priceDict[model])
        cb(true)
    else
        client("sendNotificationCustom", source, "You don't have enough money to buy this vehicle.")
        cb(false)
    end
end)

RNE('ts-vehicleshop:napraviBucket')
AEH('ts-vehicleshop:napraviBucket', function(entity)
    local random = math.random(1, 5000)
    SetPlayerRoutingBucket(source, random)
    local vozilo = GetVehiclePedIsIn(GetPlayerPed(source), false)
    Wait(1000)
    SetEntityRoutingBucket(vozilo, random)
end)

RNE('ts-vehicleshop:resetujBucket')
AEH('ts-vehicleshop:resetujBucket', function(data)
    SetPlayerRoutingBucket(source, 0)
end)

ESX.RegisterServerCallback('ts-vehicleshop:isPlateTaken', function(source, cb, plate)
    local normalizedPlate = NormalizePlate(plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = normalizedPlate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

komanda("addstock", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'admin' then
        return TriggerClientEvent('esx:showNotification', source, 'You do not have permission to use this command.')
    end

    if #args ~= 2 then
        return TriggerClientEvent('esx:showNotification', source, 'Usage: /addstock [model] [amount]')
    end

    local model, amount = args[1], tonumber(args[2])

    if not amount or amount <= 0 then
        return TriggerClientEvent('esx:showNotification', source, 'Invalid amount. Please enter a positive number.')
    end

    if not stocksDict[model] then
        return TriggerClientEvent('esx:showNotification', source, 'Invalid vehicle model.')
    end

    stocksDict[model] = stocksDict[model] + amount

    MySQL.Async.execute('UPDATE carStock SET stock = @stock WHERE model = @model', {
        ['@stock'] = stocksDict[model],
        ['@model'] = model
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:showNotification', source, 'Stock updated. New stock for ' .. model .. ': ' .. stocksDict[model])
        else
            TriggerClientEvent('esx:showNotification', source, 'Failed to update stock in database.')
        end
    end)
end, false)

ESX.RegisterServerCallback('ts-vehicleshop:getStocks', function(source, cb)
    if source < 0 then return cb(false) end
    cb(stocksDict)
end)

-- Debug command to check if a plate exists in the database
komanda("checkplate", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'admin' then
        return TriggerClientEvent('esx:showNotification', source, 'You do not have permission to use this command.')
    end

    if #args < 1 then
        return TriggerClientEvent('esx:showNotification', source, 'Usage: /checkplate [plate]')
    end

    local plate = args[1]
    local normalizedPlate = NormalizePlate(plate)
    
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @normalizedPlate OR plate = @originalPlate', {
        ['@normalizedPlate'] = normalizedPlate,
        ['@originalPlate'] = plate
    }, function(result)
        if result and result[1] then
            TriggerClientEvent('esx:showNotification', source, 'Vehicle found in database: Owner ID = ' .. result[1].owner)
        else
            TriggerClientEvent('esx:showNotification', source, 'Vehicle NOT found in database!')
        end
    end)
end, false)

AddEventHandler("playerDropped", function()
    if TestSession["car"] == true and source == NaTestu then
        TestSession["car"] = false
        NaTestu = nil
        if DoesEntityExist(Vozilo) then
            DeleteEntity(Vozilo)
            Vozilo = nil
        end
    end
end)

RNE("ts-vehicleshop:startTestSession", function()
    SetPlayerRoutingBucket(source, source + math.random(1, 99))
end)

RNE("ts-vehicleshop:endTestSession", function()
    SetPlayerRoutingBucket(source, 0)
end)

-- Initialize when resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    -- print('The resource ' .. resourceName .. ' is starting.')
    loadStocksFromDB()
end)

-- Ensure stocks are loaded when MySQL is ready
MySQL.ready(function()
    -- print("MySQL is ready, loading vehicle stocks...")
    loadStocksFromDB()
end)

-- Debug command to check all loaded stocks
komanda("checkallstocks", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'admin' then
        return TriggerClientEvent('esx:showNotification', source, 'You do not have permission to use this command.')
    end
    
    local count = 0
    local stockList = "Vehicle Stocks:\n"
    for k, v in pairs(stocksDict) do
        count = count + 1
        stockList = stockList .. k .. ": " .. v .. "\n"
        
        -- Send in chunks to avoid message size limits
        if count % 10 == 0 then
            TriggerClientEvent('esx:showNotification', source, stockList)
            stockList = ""
        end
    end
    
    if stockList ~= "" then
        TriggerClientEvent('esx:showNotification', source, stockList)
    end
    
    TriggerClientEvent('esx:showNotification', source, "Total vehicles in stock: " .. count)
end, false)
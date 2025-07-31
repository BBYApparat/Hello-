ESX = exports["es_extended"]:getSharedObject()

-- Initialize house ownership data
local HouseOwnership = {}
local HouseVehicles = {} -- Store vehicles for each house garage
local ActiveRaids = {} -- Track active raids
local RaidCooldowns = {} -- Track raid cooldowns
local DoorbellHistory = {} -- Store doorbell history
local HouseDecorations = {} -- Store decorations for each house

-- Initialize stashes and vehicle storage for all houses on server start
CreateThread(function()
    MySQL.query("SELECT * FROM bby_housing", {}, function(houses)
        for k, house in pairs(houses) do
            HouseOwnership[house.house_id] = house.identifier
        end
    end)
    
    -- Load stored vehicles for each house
    MySQL.query("SELECT * FROM bby_housing_vehicles", {}, function(vehicles)
        for k, vehicle in pairs(vehicles) do
            if not HouseVehicles[vehicle.house_id] then
                HouseVehicles[vehicle.house_id] = {}
            end
            table.insert(HouseVehicles[vehicle.house_id], {
                id = vehicle.id,
                plate = vehicle.plate,
                model = vehicle.model,
                props = json.decode(vehicle.props),
                slot = vehicle.slot
            })
        end
    end)
    
    -- Load stored decorations for each house
    MySQL.query("SELECT * FROM bby_housing_decorations", {}, function(decorations)
        for k, decoration in pairs(decorations) do
            if not HouseDecorations[decoration.house_id] then
                HouseDecorations[decoration.house_id] = {}
            end
            table.insert(HouseDecorations[decoration.house_id], {
                id = decoration.id,
                model = decoration.model,
                coords = json.decode(decoration.coords),
                rotation = json.decode(decoration.rotation),
                name = decoration.name
            })
        end
    end)
    
    -- Register stashes for all houses (even unowned ones)
    for i = 1, 15 do
        local houseData = Config.Houses[i]
        local houseType = Config.HouseTypes[houseData.type]
        exports.ox_inventory:RegisterStash("house_" .. i, houseType.label .. " " .. i .. " Storage", 50, 100000)
    end
end)

-- Function to purchase a house
RegisterNetEvent('housing:purchaseHouse', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local house = Config.Houses[houseId]
    if not house then 
        TriggerClientEvent('esx:showNotification', source, 'House not found!')
        return 
    end
    
    -- Check if house is already owned
    if HouseOwnership[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'This house is already owned!')
        return
    end
    
    -- Calculate actual price based on house type
    local houseType = Config.HouseTypes[house.type]
    local actualPrice = math.floor(house.base_price * houseType.interior.price_multiplier)
    
    -- Check if player has enough money
    if xPlayer.getMoney() < actualPrice then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t have enough money! Required: $' .. actualPrice)
        return
    end
    
    -- Remove money and assign house
    xPlayer.removeMoney(actualPrice)
    HouseOwnership[houseId] = xPlayer.identifier
    HouseVehicles[houseId] = {} -- Initialize empty garage
    
    -- Save to database
    MySQL.insert.await('INSERT INTO `bby_housing` (house_id, identifier, house_type, purchased_at) VALUES (?, ?, ?, ?)', {
        houseId, 
        xPlayer.identifier, 
        house.type,
        os.date('%Y-%m-%d %H:%M:%S')
    })
    
    TriggerClientEvent('esx:showNotification', source, 'House purchased successfully for $' .. actualPrice)
    TriggerClientEvent('housing:updateHouseData', source, HouseOwnership)
end)

-- Function to sell a house
RegisterNetEvent('housing:sellHouse', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    local house = Config.Houses[houseId]
    local houseType = Config.HouseTypes[house.type]
    local originalPrice = math.floor(house.base_price * houseType.interior.price_multiplier)
    local sellPrice = math.floor(originalPrice * 0.7) -- 70% of original price
    
    -- Give money back and remove ownership
    xPlayer.addMoney(sellPrice)
    HouseOwnership[houseId] = nil
    
    -- Clear garage vehicles
    if HouseVehicles[houseId] then
        -- Delete all vehicles from garage in database
        MySQL.execute.await('DELETE FROM `bby_housing_vehicles` WHERE house_id = ?', {houseId})
        HouseVehicles[houseId] = nil
    end
    
    -- Remove from database
    MySQL.execute.await('DELETE FROM `bby_housing` WHERE house_id = ? AND identifier = ?', {
        houseId, 
        xPlayer.identifier
    })
    
    TriggerClientEvent('esx:showNotification', source, 'House sold for $' .. sellPrice)
    TriggerClientEvent('housing:updateHouseData', source, HouseOwnership)
end)

-- Enter house (set routing bucket)
RegisterNetEvent('housing:enterHouse', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Set player to unique routing bucket (house ID = bucket ID)
    SetPlayerRoutingBucket(source, houseId)
    local house = Config.Houses[houseId]
    TriggerClientEvent('housing:enterHouse', source, houseId, house.type)
end)

-- Exit house (return to default bucket)
RegisterNetEvent('housing:exitHouse', function()
    local source = source
    
    -- Return player to default bucket (0)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('housing:exitHouse', source)
end)

-- Enter garage (set routing bucket)
RegisterNetEvent('housing:enterGarage', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Set player to garage bucket (house ID + 100 to differentiate from house interior)
    SetPlayerRoutingBucket(source, houseId + 100)
    local house = Config.Houses[houseId]
    TriggerClientEvent('housing:enterGarage', source, houseId, house.type)
end)

-- Exit garage (return to default bucket)
RegisterNetEvent('housing:exitGarage', function()
    local source = source
    
    -- Return player to default bucket (0)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('housing:exitGarage', source)
end)

-- Store vehicle in garage
RegisterNetEvent('housing:storeVehicle', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Check if garage has space (max 5 vehicles)
    if not HouseVehicles[houseId] then
        HouseVehicles[houseId] = {}
    end
    
    if #HouseVehicles[houseId] >= 5 then
        TriggerClientEvent('esx:showNotification', source, 'Garage is full! (Max: 5 vehicles)')
        return
    end
    
    TriggerClientEvent('housing:storeVehicle', source, houseId)
end)

-- Get vehicle from garage
RegisterNetEvent('housing:getVehicle', function(houseId, vehicleId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Find vehicle in garage
    if not HouseVehicles[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'No vehicles in garage!')
        return
    end
    
    local vehicle = nil
    local vehicleIndex = nil
    for i, v in ipairs(HouseVehicles[houseId]) do
        if v.id == vehicleId then
            vehicle = v
            vehicleIndex = i
            break
        end
    end
    
    if not vehicle then
        TriggerClientEvent('esx:showNotification', source, 'Vehicle not found!')
        return
    end
    
    -- Remove vehicle from garage storage
    table.remove(HouseVehicles[houseId], vehicleIndex)
    MySQL.execute.await('DELETE FROM `bby_housing_vehicles` WHERE id = ?', {vehicleId})
    
    TriggerClientEvent('housing:spawnVehicle', source, vehicle.model, vehicle.props, vehicle.plate)
end)

-- Get garage vehicles list
ESX.RegisterServerCallback('housing:getGarageVehicles', function(source, cb, houseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or HouseOwnership[houseId] ~= xPlayer.identifier then
        cb({})
        return
    end
    
    if not HouseVehicles[houseId] then
        HouseVehicles[houseId] = {}
    end
    
    cb(HouseVehicles[houseId])
end)

-- Save vehicle to garage (called from client)
RegisterNetEvent('housing:saveVehicleToGarage', function(houseId, vehicleData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or HouseOwnership[houseId] ~= xPlayer.identifier then
        return
    end
    
    -- Find next available slot
    local slot = 1
    if HouseVehicles[houseId] then
        for i = 1, 5 do
            local slotTaken = false
            for _, v in ipairs(HouseVehicles[houseId]) do
                if v.slot == i then
                    slotTaken = true
                    break
                end
            end
            if not slotTaken then
                slot = i
                break
            end
        end
    else
        HouseVehicles[houseId] = {}
    end
    
    -- Save to database
    local insertId = MySQL.insert.await('INSERT INTO `bby_housing_vehicles` (house_id, plate, model, props, slot) VALUES (?, ?, ?, ?, ?)', {
        houseId,
        vehicleData.plate,
        vehicleData.model,
        json.encode(vehicleData.props),
        slot
    })
    
    -- Add to memory
    table.insert(HouseVehicles[houseId], {
        id = insertId,
        plate = vehicleData.plate,
        model = vehicleData.model,
        props = vehicleData.props,
        slot = slot
    })
    
    TriggerClientEvent('esx:showNotification', source, 'Vehicle stored in garage!')
end)

-- Send house ownership data to client on player load
AddEventHandler('esx:playerLoaded', function(playerId)
    TriggerClientEvent('housing:updateHouseData', playerId, HouseOwnership)
end)

-- Get house ownership data
ESX.RegisterServerCallback('housing:getHouseData', function(source, cb)
    cb(HouseOwnership)
end)

-- Helper function to check if player is police
local function isPolice(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false end
    
    for _, job in ipairs(Config.PoliceJobs) do
        if xPlayer.job.name == job then
            return true
        end
    end
    return false
end

-- Police Raid System
RegisterNetEvent('housing:initiateRaid', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not isPolice(source) then
        TriggerClientEvent('esx:showNotification', source, 'Access denied!')
        return
    end
    
    -- Check if house exists and is owned
    if not HouseOwnership[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'This house is not owned!')
        return
    end
    
    -- Check if raid is already active
    if ActiveRaids[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'Raid already in progress!')
        return
    end
    
    -- Check cooldown
    if RaidCooldowns[houseId] and (os.time() - RaidCooldowns[houseId]) < Config.RaidSettings.RaidCooldown then
        local remainingTime = Config.RaidSettings.RaidCooldown - (os.time() - RaidCooldowns[houseId])
        TriggerClientEvent('esx:showNotification', source, 'Raid cooldown active! Wait ' .. math.ceil(remainingTime/60) .. ' minutes')
        return
    end
    
    -- TODO: Add warrant check if Config.RaidSettings.RequireWarrant is true
    -- This would integrate with your MDT system
    
    -- Start raid
    ActiveRaids[houseId] = {
        startTime = os.time(),
        officers = {source},
        evidence = {}
    }
    
    -- Notify all police
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        if isPolice(xPlayer.source) then
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'RAID INITIATED: House ' .. houseId .. ' by ' .. xPlayer.getName())
        end
    end
    
    -- Notify house owner if online
    local ownerIdentifier = HouseOwnership[houseId]
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.identifier == ownerIdentifier then
            TriggerClientEvent('esx:showNotification', xPlayer.source, '🚨 POLICE RAID: Your house is being raided!')
            TriggerClientEvent('housing:houseRaided', xPlayer.source, houseId)
            break
        end
    end
    
    TriggerClientEvent('housing:raidStarted', source, houseId)
    
    -- Auto-end raid after duration
    SetTimeout(Config.RaidSettings.RaidDuration * 1000, function()
        if ActiveRaids[houseId] then
            endRaid(houseId)
        end
    end)
end)

-- End raid function
function endRaid(houseId)
    if not ActiveRaids[houseId] then return end
    
    local raidData = ActiveRaids[houseId]
    ActiveRaids[houseId] = nil
    RaidCooldowns[houseId] = os.time()
    
    -- Notify officers
    for _, officerId in ipairs(raidData.officers) do
        TriggerClientEvent('esx:showNotification', officerId, 'Raid completed on House ' .. houseId)
        TriggerClientEvent('housing:raidEnded', officerId, houseId)
    end
    
    -- Log raid to database
    MySQL.insert('INSERT INTO bby_housing_raids (house_id, officers, evidence_found, raid_date) VALUES (?, ?, ?, ?)', {
        houseId,
        json.encode(raidData.officers),
        json.encode(raidData.evidence),
        os.date('%Y-%m-%d %H:%M:%S')
    })
end

-- Join ongoing raid
RegisterNetEvent('housing:joinRaid', function(houseId)
    local source = source
    
    if not isPolice(source) then
        TriggerClientEvent('esx:showNotification', source, 'Access denied!')
        return
    end
    
    if not ActiveRaids[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'No active raid at this house!')
        return
    end
    
    table.insert(ActiveRaids[houseId].officers, source)
    TriggerClientEvent('housing:raidStarted', source, houseId)
    TriggerClientEvent('esx:showNotification', source, 'Joined raid on House ' .. houseId)
end)

-- Confiscate evidence during raid
RegisterNetEvent('housing:confiscateEvidence', function(houseId, itemName, amount)
    local source = source
    
    if not isPolice(source) or not ActiveRaids[houseId] then
        return
    end
    
    -- Check if officer is part of the raid
    local isRaidOfficer = false
    for _, officerId in ipairs(ActiveRaids[houseId].officers) do
        if officerId == source then
            isRaidOfficer = true
            break
        end
    end
    
    if not isRaidOfficer then return end
    
    -- Check if item is allowed to be confiscated
    local canConfiscate = false
    for _, allowedItem in ipairs(Config.RaidSettings.AllowedItems) do
        if string.find(itemName:lower(), allowedItem:lower()) then
            canConfiscate = true
            break
        end
    end
    
    if canConfiscate then
        table.insert(ActiveRaids[houseId].evidence, {
            item = itemName,
            amount = amount,
            officer = source,
            time = os.time()
        })
        
        TriggerClientEvent('esx:showNotification', source, 'Evidence confiscated: ' .. amount .. 'x ' .. itemName)
    end
end)

-- Doorbell System
RegisterNetEvent('housing:ringDoorbell', function(houseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if house is owned
    if not HouseOwnership[houseId] then
        TriggerClientEvent('esx:showNotification', source, 'This house is not owned!')
        return
    end
    
    -- Find house owner
    local ownerIdentifier = HouseOwnership[houseId]
    local ownerPlayer = nil
    
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.identifier == ownerIdentifier then
            ownerPlayer = xPlayer
            break
        end
    end
    
    -- Add to doorbell history
    if not DoorbellHistory[houseId] then
        DoorbellHistory[houseId] = {}
    end
    
    table.insert(DoorbellHistory[houseId], 1, {
        visitor_name = xPlayer.getName(),
        visitor_id = source,
        time = os.time(),
        answered = false
    })
    
    -- Keep only last 10 entries
    if #DoorbellHistory[houseId] > Config.DoorbellSettings.MaxVisitorHistory then
        table.remove(DoorbellHistory[houseId])
    end
    
    if ownerPlayer then
        -- Owner is online - send notification
        TriggerClientEvent('housing:doorbellRang', ownerPlayer.source, {
            houseId = houseId,
            visitorName = xPlayer.getName(),
            visitorId = source
        })
        
        TriggerClientEvent('esx:showNotification', ownerPlayer.source, '🔔 ' .. xPlayer.getName() .. ' is at your door!')
        
        -- Play doorbell sound
        if Config.DoorbellSettings.EnableSounds then
            TriggerClientEvent('housing:playDoorbellSound', ownerPlayer.source, houseId)
        end
        
        TriggerClientEvent('esx:showNotification', source, 'Doorbell rang! Waiting for response...')
    else
        -- Owner is offline
        TriggerClientEvent('esx:showNotification', source, 'No one is home!')
        
        -- Save to database for offline notification
        MySQL.insert('INSERT INTO bby_housing_doorbell (house_id, visitor_name, visitor_identifier, ring_time) VALUES (?, ?, ?, ?)', {
            houseId,
            xPlayer.getName(),
            xPlayer.identifier,
            os.date('%Y-%m-%d %H:%M:%S')
        })
    end
end)

-- Answer doorbell
RegisterNetEvent('housing:answerDoorbell', function(houseId, visitorId, response)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Verify ownership
    if not xPlayer or HouseOwnership[houseId] ~= xPlayer.identifier then
        return
    end
    
    -- Mark as answered in history
    if DoorbellHistory[houseId] then
        for _, entry in ipairs(DoorbellHistory[houseId]) do
            if entry.visitor_id == visitorId and not entry.answered then
                entry.answered = true
                entry.response = response
                break
            end
        end
    end
    
    -- Notify visitor
    if response == 'invite' then
        TriggerClientEvent('esx:showNotification', visitorId, xPlayer.getName() .. ' invited you inside!')
        TriggerClientEvent('housing:invitedInside', visitorId, houseId)
    elseif response == 'decline' then
        TriggerClientEvent('esx:showNotification', visitorId, xPlayer.getName() .. ' declined your visit')
    end
    
    TriggerClientEvent('esx:showNotification', source, 'Response sent to visitor')
end)

-- Get doorbell history
ESX.RegisterServerCallback('housing:getDoorbellHistory', function(source, cb, houseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or HouseOwnership[houseId] ~= xPlayer.identifier then
        cb({})
        return
    end
    
    -- Combine online and offline history
    local history = {}
    
    -- Add recent online visitors
    if DoorbellHistory[houseId] then
        for _, entry in ipairs(DoorbellHistory[houseId]) do
            table.insert(history, {
                visitor_name = entry.visitor_name,
                time = entry.time,
                answered = entry.answered,
                response = entry.response or 'no_response',
                online = true
            })
        end
    end
    
    -- Add offline visitors from database
    MySQL.query('SELECT * FROM bby_housing_doorbell WHERE house_id = ? ORDER BY ring_time DESC LIMIT ?', {
        houseId, 
        Config.DoorbellSettings.MaxVisitorHistory
    }, function(results)
        for _, row in ipairs(results) do
            local timestamp = os.time{
                year = tonumber(row.ring_time:sub(1, 4)),
                month = tonumber(row.ring_time:sub(6, 7)),
                day = tonumber(row.ring_time:sub(9, 10)),
                hour = tonumber(row.ring_time:sub(12, 13)),
                min = tonumber(row.ring_time:sub(15, 16)),
                sec = tonumber(row.ring_time:sub(18, 19))
            }
            
            table.insert(history, {
                visitor_name = row.visitor_name,
                time = timestamp,
                answered = false,
                response = 'offline',
                online = false
            })
        end
        
        -- Sort by time (newest first)
        table.sort(history, function(a, b) return a.time > b.time end)
        
        cb(history)
    end)
end)

-- Decoration System Events

-- Buy decoration
RegisterNetEvent('housing:buyDecoration', function(decorationData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Find decoration in config
    local decorationInfo = nil
    for _, category in ipairs(Config.Decorations) do
        for _, item in ipairs(category.items) do
            if item.model == decorationData.model then
                decorationInfo = item
                break
            end
        end
        if decorationInfo then break end
    end
    
    if not decorationInfo then
        TriggerClientEvent('esx:showNotification', source, 'Invalid decoration!')
        return
    end
    
    -- Check if player has enough money
    if xPlayer.getMoney() < decorationInfo.price then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t have enough money! Required: $' .. decorationInfo.price)
        return
    end
    
    -- Remove money
    xPlayer.removeMoney(decorationInfo.price)
    
    -- Add to player inventory (as item for placement)
    xPlayer.addInventoryItem('decoration', 1, {
        model = decorationInfo.model,
        name = decorationInfo.name,
        description = decorationInfo.description
    })
    
    TriggerClientEvent('esx:showNotification', source, 'Purchased ' .. decorationInfo.name .. ' for $' .. decorationInfo.price)
end)

-- Place decoration
RegisterNetEvent('housing:placeDecoration', function(houseId, decorationData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Check decoration limit
    if not HouseDecorations[houseId] then
        HouseDecorations[houseId] = {}
    end
    
    if #HouseDecorations[houseId] >= Config.DecorationSettings.MaxDecorationsPerHouse then
        TriggerClientEvent('esx:showNotification', source, 'Maximum decorations reached! (' .. Config.DecorationSettings.MaxDecorationsPerHouse .. ')')
        return
    end
    
    -- Save to database
    local insertId = MySQL.insert.await('INSERT INTO `bby_housing_decorations` (house_id, model, name, coords, rotation) VALUES (?, ?, ?, ?, ?)', {
        houseId,
        decorationData.model,
        decorationData.name,
        json.encode(decorationData.coords),
        json.encode(decorationData.rotation)
    })
    
    -- Add to memory
    table.insert(HouseDecorations[houseId], {
        id = insertId,
        model = decorationData.model,
        coords = decorationData.coords,
        rotation = decorationData.rotation,
        name = decorationData.name
    })
    
    -- Notify all players in the house to spawn the decoration
    TriggerClientEvent('housing:spawnDecoration', -1, houseId, {
        id = insertId,
        model = decorationData.model,
        coords = decorationData.coords,
        rotation = decorationData.rotation,
        name = decorationData.name
    })
    
    TriggerClientEvent('esx:showNotification', source, 'Decoration placed successfully!')
end)

-- Remove decoration
RegisterNetEvent('housing:removeDecoration', function(houseId, decorationId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player owns this house
    if HouseOwnership[houseId] ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You don\'t own this house!')
        return
    end
    
    -- Find and remove decoration
    if HouseDecorations[houseId] then
        for i, decoration in ipairs(HouseDecorations[houseId]) do
            if decoration.id == decorationId then
                -- Remove from database
                MySQL.execute.await('DELETE FROM `bby_housing_decorations` WHERE id = ?', {decorationId})
                
                -- Remove from memory
                table.remove(HouseDecorations[houseId], i)
                
                -- Notify all players to remove the decoration
                TriggerClientEvent('housing:removeDecorationObject', -1, houseId, decorationId)
                
                TriggerClientEvent('esx:showNotification', source, 'Decoration removed!')
                return
            end
        end
    end
    
    TriggerClientEvent('esx:showNotification', source, 'Decoration not found!')
end)

-- Get house decorations
ESX.RegisterServerCallback('housing:getHouseDecorations', function(source, cb, houseId)
    if not HouseDecorations[houseId] then
        HouseDecorations[houseId] = {}
    end
    cb(HouseDecorations[houseId])
end)

-- Get decoration shop
ESX.RegisterServerCallback('housing:getDecorationShop', function(source, cb)
    cb(Config.Decorations)
end)
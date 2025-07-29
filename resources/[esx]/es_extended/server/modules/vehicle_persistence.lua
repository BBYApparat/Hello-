-- Vehicle Persistence System for ESX (Performance Optimized)
-- Handles despawning vehicles when no players are nearby and respawning them when players return

local DESPAWN_DISTANCE = 150.0 -- Distance in meters to check for nearby players
local CHECK_INTERVAL = 30000 -- Check every 30 seconds (reduced from 60)
local DESPAWN_TIMEOUT = 300000 -- 5 minutes before despawning (in milliseconds)
local BATCH_SAVE_INTERVAL = 120000 -- Batch save every 2 minutes
local MAX_VEHICLES_PER_PLAYER = 5 -- Limit vehicles per player to prevent abuse

-- Storage for tracked vehicles (MEMORY-BASED - NO DATABASE SPAM)
local trackedVehicles = {} -- [vehicle] = vehicleData
local vehicleTimers = {} -- [vehicle] = timestamp
local vehicleCache = {} -- [plate] = vehicleData (cached for quick lookups)
local playerVehicles = {} -- [identifier] = {plate1, plate2, ...}
local dirtyVehicles = {} -- Vehicles that need database updates
local batchSaveQueue = {} -- Queue for batch database operations

-- Initialize the system
CreateThread(function()
    Wait(5000) -- Wait for ESX to be fully loaded
    
    -- PERFORMANCE: Load only essential data into memory cache
    MySQL.query('SELECT plate, owner, last_position, is_spawned FROM vehicle_persistence', {}, function(results)
        for _, row in ipairs(results) do
            vehicleCache[row.plate] = {
                owner = row.owner,
                lastPosition = json.decode(row.last_position or '{"x":0,"y":0,"z":0,"h":0}'),
                isSpawned = row.is_spawned == 1
            }
            
            -- Group by player for quick lookups
            if not playerVehicles[row.owner] then
                playerVehicles[row.owner] = {}
            end
            table.insert(playerVehicles[row.owner], row.plate)
        end
        
        print(('[ESX] Vehicle Persistence: Loaded %d vehicles into memory cache'):format(#results))
    end)
    
    -- Start monitoring and batch save systems
    startVehicleMonitoring()
    startBatchSaveSystem()
end)

-- PERFORMANCE: Batch save system - saves to database every 2 minutes instead of constantly
function startBatchSaveSystem()
    CreateThread(function()
        while true do
            Wait(BATCH_SAVE_INTERVAL)
            
            if next(batchSaveQueue) then
                local queries = {}
                local count = 0
                
                for plate, data in pairs(batchSaveQueue) do
                    table.insert(queries, {
                        query = [[INSERT INTO vehicle_persistence (plate, owner, last_position, is_spawned, network_id, last_seen)
                                 VALUES (?, ?, ?, ?, ?, NOW())
                                 ON DUPLICATE KEY UPDATE
                                 last_position = VALUES(last_position),
                                 is_spawned = VALUES(is_spawned),
                                 network_id = VALUES(network_id),
                                 last_seen = NOW()]],
                        parameters = {
                            plate,
                            data.owner,
                            json.encode(data.lastPosition),
                            data.isSpawned and 1 or 0,
                            data.networkId
                        }
                    })
                    count = count + 1
                end
                
                -- Execute batch queries
                MySQL.transaction(queries, function(success)
                    if success then
                        print(('[ESX] Vehicle Persistence: Batch saved %d vehicles'):format(count))
                        batchSaveQueue = {} -- Clear queue
                    else
                        print('[ESX] Vehicle Persistence: Batch save failed')
                    end
                end)
            end
        end
    end)
end

-- OPTIMIZED: Vehicle monitoring with reduced database calls
function startVehicleMonitoring()
    CreateThread(function()
        while true do
            Wait(CHECK_INTERVAL)
            
            local currentTime = GetGameTimer()
            
            -- PERFORMANCE: Check vehicles in batches to avoid frame drops
            local vehicleList = {}
            for vehicle, data in pairs(trackedVehicles) do
                table.insert(vehicleList, {vehicle, data})
            end
            
            for i, vehicleData in ipairs(vehicleList) do
                local vehicle, data = vehicleData[1], vehicleData[2]
                
                if DoesEntityExist(vehicle) then
                    local vehicleCoords = GetEntityCoords(vehicle)
                    local nearbyPlayers = ESX.OneSync.GetPlayersInArea(vehicleCoords, DESPAWN_DISTANCE)
                    
                    if #nearbyPlayers == 0 then
                        -- No players nearby, start despawn timer
                        if not vehicleTimers[vehicle] then
                            vehicleTimers[vehicle] = currentTime
                        elseif currentTime - vehicleTimers[vehicle] > DESPAWN_TIMEOUT then
                            -- Time to despawn the vehicle
                            despawnVehicle(vehicle, data)
                        end
                    else
                        -- Players are nearby, cancel despawn timer
                        vehicleTimers[vehicle] = nil
                        
                        -- PERFORMANCE: Queue position update instead of immediate DB write
                        queueVehicleUpdate(data.plate, vehicleCoords, true, data.networkId, data.owner)
                    end
                else
                    -- Vehicle no longer exists, clean up
                    cleanupVehicleData(vehicle, data)
                end
                
                -- PERFORMANCE: Process only 5 vehicles per frame to avoid lag
                if i % 5 == 0 then
                    Wait(0)
                end
            end
        end
    end)
end

-- PERFORMANCE: Queue updates instead of immediate database writes
function queueVehicleUpdate(plate, coords, isSpawned, networkId, owner)
    local heading = coords and GetEntityHeading(NetworkGetEntityFromNetworkId(networkId or 0)) or 0
    
    batchSaveQueue[plate] = {
        owner = owner,
        lastPosition = coords and {x = coords.x, y = coords.y, z = coords.z, h = heading} or {x = 0, y = 0, z = 0, h = 0},
        isSpawned = isSpawned,
        networkId = networkId
    }
    
    -- Update memory cache immediately
    if vehicleCache[plate] then
        vehicleCache[plate].lastPosition = batchSaveQueue[plate].lastPosition
        vehicleCache[plate].isSpawned = isSpawned
    end
end

-- OPTIMIZED: Despawn function with minimal database operations
function despawnVehicle(vehicle, data)
    if not DoesEntityExist(vehicle) then
        cleanupVehicleData(vehicle, data)
        return
    end
    
    local vehicleCoords = GetEntityCoords(vehicle)
    local vehicleHeading = GetEntityHeading(vehicle)
    local plate = data.plate
    
    -- PERFORMANCE: Only save essential data during despawn
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    local healthData = {
        engineHealth = GetVehicleEngineHealth(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle)
    }
    
    -- PERFORMANCE: Queue the heavy save operation instead of blocking
    CreateThread(function()
        local trunkItems, gloveboxItems = nil, nil
        
        if Config.OxInventory then
            -- PERFORMANCE: Non-blocking inventory operations
            local success, trunkData = pcall(exports.ox_inventory.GetInventory, exports.ox_inventory, 'trunk_' .. plate, false)
            if success and trunkData then
                trunkItems = json.encode(trunkData.items or {})
            end
            
            local success2, gloveboxData = pcall(exports.ox_inventory.GetInventory, exports.ox_inventory, 'glovebox_' .. plate, false)
            if success2 and gloveboxData then
                gloveboxItems = json.encode(gloveboxData.items or {})
            end
        end
        
        -- Queue for batch save instead of immediate database write
        batchSaveQueue[plate] = {
            owner = data.owner,
            lastPosition = {x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z, h = vehicleHeading},
            isSpawned = false,
            networkId = nil,
            vehicleData = vehicleProps,
            healthData = healthData,
            trunkItems = trunkItems,
            gloveboxItems = gloveboxItems
        }
        
        -- Update memory cache
        vehicleCache[plate] = {
            owner = data.owner,
            lastPosition = {x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z, h = vehicleHeading},
            isSpawned = false
        }
    end)
    
    print(('[ESX] Despawned vehicle %s (owner: %s)'):format(plate, data.owner))
    
    -- Delete the vehicle immediately
    DeleteEntity(vehicle)
    
    -- Clean up tracking data
    cleanupVehicleData(vehicle, data)
end

-- Function to clean up vehicle tracking data
function cleanupVehicleData(vehicle, data)
    trackedVehicles[vehicle] = nil
    vehicleTimers[vehicle] = nil
    
    if data and data.plate then
        -- Mark as not spawned in database
        MySQL.execute.await('UPDATE vehicle_persistence SET is_spawned = 0, network_id = NULL WHERE plate = ?', {data.plate})
    end
end

-- Function to update vehicle position in database
function updateVehiclePosition(vehicle, data, coords)
    local heading = GetEntityHeading(vehicle)
    local position = {x = coords.x, y = coords.y, z = coords.z, h = heading}
    
    MySQL.execute.await('UPDATE vehicle_persistence SET last_position = ?, last_seen = CURRENT_TIMESTAMP WHERE plate = ?', {
        json.encode(position),
        data.plate
    })
end

-- PERFORMANCE: Optimized vehicle registration with limits
function ESX.RegisterSpawnedVehicle(vehicle, plate, owner)
    if not DoesEntityExist(vehicle) then
        return false
    end
    
    -- PERFORMANCE: Check vehicle limits per player
    local playerVehicleCount = 0
    for _, vehicleData in pairs(trackedVehicles) do
        if vehicleData.owner == owner then
            playerVehicleCount = playerVehicleCount + 1
        end
    end
    
    if playerVehicleCount >= MAX_VEHICLES_PER_PLAYER then
        print(('[ESX] Vehicle limit reached for player %s (%d/%d)'):format(owner, playerVehicleCount, MAX_VEHICLES_PER_PLAYER))
        return false
    end
    
    local networkId = NetworkGetNetworkIdFromEntity(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    local vehicleHeading = GetEntityHeading(vehicle)
    
    trackedVehicles[vehicle] = {
        plate = plate,
        owner = owner,
        networkId = networkId,
        lastPosition = vehicleCoords,
        despawnTimer = nil
    }
    
    -- PERFORMANCE: Queue database update instead of immediate write
    queueVehicleUpdate(plate, vehicleCoords, true, networkId, owner)
    
    -- Update memory cache
    vehicleCache[plate] = {
        owner = owner,
        lastPosition = {x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z, h = vehicleHeading},
        isSpawned = true
    }
    
    -- Update player vehicle list
    if not playerVehicles[owner] then
        playerVehicles[owner] = {}
    end
    
    local alreadyTracked = false
    for _, existingPlate in ipairs(playerVehicles[owner]) do
        if existingPlate == plate then
            alreadyTracked = true
            break
        end
    end
    
    if not alreadyTracked then
        table.insert(playerVehicles[owner], plate)
    end
    
    print(('[ESX] Registered vehicle %s for persistence tracking'):format(plate))
    return true
end

-- Function to spawn a persisted vehicle
function ESX.SpawnPersistedVehicle(plate, spawnCoords)
    local result = MySQL.scalar.await('SELECT * FROM vehicle_persistence WHERE plate = ? AND is_spawned = 0', {plate})
    
    if not result then
        return false, "Vehicle not found or already spawned"
    end
    
    local vehicleData = json.decode(result.vehicle_data or '{}')
    local healthData = json.decode(result.health_data or '{}')
    local lastPosition = json.decode(result.last_position or '{}')
    
    -- Use spawn coordinates or last known position
    local coords = spawnCoords or vector3(lastPosition.x or 0, lastPosition.y or 0, lastPosition.z or 0)
    local heading = lastPosition.h or 0.0
    
    -- Spawn the vehicle
    ESX.OneSync.SpawnVehicle(vehicleData.model or 'adder', coords, heading, vehicleData, function(networkId)
        if networkId then
            local vehicle = NetworkGetEntityFromNetworkId(networkId)
            
            if DoesEntityExist(vehicle) then
                -- Apply health data
                if healthData.engineHealth then
                    SetVehicleEngineHealth(vehicle, healthData.engineHealth + 0.0)
                end
                if healthData.bodyHealth then
                    SetVehicleBodyHealth(vehicle, healthData.bodyHealth + 0.0)
                end
                if healthData.tankHealth then
                    SetVehiclePetrolTankHealth(vehicle, healthData.tankHealth + 0.0)
                end
                if healthData.dirtLevel then
                    SetVehicleDirtLevel(vehicle, healthData.dirtLevel + 0.0)
                end
                
                -- Restore inventory if ox_inventory is available
                if Config.OxInventory then
                    if result.trunk_items then
                        local trunkItems = json.decode(result.trunk_items)
                        if trunkItems and next(trunkItems) then
                            exports.ox_inventory:forceOpenInventory('trunk_' .. plate, 'trunk', {
                                netid = networkId,
                                plate = plate
                            })
                            for _, item in pairs(trunkItems) do
                                if item.name and item.count and item.count > 0 then
                                    exports.ox_inventory:AddItem('trunk_' .. plate, item.name, item.count, item.metadata)
                                end
                            end
                        end
                    end
                    
                    if result.glovebox_items then
                        local gloveboxItems = json.decode(result.glovebox_items)
                        if gloveboxItems and next(gloveboxItems) then
                            exports.ox_inventory:forceOpenInventory('glovebox_' .. plate, 'glovebox', {
                                netid = networkId,
                                plate = plate
                            })
                            for _, item in pairs(gloveboxItems) do
                                if item.name and item.count and item.count > 0 then
                                    exports.ox_inventory:AddItem('glovebox_' .. plate, item.name, item.count, item.metadata)
                                end
                            end
                        end
                    end
                end
                
                -- Register for tracking
                ESX.RegisterSpawnedVehicle(vehicle, plate, result.owner)
                
                print(('[ESX] Spawned persisted vehicle %s'):format(plate))
                return vehicle
            end
        end
        
        return false
    end)
    
    return true, "Vehicle spawn initiated"
end

-- PERFORMANCE: Memory-based vehicle location lookup (NO DATABASE!)
function ESX.GetVehicleLocation(plate)
    local cached = vehicleCache[plate]
    
    if cached then
        local pos = cached.lastPosition
        return {
            coords = vector3(pos.x or 0, pos.y or 0, pos.z or 0),
            heading = pos.h or 0.0,
            isSpawned = cached.isSpawned
        }
    end
    
    return nil
end

-- PERFORMANCE: Memory-based ownership check (NO DATABASE!)
function ESX.DoesPlayerOwnVehicle(identifier, plate)
    local cached = vehicleCache[plate]
    return cached and cached.owner == identifier
end

-- PERFORMANCE: Get player's vehicles from memory
function ESX.GetPlayerVehicles(identifier)
    return playerVehicles[identifier] or {}
end

-- Event handlers for vehicle spawning (integrate with existing garage systems)
AddEventHandler('esx:vehicleSpawned', function(playerId, vehicle, plate, vehicleData)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer and DoesEntityExist(vehicle) then
        ESX.RegisterSpawnedVehicle(vehicle, plate, xPlayer.identifier)
    end
end)

-- Clean up when vehicle is deleted
AddEventHandler('entityRemoved', function(entity)
    if trackedVehicles[entity] then
        cleanupVehicleData(entity, trackedVehicles[entity])
    end
end)

print('[ESX] Vehicle Persistence Module loaded')
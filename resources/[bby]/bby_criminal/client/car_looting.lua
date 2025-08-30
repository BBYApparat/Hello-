local ESX = exports['es_extended']:getSharedObject()
local spawnedSuitcases = {}
local vehicleWindows = {} -- Track broken windows
local playerStolenVehicles = {} -- Track which vehicles THIS player has stolen from
local isStealingOrSmashing = false

-- Utility functions
local function DebugPrint(msg)
    if Config.Debug then
        print('^3[bby_carsuitcase] ^7' .. msg)
    end
end

local function DrawDebugMarker(coords)
    if Config.Debug then
        DrawMarker(2, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
    end
end

-- Check if vehicle is valid for suitcase spawn (any parked car)
local function IsVehicleValid(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    
    -- Check if it's a car (not a bike, plane, etc)
    local vehicleClass = GetVehicleClass(vehicle)
    if vehicleClass == 8 or vehicleClass == 13 or vehicleClass == 14 or vehicleClass == 15 or vehicleClass == 16 then
        return false -- Motorcycles, Cycles, Boats, Helicopters, Planes
    end
    
    -- Don't check for driver or speed - we want ALL parked cars
    return true
end

-- Check if vehicle is locked using SimpleCarlock export
local function IsVehicleLocked(vehicle)
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    return lockStatus == 2 or lockStatus == 3 or lockStatus == 4 or lockStatus == 10
end

-- Get vehicle plate
local function GetVehiclePlate(vehicle)
    if not DoesEntityExist(vehicle) then return nil end
    return GetVehicleNumberPlateText(vehicle)
end

-- Check if player has crowbar for window smashing
local function HasCrowbar()
    if Config.UseItemForSmash then
        return exports.ox_inventory:Search('count', Config.WindowSmashItem) > 0
    else
        return HasPedGotWeapon(PlayerPedId(), Config.WindowSmashWeapon, false)
    end
end

-- Spawn suitcase in vehicle
local function SpawnSuitcaseInVehicle(vehicle, forceRespawn)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = GetVehiclePlate(vehicle)
    if not plate then return end
    
    -- Check if THIS PLAYER has already stolen from this vehicle
    if playerStolenVehicles[plate] and not forceRespawn then
        -- Check if cooldown has passed for this player
        if playerStolenVehicles[plate].timestamp then
            local currentTime = GetGameTimer()
            local cooldownTime = playerStolenVehicles[plate].cooldownTime or Config.CarLootCooldown
            
            if (currentTime - playerStolenVehicles[plate].timestamp) < cooldownTime then
                -- Still on cooldown for this player, don't spawn
                return
            else
                -- Cooldown passed, remove from stolen list
                playerStolenVehicles[plate] = nil
            end
        end
    end
    
    -- Check if suitcase already exists for this vehicle (for this player's view)
    if spawnedSuitcases[plate] then
        if DoesEntityExist(spawnedSuitcases[plate].prop) and not forceRespawn then
            return
        elseif DoesEntityExist(spawnedSuitcases[plate].prop) then
            -- Remove old prop if forcing respawn
            DeleteEntity(spawnedSuitcases[plate].prop)
        end
    end
    
    -- IMPORTANT: Set vehicle as mission entity to prevent despawning
    SetEntityAsMissionEntity(vehicle, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
    
    -- Randomly select a suitcase prop
    local randomProp = Config.SuitcaseProps[math.random(#Config.SuitcaseProps)]
    local model = GetHashKey(randomProp)
    lib.requestModel(model)
    
    -- Get vehicle coords for prop creation
    local vehCoords = GetEntityCoords(vehicle)
    
    -- Create suitcase prop
    local suitcase = CreateObject(model, vehCoords.x, vehCoords.y, vehCoords.z, false, false, false)
    
    -- Make sure prop is visible
    SetEntityVisible(suitcase, true)
    SetEntityCollision(suitcase, false, false)
    
    -- Try different attachment method - directly to seat position
    local boneIndex = GetEntityBoneIndexByName(vehicle, 'seat_pside_f')
    if boneIndex == -1 then
        -- Fallback if bone doesn't exist, use offset from vehicle
        AttachEntityToEntity(suitcase, vehicle, 0, 
            0.5, -0.2, 0.3, -- Position offset (passenger side)
            0.0, 0.0, 0.0, -- Rotation
            false, false, false, false, 2, true)
    else
        -- Attach to passenger seat bone
        AttachEntityToEntity(suitcase, vehicle, boneIndex, 
            0.0, 0.0, 0.3, -- Position offset from bone
            0.0, 0.0, 0.0, -- Rotation
            false, false, false, false, 2, true)
    end
    
    -- Store reference
    spawnedSuitcases[plate] = {
        vehicle = vehicle,
        prop = suitcase,
        stolen = false,
        propModel = randomProp
    }
    
    DebugPrint(('Spawned suitcase (%s) in vehicle: %s (Entity: %d)'):format(randomProp, plate, suitcase))
    
    -- Add ox_target interactions
    exports.ox_target:addLocalEntity(vehicle, {
        {
            name = 'steal_suitcase_unlocked',
            icon = 'fas fa-suitcase',
            label = 'Steal Suitcase',
            distance = 2.0,
            canInteract = function(entity, distance, coords, name, bone)
                local vehPlate = GetVehiclePlate(entity)
                if not vehPlate or not spawnedSuitcases[vehPlate] then return false end
                if spawnedSuitcases[vehPlate].stolen then return false end
                if isStealingOrSmashing then return false end
                
                -- Show if unlocked OR window is broken
                if not IsVehicleLocked(entity) or vehicleWindows[vehPlate] then
                    return true
                end
                
                return false
            end,
            onSelect = function(data)
                StealSuitcase(data.entity)
            end
        },
        {
            name = 'smash_window',
            icon = 'fas fa-hammer',
            label = 'Smash Window',
            distance = 2.0,
            canInteract = function(entity, distance, coords, name, bone)
                local vehPlate = GetVehiclePlate(entity)
                if not vehPlate or not spawnedSuitcases[vehPlate] then return false end
                if spawnedSuitcases[vehPlate].stolen then return false end
                if vehicleWindows[vehPlate] then return false end -- Window already broken
                if isStealingOrSmashing then return false end
                
                -- Only show if vehicle is locked and player has crowbar
                if IsVehicleLocked(entity) and HasCrowbar() then
                    return true
                end
                
                return false
            end,
            onSelect = function(data)
                SmashWindow(data.entity)
            end
        }
    })
end

-- Remove suitcase from vehicle (only from this player's view)
local function RemoveSuitcase(plate, keepVehicleTracked)
    if spawnedSuitcases[plate] then
        if DoesEntityExist(spawnedSuitcases[plate].prop) then
            DeleteEntity(spawnedSuitcases[plate].prop)
        end
        
        -- Remove ox_target
        if DoesEntityExist(spawnedSuitcases[plate].vehicle) then
            exports.ox_target:removeLocalEntity(spawnedSuitcases[plate].vehicle, {'steal_suitcase_unlocked', 'smash_window'})
        end
        
        -- Keep vehicle reference if needed for respawn later
        if not keepVehicleTracked then
            spawnedSuitcases[plate] = nil
        else
            spawnedSuitcases[plate].prop = nil
            spawnedSuitcases[plate].hidden = true
        end
        
        DebugPrint('Removed suitcase from vehicle: ' .. plate .. ' (player-specific)')
    end
end

-- Smash window function (separate from stealing)
function SmashWindow(vehicle)
    if isStealingOrSmashing then return end
    
    local plate = GetVehiclePlate(vehicle)
    if not plate or vehicleWindows[plate] then
        return
    end
    
    if not HasCrowbar() then
        lib.notify({
            title = 'Error',
            description = 'You need a crowbar to smash the window!',
            type = 'error'
        })
        return
    end
    
    isStealingOrSmashing = true
    local playerPed = PlayerPedId()
    
    -- Play smash animation
    lib.requestAnimDict(Config.Animations.smashWindow.dict)
    TaskPlayAnim(playerPed, Config.Animations.smashWindow.dict, Config.Animations.smashWindow.anim, 
        8.0, -8.0, Config.SmashTime, Config.Animations.smashWindow.flag, 0, false, false, false)
    
    -- Progress bar for smashing
    if lib.progressBar({
        duration = Config.SmashTime,
        label = 'Smashing window...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Smash successful
        ClearPedTasks(playerPed)
        SmashVehicleWindow(vehicle, 1) -- Passenger window
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
        
        -- Mark window as broken
        vehicleWindows[plate] = true
        
        -- Alert police if configured
        if Config.AlertPolice and math.random() < Config.AlertChance then
            local coords = GetEntityCoords(vehicle)
            TriggerServerEvent('bby_criminal:alertPolice', coords)
        end
        
        lib.notify({
            title = 'Success',
            description = 'Window smashed! You can now steal the suitcase.',
            type = 'success'
        })
    else
        -- Cancelled
        ClearPedTasks(playerPed)
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped smashing the window',
            type = 'error'
        })
    end
    
    isStealingOrSmashing = false
end

-- Steal suitcase function
function StealSuitcase(vehicle)
    if isStealingOrSmashing then return end
    
    local plate = GetVehiclePlate(vehicle)
    if not plate or not spawnedSuitcases[plate] or spawnedSuitcases[plate].stolen then
        return
    end
    
    isStealingOrSmashing = true
    local playerPed = PlayerPedId()
    
    -- Play animation
    lib.requestAnimDict(Config.Animations.stealSuitcase.dict)
    TaskPlayAnim(playerPed, Config.Animations.stealSuitcase.dict, Config.Animations.stealSuitcase.anim, 
        8.0, -8.0, Config.StealTime, Config.Animations.stealSuitcase.flag, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = Config.StealTime,
        label = 'Stealing suitcase...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Success
        ClearPedTasks(playerPed)
        
        -- Mark as stolen for THIS PLAYER only with individual cooldown
        playerStolenVehicles[plate] = {
            timestamp = GetGameTimer(),
            cooldownTime = math.random(Config.CarLootCooldownMin, Config.CarLootCooldownMax) -- Random cooldown per player
        }
        
        -- Remove suitcase from this player's view
        RemoveSuitcase(plate)
        
        -- Give reward
        TriggerServerEvent('bby_criminal:rewardPlayer')
        
        local minutes = math.floor(playerStolenVehicles[plate].cooldownTime / 60000)
        DebugPrint(('Vehicle %s looted by player, cooldown: %d minutes'):format(plate, minutes))
        lib.notify({
            title = 'Success',
            description = 'You stole the suitcase!',
            type = 'success'
        })
    else
        -- Cancelled
        ClearPedTasks(playerPed)
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped stealing the suitcase',
            type = 'error'
        })
    end
    
    isStealingOrSmashing = false
end

-- OPTIMIZED: Only scan vehicles near player
local function ScanForParkedVehicles()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Only get vehicles within reasonable distance
    local vehicles = {}
    local allVehicles = GetGamePool('CVehicle')
    
    for _, vehicle in pairs(allVehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehCoords)
        
        -- Only process vehicles within 150 meters
        if distance <= 150.0 then
            table.insert(vehicles, vehicle)
        end
    end
    
    local suitcaseCount = 0
    local validSuitcases = 0
    for plate, data in pairs(spawnedSuitcases) do
        if DoesEntityExist(data.prop) then
            suitcaseCount = suitcaseCount + 1
            if IsEntityVisible(data.prop) then
                validSuitcases = validSuitcases + 1
            end
        else
            -- Clean up invalid entry
            spawnedSuitcases[plate] = nil
        end
    end
    
    DebugPrint(('Found %d vehicles in world, %d suitcases spawned (%d visible)'):format(#vehicles, suitcaseCount, validSuitcases))
    
    -- Only spawn more if we're below the limit
    if suitcaseCount >= Config.MaxSuitcasesTotal then
        DebugPrint('Max total suitcases reached, skipping spawn')
        return
    end
    
    local vehiclesChecked = 0
    local vehiclesWithSuitcase = 0
    
    -- Process ALL vehicles immediately
    for _, vehicle in pairs(vehicles) do
        if IsVehicleValid(vehicle) then
            vehiclesChecked = vehiclesChecked + 1
            local plate = GetVehiclePlate(vehicle)
            
            -- Skip only if plate is invalid or already has suitcase
            if plate and plate ~= "" and not spawnedSuitcases[plate] then
                -- ALWAYS spawn suitcase (100% chance now)
                SpawnSuitcaseInVehicle(vehicle)
                suitcaseCount = suitcaseCount + 1
                vehiclesWithSuitcase = vehiclesWithSuitcase + 1
                
                if suitcaseCount >= Config.MaxSuitcasesTotal then
                    DebugPrint('Max total suitcases reached')
                    break
                end
            end
        end
    end
    
    DebugPrint(('Checked %d valid vehicles, spawned %d new suitcases'):format(vehiclesChecked, vehiclesWithSuitcase))
end

-- OPTIMIZED: Limited initial spawn near player only
local function InitialSpawn()
    if Config.DisableInitialSpawn then
        DebugPrint('Initial spawn disabled')
        return
    end
    
    Wait(5000) -- Wait for game to stabilize
    DebugPrint('Starting initial suitcase spawn near player...')
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local spawnCount = 0
    local maxInitialSpawn = math.min(30, Config.MaxSuitcasesTotal) -- Limit initial spawn
    
    for _, vehicle in pairs(vehicles) do
        if IsVehicleValid(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehCoords)
            
            -- Only spawn in nearby vehicles initially
            if distance <= 100.0 then
                local plate = GetVehiclePlate(vehicle)
                
                if plate and plate ~= "" and math.random() < Config.SpawnChance then
                    -- Set as mission entity to prevent despawn
                    SetEntityAsMissionEntity(vehicle, true, false)
                    
                    -- Spawn suitcase
                    SpawnSuitcaseInVehicle(vehicle)
                    spawnCount = spawnCount + 1
                    
                    if spawnCount >= maxInitialSpawn then
                        break
                    end
                end
            end
        end
    end
    
    DebugPrint(('Initial spawn complete: %d suitcases spawned'):format(spawnCount))
end

-- Cleanup non-existent vehicles
local function CleanupSuitcases()
    for plate, data in pairs(spawnedSuitcases) do
        if not DoesEntityExist(data.vehicle) then
            -- Vehicle no longer exists, remove suitcase
            RemoveSuitcase(plate)
            vehicleWindows[plate] = nil
        elseif not DoesEntityExist(data.prop) then
            -- Prop no longer exists, cleanup references
            spawnedSuitcases[plate] = nil
            vehicleWindows[plate] = nil
        end
    end
end

-- Note: Car density is now controlled via esx-smallresources/client/density.lua

-- Initial spawn thread
CreateThread(function()
    InitialSpawn()
end)

-- OPTIMIZED: Only keep nearby vehicles from despawning
CreateThread(function()
    while true do
        Wait(15000) -- Check less frequently (15 seconds)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehiclesToProcess = 0
        
        for plate, data in pairs(spawnedSuitcases) do
            if DoesEntityExist(data.vehicle) then
                local vehCoords = GetEntityCoords(data.vehicle)
                local distance = #(playerCoords - vehCoords)
                
                -- Only process vehicles within reasonable distance
                if distance <= 200.0 then
                    vehiclesToProcess = vehiclesToProcess + 1
                    SetEntityAsMissionEntity(data.vehicle, true, false)
                    
                    -- Process max 10 vehicles per cycle to avoid lag
                    if vehiclesToProcess >= 10 then
                        Wait(0) -- Yield to prevent freezing
                        vehiclesToProcess = 0
                    end
                end
            end
        end
    end
end)

-- Check player-specific cooldowns and respawn suitcases when ready
CreateThread(function()
    while true do
        Wait(30000) -- Check every 30 seconds
        
        local currentTime = GetGameTimer()
        local respawnList = {}
        
        -- Check for expired cooldowns
        for plate, data in pairs(playerStolenVehicles) do
            if data.timestamp then
                local cooldownTime = data.cooldownTime or Config.CarLootCooldown
                
                if (currentTime - data.timestamp) > cooldownTime then
                    -- Cooldown expired for this player
                    respawnList[plate] = true
                    playerStolenVehicles[plate] = nil
                    DebugPrint(('Cooldown expired for vehicle %s, respawning suitcase'):format(plate))
                end
            end
        end
        
        -- Respawn suitcases for vehicles that are off cooldown
        for plate, _ in pairs(respawnList) do
            -- Find the vehicle
            local vehicles = GetGamePool('CVehicle')
            for _, vehicle in pairs(vehicles) do
                if GetVehiclePlate(vehicle) == plate then
                    SpawnSuitcaseInVehicle(vehicle, true) -- Force respawn
                    break
                end
            end
        end
    end
end)

-- Main thread for scanning and spawning
CreateThread(function()
    Wait(10000) -- Wait longer for initial spawn to complete
    while true do
        ScanForParkedVehicles()
        CleanupSuitcases()
        
        -- Debug drawing
        if Config.Debug then
            for plate, data in pairs(spawnedSuitcases) do
                if DoesEntityExist(data.vehicle) then
                    local coords = GetEntityCoords(data.vehicle)
                    DrawDebugMarker(coords)
                end
            end
        end
        
        Wait(Config.UpdateInterval)
    end
end)

-- Debug command to manually spawn suitcase in nearest vehicle
if Config.Debug then
    RegisterCommand('testsuitcase', function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearestVehicle = nil
        local nearestDistance = 10.0
        
        local vehicles = GetGamePool('CVehicle')
        for _, vehicle in pairs(vehicles) do
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehCoords)
            if distance < nearestDistance then
                nearestVehicle = vehicle
                nearestDistance = distance
            end
        end
        
        if nearestVehicle then
            local plate = GetVehiclePlate(nearestVehicle)
            print('^2[DEBUG] Forcing suitcase spawn in nearest vehicle: ' .. tostring(plate))
            SpawnSuitcaseInVehicle(nearestVehicle)
        else
            print('^1[DEBUG] No vehicle found nearby')
        end
    end, false)
    
    RegisterCommand('clearsuitcases', function()
        local count = 0
        for plate, _ in pairs(spawnedSuitcases) do
            RemoveSuitcase(plate)
            count = count + 1
        end
        print('^2[DEBUG] Cleared ' .. count .. ' suitcases')
    end, false)
    
    RegisterCommand('checksuitcases', function()
        local count = 0
        local visible = 0
        for plate, data in pairs(spawnedSuitcases) do
            if DoesEntityExist(data.prop) then
                count = count + 1
                if IsEntityVisible(data.prop) then
                    visible = visible + 1
                end
                print(('[DEBUG] Plate: %s, Prop: %s, Entity: %d, Visible: %s'):format(
                    plate, data.propModel, data.prop, tostring(IsEntityVisible(data.prop))
                ))
            end
        end
        print('^2[DEBUG] Total suitcases: ' .. count .. ' (Visible: ' .. visible .. ')')
    end, false)
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for plate, _ in pairs(spawnedSuitcases) do
        RemoveSuitcase(plate)
    end
end)
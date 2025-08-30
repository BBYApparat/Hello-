local ESX = exports['es_extended']:getSharedObject()
local spawnedSuitcases = {}
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

-- Check if vehicle is parked (not moving, no driver)
local function IsVehicleParked(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    
    local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver ~= 0 and driver ~= PlayerPedId() then
        return false
    end
    
    local speed = GetEntitySpeed(vehicle)
    return speed < 0.5
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
local function SpawnSuitcaseInVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = GetVehiclePlate(vehicle)
    if not plate then return end
    
    -- Check if suitcase already exists for this vehicle
    if spawnedSuitcases[plate] then
        if DoesEntityExist(spawnedSuitcases[plate].prop) then
            return
        end
    end
    
    -- Load prop model
    local model = GetHashKey(Config.SuitcaseProp)
    lib.requestModel(model)
    
    -- Create suitcase prop
    local suitcase = CreateObject(model, 0.0, 0.0, 0.0, false, false, false)
    
    -- Attach to passenger seat area
    AttachEntityToEntity(suitcase, vehicle, GetEntityBoneIndexByName(vehicle, 'seat_pside_f'), 
        0.0, -0.2, 0.4, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    
    -- Store reference
    spawnedSuitcases[plate] = {
        vehicle = vehicle,
        prop = suitcase,
        stolen = false
    }
    
    DebugPrint('Spawned suitcase in vehicle: ' .. plate)
    
    -- Add ox_target interaction
    exports.ox_target:addLocalEntity(vehicle, {
        {
            name = 'steal_suitcase',
            icon = 'fas fa-suitcase',
            label = 'Steal Suitcase',
            distance = 2.0,
            canInteract = function(entity, distance, coords, name, bone)
                local vehPlate = GetVehiclePlate(entity)
                if not vehPlate or not spawnedSuitcases[vehPlate] then return false end
                if spawnedSuitcases[vehPlate].stolen then return false end
                if isStealingOrSmashing then return false end
                
                -- Check if vehicle is locked
                if IsVehicleLocked(entity) then
                    return false
                end
                
                return true
            end,
            onSelect = function(data)
                StealSuitcase(data.entity)
            end
        },
        {
            name = 'smash_window',
            icon = 'fas fa-hammer',
            label = 'Smash Window & Steal',
            distance = 2.0,
            canInteract = function(entity, distance, coords, name, bone)
                local vehPlate = GetVehiclePlate(entity)
                if not vehPlate or not spawnedSuitcases[vehPlate] then return false end
                if spawnedSuitcases[vehPlate].stolen then return false end
                if isStealingOrSmashing then return false end
                
                -- Check if vehicle is locked and player has crowbar
                if IsVehicleLocked(entity) and HasCrowbar() then
                    return true
                end
                
                return false
            end,
            onSelect = function(data)
                SmashWindowAndSteal(data.entity)
            end
        }
    })
end

-- Remove suitcase from vehicle
local function RemoveSuitcase(plate)
    if spawnedSuitcases[plate] then
        if DoesEntityExist(spawnedSuitcases[plate].prop) then
            DeleteEntity(spawnedSuitcases[plate].prop)
        end
        
        -- Remove ox_target
        if DoesEntityExist(spawnedSuitcases[plate].vehicle) then
            exports.ox_target:removeLocalEntity(spawnedSuitcases[plate].vehicle, {'steal_suitcase', 'smash_window'})
        end
        
        spawnedSuitcases[plate] = nil
        DebugPrint('Removed suitcase from vehicle: ' .. plate)
    end
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
        spawnedSuitcases[plate].stolen = true
        RemoveSuitcase(plate)
        TriggerServerEvent('bby_carsuitcase:rewardPlayer')
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

-- Smash window and steal function
function SmashWindowAndSteal(vehicle)
    if isStealingOrSmashing then return end
    
    local plate = GetVehiclePlate(vehicle)
    if not plate or not spawnedSuitcases[plate] or spawnedSuitcases[plate].stolen then
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
        -- Smash successful, break the window
        SmashVehicleWindow(vehicle, 1) -- Passenger window
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
        
        -- Alert police if configured
        if Config.AlertPolice and math.random() < Config.AlertChance then
            local coords = GetEntityCoords(vehicle)
            TriggerServerEvent('bby_carsuitcase:alertPolice', coords)
        end
        
        -- Now steal the suitcase
        lib.requestAnimDict(Config.Animations.stealSuitcase.dict)
        TaskPlayAnim(playerPed, Config.Animations.stealSuitcase.dict, Config.Animations.stealSuitcase.anim, 
            8.0, -8.0, Config.SmashStealTime, Config.Animations.stealSuitcase.flag, 0, false, false, false)
        
        if lib.progressBar({
            duration = Config.SmashStealTime,
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
            spawnedSuitcases[plate].stolen = true
            RemoveSuitcase(plate)
            TriggerServerEvent('bby_carsuitcase:rewardPlayer')
            lib.notify({
                title = 'Success',
                description = 'You stole the suitcase!',
                type = 'success'
            })
        else
            -- Cancelled during stealing
            ClearPedTasks(playerPed)
            lib.notify({
                title = 'Cancelled',
                description = 'You stopped stealing the suitcase',
                type = 'error'
            })
        end
    else
        -- Cancelled during smashing
        ClearPedTasks(playerPed)
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped smashing the window',
            type = 'error'
        })
    end
    
    isStealingOrSmashing = false
end

-- Scan for parked vehicles and spawn suitcases
local function ScanForParkedVehicles()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = lib.getNearbyVehicles(playerCoords, Config.SpawnRadius, true)
    
    local suitcaseCount = 0
    for plate, _ in pairs(spawnedSuitcases) do
        if DoesEntityExist(spawnedSuitcases[plate].prop) then
            suitcaseCount = suitcaseCount + 1
        end
    end
    
    if suitcaseCount >= Config.MaxSuitcasesPerArea then
        DebugPrint('Max suitcases reached in area')
        return
    end
    
    for _, vehData in pairs(vehicles) do
        local vehicle = vehData.vehicle
        if IsVehicleParked(vehicle) then
            local plate = GetVehiclePlate(vehicle)
            if plate and not spawnedSuitcases[plate] then
                -- Random chance to spawn suitcase
                if math.random() < Config.SpawnChance then
                    SpawnSuitcaseInVehicle(vehicle)
                    suitcaseCount = suitcaseCount + 1
                    
                    if suitcaseCount >= Config.MaxSuitcasesPerArea then
                        break
                    end
                end
            end
        end
    end
end

-- Cleanup distant suitcases
local function CleanupDistantSuitcases()
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    for plate, data in pairs(spawnedSuitcases) do
        if DoesEntityExist(data.vehicle) then
            local vehCoords = GetEntityCoords(data.vehicle)
            local distance = #(playerCoords - vehCoords)
            
            if distance > Config.SpawnRadius * 2 then
                RemoveSuitcase(plate)
            end
        else
            -- Vehicle no longer exists
            RemoveSuitcase(plate)
        end
    end
end

-- Main thread for scanning and spawning
CreateThread(function()
    while true do
        ScanForParkedVehicles()
        CleanupDistantSuitcases()
        
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

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for plate, _ in pairs(spawnedSuitcases) do
        RemoveSuitcase(plate)
    end
end)
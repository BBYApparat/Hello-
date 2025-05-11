ESX = exports["es_extended"]:getSharedObject()

-- Σημεία spawn για τα οχήματα
local spawnPoints = {
    {
        coords = vector3(226.048355, -791.380249, 30.678345),
        heading = 180.0
    },
    {
        coords = vector3(237.706490, -795.306875, 30.476196),
        heading = 180.0
    }
}

-- Cache system for checking spots
local lastCheckTime = 0
local cachedSpotStatus = { available = false, spot = nil }
local CACHE_DURATION = 5000 -- Cache check duration in milliseconds

-- Check spots using cache
function isAnySpotAvailable()
    local currentTime = GetGameTimer()
    if currentTime - lastCheckTime < CACHE_DURATION then
        return cachedSpotStatus.available, cachedSpotStatus.spot
    end

    lastCheckTime = currentTime
    local vehicles = GetGamePool('CVehicle')
    
    for _, spot in ipairs(spawnPoints) do
        local clearArea = true
        
        for _, vehicle in ipairs(vehicles) do
            if #(GetEntityCoords(vehicle) - spot.coords) < 3.0 then
                clearArea = false
                break
            end
        end
        
        if clearArea then
            cachedSpotStatus.available = true
            cachedSpotStatus.spot = spot
            return true, spot
        end
    end
    
    cachedSpotStatus.available = false
    cachedSpotStatus.spot = nil
    return false, nil
end

-- Find the closest rental vehicle
function findNearbyRentalVehicle(playerCoords, maxDistance)
    local vehicles = GetGamePool('CVehicle')
    local nearestDist = maxDistance or 10.0
    local nearestVeh = nil
    
    for _, veh in ipairs(vehicles) do
        local plate = GetVehicleNumberPlateText(veh)
        if plate:sub(1, 4) == 'RENT' then
            local dist = #(playerCoords - GetEntityCoords(veh))
            if dist < nearestDist then
                nearestDist = dist
                nearestVeh = veh
            end
        end
    end
    
    return nearestVeh
end

-- Using cache. Is there available spot?
function openVehicleMenu()
    local hasSpot, _ = isAnySpotAvailable()
    if not hasSpot then
        lib.notify({
            title = 'Error',
            description = 'All parking spots are occupied',
            type = 'error'
        })
        return
    end

    local options = {}
    for _, vehicle in pairs(Config.Vehicles) do
        options[#options + 1] = {
            title = vehicle.name,
            description = ('Price: $%s'):format(vehicle.price),
            onSelect = function()
                if cachedSpotStatus.available then
                    TriggerServerEvent('rental:rentVehicle', vehicle.name)
                else
                    lib.notify({
                        title = 'Error',
                        description = 'All parking spots are occupied',
                        type = 'error'
                    })
                end
            end
        }
    end

    lib.registerContext({
        id = 'rental_vehicles',
        title = 'Rental Vehicles',
        options = options
    })

    lib.showContext('rental_vehicles')
end

-- Model loading with optimization
function LoadModel(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local timeOut = GetGameTimer() + 5000 -- 5 seconds timeout

        while not HasModelLoaded(hash) do
            if GetGameTimer() >= timeOut then
                return false
            end
            Wait(500) 
        end
    end
    return true
end

-- Setting up NPC and target
function initializeTarget()
    local model = GetHashKey('a_m_m_business_01')
    local coords = vector3(416.7, -1108.92, 29.05)
    
    if not LoadModel(model) then 
        print('Failed to load ped model')
        return 
    end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, 180.0, false, false)
    
    -- Setting up NPC properties all at once for optimization
    local pedModifications = {
        {func = FreezeEntityPosition, args = {ped, true}},
        {func = SetEntityInvincible, args = {ped, true}},
        {func = SetBlockingOfNonTemporaryEvents, args = {ped, true}},
        {func = SetPedCanRagdoll, args = {ped, false}}
    }
    
    for _, mod in ipairs(pedModifications) do
        mod.func(table.unpack(mod.args))
    end

    -- Adding target options
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'rental:getRentedCar',
            label = 'Get Rented Car',
            icon = 'car',
            onSelect = openVehicleMenu
        },
        {
            name = 'rental:checkTime',
            label = 'Check Rented Time Left',
            icon = 'clock',
            onSelect = function()
                TriggerServerEvent('rental:checkTimeLeft')
            end
        },
        {
            name = 'rental:returnVehicle',
            label = 'Return Rented Car',
            icon = 'rotate-left',
            onSelect = function()
                local playerPed = PlayerPedId()
                
                -- Check if player is in vehicle
                if IsPedInAnyVehicle(playerPed, false) then
                    return lib.notify({
                        title = 'Error',
                        description = 'Please exit the vehicle first',
                        type = 'error'
                    })
                end
                
                local playerCoords = GetEntityCoords(playerPed)
                local nearestVeh = findNearbyRentalVehicle(playerCoords, 10.0)
                
                if nearestVeh then
                    -- Store the vehicle network ID
                    local netId = NetworkGetNetworkIdFromEntity(nearestVeh)
                    -- Trigger the return event with the network ID
                    TriggerServerEvent('rental:returnVehicle', netId)
                else
                    lib.notify({
                        title = 'Error',
                        description = 'Could not find your rental vehicle nearby',
                        type = 'error'
                    })
                end
            end
        }
    })

    SetModelAsNoLongerNeeded(model)
    
    -- Cleanup on resource stop
    AddEventHandler('onResourceStop', function(resourceName)
        if GetCurrentResourceName() == resourceName then
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
    end)
end

-- Vehicle spawn handling
RegisterNetEvent('rental:spawnVehicle')
AddEventHandler('rental:spawnVehicle', function(model)
    local hash = GetHashKey(model)
    if not LoadModel(hash) then
        lib.notify({
            title = 'Error',
            description = 'Failed to load vehicle model',
            type = 'error'
        })
        TriggerServerEvent('rental:cancelRental')
        return
    end

    local hasSpot, spot = isAnySpotAvailable()
    if not hasSpot then
        lib.notify({
            title = 'Error',
            description = 'All parking spots are occupied',
            type = 'error'
        })
        TriggerServerEvent('rental:cancelRental')
        SetModelAsNoLongerNeeded(hash)
        return
    end

    local vehicle = CreateVehicle(hash, spot.coords.x, spot.coords.y, spot.coords.z, spot.heading, true, false)
    SetVehicleNumberPlateText(vehicle, 'RENT' .. math.random(100, 999))
    
    -- Documenting vehicle properties in batch
    local entityEnhancements = {
        {func = SetVehicleDirtLevel, args = {vehicle, 0.0}},
        {func = SetEntityAsMissionEntity, args = {vehicle, true, true}},
        {func = SetVehicleHasBeenOwnedByPlayer, args = {vehicle, true}},
    }
    
    for _, enhancement in ipairs(entityEnhancements) do
        enhancement.func(table.unpack(enhancement.args))
    end
    
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    -- Clearing Cache
    SetModelAsNoLongerNeeded(hash)
end)

-- Initialize the system
CreateThread(function()
    initializeTarget()
end)

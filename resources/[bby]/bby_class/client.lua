-- Initialize variables
local ESX = exports.es_extended:getSharedObject()
local pursuitModeActive = false
local currentPursuitClass = nil
local lastVehicle = nil

-- Add missing IsPolice function
function IsPolice()
    if not ESX or not ESX.PlayerData or not ESX.PlayerData.job then
        return false
    end
    
    local jobName = ESX.PlayerData.job.name
    return jobName == 'police' or jobName == 'sheriff'
end

-- Pursuit mode configuration
local PursuitModes = {
    ["C"] = {
        name = "CAUTIOUS",
        speedMultiplier = 1.05,      -- 5% boost
        accelerationMultiplier = 1.05,
        handling = 1.02,             -- 2% handling improvement
        braking = 1.05,              -- 5% braking improvement 
        color = {r = 0, g = 255, b = 0}, -- Green
    },
    ["B"] = {
        name = "BASIC",
        speedMultiplier = 1.1,       -- 10% boost
        accelerationMultiplier = 1.1,
        handling = 1.05,             -- 5% handling improvement
        braking = 1.1,               -- 10% braking improvement 
        color = {r = 0, g = 150, b = 255}, -- Light blue
    },
    ["A"] = {
        name = "ADVANCED",
        speedMultiplier = 1.2,       -- 20% boost
        accelerationMultiplier = 1.15,
        handling = 1.1,              -- 10% handling improvement
        braking = 1.15,              -- 15% braking improvement
        color = {r = 255, g = 165, b = 0}, -- Orange
    },
    ["S"] = {
        name = "SUPERIOR", 
        speedMultiplier = 1.3,       -- 30% boost
        accelerationMultiplier = 1.2,
        handling = 1.15,             -- 15% handling improvement
        braking = 1.2,               -- 20% braking improvement
        color = {r = 255, g = 0, b = 0}, -- Red
    }
}

-- Police vehicles that can use pursuit mode
local PursuitVehicles = {
    -- Standard patrol vehicles
    ["police"] = true,
    ["police2"] = true,
    ["police3"] = true,
    ["police4"] = true,
    ["sheriff"] = true,
    ["sheriff2"] = true,
    
    -- Specialty vehicles
    ["fbi"] = true,
    ["fbi2"] = true,
    ["policeb"] = true,
    ["policeold1"] = true,
    ["policeold2"] = true,
    ["policet"] = true,
    ["riot"] = true,
    ["polmav"] = true
}

-- Check if vehicle is a police vehicle
function IsPoliceVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    local displayName = GetDisplayNameFromVehicleModel(model):lower()
    return PursuitVehicles[displayName] or false
end

-- Register events for each pursuit class
RegisterNetEvent('bby_class:turntoSClass')
AddEventHandler('bby_class:turntoSClass', function()
    TogglePursuitMode("S")
end)

RegisterNetEvent('bby_class:turntoAClass')
AddEventHandler('bby_class:turntoAClass', function()
    TogglePursuitMode("A")
end)

RegisterNetEvent('bby_class:turntoBClass')
AddEventHandler('bby_class:turntoBClass', function()
    TogglePursuitMode("B")
end)

RegisterNetEvent('bby_class:turntoCClass')
AddEventHandler('bby_class:turntoCClass', function()
    TogglePursuitMode("C")
end)

RegisterNetEvent('bby_class:disablePursuit')
AddEventHandler('bby_class:disablePursuit', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        DeactivatePursuitMode(veh)
    else
        lib.notify({
            title = 'Pursuit Mode',
            description = 'You need to be in a vehicle',
            type = 'error'
        })
    end
end)

-- Main pursuit mode toggle function
function TogglePursuitMode(pursuitClass)
    local ped = PlayerPedId()
    
    -- Check if player is in a vehicle
    if not IsPedInAnyVehicle(ped, false) then
        lib.notify({
            title = 'Pursuit Mode',
            description = 'You need to be in a vehicle',
            type = 'error'
        })
        return
    end
    
    local veh = GetVehiclePedIsIn(ped, false)
    
    -- Check if player is the driver
    if GetPedInVehicleSeat(veh, -1) ~= ped then
        lib.notify({
            title = 'Pursuit Mode',
            description = 'Only the driver can activate pursuit mode',
            type = 'error'
        })
        return
    end
    
    -- Check if player is police
    if not IsPolice() then
        lib.notify({
            title = 'Pursuit Mode',
            description = 'Only law enforcement can use pursuit mode',
            type = 'error'
        })
        return
    end
    
    -- Check if vehicle is a police vehicle
    if not IsPoliceVehicle(veh) then
        lib.notify({
            title = 'Pursuit Mode',
            description = 'This vehicle does not support pursuit mode',
            type = 'error'
        })
        return
    end
    
    -- Activate the selected pursuit class
    ActivatePursuitMode(veh, pursuitClass)
end

-- Activate pursuit mode function
function ActivatePursuitMode(vehicle, pursuitClass)
    -- Get pursuit settings based on class
    local pursuitSettings = PursuitModes[pursuitClass]
    
    -- If already in pursuit mode, deactivate first
    if pursuitModeActive then
        DeactivatePursuitMode(vehicle)
        Wait(200) -- Short delay for clean transition
    end
    
    -- Store state
    currentPursuitClass = pursuitClass
    lastVehicle = vehicle
    pursuitModeActive = true
    
    -- Apply vehicle modifications
    SetVehicleModKit(vehicle, 0)
    
    -- Improve engine power
    SetVehicleEnginePowerMultiplier(vehicle, pursuitSettings.speedMultiplier * 20.0)
    
    -- Improve acceleration
    SetVehicleEngineTorqueMultiplier(vehicle, pursuitSettings.accelerationMultiplier)
    
    -- Improve handling
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", 
        GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax") * pursuitSettings.handling)
    
    -- Improve braking
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", 
        GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce") * pursuitSettings.braking)
    
    -- Visual feedback - flash headlights
    for i=1, 3 do
        SetVehicleLights(vehicle, 2)
        Wait(100)
        SetVehicleLights(vehicle, 0)
        Wait(100)
    end
    
    -- Audio feedback
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    
    -- Notify
    local boostText = math.floor((pursuitSettings.speedMultiplier - 1.0) * 100) .. "%"
    lib.notify({
        title = 'Pursuit Mode Activated',
        description = pursuitSettings.name .. ' - Boost: ' .. boostText,
        type = 'success'
    })
    
    -- Sync with other players
    TriggerServerEvent('bby_class:server:syncActivation', NetworkGetNetworkIdFromEntity(vehicle), pursuitClass)
end

-- Deactivate pursuit mode function
function DeactivatePursuitMode(vehicle)
    if not currentPursuitClass or not pursuitModeActive then return end
    
    -- Reset vehicle performance
    SetVehicleModKit(vehicle, 0)
    SetVehicleEnginePowerMultiplier(vehicle, 1.0)
    SetVehicleEngineTorqueMultiplier(vehicle, 1.0)
    
    -- Reset handling to default 
    local handlingMultiplier = 1.0 / PursuitModes[currentPursuitClass].handling
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", 
        GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax") * handlingMultiplier)
    
    -- Reset braking
    local brakingMultiplier = 1.0 / PursuitModes[currentPursuitClass].braking
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", 
        GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce") * brakingMultiplier)
    
    -- Audio feedback
    PlaySoundFrontend(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    
    -- Notify
    lib.notify({
        title = 'Pursuit Mode',
        description = 'Deactivated',
        type = 'error'
    })
    
    -- Reset state
    pursuitModeActive = false
    
    -- Sync with other players
    TriggerServerEvent('bby_class:server:syncDeactivation', NetworkGetNetworkIdFromEntity(vehicle))
    
    -- Clear variables
    currentPursuitClass = nil
    lastVehicle = nil
end

-- Display pursuit mode status and handle auto-deactivation
Citizen.CreateThread(function()
    while true do
        local sleep = 1000 -- Default longer sleep
        
        if pursuitModeActive and currentPursuitClass then
            sleep = 0 -- No sleep when active
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                
                -- Deactivate if player switched vehicles
                if veh ~= lastVehicle then
                    DeactivatePursuitMode(lastVehicle)
                    lib.notify({
                        title = 'Pursuit Mode',
                        description = 'Deactivated - Vehicle Changed',
                        type = 'error'
                    })
                elseif GetPedInVehicleSeat(veh, -1) == ped then
                    -- Only display 3D text when player is driver
                    local pursuitSettings = PursuitModes[currentPursuitClass]
                    local color = pursuitSettings.color
                    
                    -- Get vehicle position for 3D text (above vehicle)
                    local vehCoords = GetEntityCoords(veh)
                    local boostText = "+" .. math.floor((pursuitSettings.speedMultiplier - 1.0) * 100) .. "%"
                    
                    -- Draw 3D text above vehicle
                    DrawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 1.2, 
                        "~" .. RGBToHex(color.r, color.g, color.b) .. "~PURSUIT: " .. pursuitSettings.name .. " " .. boostText)
                else
                    -- Deactivate if no longer the driver
                    DeactivatePursuitMode(veh)
                    lib.notify({
                        title = 'Pursuit Mode',
                        description = 'Deactivated - No Longer Driver',
                        type = 'error'
                    })
                end
                
                -- Check if engine is off
                if not GetIsVehicleEngineRunning(veh) and pursuitModeActive then
                    DeactivatePursuitMode(veh)
                    lib.notify({
                        title = 'Pursuit Mode',
                        description = 'Deactivated - Engine Off',
                        type = 'error'
                    })
                end
            else
                -- Auto-deactivate if player exits vehicle
                DeactivatePursuitMode(lastVehicle)
                lib.notify({
                    title = 'Pursuit Mode',
                    description = 'Deactivated - Left Vehicle',
                    type = 'error'
                })
            end
        end
        
        Wait(sleep)
    end
end)

-- Convert RGB to hex for text color
function RGBToHex(r, g, b)
    if r < 0 then r = 0 elseif r > 255 then r = 255 end
    if g < 0 then g = 0 elseif g > 255 then g = 255 end
    if b < 0 then b = 0 elseif b > 255 then b = 255 end
    
    -- There's no actual hex in GTA text, so we use letter codes
    if r == 255 and g == 0 and b == 0 then
        return "r" -- Red
    elseif r == 0 and g == 255 and b == 0 then
        return "g" -- Green
    elseif r == 0 and g == 150 and b == 255 then
        return "b" -- Blue
    elseif r == 255 and g == 165 and b == 0 then
        return "o" -- Orange
    else
        return "w" -- Default to white
    end
end

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end

-- Sync pursuit mode activation from other players
RegisterNetEvent('bby_class:client:syncActivation')
AddEventHandler('bby_class:client:syncActivation', function(netId, pursuitClass)
    local veh = NetworkGetEntityFromNetworkId(netId)
    
    -- Skip if it's our own vehicle (we already handled it locally)
    if veh == lastVehicle and pursuitModeActive then return end
    
    -- Visual feedback for other players
    if DoesEntityExist(veh) and IsEntityAVehicle(veh) then
        -- Flash headlights to show activation
        for i=1, 3 do
            SetVehicleLights(veh, 2)
            Wait(100)
            SetVehicleLights(veh, 0)
            Wait(100)
        end
    end
end)

-- Make sure the ESX job updates are reflected
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if ESX and ESX.PlayerData then
        ESX.PlayerData.job = job
    end
end)

-- Server events (server.lua will need to be created separately)
-- These help with syncing pursuit mode between players
RegisterNetEvent('bby_class:client:syncDeactivation')
AddEventHandler('bby_class:client:syncDeactivation', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    
    -- Skip if it's our own vehicle (we already handled it locally)
    if veh == lastVehicle and not pursuitModeActive then return end
end)
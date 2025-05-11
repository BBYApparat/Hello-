ESX = exports['es_extended']:getSharedObject()
PlayerData = {}

Citizen.CreateThread(function()
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
    Init()
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded', function()
    PlayerData = ESX.GetPlayerData()
end)

Notify = function(msg, type)
    if type == 'success' then
        ESX.ShowNotification('~g~'..msg)
    elseif type == 'warning' then
        ESX.ShowNotification('~y~'..msg)
    elseif type == 'error' then
        ESX.ShowNotification('~r~'..msg)
    else
        ESX.ShowNotification('~b~'..msg)
    end
    NotifyNui(msg, type)
end

GetVehicleProperties = function(vehicle)
    local prop = ESX.Game.GetVehicleProperties(vehicle)
    if GetResourceState('LegacyFuel') == 'started' then
        prop.fuelLevel = exports['LegacyFuel']:GetFuel(vehicle)
    elseif GetResourceState('ps-fuel') == 'started' then
        prop.fuelLevel = exports['ps-fuel']:GetFuel(vehicle)
    elseif GetResourceState('esx_fuel') == 'started' then
        prop.fuelLevel = exports['esx_fuel']:GetFuel(vehicle)
    end
    return prop
end

GetPlate = function(vehicle)
    return vehicle and DoesEntityExist(vehicle) and (string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')) or ''
end

GetSpawnPointVehicles = function(coords, radius, ignore)
    coords = vector3(coords.x, coords.y, coords.z)
    local vehicles = GetGamePool('CVehicle')
    local closeVeh = {}
    for i = 1, #vehicles, 1 do
        if not ignore or (ignore and vehicles[i] ~= ignore) then
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance = #(vehicleCoords - coords)
            if distance <= radius then
                closeVeh[#closeVeh + 1] = VehToNet(vehicles[i])
            end
        end
    end
    return closeVeh
end
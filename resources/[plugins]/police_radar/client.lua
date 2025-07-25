local ESX = exports["es_extended"]:getSharedObject()
local radarActive = false
local helicopters = {}

local function GetPlayerJob()
    local playerData = ESX.GetPlayerData()
    return playerData.job and playerData.job.name or nil
end

local function IsPolice()
    local job = GetPlayerJob()
    return job == 'police' or job == 'sheriff'
end

local function GetHelicopterColor(ped)
    if not ped or not DoesEntityExist(ped) then
        return 'red'
    end
    
    local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    if playerServerId == -1 then
        return 'red'
    end
    
    ESX.TriggerServerCallback('police_radar:getPlayerJob', function(job)
        if job == 'police' or job == 'sheriff' then
            return 'blue'
        elseif job == 'ambulance' then
            return 'green'
        else
            return 'red'
        end
    end, playerServerId)
end

local function UpdateHelicopters()
    helicopters = {}
    
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and IsVehicleModel(vehicle, GetHashKey("polmav")) or 
           IsVehicleModel(vehicle, GetHashKey("buzzard")) or
           IsVehicleModel(vehicle, GetHashKey("buzzard2")) or
           IsVehicleModel(vehicle, GetHashKey("maverick")) or
           IsVehicleModel(vehicle, GetHashKey("frogger")) or
           IsVehicleModel(vehicle, GetHashKey("seasparrow")) or
           IsVehicleModel(vehicle, GetHashKey("supervolito")) or
           IsVehicleModel(vehicle, GetHashKey("swift")) then
            
            local coords = GetEntityCoords(vehicle)
            local playerId = GetPlayerServerId(player)
            local playerName = GetPlayerName(player)
            
            ESX.TriggerServerCallback('police_radar:getPlayerJob', function(job)
                local color = 'red'
                if job == 'police' or job == 'sheriff' then
                    color = 'blue'
                elseif job == 'ambulance' then
                    color = 'green'
                end
                
                table.insert(helicopters, {
                    id = playerId,
                    name = playerName,
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    color = color
                })
            end, playerId)
        end
    end
end

local function OpenRadarMap()
    if not IsPolice() then
        ESX.ShowNotification('~r~Access Denied: Police Only')
        return
    end
    
    UpdateHelicopters()
    radarActive = true
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openRadar',
        helicopters = helicopters
    })
end

local function CloseRadarMap()
    radarActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeRadar'
    })
end

RegisterNUICallback('closeRadar', function(data, cb)
    CloseRadarMap()
    cb('ok')
end)

RegisterNUICallback('updateRadar', function(data, cb)
    if radarActive then
        UpdateHelicopters()
        cb(helicopters)
    else
        cb({})
    end
end)

RegisterNetEvent('police_radar:openMap')
AddEventHandler('police_radar:openMap', function()
    OpenRadarMap()
end)

Citizen.CreateThread(function()
    local radarProp = CreateObject(GetHashKey('prop_radar_01'), 445.0, -981.0, 30.0, false, false, false)
    SetEntityHeading(radarProp, 0.0)
    FreezeEntityPosition(radarProp, true)
    
    exports.ox_target:addLocalEntity(radarProp, {
        {
            name = 'police_radar',
            icon = 'fas fa-radar',
            label = 'Access Police Radar',
            canInteract = function()
                return IsPolice()
            end,
            onSelect = function()
                OpenRadarMap()
            end
        }
    })
end)

Citizen.CreateThread(function()
    while true do
        if radarActive then
            UpdateHelicopters()
            SendNUIMessage({
                type = 'updateHelicopters',
                helicopters = helicopters
            })
        end
        Citizen.Wait(2000)
    end
end)
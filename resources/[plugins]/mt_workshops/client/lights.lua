local defaultMods = {}
local vehicle = nil

openLightsController = function()
    if not IsPedInAnyVehicle(cache.ped, false) then notify(locale('notify_error_no_vehicle_in'), 'error') return end
    vehicle = GetVehiclePedIsIn(cache.ped, false)
    defaultMods = getVehicleMods(vehicle)
    local nr, ng, nb = GetVehicleNeonLightsColour(vehicle)
    local enabled, xr, xg, xb = GetVehicleXenonLightsCustomColor(vehicle)
    SendNUI('lightsMenu', {
        neons = string.format("rgb(%s, %s, %s)", nr and nr or 255, ng and ng or 255, nb and nb or 255),
        xenons = string.format("rgb(%s, %s, %s)", xr and xr or 255, xg and xg or 255, xb and xb or 255),
        defaultColors = Config.neonsColors,
        xenonsEnabled = IsToggleModOn(vehicle, 22) and true or false,
        neonsEnabled = IsVehicleNeonLightEnabled(vehicle, 2) and true or false,
    })
    ShowNUI('setVisibleLightsMenu', true)
end
exports("openLightsController", openLightsController)
lib.callback.register('mt_workshops:client:openLightsController', openLightsController)

RegisterNuiCallback('installLights', function(data, cb)
    if data.type == 'neons' then
        for i = 0, 4 do
            SetVehicleNeonLightEnabled(vehicle, i, data.enabled)
        end
    else
        ToggleVehicleMod(vehicle, 22, data.enabled)
    end
    cb(true)
end)

RegisterNuiCallback('lightsChange', function(data, cb)
    local r, g, b = string.match(data.color, "rgb%((%d+), (%d+), (%d+)%)")
    if data.type == 'neons' then
        SetVehicleNeonLightsColour(vehicle, tonumber(r), tonumber(g), tonumber(b))
    else
        SetVehicleXenonLightsCustomColor(vehicle, tonumber(r), tonumber(g), tonumber(b))
    end
    cb(true)
end)

RegisterNuiCallback('closeLightsMenu', function(data, cb)
    ShowNUI('setVisibleLightsMenu', false)
    local newMods = getVehicleMods(vehicle)
    setVehicleMods(vehicle, defaultMods)
    cb(true)
end)

RegisterNuiCallback('saveLights', function(data, cb)
    ShowNUI('setVisibleLightsMenu', false)
    local newMods = getVehicleMods(vehicle)
    TriggerServerEvent('mt_workshops:server:setVehicleMods', VehToNet(vehicle), newMods, cache.serverId)
    vehicle = nil
    defaultMods = {}
    cb(true)
end)

RegisterNetEvent('mt_workshops:client:setVehicleMods', function(vehicle, newMods, player)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    setVehicleMods(NetToVeh(vehicle), newMods)
    if cache.serverId == player then
        lib.callback.await('mt_workshops:server:saveVehicleMods', false, NetToVeh(vehicle), newMods)
    end
end)
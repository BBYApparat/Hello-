local vehicle = nil
local defaultMods = nil

openExtrasMenu = function()
    if not IsPedInAnyVehicle(cache.ped, false) then notify(locale('notify_error_no_vehicle_in'), 'error') return end
    local extras = {}
    vehicle = GetVehiclePedIsIn(cache.ped, false)
    defaultMods = getVehicleMods(vehicle)
    for i = 0, 50 do
        if DoesExtraExist(vehicle, i) then
            extras[#extras + 1] = { id = i, label = locale('ui_extra_option', i), enabled = IsVehicleExtraTurnedOn(vehicle, i) }
        end
    end
    SendNUI('extrasMenu', { extras = extras })
    ShowNUI('setVisibleExtrasMenu', true)
end
lib.callback.register('mt_workshops:client:openExtrasMenu', openExtrasMenu)
exports('openExtrasMenu', openExtrasMenu)

RegisterNuiCallback('enableExtra', function(data, cb)
    if IsVehicleExtraTurnedOn(vehicle, tonumber(data.id)) then
        SetVehicleExtra(vehicle, tonumber(data.id), true)
    else
        SetVehicleExtra(vehicle, tonumber(data.id), false)
    end
    local extras = {}
    for i = 0, 50 do
        if DoesExtraExist(vehicle, i) then
            extras[#extras + 1] = { id = i, label = locale('ui_extra_option', i), enabled = IsVehicleExtraTurnedOn(vehicle, i) }
        end
    end
    SendNUI('extrasMenu', { extras = extras })
    cb(true)
end)

RegisterNuiCallback('closeExtrasMenu', function(data, cb)
    ShowNUI('setVisibleExtrasMenu', false)
    local newMods = getVehicleMods(vehicle)
    setVehicleMods(vehicle, defaultMods)
    cb(true)
end)

RegisterNuiCallback('saveExtras', function(data, cb)
    ShowNUI('setVisibleExtrasMenu', false)
    local newMods = getVehicleMods(vehicle)
    TriggerServerEvent('mt_workshops:server:setVehicleMods', VehToNet(vehicle), newMods, cache.serverId)
    vehicle = nil
    defaultMods = {}
    cb(true)
end)
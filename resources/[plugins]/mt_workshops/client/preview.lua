local inPreview = false
local previewVehicle = nil
local previewDefaultMods = nil

---@param value any
---@return string
getColorLabel = function(value)
    for pk, pv in pairs(Config.paints) do
        for p2k, p2v in pairs(Config.paints[pk]) do
            if p2v.value == value then return p2v.label end
        end
    end
    return ''
end

openPreviewMenu = function()
    if inPreview then return end
    local vehicleCosmetics = {}
    local cosmetics = {}
    if not ((Config.preview.lockJob and insideZone[getPlayerJob()]) or (not Config.preview.lockJob and insideZoneNoJob)) then notify(locale('notify_error_inside_zone'), 'error') return end
    if not IsPedInAnyVehicle(cache.ped, false) then notify(locale('notify_error_no_vehicle_in'), 'error') return end
    inPreview = true
    previewVehicle = GetVehiclePedIsIn(cache.ped, false)
    FreezeEntityPosition(previewVehicle, true)
    SetVehicleModKit(previewVehicle, 0)
    previewDefaultMods = getVehicleMods(previewVehicle)
    previewDefaultMods.windowTint = (GetVehicleWindowTint(previewVehicle) > -1) and GetVehicleWindowTint(previewVehicle) or 0
    for k, v in pairs(Config.cosmetics) do
        if v.value == 23 or v.value == 24 then SetVehicleWheelType(previewVehicle, Config.rimsCategory[1].value) end
        if v.value == 'paints' then
            local colors = {
                dashboard = GetVehicleDashboardColour(previewVehicle),
                interior = GetVehicleInteriorColour(previewVehicle)
            }
            colors.primary, colors.secoundary = GetVehicleColours(previewVehicle)
            colors.pearl, colors.wheels = GetVehicleExtraColours(previewVehicle)
            cosmetics[#cosmetics + 1] = v
            for _, p in pairs(Config.paints[Config.paintsTypes[1].value]) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = p.label,
                    value = p.value,
                    selected = (colors[Config.paintsCategory[1].value] == p.value)
                }
            end
        elseif v.value == 'windowTint' then
            cosmetics[#cosmetics + 1] = v
            for _, w in pairs(Config.windowTint) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = w.label,
                    value = w.value,
                    selected = (GetVehicleWindowTint(previewVehicle) == w.value)
                }
            end
        elseif v.value == 'plates' then
            cosmetics[#cosmetics + 1] = v
            for _, p in pairs(Config.plates) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = p.label,
                    value = p.value,
                    selected = (GetVehicleNumberPlateTextIndex(previewVehicle) == p.value)
                }
            end
        elseif v.value == 14 then
            cosmetics[#cosmetics + 1] = v
            for _, h in pairs(Config.horns) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = h.label,
                    value = h.value,
                    selected = (GetVehicleMod(previewVehicle, v.value) == h.value)
                }
            end
        else
            if GetNumVehicleMods(previewVehicle, v.value) > 0 then
                cosmetics[#cosmetics + 1] = v
                for i = -1, (GetNumVehicleMods(previewVehicle, v.value) - 1) do
                    local modLabel = string.format("%s - %s", (i + 1), GetLabelText(GetModTextLabel(previewVehicle, v.value, i)))
                    vehicleCosmetics[#vehicleCosmetics + 1] = {
                        category = v.value,
                        label =  (i == -1) and 'Stock' or (modLabel == "NULL" or modLabel == nil) and locale('ui_custom') or modLabel,
                        value = i,
                        selected = (GetVehicleMod(previewVehicle, v.value) == i)
                    }
                end
            end
        end
    end
    SendNUI('helpMenu', {})
    SendNUI('previewMenu', { categories = cosmetics, options = vehicleCosmetics, wheelsCategory = Config.rimsCategory, paintsTypes = Config.paintsTypes, paintsCategory = Config.paintsCategory })
    ShowNUI('setVisiblePreviewMenu', true)
end
exports('openPreviewMenu', openPreviewMenu)
RegisterNetEvent('mt_workshops:client:openPreviewMenu', openPreviewMenu)

CreateThread(function()
    while true do
        if inPreview then
            DisableControlAction(0, 75, true)
            Wait(1)
        else Wait(1000) end
    end
end)

RegisterNuiCallback('refreshOptions', function(data, cb)
    local vehicleCosmetics = {}
    for k, v in pairs(Config.cosmetics) do
        if v.value == 23 or v.value == 24 then SetVehicleWheelType(previewVehicle, data.wheelsValue) end
        if v.value == 'paints' then
            local colors = {
                dashboard = GetVehicleDashboardColour(previewVehicle),
                interior = GetVehicleInteriorColour(previewVehicle)
            }
            colors.primary, colors.secoundary = GetVehicleColours(previewVehicle)
            colors.pearl, colors.wheels = GetVehicleExtraColours(previewVehicle)
            for _, p in pairs(Config.paints[data.paintsValue]) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = p.label,
                    value = p.value,
                    selected = (colors[data.selectedPaintCategory] == p.value)
                }
            end
        else
            if GetNumVehicleMods(previewVehicle, v.value) > 0 then
                for i = -1, (GetNumVehicleMods(previewVehicle, v.value) - 1) do
                    local modLabel = string.format("%s - %s", (i + 1), GetLabelText(GetModTextLabel(previewVehicle, v.value, i)))
                    vehicleCosmetics[#vehicleCosmetics + 1] = {
                        category = v.value,
                        label =  (i == -1) and 'Stock' or (modLabel == "NULL" or modLabel == nil) and locale('ui_custom') or modLabel,
                        value = i,
                        selected = (GetVehicleMod(previewVehicle, v.value) == i)
                    }
                end
            end
        end
    end
    SendNUI('previewMenuUpdateOptions', { options = vehicleCosmetics })
    cb(true)
end)

RegisterNuiCallback('activeCamera', function(data, cb)
    ShowNUI('setVisiblePreviewMenu', false)
    ShowNUI('setVisibleHelpMenu', true)
    SetNuiFocus(false, false)
    CreateThread(function()
        while true do
            if IsControlJustPressed(0, 202) then
                ShowNUI('setVisiblePreviewMenu', true)
                ShowNUI('setVisibleHelpMenu', false)
                SetNuiFocus(true, true)
                break
            end
            Wait(1)
        end
    end)
    cb(true)
end)

RegisterNuiCallback('chooseMod', function(data, cb)
    local paintCategory = data.selectedPaintCategory
    if data.category == 'paints' then
        local primary, secoundary = GetVehicleColours(previewVehicle)
        local pearl, wheels = GetVehicleExtraColours(previewVehicle)
        local dashboard = GetVehicleDashboardColour(previewVehicle)
        local interior = GetVehicleInteriorColour(previewVehicle)
        if paintCategory == 'primary' then
            ClearVehicleCustomPrimaryColour(previewVehicle)
            SetVehicleColours(previewVehicle, data.value, secoundary)
        elseif paintCategory == 'secoundary' then
            ClearVehicleCustomSecondaryColour(previewVehicle)
            SetVehicleColours(previewVehicle, primary, data.value)
        elseif paintCategory == 'pearl' then
            SetVehicleExtraColours(previewVehicle, data.value, wheels)
        elseif paintCategory == 'wheels' then
            SetVehicleExtraColours(previewVehicle, pearl, data.value)
        elseif paintCategory == 'dashboard' then
            SetVehicleDashboardColor(previewVehicle, data.value)
        elseif paintCategory == 'interior' then
            SetVehicleInteriorColor(previewVehicle, data.value)
        end
    elseif data.category == 'windowTint' then
        SetVehicleWindowTint(previewVehicle, data.value)
    elseif data.category == 'plates' then
        SetVehicleNumberPlateTextIndex(previewVehicle, data.value)
    else
        SetVehicleMod(previewVehicle, data.category, data.value, false)
    end
    local vehicleCosmetics = {}
    for k, v in pairs(Config.cosmetics) do
        if v.value == 'paints' then
            local colors = {
                dashboard = GetVehicleDashboardColour(previewVehicle),
                interior = GetVehicleInteriorColour(previewVehicle)
            }
            colors.primary, colors.secoundary = GetVehicleColours(previewVehicle)
            colors.pearl, colors.wheels = GetVehicleExtraColours(previewVehicle)
            for _, p in pairs(Config.paints[data.selectedPaintType]) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = p.label,
                    value = p.value,
                    selected = (colors[paintCategory] == p.value)
                }
            end
        elseif v.value == 'windowTint' then
            for _, w in pairs(Config.windowTint) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = w.label,
                    value = w.value,
                    selected = (GetVehicleWindowTint(previewVehicle) == w.value)
                }
            end
        elseif v.value == 'plates' then
            for _, p in pairs(Config.plates) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = p.label,
                    value = p.value,
                    selected = (GetVehicleNumberPlateTextIndex(previewVehicle) == p.value)
                }
            end
        elseif v.value == 14 then
            for _, h in pairs(Config.horns) do
                vehicleCosmetics[#vehicleCosmetics + 1] = {
                    category = v.value,
                    label = h.label,
                    value = h.value,
                    selected = (GetVehicleMod(previewVehicle, v.value) == h.value)
                }
            end
        else
            if GetNumVehicleMods(previewVehicle, v.value) > 0 then
                for i = -1, (GetNumVehicleMods(previewVehicle, v.value) - 1) do
                    local modLabel = string.format("%s - %s", (i + 1), GetLabelText(GetModTextLabel(previewVehicle, v.value, i)))
                    vehicleCosmetics[#vehicleCosmetics + 1] = {
                        category = v.value,
                        label =  (i == -1) and 'Stock' or (modLabel == "NULL" or modLabel == nil) and locale('ui_custom') or modLabel,
                        value = i,
                        selected = (GetVehicleMod(previewVehicle, v.value) == i)
                    }
                end
            end
        end
    end
    SendNUI('previewMenuUpdateOptions', { options = vehicleCosmetics })
    cb(true)
end)

RegisterNuiCallback('finishPreview', function(data, cb)
    inPreview = false
    ShowNUI('setVisiblePreviewMenu', false)
    local newMods = getVehicleMods(previewVehicle)
    FreezeEntityPosition(previewVehicle, false)
    local modsList = {}
    for ck, cv in pairs(Config.cosmetics) do
        if cv.value == 'paints' then
            for pk, pv in pairs(Config.paintsCategory) do
                if newMods[pv.modsId] ~= previewDefaultMods[pv.modsId] then
                    modsList[#modsList + 1] = {
                        isPaint = true,
                        id = pv.value,
                        value = newMods[pv.modsId],
                        idLabel = pv.label,
                        valueLabel = getColorLabel(newMods[pv.modsId])
                    }
                end
            end
        elseif cv.value == 'windowTint' then
            if newMods.windowTint ~= previewDefaultMods.windowTint then
                for wp, wv in pairs(Config.windowTint) do
                    if newMods.windowTint == wv.value then
                        modsList[#modsList + 1] = {
                            id = 'windowTint',
                            value = newMods.windowTint,
                            idLabel = cv.label,
                            valueLabel = wv.label
                        }
                    end
                end
            end
        elseif cv.value == 'plates' then
            if newMods.plateIndex ~= previewDefaultMods.plateIndex then
                for pk, pv in pairs(Config.plates) do
                    if pv.value == newMods.plateIndex then
                        modsList[#modsList + 1] = {
                            id = 'plates',
                            value = newMods.plateIndex,
                            idLabel = cv.label,
                            valueLabel = pv.label
                        }
                    end
                end
            end
        else
            local value = newMods[cv.modsId]
            if value ~= previewDefaultMods[cv.modsId] then
                modsList[#modsList + 1] = {
                    wheelType = (cv.value == 23 or cv.value == 24) and GetVehicleWheelType(previewVehicle) or false,
                    id = cv.value,
                    value = value,
                    idLabel = cv.label,
                    valueLabel = string.format("%s - %s", (value + 1), GetLabelText(GetModTextLabel(previewVehicle, cv.value, value)))
                }
            end
        end
    end
    setVehicleMods(previewVehicle, previewDefaultMods)
    SetVehicleWindowTint(previewVehicle, previewDefaultMods.windowTint)
    previewDefaultMods = nil
    previewVehicle = nil
    if not (#modsList > 0) then cb(true) return end
    lib.callback.await('mt_workshops:server:addItem', false, 'mods_list', 1, { plate = newMods.plate, modsList = modsList })
    cb(true)
end)
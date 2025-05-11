---@param data table | nil
---@param item table
openCosmeticsMenu = function(data, item)
    local metadata = item.metadata or item.info
    SendNUI('cosmeticsMenu', { plate = metadata.plate, modsList = metadata.modsList, slot = item.slot, isMission = metadata.isMission or false })
    ShowNUI('setVisibleCosmeticsMenu', true)
end
lib.callback.register('mt_workshops:client:useModsList', openCosmeticsMenu)
exports('openCosmeticsMenu', openCosmeticsMenu)

RegisterNuiCallback('deleteList', function(data, cb)
    ShowNUI('setVisibleCosmeticsMenu', false)
    lib.callback.await('mt_workshops:server:removeItem', false, 'mods_list', 1, data.list)
    cb(true)
end)

RegisterNuiCallback('applyMod', function(data, cb)
    if not insideZone[getPlayerJob()] then notify(locale('notify_error_inside_zone'), 'error') cb(true) return end
    local vehicle = getClosestVehicle()
    if not vehicle then notify(locale('notify_error_no_vehicle'), 'error') cb(true) return end
    local item = ''
    for mck, mcv in pairs(Config.cosmetics) do
        if (data.id == mcv.value) or (data.isPaint and (mcv.value == 'paints')) then item = mcv.item break end
    end
    if (not data.isMission) and (not getHasItem(item, 1)) then notify(locale('notify_missing_item'), 'error') cb(true) return end
    if not (data.plate == GetVehicleNumberPlateText(vehicle)) then notify(locale('notify_error_no_vehicle_plate', data.plate), 'error') cb(true) return end
    ShowNUI('setVisibleCosmeticsMenu', false)
    if data.isPaint then
        spraycan = createProp('ng_proc_spraycan01b', vec3(0.0, 0.0, 0.0), 0.0)
        AttachEntityToEntity(spraycan, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.11, 0.05, -0.06, 28.0, 30.0, 0.0, true, true, false, true, 1, true)
        playAnim("switch@franklin@lamar_tagging_wall", "lamar_tagging_wall_loop_lamar", 10000000, 1)
        Wait(2000)
        ClearPedTasks(cache.ped)
        playAnim("switch@franklin@lamar_tagging_wall", "lamar_tagging_exit_loop_lamar", 100000000, 1)
        loadParticle('core')
        Wait(100)
        UseParticleFxAssetNextCall("core")
        local spray = StartParticleFxLoopedOnEntity("ent_amb_steam", spraycan, 0.0, 0.13, 0.0, 90.0, 90.0, 0.0, 0.2, false, false, false)
        SetParticleFxLoopedAlpha(spray, 255.0)
        SetParticleFxLoopedColour(spray, 255, 255, 255, false)
    end
    if progressBar(locale('progress_install_cosmetic'), Config.times.installingCosmetic, { car = true, walk = true }, data.isPaint and {} or { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 6 }, {}) then
        TriggerServerEvent('mt_workshops:server:setVehicleCosmeticMod', VehToNet(vehicle), data.isPaint, data.wheelType, data.id, data.value, cache.serverId)
        for mk, mv in pairs(data.modsList) do
            if mv.id == data.id then mv.applied = true end
        end
        lib.callback.await('mt_workshops:server:setItemMetadata', false, 'mods_list', data.slot, { plate = data.plate, modsList = data.modsList, isMission = data.isMission })
        if not data.isMission then lib.callback.await('mt_workshops:server:removeItem', false, item, 1) end
        if data.isMission then checkMissionModsFinished() end
        Wait(500)
    end
    openCosmeticsMenu(nil, { slot = data.slot, metadata = { plate = data.plate, modsList = data.modsList, isMission = data.isMission }})
    ClearPedTasks(cache.ped) 
    if spraycan then DeleteEntity(spraycan) spraycan = nil end
    cb(true)
end)

RegisterNetEvent('mt_workshops:client:setVehicleCosmeticMod', function(vehicle, isPaint, wheelType, modType, modLevel, player)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    vehicle = NetToVeh(vehicle)
    if isPaint then
        if modType == 'primary' then
            local primary, secoundary = GetVehicleColours(vehicle)
            ClearVehicleCustomPrimaryColour(vehicle)
            SetVehicleColours(vehicle, modLevel, secoundary)
        elseif modType == 'secoundary' then
            local primary, secoundary = GetVehicleColours(vehicle)
            ClearVehicleCustomSecondaryColour(vehicle)
            SetVehicleColours(vehicle, primary, modLevel)
        elseif modType == 'pearl' then
            local pearl, wheel = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, modLevel, wheel)
        elseif modType == 'wheels' then
            local pearl, wheel = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, pearl, modLevel)
        elseif modType == 'interior' then
            SetVehicleInteriorColor(vehicle, modLevel)
        elseif modType == 'dashboard' then
            SetVehicleDashboardColor(vehicle, modLevel)
        end
    elseif modType == 'plates' then
        SetVehicleNumberPlateTextIndex(vehicle, modLevel)
    elseif modType == 'windowTint' then
        SetVehicleWindowTint(vehicle, modLevel)
    else
        if modType == 23 or modType == 23 then SetVehicleWheelType(vehicle, wheelType) end
        SetVehicleMod(vehicle, modType, modLevel, false)
    end
    if cache.serverId == player then
        lib.callback.await('mt_workshops:server:saveVehicleMods', false, vehicle, getVehicleMods(vehicle))
    end
end)
local washedVehicles = {}

openToolboxMenu = function()
    if not insideZone[getPlayerJob()] then notify(locale('notify_error_inside_zone'), 'error') return end
    local vehicle = getClosestVehicle()
    if not vehicle then notify(locale('notify_error_no_vehicle'), 'error') return end
    local neededItems = Config.repairItems
    for nik, niv in pairs(neededItems) do
        niv.label = getItemData(niv.item).label
    end
    SendNUI('repairMenu', {
        engine = math.ceil(GetVehicleEngineHealth(vehicle)/10),
        body = math.ceil(GetVehicleBodyHealth(vehicle)/10),
        tank = math.ceil(GetVehiclePetrolTankHealth(vehicle)/10),
        dirt = math.ceil(GetVehicleDirtLevel(vehicle)),
        neededItems = neededItems,
        toolboxOptions = Config.toolboxOptions
    })
    ShowNUI('setVisibleRepairMenu', true)
end
exports('openToolboxMenu', openToolboxMenu)
lib.callback.register('mt_workshops:client:openToolboxMenu', openToolboxMenu)

RegisterNuiCallback('openPerformanceMenu', function(data, cb)
    ShowNUI('setVisibleRepairMenu', false)
    openPerformanceMenu()
    cb(true)
end)

RegisterNuiCallback('openRepairMenu', function(data, cb)
    ShowNUI('setVisiblePerformanceMenu', false)
    openToolboxMenu()
    cb(true)
end)

RegisterNuiCallback('repairVehiclePart', function(data, cb)
    local vehicle = getClosestVehicle()
    if data.part == 'engine' then
        if not getHasItem(Config.repairItems.engine.item, Config.repairItems.engine.count) then notify(locale('notify_missing_item'), 'error') return end
        ShowNUI('setVisibleRepairMenu', false)
        loadAnimDict("rcmnigel3_trunk")
        TaskPlayAnim(cache.ped, "rcmnigel3_trunk", "out_trunk_trevor", 8.0, 8.0, 2000, 1, 0.0, 0, 0, 0)
        Wait(2000)
        SetVehicleDoorOpen(vehicle, 4, true, true)
        if progressBar(locale('progress_repair_engine'), Config.times.repairEngine, { car = true, walk = true }, { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 6 }, { model = `w_me_wrench`, pos = vec3(0.071, -0.017, 0.036), rot = vec3(-121.24, -10.43, 6.64) }) then
            TriggerServerEvent('mt_workshops:server:fixVehicleEngine', VehToNet(vehicle), cache.serverId)
            lib.callback.await('mt_workshops:server:removeItem', false, Config.repairItems.engine.item, Config.repairItems.engine.count)
        end
        loadAnimDict("rcmepsilonism8")
        TaskPlayAnim(cache.ped, "rcmepsilonism8", "bag_handler_close_trunk_walk_left", 8.0, 8.0, 2500, 1, 0.0, 0, 0, 0)
        Wait(2500)
        SetVehicleDoorShut(vehicle, 4, true)
        Wait(100)
        openToolboxMenu()
    elseif data.part == 'body' then
        if not getHasItem(Config.repairItems.body.item, Config.repairItems.body.count) then notify(locale('notify_missing_item'), 'error') return end
        ShowNUI('setVisibleRepairMenu', false)
        SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)+180)
        if progressBar(locale('progress_repair_body'), Config.times.repairBody, { car = true, walk = true }, { dict = 'amb@world_human_vehicle_mechanic@male@base', clip = 'base', flag = 6 }, { model = `w_me_wrench`, pos = vec3(0.071, -0.017, 0.036), rot = vec3(-121.24, -10.43, 6.64) }) then
            TriggerServerEvent('mt_workshops:server:fixVehicleBody', VehToNet(vehicle), cache.serverId)
            lib.callback.await('mt_workshops:server:removeItem', false, Config.repairItems.body.item, Config.repairItems.body.count)
        end
        local pCoords = GetEntityCoords(cache.ped)
        SetEntityCoords(cache.ped, pCoords.x, pCoords.y, pCoords.z+0.5, true, false, false, false)
        SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)-180)
        Wait(100)
        openToolboxMenu()
    elseif data.part == 'tank' then
        if not getHasItem(Config.repairItems.tank.item, Config.repairItems.tank.count) then notify(locale('notify_missing_item'), 'error') return end
        ShowNUI('setVisibleRepairMenu', false)
        SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)+180)
        if progressBar(locale('progress_repair_tank'), Config.times.repairTank, { car = true, walk = true }, { dict = 'amb@world_human_vehicle_mechanic@male@base', clip = 'base', flag = 6 }, { model = `w_me_wrench`, pos = vec3(0.071, -0.017, 0.036), rot = vec3(-121.24, -10.43, 6.64) }) then
            TriggerServerEvent('mt_workshops:server:fixVehicleTank', VehToNet(vehicle), cache.serverId)
            lib.callback.await('mt_workshops:server:removeItem', false, Config.repairItems.tank.item, Config.repairItems.tank.count)
        end
        local pCoords = GetEntityCoords(cache.ped)
        SetEntityCoords(cache.ped, pCoords.x, pCoords.y, pCoords.z+0.5, true, false, false, false)
        SetEntityHeading(cache.ped, GetEntityHeading(cache.ped)-180)
        Wait(100)
        openToolboxMenu()
    elseif data.part == 'wash' then
        ShowNUI('setVisibleRepairMenu', false)
        if progressBar(locale('progress_wash'), Config.times.wash, { car = true, walk = true }, { dict = 'timetable@floyd@clean_kitchen@base', clip = 'base', flag = 6 }, { bone = 28422, model = `prop_sponge_01`, pos = vec3(0.0, 0.0, -0.01), rot = vec3(90.0, 0.0, 0.0) }) then
            TriggerServerEvent('mt_workshops:server:washVehicle', VehToNet(vehicle), cache.serverId)
        end
        Wait(100)
        openToolboxMenu()
    end
    cb(true)
end)

RegisterNetEvent('mt_workshops:client:fixVehicleBody', function(vehicle)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    vehicle = NetToVeh(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local petrolHealth = GetVehiclePetrolTankHealth(vehicle)
    local currentFuel = GetVehicleFuelLevel(vehicle)
    SetVehicleFixed(vehicle)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, engineHealth)
    SetVehiclePetrolTankHealth(vehicle, petrolHealth)
    SetVehicleFuelLevel(vehicle, currentFuel)
    if cache.serverId == player then
        lib.callback.await('mt_workshops:server:saveVehicleMods', false, NetToVeh(vehicle), getVehicleMods(NetToVeh(vehicle)))
    end
end)

RegisterNetEvent('mt_workshops:client:fixVehicleEngine', function(vehicle)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    SetVehicleEngineHealth(NetToVeh(vehicle), 1000.0)
    if cache.serverId == player then
        lib.callback.await('mt_workshops:server:saveVehicleMods', false, NetToVeh(vehicle), getVehicleMods(NetToVeh(vehicle)))
    end
end)

RegisterNetEvent('mt_workshops:client:fixVehicleTank', function(vehicle)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    SetVehiclePetrolTankHealth(NetToVeh(vehicle), 1000.0)
    if cache.serverId == player then
        lib.callback.await('mt_workshops:server:saveVehicleMods', false, NetToVeh(vehicle), getVehicleMods(NetToVeh(vehicle)))
    end
end)

RegisterNetEvent('mt_workshops:client:washVehicle', function(vehicle)
    if not NetworkDoesEntityExistWithNetworkId(vehicle) then return end
    SetVehicleDirtLevel(NetToVeh(vehicle), 0.0)
end)
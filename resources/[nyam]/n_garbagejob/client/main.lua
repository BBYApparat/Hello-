local ESX = exports.es_extended:getSharedObject()
local garbageVehicle = nil
local hasBag = false
local currentStop = 0
local deliveryBlip = nil
local amountOfBags = 0
local garbageObject = nil
local endBlip = nil
local garbageBlip = nil
local canTakeBag = true
local currentStopNum = 0
local PZone = nil
local listen = false
local finished = false
local continueworking = false

-- Functions

local function setupClient()
    garbageVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    amountOfBags = 0
    garbageObject = nil
    endBlip = nil
    currentStopNum = 0
    -- if playerJob.name == Config.Jobname then
        garbageBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(garbageBlip, 318)
        SetBlipDisplay(garbageBlip, 4)
        SetBlipScale(garbageBlip, 1.0)
        SetBlipAsShortRange(garbageBlip, true)
        SetBlipColour(garbageBlip, 39)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(garbageBlip)
    -- end
end

local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

local function BringBackCar()
    DeleteVehicle(garbageVehicle)
    if endBlip then
        RemoveBlip(endBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    garbageVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    amountOfBags = 0
    garbageObject = nil
    endBlip = nil
    currentStopNum = 0
end

local function DeleteZone()
    listen = false
    if PZone then
        PZone:destroy()
    end
end

local function SetRouteBack()
    local depot = Config.Locations["main"].coords
    endBlip = AddBlipForCoord(depot.x, depot.y, depot.z)
    SetBlipSprite(endBlip, 1)
    SetBlipDisplay(endBlip, 2)
    SetBlipScale(endBlip, 1.0)
    SetBlipAsShortRange(endBlip, false)
    SetBlipColour(endBlip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
    EndTextCommandSetBlipName(endBlip)
    SetBlipRoute(endBlip, true)
    DeleteZone()
    finished = true
    lib.hideTextUI()
end

local function AnimCheck()
    CreateThread(function()
        local ped = PlayerPedId()
        while hasBag and not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man',3) do
            if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                ClearPedTasksImmediately(ped)
                LoadAnimation('missfbi4prepp1')
                TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

local function DeliverAnim()
    local ped = PlayerPedId()
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, GetEntityHeading(garbageVehicle))
    canTakeBag = false
    SetTimeout(1250, function()
        DetachEntity(garbageObject, 1, false)
        DeleteObject(garbageObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        garbageObject = nil
        canTakeBag = true
    end)
    if hasBag then
        local CL = Config.Locations["trashcan"][currentStop]
        hasBag = false
        local pos = GetEntityCoords(ped)
        
        if (amountOfBags - 1) <= 0 then
            ESX.TriggerServerCallback('n_garbagejob:server:NextStop', function(hasMoreStops, nextStop, newBagAmount, totalStops)
                if hasMoreStops and nextStop ~= 0 then
                    -- Here he puts your next location and you are not finished working yet.
                    currentStop = nextStop
                    currentStopNum = currentStopNum + 1
                    amountOfBags = newBagAmount
                    SetGarbageRoute()
                    Core.Notify(Lang("info.all_bags", {done = currentStopNum-1, left = totalStops}), "info", 3500)
                    SetVehicleDoorShut(garbageVehicle, 5, false)
                else
                    if hasMoreStops and nextStop == currentStop then
                        Core.Notify(Lang("info.depot_issue"), "error", 3500)
                        amountOfBags = 0
                        lib.hideTextUI()
                    else
                        -- You are done with work here.
                        Core.Notify(Lang("info.done_working"), "success", 3500)
                        SetVehicleDoorShut(garbageVehicle, 5, false)
                        RemoveBlip(deliveryBlip)
                        SetRouteBack()
                        amountOfBags = 0
                    end
                end
            end, currentStop, currentStopNum, pos)
        else
            -- You haven't delivered all bags here
            amountOfBags = amountOfBags - 1
            if amountOfBags > 1 then
                Core.Notify(Lang("info.bags_left", { value = amountOfBags }), "info", 3500)
            else
                Core.Notify(Lang("info.bags_still", { value = amountOfBags }), "info", 3500)
            end
        end
    end
end

function TakeAnim(coords)
    local ped = PlayerPedId()
    TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 750)
    Wait(500)
    if lib.progressCircle({
        label = Lang("info.picking_bag"),
        duration = math.random(1000, 2000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer"
        },
    }) then
        LoadAnimation('missfbi4prepp1')
        TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
        garbageObject = CreateObject(`prop_cs_rub_binbag_01`, 0, 0, 0, true, true, true)
        AttachEntityToEntity(garbageObject, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        AnimCheck()
        hasBag = true
    else
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        Core.Notify(Lang("error.cancled"), "error", 3500)
    end
end

local function RunWorkLoop()
    CreateThread(function()
        local GarbText = false
        while listen do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local DeliveryData = Config.Locations["trashcan"][currentStop]
            local Distance = #(pos - vector3(DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z))
            if Distance < 15 or hasBag then

                if not hasBag and canTakeBag then
                    if Distance < 1.5 then
                        if not GarbText then
                            GarbText = true
                            lib.showTextUI(Lang("info.grab_garbage"), 'left')
                        end
                        if IsControlJustPressed(0, 51) then
                            hasBag = true
                            lib.hideTextUI()
                            TakeAnim(DeliveryData.coords)
                        end
                    elseif Distance < 10 then
                        if GarbText then
                            GarbText = false
                            lib.hideTextUI()
                        end
                    end
                else
                    if DoesEntityExist(garbageVehicle) then
                        local Coords = GetOffsetFromEntityInWorldCoords(garbageVehicle, 0.0, -4.5, 0.0)
                        local TruckDist = #(pos - Coords)
                        local TrucText = false

                        if TruckDist < 2 then
                            if not TrucText then
                                TrucText = true
                                lib.showTextUI(Lang("info.dispose_garbage"), 'left')
                            end
                            if IsControlJustPressed(0, 51) and hasBag then
                                StopAnimTask(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 1.0)
                                DeliverAnim()
                                if lib.progressCircle({
                                    label = Lang("info.progressbar"),
                                    duration = 2000,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                        move = true,
                                        mouse = false,
                                        combat = true
                                    },
                                }) then
                                    hasBag = false
                                    canTakeBag = false
                                    DetachEntity(garbageObject, 1, false)
                                    DeleteObject(garbageObject)
                                    FreezeEntityPosition(ped, false)
                                    garbageObject = nil
                                    canTakeBag = true
                                    -- Looks if you have delivered all bags
                                    if (amountOfBags - 1) <= 0 then
                                        ESX.TriggerServerCallback('n_garbagejob:server:NextStop', function(hasMoreStops, nextStop, newBagAmount)
                                            if hasMoreStops and nextStop ~= 0 then
                                                -- Here he puts your next location and you are not finished working yet.
                                                currentStop = nextStop
                                                currentStopNum = currentStopNum + 1
                                                amountOfBags = newBagAmount
                                                SetGarbageRoute()
                                                Core.Notify(Lang("info.all_bags"), "info", 3500)
                                                listen = false
                                                SetVehicleDoorShut(garbageVehicle, 5, false)
                                            else
                                                if hasMoreStops and nextStop == currentStop then
                                                    Core.Notify(Lang("info.depot_issue"), "error", 3500)
                                                    amountOfBags = 0
                                                else
                                                    -- You are done with work here.
                                                    Core.Notify(Lang("info.done_working"), "success", 3500)
                                                    SetVehicleDoorShut(garbageVehicle, 5, false)
                                                    RemoveBlip(deliveryBlip)
                                                    SetRouteBack()
                                                    amountOfBags = 0
                                                    listen = false
                                                end
                                            end
                                        end, currentStop, currentStopNum, pos)
                                        hasBag = false
                                    else
                                        -- You haven't delivered all bags here
                                        amountOfBags = amountOfBags - 1
                                        if amountOfBags > 1 then
                                            Core.Notify(Lang("info.bags_left", { value = amountOfBags }), "info", 3500)
                                        else
                                            Core.Notify(Lang("info.bags_still", { value = amountOfBags }), "info", 3500)
                                        end
                                        hasBag = false
                                    end

                                    Wait(1500)
                                    if TrucText then
                                        lib.hideTextUI()
                                        TrucText = false
                                    end
                                else
                                    Core.Notify(Lang("error.cancled"), "error", 3500)
                                end
                            end
                        end
                    else
                        Core.Notify(Lang("error.no_truck"), "error", 3500)
                        hasBag = false
                    end
                end
            end
            Wait(1)
        end
    end)
end

local function CreateZone(x, y, z)
    CreateThread(function()
        PZone = CircleZone:Create(vector3(x, y, z), 15.0, {
            name = "NewRouteWhoDis",
            debugPoly = false,
        })

        PZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                listen = true
                RunWorkLoop()
                SetVehicleDoorOpen(garbageVehicle,5,false,false)
            else
                lib.hideTextUI()
                listen = false
                SetVehicleDoorShut(garbageVehicle, 5, false)
            end
        end)
    end)
end

function SetGarbageRoute()
    local CL = Config.Locations["trashcan"][currentStop]
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    deliveryBlip = AddBlipForCoord(CL.coords.x, CL.coords.y, CL.coords.z)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipDisplay(deliveryBlip, 2)
    SetBlipScale(deliveryBlip, 1.0)
    SetBlipAsShortRange(deliveryBlip, false)
    SetBlipColour(deliveryBlip, 27)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["trashcan"][currentStop].name)
    EndTextCommandSetBlipName(deliveryBlip)
    SetBlipRoute(deliveryBlip, true)
    finished = false
    
    if PZone then
        DeleteZone()
        Wait(500)
        CreateZone(CL.coords.x, CL.coords.y, CL.coords.z)
    else
        CreateZone(CL.coords.x, CL.coords.y, CL.coords.z)
    end
end

local ControlListen = false
local function Listen4Control()
    ControlListen = true
    CreateThread(function()
        while ControlListen do
            if IsControlJustReleased(0, 38) then
                TriggerEvent("n_garbagejob:client:MainMenu")
            end
            Wait(1)
        end
    end)
end

local pedsSpawned = false
local function spawnPeds()
    if not Config.Peds or not next(Config.Peds) or pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        current.model = type(current.model) == 'string' and GetHashKey(current.model) or current.model
        RequestModel(current.model)
        while not HasModelLoaded(current.model) do
            Wait(0)
        end
        local ped = CreatePed(0, current.model, current.coords, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        current.pedHandle = ped

        if Config.UseTarget then
            -- Add ox_target options for the ped
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'garbage_job_ped',
                    icon = 'fas fa-trash',
                    label = 'Talk to Garbage Worker',
                    onSelect = function()
                        TriggerEvent("n_garbagejob:client:MainMenu")
                    end
                }
            })
        else
            -- Using the non-target approach with zone creation
            local options = current.zoneOptions
            if options then
                local zone = BoxZone:Create(current.coords.xyz, options.length, options.width, {
                    name = "zone_garbage_" .. i,
                    heading = current.coords.w,
                    debugPoly = false
                })
                zone:onPlayerInOut(function(inside)
                    if LocalPlayer.state.isLoggedIn then
                        if inside then
                            lib.showTextUI(Lang("info.talk"), 'left')
                            Listen4Control()
                        else
                            ControlListen = false
                            lib.hideTextUI()
                        end
                    end
                end)
            end
        end
    end
    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    end
end

-- Events

RegisterNetEvent('n_garbagejob:client:SetWaypointHome', function()
    SetNewWaypoint(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y)
end)

RegisterNetEvent('n_garbagejob:client:RequestRoute', function()
    if garbageVehicle then continueworking = true TriggerServerEvent('n_garbagejob:server:PayShift', continueworking) end
    ESX.TriggerServerCallback('n_garbagejob:server:NewShift', function(shouldContinue, firstStop, totalBags)
        if shouldContinue then
            if not garbageVehicle then
                local occupied = false
                for _,v in pairs(Config.Locations["vehicle"].coords) do
                    if not IsAnyVehicleNearPoint(vector3(v.x,v.y,v.z), 2.5) then
                        ESX.TriggerServerCallback('esx:spawnVehicle', function(netId)
                            local veh = NetToVeh(netId)
                            SetEntityHeading(veh, v.w)
                            SetVehicleEngineOn(veh, false, true)
                            SetVehicleNumberPlateText(veh, "SLRP-" .. tostring(math.random(10, 99)))
                            SetEntityHeading(veh, v.w)
                            --exports['bby_fuel']:SetFuel(veh, 100.0)
                            SetVehicleFixed(veh)
                            SetEntityAsMissionEntity(veh, true, true)
                            SetVehicleDoorsLocked(veh, 1)
                            garbageVehicle = veh
                            currentStop = firstStop
                            currentStopNum = 1
                            amountOfBags = totalBags
                            SetGarbageRoute()
                            -- TriggerEvent("vehiclekeys:client:SetOwner", ESX.Math.Trim(GetVehicleNumberPlateText(veh)))
                            exports['SimpleCarlock']:GiveKey(ESX.Math.Trim(GetVehicleNumberPlateText(veh)))
                            Core.Notify(Lang("info.deposit_paid", { value = Config.TruckPrice }), "info", 3500)
                            Core.Notify(Lang("info.started"), "info", 3500)
                            TriggerServerEvent("n_garbagejob:server:payDeposit")
                        end, {model = Config.Vehicle, coords = vector3(v.x,v.y,v.z), warp = true})
                        return
                    else
                        occupied = true
                    end
                end
                if occupied then
                    Core.Notify(Lang("error.all_occupied"), "error", 3500)
                end
            end
            currentStop = firstStop
            currentStopNum = 1
            amountOfBags = totalBags
            SetGarbageRoute()
        else
            Core.Notify(Lang("info.not_enough", { value = Config.TruckPrice }), "error", 3500)
        end
    end, continueworking)
end)

RegisterNetEvent('n_garbagejob:client:RequestPaycheck', function()
    if garbageVehicle then
        BringBackCar()
        Core.Notify(Lang("info.truck_returned"), "success", 3500)
    end
    TriggerServerEvent('n_garbagejob:server:PayShift')
end)

RegisterNetEvent('n_garbagejob:client:MainMenu', function()
    lib.registerContext({
        id = 'garbage_main_menu',
        title = Lang("menu.header"),
        options = {
            {
                title = Lang("menu.return_collect"),
                description = 'Example button description',
                icon = 'stop',
                onSelect = function()
                TriggerEvent("n_garbagejob:client:RequestPaycheck")
                end,
                -- metadata = {
                --   {label = 'Value 1', value = 'Some value'},
                --   {label = 'Value 2', value = 300}
                -- },
            },
            {
                title = Lang("menu.request_route"),
                description = 'Example button description',
                icon = 'play',
                onSelect = function()
                TriggerEvent("n_garbagejob:client:RequestRoute")
                end,
                -- metadata = {
                --   {label = 'Value 1', value = 'Some value'},
                --   {label = 'Value 2', value = 300}
                -- },
            }
        }
    })
    lib.showContext('garbage_main_menu')
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    -- playerJob = xPlayer.job
    if garbageBlip then
        RemoveBlip(garbageBlip)
    end
    if endBlip then
        RemoveBlip(endBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    endBlip = nil
    deliveryBlip = nil
    setupClient()
    spawnPeds()
end)

RegisterNetEvent('esx:onPlayerLogout', function(JobInfo)
    if garbageObject then
        DeleteEntity(garbageObject)
        garbageObject = nil
    end
    deletePeds()
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if garbageObject then
            DeleteEntity(garbageObject)
            garbageObject = nil
        end
        deletePeds()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        -- playerJob = QBCore.Functions.GetPlayerData().job
        setupClient()
        spawnPeds()
    end
end)
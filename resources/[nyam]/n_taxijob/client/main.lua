-- Variables
local ESX = exports.es_extended:getSharedObject()
local meterIsOpen = false
local meterActive = false
local lastLocation = nil
local mouseActive = false
local CubPed = nil
local CubRenterZone = nil
local PlayerData = nil
-- used for polyzones
local isInsidePickupZone = false
local isInsideDropZone = false
local Notified = false
local isPlayerInsideZone = false

local meterData = {
    fareAmount = 6,
    currentFare = 0,
    distanceTraveled = 0,
    countdownTime = 420,
    npc = false
}

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false
}

local MeterLimit = 5 * (1000 * 60)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    PlayerData = ESX.GetPlayerData()
    setupTarget()
    setupCabParkingLocation()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if CubRenterZone then CubRenterZone:destroy() end
    despawnCubRenter()
end)

-- events
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    setupTarget()
    setupCabParkingLocation()
end)

AddEventHandler('esx:setPlayerData', function(key, metadata, oldMetadata)
    if key == "metadata" and PlayerData then
        PlayerData.metadata = metadata
    end
end)

-- Functions

local function ResetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

local function resetMeter()
    meterData = {
        fareAmount = 6,
        currentFare = 0,
        distanceTraveled = 0,
        countdownTime = 420,
        npc = false
    }
end

local function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    
    return retval
end

local function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetDeliveryLocation()
    NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
    if NpcData.LastDeliver ~= nil then
        while NpcData.LastDeliver ~= NpcData.CurrentDeliver do
            NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
        end
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = NpcData.CurrentDeliver
    if not Config.UseTarget then -- added checks to disable distance checking if polyzone option is used
        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = #(pos - vector3(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z))
                if dist < 20 then
                    DrawMarker(2, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 5 then
                        DrawText3D(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, Lang("info.drop_off_npc"))
                        if IsControlJustPressed(0, 38) then
                            local veh = GetVehiclePedIsIn(ped, 0)
                            TaskLeaveVehicle(NpcData.Npc, veh, 0)
                            SetEntityAsMissionEntity(NpcData.Npc, false, true)
                            SetEntityAsNoLongerNeeded(NpcData.Npc)
                            local targetCoords = Config.NPCLocations.TakeLocations[NpcData.LastNpc]
                            TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                            SendNUIMessage({action = "toggleMeter"})
                            TriggerServerEvent('n_taxijob:NpcPay', meterData.currentFare)
                            meterActive = false
                            SendNUIMessage({action = "resetMeter"})
                            exports.n_snippets:Notify(Lang("info.person_was_dropped_off"), 'success', 3500, 'Taxi Job')
                            Wait(500)
                            SetVehicleDoorsShut(veh, true)
                            if NpcData.DeliveryBlip ~= nil then
                                RemoveBlip(NpcData.DeliveryBlip)
                            end
                            local RemovePed = function(p)
                                SetTimeout(60000, function()
                                    DeletePed(p)
                                end)
                            end
                            RemovePed(NpcData.Npc)
                            ResetNpcTask()
                            break
                        end
                    end
                end
                Wait(1)
            end
        end)
    end
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}
	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	for k, entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))
		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities+1] = isPlayerEntities and k or entity
		end
	end
	return nearbyEntities
end

local function GetVehiclesInArea(coords, maxDistance) -- Vehicle inspection in designated area
	return EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance)
end

local function IsSpawnPointClear(coords, maxDistance) -- Check the spawn point to see if it's empty or not:
	return #GetVehiclesInArea(coords, maxDistance) == 0
end

local function getVehicleSpawnPoint()
    local near = nil
	local distance = 10
	for k, v in pairs(Config.CabSpawns) do
        if IsSpawnPointClear(vector3(v.x, v.y, v.z), 2.5) then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local cur_distance = #(pos - vector3(v.x, v.y, v.z))
            if cur_distance < distance then
                distance = cur_distance
                near = k
            end
        end
    end
	return near
end

local function calculateFareAmount()
    if meterIsOpen and meterActive then
        local startPos = lastLocation
        local newPos = GetEntityCoords(PlayerPedId())
        
        if not StartPos then StartPos = GetEntityCoords(PlayerPedId()) end
        
        if startPos ~= newPos then
            local newDistance = #(startPos - newPos)
            lastLocation = newPos
            
            meterData.distanceTraveled += (newDistance/1609)

            local fareAmount = ((meterData.distanceTraveled)*Config.Meter.defaultPrice)+Config.Meter.startingPrice
            meterData.currentFare = math.floor(fareAmount)
        end

        if meterData.npc then
            if meterData.countdownTime > 0 then
                meterData.countdownTime = meterData.countdownTime - 1
            else
                TimeRanOut()
            end
        end
        SendNUIMessage({
            action = "updateMeter",
            meterData = meterData
        })
    end
end

function TimeRanOut()
    exports.n_snippets:Notify(Lang("error.time_ran_out"), 'error', 5000, 'Taxi Job')
    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
    local retval, peds = AddRelationshipGroup("madPeds")
	local retval, players = AddRelationshipGroup("players")

    SetVehicleBrake(veh, true)
    SetVehicleHandbrake(veh, true)
    while not IsVehicleStopped(veh) do
        lib.disableControls()
        if IsVehicleStopped(veh) then
            FreezeEntityPosition(veh, true)
        end
        Wait(1)
    end

    TaskLeaveVehicle(NpcData.Npc, veh, 0)

    SetRelationshipBetweenGroups(5, peds, players)
    SetRelationshipBetweenGroups(5, players, peds)

    -- SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(NpcData.Npc), true) 

    SetPedRelationshipGroupHash(NpcData.Npc, peds)
    
    SetPedFleeAttributes(NpcData.Npc, 0, false)
    SetPedCanSwitchWeapon(NpcData.Npc, true)
    SetPedDropsWeaponsWhenDead(NpcData.Npc, false)
    SetPedAsEnemy(NpcData.Npc, true)
    SetPedCombatMovement(NpcData.Npc, 3)
    SetPedAlertness(NpcData.Npc, 3)
    SetPedCombatRange(NpcData.Npc, 2)
    SetPedSeeingRange(NpcData.Npc, 15.0)
    SetPedHearingRange(NpcData.Npc, 15.0)
    
    SetPedCombatAttributes(NpcData.Npc, 5, 1)
    SetPedCombatAttributes(NpcData.Npc, 0, 1)
    SetPedCombatAttributes(NpcData.Npc, 46, 1)
    
    SetPedCanRagdollFromPlayerImpact(NpcData.Npc, false)
    SetEntityAsMissionEntity(NpcData.Npc)
    SetEntityVisible(NpcData.Npc, true)

    TaskGuardCurrentPosition(NpcData.Npc, 10.0, 10.0, 1)
    TaskCombatPed(NpcData.Npc, GetPlayerPed(-1), 0, 16)

    
    SetEntityAsMissionEntity(NpcData.Npc, false, true)
    SetEntityAsNoLongerNeeded(NpcData.Npc)
    
    -- local targetCoords = Config.NPCLocations.TakeLocations[NpcData.LastNpc]
    -- TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)

    SendNUIMessage({action = "toggleMeter"})
    meterActive = false
    SendNUIMessage({action = "resetMeter"})
    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    local RemovePed = function(p)
        SetTimeout(15000, function()
            DeletePed(p)
        end)
    end
    Wait(2000)
    FreezeEntityPosition(veh, false)
    SetVehicleBrake(veh, false)
    SetVehicleHandbrake(veh, false)
    ResetNpcTask()
    RemovePed(NpcData.Npc)
end

function TaxiGarage()
    local Vehicles = {}
    
    for _, v in pairs(Config.AllowedVehicles) do
        Vehicles[#Vehicles+1] = {
            title = v.label,
            description = 'Get one cub togo',
            onSelect = function()
                TriggerEvent("n_taxijob:TakeVehicle", {model = v.model})
            end,
        }
    end

    lib.registerContext({
        id = 'n_taxijob_menu',
        title = Lang("menu.taxi_menu_header"),
        options = Vehicles
    })
    
    lib.showContext('n_taxijob_menu')
end

RegisterNetEvent("n_taxijob:TakeVehicle", function(data)
    ESX.TriggerServerCallback('n_taxijob:checkRented', function(hasPlate)
        if hasPlate then
            exports.n_snippets:Notify(Lang("error.already_rented"), "error", 3500, "Taxi Job")
            return
        end
        local SpawnPoint = getVehicleSpawnPoint()
        if SpawnPoint then
            local coords = vector3(Config.CabSpawns[SpawnPoint].x,Config.CabSpawns[SpawnPoint].y,Config.CabSpawns[SpawnPoint].z)
            local CanSpawn = IsSpawnPointClear(coords, 2.0)
            if CanSpawn then
                ESX.TriggerServerCallback('esx:spawnVehicle', function(netId)
                    local veh = NetToVeh(netId)
                    local plate = "TAXI"..tostring(math.random(1000, 9999))
                    SetVehicleNumberPlateText(veh, plate)
                    Entity(veh).state.fuel = 100.0
                    closeMenuFull()
                    SetEntityHeading(veh, Config.CabSpawns[SpawnPoint].w)
                    
                    exports.wasabi_carlock:GiveKey(plate)

                    TriggerServerEvent('n_taxijob:rentCab', plate)
                    SetVehicleEngineOn(veh, true, true)
                    lib.showTextUI(Lang("info.vehicle_parking"), {position = Config.DefaultTextLocation})
                    isPlayerInsideZone = true
                end, {model = data.model, coords = coords, warp = true})
            else
                exports.n_snippets:Notify(Lang("info.no_spawn_point"), "error", 3500, "Taxi Job")
            end
        else
            exports.n_snippets:Notify(Lang("info.no_spawn_point"), 'error', 3500, "Taxi Job")
            return
        end
    end)
end)

function closeMenuFull()
    lib.hideContext()
end

-- Events
RegisterNetEvent('n_taxijob:DoTaxiNpc', function()
    if whitelistedVehicle() then
        if not NpcData.Active then
            exports.n_snippets:Notify(Lang("info.waiting_for_client"), 'info', 3500, "Taxi Job")
            Wait(5000)
            NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
            if NpcData.LastNpc ~= nil then
                while NpcData.LastNpc ~= NpcData.CurrentNpc do
                    NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
                end
            end

            local Gender = math.random(1, #Config.NpcSkins)
            local PedSkin = math.random(1, #Config.NpcSkins[Gender])
            local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            NpcData.Npc = CreatePed(3, model, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z - 0.98, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].w, false, true)
            PlaceObjectOnGroundProperly(NpcData.Npc)
            FreezeEntityPosition(NpcData.Npc, true)
            if NpcData.NpcBlip ~= nil then
                RemoveBlip(NpcData.NpcBlip)
            end
            exports.n_snippets:Notify(Lang("info.npc_on_gps"), 'success', 3500, "Taxi Job")

           -- added checks to disable distance checking if polyzone option is used
            if Config.UseTarget then
                createNpcPickUpLocation()
            end

            NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z)

            SetBlipColour(NpcData.NpcBlip, 3)
            SetBlipRoute(NpcData.NpcBlip, true)
            SetBlipRouteColour(NpcData.NpcBlip, 3)
            NpcData.LastNpc = NpcData.CurrentNpc
            NpcData.Active = true
            resetMeter()
            -- SendNUIMessage({action = "toggleMeter"})
            -- SendNUIMessage({action = "updateMeter", meterData = meterData})
            -- added checks to disable distance checking if polyzone option is used
           if not Config.UseTarget then
                CreateThread(function()
                    while not NpcData.NpcTaken do

                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local dist = #(pos - vector3(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z))

                        if dist < 20 then
                            DrawMarker(2, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                            if dist < 5 then
                                DrawText3D(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, Lang("info.call_npc"))
                                if IsControlJustPressed(0, 38) then
                                    local veh = GetVehiclePedIsIn(ped, 0)
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                                    for i=maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(veh, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end
                                    lastLocation = GetEntityCoords(PlayerPedId())
                                    if not meterIsOpen then
                                        SendNUIMessage({
                                            action = "openMeter",
                                            toggle = true,
                                            meterData = Config.Meter
                                        })
                                    end
                                    if not meterActive then
                                        SendNUIMessage({action = "toggleMeter"})
                                    end
                                    meterIsOpen = true
                                    meterActive = true
                                    ClearPedTasksImmediately(NpcData.Npc)
                                    FreezeEntityPosition(NpcData.Npc, false)
                                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                    meterData.npc = true
                                    exports.n_snippets:Notify(Lang("info.go_to_location"), "info", 3500, "Taxi Job")
                                    if NpcData.NpcBlip ~= nil then
                                        RemoveBlip(NpcData.NpcBlip)
                                    end
                                    GetDeliveryLocation()
                                    NpcData.NpcTaken = true
                                end
                            end
                        end

                        Wait(1)
                    end
                end)
           end
        else
            RemoveBlip(NpcData.NpcBlip)
            ClearAllBlipRoutes()
            resetMeter()
            meterActive = false
            DeletePed(NpcData.Npc)
            ResetNpcTask()
            -- zone:destroy()
            exports.n_snippets:Notify(Lang("info.mission_canceled"), "info", 3500, "Taxi Job")
        end
    else
        exports.n_snippets:Notify(Lang("error.not_in_taxi"), "error", 3500, "Taxi Job")
    end
end)

RegisterNetEvent('n_taxijob:toggleMeter', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen and IsDriver() then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Config.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            exports.n_snippets:Notify(Lang("error.missing_meter"), 'error', 3500, "Taxi Job")
        end
    else
        exports.n_snippets:Notify(Lang("error.no_vehicle"), 'error', 3500, "Taxi Job")
    end
end)

RegisterNetEvent('n_taxijob:enableMeter', function()
    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        exports.n_snippets:Notify(Lang("error.not_active_meter"), 'error', 3500, "Taxi Job")
    end
end)

RegisterNetEvent('n_taxijob:toggleMuis', function()
    Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        exports.n_snippets:Notify(Lang("error.no_meter_sight"), 'error', 3500, "Taxi Job")
    end
end)

-- NUI Callbacks

RegisterNUICallback('enableMeter', function(data, cb)
    meterActive = data.enabled
    if not meterActive then resetMeter() end
    lastLocation = GetEntityCoords(PlayerPedId())
    cb('ok')
end)

RegisterNUICallback('hideMouse', function(_, cb)
    SetNuiFocus(false, false)
    mouseActive = false
    cb('ok')
end)

-- Threads
CreateThread(function()
    local TaxiBlip = AddBlipForCoord(Config.Location)
    SetBlipSprite (TaxiBlip, 198)
    SetBlipDisplay(TaxiBlip, 4)
    SetBlipScale  (TaxiBlip, 0.6)
    SetBlipAsShortRange(TaxiBlip, true)
    SetBlipColour(TaxiBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Lang("info.blip_name"))
    EndTextCommandSetBlipName(TaxiBlip)
end)

CreateThread(function()
    while true do
        Wait(1000)
        calculateFareAmount()
    end
end)

CreateThread(function()
    while true do
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if meterIsOpen then
                SendNUIMessage({action = "openMeter", toggle = false})
                meterIsOpen = false
            end
        end
        Wait(200)
    end
end)

RegisterNetEvent('n_taxijob:requestcab', function()
    TaxiGarage()
end)

-- POLY & TARGET Conversion code
function setupTarget()
    CubRenterZone = CircleZone:Create(Config.CubRenter.coords, Config.CubRenter.dist, {name = "CubRenterZone", debugPoly = false})
    
    CubRenterZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            spawnCubRenter()
        else
            despawnCubRenter()
        end
    end)
end

local zone
local delieveryZone

function createNpcPickUpLocation()
    zone = BoxZone:Create(Config.PZLocations.TakeLocations[NpcData.CurrentNpc].coord, Config.PZLocations.TakeLocations[NpcData.CurrentNpc].height, Config.PZLocations.TakeLocations[NpcData.CurrentNpc].width, {
        heading = Config.PZLocations.TakeLocations[NpcData.CurrentNpc].heading,
        debugPoly = false,
        minZ = Config.PZLocations.TakeLocations[NpcData.CurrentNpc].minZ,
        maxZ = Config.PZLocations.TakeLocations[NpcData.CurrentNpc].maxZ,
    })

    zone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if whitelistedVehicle() and not isInsidePickupZone and not NpcData.NpcTaken then
                isInsidePickupZone = true
                lib.showTextUI(Lang("info.call_npc"), {position = Config.DefaultTextLocation})
                callNpcPoly()
            end
        else
            isInsidePickupZone = false
        end
    end)
end

function spawnCubRenter()
    
    RequestModel(Config.CubRenter.ped)
    while not HasModelLoaded(Config.CubRenter.ped) do
        Wait(0)
    end
    TriggerEvent('nyam_snippets:blockEntity', 'ped', Config.CubRenter.ped)
    CubRenter = CreatePed(0, Config.CubRenter.ped, Config.CubRenter.coords.x, Config.CubRenter.coords.y, Config.CubRenter.coords.z-1.0, Config.CubRenter.coords.w, false, false)
    TaskStartScenarioInPlace(CubRenter, "WORLD_HUMAN_STAND_MOBILE", 0, true)
    FreezeEntityPosition(CubRenter, true)
    SetEntityInvincible(CubRenter, true)
    SetBlockingOfNonTemporaryEvents(CubRenter, true)

    exports['qb-target']:AddTargetEntity(CubRenter, {
        options = {
            {
                type = "server",
                event = "n_taxijob:becomeTaxiDriver",
                icon = "fas fa-sign-in-alt",
                label = '🚕 Become a driver',
                canInteract = function()
                    return PlayerData.metadata.isTaxiDriver ~= 1
                end,
            },
            {
                type = "server",
                event = "n_taxijob:retrieveTaxiDriver",
                icon = "fas fa-sign-in-alt",
                label = '🚕 Resign as driver',
                canInteract = function()
                    return PlayerData.metadata.isTaxiDriver == 1
                end,
            },
            {
                type = "client",
                event = "n_taxijob:requestcab",
                icon = "fa-solid fa-steering-wheel",
                label = '🚕 Request Taxi Cab',
                canInteract = function()
                    return PlayerData.metadata.isTaxiDriver == 1
                end,
            }
        },
        distance = 3.0
    })
end

function despawnCubRenter()
    DeleteEntity(CubRenter)
    -- DeletePed(CubRenter)
end

function createNpcDelieveryLocation()
    delieveryZone = BoxZone:Create(Config.PZLocations.DropLocations[NpcData.CurrentDeliver].coord, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].height, Config.PZLocations.DropLocations[NpcData.CurrentDeliver].width, {
        heading = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].heading,
        debugPoly = false,
        minZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].minZ,
        maxZ = Config.PZLocations.DropLocations[NpcData.CurrentDeliver].maxZ,
    })

    delieveryZone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if whitelistedVehicle() and not isInsideDropZone and NpcData.NpcTaken then
                isInsideDropZone = true
                lib.showTextUI(Lang("info.drop_off_npc"), {position = Config.DefaultTextLocation})
                dropNpcPoly()
            end
        else
            lib.hideTextUI()
            isInsideDropZone = false
        end
    end)
end

function callNpcPoly()
    CreateThread(function()
        while not NpcData.NpcTaken do
            local ped = PlayerPedId()
            if isInsidePickupZone then
                if IsControlJustPressed(0, 38) then
                    lib.hideTextUI()
                    resetMeter()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                    for i=maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(veh, i) then
                            freeSeat = i
                            break
                        end
                    end
                    lastLocation = GetEntityCoords(PlayerPedId())
                    SendNUIMessage({
                        action = "openMeter",
                        toggle = true,
                        meterData = Config.Meter
                    })
                    if not meterActive then SendNUIMessage({action = "toggleMeter"}) end

                    meterIsOpen = true
                    meterActive = true

                    ClearPedTasksImmediately(NpcData.Npc)
                    FreezeEntityPosition(NpcData.Npc, false)
                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                    exports.n_snippets:Notify(Lang("info.go_to_location"), "info", 3500, "Taxi Job")
                    meterData.npc = true
                    if NpcData.NpcBlip ~= nil then
                        RemoveBlip(NpcData.NpcBlip)
                    end
                    GetDeliveryLocation()
                    NpcData.NpcTaken = true
                    createNpcDelieveryLocation()
                    zone:destroy()
                end
            end
            Wait(1)
        end
    end)
end

function dropNpcPoly()
    CreateThread(function()
        while NpcData.NpcTaken do
            local ped = PlayerPedId()
            if isInsideDropZone then
                if IsControlJustPressed(0, 38) then
                    lib.hideTextUI()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    TriggerServerEvent('n_taxijob:NpcPay', meterData.currentFare)
                    TaskLeaveVehicle(NpcData.Npc, veh, 0)
                    SendNUIMessage({action = "toggleMeter"})
                    meterActive = false
                    SendNUIMessage({action = "resetMeter"})
                    Wait(1500)
                    SetVehicleDoorsShut(veh, true)
                    SetEntityAsMissionEntity(NpcData.Npc, false, true)
                    SetEntityAsNoLongerNeeded(NpcData.Npc)
                    local targetCoords = Config.NPCLocations.TakeLocations[NpcData.LastNpc]
                    TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                    exports.n_snippets:Notify(Lang("info.person_was_dropped_off"), 'success', 3500, "Taxi Job")
                    if NpcData.DeliveryBlip ~= nil then
                        RemoveBlip(NpcData.DeliveryBlip)
                    end
                    local RemovePed = function(p)
                        SetTimeout(60000, function()
                            DeletePed(p)
                        end)
                    end
                    RemovePed(NpcData.Npc)
                    ResetNpcTask()
                    delieveryZone:destroy()
                    TriggerEvent("n_taxijob:DoTaxiNpc")
                    break
                end
            end
            Wait(1)
        end
    end)
end

function setupCabParkingLocation()
    local taxiParking = BoxZone:Create(vector3(Config.CubRenter.coords.x, Config.CubRenter.coords.y, Config.CubRenter.coords.z), 26.0, 32.2, {
        debugPoly = false,
        name="n_taxi",
        heading=55
    })

    taxiParking:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside and Config.UseTarget then
            if whitelistedVehicle() then
                lib.showTextUI(Lang("info.vehicle_parking"), {position = Config.DefaultTextLocation})
                isPlayerInsideZone = true
            end
        else
            lib.hideTextUI()
            isPlayerInsideZone = false
        end
    end)

end

-- thread to handle vehicle parking
CreateThread(function()
    while true do
        if PlayerData and (not PlayerData.metadata.isTaxiDriver and PlayerData.metadata.isTaxiDriver ~= 1) then
            Wait(1000)
        end
        if isPlayerInsideZone then
            if IsControlJustReleased(0, 38) then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    local ped = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    ESX.TriggerServerCallback('n_taxijob:checkRented', function(plate)
                        if plate then
                            local cubPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                            if plate == cubPlate then
                                lib.hideTextUI()
                                if meterIsOpen then
                                    TriggerEvent('n_taxijob:toggleMeter')
                                    meterActive = false
                                end
                                TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
                                Wait(2000) -- 2 second delay just to ensure the player is out of the vehicle
                                DeleteVehicle(vehicle)
                                exports.n_snippets:Notify(Lang("info.taxi_returned"), 'success', 3500, "Taxi Job")
                                TriggerServerEvent('n_taxijob:returnCab', cubPlate)
                            else
                                exports.n_snippets:Notify(Lang("error.no_vehicle_plate"), 'error', 3500, "Taxi Job")
                            end
                        else
                            exports.n_snippets:Notify(Lang("error.no_vehicle_plate"), 'error', 3500, "Taxi Job")
                        end
                    end)
                end
            end
        end
        Wait(1)
    end
end)
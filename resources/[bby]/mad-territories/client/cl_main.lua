local Config = require 'config.client'
local Shared = require 'config.shared'
ESX = exports["es_extended"]:getSharedObject()

-- rotationCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 0)
sprayingParticle = nil
placingObject = nil
sprayingCan = nil
isPlacing = false
canPlace = false
isSelling = false
SoldPeds = {}
RobbedPeds = {}
inNegotiation = false
zone = nil
PlayerGang = "none"

cachedGraffitis = nil
graffitiZones = {}
graffitiBlips = {}

-- Initialize when player loads
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    cachedGraffitis = lib.callback.await('mad-territories:server:fetchGraffitisData') -- Get graffiti data
    PlayerGang = lib.callback.await('mad-territories:server:getPlayerGang') -- Get player's gang
    setupGraffitis()
end)

-- Initialize on resource start for players already in-game
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Wait(1000) -- Wait for ESX to initialize
    cachedGraffitis = lib.callback.await('mad-territories:server:fetchGraffitisData') -- Get graffiti data
    PlayerGang = lib.callback.await('mad-territories:server:getPlayerGang') -- Get player's gang
    setupGraffitis()
end)

function setupGraffitis()
    for k,v in pairs(cachedGraffitis) do
        RemoveBlip(graffitiBlips[v.key])
        if cachedGraffitis[v.key] and cachedGraffitis[v.key].entity and DoesEntityExist(cachedGraffitis[v.key].entity) then
            DeleteEntity(cachedGraffitis[v.key].entity)
        end
        if graffitiZones[v.key] ~= nil then graffitiZones[v.key]:remove() end
        
        graffitiZones[v.key] = lib.zones.sphere({
            key = v.key,
            coords = vec3(v.coords.x, v.coords.y, v.coords.z),
            radius = Config.graffitiRadius,
            debug = Shared.debug,
            inside = inside,
            onEnter = onEnter,
            onExit = onExit
        })

        if Config.everyoneCanSeeGangBlips then
            graffitiBlips[v.key] = AddBlipForRadius(vec3(v.coords.x, v.coords.y, v.coords.z), Config.graffitiRadius)
            SetBlipColour(graffitiBlips[v.key], Config.gangColors[v.gang])
            SetBlipAlpha(graffitiBlips[v.key], 128)
        else
            if PlayerGang ~= "none" then
                graffitiBlips[v.key] = AddBlipForRadius(vec3(v.coords.x, v.coords.y, v.coords.z), Config.graffitiRadius)
                SetBlipColour(graffitiBlips[v.key], Config.gangColors[v.gang])
                SetBlipAlpha(graffitiBlips[v.key], 128)
            end
        end
    end
end

function onExit(self)
    if cachedGraffitis[self.key] and cachedGraffitis[self.key].entity and DoesEntityExist(cachedGraffitis[self.key].entity) then
        DeleteEntity(cachedGraffitis[self.key].entity)
    end
    zone = nil
    if Config.useDrugSellingSystem then
        if Shared.target == "ox" then
            exports.ox_target:removeGlobalVehicle({'trunk_target_sell', 'trunk_target_stopsell'})
        else
            exports['qb-target']:RemoveTargetBone('boot', Shared.lang["startselling"])
            exports['qb-target']:RemoveTargetBone('boot', Shared.lang["stopselling"])
        end
        if isSelling then
            stopSelling()
            ESX.ShowNotification(Shared.lang["cantsellhere"])
        end
    end

    if Config.useRobNpcSystem then
        if Shared.target == "ox" then
            exports.ox_target:removeGlobalPed('robnpc_territories')
        else
            exports['qb-target']:RemoveGlobalPed(Shared.lang["robnpc"])
        end
    end
end

function onEnter(self)
    zone = self.key
    lib.requestModel(cachedGraffitis[self.key].model)
    cachedGraffitis[self.key].entity = CreateObjectNoOffset(cachedGraffitis[self.key].model, cachedGraffitis[self.key].coords.x, cachedGraffitis[self.key].coords.y, cachedGraffitis[self.key].coords.z, false, false)
    SetEntityRotation(cachedGraffitis[self.key].entity, cachedGraffitis[self.key].rotation.x, cachedGraffitis[self.key].rotation.y, cachedGraffitis[self.key].rotation.z)
    FreezeEntityPosition(cachedGraffitis[self.key].entity, true)

    if Config.useDrugSellingSystem then
        if Shared.target == "ox" then
            exports.ox_target:addGlobalVehicle({{
                name = 'trunk_target_sell',
                icon = 'fa-solid fa-user-secret',
                label = Shared.lang["startselling"],
                offset = vec3(0.5, 0, 0.5),
                distance = 2,
                canInteract = function(entity, distance, coords, name)
                    return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and not isSelling and IsVehicleSeatFree(entity, -1))
                end,
                onSelect = function(data)
                    local count = lib.callback.await('mad-territories:server:getPoliceCount')
                    if count >= Shared.policeNeededToSell then
                        isSelling = true
                        ESX.ShowNotification(Shared.lang["startsellhere"])
                        onSelectDoor(data.entity, 5)
                        startSelling(data.entity)
                    else
                        ESX.ShowNotification(Shared.lang["nocops"])
                    end
                end
            },
            {
                name = 'trunk_target_stopsell',
                icon = 'fa-solid fa-user-secret',
                label = Shared.lang["stopselling"],
                offset = vec3(0.5, 0, 0.5),
                distance = 2,
                canInteract = function(entity, distance, coords, name)
                    return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and isSelling and IsVehicleSeatFree(entity, -1))
                end,
                onSelect = function(data)
                    stopSelling()
                    ESX.ShowNotification(Shared.lang["cantsellhere"])
                    onSelectDoor(data.entity, 5)
                end
            }})
        else
            exports['qb-target']:AddTargetBone('boot', { 
                options = { 
                    {
                        icon = 'fa-solid fa-user-secret',
                        label = Shared.lang["startselling"],
                        canInteract = function(entity, distance, coords, name)
                            return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and not isSelling and IsVehicleSeatFree(entity, -1))
                        end,
                        action = function(entity)
                            local count = lib.callback.await('mad-territories:server:getPoliceCount')
                            if count >= Shared.policeNeededToSell then
                                isSelling = true
                                ESX.ShowNotification(Shared.lang["startsellhere"])
                                onSelectDoor(entity, 5)
                                startSelling(entity)
                            else
                                ESX.ShowNotification(Shared.lang["nocops"])
                            end
                        end
                    },
                    {
                        icon = 'fa-solid fa-user-secret',
                        label = Shared.lang["stopselling"],
                        canInteract = function(entity, distance, coords, name)
                            return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and isSelling and IsVehicleSeatFree(entity, -1))
                        end,
                        action = function(entity)
                            stopSelling()
                            ESX.ShowNotification(Shared.lang["cantsellhere"])
                            onSelectDoor(entity, 5)
                        end
                    }
                },
                distance = 2, 
            })
        end
    end

    if Config.useRobNpcSystem then
        if (cachedGraffitis[self.key].gang ~= PlayerGang) or Shared.debug then
            if Shared.target == "ox" then
                exports.ox_target:addGlobalPed({
                    name = 'robnpc_territories',
                    icon = 'fa-solid fa-user-secret',
                    label = Shared.lang["robnpc"],
                    distance = 2,
                    canInteract = function(entity, distance, coords, name)
                        return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and not isSelling and not HasRobbedPed(entity))
                    end,
                    onSelect = function(data)
                        RobNpc(data.entity)
                    end
                })
            else
                exports['qb-target']:AddGlobalPed({
                    options = { 
                    { 
                        icon = 'fas fa-example', 
                        label = Shared.lang["robnpc"], 
                        action = function(entity) 
                            RobNpc(entity)
                        end,
                        canInteract = function(entity, distance, data) 
                            return (not IsPedInAnyVehicle(cache.ped) and not IsPedDeadOrDying(cache.ped) and not isSelling and not HasRobbedPed(entity))
                        end,
                    }
                    },
                    distance = 2.0,
                })
            end
        end
    end
end

RegisterNetEvent('mad-territories:client:placeGraffiti', function(gang, model)
    local ped = cache.ped

    if isPlacing then
        return
    end

    PlaceGraffiti(model, function(result, coords, rotation)
        if result then
            local tempAlpha = 0
            local tempSpray = CreateObjectNoOffset(model, coords, false, false, false)
            lib.callback.await('mad-territories:server:removeSprayCan')

            SetEntityRotation(tempSpray, rotation.x, rotation.y, rotation.z)
            FreezeEntityPosition(tempSpray, true)
            SetEntityAlpha(tempSpray, 0, false)

            CreateThread(function()
                while tempAlpha < 255 do
                    tempAlpha = tempAlpha + 50
                    SetEntityAlpha(tempSpray, tempAlpha, false)
                    Wait(4000)
                end
            end)

            SprayingAnim()

            if lib.progressCircle({
                duration = Config.graffitiProgressbarTimer,
                position = 'bottom',
                label = 'Spraying',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            }) then
                StopAnimTask(ped, 'switch@franklin@lamar_tagging_wall', 'lamar_tagging_exit_loop_lamar', 1.0)
                StopParticleFxLooped(sprayingParticle, true)
                DeleteObject(sprayingCan)
                DeleteObject(tempSpray)
                sprayingParticle = nil
                sprayingCan = nil

                --register in database
                TriggerServerEvent('mad-territories:server:addServerGraffiti', model, coords, rotation)
            end
        end
    end)
end)

RegisterNetEvent('mad-territories:client:updateClientGraffitiData', function(data)
    cachedGraffitis = data
    setupGraffitis()
end)

RegisterNetEvent('mad-territories:client:removeClosestGraffiti', function()
    local ped = cache.ped
    local graffiti = GetClosestGraffiti(5.0)

    if not graffiti then
        ESX.ShowNotification(Shared.lang["nograffiti"])
    else
        TriggerServerEvent("mad-territories:server:notifyGang", tonumber(graffiti), "graffiti")
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)
        lib.callback.await('mad-territories:server:removeSprayCleaner')
        
        if lib.progressCircle({
            duration = Config.CleanGraffitiProgressbarTimer,
            position = 'bottom',
            label = 'Cleaning Spray',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
        }) then
            ClearPedTasks(ped)
            TriggerServerEvent("mad-territories:server:syncRemovedClientSpray", tonumber(graffiti))
            TriggerServerEvent('mad-territories:server:removeServerGraffiti', tonumber(graffiti))

            if Config.useDrugSellingSystem then
                if Shared.target == "ox" then
                    exports.ox_target:removeGlobalVehicle({'trunk_target_sell', 'trunk_target_stopsell'})
                else
                    exports['qb-target']:RemoveTargetBone('boot', Shared.lang["startselling"])
                    exports['qb-target']:RemoveTargetBone('boot', Shared.lang["stopselling"])
                end
                if isSelling then
                    stopSelling()
                    ESX.ShowNotification(Shared.lang["cantsellhere"])
                end
            end
        
            if Config.useRobNpcSystem then
                if Shared.target == "ox" then
                    exports.ox_target:removeGlobalPed('robnpc_territories')
                else
                    exports['qb-target']:RemoveGlobalPed(Shared.lang["robnpc"])
                end
            end
        end
    end
end)

RegisterNetEvent('mad-territories:client:syncRemovedClientSpray', function(key)
    RemoveBlip(graffitiBlips[key])
    if cachedGraffitis[key] and cachedGraffitis[key].entity and DoesEntityExist(cachedGraffitis[key].entity) then
        DeleteEntity(cachedGraffitis[key].entity)
    end
    if graffitiZones[key] ~= nil then graffitiZones[key]:remove() end
end)

RegisterNetEvent('mad-territories:client:alertGangMembers', function(key, ntype, coords)
    if ntype == "graffiti" then
        ESX.ShowNotification(Shared.lang["notifygang"])
        PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false)
        CreateThread(function()
            local alertblip = AddBlipForCoord(cachedGraffitis[key].coords.x, cachedGraffitis[key].coords.y, cachedGraffitis[key].coords.z)
            SetBlipSprite(alertblip, 161)
            SetBlipAsShortRange(alertblip, true)
            SetBlipColour(alertblip, 12)
            SetBlipScale(alertblip, 0.9)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Graffiti Being Erased')
            EndTextCommandSetBlipName(alertblip)
            Wait(40000)
            RemoveBlip(alertblip)
        end)
    elseif ntype == "npc" then
        ESX.ShowNotification(Shared.lang["notifygangnpc"])
        PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false)
        CreateThread(function()
            local npcblip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(npcblip, 110)
            SetBlipAsShortRange(npcblip, true)
            SetBlipColour(npcblip, 1)
            SetBlipScale(npcblip, 0.9)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Robbed Local')
            EndTextCommandSetBlipName(npcblip)
            Wait(40000)
            RemoveBlip(npcblip)
        end)
    end
end)

------------------------------Selling Stuff-----------------------------------

function onSelectDoor(data, door)
    local entity = data

    if NetworkGetEntityOwner(entity) == cache.playerId then
        return toggleDoorTerritories(entity, door)
    end

    TriggerServerEvent('mad-territories:server:toggleEntityDoor', VehToNet(entity), door)
end

RegisterNetEvent('mad-territories:toggleEntityDoor', function(netId, door)
    local entity = NetToVeh(netId)
    toggleDoorTerritories(entity, door)
end)

function startSelling(entity)
    if not isSelling or not DoesEntityExist(entity) then return end
    
    CreateThread(function()
        local closestPed, distance = GetClosestPed()
        
        -- Make sure we found a valid ped
        if closestPed and type(closestPed) == 'number' and DoesEntityExist(closestPed) then
            if not HasSoldPed(closestPed) then
                local vehicleCoords = GetEntityCoords(entity)
                
                SetEntityAsMissionEntity(closestPed)
                TaskGoToCoordAnyMeans(closestPed, vehicleCoords, 1.0, 0, false)
                AddSoldPed(closestPed)

                if Shared.target == "ox" then
                    exports.ox_target:addLocalEntity(closestPed, {{
                        name = 'trunk_selldrugs',
                        icon = 'fa-solid fa-user-secret',
                        label = Shared.lang["selldrugs"],
                        distance = 2,
                        canInteract = function(entity, distance, coords, name)
                            return (not IsPedInAnyVehicle(entity) and not IsPedDeadOrDying(entity) and isSelling)
                        end,
                        onSelect = function()
                            negotiateStuff(closestPed)     
                        end
                    }})
                else
                    exports['qb-target']:AddTargetEntity(closestPed, {
                        options = {
                            {
                                icon = 'fa-solid fa-user-secret',
                                label = Shared.lang["selldrugs"],
                                canInteract = function(entity, distance, coords, name)
                                    return (not IsPedInAnyVehicle(entity) and not IsPedDeadOrDying(entity) and isSelling)
                                end,
                                action = function()
                                    negotiateStuff(closestPed)     
                                end
                            }
                        },
                        distance = 2.0 
                    })
                end
            else
                print("Ped already in table")
            end
        else
            print("No valid ped found nearby")
        end
    end)
    
    -- Continue trying to find peds after the timeout
    if isSelling then
        SetTimeout(Config.timeBetweenDrugBuyers * 1000, function()
            startSelling(entity)
        end)
    end
end

function negotiateStuff(closestPed)
    local drug = math.random(1, #Shared.drugsPrices)
    local drugAmount = math.random(Shared.sellDrugAmount.min, Shared.sellDrugAmount.max)
    print("drug: ".. Shared.drugsPrices[drug].name.." amount: "..drugAmount)
    
    -- Use ESX.TriggerServerCallback to get player inventory
    ESX.TriggerServerCallback('esx:getPlayerData', function(data)
        local hasItem = false
        
        if data and data.inventory then
            for _, item in ipairs(data.inventory) do
                if item.name == Shared.drugsPrices[drug].name and item.count >= drugAmount then
                    hasItem = true
                    break
                end
            end
        end
        
        if hasItem then
            print("Player has the required items, proceeding with sale")
            TaskTurnPedToFaceEntity(closestPed, cache.ped, Config.negotiateTimer*1000)
            inNegotiation = true

            lib.registerContext({
                id = 'drugsell_menu',
                title = 'Drug Dealing',
                canClose = false,
                options = {
                    {
                        title = "Type: "..Shared.drugsPrices[drug].name.. "  \n Amount: "..drugAmount,
                        readOnly = true,
                        icon = 'cannabis',
                    },
                    {
                        title = 'Accept',
                        icon = 'check',
                        onSelect = function()
                            PlayGiveAnim(closestPed)
                            TriggerServerEvent("mad-territories:server:sellDrug", drug, Shared.drugsPrices[drug].name, drugAmount, zone)
                            if Shared.target == "ox" then
                                exports.ox_target:removeLocalEntity(closestPed, 'trunk_selldrugs')
                            else
                                exports['qb-target']:RemoveTargetEntity(closestPed, Shared.lang["selldrugs"])
                            end
                            SetEntityAsNoLongerNeeded(closestPed)
                            lib.hideContext(onExit)
                            inNegotiation = false
                            local random = math.random(1,100)
                            if random <= Config.chanceToCallCopsDrugSell then
                                Shared.AlertPolice()
                            end
                        end,
                    },
                    {
                        title = 'Cancel',
                        icon = 'xmark',
                        onSelect = function()
                            if Shared.target == "ox" then
                                exports.ox_target:removeLocalEntity(closestPed, 'trunk_selldrugs')
                            else
                                exports['qb-target']:RemoveTargetEntity(closestPed, Shared.lang["selldrugs"])
                            end
                            SetEntityAsNoLongerNeeded(closestPed)
                            lib.hideContext(onExit)
                            inNegotiation = false
                        end,
                    },
                }
            })

            lib.showContext('drugsell_menu')

            TimeoutMenu(closestPed)
        else
            print("Player doesn't have the required items")
            if Shared.target == "ox" then
                exports.ox_target:removeLocalEntity(closestPed, 'trunk_selldrugs')
            else
                exports['qb-target']:RemoveTargetEntity(closestPed, Shared.lang["selldrugs"])
            end
            SetEntityAsNoLongerNeeded(closestPed)
            ESX.ShowNotification(Shared.lang["nodrugs"])
        end
    end)
end

function TimeoutMenu(ped)
    SetTimeout(Config.negotiateTimer*1000, function()
        if inNegotiation then
            ESX.ShowNotification(Shared.lang["toomuchtime"])
            if Shared.target == "ox" then
                exports.ox_target:removeLocalEntity(ped, 'trunk_selldrugs')
            else
                exports['qb-target']:RemoveTargetEntity(ped, Shared.lang["selldrugs"])
            end
            SetEntityAsNoLongerNeeded(ped)
            lib.hideContext(onExit)
            inNegotiation = false
        end
    end)    
end

function stopSelling()
    isSelling = false
    for k, v in pairs(SoldPeds) do
        -- Make sure k is a valid ped entity and not a boolean
        if type(k) == 'number' and DoesEntityExist(k) then
            SetPedAsNoLongerNeeded(k)
            if Shared.target == "ox" then
                exports.ox_target:removeLocalEntity(k, 'trunk_selldrugs')
            else
                exports['qb-target']:RemoveTargetEntity(k, Shared.lang["selldrugs"])
            end
        end
    end
    
    inNegotiation = false
    lib.hideContext(onExit)
    
    -- Clear the SoldPeds table
    SoldPeds = {}
end

function AddSoldPed(entity)
    SoldPeds[entity] = true
end

function HasSoldPed(entity)
    return SoldPeds[entity] ~= nil
end

function PlayGiveAnim(tped)    
    local pid = cache.ped    
    FreezeEntityPosition(pid, true)        
    lib.requestAnimDict('mp_common')
    TaskPlayAnim(pid, "mp_common", "givetake2_a", 8.0, -8, 2000, 0, 1, 0,0,0)    
    TaskPlayAnim(tped, "mp_common", "givetake2_a", 8.0, -8, 2000, 0, 1, 0,0,0)
    FreezeEntityPosition(pid, false)    
end

--------------------Rob NPC stuff---------------------------
function RobNpc(entity)
    if IsPedArmed(cache.ped, 4) then
        AddRobbedPed(entity)
        SetEntityAsMissionEntity(entity)
        lib.requestAnimDict('random@mugging3')
        TaskStandStill(entity, Config.robAnimationTime * 1000)
        TaskTurnPedToFaceEntity(entity, cache.ped, Config.robAnimationTime*1000)
        FreezeEntityPosition(entity, true)
        TaskPlayAnim(entity, 'random@mugging3', 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
        TriggerServerEvent("mad-territories:server:notifyGang", tonumber(zone), "npc", GetEntityCoords(entity))
        if lib.progressCircle({
            duration = Config.robAnimationTime*1000,
            position = 'bottom',
            label = 'Robbing',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'random@shop_robbery',
                clip = 'robbery_action_b',
                flag = 16,
            },
        }) then
            FreezeEntityPosition(entity, false)
            ClearPedTasks(cache.ped)
            ClearPedTasks(entity)
            SetPedAsNoLongerNeeded(entity)
            TriggerServerEvent("mad-territories:server:giveNpcMoney", zone)

            local random = math.random(1,100)
            if random <= Config.chanceToCallCopsRobNpc then
                Shared.AlertPolice()
            end
        end
    else
        ESX.ShowNotification(Shared.lang["noweapon"])
    end
end

function AddRobbedPed(entity)
    RobbedPeds[entity] = true
end

function HasRobbedPed(entity)
    return RobbedPeds[entity] ~= nil
end

-- Utility functions that were previously missing
function PlaceGraffiti(model, cb)
    isPlacing = true
    canPlace = false
    
    -- Request the model
    lib.requestModel(model)
    
    -- Create temporary preview object
    placingObject = CreateObject(model, 0, 0, 0, false, false, false)
    SetEntityAlpha(placingObject, 200, false)
    SetEntityCollision(placingObject, false, false)
    
    -- Setup camera
    local coords = GetEntityCoords(cache.ped)
    -- SetCamActive(rotationCam, true)
    -- RenderScriptCams(true, false, 0, true, false)
    -- SetCamCoord(rotationCam, coords.x, coords.y, coords.z + 1.5)
    
    -- Main placement thread
    CreateThread(function()
        local heading = 0.0
        
        while isPlacing do
            Wait(0)
            DisableControlActions()
            
            local hitCoords, surfaceNormal, entityHit = GetCoordsFromRaycast(10.0)
            
            if hitCoords then
                -- Adjust object position to stick to walls/surfaces
                DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0, 255, 0, 200, false, false, 0, false, false, false, false)
                
                -- Update object position and rotation
                SetEntityCoords(placingObject, hitCoords.x, hitCoords.y, hitCoords.z, false, false, false, false)
                
                -- Handle rotation controls
                if IsControlPressed(0, 108) then -- NUM4
                    heading = heading - 0.5
                elseif IsControlPressed(0, 107) then -- NUM6
                    heading = heading + 0.5
                end
                
                SetEntityRotation(placingObject, 0.0, 0.0, heading, 2, true)
                
                -- Check if surface is valid for placing graffiti
                if entityHit ~= 0 and IsEntityAVehicle(entityHit) == false then
                    canPlace = true
                    SetEntityAlpha(placingObject, 200, false)
                else
                    canPlace = false
                    SetEntityAlpha(placingObject, 100, false)
                end
                
                -- Display help text
                local text = Shared.lang["options"]
                DrawText3D(hitCoords.x, hitCoords.y, hitCoords.z, text)
                
                -- Handle confirmation/cancellation
                if IsControlJustPressed(0, 194) then -- Backspace to cancel
                    isPlacing = false
                    canPlace = false
                    cb(false, nil, nil)
                elseif IsControlJustPressed(0, 191) and canPlace then -- Enter to confirm
                    local finalCoords = GetEntityCoords(placingObject)
                    local finalRotation = GetEntityRotation(placingObject, 2)
                    isPlacing = false
                    canPlace = false
                    cb(true, finalCoords, finalRotation)
                end
            end
        end
        
        -- Cleanup
        DeleteObject(placingObject)
        placingObject = nil
        SetCamActive(rotationCam, false)
        RenderScriptCams(false, false, 0, true, false)
    end)
end

function GetCoordsFromPlayerView(distance)
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(playerPed)
    local playerCamCoord = GetGameplayCamCoord()
    local direction = GetGameplayCamDirection()
    local destination = {
        x = playerCamCoord.x + direction.x * distance,
        y = playerCamCoord.y + direction.y * distance,
        z = playerCamCoord.z + direction.z * distance
    }
    
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(
        playerCamCoord.x, playerCamCoord.y, playerCamCoord.z, 
        destination.x, destination.y, destination.z, 
        1, playerPed, 7
    )
    local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    if hit == 1 then
        return vec3(hitCoords.x, hitCoords.y, hitCoords.z), vec3(surfaceNormal.x, surfaceNormal.y, surfaceNormal.z), entityHit
    else
        return nil, nil, nil
    end
end

function GetGameplayCamDirection()
    local rot = GetGameplayCamRot(2)
    local radX = rot.x * 0.0174532925
    local radY = rot.y * 0.0174532925
    local radZ = rot.z * 0.0174532925
    
    return vector3(
        -math.sin(radZ) * math.abs(math.cos(radX)),
        math.cos(radZ) * math.abs(math.cos(radX)),
        math.sin(radX)
    )
end

function VectorToRotation(normal)
    local rotation = vector3(0.0, 0.0, 0.0)
    rotation.x = math.atan2(normal.z, math.sqrt(normal.x * normal.x + normal.y * normal.y)) * 180.0 / math.pi - 90.0
    rotation.y = 0.0
    rotation.z = -math.atan2(normal.x, normal.y) * 180.0 / math.pi
    return rotation
end

-- Helper function to disable controls during placement
function DisableControlActions()
    DisableControlAction(0, 30, true) -- Move LR
    DisableControlAction(0, 31, true) -- Move UD
    DisableControlAction(0, 36, true) -- Duck
    DisableControlAction(0, 21, true) -- Sprint
    DisableControlAction(0, 75, true) -- Exit Vehicle
    DisableControlAction(0, 23, true) -- Enter Vehicle
    DisableControlAction(0, 47, true) -- Detonate
    DisableControlAction(0, 58, true) -- Throw Grenade
    DisableControlAction(0, 263, true) -- Melee Attack 1
    DisableControlAction(0, 264, true) -- Melee Attack 2
    DisableControlAction(0, 257, true) -- Attack
    DisableControlAction(0, 140, true) -- Melee Attack Light
    DisableControlAction(0, 141, true) -- Melee Attack Heavy
    DisableControlAction(0, 142, true) -- Melee Attack Alternate
    DisableControlAction(0, 143, true) -- Melee Block
end

-- Helper function for raycasting
function GetCoordsFromRaycast(distance)
    local camRot = GetCamRot(rotationCam, 2)
    local camCoord = GetCamCoord(rotationCam)
    local direction = RotationToDirection(camRot)
    local destination = {
        x = camCoord.x + direction.x * distance,
        y = camCoord.y + direction.y * distance,
        z = camCoord.z + direction.z * distance
    }
    local rayHandle = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, destination.x, destination.y, destination.z, -1, cache.ped, 0)
    local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    if hit == 1 then
        return vec3(hitCoords.x, hitCoords.y, hitCoords.z), vec3(surfaceNormal.x, surfaceNormal.y, surfaceNormal.z), entityHit
    else
        return nil, nil, nil
    end
end

-- Helper function to convert rotation to direction
function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- Helper function for 3D text
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
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 90)
end

-- Function to handle the spray animation and effects
function SprayingAnim()
    local ped = cache.ped
    lib.requestAnimDict('switch@franklin@lamar_tagging_wall')
    lib.requestModel(`prop_cs_spray_can`)
    
    sprayingCan = CreateObject(`prop_cs_spray_can`, 0, 0, 0, true, true, false)
    AttachEntityToEntity(sprayingCan, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.04, -70.0, 0.0, -10.0, true, true, false, true, 1, true)
    
    TaskPlayAnim(ped, 'switch@franklin@lamar_tagging_wall', 'lamar_tagging_exit_loop_lamar', 8.0, -8, -1, 49, 0, false, false, false)
    
    -- Start spray particle effect
    local boneIndex = GetPedBoneIndex(ped, 28422)
    sprayingParticle = StartParticleFxLoopedOnPedBone('scr_flat_smoke', ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 0.1, false, false, false)
    SetParticleFxLoopedAlpha(sprayingParticle, 0.8)
    SetParticleFxLoopedColour(sprayingParticle, 0.0, 0.0, 0.0, false)
end

function GetClosestGraffiti(radius)
    local playerCoords = GetEntityCoords(cache.ped)
    local closestDistance = radius
    local closestGraffiti = nil
    
    -- Loop through all graffitis to find the closest one
    for k, v in pairs(cachedGraffitis) do
        if v then
            local graffitiCoords = vec3(v.coords.x, v.coords.y, v.coords.z)
            local distance = #(playerCoords - graffitiCoords)
            
            if distance <= closestDistance then
                closestDistance = distance
                closestGraffiti = v.key
            end
        end
    end
    
    return closestGraffiti
end

function toggleDoorTerritories(vehicle, door)
    if not DoesEntityExist(vehicle) then return false end
    
    -- Check if door exists on this vehicle
    if not door or door < 0 or door > 5 then 
        print("Invalid door index:", door)
        return false
    end
    
    -- Get current door state
    local isDoorOpen = GetVehicleDoorAngleRatio(vehicle, door) > 0.0
    
    -- Toggle door state
    if isDoorOpen then
        SetVehicleDoorShut(vehicle, door, false) -- Close door
    else
        SetVehicleDoorOpen(vehicle, door, false, false) -- Open door
    end
    
    return true
end

function GetClosestPed(distance)
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(playerPed)
    local distance = distance or 5.0
    local closestPed
    local closestDistance = distance
    
    -- Get all peds in the area
    local peds = GetGamePool('CPed')
    
    for i = 1, #peds do
        local ped = peds[i]
        
        -- Skip if it's the player, dead, or in a vehicle
        if ped ~= playerPed and not IsPedDeadOrDying(ped, 1) and not IsPedInAnyVehicle(ped, false) then
            local pedCoords = GetEntityCoords(ped)
            local dist = #(playerCoords - pedCoords)
            
            -- Check if this is the closest ped so far
            if dist < closestDistance then
                closestPed = ped
                closestDistance = dist
            end
        end
    end
    
    -- Return the closest ped and its distance
    return closestPed or false, closestDistance
end
----------------------Reset graffitis-----------------------

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if cachedGraffitis == nil then return end
    for k,v in pairs(cachedGraffitis) do
        if v then
            if DoesEntityExist(cachedGraffitis[v.key].entity) then
                DeleteEntity(cachedGraffitis[v.key].entity)
            end
        end
    end
end)
local ESX = exports.es_extended:getSharedObject()
local isOnArea = false
local Animals = {}
local CurrentWeapon = nil
local MyGround = nil

local function initCam(entity)
    FreezeEntityPosition(cache.ped, true)
    ClearFocus()
    local playerCoords = cache.coords
    local entityCoords = GetEntityCoords(entity)

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", playerCoords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)

    SetCamCoord(cam, entityCoords.x, entityCoords.y + 2, entityCoords.z + 3.0)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z)

    return cam
end

local function stopCam(cam)
    ClearFocus()
    RenderScriptCams(false, true, 500, true, false)
    DestroyCam(cam, false)
    FreezeEntityPosition(cache.ped, false)
end

local function onEnter(self)
    -- print('entered area')
    isOnArea = true

    Wait(Config.Options.waitBefeSpawn*60000)
    
    if #Animals <= 0 then
        CreateAnimals()
    end
end
 
local function onExit(self)
    -- print('exited area')
    isOnArea = false
    DeleteAnimals()
end

CreateThread(function()
    lib.zones.poly({
        points = Config.Area.points,
        thickness = Config.Area.thickness,
        debug = false,
        inside = inside,
        onEnter = onEnter,
        onExit = onExit,
    })
end)

CreateThread(function()
    while true do
        if isOnArea then
            if #Animals > 0 then
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                for i, data in pairs(Animals) do
                    local AnimalCoords = GetEntityCoords(data.animal)
                    local distance = #(PlayerCoords - AnimalCoords)
                    if distance >= 180 then
                        DeleteEntity(data.animal)
                        Animals[i] = nil
                    end
                end
            end
            if #Animals <= Config.Options.respawnOnLeft then
                CreateAnimals()
            end
        end
        Wait(1000)
    end    
end)

function CreateAnimals()
    if isOnArea then
        local PlayerPed = PlayerPedId()
        local PlayerCoords = GetEntityCoords(PlayerPed)
        local randomMath = {'+', '-'}
        if CanSpawnAnimals(PlayerPed) then
            for animal, data in pairs(Config.Animals) do
                for i = 1, math.random(data.spawnAmount.min, data.spawnAmount.max) do
                    if #Animals <= Config.Options.maxSpawn then
                        local GeneratedCoord = vec3(PlayerCoords.x + (math.random(-100, 100)), PlayerCoords.y + (math.random(-100, 100)), PlayerCoords.z)
                        local GeneratedZ = getZ(GeneratedCoord)
                        local animalEntity = createPed(data.ped, vec3(GeneratedCoord.x, GeneratedCoord.y, GeneratedZ), 0.0, false, false)
                        local animalIndex = #Animals+1

                        Animals[animalIndex] = {}
                        Animals[animalIndex].animal = animalEntity
                        Animals[animalIndex].type = string.upper(animal)
                        Animals[animalIndex].blip = createEntityBlip({animal = animalEntity})
                        
                        SetRelationshipBetweenGroups(5, `WILD_ANIMAL`, `PLAYER`)
                        SetRelationshipBetweenGroups(5, `PLAYER`, `WILD_ANIMAL`)
                        SetPedRelationshipGroupHash(animalEntity, `WILD_ANIMAL`)
                    
                        TaskWanderStandard(animalEntity)
                        
                        Core.Target.addLocalEntity({
                            entity = animalEntity,
                            options = {
                                {
                                    icon = 'fas fa-not-equal',
                                    label = Lang("targets.butch_animal"),
                                    canInteract = function(entity)
                                        if IsEntityDead(entity) then
                                            if UserHoldingKnife() then
                                                return true
                                            end
                                        end
                                        return false
                                    end,
                                    onSelect = function()
                                        HarvestAnimal(animalIndex)
                                    end,
                                    distance = 2.0
                                },
                                {
                                    icon = 'fas fa-exclamation-triangle',
                                    label = Lang("targets.must_hold_kniffe"),
                                    canInteract = function(entity)
                                        if IsEntityDead(entity) then
                                            if not UserHoldingKnife() then
                                                return true
                                            end
                                        end
                                        return false
                                    end,
                                    distance = 2.0
                                },
                            }
                        })
                        Wait(500)
                    end
                end
            end
        else
            print('Cannot spawn animals while standing on this type of material: ' .. MyGround .. ' , add it on config')
        end
    end
end

function createPed(name, ...)
    local model = lib.requestModel(name)

    if not model then return end

    local ped = CreatePed(5, model, ...)

    SetModelAsNoLongerNeeded(model)
    return ped
end

function getZ(mapCoords)
    local safeZ = nil
    local z = 0.0

    repeat
        Wait(1)
        z += 5
        foundLand, safeZ = GetGroundZFor_3dCoord(mapCoords.x, mapCoords.y, z, 1)
    until foundLand

    return safeZ
end

function createEntityBlip(data)
    local blip = AddBlipForEntity(data.animal)

    SetBlipSprite(blip, 119)
    SetBlipScale(blip, 0.3)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Hunting Animal")
    EndTextCommandSetBlipName(blip)
    return blip
end

function CanSpawnAnimals(ped)
    MyGround = GetGroundHash(ped)
    
    for i = 1, #Config.Options.grounds do
        if Config.Options.grounds[i] == MyGround then
            return true
        end
    end
    
    return false
end

function GetGroundHash(ped)
    local posped = GetEntityCoords(ped)
    local num = StartShapeTestCapsule(posped.x, posped.y, posped.z + 4, posped.x, posped.y, posped.z - 2.0, 2, 1, ped, 7)
    local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
    return arg5
end

function DeleteAnimal(animalIndex)
    DeleteEntity(Animals[animalIndex].animal)
    Animals[animalIndex] = nil
end

function DeleteAnimals()
    for i, data in pairs(Animals) do
        DeleteEntity(data.animal)
    end
    Animals = {}
end

function HarvestAnimal(animalIndex)
    local cam = initCam(Animals[animalIndex].animal)
    FreezeEntityPosition(Animals[animalIndex].animal, true)
    
    lib.progressBar({
        duration = 5 * 1000,
        label = Lang("progbar.harvesting_animal"),
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search',
            flag = 1,
        },
    })
    stopCam(cam)
    -- Core.Notify(Lang("success.harvested_animal"), "success", 3500)
    TriggerServerEvent("n_hunting:harvestedAnimal", Animals[animalIndex].type)
    DeleteAnimal(animalIndex)
end

function UserHoldingKnife()
    if not CurrentWeapon then CurrentWeapon = GetCurrentPedWeapon(cache.ped) end

    for i, weapon in pairs(Config.Options.allowedKnive) do
        if joaat(CurrentWeapon) == weapon then return true end
    end
end

lib.onCache('weapon', function(value)
    CurrentWeapon = value
    if value and (value == -1466123874) then
        AimBlock()
    end
end)

function AimBlock()
    CreateThread(function()
        while cache.weapon do
            Wait(0)
            local aiming, entity = GetEntityPlayerIsFreeAimingAt(cache.playerId)
            local freeAiming = IsPlayerFreeAiming(cache.playerId)
            local type = GetEntityType(entity)
            
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisablePlayerFiring(cache.ped, true)
            
            if type == 1 and not IsPedAPlayer(entity) then
                Wait(500)
            end
            -- if aiming and not freeAiming or IsPedAPlayer(entity) or type == 2 or (type == 1 and IsPedInAnyVehicle(entity, false)) then
            --     DisableControlAction(0, 24, true)
            --     DisableControlAction(0, 47, true)
            --     DisableControlAction(0, 58, true)
            --     DisablePlayerFiring(cache.ped, true)
            -- end
        end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    DeleteAnimals()
end)
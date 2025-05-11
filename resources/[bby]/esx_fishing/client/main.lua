local canFish = false
local isFishing = false
local fishingRod
local currentZone = nil

local function WaterCheck()
    local headPos = GetPedBoneCoords(cache.ped, 31086, 0.0, 0.0, 0.0)
    local offsetPos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 50.0, -25.0)
    local water, waterPos = TestProbeAgainstWater(headPos.x, headPos.y, headPos.z, offsetPos.x, offsetPos.y, offsetPos.z)
    return water, waterPos
end

local fishAnimation = function(rodId, metadata)
    local ped = PlayerPedId()
    RequestAnimDict('mini@tennis')
    while not HasAnimDictLoaded('mini@tennis') do Wait(0) end
    TaskPlayAnim(ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
    while IsEntityPlayingAnim(ped, 'mini@tennis', 'forehand_ts_md_far', 3) do Wait(0) end

    RequestAnimDict('amb@world_human_stand_fishing@idle_a')
    while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do Wait(0) end
    TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_a', 1.0, -1.0, 1.0, 10, 0, 0, 0, 0)

    local castTime = Config.DefaultCastTime
    if currentZone and Config.FishingZones[currentZone] and Config.FishingZones[currentZone].CastTime then
        castTime = Config.FishingZones[currentZone].CastTime
    end

    Wait(math.random(castTime.minimum, castTime.maximum) * 1000)

    local success = false
    local minigame = Config.DefaultMiniGame
    if currentZone and Config.FishingZones[currentZone] and Config.FishingZones[currentZone].MiniGame then
        minigame = Config.FishingZones[currentZone].MiniGame
    end

    for i = 1, math.random(minigame.countMin, minigame.countMax), 1 do
        if not IsEntityPlayingAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 3) then
            TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 10, 0, 0, 0, 0)
            Citizen.Wait(2000)
        end
        
        exports['ps-ui']:Circle(function(successMinigame)
            if successMinigame then
                success = true
            end
        end, 1, 10)
        Wait(100)
    end

    local stress = Config.DefaultStress
    if currentZone and Config.FishingZones[currentZone] and Config.FishingZones[currentZone].Stress then
        stress = Config.FishingZones[currentZone].Stress
    end

    local quality = Config.DefaultRemoveFishingRodHealth
    if currentZone and Config.FishingZones[currentZone] and Config.FishingZones[currentZone].RemoveFishingRodHealth then
        quality = Config.FishingZones[currentZone].RemoveFishingRodHealth
    end

    if success then
        RequestAnimDict('anim@move_m@trash')
        while not HasAnimDictLoaded('anim@move_m@trash') do Wait(0) end
        TaskPlayAnim(ped, 'anim@move_m@trash', 'pickup', 4.0, -1.0, -1, 48, 0, 0, 0, 0)
        Citizen.Wait(1200)

        TriggerServerEvent('esx_fishing:server:ReceiveFish', currentZone, rodId, metadata)
        -- TriggerEvent('esx_status:remove', 'stress', stress.RemoveOnSuccess)
        -- TriggerServerEvent('inventory:removequality', nil, 'fishingrod', quality.onSuccess)
    else
        -- TriggerEvent('esx_status:add', 'stress', stress.AddOnFail)
        -- TriggerServerEvent('inventory:removequality', nil, 'fishingrod', quality.onFail)
        ESX.ShowNotification('~r~The fish got away!')
    end

    ClearPedTasks(ped)
    DeleteObject(fishingRod)
    isFishing = false
end

local startFishing = function(rodId, metadata)
    if isFishing then return end
    isFishing = true

    local fishingRodHash = `prop_fishing_rod_01`
    if not IsModelValid(fishingRodHash) then return end
    if not HasModelLoaded(fishingRodHash) then RequestModel(fishingRodHash) end
    while not HasModelLoaded do Wait(0) end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local object = CreateObject(fishingRodHash, pedCoords, true, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(object)
    fishingRod = object
    fishAnimation(rodId, metadata)
end

RegisterNetEvent("esx_fishing:placeBaitAnim", function()
    if isFishing then return end
    local fishingRodHash = `prop_fishing_rod_01`
    if not IsModelValid(fishingRodHash) then return end
    if not HasModelLoaded(fishingRodHash) then RequestModel(fishingRodHash) end
    while not HasModelLoaded do Wait(0) end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local object = CreateObject(fishingRodHash, pedCoords, true, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(object)
    fishingRod = object
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    
    if lib.progressCircle({
        duration = 4500,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    }) then 
        ClearPedTasks(ped)
        DeleteObject(fishingRod)
    end
end)

RegisterCommand('anchor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        if not IsBoatAnchoredAndFrozen(vehicle) then
            SetBoatFrozenWhenAnchored(vehicle, true)
            SetBoatAnchor(vehicle, true)
            ESX.ShowNotification('Anchor enabled!')
        else
            SetBoatFrozenWhenAnchored(vehicle, false)
            SetBoatAnchor(vehicle, false)
            ESX.ShowNotification('Anchor disabled!')
        end
    end
end)

RegisterNetEvent('esx_fishing:client:FishingRod', function(rodId, metadata)
    if IsEntityInWater(PlayerPedId()) then return end
    if IsPedInAnyVehicle(PlayerPedId(), false) then return end
    -- if not canFish then
    --     ESX.ShowNotification('~r~You can\'t fish over here..')
    --     return
    -- end
    local water, waterLoc = WaterCheck()

    if water then
        startFishing(rodId, metadata)
    else
        ESX.ShowNotification('Are you trying to catch what?!', "error", 3500)
    end
end)

CreateThread(function()
    local zones = {}

    for k, v in pairs(Config.FishingZones) do
        if v.box then -- BoxZone
            zones[#zones+1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = k,
                minZ = v.minZ,
                maxZ = v.maxZ,
                debugPoly = Config.DebugPoly
            })
        else -- PolyZone
            zones[#zones+1] = PolyZone:Create(v.points, {
                name = k,
                minZ = v.minZ,
                maxZ = v.maxZ,
                debugGrid = Config.DebugPoly,
            })
        end
    end

    -- Create ComboZone
    local fishingCombo = ComboZone:Create(zones, {
        name = "fishingCombo", 
        debugPoly = Config.DebugPoly
    })

    -- Enter/Exit Fishing Zone
    -- fishingCombo:onPlayerInOut(function(isPointInside, point, zone)
    --     if isPointInside then
    --         currentZone = tonumber(zone.name)
    --         if Config.ZoneAlert then
    --             TriggerEvent('textui:open', 'Fishing', 'darkgreen', 'left')
    --         end
    --         canFish = true
    --     else
    --         if Config.ZoneAlert then
    --             TriggerEvent('textui:close')
    --         end
    --         canFish = false
    --     end
    -- end)
end)
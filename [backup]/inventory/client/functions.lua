local pedSpawned = false
local ShopPed = {}
local is_disable_thread_running = false
local isPlayerDead = false

Lang = function(str)
	return Locales['en'][str] or ""
end

RegisterNetEvent("esx:onCloseInventory", function()
    -- TriggerScreenblurFadeOut(100)
    -- Just an event for your extra code when player closes the inventory
end)

AddEventHandler("inventory:setPlayerDead", function(bool)
    isPlayerDead = bool
end)

fixUi = function()
    closeInventory()
    SendNUIMessage({ action = "toggleHotbar", open = false })
end

loadModel = function(model)
	if not HasModelLoaded(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end
	end
end

loadAnim = function(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
	end
end

-- Checking if player is in an action, arrested, in handcuffs or dead to prevent from opening inventory or hotbar & hotbar use (1-5 keys)
isPlayerBusy = function()
    -- Prevents from showing false information on inventory before player clearly loads into server
    if not ESX.PlayerLoaded then
        return true
    end
    if IsPlayerDead(PlayerId()) then
        return true
    end
    -- checks if pause menu active
    if IsPauseMenuActive() then
        return true 
    end
    -- checks if in ui
    if IsNuiFocused() then
        return true
    end
    if IsNuiFocusKeepingInput() then
        return true
    end
    -- If player is in inventory then prevents from opening again or using an item via key
    if inInventory or isInventoryOpening or isCrafting then
        return true
    end
    -- Checks if holstering weapon to prevent glitching the animation
    if not canFireWeapon() then
        return true
    end

    if isPlayerDead then return true end

    return false
end

StartThiefAnim = function()
    local dict = 'random@shop_robbery'
    loadAnim(dict)
    TaskPlayAnim(ped, dict, "robbery_action_b", 4.0, 4.0, 3000, 49, 0, 0.0, 0.0, 0.0)
end

StartGiveAnim = function()
    local animations = Config.Animations.give
    loadAnim(animations.dict)
	TaskPlayAnim(PlayerPedId(), animations.dict, animations.anim, 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(1500)
    StopAnimTask(PlayerPedId(), animations.dict, animations.anim, 3.0)
end

ProgressBar = function(text, time, settings, cb)
    if not settings then settings = {} end
    exports.progressbar:Progress({
		name = "inventory_pbar",
		duration = time,
		label = text,
		useWhileDead = settings.whileDead or false,
		canCancel = settings.canCancel or false,
		controlDisables = {
			disableMovement = settings.movement or false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,    
		},
		animation = {
			animDict = settings.dict or nil,
			anim = settings.anim or nil,
			flags = settings.flags or 0
		}
	}, function(cancelled)
        if cb then
            if cancelled then
                cb(true)
            else
                cb(false)
            end
        end
    end) 
end

isNightTime = function()
	local curhour = GetClockHours()
	if curhour >= 21 or curhour <= 5 then
		return true
	end
	return false
end

ShowNotification = function(msg, _type, timer)
	ESX.ShowNotification(msg, timer, _type)
end

vehicleInFront = function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vec = GetEntityForwardVector(ped)
    local new_pos = { x = pos.x + vec.x, y = pos.y + vec.y, z = pos.z }
    local thisVeh, dist = ESX.Game.GetClosestVehicle(new_pos)
    if thisVeh == 0 then
        thisVeh, dist = ESX.Game.GetClosestVehicle(pos)
    end
    return thisVeh, dist
end

run_disabling_thread = function()
    if is_disable_thread_running then return end
    is_disable_thread_running = true
    CreateThread(function()
        while inInventory or isInventoryOpening do
            DisablePlayerFiring(PlayerId())
            DisableControlAction(0, 0, true) -- V --> Switching Camera
            DisableControlAction(0, 1, true) -- Mouse Up
            DisableControlAction(0, 2, true) -- Mouse Down
            DisableControlAction(0, 4, true) -- Mouse Down
            DisableControlAction(0, 6, true) -- Mouse Right
            DisableControlAction(0, 24, true) -- Mouse Attack
            DisableControlAction(0, 25, true) -- Mouse Aim
            DisableControlAction(0, 37, true) -- Swap Gun
            DisableControlAction(0, 44, true) -- Q
            DisableControlAction(0, 45, true) -- R
            DisableControlAction(0, 68, true) -- Vehicle Aiming Right Mouse
            DisableControlAction(1, 106, true) -- Vehicle Control Left Mouse
            DisableControlAction(1, 140, true) -- Disable Attack
            DisableControlAction(1, 141, true) -- Disable Left click
            DisableControlAction(1, 142, true) -- Disable R
            DisableControlAction(0, 192, true) -- TAB
            DisableControlAction(0, 204, true) -- TAB
            DisableControlAction(0, 211, true) -- TAB
            DisableControlAction(0, 200, true) -- ESC
            Wait(1)
        end
        is_disable_thread_running = false
    end)
end

-- Shop Peds Creation
createPeds = function()
    if pedSpawned then return end
    for k, v in pairs(Config.Locations) do
        if not ShopPed[k] then 
            ShopPed[k] = {} 
        end
        local current = v["ped"]
        current = type(current) == 'string' and GetHashKey(current) or current
        loadModel(current)
        ShopPed[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
        SetEntityInvincible(ShopPed[k], true)
        SetBlockingOfNonTemporaryEvents(ShopPed[k], true)
        TaskStartScenarioInPlace(ShopPed[k], v["scenario"], true)
        FreezeEntityPosition(ShopPed[k], true)
        exports[Config.TargetResource]:AddTargetEntity(ShopPed[k], {
            distance = 2.0,
            options = {
                {
                    label = v["targetLabel"],
                    icon = v["targetIcon"],
                    item = v["item"],
                    job = v["job"],
                    gang = v["gang"],
                    action = function()
                        exports.inventory:openShop(k, Config.Locations[k])
                    end,
                }
            },
        })
    end
    pedSpawned = true
end

-- Shop Peds Deletion
deletePeds = function()
    if pedSpawned then
        for _, v in pairs(ShopPed) do
            DeletePed(v)
        end
    end
end

-- Shop Blips Creation
createBlips = function()
    for store, _ in pairs(Config.Locations) do
        if Config.Locations[store].showblip then
            local locationData = Config.Locations[store].coords
            local StoreBlip = AddBlipForCoord(locationData.x, locationData.y, locationData.z)
            SetBlipSprite(StoreBlip, Config.Locations[store].blipsprite)
            SetBlipScale(StoreBlip, Config.Locations[store].blipscale or 0.6)
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.Locations[store].blipcolor)
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Locations[store].label)
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end

-- Unused. Just for functionality when using "esx:setSkin" event
updateInventorySkinData = function(skin)

end

-- Unused. Just for functionality when using "esx:setJob" event
updateJobData = function(job)

end

-- Unused. Just for functionality when using "esx:playerLoaded" event
playerLoadedUpdateData = function(plyData)

end

-- Unused. Just for functionality when using "esx:onPlayerDeath" event
onPlayerDeadEvent = function(death_data)

end

-- Unused. Just for functionality
canRobTarget = function(targetId)

    return true
end

-- found the dumpster and checking if opened by mistake
tryOpeningDumpster = function(Dumpster)
    if not IsPedSprinting(PlayerPedId()) and not IsPedJumping(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
        ExecuteCommand('e inspect')
        ProgressBar("Opening Dumpster...", 2000, {whileDead = false, canCancel = false}, function(cancelled)
            if not cancelled then
                CurrentDumpster = Dumpster
                local dumpCoords = GetEntityCoords(Dumpster)
                ExecuteCommand('e c')
                local data = {
                    model = GetEntityModel(Dumpster),
                    coords = vector3(ESX.Math.Round(dumpCoords.x, 2),ESX.Math.Round(dumpCoords.y, 2),ESX.Math.Round(dumpCoords.z, 2))
                }
                TriggerServerEvent("inventory:OpenDumpster", data)
            end
        end)
    end
end

-- Checking params for trunk opening
isCloseToTrunk = function()
    local curVeh = nil
    local vehicle, dist = vehicleInFront()
    if vehicle ~= 0 and vehicle ~= nil then
        local model = GetEntityModel(vehicle)
        local boot = GetEntityBoneIndexByName(vehicle, "platelight")
        if IsBackEngine(model) then
            boot = GetEntityBoneIndexByName(vehicle, "boot")
        end
        local neon_b = GetEntityBoneIndexByName(vehicle, "neon_b")
        local bootpos = GetWorldPositionOfEntityBone(vehicle, boot)
        local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -0.0, 0)
        local neonpos = GetWorldPositionOfEntityBone(vehicle, neon_b)
        if IsBackEngine(model) then
            trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
        end
        local boneDist  = #(vector2(pos.x, pos.y) - vector2(trunkpos.x, trunkpos.y))
        local boneDist2 = #(vector2(pos.x, pos.y) - vector2(bootpos.x, bootpos.y))
        local boneDist3 = #(vector2(pos.x, pos.y) - vector2(neonpos.x, neonpos.y))
        if (boneDist < 1.25 or boneDist2 < 1.25 or boneDist3 < 1.25) and not inVehicle then
            if GetVehicleDoorLockStatus(vehicle) < 2  and not IsPedSprinting(PlayerPedId()) and not IsPedJumping(PlayerPedId()) then
                CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                curVeh = vehicle
                CurrentGlovebox = nil
                if Config.BannedPlates[tostring(CurrentVehicle)] or string.match(tostring(CurrentVehicle), "RENT") or string.match(tostring(CurrentVehicle), "TEST") then
                    CurrentVehicle = nil
                end
            end
        else
            CurrentVehicle = nil
        end
    else
        CurrentVehicle = nil
    end
    return curVeh
end

-- Checking params for glovebox opening
isInVehicleForGlovebox = function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
    curVeh = vehicle
    CurrentVehicle = nil
    if Config.BannedPlates[tostring(CurrentGlovebox)] or string.match(tostring(CurrentGlovebox), "RENT") or string.match(tostring(CurrentGlovebox), "TEST") or GetVehicleClass(vehicle) == 13 then
        CurrentGlovebox = nil
    end
end

isInVehicleForTrunk = function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    CurrentTrunk = GetVehicleNumberPlateText(vehicle)
    print(CurrentTrunk)
    print(" function is trunk")
    curVeh = vehicle
    CurrentTrunk = nil
        if Config.BannedPlates[tostring(CurrentTrunk)] or string.match(tostring(CurrentTrunk), "RENT") or string.match(tostring(CurrentTrunk), "TEST") or GetVehicleClass(vehicle) == 13 then
        CurrentTrunk = nil
    end
end

-- Getting trunk information
getVehicleInformation = function(curVeh)
    local vehicleClass = GetVehicleClass(curVeh)
    if vehicleClass ~= 8 and vehicleClass ~= 13 then
        local vehCapacity = Config.VehicleCapacity[tostring(vehicleClass)]
        local other = {
            maxweight = vehCapacity.maxweight,
            slots = vehCapacity.slots
        }
        return other
    end
    return nil
end

checkforLeftOveritemsonTrunk = function()
    local foundWalkingStick, foundVape, foundBong
    for k,v in pairs(inv) do
        if v and v.name == "walkingstick" then
            foundWalkingStick = true
        end
        if v and v.name == "vape" then
            foundVape = true
        end
        if v and v.name == "bong" then
            foundBong = true
        end
    end
    if not foundVape then
        RemoveVape()
    end
    if not foundBong then
        RemoveBong()
    end
    if not foundWalkingStick then
        RemoveWalkingStick()
    end
end
    
-- It gets triggered on "esx:setInventory" and resets some stuff for non leftover items
checkforLeftOveritems = function(inv)
    local foundWalkingStick, foundVape, foundBong
    for k,v in pairs(inv) do
        if v and v.name == "walkingstick" then
            foundWalkingStick = true
        end
        if v and v.name == "vape" then
            foundVape = true
        end
        if v and v.name == "bong" then
            foundBong = true
        end
    end
    if not foundVape then
        RemoveVape()
    end
    if not foundBong then
        RemoveBong()
    end
    if not foundWalkingStick then
        RemoveWalkingStick()
    end
end
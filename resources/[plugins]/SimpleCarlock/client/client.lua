-- File: client.lua
-- Description: Client-side logic for SimpleCarlock.

-- ========== LOCAL STATE ==========
local playerKeys = {} -- Stores plates of vehicles the player has keys for.
local isLockpicking = false
local vehicleBeingPicked = nil
local isHotwiring = false
local vehicleBeingHotwired = nil
local nuiReady = false
local canAutolock = true -- Flag to temporarily disable autolocking.
local helpMenuOpen = false
local shownHelpForVehicle = {} -- Tracks if help message has been shown for a vehicle.

-- ========== LOCAL FUNCTIONS ==========
function ShowNotification(msg)
    -- Use ESX notification instead of GTA native notification
    ESX.ShowNotification(msg)
end

-- Finds the closest vehicle to a given position.
function GetClosestVehicle(pos)
    local closestVeh, closestDist = nil, -1
    local handle, veh = FindFirstVehicle()
    local success
    repeat
        if DoesEntityExist(veh) then
            local vehPos = GetEntityCoords(veh)
            local dist = #(pos - vehPos)
            if closestDist == -1 or dist < closestDist then
                closestVeh, closestDist = veh, dist
            end
        end
        success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return closestVeh, closestDist
end

-- ========== NUI CALLBACKS ==========
RegisterNuiCallback('nuiReady', function(data, cb) nuiReady = true; cb('ok'); end)

-- Lockpick minigame callback (replaced with boii_minigames)
function HandleLockpickResult(success)
    isLockpicking = false
    ClearPedTasks(PlayerPedId())
    
    if success then
        ShowNotification("~g~Lock successfully picked!")
        if DoesEntityExist(vehicleBeingPicked) then
            SetVehicleDoorsLocked(vehicleBeingPicked, 1) -- 1 = Unlocked but not forced open
            ShowNotification("~g~The door is now unlocked.")
        end
    else
        ShowNotification("~r~You broke your pick! Lockpicking failed.")
    end
    vehicleBeingPicked = nil
end

-- Hotwiring minigame callback
function HandleHotwireResult(success)
    isHotwiring = false
    ClearPedTasks(PlayerPedId())
    
    if success then
        ShowNotification("~g~Vehicle successfully hotwired!")
        if DoesEntityExist(vehicleBeingHotwired) then
            SetVehicleEngineOn(vehicleBeingHotwired, true, false, true)
            ShowNotification("~g~The engine is now running.")
        end
    else
        ShowNotification("~r~Hotwiring failed! You triggered the alarm.")
        if DoesEntityExist(vehicleBeingHotwired) then
            SetVehicleAlarm(vehicleBeingHotwired, true)
            StartVehicleAlarm(vehicleBeingHotwired)
        end
    end
    vehicleBeingHotwired = nil
end

RegisterNuiCallback('closeHelpMenu', function(data, cb)
    helpMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- ========== NET EVENTS ==========
RegisterNetEvent('carLock:setVehicleKey'); AddEventHandler('carLock:setVehicleKey', function(plate) if plate then playerKeys[plate] = true; end; end)
RegisterNetEvent('carLock:removeVehicleKey'); AddEventHandler('carLock:removeVehicleKey', function(plate) if plate then playerKeys[plate] = nil; end; end)
RegisterNetEvent('carLock:showNotification'); AddEventHandler('carLock:showNotification', function(msg) ShowNotification(msg); end)

RegisterNetEvent('carLock:updateLockStatus')
AddEventHandler('carLock:updateLockStatus', function(netId, locked)
    local veh = NetToVeh(netId)
    if DoesEntityExist(veh) then
        SetVehicleDoorsLocked(veh, locked and 2 or 1) -- 2 = Locked, 1 = Unlocked
        
        -- Play lock/unlock emote for nearby players
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local vehiclePos = GetEntityCoords(veh)
        local distance = #(playerPos - vehiclePos)
        
        -- Only play emote if player is near the vehicle (within 10 meters)
        if distance <= 10.0 then
            -- Load animation dictionary
            RequestAnimDict("anim@mp_player_intmenu@key_fob@")
            while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
                Wait(1)
            end
            
            -- Play key fob animation
            TaskPlayAnim(playerPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, -8.0, 1000, 48, 0, false, false, false)
            
            -- Clean up animation dictionary after use
            Wait(1000)
            RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
        end
        
        if nuiReady then
            local soundName = locked and "lock" or "unlock"
            SendNuiMessage(json.encode({action = 'playSound', sound = soundName, volume = Config.Settings.soundVolume}))
        end
        -- Animate vehicle lights to give feedback.
        SetVehicleLights(veh, 2); Wait(150); SetVehicleLights(veh, 0); Wait(150); SetVehicleLights(veh, 2); Wait(150); SetVehicleLights(veh, 0)
    end
end)

RegisterNetEvent('carLock:startLockpickMinigame')
AddEventHandler('carLock:startLockpickMinigame', function(netId)
    isLockpicking = true
    vehicleBeingPicked = NetToVeh(netId)
    local ply = PlayerPedId()

    ShowNotification("~b~You begin to pick the lock...")
    local anim = "mini@repair"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do Wait(100) end
    
    TaskPlayAnim(ply, anim, "fixing_a_ped", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Wait before starting the key drop minigame
    CreateThread(function()
        Wait(Config.Settings.lockpickInitialWait)
        if not isLockpicking or not DoesEntityExist(vehicleBeingPicked) then 
            isLockpicking = false
            ClearPedTasks(PlayerPedId())
            return
        end
        
        -- Start boii_minigames key_drop minigame
        exports['boii_minigames']:key_drop({
            style = 'default',
            score_limit = 10, -- 10 letters to drop
            miss_limit = 1, -- Only 1 miss allowed before fail
            fall_delay = 1000,
            new_letter_delay = 2000
        }, function(success)
            HandleLockpickResult(success)
        end)
    end)
end)

-- ========== COMMANDS ==========
-- Lockpick item usage event (for ESX item integration)
RegisterNetEvent('carLock:useLockpick')
AddEventHandler('carLock:useLockpick', function()
    if isLockpicking or isHotwiring then return end
    
    local ply = PlayerPedId()
    if IsPedInAnyVehicle(ply, false) then
        ShowNotification("~r~You cannot do this from inside a vehicle.")
        return
    end

    local closestVeh, closestDist = GetClosestVehicle(GetEntityCoords(ply))
    if closestVeh and closestDist <= Config.Settings.lockpickDistance then
        TriggerServerEvent('carLock:requestLockpick', VehToNet(closestVeh))
    else
        ShowNotification("~y~No vehicle close enough to lockpick.")
    end
end)

-- Keep command for testing/admin use
RegisterCommand('lockpick', function()
    TriggerEvent('carLock:useLockpick')
end, false)

-- Hotwire function (called with H key or command)
function StartHotwire()
    if isLockpicking or isHotwiring then return end
    
    local ply = PlayerPedId()
    if not IsPedInAnyVehicle(ply, false) then
        ShowNotification("~r~You must be inside a vehicle to hotwire it.")
        return
    end

    local vehicle = GetVehiclePedIsIn(ply, false)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Check if player already has keys
    if plate and playerKeys[plate] then
        ShowNotification("~y~You already have keys for this vehicle.")
        return
    end
    
    -- Check if engine is already on
    if GetIsVehicleEngineRunning(vehicle) then
        ShowNotification("~y~The engine is already running.")
        return
    end

    isHotwiring = true
    vehicleBeingHotwired = vehicle
    
    ShowNotification("~b~You begin to hotwire the vehicle...")
    local anim = "mini@repair"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do Wait(100) end
    
    TaskPlayAnim(ply, anim, "fixing_a_ped", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Show progress bar for 5 seconds
    CreateThread(function()
        -- Progress bar here (you can replace with your progress bar system)
        local progressTime = 5000
        local startTime = GetGameTimer()
        
        while GetGameTimer() - startTime < progressTime and isHotwiring do
            local progress = (GetGameTimer() - startTime) / progressTime
            -- Draw progress bar (you can customize this)
            DrawRect(0.5, 0.9, 0.2, 0.02, 0, 0, 0, 150)
            DrawRect(0.5, 0.9, 0.2 * progress, 0.02, 0, 255, 0, 255)
            Wait(0)
        end
        
        if not isHotwiring or not DoesEntityExist(vehicleBeingHotwired) then 
            isHotwiring = false
            ClearPedTasks(PlayerPedId())
            return
        end
        
        -- Start boii_minigames key_drop minigame after progress bar
        exports['boii_minigames']:key_drop({
            style = 'default',
            score_limit = 10, -- 10 letters to drop
            miss_limit = 1, -- Only 1 miss allowed before fail
            fall_delay = 1000,
            new_letter_delay = 2000
        }, function(success)
            HandleHotwireResult(success)
        end)
    end)
end

RegisterCommand('hotwire', StartHotwire, false)

-- Test command for export debugging
RegisterCommand('testgivekey', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(veh)
        print("[SimpleCarlock] Test command: Giving key for plate: " .. plate)
        exports['SimpleCarlock']:GiveKey(plate)
    else
        print("[SimpleCarlock] Test command: Not in vehicle")
    end
end, false)



-- ========== CORE THREADS ==========

-- This thread handles player input for locking/unlocking.
-- It runs every frame (Wait(0)) to ensure inputs are captured instantly.
CreateThread(function()
    while true do
        Wait(0) -- Run every game tick for responsiveness.
        if isLockpicking or isHotwiring then goto continue end

        local ply = PlayerPedId()
        
        -- Manual lock/unlock while on foot.
        if not IsPedInAnyVehicle(ply, false) and (IsControlJustReleased(0, Config.Settings.lockKey) or IsControlJustReleased(0, Config.Settings.lockKeyAlt)) then
            local veh, dist = GetClosestVehicle(GetEntityCoords(ply))
            if veh and dist <= Config.Settings.interactionDistance then
                local plate = GetVehicleNumberPlateText(veh)
                if plate and playerKeys[plate] then
                    TriggerServerEvent('carLock:toggleLock', VehToNet(veh))
                end
            end
        end
        
        -- Hotwire with H key while inside vehicle
        if IsPedInAnyVehicle(ply, false) and IsControlJustReleased(0, Config.Settings.hotwireKey) then
            StartHotwire()
        end
        
        -- Auto-unlock just before exiting vehicle.
        if IsPedInAnyVehicle(ply, false) and IsControlJustPressed(0, Config.Settings.exitKey) then
            local veh = GetVehiclePedIsIn(ply, false)
            local plate = GetVehicleNumberPlateText(veh)
            -- If player has keys and car is locked, unlock it to allow exit.
            if plate and playerKeys[plate] and GetVehicleDoorLockStatus(veh) ~= 1 then
                TriggerServerEvent('carLock:toggleLock', VehToNet(veh))
                TriggerEvent('carLock:pauseAutolock')
            end
        end
        ::continue::
    end
end)

-- This thread handles automatic features like drive-lock and walk-away lock.
-- It runs on a 500ms interval as it doesn't need to be instant.
CreateThread(function()
    local lastUsedVehicle = 0
    while true do
        Wait(500)
        if isLockpicking or isHotwiring then goto continue end

        local ply = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(ply, false)

        if currentVehicle ~= 0 then -- Player is in a vehicle
            lastUsedVehicle = currentVehicle
            if not canAutolock then canAutolock = true end
            
            local plate = GetVehicleNumberPlateText(currentVehicle)

            -- Auto-lock when driving.
            if GetPedInVehicleSeat(currentVehicle, -1) == ply then -- Player is the driver
                if playerKeys[plate] and GetVehicleDoorLockStatus(currentVehicle) == 1 and GetEntitySpeed(currentVehicle) * 2.236936 > Config.Settings.driveLockSpeed then
                    TriggerServerEvent('carLock:toggleLock', VehToNet(currentVehicle))
                end
            end
        else -- Player is on foot
            if canAutolock and DoesEntityExist(lastUsedVehicle) then 
                local dist = #(GetEntityCoords(ply) - GetEntityCoords(lastUsedVehicle))
                if dist > Config.Settings.autolockDistance then
                    local plate = GetVehicleNumberPlateText(lastUsedVehicle)
                    if plate and playerKeys[plate] and GetVehicleDoorLockStatus(lastUsedVehicle) == 1 then
                        TriggerServerEvent('carLock:toggleLock', VehToNet(lastUsedVehicle), true) -- isAutolock = true
                        lastUsedVehicle = 0 -- Reset to prevent re-locking.
                    end
                end
            end
        end
        ::continue::
    end
end)

-- Temporarily disables autolocking to prevent the car from locking right after you exit.
AddEventHandler('carLock:pauseAutolock', function()
    canAutolock = false
    SetTimeout(3000, function()
        canAutolock = true
    end)
end)

-- ========== EXPORTS ==========

-- Export to get vehicle keys for external resources
exports('getVehicleKeys', function()
    return playerKeys
end)

-- Export to check if player has keys for a specific vehicle
exports('hasVehicleKeys', function(plate)
    if not plate then return false end
    return playerKeys[plate] ~= nil
end)

-- Export to give keys for a specific vehicle (wasabi_carlock compatibility)
exports('GiveKey', function(plate)
    print("[SimpleCarlock] GiveKey export called with plate: " .. tostring(plate))
    if not plate then 
        print("[SimpleCarlock] GiveKey: No plate provided")
        return false 
    end
    playerKeys[plate] = true
    ShowNotification("~g~Keys received for vehicle: " .. plate)
    print("[SimpleCarlock] GiveKey: Keys given for plate: " .. plate)
    return true
end)

-- Export to remove keys for a specific vehicle
exports('RemoveKey', function(plate)
    if not plate then return false end
    playerKeys[plate] = nil
    ShowNotification("~r~Keys removed for vehicle: " .. plate)
    return true
end)

-- ========== GARAGE INTEGRATION EVENTS ==========

-- Event for automatic key assignment when vehicle is spawned (for garage systems)
RegisterNetEvent('carLock:autoGiveKeys')
AddEventHandler('carLock:autoGiveKeys', function(plate)
    if plate then
        playerKeys[plate] = true
        ShowNotification("~g~Keys received for vehicle: " .. plate)
    end
end)
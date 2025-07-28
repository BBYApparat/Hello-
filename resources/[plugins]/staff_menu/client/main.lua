local ESX = exports["es_extended"]:getSharedObject()
local isStaff = false
local playerGroup = 'user'
local playerLevel = 0
local isMenuOpen = false
local noclipEnabled = false
local blipsEnabled = false

-- Initialize
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    
    ESX.TriggerServerCallback('staff_menu:getPlayerGroup', function(group, level)
        playerGroup = group
        playerLevel = level
        isStaff = level > 0
        
        if isStaff then
            ESX.ShowNotification('~g~Staff Menu loaded. Press ~b~' .. Config.MenuKey .. '~g~ to open.')
        end
    end)
end)

-- Key Handler
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, GetHashKey(Config.MenuKey)) then
            if isStaff and not isMenuOpen then
                OpenStaffMenu()
            end
        end
    end
end)

-- Register Key Mapping
RegisterKeyMapping('staffmenu', 'Open Staff Menu', 'keyboard', Config.MenuKey)
RegisterCommand('staffmenu', function()
    if isStaff and not isMenuOpen then
        OpenStaffMenu()
    end
end)

-- vMenu-style NoClip functionality
local noclipSpeed = 1.0
local maxSpeed = 20.0
local minSpeed = 0.1
local speedMultiplier = {
    ['fast'] = 2.5,
    ['superfast'] = 5.0,
    ['slow'] = 0.5
}

local function ToggleNoClip()
    if not HasPermission('noclip') then
        ESX.ShowNotification('~r~You don\'t have permission for this action.')
        return
    end
    
    noclipEnabled = not noclipEnabled
    local ped = PlayerPedId()
    
    if noclipEnabled then
        -- Enable noclip
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(PlayerId(), true)
        
        -- Disable player controls that interfere
        SetPedCanRagdoll(ped, false)
        SetEntityProofs(ped, true, true, true, true, true, true, true, true)
        
        ESX.ShowNotification('~g~NoClip enabled~n~~w~WASD: Move | Shift: Fast | Ctrl: Slow | Scroll: Speed')
    else
        -- Disable noclip
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(PlayerId(), false)
        
        -- Re-enable normal physics
        SetPedCanRagdoll(ped, true)
        SetEntityProofs(ped, false, false, false, false, false, false, false, false)
        
        -- Reset speed
        noclipSpeed = 1.0
        
        ESX.ShowNotification('~o~NoClip disabled')
    end
end

-- vMenu-style smooth NoClip movement
CreateThread(function()
    while true do
        if noclipEnabled then
            local ped = PlayerPedId()
            local currentCoords = GetEntityCoords(ped)
            
            -- Get camera direction
            local camRot = GetGameplayCamRot(0)
            local camCoords = GetGameplayCamCoord()
            
            -- Calculate direction vectors
            local pitch = math.rad(camRot.x)
            local yaw = math.rad(camRot.z)
            
            local forward = vector3(
                -math.sin(yaw) * math.cos(pitch),
                math.cos(yaw) * math.cos(pitch),
                math.sin(pitch)
            )
            
            local right = vector3(
                math.cos(yaw),
                math.sin(yaw),
                0.0
            )
            
            local up = vector3(0, 0, 1)
            
            -- Speed controls
            local currentSpeed = noclipSpeed
            local frameTime = GetFrameTime()
            
            -- Speed modifiers
            if IsDisabledControlPressed(0, 21) then -- Left Shift
                currentSpeed = currentSpeed * speedMultiplier.fast
            end
            if IsDisabledControlPressed(0, 36) then -- Left Ctrl
                currentSpeed = currentSpeed * speedMultiplier.slow
            end
            
            -- Mouse wheel speed adjustment
            if IsDisabledControlJustPressed(0, 14) then -- Mouse wheel up
                noclipSpeed = math.min(noclipSpeed + 0.5, maxSpeed)
                ESX.ShowNotification('~b~Speed: ~w~' .. string.format('%.1f', noclipSpeed))
            elseif IsDisabledControlJustPressed(0, 15) then -- Mouse wheel down
                noclipSpeed = math.max(noclipSpeed - 0.5, minSpeed)
                ESX.ShowNotification('~b~Speed: ~w~' .. string.format('%.1f', noclipSpeed))
            end
            
            -- Movement vector
            local movement = vector3(0, 0, 0)
            
            -- Forward/Backward
            if IsDisabledControlPressed(0, 32) then -- W
                movement = movement + forward
            end
            if IsDisabledControlPressed(0, 33) then -- S  
                movement = movement - forward
            end
            
            -- Left/Right
            if IsDisabledControlPressed(0, 34) then -- A
                movement = movement - right
            end
            if IsDisabledControlPressed(0, 35) then -- D
                movement = movement + right
            end
            
            -- Up/Down (Space/C)
            if IsDisabledControlPressed(0, 22) then -- Space
                movement = movement + up
            end
            if IsDisabledControlPressed(0, 26) then -- C (Look behind in vehicle)
                movement = movement - up
            end
            
            -- Apply movement
            if movement.x ~= 0 or movement.y ~= 0 or movement.z ~= 0 then
                -- Normalize movement vector
                local length = math.sqrt(movement.x^2 + movement.y^2 + movement.z^2)
                if length > 0 then
                    movement = movement / length
                end
                
                -- Apply speed and frame time
                movement = movement * currentSpeed * frameTime * 60.0
                
                -- Set new position
                local newCoords = currentCoords + movement
                SetEntityCoords(ped, newCoords.x, newCoords.y, newCoords.z, false, false, false, false)
            end
            
            -- Disable all player controls while in noclip
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
            
            -- Re-enable camera controls
            EnableControlAction(0, 1, true) -- LookLeftRight
            EnableControlAction(0, 2, true) -- LookUpDown
            EnableControlAction(0, 14, true) -- Mouse wheel up
            EnableControlAction(0, 15, true) -- Mouse wheel down
        end
        Wait(0)
    end
end)

function HasPermission(action)
    local perm = Config.Permissions[action]
    if not perm then return false end
    return playerLevel >= perm.minLevel
end

-- Client event handlers
RegisterNetEvent('staff_menu:forceRevive')
AddEventHandler('staff_menu:forceRevive', function()
    local ped = PlayerPedId()
    
    -- Clear death state
    if IsEntityDead(ped) then
        NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    end
    
    -- Clear animations and effects
    ClearPedTasksImmediately(ped)
    ClearPedSecondaryTask(ped)
    SetEntityInvincible(ped, false)
    SetPlayerInvincible(PlayerId(), false)
    
    -- Reset health
    SetEntityHealth(ped, 200)
    
    -- Clear any screen effects
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('staff_menu:toggleFreeze')
AddEventHandler('staff_menu:toggleFreeze', function()
    local ped = PlayerPedId()
    local frozen = IsEntityPositionFrozen(ped)
    FreezeEntityPosition(ped, not frozen)
    
    if not frozen then
        ESX.ShowNotification('~r~You have been frozen by staff')
    else
        ESX.ShowNotification('~g~You have been unfrozen by staff')
    end
end)

-- Export functions
exports('HasPermission', HasPermission)
exports('GetPlayerLevel', function() return playerLevel end)
exports('GetPlayerGroup', function() return playerGroup end)
exports('ToggleNoClip', ToggleNoClip)
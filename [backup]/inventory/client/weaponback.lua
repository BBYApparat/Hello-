local ped
local attached_weapons = {}
local shouldhideWeapons = false

local ForceRemoveWeapons = function()
    if attached_weapons and next(attached_weapons) then
        for name, attached_object in pairs(attached_weapons) do
            DetachEntity(attached_object.handle)
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
        end
    end
end

local ResetWeaponsA = function(c_ped)
    local pedCo = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Config.Weapons.compatable_weapon_hashes) do
        local obj = GetClosestObjectOfType(pedCo.x, pedCo.y, pedCo.z, 6.0, GetHashKey(k))
        if obj and IsEntityAttachedToEntity(obj, c_ped) then
            DetachEntity(obj)
            DeleteEntity(obj)
        end
    end
end

local AttachWeapon = function(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR, isMelee, name)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end
    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false),
        name = name
    }
    if attachModel == "prop_ld_jerrycan_01" then 
        x = 0.3
        y = -0.19 
        z = 0.0 
        xR = -90.0 
        yR = 185.0 
        zR = 92.0 
    end
    AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
    SetEntityCollision(attached_weapons[attachModel].handle, false, true)
end



local isMeleeWeapon = function(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
        return true
    else
        return false
    end
end

local checkItem = function(item)
    local items = PlayerData.inventory
    if items then
        for k,v in pairs(items) do
            if v.name == item then
                return true
            end
        end
    end
    return false
end

CreateThread(function()
    while true do
        if ped ~= PlayerPedId() or not ped then
            ResetWeaponsA(ped)
            ped = PlayerPedId()
            ForceRemoveWeapons()
        end
        Wait(300)
    end
end)

CreateThread(function()
    Wait(5000)
    while true do
        while not ESX or not ped do
            Wait(400)
        end
        local weapon = GetSelectedPedWeapon(ped)
        for wep_name, v in pairs(Config.Weapons.compatable_weapon_hashes) do
            local weaponName = ESX.Shared.Weapons[v.hash]
            if v.hash ~= GetHashKey('WEAPON_UNARMED') and weaponName ~= nil then
                if checkItem(weaponName.name) then
                    if not attached_weapons[wep_name] and weapon ~= v.hash and not shouldhideWeapons then
                        AttachWeapon(wep_name, v.hash, v.back_bone, v.x, v.y, v.z, v.x_rotation, v.y_rotation, v.z_rotation, isMeleeWeapon(wep_name), weaponName.name)
                    end
                end
            end
        end
        Wait(120)
    end
end)

RegisterNetEvent('weapons:removeAll', function(timer)
    ForceRemoveWeapons()
    shouldhideWeapons = true
    Wait(timer or 1000)
    shouldhideWeapons = false
end)

RegisterNetEvent('weapons:toggle', function(bool)
    shouldhideWeapons = bool
    if shouldhideWeapons then
        ForceRemoveWeapons()
    end
end)

RegisterNetEvent('inventory:client:detachallweaps', function()
    shouldhideWeapons = true
    ForceRemoveWeapons()
    Wait(1000)
    shouldhideWeapons = false
end)

RegisterNetEvent('weapons:invisible', function(bool)
    if bool then
        for k,v in pairs(attached_weapons) do
            SetEntityAlpha(v.handle, 0)
        end
    else
        for k,v in pairs(attached_weapons) do
            ResetEntityAlpha(v.handle)
        end
    end
end)

-- Checks if noclip or invisible is active
CreateThread(function()
    local kappa = GetResourceState('kappa') == "started" or false
    while true do
        local isNoclip = (kappa and exports.kappa:IsNoclipActive()) or false
        local IsInvisible = (kappa and exports.kappa:IsInvisibleActive()) or false
        if isNoclip or IsInvisible then
            TriggerEvent('weapons:invisible', true)
        else
            TriggerEvent('weapons:invisible', false)
        end
        Wait(500)
    end
end)

CreateThread(function()
    Wait(5000)
    while true do
        while (not ESX or not ped) and not PlayerData and not PlayerData.inventory do
            Wait(400)
        end
        Wait(120)
        local weapon = GetSelectedPedWeapon(ped)
        for name, attached_object in pairs(attached_weapons) do
            if weapon == attached_object.hash or not checkItem(attached_object.name) then
                DeleteObject(attached_object.handle)
                attached_weapons[name] = nil
            end
        end
    end
end)

RegisterNetEvent('onback:removeWeapons', function()
    ForceRemoveWeapons()
end)

AddEventHandler('onResourceStop', function(res)
    if (GetCurrentResourceName() ~= res) then return end
    ForceRemoveWeapons()
end)
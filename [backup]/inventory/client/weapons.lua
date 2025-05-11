local CurrentWeaponData, CanShoot, MultiplierAmount = {}, true, 0
local currentWeapon = nil

local function DrawText3Ds(x, y, z, text)
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

local GetCurrentPetrolAmmo = function()
    return CurrentWeaponData.info.liters or 0
end

getLastPedWeapon = function()
    return CurrentWeaponData
end

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = ESX.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local ped = PlayerPedId()
    local WeaponData = ESX.Shared.Items[data.WeaponData.name]
    local label = ESX.Shared.Items
    local Attachment = ESX.Config.WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    ESX.TriggerServerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(ESX.Config.WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        item = pew.item
                        Attachies[#Attachies+1] = {
                            attachment = pew.item,
                            label = ESX.Shared.Items[item].label,
                        }
                    end
                end
            end
            local Data = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(Data)
        else
            RemoveWeaponComponentFromPed(ped, GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNetEvent('inventory:client:removeWeapons', function()
    local ped = PlayerPedId()
    TriggerEvent('inventory:client:restoreWeapons')
    TriggerEvent('onback:removeWeapons')
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    CurrentWeaponData = data or {}
end)

RegisterNetEvent('weapons:client:startPetrolThread', function(weaponData)
    local realAmmo = 0
    if weaponData and weaponData.info and weaponData.info.liters then
        realAmmo = weaponData.info.liters
    end
    TriggerEvent('fuel:setPetrolHealth', realAmmo)
end)

RegisterNetEvent('inventory:client:CheckWeapon', function(weaponName)
    if currentWeapon == weaponName then
        TriggerEvent('weapons:ResetHolster')
        TriggerEvent('inventory:client:restoreWeapons')
    end
end)

RegisterNetEvent("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent("inventory:client:addAttachment", function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = ESX.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)

RegisterNetEvent('weapons:client:EquipTint', function(tint)
    local player = PlayerPedId()
    local weapon = GetSelectedPedWeapon(player)
    SetPedWeaponTintIndex(player, weapon, tint)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('inventory:client:restoreWeapons', function(bool)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local weaponData = CurrentWeaponData
    local ammo = GetAmmoInPedWeapon(ped, weapon)
    local slot = weaponData.slot
    if weapon == GetHashKey('WEAPON_PETROLCAN') then
        ammo = GetCurrentPetrolAmmo()
        TriggerEvent('fuel:setPetrolHealth', nil)
    end
    if bool then
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(ped, true)
    end
    SetTimeout(100, function()
        TriggerServerEvent('inventory:server:setWeaponData', slot, ammo)    
    end)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    Wait(500)
    RemoveAllPedWeapons(ped, true)
    TriggerEvent('weapons:client:SetCurrentWeapon', nil, false)
    currentWeapon = nil
end)

RegisterNetEvent('inventory:client:petrolAmmo', function(ammo)
    if CurrentWeaponData and CurrentWeaponData.info and CurrentWeaponData.info.liters then
        if ammo < 0 then
            ammo = 0
        end
        CurrentWeaponData.info.liters = ammo
        if CurrentWeaponData.info.liters == 0 then
            local ammo2 = GetCurrentPetrolAmmo()
            local slot = CurrentWeaponData.slot
            TriggerEvent('inventory:client:restoreWeapons')
            Wait(100)
            TriggerServerEvent('inventory:server:setWeaponData', slot, ammo2)
        end
    end
end)

RegisterNetEvent("inventory:stoppedRefuelling", function()
    local ammo2 = GetCurrentPetrolAmmo()
    local slot = CurrentWeaponData.slot
    TriggerEvent('inventory:client:restoreWeapons')
    Wait(100)
    TriggerServerEvent('inventory:server:setWeaponData', slot, ammo2)
end)

RegisterNetEvent('esx:updateItemInfo', function(slot, info)
    if not CurrentWeaponData then return end
    if CurrentWeaponData.slot == slot then
        CurrentWeaponData.info = info
        if CurrentWeaponData.name == "weapon_petrolcan" then
            TriggerEvent('fuel:setPetrolHealth', info.liters)
        end
    end
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool, isForced)
    local weaponName = tostring(weaponData.name)
    local itemInfo = ESX.Shared.Items[weaponName]
    if not isForced then
        TriggerEvent('inventory:client:ItemBox', itemInfo, "use")
    end
    if currentWeapon == weaponName then
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        local ammo = GetAmmoInPedWeapon(PlayerPedId(), weapon)
        local slot = weaponData.slot
        TriggerEvent('inventory:client:restoreWeapons')
        if weapon == GetHashKey('WEAPON_PETROLCAN') then
            ammo = GetCurrentPetrolAmmo()
            TriggerEvent('fuel:setPetrolHealth', nil)
        end
        Wait(100)
        TriggerServerEvent('inventory:server:setWeaponData', slot, ammo)
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_megaphone" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerServerEvent('esx:removeItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_petrolcan" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 4000)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        TriggerEvent('weapons:client:startPetrolThread', weaponData)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        ESX.TriggerServerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            GiveWeaponToPed(ped, GetHashKey(weaponName), 0, false, false)
            SetPedAmmo(ped, GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent('weapons:client:refillJerrycan', function(amount, paym)
    if CurrentWeaponData and CurrentWeaponData.name == "weapon_petrolcan" then
        TriggerServerEvent('fuel:server:updatePetrolcan', CurrentWeaponData, amount, paym)
    end
end)

RegisterNetEvent('weapons:fixthedamn', function(itemData)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if CurrentWeaponData and next(CurrentWeaponData) then
        if weapon ~= GetHashKey('WEAPON_UNARMED') and weapon == GetHashKey(CurrentWeaponData.name) and ESX.Shared.Weapons[GetHashKey(CurrentWeaponData.name)] then
            TriggerServerEvent('esx:removeItem', itemData.name, 1)
            ProgressBar(Lang("repairing_weapon"), 15000, {whileDead = false, canCancel = false, movement = true, dict = "mini@repair", anim = "fixing_a_player", flags = 48}, function (cancelled)
                if not cancelled then
                    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
                    ClearPedTasks(ped)
                    TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, 100)
                end
            end)
        end
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData and next(CurrentWeaponData) then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

local isReloading = false

RegisterNetEvent('weapon:client:AddAmmo', function(type, amount, itemData)
    if isReloading then return end
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if CurrentWeaponData then
        if ESX.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and ESX.Shared.Weapons[weapon]["ammo_type"] == type:upper() then
            local total = GetAmmoInPedWeapon(ped, weapon)
            local found, maxAmmo = GetMaxAmmo(ped, weapon)
            if total < maxAmmo then
                isReloading = true
                ProgressBar(Lang("loading_bullets"), 1000, {whileDead = false, canCancel = false, movement = false}, function (cancelled)
                    if ESX.Shared.Weapons[weapon] then
                        AddAmmoToPed(ped,weapon,amount)
                        MakePedReload(ped)
                        TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, total + amount)
                        TriggerServerEvent('esx:removeItem', itemData.name, 1, itemData.slot)
                        Wait(50)
                        isReloading = false
                    end
                end)
            else
                ESX.ShowNotification(Lang("max_ammo"), "error", 4000)
            end
        else
            ESX.ShowNotification(Lang("weapon_not_found"), "error", 4000)
        end
    else
        ESX.ShowNotification(Lang("weapon_not_found"), "error", 4000)
    end
end)

RegisterNetEvent("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = ESX.Shared.Weapons[weapon]
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if ESX.Config.WeaponAttachments[WeaponData.name] then
            if ESX.Config.WeaponAttachments[WeaponData.name][attachment]['item'] == ItemData.name then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData.name, CurrentWeaponData, ESX.Config.WeaponAttachments[WeaponData.name][attachment])
            else
                ESX.ShowNotification(_("weapon_no_attachments"), "error", 4000)
            end
        end
    else
        ESX.ShowNotification(Lang("weapon_not_in_hands"), "error", 4000)
    end
end)

CreateThread(function()
    SetWeaponsNoAutoswap(true)
    while true do
        Wait(30)
        local ped = PlayerPedId()
        local player = PlayerId()
        local weapon = GetSelectedPedWeapon(ped)
        local group = GetWeapontypeGroup(weapon)
        if group ~= -728555052 then 
            if weapon ~= 911657153 and weapon ~= -1169823560 and weapon ~= 615608432 and weapon ~= 741814745 and weapon ~= -1569615261 then
                local ammo = GetAmmoInPedWeapon(ped, weapon)
                if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsPedShooting(ped)) then
                    if ammo > 1 and CurrentWeaponData and CurrentWeaponData.name and CurrentWeaponData.name ~= "weapon_megaphone" then
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
                    end
                    if MultiplierAmount > 0 and weapon ~= GetHashKey('WEAPON_PETROLCAN') and ESX.Shared.Weapons[weapon] then
                        local wpData = ESX.Shared.Weapons[weapon]
                        if ESX.Shared.Items[wpData.name] then
                            TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                            MultiplierAmount = 0
                        end
                    end
                end
            end
        end
    end
end)

local whitelistedWeapons = {
    ["weapon_snowball"] = true,
    ["weapon_pipebomb"] = true,
    ["weapon_molotov"] = true,
    ["weapon_stickybomb"] = true,
    ["weapon_grenade"] = true,
    ["weapon_bzgas"] = true,
    ["weapon_proxmine"] = true,
    ["weapon_ball"] = true,
    ["weapon_smokegrenade"] = true,
    ["weapon_flare"] = true,
}

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if CurrentWeaponData and next(CurrentWeaponData) then
            local weapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            local weaponExists = ESX.Shared.Weapons[weapon]
            if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsPedShooting(ped) then
                if CanShoot then
                    if weapon and weapon ~= 0 and weaponExists then
                        if whitelistedWeapons[weaponExists.name] then
                            while GetSelectedPedWeapon(ped) == weapon do
                                Wait(300)
                            end
                            TriggerEvent('inventory:client:restoreWeapons', true)
                            Wait(250)
                            TriggerServerEvent('esx:removeItem', weaponExists.name, 1, false, true)
                        end
                    else
                        if ammo > 0 then
                            MultiplierAmount = MultiplierAmount + 1
                        end
                    end
                else
                    if weapon ~= -1569615261 then
                        TriggerEvent('inventory:client:CheckWeapon', ESX.Shared.Weapons[weapon]["name"])
                        ESX.ShowNotification(Lang("weapon_broke"), "error", 4000)
                        MultiplierAmount = 0
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 300
        if LocalPlayer.state.isLoggedIn then
            local inRange = false
            local ped = PlayerPedId()
            SetWeaponsNoAutoswap(true)
            local pos = GetEntityCoords(ped)
            for k, data in pairs(Config.WeaponRepairPoints) do
                local distance = #(pos - data.coords)
                if distance < 10 then
                    sleep = 3
                    if distance < 1 then
                        if data.IsRepairing then
                            if data.RepairingData.CitizenId ~= PlayerData.identifier then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop in this moment is ~r~NOT~w~ usable.')
                            else
                                if not data.RepairingData.Ready then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Your weapon will be repaired.')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                end
                            end
                        else
                            if CurrentWeaponData and next(CurrentWeaponData) then
                                if not data.RepairingData.Ready then
                                    local WeaponData = ESX.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
                                    local WeaponClass = (ESX.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Repair Weapon, ~g~$'..Config.WeaponRepairCosts[WeaponClass]..'~w~')
                                    if IsControlJustPressed(0, 38) then
                                        ESX.TriggerServerCallback('weapons:server:RepairWeapon', function(HasMoney)
                                            if HasMoney then
                                                CurrentWeaponData = {}
                                            end
                                        end, k, CurrentWeaponData)
                                    end
                                else
                                    if data.RepairingData.CitizenId ~= PlayerData.identifier then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop in this moment is ~r~NOT~w~ usable.')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                        if IsControlJustPressed(0, 38) then
                                            TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                        end
                                    end
                                end
                            else
                                if data.RepairingData.CitizenId == nil then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'You dont have a weapon in your hand.')
                                elseif data.RepairingData.CitizenId == PlayerData.identifier then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] - Take Weapon Back')
                                    if IsControlJustPressed(0, 38) then
                                        TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function GetWeaponData()
    return CurrentWeaponData
end

exports("GetWeaponData", GetWeaponData)
local function IsWeaponBlocked(WeaponName)
    if Config.DurabilityBlockedWeapons[WeaponName] then
        return true
    end
    return false
end

local function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

local function GetAttachmentType(attachments)
    local attype = nil
    for k,v in pairs(attachments) do
        attype = v.type
    end
    return attype
end

ESX.RegisterServerCallback("weapons:server:GetConfig", function(source, cb)
    cb(Config.WeaponRepairPoints)
end)

ESX.RegisterServerCallback("weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = ESX.GetPlayerFromId(source)
    local retval = 0
    if WeaponData then
        if Player then
            local ItemData = Player.GetItemBySlot(WeaponData.slot)
            if ItemData then
                retval = ItemData.info.ammo and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

ESX.RegisterServerCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, itemData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local itemInfo = xPlayer.GetItemBySlot(itemData.slot)
    local weaponInfo = itemInfo.info
    local AttachmentComponent = ESX.Config.WeaponAttachments[itemData.name:upper()][AttachmentData.attachment]
    if itemInfo then
        if weaponInfo.attachments and next(weaponInfo.attachments) then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, weaponInfo.attachments)
            if HasAttach then
                table.remove(weaponInfo.attachments, key)
                xPlayer.addInventoryItem(AttachmentComponent.item, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, ESX.Shared.Items[AttachmentComponent.item], "add")
                xPlayer.showNotification(ESX.Shared.Items[AttachmentComponent.item].label..' removed', "inform", 3000)
                xPlayer.updateItemData(itemData.slot, weaponInfo)
                SetTimeout(300, function()
                    xPlayer.triggerEvent('inventory:client:UpdatePlayerInventory')
                end)
                cb(weaponInfo.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("weapons:server:RepairWeapon", function(source, cb, RepairPoint, data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local minute = 60 * 1000
    local Timeout = math.random(5 * minute, 10 * minute)
    local WeaponData = ESX.Shared.Weapons[GetHashKey(data.name)]
    local WeaponClass = (ESX.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
    if Player.inventory[data.slot] then
        if Player.inventory[data.slot].info.quality then
            if Player.inventory[data.slot].info.quality ~= 100 then
                if Player.getMoney() >= Config.WeaponRepairCosts[WeaponClass] then
                    Player.removeMoney(Config.WeaponRepairCosts[WeaponClass])
                    Config.WeaponRepairPoints[RepairPoint].IsRepairing = true
                    Config.WeaponRepairPoints[RepairPoint].RepairingData = {
                        CitizenId = Player.identifier,
                        WeaponData = Player.inventory[data.slot],
                        Ready = false,
                    }
                    Player.removeInventoryItem(data.name, 1, data.slot)
                    TriggerClientEvent('inventory:client:ItemBox', src, ESX.Shared.Items[data.name], "remove")
                    TriggerClientEvent("inventory:client:CheckWeapon", src, data.name)
                    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                    SetTimeout(Timeout, function()
                        Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                        Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready = true
                        TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                        -- TriggerEvent('qb-phone:server:sendNewMailToOffline', Player.identifier, {
                        --     sender = 'Typone',
                        --     subject = 'Repair',
                        --     message = WeaponData.label
                        -- })
                        SetTimeout(7 * 60000, function()
                            if Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready then
                                Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                                Config.WeaponRepairPoints[RepairPoint].RepairingData = {}
                                TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                            end
                        end)
                    end)
                    cb(true)
                else
                    cb(false)
                end
            else
                Player.showNotification('This weapon is not damaged..', "error", 3000)
                cb(false)
            end
        else
            Player.showNotification('This weapon is not damaged..', "error", 3000)
            cb(false)
        end
    else
        Player.showNotification('You need to have weapon on hands', "error", 3000)
        TriggerClientEvent('weapons:client:SetCurrentWeapon', src, {}, false)
        cb(false)
    end
end)

RegisterNetEvent("weapons:server:AddWeaponAmmo", function(CurrentWeaponData, amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    amount = tonumber(amount) or 0
    if CurrentWeaponData then
        Player.updateWeaponAmmo(CurrentWeaponData.slot, amount, true)
    end
end)

-- RegisterServerEvent('inventory:forceUseWeapon', function(data)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if xPlayer.inventory[data.slot] and xPlayer.inventory[data.slot].name == data.name then
--         xPlayer.triggerEvent('inventory:client:UseWeapon', data, nil, true)
--     end
-- end)

RegisterNetEvent('inventory:server:setWeaponData', function(slot, ammo)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if ammo < 0 then ammo = 0 end
    if Player.inventory[slot] then
        if Player.inventory[slot].name == "weapon_petrolcan" then
            if Player.inventory[slot].info and Player.inventory[slot].info.liters then
                Player.inventory[slot].info.liters = ammo
                Player.updateItemData(slot, Player.inventory[slot].info)
            end
        else
            if Player.inventory[slot].info and Player.inventory[slot].info.ammo then
                Player.updateWeaponAmmo(slot, ammo)
            end
        end
    end
end)

RegisterNetEvent("weapons:server:UpdateWeaponAmmo", function(CurrentWeaponData, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    amount = tonumber(amount) or 0
    if CurrentWeaponData then
        xPlayer.updateWeaponAmmo(CurrentWeaponData.slot, amount)
    end
end)

RegisterNetEvent("weapons:server:TakeBackWeapon", function(k, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local itemdata = Config.WeaponRepairPoints[k].RepairingData.WeaponData
    itemdata.info.quality = 100
    xPlayer.addInventoryItem(itemdata.name, 1, false, itemdata.info)
    TriggerClientEvent('inventory:client:ItemBox', src, ESX.Shared.Items[itemdata.name], "add")
    Config.WeaponRepairPoints[k].IsRepairing = false
    Config.WeaponRepairPoints[k].RepairingData = {}
    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[k], k)
end)

RegisterNetEvent("weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local WeaponSlot = xPlayer.inventory[data.slot]
    WeaponSlot.info.quality = hp
    xPlayer.updateItemData(data.slot, WeaponSlot.info)
    xPlayer.showNotification('Weapon Fixed!', "inform", 4000)
end)

RegisterNetEvent('weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not data or not data.name or not GetHashKey(data.name) then return end
    local WeaponData = ESX.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = xPlayer.inventory[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name] or 0.1
    if WeaponSlot and WeaponData then
        if not IsWeaponBlocked(WeaponData.name) then
            if WeaponSlot.info.quality then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        if WeaponData.name == "weapon_megaphone" then
                            xPlayer.showNotification("Your Megaphone just broke", "error", 8000)
                        else
                            xPlayer.showNotification('Your weapon is broken, you need to repair it before you can use it again.', "error", 8000)
                        end
                        break
                    end
                end
            else
                if not WeaponSlot.info then
                    WeaponSlot.info = {}
                end
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        if WeaponData.name == "weapon_megaphone" then
                            xPlayer.showNotification("Your Megaphone is broken.", 'error', 8000)
                        else
                            xPlayer.showNotification('Your weapon is broken, you need to repair it before you can use it again.', "error", 8000)
                        end
                        break
                    end
                end
            end
        end
    end
    xPlayer.updateItemData(WeaponSlot.slot, WeaponSlot.info)
end)

RegisterNetEvent("weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local itemData = xPlayer.GetItemBySlot(CurrentWeaponData.slot)
    local weaponinfo = itemData.info
    local GiveBackItem = nil
    if itemData and itemData.info then
        if weaponinfo.attachments and next(weaponinfo.attachments) then
            local currenttype = GetAttachmentType(weaponinfo.attachments)
            local HasAttach, key = HasAttachment(AttachmentData.component, weaponinfo.attachments)
            if not HasAttach then
                if AttachmentData.type and currenttype == AttachmentData.type then
                    for k, v in pairs(weaponinfo.attachments) do
                        if v.type and v.type == currenttype then
                            GiveBackItem = tostring(v.item):lower()
                            table.remove(itemData.info.attachments, key)
                            TriggerClientEvent('inventory:client:ItemBox', src, ESX.Shared.Items[GiveBackItem], "add")
                        end
                    end
                end
                weaponinfo.attachments[#weaponinfo.attachments + 1] = {
                    component = AttachmentData.component,
                    label = ESX.Shared.Items[AttachmentData.item].label,
                    item = AttachmentData.item,
                    type = AttachmentData.type,
                }
                TriggerClientEvent("inventory:client:addAttachment", src, AttachmentData.component)
                xPlayer.removeInventoryItem(ItemData, 1)
                xPlayer.updateItemData(CurrentWeaponData.slot, weaponinfo)
                SetTimeout(1000, function()
                    TriggerClientEvent('inventory:client:ItemBox', src, ESX.Shared.Items[ItemData], "remove")
                end)
            else
                xPlayer.showNotification('You already have a '.. ESX.Shared.Items[AttachmentData.item].label ..' on your weapon.', "error", 3000)
            end
        else
            weaponinfo.attachments = {}
            weaponinfo.attachments[#weaponinfo.attachments + 1] = {
                component = AttachmentData.component,
                label = ESX.Shared.Items[AttachmentData.item].label,
                item = AttachmentData.item,
                type = AttachmentData.type,
            }
            TriggerClientEvent("inventory:client:addAttachment", src, AttachmentData.component)
            xPlayer.removeInventoryItem(ItemData, 1)
            xPlayer.updateItemData(CurrentWeaponData.slot, weaponinfo)
            SetTimeout(1000, function()
                local itemInfo = ESX.Shared.Items[ItemData]
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "remove")
            end)
        end
    end
    if GiveBackItem then
        xPlayer.addInventoryItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

ESX.RegisterCommand("repairweapon", 'superadmin', function(xPlayer)
    TriggerClientEvent('weapons:client:SetWeaponQuality', xPlayer.source, 100)
end)

for k,v in pairs(Config.AmmoItems) do
    ESX.RegisterUsableItem(v.name, function(source, item)
        TriggerClientEvent(v.event, source, v.ammo_type, v.ammo_count, item)
    end)
end

for k,v in pairs(Config.WeaponTints) do
    ESX.RegisterUsableItem(v.name, function(source)
        TriggerClientEvent(v.event, source, v.value)
    end)
end

for k,v in pairs(Config.WeaponAttachments) do
    ESX.RegisterUsableItem(v.name, function(source, item)
        TriggerClientEvent(v.event, source, item, v.value)
    end)
end
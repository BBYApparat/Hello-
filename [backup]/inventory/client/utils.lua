RegisterNUICallback("PlayDropSound", function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

function openAnim()
    local animations = Config.Animations.openInv
    loadAnim(animations.dict)
    TaskPlayAnim(PlayerPedId(), animations.dict, animations.anim, 1.5, 1.5, 3.0, 48, 0.0, 0, 0, 0)
end

function closeInventory()
    TriggerEvent('esx:onCloseInventory')
    local animations = Config.Animations.closeInv
    if IsEntityPlayingAnim(PlayerPedId(), animations.dict, animations.anim, 3) then
        StopAnimTask(PlayerPedId(), animations.dict, animations.anim, 2.0)
    end
    SendNUIMessage({action = "close"})
end

local setUnarmed = function()
    TriggerEvent('inventory:client:restoreWeapons')
end

exports("setUnarmed", setUnarmed)

function HasItem(name, amount)
    while not ESX or (not PlayerData and not PlayerData.inventory) do Wait(100) end
    if not amount then amount = 1 end
    if not ESX.Shared.Items[name] then return false end
    local temp_amount = 0
	for k,v in pairs(PlayerData.inventory) do
		if v.name == name then
            if Config.ItemInformations[v.itemtype] then
                if v.info[Config.ItemInformations[v.itemtype].type] > 0 then
                    temp_amount = temp_amount + v.amount
                end
            elseif Config.ItemInformations[v.name] then
                if v.info[Config.ItemInformations[v.name].type] > 0 then
                    temp_amount = temp_amount + v.amount
                end
            else
                temp_amount = temp_amount + v.amount
            end
			if temp_amount >= amount then
				return true
			end
		end
	end
	return false
end

exports("HasItem", HasItem)

GetItemsByName = function(item)
    item = tostring(item):lower()
    local items = {}
    local slots = GetSlotsByItem(item)
    for _, slot in pairs(slots) do
        if slot then
            items[#items+1] = PlayerData.inventory[slot]
        end
    end
    return items
end

exports("GetItemsByName", GetItemsByName)

GetTotalItemAmount = function(item)
    local temp_item = GetItemsByName(item)
    local temp_amount = 0
    if temp_item and #temp_item > 0 then
        for i=1,#temp_item do
            temp_amount = temp_amount + temp_item[i].amount
        end
    end
    return temp_amount
end

exports("GetTotalItemAmount", GetTotalItemAmount)

GetSlotsByItem = function(itemName)
    local slotsFound = {}
    if not PlayerData.inventory then
        return slotsFound
    end
    for slot, item in pairs(PlayerData.inventory) do
        if item.name:lower() == itemName:lower() then
            slotsFound[#slotsFound+1] = slot
        end
    end
    return slotsFound
end

exports("GetSlotsByItem", GetSlotsByItem)

local phone = 'phone'

function HasPhone()
    while not ESX or (not PlayerData and not PlayerData.inventory) do Wait(100) end
    for i=1,#phones do
        if HasItem(phone, 1) then
            return phones[i]
        end
    end
    return false
end

exports("HasPhone", HasPhone)

local GetTotalInventoryWeight = function()
    local weight = 0
    for k,v in pairs(PlayerData.inventory) do
        if v.name and v.amount then
            local itemData = ESX.Shared.Items[v.name]
            if itemData then
                weight = weight + (itemData.weight * v.amount)
            end
        end
    end
    return weight
end

exports('getInventoryWeight', GetTotalInventoryWeight)

local CanSwapItems = function(itemsToGive, itemsToRemove)
    local plyWeight = GetTotalInventoryWeight()
    local maxWeight = getPlayerInventoryWeight()
    local giving_items = 0
    for k,v in pairs(itemsToGive) do
        local itemData = ESX.Shared.Items[v.name]
        if itemData then
            giving_items = giving_items + (itemData.weight * v.amount)
        end
    end
    local removing_items = 0
    for k,v in pairs(itemsToRemove) do
        local itemData = ESX.Shared.Items[v.name]
        local hasItem = exports.inventory:HasItem(v.name, v.amount)
        if not hasItem then
            return false
        end
        if itemData then
            removing_items = removing_items + (itemData.weight * v.amount)
        end
    end
    local removed_weight = plyWeight - removing_items
    local total_weight = removed_weight + giving_items
    if total_weight > maxWeight then
        return false
    else
        return true
    end
end

exports('canSwapItems', CanSwapItems)

local canCarryItem = function(name, amount)
    local itemData = ESX.Shared.Items[name]
    if not itemData then return false end
    local plyWeight = GetTotalInventoryWeight()
    local maxWeight = getPlayerInventoryWeight()
    if plyWeight + (itemData.weight * amount) >= maxWeight then
        return false
    else
        return true
    end
end

exports('canCarryItem', canCarryItem)

function RemoveItem(name, amount, slot)
    if not amount then amount = 1 end
    if not ESX.Shared.Items[name] then return end
    TriggerServerEvent('esx:removeItem', name, amount, slot)
end

exports("RemoveItem", RemoveItem)

function GetClosestDumpster()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local fwd = GetEntityForwardVector(ped)
    local temp_pos = {
        x = pos.x + fwd.x,
        y = pos.y + fwd.y,
        z = pos.z
    }
    local object = 0
    for _, dumpster in pairs(Config.Dumpsters.objects) do
        local ClosestObject = GetClosestObjectOfType(temp_pos.x, temp_pos.y, temp_pos.z, 1.25, dumpster, 0, 0, 0)
        if ClosestObject ~= 0 and DoesEntityExist(ClosestObject) and GetInteriorFromEntity(ped) == 0 then
            object = ClosestObject
            break
        end
    end
    return object
end

function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local fwd = GetEntityForwardVector(ped)
    local temp_pos = {
        x = pos.x + fwd.x,
        y = pos.y + fwd.y,
        z = pos.z
    }
    local object = nil
    for _, machine in pairs(Config.VendingMachine.objects) do
        local ClosestObject = GetClosestObjectOfType(temp_pos.x, temp_pos.y, temp_pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
                break
            end
        end
    end
    return object
end

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if ESX.Config.WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(ESX.Config.WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        item = value.item
                        attachments[#attachments+1] = {
                            attachment = key,
                            label = ESX.Shared.Items[item].label
                        }
                    end
                end
            end
        end
    end
    return attachments
end

function OpenDumpster()
    local dict = "amb@prop_human_bum_bin@idle_b"
    local anim = "idle_d"
    local ped = PlayerPedId()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(ped, dict, anim, 4.0, 4.0, -1, 50, 0, false, false, false)
end

function OpenTrunk(veh)
    local vehicle = veh
    local dict = "amb@prop_human_bum_bin@idle_b"
    local anim = "idle_d"
    local ped = PlayerPedId()
    if vehicle then
        local model = GetEntityModel(vehicle)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
        TaskPlayAnim(ped, dict, anim, 4.0, 4.0, -1, 50, 0, false, false, false)
        if IsBackEngine(model) then
            SetVehicleDoorOpen(vehicle, 4, false, false)
        else
            SetVehicleDoorOpen(vehicle, 5, false, false)
        end
        TaskTurnPedToFaceEntity(ped, vehicle, 500)
    end
end

function CloseTrunk()
    local vehicle = ESX.Game.GetClosestVehicle()
    local dict = "amb@prop_human_bum_bin@idle_b"
    local anim = "exit"
    local ped = PlayerPedId()
    if vehicle then
        local model = GetEntityModel(vehicle)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
        TaskPlayAnim(ped, dict, anim, 4.0, 4.0, -1, 50, 0, false, false, false)
        if IsBackEngine(model) then
            SetVehicleDoorShut(vehicle, 4, false)
        else
            SetVehicleDoorShut(vehicle, 5, false)
        end
    end
end

function IsBackEngine(vehModel)
    if BackEngineVehicles[vehModel] then return true end
    return false
end

function DrawText3Ds(x, y, z, text)
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

local HasAnyWeapon = function()
    for k, item in pairs(PlayerData.inventory) do
        local itemData = ESX.Shared.Items[item.name]
        if itemData and itemData.type == "weapon" then
            if not Config.NotMetalWeapons[GetHashKey(item.name)] then
                return true
            end
        end
    end
end

exports('HasAnyWeapon', HasAnyWeapon)


local isInventoryOpened = function()
    return inInventory
end

exports('isInventoryOpened', isInventoryOpened)
CreateDropId = function()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

CreateSVDrop = function(source, items, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not coords then
		coords = GetEntityCoords(GetPlayerPed(source))
	end
	local dropId = CreateDropId()
	Drops[dropId] = {}
	Drops[dropId].items = {}
	Drops[dropId].coords = { 
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}
	local toSlot = 1
	for k,v in pairs(items) do
		local itemData = ESX.Shared.Items[v.name]
		if itemData then
			Drops[dropId].items[toSlot] = {
				name = itemData.name,
				amount = v.amount,
				info = v.info or "",
				slot = toSlot,
				id = dropId,
			}
			toSlot = toSlot + 1
		end
	end
	TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
end

exports("CreateSVDrop", CreateSVDrop)

CreateNewDrop = function(source, fromSlot, toSlot, itemAmount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemData = xPlayer.GetItemBySlot(fromSlot)
	local coords = GetEntityCoords(GetPlayerPed(source))
    if xPlayer.hasInventoryItem(itemData.name, itemAmount, itemData.slot) then
	    xPlayer.removeInventoryItem(itemData.name, itemAmount, itemData.slot)
        local item = ESX.Shared.Items[itemData.name]
        if item.type == 'weapon' then
    		xPlayer.triggerEvent("inventory:client:CheckWeapon", itemData.name)
        end
		local itemInfo = ESX.Shared.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}
		Drops[dropId].coords = { 
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		Drops[dropId].items[toSlot] = {
			name = itemInfo.name,
			amount = itemAmount,
			info = itemData.info or "",
			slot = toSlot,
			id = dropId,
		}
		SendLog("drop", { color = 32768, title = 'Drop Logs', message = "**".. GetPlayerName(source) .. "** *("..source..') - '..xPlayer.identifier.."* dropped new item\n name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**"})
		xPlayer.triggerEvent("inventory:client:DropItemAnim")
		TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
	else
        xPlayer.showNotification("You don't have this item!", "error", 2000)
		return
	end
end

UnpackDrops = function()
	local data = {}
	for k,v in pairs(Drops) do
		if v.id then
			data[v.id] = {
				id = v.id,
				coords = v.coords
			}
		end
	end
	return data
end

hasDropItem = function(dropId, slot, name, amount)
	local amount = tonumber(amount)
	if not ESX.Shared.Items[name] then return false end
	if not Drops[dropId] then return false end
	if not Drops[dropId].items[slot] then return false end
	if Drops[dropId].items[slot].name == name and Drops[dropId].items[slot].amount >= amount then
		return true
	end
	return false
end

AddToDrop = function(dropId, slot, itemName, amount, info)
	local amount = tonumber(amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = ESX.Shared.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo.name,
			amount = amount,
			info = info or "",
			slot = slot,
			id = dropId,
		}
	end
end

RemoveFromDrop = function(dropId, slot, itemName, amount)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

AddEventHandler('inventory:createManualDrop', function(src, items, coords)
	CreateSVDrop(src, items, coords)
end)
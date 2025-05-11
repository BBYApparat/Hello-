BuildStoreInventory = function(id, plyId)
	local items = {}
	if storeInventories[tostring(plyId)] then
		if storeInventories[tostring(plyId)][id] and storeInventories[tostring(plyId)][id].items and next(storeInventories[tostring(plyId)][id].items) then
			items = ExtractData(storeInventories[tostring(plyId)][id].items)
		end
	else
		storeInventories[tostring(plyId)] = {}
		storeInventories[tostring(plyId)][id] = {
			items = {}
		}
	end
	return items
end

GetStoreTotalWeight = function(id, plyId)
	if not storeInventories[tostring(plyId)] then
		return 0
	end
	if storeInventories[tostring(plyId)][id] then
		local storeData = storeInventories[tostring(plyId)][id].items
		if storeData and #storeData > 0 then
			local temp_weight = 0
			for i=1,#storeData do
				if storeData[i] and storeData[i].name then
					local name = storeData[i].name
					local amount = storeData[i].amount
					local itemData = ESX.Shared.Items[name]
					if itemData then
						local toAdd = itemData.weight * amount
						temp_weight = temp_weight + toAdd
					end
				end
			end
			return temp_weight
		else
			return 0
		end
	end
	return 0
end

hasStoreItem = function(id, plyId, slot, name, amount)
	local amount = tonumber(amount)
	if not ESX.Shared.Items[name] then return false end
	if not storeInventories[tostring(plyId)] then return false end
	if not storeInventories[tostring(plyId)][id] then return false end
	if not storeInventories[tostring(plyId)][id].items[slot] then return false end
	if storeInventories[tostring(plyId)][id].items[slot].name == name and storeInventories[tostring(plyId)][id].items[slot].amount >= amount then
		return true
	end
	return false
end

canStoreCarryItem = function(id, plyId, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not storeInventories[tostring(plyId)] or not storeInventories[tostring(plyId)][id] then return false end
	local totalWeight = GetStoreTotalWeight(id, plyId)
	local toItemAdd = ItemData.weight * amount
	if totalWeight + toItemAdd <= storeInventories[tostring(plyId)][id].maxweight then
		return true
	end
	return false
end

AddToStoreInventory = function(id, plyId, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	if not storeInventories[tostring(plyId)] then
		storeInventories[tostring(plyId)] = {}
		storeInventories[tostring(plyId)][id] = {}
	else
		if not storeInventories[tostring(plyId)][id] then
			storeInventories[tostring(plyId)][id] = {}
		end
	end
 	if storeInventories[tostring(plyId)][id].items[slot] ~= nil and storeInventories[tostring(plyId)][id].items[slot].name == itemName then
		storeInventories[tostring(plyId)][id].items[slot].amount = storeInventories[tostring(plyId)][id].items[slot].amount + amount
	else
		local itemInfo = ESX.Shared.Items[itemName:lower()]
		storeInventories[tostring(plyId)][id].items[slot] = {
			name = itemInfo.name,
			amount = amount,
			info = info or "",
			slot = slot,
			id = dropId,
		}
	end
end

RemoveFromStoreInventory = function(id, plyId, slot, itemName, amount)
	if storeInventories[tostring(plyId)][id].items[slot] ~= nil and storeInventories[tostring(plyId)][id].items[slot] and storeInventories[tostring(plyId)][id].items[slot].name == itemName then
		if storeInventories[tostring(plyId)][id].items[slot].amount > amount then
			storeInventories[tostring(plyId)][id].items[slot].amount = storeInventories[tostring(plyId)][id].items[slot].amount - amount
		else
			storeInventories[tostring(plyId)][id].items[slot] = nil
			if next(storeInventories[tostring(plyId)][id].items) == nil then
				storeInventories[tostring(plyId)][id].items = {}
			end
		end
	else
		storeInventories[tostring(plyId)][id].items[slot] = nil
		if storeInventories[tostring(plyId)][id].items == nil then
			storeInventories[tostring(plyId)][id].items[slot] = nil
		end
	end
end

RegisterServerEvent('inventory:OpenStoreInventory', function(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('inventory:server:opensvInventory', source, "storeinventory", tostring(id))
end)
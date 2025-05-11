SetupCustomInvItems = function(data)
	local items = {}
	local InvInfo = data.info.items
	if InvInfo then
		for k, item in pairs(InvInfo) do
			local itemInfo = ESX.Shared.Items[item.name]
			if itemInfo then
				items[item.slot] = {
					name = itemInfo.name,
					amount = tonumber(item.amount),
					info = item.info or "",
					slot = item.slot
				}
			else
				items[item.slot] = {}
			end
		end
	end
	return items
end

hasMiniStorageItem = function(playerId, slot, name, toSlot, toAmount)
	local toAmount = tonumber(toAmount)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local itemData = xPlayer.GetItemBySlot(slot)
	local itemInfo = itemData.info
	if itemInfo.items then
		for k,v in pairs(itemInfo.items) do
			if k then
				if v.name == name and v.slot == toSlot and v.amount >= toAmount then
					return true
				end
			end
		end
	end
	return false
end

AddToMiniStorage = function(playerId, slot, name, toSlot, otherslot, toAmount, toInfo)
	local toAmount = tonumber(toAmount)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local itemData = xPlayer.GetItemBySlot(slot)
	local itemInfo = itemData.info
	if not itemInfo then
		itemInfo = {}
	end
	if not itemInfo.items then
		itemInfo.items = {}
	end
	local changeMade = false
	local ItemData = ESX.Shared.Items[name]
	if not ItemData.unique then
		if itemInfo.items[toSlot] and itemInfo.items[toSlot].name == name then
			itemInfo.items[toSlot].amount = itemInfo.items[toSlot].amount + toAmount
		else
			local toitemInfo = ESX.Shared.Items[name:lower()]
			itemInfo.items[toSlot] = {
				name = toitemInfo.name,
				amount = toAmount,
				info = toInfo or "",
				slot = toSlot,
			}
		end
	else
		if itemInfo.items[toSlot] and itemInfo.items[toSlot].name == name then
			local toitemInfo = ESX.Shared.Items[name:lower()]
			itemInfo.items[otherslot] = {
				name = toitemInfo.name,
				amount = toAmount,
				info = toInfo or "",
				slot = otherslot,
			}
		else
			local toitemInfo = ESX.Shared.Items[name:lower()]
			itemInfo.items[toSlot] = {
				name = toitemInfo.name,
				amount = toAmount,
				info = toInfo or "",
				slot = toSlot,
			}
		end
	end
	xPlayer.updateItemData(slot, itemInfo)
end

RemoveFromMiniStorage = function(playerId, slot, name, toSlot, toAmount, toInfo)
	local toAmount = tonumber(toAmount)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local itemData = xPlayer.GetItemBySlot(slot)
	local itemInfo = itemData.info
	if itemInfo.items[toSlot] ~= nil and itemInfo.items[toSlot].name == name then
		if itemInfo.items[toSlot].amount > toAmount then
			itemInfo.items[toSlot].amount = itemInfo.items[toSlot].amount - toAmount
		else
			itemInfo.items[toSlot] = nil
			if next(itemInfo.items) == nil then
				itemInfo.items = {}
			end
		end
	else
		itemInfo.items[toSlot] = nil
		if itemInfo.items == nil then
			itemInfo.items[toSlot] = nil
		end
	end
	xPlayer.updateItemData(slot, itemInfo)
end
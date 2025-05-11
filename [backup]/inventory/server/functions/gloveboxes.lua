LoadGloveBoxes = function()
	local result4 = MySQL.Sync.fetchAll('SELECT * FROM gloveboxitems')
	if result4 and next(result4) then
		for k,v in pairs(result4) do
			Wait(50)
			Gloveboxes[v.plate] = {}
			local tmp2result = MySQL.Sync.fetchScalar('SELECT items FROM gloveboxitems WHERE plate = ?', {v.plate})
			local items = {}
			if tmp2result then
				local trunkItems = json.decode(tmp2result)
				if trunkItems then
					for _, item in pairs(trunkItems) do
						if item then
							local itemInfo = ESX.Shared.Items[item.name:lower()]
							if itemInfo then
								items[item.slot] = {
									name = itemInfo.name,
									amount = tonumber(item.amount),
									info = item.info or "",
									slot = item.slot,
								}
								if itemInfo.name == "fakeplate" then
									storedFakeplates[item.info.plate] = true
								end
							end
						end
					end
				end
			end
			Gloveboxes[v.plate].items = items
		end
	end
end

GetOwnedVehicleGloveboxItems = function(plate)
	local items = {}
	local result = Gloveboxes[plate]
	if result then
		local gloveboxItems = result.items
		if gloveboxItems then
			for k, item in pairs(gloveboxItems) do
				if item then
					local itemInfo = ESX.Shared.Items[item.name:lower()]
					if itemInfo then
						if itemInfo.itemtype == "expiring" and item.info and item.info.time and item.info.quality then
							local timePassed = os.time() - item.info.time
							local counter = math.floor(timePassed / 4320)
							if counter >= 1 then
								local new_quality = ESX.Math.Round(item.info.quality - (5 * counter))
								if new_quality <= 0 then
									item.info.quality = 0
									item.info.time = nil
								else
									item.info.quality = new_quality
									item.info.time = os.time()
								end
							end
						end
						items[item.slot] = {
							name = itemInfo.name,
							amount = tonumber(item.amount),
							info = item.info or "",
							slot = item.slot,
						}
					end
				end
			end
		end
	end
	return items
end

SaveOwnedGloveboxItems = function(plate, items)
	if items ~= nil then
		TriggerClientEvent('inventory:client:UpdateInventory', -1, "glovebox", plate)
	end
end

SaveGloveboxes = function()
	local data = Gloveboxes
	for k,v in pairs(data) do
		local items = v.items
		if items then
			local temp_list = {}
			for _, item in pairs(items) do
				table.insert(temp_list, {
					name = item.name,
					slot = item.slot,
					amount = item.amount,
					info = item.info
				})
			end
			MySQL.Async.insert('INSERT INTO gloveboxitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items',{
				['plate'] = k,
				['items'] = json.encode(temp_list)
			})
		end
	end
end

GetGloveboxTotalWeight = function(plate)
	if not Gloveboxes[plate] then
		return 0
	end
	if Gloveboxes[plate] then
		local gloveboxData = Gloveboxes[plate].items
		if gloveboxData and #gloveboxData > 0 then
			local temp_weight = 0
			for i=1,#gloveboxData do
				if gloveboxData[i] and gloveboxData[i].name then
					local name = gloveboxData[i].name
					local amount = gloveboxData[i].amount
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

hasGloveboxItem = function(plate, slot, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not Gloveboxes[plate] then return false end
	if not Gloveboxes[plate].items[slot] then return false end
	if Gloveboxes[plate].items[slot].name == item and Gloveboxes[plate].items[slot].amount >= amount then
		return true
	end
	return false
end

canGloveboxSwapItems = function(plate, item1, amount1, item2, amount2)
	local ItemData1 = ESX.Shared.Items[item1]
	if not ItemData1 then return false end
	local ItemData2 = ESX.Shared.Items[item2]
	if not ItemData2 then return false end
	if not Gloveboxes[plate] then return false end
	local totalWeight = GetGloveboxTotalWeight(plate)
	local removingItemWeight = ItemData2.weight * amount2
	local newWeight = totalWeight - removingItemWeight
	local addingItemWeight = ItemData1.weight * amount1
	local totalnewWeight = newWeight + addingItemWeight
	if totalnewWeight <= Gloveboxes[plate].maxweight then
		return true
	end
	return false
end

canGloveBoxCarryItem = function(plate, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not Gloveboxes[plate] then return false end
	local totalWeight = GetGloveboxTotalWeight(plate)
	local toItemAdd = ItemData.weight * amount
	if totalWeight + toItemAdd <= Gloveboxes[plate].maxweight then
		return true
	end
	return false
end

AddToGlovebox = function(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[itemName]
	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	end
end

RemoveFromGlovebox = function(plate, slot, itemName, amount)
	if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
			if next(Gloveboxes[plate].items) == nil then
				Gloveboxes[plate].items = {}
			end
		end
	else
		Gloveboxes[plate].items[slot] = nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end
LoadTrunks = function()
	local result3 = MySQL.Sync.fetchAll('SELECT * FROM trunkitems')
	if result3 and next(result3) then
		for k,v in pairs(result3) do
			Wait(50)
			Trunks[v.plate] = {}
			local items = {}
			local tmpresult = MySQL.Sync.fetchScalar('SELECT items FROM trunkitems WHERE plate = ?', {v.plate})
			if tmpresult then
				local trunkItems = json.decode(tmpresult)
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
			Trunks[v.plate].items = items
		end
	end
end

GetOwnedVehicleItems = function(plate)
	local items = {}
	local result = Trunks[plate]
	if result then
		local trunkItems = result.items
		if trunkItems then
			for k, item in pairs(trunkItems) do
				if item then
					local itemInfo = ESX.Shared.Items[item.name:lower()]
					if itemInfo then
						if itemInfo.itemtype == "expiring" and item.info and item.info.quality and item.info.time then
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

SaveOwnedVehicleItems = function(plate, items)
	if items ~= nil then
		TriggerClientEvent('inventory:client:UpdateInventory', -1, "trunk", plate)
	end
end

SaveTrunks = function()
	local data = Trunks
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
			MySQL.Async.insert('INSERT INTO trunkitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items',{
				['plate'] = k,
				['items'] = json.encode(temp_list)
			})
		end
	end
end

GetTrunkTotalWeight = function(plate)
	if not Trunks[plate] then
		return 0
	end
	if Trunks[plate] then
		local trunkData = Trunks[plate].items
		if trunkData and #trunkData > 0 then
			local temp_weight = 0
			for i=1,#trunkData do
				if trunkData[i] and trunkData[i].name then
					local name = trunkData[i].name
					local amount = trunkData[i].amount
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

hasTrunkItem = function(plate, slot, name, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[name]
	if not ItemData then return false end
	if not Trunks[plate] then return false end
	if not Trunks[plate].items[slot] then return false end
	if Trunks[plate].items[slot].name == name and Trunks[plate].items[slot].amount >= amount then
		return true
	end
	return false
end

canTrunkSwapItems = function(plate, item1, amount1, item2, amount2)
	local ItemData1 = ESX.Shared.Items[item1]
	if not ItemData1 then return false end
	local ItemData2 = ESX.Shared.Items[item2]
	if not ItemData2 then return false end
	if not Trunks[plate] then return false end
	local totalWeight = GetTrunkTotalWeight(plate)
	local removingItemWeight = ItemData2.weight * amount2
	local newWeight = totalWeight - removingItemWeight
	local addingItemWeight = ItemData1.weight * amount1
	local totalnewWeight = newWeight + addingItemWeight
	if totalnewWeight <= Trunks[plate].maxweight then
		return true
	end
	return false
end

canTrunkCarryItem = function(plate, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not Trunks[plate] then return false end
	local totalWeight = GetTrunkTotalWeight(plate)
	local toItemAdd = ItemData.weight * amount
	if totalWeight + toItemAdd <= Trunks[plate].maxweight then
		return true
	end
	return false
end

AddToTrunk = function(plate, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[itemName]
	if not ItemData.unique then
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	end
end

RemoveFromTrunk = function(plate, slot, itemName, amount)
	if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
			if next(Trunks[plate].items) == nil then
				Trunks[plate].items = {}
			end
		end
	else
		Trunks[plate].items[slot] = nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end
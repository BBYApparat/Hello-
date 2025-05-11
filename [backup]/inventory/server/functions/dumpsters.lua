GetDumpsterItems = function(id)
	local items = {}
	local result = Dumpsters[id]
	if result then
		local dumpItems = result.items
		if dumpItems then
			for k, item in pairs(dumpItems) do
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
	else
		if Config.StandardDumpsters[id] then

		else
			math.randomseed(ESX.Math.Round(os.time() / 13) * (os.time() * 0.32))
			local mr = math.random(1, 2)
			if mr == 1 then
				local garbage_items = Config.Dumpsters.items[math.random(1,#Config.Dumpsters.items)]
				for k, item in pairs(garbage_items) do
					local itemInfo = ESX.Shared.Items[item.name:lower()]
					if itemInfo then
						local info = ESX.SetupItemInfo(itemInfo.name) or ""
						items[item.slot] = {
							name = itemInfo.name,
							amount = tonumber(item.amount),
							info = info,
							slot = item.slot,
						}
					end
				end
			end
		end
	end
	return items
end

SaveDumpsterItems = function(id, items)
	if items then
		TriggerClientEvent('inventory:client:UpdateInventory', -1, "dumpster", id) --TOFIX
	end
end

GetDumpsterTotalWeight = function(id)
	if not Dumpsters[id] then
		return 0
	end
	if Dumpsters[id] then
		local dumpsterData = Dumpsters[id].items
		if dumpsterData and #dumpsterData > 0 then
			local temp_weight = 0
			for i=1,#dumpsterData do
				if dumpsterData[i] and dumpsterData[i].name then
					local name = dumpsterData[i].name
					local amount = dumpsterData[i].amount
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

hasDumpsterItem = function(id, slot, name, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[name]
	if not ItemData then return false end
	if not Dumpsters[id] then return false end
	if not Dumpsters[id].items[slot] then return false end
	if Dumpsters[id].items[slot].name == name and Dumpsters[id].items[slot].amount >= amount then
		return true
	end
	return false
end

canDumpsterSwapItems = function(id, item1, amount1, item2, amount2)
	local ItemData1 = ESX.Shared.Items[item1]
	if not ItemData1 then return false end
	local ItemData2 = ESX.Shared.Items[item2]
	if not ItemData2 then return false end
	if not Dumpsters[id] then return false end
	local totalWeight = GetDumpsterTotalWeight(id)
	local removingItemWeight = ItemData2.weight * amount2
	local newWeight = totalWeight - removingItemWeight
	local addingItemWeight = ItemData1.weight * amount1
	local totalnewWeight = newWeight + addingItemWeight
	if totalnewWeight <= Dumpsters[id].maxweight then
		return true
	end
	return false
end

canDumpsterCarryItem = function(id, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not Dumpsters[id] then return false end
	local totalWeight = GetDumpsterTotalWeight(id)
	local toItemAdd = ItemData.weight * amount
	if totalWeight + toItemAdd <= Dumpsters[id].maxweight then
		return true
	end
	return false
end

AddToDumpster = function(id, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[itemName]
	if not ItemData.unique then
		if Dumpsters[id].items[slot] ~= nil and Dumpsters[id].items[slot].name == itemName then
			Dumpsters[id].items[slot].amount = Dumpsters[id].items[slot].amount + amount
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Dumpsters[id].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	else
		if Dumpsters[id].items[slot] ~= nil and Dumpsters[id].items[slot].name == itemName then
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Dumpsters[id].items[otherslot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Dumpsters[id].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	end
end

RemoveFromDumpster = function(id, slot, itemName, amount)
	if Dumpsters[id].items[slot] ~= nil and Dumpsters[id].items[slot].name == itemName then
		if Dumpsters[id].items[slot].amount > amount then
			Dumpsters[id].items[slot].amount = Dumpsters[id].items[slot].amount - amount
		else
			Dumpsters[id].items[slot] = nil
			if next(Dumpsters[id].items) == nil then
				Dumpsters[id].items = {}
			end
		end
	else
		Dumpsters[id].items[slot] = nil
		if Dumpsters[id].items == nil then
			Dumpsters[id].items[slot] = nil
		end
	end
end

local CreateUniqueDumpsterId = function(data)
	local foundId = nil
	if Dumpsters and next(Dumpsters) then
		local id = 0
		for k,v in pairs(Dumpsters) do
			local dist = #(v.coords - vector3(data.coords.x, data.coords.y, data.coords.z))
			if dist <= 0.5 and data.model == v.model then
				foundId = k
				break
			end
			id = id + 1
		end
		if not foundId then
			foundId = "dump"..(id + 1)
		end
	else
		foundId = "dump1"
	end
	return foundId
end

RegisterServerEvent('inventory:OpenDumpster', function(data)
	local dumpsterId = CreateUniqueDumpsterId(data)
	while not dumpsterId do
		Wait(0)
	end
	local sendingData = {
		coords = vector3(data.coords.x, data.coords.y, data.coords.z),
		model = data.model,
		id = dumpsterId
	}
	TriggerEvent('inventory:server:opensvInventory', source, "dumpster", sendingData)
end)
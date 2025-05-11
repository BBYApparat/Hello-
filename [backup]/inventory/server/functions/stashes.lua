LoadStashes = function()
	local result2 = MySQL.Sync.fetchAll('SELECT * FROM stashitems')
	for k,v in pairs(result2) do
		Wait(50)
		Stashes[v.stash] = {}
		local items = {}
		local tempresult = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', {v.stash})
		if tempresult then
			local stashItems = json.decode(tempresult)
			if stashItems then
				for _, item in pairs(stashItems) do
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
		Stashes[v.stash].items = items
	end
end

local IsBuddyDryingStash = function(stashId)
	for i=1,#Config.BudStashes do
		if string.match(stashId, Config.BudStashes[i]) then
			return true
		end
	end
	return false
end

GetStashItems = function(stashId)
	local items = {}
	local result = Stashes[stashId]
	if result then
		local stashItems = result.items
		if stashItems then
			for k, item in pairs(stashItems) do
				if item then
					if Config.Buds[item.name] then
						local isNeededStash = IsBuddyDryingStash(stashId)
						if isNeededStash then
							local timerNeeded = Config.Buds[item.name]
							local timePassed = (os.time() - item.info.dryTime)
							if timePassed >= timerNeeded then
								local new_name = Config.DryBuds[item.name]
								item.name = new_name
								Stashes[stashId].items[item.slot].name = new_name
							end
						end
					end
					local itemInfo = ESX.Shared.Items[item.name:lower()]
					if itemInfo then
						if itemInfo.itemtype == "expiring" and item.info and item.info.quality and item.info.time then
							local timePassed = os.time() - item.info.time
							local temp_timer = 4320
							if string.match(stashId, "fridge") then
								temp_timer = 8640
							end
							local counter = math.floor(timePassed / temp_timer)
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

exports("GetStashItems", GetStashItems)


SaveStashItems = function(stashId, items)
	if items then
		TriggerClientEvent('inventory:client:UpdateInventory', -1, "stash", stashId)
	end
end

SaveStashes = function()
	local data = Stashes
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
			MySQL.Async.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items',{
				['stash'] = k,
				['items'] = json.encode(temp_list)
			})
		end
	end
end

GetStashTotalWeight = function(stashId)
	if not Stashes[stashId] then
		return 0
	end
	if Stashes[stashId] then
		local stashData = Stashes[stashId].items
		if stashData and #stashData > 0 then
			local temp_weight = 0
			for i=1,#stashData do
				if stashData[i] and stashData[i].name then
					local name = stashData[i].name
					local amount = stashData[i].amount
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

hasStashItem = function(stashId, slot, name, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[name]
	if not ItemData then return false end
	if not Stashes[stashId] then return false end
	if not Stashes[stashId].items[slot] then return false end
	if Stashes[stashId].items[slot] then
		if Stashes[stashId].items[slot].name == name and Stashes[stashId].items[slot].amount >= amount then
			return true
		end
	end
	return false
end

exports("hasStashItem", hasStashItem)

canStashSwapItems = function(stashId, item1, amount1, item2, amount2)
	local amount = tonumber(amount)
	local ItemData1 = ESX.Shared.Items[item1]
	if not ItemData1 then return false end
	local ItemData2 = ESX.Shared.Items[item2]
	if not ItemData2 then return false end
	if not Stashes[stashId] then return false end
	local totalWeight = GetStashTotalWeight(stashId)
	local removingItemWeight = ItemData2.weight * amount2
	local newWeight = totalWeight - removingItemWeight
	local addingItemWeight = ItemData1.weight * amount1
	local totalnewWeight = newWeight + addingItemWeight
	if totalnewWeight <= Stashes[stashId].maxweight then
		return true
	end
	return false
end

canStashCarryItem = function(stashId, item, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[item]
	if not ItemData then return false end
	if not Stashes[stashId] then return false end
	local totalWeight = GetStashTotalWeight(stashId)
	local toItemAdd = ItemData.weight * amount
	if totalWeight + toItemAdd <= Stashes[stashId].maxweight then
		return true
	end
	return false
end

AddToStash = function(stashId, slot, otherslot, itemName, amount, info)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[itemName]
	if Config.Buds[itemName] then
		local isDryingStash = IsBuddyDryingStash(stashId)
		if isDryingStash then
			if not info then
				info = {
					dryTime = os.time(),
					quality = math.random(0, 100)
				}
			elseif not info.dryTime then
				info.dryTime = os.time()
			end
		end
	end
	if not ItemData.unique then
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Shared.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo.name,
				amount = amount,
				info = info or "",
				slot = slot,
			}
		end
	end
end

RemoveFromStash = function(stashId, slot, itemName, amount)
	local amount = tonumber(amount)
	if Config.Buds[itemName] then
		if Stashes[stashId].items[slot].info.dryTime then
			Stashes[stashId].items[slot].info.dryTime = nil
		end
	end
	if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
			if next(Stashes[stashId].items) == nil then
				Stashes[stashId].items = {}
			end
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

AddEventHandler('inventory:deleteStash', function(id)
	if Stashes[id] then
		TriggerClientEvent('inventory:closeCurrentInventory', -1, "stash", id)
		Wait(250)
		Stashes[id] = nil
		MySQL.Sync.execute('DELETE FROM stashitems WHERE stash = @stash',{
			['@stash'] = id
		})
	end
end)

AddEventHandler("inventory:server:getStashItems", function(stashId, cb)
	cb(GetStashItems(stashId))
end)

AddEventHandler('inventory:server:emptyInventory', function(name)
	if Stashes[name] then
		Stashes[name].items = {}
		MySQL.Async.execute('DELETE FROM stashitems WHERE stash = @stash', {
			['@stash'] = name
		})
	end
end)

ESX.RegisterServerCallback('inventory:server:GetStashItems', function(source, cb, stashId)
	cb(GetStashItems(stashId))
end)
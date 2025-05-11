LoadAutoShops = function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM `autoshops`')
    for k,v in pairs(result) do
        if v.shop then
			local temp_data = {}
            temp_data.items = {}
            local temp_items = json.decode(v.items)
            for _, b in pairs(temp_items) do
                temp_data.items[_] = {
                    name = b.name,
                    amount = b.amount,
                    slot = b.slot,
                    price = b.price
                }
            end
			Autoshops[v.shop] = temp_data
        end
    end
end

LoadAutoShopData = function()
	for k,v in pairs(ESX.Jobs) do
		if not Autoshops[v.name] then
			Autoshops[v.name] = {}
		end
	end
end

SetupAutoShopItems = function(shop)
	local shopItems = {}
	if Autoshops[shop] and Autoshops[shop].items then
		shopItems = Autoshops[shop].items
	end
	local items = {}
	if shopItems and next(shopItems) then
		for k, item in pairs(shopItems) do
			if item then
				local itemInfo = ESX.Shared.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = itemInfo.name,
						amount = tonumber(item.amount),
						info = item.info or "",
						price = item.price,
						slot = item.slot
					}
				end
			end
		end
	end
	return items
end

SaveAutoshopItems = function(autoshopId, items)
	if items then
		for slot, item in pairs(items) do
			item.description = nil
			item.info = nil
		end
		MySQL.Async.insert('INSERT INTO autoshops (shop, items) VALUES (:shop, :items) ON DUPLICATE KEY UPDATE items = :items',{
			['shop'] = autoshopId,
			['items'] = json.encode(items)
		})
	end
end

HasAutoshopEnough = function(autoshopId, slot, itemName, amount)
	if Autoshops[autoshopId] and Autoshops[autoshopId].items and Autoshops[autoshopId].items[slot] and Autoshops[autoshopId].items[slot].name == itemName then
		local temp_amount = Autoshops[autoshopId].items[slot].amount
		if temp_amount - amount >= 0 then
			return true
		end
	end
	return false
end

AddToAutoshop = function(autoshopId, slot, itemName, amount)
	local amount = tonumber(amount)
	local ItemData = ESX.Shared.Items[itemName]
	local autoshopData = Autoshops[autoshopId].items
	local changed = false
	local SlotExists = false
	for k,v in pairs(autoshopData) do
		if v.name == itemName then
			Autoshops[autoshopId].items[k].amount = Autoshops[autoshopId].items[k].amount + amount
			changed = true
			break
		end
	end
	if Autoshops[autoshopId].items[slot] and not changed then
		SlotExists = true
	end
	if not changed and not SlotExists then
		local itemInfo = ESX.Shared.Items[itemName:lower()]
		Autoshops[autoshopId].items[slot] = {
			name = itemInfo.name,
			amount = amount,
			info = "",
			slot = slot,
		}
	end
end

RemoveFromAutoshop = function(autoshopId, slot, itemName, amount)
	local amount = tonumber(amount)
	if Autoshops[autoshopId].items[slot] ~= nil and Autoshops[autoshopId].items[slot].name == itemName then
		if Autoshops[autoshopId].items[slot].amount > amount then
			Autoshops[autoshopId].items[slot].amount = Autoshops[autoshopId].items[slot].amount - amount
		else
			Autoshops[autoshopId].items[slot] = nil
			if next(Autoshops[autoshopId].items) == nil then
				Autoshops[autoshopId].items = {}
			end
		end
	else
		Autoshops[autoshopId].items[slot] = nil
		if Autoshops[autoshopId].items == nil then
			Autoshops[autoshopId].items[slot] = nil
		end
	end
end

RegisterServerEvent('inventory:server:updateAutoshop', function(_data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.job.name
	local item = xPlayer.GetItemBySlot(_data.itemData.slot)
	if item and item.amount >= _data.itemData.amount then
		if IsVendingItemWhitelisted(_data.itemData.name, source) then
			if Autoshops[job] then
				if not Autoshops[job].items then
					Autoshops[job].items = {}
				end
				if Autoshops[job].items then
					for k,v in pairs(Autoshops[job].items) do
						if v.name == _data.itemData.name then
							xPlayer.showNotification('This item already exists. Stack it', "error", 2000)
							return
						end
					end
					if not Autoshops[job].items[tostring(_data.toSlot)] then
						xPlayer.removeInventoryItem(_data.itemData.name, _data.itemData.amount)
						Autoshops[job].items[tostring(_data.toSlot)] = {
							name = _data.itemData.name,
							amount = _data.itemData.amount,
							info = _data.itemData.info or "",
							slot = _data.toSlot,
							price = _data.money
						}
						SaveAutoshopItems(job, Autoshops[job].items)
					end
				end
			end
		else
			xPlayer.showNotification('You are not allowed to sell this item.', "error", 2000)
		end
	end
end)
SetupShopItems = function(shop, shopItems)
	local items = {}
	local slotnum = 0
	if shopItems and next(shopItems) then
		for k, item in pairs(shopItems) do
			local itemInfo = ESX.Shared.Items[item.name:lower()]
			if itemInfo then
				slotnum = slotnum + 1
				items[slotnum] = {
					name = itemInfo.name,
					amount = tonumber(item.amount),
					info = item.info or "",
					price = item.price,
					slot = slotnum,
				}
			end
		end
	end
	return {items, slotnum}
end
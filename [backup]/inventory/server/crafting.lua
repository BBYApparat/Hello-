hasCraftItems = function(source, CostItems, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(CostItems) do
		if v.name == "money" then
			local money = xPlayer.getMoney()
			if money < (v.count * amount) then
				return false
			end
		else
			local temp_item = xPlayer.GetTotalItemAmount(v.name)
			if temp_item < (v.count * amount) then
				return false
			end
		end
	end
	return true
end

local recipeContains = function(recipe, fromItem)
	for k, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end
	return false
end

RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local amount = tonumber(amount)
    local canAfford = true
	local hadMoney = true
    local weighttoremove = 0
	local logtext = "** "..GetPlayerName(src).."** *("..src..') - '..Player.identifier.."* **crafted x".. amount..' of '..itemName.. ' to Slot '..toSlot.. '**\n** Costs: '
	if itemName ~= nil and itemCosts ~= nil then
        for k,v in pairs(itemCosts) do
			if v.name == "money" then
				local money = Player.getMoney()
				if money < v.count then
					canAfford = false
					hadMoney = false
					break
				end
			else
				local temp_amount = Player.GetTotalItemAmount(v.name)
				if temp_amount < v.count then
					canAfford = false
					break
				end
			end
        end
        if canAfford then
            for k,v in pairs(itemCosts) do
				if v.name ~= "money" then
					local item = ESX.Shared.Items[v.name]
					weighttoremove = weighttoremove + (item.weight * v.count)
				end
            end
            local totalWeight = Player.GetTotalWeight(Player.inventory)
            local new_weight = totalWeight - weighttoremove
            local itemweight = ESX.Shared.Items[itemName].weight
            local newtotalweight = (itemweight * amount) + new_weight
            if newtotalweight < ESX.Config.MaxWeight then
                for k, v in pairs(itemCosts) do
					if v.name == "money" then
						local totalcount = (v.count * amount)
						Player.removeMoney(totalcount)
						Player.showNotification('Removed $'..totalcount, "inform", 2000)
						logtext = logtext.. ' $'..totalcount..' , '
					else
						local totalcount = (v.count * amount)
						Player.removeInventoryItem(v.name, totalcount)
						Player.ItemBox(v.name, "remove", totalcount)
						logtext = logtext.. ' x'..totalcount..' of '..v.name..' , '
					end
                end
				logtext = logtext..' **'
				local info = ""
				if ESX.Shared.Items[itemName].itemtype == "expiring" then
					info = {
						time = os.time(),
						quality = 100
					}
				elseif ESX.Shared.Items[itemName].type == "weapon" then
					info = {
						serie = tostring(ESX.Shared.RandomInt(2) .. ESX.Shared.RandomStr(3) .. ESX.Shared.RandomInt(1) .. ESX.Shared.RandomStr(2) .. ESX.Shared.RandomInt(3) .. ESX.Shared.RandomStr(4)),
						quality = 100
					}
				end
                Player.addInventoryItem(itemName, amount, toSlot, info)
				Player.ItemBox(itemName, "add", amount)
				SendLog("crafting", { color = 32768, title = 'Crafting Logs', message = logtext })
                TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
            else
                Player.showNotification('Not Enough Space', "error", 2000)
            end
		else
			local temp_msg = "You are missing Important Items"
			if not hadMoney then
				temp_msg = "You don't have enough money"
			end
			Player.showNotification(temp_msg, "error", 2000)
        end
	end
end)

RegisterNetEvent('inventory:server:combineItem', function(item, fromoldItem, tooldItem)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if fromoldItem == nil  then return end
	if tooldItem == nil then return end
	local fromItem = xPlayer.GetItemByName(fromoldItem)
	local toItem = xPlayer.GetItemByName(tooldItem)
	if fromItem == nil then return end
	if toItem == nil then return end
	local recipe = ESX.Shared.Items[toItem.name].combinable
	if recipe and recipe.reward ~= item then return end
	if not recipeContains(recipe, fromItem) then return end
    local weight1 = ESX.Shared.Items[item].weight
    local weight2 = ESX.Shared.Items[fromItem.name].weight
    local weight3 = ESX.Shared.Items[toItem.name].weight
    local totweight = xPlayer.GetTotalWeight(xPlayer.inventory)
    local totalremovableweight = weight3 + weight2
    local removedweight = totweight - totalremovableweight
    local addedweight = removedweight + weight1
    if addedweight <= ESX.Config.MaxWeight then
        xPlayer.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[item], 'add')
        xPlayer.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[fromItem.name], 'remove')
        xPlayer.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[toItem.name], 'remove')
		local info = ""
		if ESX.Shared.Items[item].itemtype == "expiring" then
			info = {
				time = os.time(),
				quality = 100
			}
		elseif ESX.Shared.Items[item].type == "weapon" then
			info = {
				serie = tostring(ESX.Shared.RandomInt(2) .. ESX.Shared.RandomStr(3) .. ESX.Shared.RandomInt(1) .. ESX.Shared.RandomStr(2) .. ESX.Shared.RandomInt(3) .. ESX.Shared.RandomStr(4)),
				quality = 100
			}
		end
        xPlayer.addInventoryItem(item, 1, nil, info)
        xPlayer.removeInventoryItem(fromItem.name, 1)
        xPlayer.removeInventoryItem(toItem.name, 1)
		SendLog("inventory", { color = 32768, title = 'Combine Logs', message = "**".. GetPlayerName(source) .. "** *("..source..') - '..xPlayer.identifier.."* combined new item\n from name 1: **"..fromItem.name.." x 1 **\n from name 2: **" .. toItem.name .. " x1 **\n ".. 'to name: **'..item..'**'})
    else
        xPlayer.showNotification('Not enough Space', "error", 2000)
    end
end)
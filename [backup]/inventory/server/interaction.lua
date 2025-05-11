ESX.RegisterCommand(Config.Commands.rob.cmdName, Config.Commands.rob.minGroup, function(xPlayer)
    xPlayer.triggerEvent("inventory:client:RobPlayer")
end)

RegisterServerEvent("inventory:server:GiveItem", function(target, name, amount, slot)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local OtherPlayer = ESX.GetPlayerFromId(tonumber(target))
    local myCoords = GetEntityCoords(GetPlayerPed(src))
    local tarCoords = GetEntityCoords(GetPlayerPed(target))
    local dist = #(myCoords - tarCoords)
	if Player == OtherPlayer then return end
	if dist > 2 then return end
	local item = Player.GetItemBySlot(slot)
	if not item then return end
	if item.name ~= name then return end
	if amount <= item.amount then
		if amount == 0 then
			amount = item.amount
		end
        if Player.hasInventoryItem(item.name, amount, item.slot) then
            if OtherPlayer.canCarryItem(item.name, amount) then
				Player.triggerEvent("inventory:client:CheckWeapon", item.name)
                Player.removeInventoryItem(item.name, amount, slot)
                Player.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[item.name], "remove")
                Player.triggerEvent('inventory:client:UpdatePlayerInventory', false)
                Player.triggerEvent('inventory:client:giveAnim')
                OtherPlayer.addInventoryItem(item.name, amount, false, item.info)
                OtherPlayer.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[item.name], "add")
                OtherPlayer.triggerEvent('inventory:client:UpdatePlayerInventory', false)
				SendLog("inventory", { color = 32768, title = 'Give item Logs', message = "**".. GetPlayerName(src) .. " ("..src..') - '..Player.identifier.."** gave Item to player \n Name: **"..item.name..'**\n Amount: **'..amount..'** \n Player took item: **'..GetPlayerName(target)..' ('..target..') - '..OtherPlayer.identifier..'**'})
			else
                Player.showNotification('The other player\'s inventory is full!', "error", 2000)
                OtherPlayer.showNotification("Your inventory is full!", "error", 2000)
                Player.triggerEvent('inventory:client:UpdatePlayerInventory', true)
                OtherPlayer.triggerEvent('inventory:client:UpdatePlayerInventory', true)
			end
		else
            Player.showNotification("You do not have enough of the item", "error", 2000)
		end
	else
        Player.showNotification("You do not have enough items to transfer", "error", 2000)
	end
end)

RegisterServerEvent('inventory:robTargetMoney', function(target, amount)
	local src = source
	if not target or target == -1 then return end
	if not amount or amount <= 0 then return end
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	local xPos = GetEntityCoords(GetPlayerPed(src))
	local tPos = GetEntityCoords(GetPlayerPed(target))
	if #(tPos - xPos) > 5.0 then return end
	local tMoney = xTarget.getMoney()
	if tMoney >= amount then
		xTarget.removeMoney(amount)
		xPlayer.addMoney(amount)
		SendLog("inventory", { color = 32768, title = 'Give money Logs', message = "**".. GetPlayerName(src) .. " ("..src..') - '..xPlayer.identifier.."** stole money from \n Name: **"..GetPlayerName(xTarget.source)..' ('..xTarget.source..') - '..xTarget.identifier..'**\n Amount: **$'..amount..'**'})
		xPlayer.triggerEvent('inventory:setSecondInventoryMoney', 0)
	end
end)

RegisterServerEvent('inventory:giveMoney', function(target, amount)
	local src = source
	if not target or target == -1 or type(amount) ~= 'number' then return end
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	local xPos = GetEntityCoords(GetPlayerPed(src))
	local tPos = GetEntityCoords(GetPlayerPed(target))
	if #(tPos - xPos) > 5.0 then return end
	local xMoney = xPlayer.getMoney()
	if (amount > xMoney) or (amount <= 0) then
		xPlayer.showNotification("Please enter a valid amount of money", "error", 2000)
		return
	end
	xTarget.addMoney(amount)
	xPlayer.removeMoney(amount)
	xTarget.showNotification('You received $'..amount)
	xPlayer.showNotification('You gave $'..amount)
	SendLog("inventory", { color = 32768, title = 'Give money Logs', message = "**".. GetPlayerName(src) .. " ("..src..') - '..xPlayer.identifier.."** gave money to \n Name: **"..GetPlayerName(xTarget.source)..' ('..xTarget.source..') - '..xTarget.identifier..'**\n Amount: **$'..amount..'**'})
	xPlayer.triggerEvent('inventory:setSecondInventoryMoney', xTarget.getMoney())
end)

RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local itemData = xPlayer.GetItemBySlot(slot)
	if itemData then
		local itemInfo = ESX.Shared.Items[itemData.name]
		if itemInfo.type == "weapon" then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
				end
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
		elseif itemInfo.usable then
			TriggerClientEvent("esx:useItem", src, itemData)
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = xPlayer.GetItemBySlot(item.slot)
		if itemData then
			TriggerClientEvent("esx:useItem", src, itemData)
		end
	end
end)
ESX = exports['es_extended']:getSharedObject()

GetSource = function(xPlayer)
	return xPlayer.source
end

GetPlayer = function(source)
	return ESX.GetPlayerFromId(source)
end

GetSourceFromIdentifier = function(identifier)
	return GetPlayerFromIdentifier(identifier).source
end

GetPlayers = function()
	return ESX.GetPlayers()
end

GetJob = function(source)
	return GetPlayer(source).job
end

GetPlayerFromIdentifier = function(identifier)
	return ESX.GetPlayerFromIdentifier(identifier)
end

AddItem = function(source, item, amount)
	local xPlayer = GetPlayer(source)
	xPlayer.addInventoryItem(item, amount)
end

RemoveItem = function(source, item, amount)
	local xPlayer = GetPlayer(source)
	xPlayer.removeInventoryItem(item, amount)
end

GetMoney = function(source, account)
	local account = account == 'cash' and 'money' or account
	local xPlayer = GetPlayer(source)
	return xPlayer.getAccount(account).money
end

AddMoney = function(source, account, amount)
	local account = account == 'cash' and 'money' or account
	local xPlayer = GetPlayer(source)
	xPlayer.addAccountMoney(account, amount)
end

RemoveMoney = function(source, account, amount)
	local account = account == 'cash' and 'money' or account
	local xPlayer = GetPlayer(source)
	xPlayer.removeAccountMoney(account, amount)
end

GetIdentifier = function(source)
	local xPlayer = GetPlayer(source)
	return xPlayer.identifier
end

GetInventory = function(source)
	local xPlayer = GetPlayer(source)
	return xPlayer.inventory
end

GetInventoryItem = function(source, item)
	local xPlayer = GetPlayer(source)
	local inv = xPlayer.getInventoryItem(item)
	return inv and inv.count or 0
end

HasEnoughItem = function(source, item, amount)
	local xPlayer = GetPlayer(source)
	local inv = xPlayer.getInventoryItem(item)
	return inv and inv.count and inv.count >= amount or false
end

GetItems = function()
	if GetResourceState('qs-inventory') == 'started' then
		return exports['qs-inventory']:GetItemList()
	elseif GetResourceState('ox_inventory') == 'started' then
		return exports['ox_inventory']:Items()
	elseif GetResourceState('inventory') == 'started' then
		exports.inventory:getItemInformations() 
	else
		return exports['es_extended']:getSharedObject().Items
	end
end

GetItemLabel = function(item)
	local items = GetItems()
    if items and items[item] then
	   return items[item].label
    else
        print('^1Item: ^3['..item..']^1 missing^0')
        return item
    end
end

AddSocietyMoney = function(job, money)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
       account.addMoney(money)
    end)
end

GetIdentifierByType = function(playerId, idtype)
    local src = source
    for _, identifier in pairs(GetPlayerIdentifiers(playerId)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

GetName = function(source)
	local identifier = GetIdentifier(source)
	local namedb = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = ?', {identifier})
    local name = namedb[1].firstname or ''
    name = namedb[1].lastname and name..' '..namedb[1].lastname or ''
    return name
end

CanCarryItem = function(source, item, amount)
	local xPlayer = GetPlayer(source)
	if xPlayer.canCarryItem then
		return xPlayer.canCarryItem(item, amount)
	else
		return true
	end
end

IsAdmin = function(source)
	local xPlayer = GetPlayer(source)
	if (Config.AdminWithAce and IsPlayerAceAllowed(source, 'command')) then
		print("^3["..source.."] ^2Permission Granted With Ace^0")
		return true
	elseif Config.AdminWithGroup[xPlayer.getGroup()] then
		print("^3["..source.."] ^2Permission Granted With Group^0")
		return true
	elseif  Config.AdminWithLicense[GetIdentifierByType(source, 'license')] then
		print("^3["..source.."] ^2Permission Granted With License^0")
		return true
	elseif Config.AdminWithIdentifier[GetIdentifier(source)] then 
		print("^3["..source.."] ^2Permission Granted With Identifier^0")
		return true
	end
	return false
end

IsVehicleOwner = function(source, plate)
	local identifier = GetIdentifier(source)
    local found = MySQL.Sync.fetchScalar('SELECT 1 FROM '..Config.OwnedVehiclesTable..' WHERE `owner` = ? AND `plate` = ?', {identifier, plate})
    return found and found > 0
end

GetCoin = function(identifier)
	local result = MySQL.Sync.fetchAll('SELECT * FROM '..Config.SpecialCoin.tablename..' WHERE `'..Config.SpecialCoin.identifiercolumname..'` = ?', {identifier})
	return result and result[1][Config.SpecialCoin.coincolumname] or 0
end

AddCoin = function(identifier, amount)
	MySQL.Async.execute('UPDATE '..Config.SpecialCoin.tablename..' SET '..Config.SpecialCoin.coincolumname..' = '..Config.SpecialCoin.coincolumname..' + ? WHERE `'..Config.SpecialCoin.identifiercolumname..'` = ?', {amount, identifier})
end

RemoveCoin = function(identifier, amount)
	MySQL.Async.execute('UPDATE '..Config.SpecialCoin.tablename..' SET '..Config.SpecialCoin.coincolumname..' = '..Config.SpecialCoin.coincolumname..' - ? WHERE `'..Config.SpecialCoin.identifiercolumname..'` = ?', {amount, identifier})
end

GetXp = function(identifier)
	local result = MySQL.Sync.fetchAll('SELECT * FROM '..Config.SpecialCoin.tablename..' WHERE `'..Config.SpecialCoin.identifiercolumname..'` = ?', {identifier})
	return result and result[1].xp or 0
end

RegisterVehicle = function(identifier, nid, model, plate)
	MySQL.Async.execute('INSERT INTO '..Config.OwnedVehiclesTable..' (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
    {
        ['@owner']      = identifier,
        ['@plate']      = plate,
        ['@vehicle']    = json.encode({model = GetHashKey(model), plate = plate}),
    })
    local vehicle = NetworkGetEntityFromNetworkId(nid)
    if DoesEntityExist(vehicle) then
    	SetVehicleNumberPlateText(vehicle, plate)
    end
end
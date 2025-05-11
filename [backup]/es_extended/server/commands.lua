ESX.RegisterCommand('add_whitelist', "superadmin", function(xPlayer, args)
	if args.playerId then
		if not Core.Whitelist[tostring(args.playerId)] then
			MySQL.insert("INSERT INTO whitelist (identifier) VALUES (@identifier)",{
				['@identifier'] = tostring(args.playerId)
			}, function(rowsChanged)
				Core.Whitelist[tostring(args.playerId)] = true
				if xPlayer then
					xPlayer.showNotification("User "..args.playerId..' added to whitelist!')
				else
					print("User "..args.playerId..' added to whitelist!')
				end
			end)
		else
			if xPlayer then
				xPlayer.showNotification("This user is already whitelisted!")
			else
				print("User "..args.playerId..' is already whitelisted!')
			end
		end
	end
end, true, {
	help = "Add a user to Whitelist",
	validate = true,
	arguments = {
		{ name = "playerId", help = "Player Identifier", type = "string" }
	}
})

ESX.RegisterCommand('remove_whitelist', "superadmin", function(xPlayer, args)
	if args.playerId then
		if Core.Whitelist[tostring(args.playerId)] then
			MySQL.insert("DELETE FROM whitelist WHERE identifier = @identifier",{
				['@identifier'] = tostring(args.playerId)
			}, function(rowsChanged)
				Core.Whitelist[tostring(args.playerId)] = nil
				if xPlayer then
					xPlayer.showNotification("User "..args.playerId..' removed from whitelist!')
				else
					print("User "..args.playerId..' removed from whitelist!')
				end
			end)
		else
			if xPlayer then
				xPlayer.showNotification("This user is not whitelisted!")
			else
				print("User "..args.playerId..' is not whitelisted!')
			end
		end
	end
end, true, {
	help = "Remove a user from Whitelist",
	validate = true,
	arguments = {
		{ name = "playerId", help = "Player Identifier", type = "string" }
	}
})

ESX.RegisterCommand('refresh_whitelist', "superadmin", function(xPlayer, args)
	ESX.RefreshWhitelist()
	if not xPlayer then
		print("Whitelist refreshed successfully")
	else
		xPlayer.showNotification("Whitelist refreshed successfully")
	end
end, true, {
	help = "Refresh whitelist",
	validate = false,
	arguments = {}
})

ESX.RegisterCommand({'setcoords', 'tp'}, 'admin', function(xPlayer, args)
	xPlayer.setCoords({ x = args.x, y = args.y, z = args.z })
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Set Coordinates /setcoords Triggered!", "pink", {
			{ name = "Player",  value = xPlayer.name,   inline = true },
			{ name = "ID",      value = xPlayer.source, inline = true },
			{ name = "X Coord", value = args.x,         inline = true },
			{ name = "Y Coord", value = args.y,         inline = true },
			{ name = "Z Coord", value = args.z,         inline = true },
		})
	end
end, false, {
	help = TranslateCap('command_setcoords'),
	validate = true,
	arguments = {
		{ name = 'x', help = TranslateCap('command_setcoords_x'), type = 'number' },
		{ name = 'y', help = TranslateCap('command_setcoords_y'), type = 'number' },
		{ name = 'z', help = TranslateCap('command_setcoords_z'), type = 'number' }
	}
})

ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if not ESX.DoesJobExist(args.job, args.grade) then
		return showError(TranslateCap('command_setjob_invalid'))
	end

	args.playerId.setJob(args.job, args.grade)
	
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Set Job /setjob Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,       inline = true },
			{ name = "ID",     value = xPlayer.source,     inline = true },
			{ name = "Target", value = args.playerId.name, inline = true },
			{ name = "Job",    value = args.playerId,      inline = true },
			{ name = "Grade",  value = args.playerId,      inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'setjob', 'Setjob', 'green', string.format('%s set job %s to %s', GetPlayerName(xPlayer.source), args.job..':'..args.grade,GetPlayerName(args.playerId.source)), true)
	end
end, true, {
	help = TranslateCap('command_setjob'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
		{ name = 'job',      help = TranslateCap('command_setjob_job'),      type = 'string' },
		{ name = 'grade',    help = TranslateCap('command_setjob_grade'),    type = 'number' }
	}
})

ESX.RegisterCommand('setgang', 'admin', function(xPlayer, args, showError)
	if not ESX.DoesGangExist(args.gang, args.grade) then
		return showError(TranslateCap('command_setgang_invalid'))
	end

	args.playerId.setGang(args.gang, args.grade)
	
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Set Gang /setgang Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,       inline = true },
			{ name = "ID",     value = xPlayer.source,     inline = true },
			{ name = "Target", value = args.playerId.name, inline = true },
			{ name = "Gang",    value = args.playerId,      inline = true },
			{ name = "Grade",  value = args.playerId,      inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'setgang', 'Setgang', 'green', string.format('%s set gang %s to %s', GetPlayerName(xPlayer.source), args.gang..':'..args.grade,GetPlayerName(args.playerId.source)), true)
	end
end, true, {
	help = TranslateCap('command_setgang'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
		{ name = 'gang',      help = TranslateCap('command_setgang_gang'),      type = 'string' },
		{ name = 'grade',    help = TranslateCap('command_setgang_grade'),    type = 'number' }
	}
})

local upgrades = Config.SpawnVehMaxUpgrades and
	{
		plate = "ADMINCAR",
		modEngine = 3,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modArmor = true,
		windowTint = 1
	} or {}

ESX.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	if not xPlayer then
		return showError('[^1ERROR^7] The xPlayer value is nil')
	end

	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local playerHeading = GetEntityHeading(playerPed)
	local playerVehicle = GetVehiclePedIsIn(playerPed)

	if not args.car or type(args.car) ~= 'string' then
		args.car = 't20'
	end

	if playerVehicle then
		DeleteEntity(playerVehicle)
	end

	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Spawn Car /car Triggered!", "pink", {
			{ name = "Player",  value = xPlayer.name,   inline = true },
			{ name = "ID",      value = xPlayer.source, inline = true },
			{ name = "Vehicle", value = args.car,       inline = true }
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'car', 'Spawn Car', 'yellow', string.format('%s spawned %s', GetPlayerName(xPlayer.source), args.car), true)
	end

	ESX.OneSync.SpawnVehicle(args.car, playerCoords, playerHeading, upgrades, function(networkId)
		if networkId then
			local vehicle = NetworkGetEntityFromNetworkId(networkId)
			for _ = 1, 20 do
				Wait(0)
				SetPedIntoVehicle(playerPed, vehicle, -1)

				if GetVehiclePedIsIn(playerPed, false) == vehicle then
					break
				end
			end
			TriggerClientEvent('keys:giveTemporaryKeys:admin', xPlayer.source, networkId)
			if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
				showError('[^1ERROR^7] The player could not be seated in the vehicle')
			end
		end
	end)
end, false, {
	help = TranslateCap('command_car'),
	validate = false,
	arguments = {
		{ name = 'car', validate = false, help = TranslateCap('command_car_car'), type = 'string' }
	}
})

ESX.RegisterCommand({ 'cardel', 'dv' }, 'admin', function(xPlayer, args)
	local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
	if DoesEntityExist(PedVehicle) then
		DeleteEntity(PedVehicle)
	end
	local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(xPlayer.source)),
		tonumber(args.radius) or 5.0)
	for i = 1, #Vehicles do
		local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
		if DoesEntityExist(Vehicle) then
			DeleteEntity(Vehicle)
		end
	end
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Delete Vehicle /dv Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,   inline = true },
			{ name = "ID",     value = xPlayer.source, inline = true },
		})
	end
end, false, {
	help = TranslateCap('command_cardel'),
	validate = false,
	arguments = {
		{ name = 'radius', validate = false, help = TranslateCap('command_cardel_radius'), type = 'any' }
	}
})

ESX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(TranslateCap('command_giveaccountmoney_invalid'))
	end
	args.playerId.setAccountMoney(args.account, args.amount, "Government Grant")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Set Account Money /setaccountmoney Triggered!", "pink", {
			{ name = "Player",  value = xPlayer.name,       inline = true },
			{ name = "ID",      value = xPlayer.source,     inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Account", value = args.account,       inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'setaccountmoney', 'Set Account Money', 'red', string.format('%s set moeny $%s of %s', GetPlayerName(xPlayer.source), args.amount, GetPlayerName(args.playerId.source)), true)
	end
end, true, {
	help = TranslateCap('command_setaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),          type = 'player' },
		{ name = 'account',  help = TranslateCap('command_giveaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = TranslateCap('command_setaccountmoney_amount'),   type = 'number' }
	}
})

ESX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(TranslateCap('command_giveaccountmoney_invalid'))
	end
	args.playerId.addAccountMoney(args.account, args.amount, "Government Grant")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Give Account Money /giveaccountmoney Triggered!", "pink", {
			{ name = "Player",  value = xPlayer.name,       inline = true },
			{ name = "ID",      value = xPlayer.source,     inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Account", value = args.account,       inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'giveaccountmoney', 'Give Account Money', 'red', string.format('%s give moeny $%s to %s', GetPlayerName(xPlayer.source), args.amount, GetPlayerName(args.playerId.source)), true)
	end
end, true, {
	help = TranslateCap('command_giveaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),          type = 'player' },
		{ name = 'account',  help = TranslateCap('command_giveaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = TranslateCap('command_giveaccountmoney_amount'),  type = 'number' }
	}
})

ESX.RegisterCommand('removeaccountmoney', 'admin', function(xPlayer, args, showError)
	if not args.playerId.getAccount(args.account) then
		return showError(TranslateCap('command_removeaccountmoney_invalid'))
	end
	args.playerId.removeAccountMoney(args.account, args.amount, "Government Tax")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Remove Account Money /removeaccountmoney Triggered!", "pink", {
			{ name = "Player",  value = xPlayer.name,       inline = true },
			{ name = "ID",      value = xPlayer.source,     inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Account", value = args.account,       inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_removeaccountmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),            type = 'player' },
		{ name = 'account',  help = TranslateCap('command_removeaccountmoney_account'), type = 'string' },
		{ name = 'amount',   help = TranslateCap('command_removeaccountmoney_amount'),  type = 'number' }
	}
})

if Config.SaltyInventory then
	ESX.RegisterCommand('openinventory', "superadmin", function(xPlayer, args, showError)
		TriggerEvent('inventory:server:opensvInventory', xPlayer.source, "otherplayer", args.playerId.source)
	end, true, {help = 'Open other player\'s inventory', validate = true, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
	}})

	ESX.RegisterCommand('clearinventory', 'moderator', function(xPlayer, args, showError)
		local xTarget
		if args and args.playerId and tonumber(args.playerId) then
			xTarget = ESX.GetPlayerFromId(args.playerId)
	
			if not xTarget then
				showError("The player is not online.")
				return
			end
		else
			xTarget = xPlayer
		end
		xTarget.clearInventory()
		TriggerEvent('esx:sendLog', 'admin', { color = 32768, title = 'Clear Inventory Logs', message = '**'..xPlayer.name..'('..xPlayer.source..' - ' .. xPlayer.identifier .. ')** Cleared Inventory of **'..xTarget.name..'('..xTarget.source..' - ' .. xTarget.identifier ..') **'})
	end, true, {help = _U('command_clearinventory'), validate = false, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'string'}
	}})
	
	ESX.RegisterCommand('cleartrunk', "admin", function(xPlayer, args, showError)
		TriggerEvent('inventory:clear', "trunk", args.trunk)
		TriggerEvent('esx:sendLog', "admin", {color = 32768, title = "Clear Logs", message = "**"..xPlayer.name.. ' ('..xPlayer.source.. " - "..xPlayer.identifier..') cleared trunk inventory with plate'..args.trunk})
	end, true, {help = "Clear Trunk Inventoty", validate = true, arguments = {
		{ name = "trunk", help = "Trunk Plate", type = "string"}
	}})
	
	ESX.RegisterCommand('clearglovebox', "admin", function(xPlayer, args, showError)
		TriggerEvent('inventory:clear', "glovebox", args.glovebox)
		TriggerEvent('esx:sendLog', "admin", {color = 32768, title = "Clear Logs", message = "**"..xPlayer.name.. ' ('..xPlayer.source.. " - "..xPlayer.identifier..') cleared glovebox inventory with plate'..args.glovebox})
	end, true, {help = "Clear Glovebox Inventoty", validate = true, arguments = {
		{ name = "glovebox", help = "Glovebox Plate", type = "string"}
	}})

	ESX.RegisterCommand('giveitem', 'admin', function(Player, args, showError)
		if not args.playerId then
			return
		end
		if not args.item then
			return
		end
		if not args.amount then
			return
		end
		if not args.ammo then
			args.ammo = 0
		end
		args.ammo = tonumber(args.ammo)
		local amount = args.amount
		local itemData = ESX.Shared.Items[tostring(args.item):lower()]
		if args.playerId then
			if amount > 0 then
				if itemData then
					local info = ESX.SetupItemInfo(itemData.name, args.ammo, args.playerId.identifier)
					if args.playerId.canCarryItem(itemData['name'], amount) then
						args.playerId.addInventoryItem(itemData["name"], amount, false, info)
						Player.showNotification("You gave "..args.playerId.source.." - "..GetPlayerName(args.playerId.source).." x"..amount.." of "..itemData.label)
						TriggerClientEvent('inventory:client:ItemBox', args.playerId.source, itemData, 'add', amount)
						TriggerEvent('esx:sendLog', 'admin', { color = 32768, title = 'Spawn Item Logs', message = "**"..GetPlayerName(Player.source)..' ('..Player.source..') - '..Player.identifier..' spawned item to player \n Name: **'..itemData.name..'**\n Amount: **$'..amount..'** \n Player Affected: **'..GetPlayerName(args.playerId.source)..' ('..args.playerId.source..') - '..args.playerId.identifier..'**'})
					else
						Player.showNotification("Player cannot carry this item", "error", 2500)
					end
				else
					Player.showNotification("This item does not exist", "error", 2500)
				end
			else
				Player.showNotification("Invalid amount", "error", 2500)
			end
		else
			Player.showNotification("Player not online", "error", 2500)
		end
	end, true, { help = _U('command_giveitem'), validate = false, arguments = {
		{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
		{name = 'amount', help = _U('command_giveitem_count'), type = 'number'},
		{name = 'ammo', help = 'Ammo', type = 'any'},
	}})
end

if not Config.OxInventory and not Config.SaltyInventory then
	ESX.RegisterCommand('giveitem', 'admin', function(xPlayer, args)
		args.playerId.addInventoryItem(args.item, args.count)
		if Config.AdminLogging then
			ESX.DiscordLogFields("UserActions", "Give Item /giveitem Triggered!", "pink", {
				{ name = "Player",   value = xPlayer.name,       inline = true },
				{ name = "ID",       value = xPlayer.source,     inline = true },
				{ name = "Target",   value = args.playerId.name, inline = true },
				{ name = "Item",     value = args.item,          inline = true },
				{ name = "Quantity", value = args.count,         inline = true },
			})
		else
			TriggerEvent('admin-log:server:CreateLog', 'giveitem', 'Give Item', 'red', string.format('%s give $%s to %s', GetPlayerName(xPlayer.source), args.count..'x '..args.item, GetPlayerName(args.playerId.source)), true)
		end
	end, true, {
		help = TranslateCap('command_giveitem'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
			{ name = 'item',     help = TranslateCap('command_giveitem_item'),   type = 'item' },
			{ name = 'count',    help = TranslateCap('command_giveitem_count'),  type = 'number' }
		}
	})

	ESX.RegisterCommand('giveweapon', 'admin', function(xPlayer, args, showError)
		if args.playerId.hasWeapon(args.weapon) then
			return showError(TranslateCap('command_giveweapon_hasalready'))
		end
		args.playerId.addWeapon(args.weapon:upper(), args.ammo)
		if Config.AdminLogging then
			ESX.DiscordLogFields("UserActions", "Give Weapon /giveweapon Triggered!", "pink", {
				{ name = "Player", value = xPlayer.name,       inline = true },
				{ name = "ID",     value = xPlayer.source,     inline = true },
				{ name = "Target", value = args.playerId.name, inline = true },
				{ name = "Weapon", value = args.weapon,        inline = true },
				{ name = "Ammo",   value = args.ammo,          inline = true },
			})
		end
	end, true, {
		help = TranslateCap('command_giveweapon'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),   type = 'player' },
			{ name = 'weapon',   help = TranslateCap('command_giveweapon_weapon'), type = 'weapon' },
			{ name = 'ammo',     help = TranslateCap('command_giveweapon_ammo'),   type = 'number' }
		}
	})

	--[[
	ESX.RegisterCommand('giveammo', 'admin', function(xPlayer, args, showError)
		if not args.playerId.hasWeapon(args.weapon) then
			return showError(TranslateCap("command_giveammo_noweapon_found"))
		end
		args.playerId.addWeaponAmmo(args.weapon, args.ammo)
		if Config.AdminLogging then
			ESX.DiscordLogFields("UserActions", "Give Ammunition /giveammo Triggered!", "pink", {
				{ name = "Player", value = xPlayer.name,       inline = true },
				{ name = "ID",     value = xPlayer.source,     inline = true },
				{ name = "Target", value = args.playerId.name, inline = true },
				{ name = "Weapon", value = args.weapon,        inline = true },
				{ name = "Ammo",   value = args.ammo,          inline = true },
			})
		end
	end, true, {
		help = TranslateCap('command_giveweapon'),
		validate = false,
		arguments = {
			{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
			{ name = 'weapon',   help = TranslateCap('command_giveammo_weapon'), type = 'weapon' },
			{ name = 'ammo',     help = TranslateCap('command_giveammo_ammo'),   type = 'number' }
		}
	})

	ESX.RegisterCommand('giveweaponcomponent', 'admin', function(xPlayer, args, showError)
		if args.playerId.hasWeapon(args.weaponName) then
			local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

			if component then
				if args.playerId.hasWeaponComponent(args.weaponName, args.componentName) then
					showError(TranslateCap('command_giveweaponcomponent_hasalready'))
				else
					args.playerId.addWeaponComponent(args.weaponName, args.componentName)
					if Config.AdminLogging then
						ESX.DiscordLogFields("UserActions", "Give Weapon Component /giveweaponcomponent Triggered!",
							"pink", {
								{ name = "Player",    value = xPlayer.name,       inline = true },
								{ name = "ID",        value = xPlayer.source,     inline = true },
								{ name = "Target",    value = args.playerId.name, inline = true },
								{ name = "Weapon",    value = args.weaponName,    inline = true },
								{ name = "Component", value = args.componentName, inline = true },
							})
					end
				end
			else
				showError(TranslateCap('command_giveweaponcomponent_invalid'))
			end
		else
			showError(TranslateCap('command_giveweaponcomponent_missingweapon'))
		end
	end, true, {
		help = TranslateCap('command_giveweaponcomponent'),
		validate = true,
		arguments = {
			{ name = 'playerId',      help = TranslateCap('commandgeneric_playerid'),               type = 'player' },
			{ name = 'weaponName',    help = TranslateCap('command_giveweapon_weapon'),             type = 'weapon' },
			{ name = 'componentName', help = TranslateCap('command_giveweaponcomponent_component'), type = 'string' }
		}
	})
	]]
end

ESX.RegisterCommand({ 'clear', 'cls' }, 'user', function(xPlayer)
	xPlayer.triggerEvent('chat:clear')
end, false, { help = TranslateCap('command_clear') })

ESX.RegisterCommand({ 'clearall', 'clsall' }, 'admin', function(xPlayer)
	TriggerClientEvent('chat:clear', -1)
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Clear Chat /clearall Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,   inline = true },
			{ name = "ID",     value = xPlayer.source, inline = true },
		})
	end
end, true, { help = TranslateCap('command_clearall') })

ESX.RegisterCommand("refreshjobs", 'admin', function()
	ESX.RefreshJobs()
end, true, { help = TranslateCap('command_clearall') })

if not Config.OxInventory and not Config.SaltyInventory then
	ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args)
		for _, v in ipairs(args.playerId.inventory) do
			if v.count > 0 then
				args.playerId.setInventoryItem(v.name, 0)
			end
		end
		TriggerEvent('esx:playerInventoryCleared', args.playerId)
		if Config.AdminLogging then
			ESX.DiscordLogFields("UserActions", "Clear Inventory /clearinventory Triggered!", "pink", {
				{ name = "Player", value = xPlayer.name,       inline = true },
				{ name = "ID",     value = xPlayer.source,     inline = true },
				{ name = "Target", value = args.playerId.name, inline = true },
			})
		else
			TriggerEvent('admin-log:server:CreateLog', 'clearinventory', 'Clear Inventory', 'red', string.format('%s cleared inventory of $%s', GetPlayerName(xPlayer.source), GetPlayerName(args.playerId.source)), true)
		end
	end, true, {
		help = TranslateCap('command_clearinventory'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
		}
	})

	ESX.RegisterCommand('clearloadout', 'admin', function(xPlayer, args)
		for i = #args.playerId.loadout, 1, -1 do
			args.playerId.removeWeapon(args.playerId.loadout[i].name)
		end
		TriggerEvent('esx:playerLoadoutCleared', args.playerId)
		if Config.AdminLogging then
			ESX.DiscordLogFields("UserActions", "/clearloadout Triggered!", "pink", {
				{ name = "Player", value = xPlayer.name,       inline = true },
				{ name = "ID",     value = xPlayer.source,     inline = true },
				{ name = "Target", value = args.playerId.name, inline = true },
			})
		else
			TriggerEvent('admin-log:server:CreateLog', 'clearloadout', 'Clear Loadout', 'red', string.format('%s cleared loadout of $%s', GetPlayerName(xPlayer.source), GetPlayerName(args.playerId.source)), true)
		end
	end, true, {
		help = TranslateCap('command_clearloadout'),
		validate = true,
		arguments = {
			{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
		}
	})
end

ESX.RegisterCommand('setgroup', 'superadmin', function(xPlayer, args, showError)
	if not args.playerId then args.playerId = xPlayer.source end
	ExecuteCommand(('remove_principal identifier.%s group.%s'):format(ESX.GetIdentifier(args.playerId.source), args.playerId.getGroup()))
	args.playerId.setGroup(args.group)
	ExecuteCommand(('add_principal identifier.%s group.%s'):format(ESX.GetIdentifier(args.playerId.source), args.group))
	args.playerId.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Your group is now '..args.group}})
	if xPlayer then
		TriggerEvent('admin-log:server:CreateLog', 'setgroup', 'Set Group', 'red', string.format('%s set group %s of $%s', GetPlayerName(xPlayer.source), args.group, GetPlayerName(args.playerId.source)), true)
	end
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', 'admin', function(_, args)
	Core.SavePlayer(args.playerId)
	print(('[^2Info^0] Saved Player - ^5%s^0'):format(args.playerId.source))
end, true, {
	help = TranslateCap('command_save'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('saveall', 'admin', function()
	Core.SavePlayers()
end, true, { help = TranslateCap('command_saveall') })

ESX.RegisterCommand('group', { "user", "admin" }, function(xPlayer, _, _)
	print(('%s, you are currently: ^5%s^0'):format(xPlayer.getName(), xPlayer.getGroup()))
end, true)

ESX.RegisterCommand('job', { "user", "admin" }, function(xPlayer, _, _)
	print(('%s, your job is: ^5%s^0 - ^5%s^0'):format(xPlayer.getName(), xPlayer.getJob().name,
		xPlayer.getJob().grade_label))
end, true)

ESX.RegisterCommand('info', { "user", "admin" }, function(xPlayer)
	local job = xPlayer.getJob().name
	local jobgrade = xPlayer.getJob().grade_name
	print(('^2ID: ^5%s^0 | ^2Name: ^5%s^0 | ^2Group: ^5%s^0 | ^2Job: ^5%s^0'):format(xPlayer.source, xPlayer.getName(),
		xPlayer.getGroup(), job))
end, true)

ESX.RegisterCommand('coords', "admin", function(xPlayer)
	local ped = GetPlayerPed(xPlayer.source)
	local coords = GetEntityCoords(ped, false)
	local heading = GetEntityHeading(ped)
	print(('Coords - Vector3: ^5%s^0'):format(vector3(coords.x, coords.y, coords.z)))
	print(('Coords - Vector4: ^5%s^0'):format(vector4(coords.x, coords.y, coords.z, heading)))
end, true)

ESX.RegisterCommand('tpm', "admin", function(xPlayer)
	xPlayer.triggerEvent("esx:tpm")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin Teleport /tpm Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,   inline = true },
			{ name = "ID",     value = xPlayer.source, inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'tpm', 'Teleport', 'red', string.format('%s used tpm', GetPlayerName(xPlayer.source)), true)
	end
end, true)

ESX.RegisterCommand('goto', "admin", function(xPlayer, args)
	local targetCoords = args.playerId.getCoords()
	xPlayer.setCoords(targetCoords)
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin Teleport /goto Triggered!", "pink", {
			{ name = "Player",        value = xPlayer.name,       inline = true },
			{ name = "ID",            value = xPlayer.source,     inline = true },
			{ name = "Target",        value = args.playerId.name, inline = true },
			{ name = "Target Coords", value = targetCoords,       inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'goto', 'Player Goto', 'green', string.format('%s go to %s', GetPlayerName(xPlayer.source), GetPlayerName(args.playerId.source)), true)
	end
end, true, {
	help = TranslateCap('command_goto'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('bring', "admin", function(xPlayer, args)
	local targetCoords = args.playerId.getCoords()
	local playerCoords = xPlayer.getCoords()
	args.playerId.setCoords(playerCoords)
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin Teleport /bring Triggered!", "pink", {
			{ name = "Player",        value = xPlayer.name,       inline = true },
			{ name = "ID",            value = xPlayer.source,     inline = true },
			{ name = "Target",        value = args.playerId.name, inline = true },
			{ name = "Target Coords", value = targetCoords,       inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'bring', 'Bring', 'green', string.format('%s bringed by %s', GetPlayerName(args.playerId.source), GetPlayerName(xPlayer.source)), true)
	end
end, true, {
	help = TranslateCap('command_bring'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})


ESX.RegisterCommand('kill', "admin", function(xPlayer, args)
	args.playerId.triggerEvent("esx:killPlayer")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Kill Command /kill Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,       inline = true },
			{ name = "ID",     value = xPlayer.source,     inline = true },
			{ name = "Target", value = args.playerId.name, inline = true },
		})
	else
		TriggerEvent('admin-log:server:CreateLog', 'kill', 'kill', 'red', string.format('%s was killed by %s', GetPlayerName(args.playerId.source), GetPlayerName(xPlayer.source)), true)
	end
end, true, {
	help = TranslateCap('command_kill'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})
--[[
ESX.RegisterCommand('freeze', "admin", function(xPlayer, args)
	args.playerId.triggerEvent('esx:freezePlayer', "freeze")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin Freeze /freeze Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,       inline = true },
			{ name = "ID",     value = xPlayer.source,     inline = true },
			{ name = "Target", value = args.playerId.name, inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_freeze'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand('unfreeze', "admin", function(xPlayer, args)
	args.playerId.triggerEvent('esx:freezePlayer', "unfreeze")
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin UnFreeze /unfreeze Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,       inline = true },
			{ name = "ID",     value = xPlayer.source,     inline = true },
			{ name = "Target", value = args.playerId.name, inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_unfreeze'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})

ESX.RegisterCommand("noclip", 'admin', function(xPlayer)
	xPlayer.triggerEvent('esx:noclip')
	if Config.AdminLogging then
		ESX.DiscordLogFields("UserActions", "Admin NoClip /noclip Triggered!", "pink", {
			{ name = "Player", value = xPlayer.name,   inline = true },
			{ name = "ID",     value = xPlayer.source, inline = true },
		})
	end
end, false)
]]

ESX.RegisterCommand('reviveall', 'superadmin', function(xPlayer, args, showError)
	for _, playerId in ipairs(GetPlayers()) do
		TriggerClientEvent('esx_ambulancejob:revive', playerId)
	end
	TriggerEvent('admin-log:server:CreateLog', 'revive', 'Revive', 'green', string.format('%s used revive all', GetPlayerName(xPlayer.source)), true)
end, false)

ESX.RegisterCommand('players', "admin", function()
	local xPlayers = ESX.GetExtendedPlayers() -- Returns all xPlayers
	print(('^5%s^2 online player(s)^0'):format(#xPlayers))
	for i = 1, #(xPlayers) do
		local xPlayer = xPlayers[i]
		print(('^1[^2ID: ^5%s^0 | ^2Name : ^5%s^0 | ^2Group : ^5%s^0 | ^2Identifier : ^5%s^1]^0\n'):format(
			xPlayer.source, xPlayer.getName(), xPlayer.getGroup(), xPlayer.identifier))
	end
end, true)

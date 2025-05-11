function ESX.Trace(msg)
	if Config.EnableDebug then
		print(('[^2TRACE^7] %s^7'):format(msg))
	end
end

function ESX.IsPlayerDown(id)
	return Player(id).state.down
end

function ESX.IsPlayerDead(id)
	return Player(id).state.dead
end

ESX.ForEachPlayer = function(cb_player, cb_end)
	if not cb_player then
		print("No cb fun received for ESX.ForEachPlayer.")
		return
	end
	for k, v in pairs (ESX.Players) do
		if k and v and v.name then
			cb_player(k, v)
		end
	end
	if cb_end then
		cb_end()
	end
end

function ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for _, v in ipairs(name) do
			ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if Core.RegisteredCommands[name] then
		print(('[^3WARNING^7] Command ^5"%s" ^7already registered, overriding command'):format(name))

		if Core.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then
			suggestion.arguments = {}
		end
		if not suggestion.help then
			suggestion.help = ''
		end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	Core.RegisteredCommands[name] = { group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion }

	RegisterCommand(name, function(playerId, args)
		local command = Core.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[^3WARNING^7] ^5%s'):format(TranslateCap('commanderror_console')))
		else
			local xPlayer, error = ESX.Players[playerId], nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = TranslateCap('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k, v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = TranslateCap('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' or not args[k] then
									targetPlayer = playerId
								end

								if targetPlayer then
									local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = TranslateCap('commanderror_invalidplayerid')
									end
								else
									error = TranslateCap('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								local newArg = tonumber(args[k])
								if not newArg then
									newArgs[v.name] = args[k]
								else
									error = TranslateCap('commanderror_argumentmismatch_string', k)
								end
							elseif v.type == 'item' then
								if ESX.Items[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = TranslateCap('commanderror_invaliditem')
								end
							elseif v.type == 'weapon' then
								if ESX.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								else
									error = TranslateCap('commanderror_invalidweapon')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							elseif v.type == 'merge' then
								local lenght = 0
								for i = 1, k - 1 do
									lenght = lenght + string.len(args[i]) + 1
								end
								local merge = table.concat(args, " ")

								newArgs[v.name] = string.sub(merge, lenght)
							end
						end

						--backwards compatibility
						if not v.validate and not v.type then
							error = nil
						end

						if error then
							break
						end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
					print(('[^3WARNING^7] %s^7'):format(error))
				else
					xPlayer.showNotification(error)
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
						print(('[^3WARNING^7] %s^7'):format(msg))
					else
						xPlayer.showNotification(msg)
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for _, v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

ESX.SetupItemInfo = function(item, ammo, identifier)
	local info = {}
	local itemData = ESX.Shared.Items[item:lower()]
	if itemData.type == "weapon" and itemData.name ~= "weapon_megaphone" then
		amount = 1
		info.serie = tostring(ESX.Shared.RandomInt(2) .. ESX.Shared.RandomStr(3) .. ESX.Shared.RandomInt(1) .. ESX.Shared.RandomStr(2) .. ESX.Shared.RandomInt(3) .. ESX.Shared.RandomStr(4))
		info.quality = 100.0
		if ammo and ammo > 0 then
			info.ammo = tonumber(ammo)
		end
	elseif itemData.name == "pizzabox" then
		info.items = {}
	elseif itemData.name == "lighter" then
		info.uses = 50
	elseif itemData.name == "zippo" then
		info.uses = 100
	elseif itemData.name == "harness" then
		info.uses = 20
	elseif itemData.name == "nitrous" then
		info.value = 100
	elseif itemData.name == "scale" then
		info.uses = 5
	elseif itemData.name == "micro_forceps" then
		info.uses = 5
	elseif itemData.name == "screwdriverset" then
		info.uses = 5
	elseif itemData.name == "fakeplate" then
		info.plate = exports.esx_internals:GeneratePlateSV()
		info.health = 100
	elseif itemData.name == "forestfruitsliquid" or itemData.name == "energydrinkliquid" or itemData.name == "cheesecakeliquid" or itemData.name == "watermelonliquid" or itemData.name == "strawberryliquid" or itemData.name == "bubblegumliquid" or itemData.name == "blueberryliquid" or itemData.name == "caramelaliquid" or itemData.name == "cinnamonliquid" or itemData.name == "vanillaliquid" or itemData.name == "biscuitliquid" or itemData.name == "coffeeliquid" or itemData.name == "bananaliquid" or itemData.name == "lemonliquid" or itemData.name == "honeyliquid" or itemData.name == "mintliquid" then
		info.shots = 100
	elseif itemData.name == "polaroid" then
		info.quality = 100
	elseif itemData.name == "cigarettepack" then
		info.cigarettes = 20
	elseif itemData.name == "slimcigarettepack" then
		info.cigarettes = 20
	elseif itemData.name == "cubancigarettepack" then
		info.cigarettes = 20
	elseif itemData.name == "bigscissors" then
		info.uses = 5
	elseif itemData.name == "labkey" then
		info.lab = exports.drugs:GenerateLab(identifier)
	elseif itemData.itemtype == "clubbottle" then
		info.uses = 10
	elseif itemData.itemtype == "expiring" then
		info.time = os.time()
		info.quality = 100
	end
	return info
end

ESX.SaveInventory = function(xPlayer)
    if not ESX.Players[xPlayer.source] then return end
    local items = xPlayer.inventory
    local ItemsJson = {}
    if items and next(items) then
        for slot, item in pairs(items) do
            if items[slot] then
                ItemsJson[#ItemsJson+1] = {
                    name = item.name,
                    amount = item.amount,
                    info = item.info,
                    slot = slot,
                }
            end
        end
        MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
            ['@inventory'] = json.encode(ItemsJson),
            ['@identifier'] = xPlayer.identifier
        })
    else
        MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
            ['@inventory'] = '[]',
            ['@identifier'] = xPlayer.identifier
        })
    end
end

function Core.SavePlayer(xPlayer, cb)
	if Config.SaltyInventory then
		local parameters <const> = {
			json.encode(xPlayer.getAccounts(true)),
			xPlayer.job.name,
			xPlayer.job.grade,
			xPlayer.gang.name,
			xPlayer.gang.grade,
			xPlayer.group,
			json.encode(xPlayer.coords),
			json.encode(xPlayer.metadata),
			xPlayer.identifier
		}
		ESX.SaveInventory(xPlayer)
		MySQL.prepare('UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `gang` = ?, `gang_grade` = ?, `group` = ?, `position` = ?, `metadata` = ? WHERE `identifier` = ?', parameters,function(affectedRows)
			if affectedRows == 1 then
				print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
				TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
			end
			if cb then
				cb()
			end
		end)
	else
		local parameters <const> = {
			json.encode(xPlayer.getAccounts(true)),
			xPlayer.job.name,
			xPlayer.job.grade,
			xPlayer.gang.name,
			xPlayer.gang.grade,
			xPlayer.group,
			json.encode(xPlayer.coords),
			json.encode(xPlayer.getInventory(true)),
			json.encode(xPlayer.getLoadout(true)),
			json.encode(xPlayer.metadata),
			xPlayer.identifier
		}
		MySQL.prepare(
			'UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `gang` = ?, `gang_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?',
			parameters,
			function(affectedRows)
				if affectedRows == 1 then
					print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
					TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
				end
				if cb then
					cb()
				end
			end
		)
	end
end

function Core.SavePlayers(cb)
	local xPlayers <const> = ESX.Players
	if not next(xPlayers) then
		return
	end
	local startTime <const> = os.time()
	local parameters = {}
	local isSaltyInventory = false
	if Config.SaltyInventory then
		isSaltyInventory = true
	end
	for _, xPlayer in pairs(ESX.Players) do
		if isSaltyInventory then
			ESX.SaveInventory(xPlayer)
			parameters[#parameters + 1] = {
				json.encode(xPlayer.getAccounts(true)),
				xPlayer.job.name,
				xPlayer.job.grade,
				xPlayer.gang.name,
				xPlayer.gang.grade,
				xPlayer.group,
				json.encode(xPlayer.coords),
				json.encode(xPlayer.getMeta()),
				xPlayer.identifier
			}
		else
			parameters[#parameters + 1] = {
				json.encode(xPlayer.getAccounts(true)),
				xPlayer.job.name,
				xPlayer.job.grade,
				xPlayer.gang.name,
				xPlayer.gang.grade,
				xPlayer.group,
				json.encode(xPlayer.coords),
				json.encode(xPlayer.getInventory(true)),
				json.encode(xPlayer.getLoadout(true)),
				json.encode(xPlayer.getMeta()),
				xPlayer.identifier
			}
		end
	end
	local sqlText = "UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `gang` = ?, `gang_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?"
	if isSaltyInventory then
		sqlText = "UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `gang` = ?, `gang_grade` = ?, `group` = ?, `position` = ?, `metadata` = ? WHERE `identifier` = ?"
	end
	MySQL.prepare(sqlText, parameters, function(results)
		if not results then
			return
		end
		if type(cb) == 'function' then
			return cb()
		end
		print(('[^2INFO^7] Saved ^5%s^7 %s over ^5%s^7 ms'):format(#parameters, #parameters > 1 and 'players' or 'player', ESX.Math.Round((os.time() - startTime) / 1000000, 2)))
	end)
end

ESX.GetPlayers = function()
    local sources = {}
    for k, v in pairs(ESX.Players) do
        table.insert(sources, k)
    end
    return sources
end

local function checkTable(key, val, player, xPlayers)
	for valIndex = 1, #val do
		local value = val[valIndex]
		if not xPlayers[value] then
			xPlayers[value] = {}
		end
		if ((key == 'job' and player.job.name == value) or (key == "gang" and player.gang.name == value)) or player[key] == value then
			xPlayers[value][#xPlayers[value] + 1] = player
		end
	end
end

function ESX.GetExtendedPlayers(key, val)
	if not key then return ESX.Players end

	local xPlayers = {}
	if type(val) == "table" then
		for _, v in pairs(ESX.Players) do
			checkTable(key, val, v, xPlayers)
		end
	else
		for _, v in pairs(ESX.Players) do
			if ((key == 'job' and v.job.name == val) or (key == "gang" and v.gang.name == val)) or v[key] == val then
				xPlayers[#xPlayers + 1] = v
			end
		end
	end

	return xPlayers
end

function ESX.GetPlayerFromId(source)
	return ESX.Players[tonumber(source)]
end

function ESX.GetPlayerFromIdentifier(identifier)
	return Core.playersByIdentifier[identifier]
end

function ESX.GetIdentifier(playerId)
	local fxDk = GetConvarInt('sv_fxdkMode', 0)
	if fxDk == 1 then
		return "ESX-DEBUG-LICENCE"
	end
	for _, v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			return v
		end
	end
end

---@param model string|number
---@param player number playerId
---@param cb function

function ESX.GetVehicleType(model, player, cb)
	model = type(model) == 'string' and joaat(model) or model

	if Core.vehicleTypesByModel[model] then
		return cb(Core.vehicleTypesByModel[model])
	end

	ESX.TriggerClientCallback(player, "esx:GetVehicleType", function(vehicleType)
		Core.vehicleTypesByModel[model] = vehicleType
		cb(vehicleType)
	end, model)
end

function ESX.DiscordLog(name, title, color, message)
	local webHook = Config.DiscordLogs.Webhooks[name] or Config.DiscordLogs.Webhooks.default
	local embedData = { {
		['title'] = title,
		['color'] = Config.DiscordLogs.Colors[color] or Config.DiscordLogs.Colors.default,
		['footer'] = {
			['text'] = "| ESX Logs | " .. os.date(),
			['icon_url'] = "https://cdn.discordapp.com/attachments/944789399852417096/1020099828266586193/blanc-800x800.png"
		},
		['description'] = message,
		['author'] = {
			['name'] = "ESX Framework",
			['icon_url'] = "https://cdn.discordapp.com/emojis/939245183621558362.webp?size=128&quality=lossless"
		}
	} }
	PerformHttpRequest(webHook, nil, 'POST', json.encode({
		username = 'Logs',
		embeds = embedData
	}), {
		['Content-Type'] = 'application/json'
	})
end

function ESX.DiscordLogFields(name, title, color, fields)
	local webHook = Config.DiscordLogs.Webhooks[name] or Config.DiscordLogs.Webhooks.default
	local embedData = { {
		['title'] = title,
		['color'] = Config.DiscordLogs.Colors[color] or Config.DiscordLogs.Colors.default,
		['footer'] = {
			['text'] = "| ESX Logs | " .. os.date(),
			['icon_url'] = "https://cdn.discordapp.com/attachments/944789399852417096/1020099828266586193/blanc-800x800.png"
		},
		['fields'] = fields,
		['description'] = "",
		['author'] = {
			['name'] = "ESX Framework",
			['icon_url'] = "https://cdn.discordapp.com/emojis/939245183621558362.webp?size=128&quality=lossless"
		}
	} }
	PerformHttpRequest(webHook, nil, 'POST', json.encode({
		username = 'Logs',
		embeds = embedData
	}), {
		['Content-Type'] = 'application/json'
	})
end

function ESX.CreateGang(name, label, grades)
	if not name then
		return print('[^3WARNING^7] missing argument `name(string)` while creating a gang')
	end

	if not label then
		return print('[^3WARNING^7] missing argument `label(string)` while creating a gang')
	end

	if not grades or not next(grades) then
		return print('[^3WARNING^7] missing argument `grades(table)` while creating a gang!')
	end

	for _, v in pairs(grades) do
		gang.grades[tostring(v.grade)] = { gang_name = name, grade = v.grade, name = v.name, label = v.label, salary = v.salary, skin_male = {}, skin_female = {} }
		parameters[#parameters + 1] = { name, v.grade, v.name, v.label, v.salary }
	end

	MySQL.insert('INSERT IGNORE INTO gangs (name, label) VALUES (?, ?)', { name, label })
	MySQL.prepare('INSERT INTO gang_grades (gang_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', parameters)

	ESX.Gangs[name] = gang
end

--- Create Job at Runtime
--- @param name string
--- @param label string
--- @param grades table
function ESX.CreateJob(name, label, grades)
	if not name then
		return print('[^3WARNING^7] missing argument `name(string)` while creating a job')
	end

	if not label then
		return print('[^3WARNING^7] missing argument `label(string)` while creating a job')
	end

	if not grades or not next(grades) then
		return print('[^3WARNING^7] missing argument `grades(table)` while creating a job!')
	end

	local parameters = {}
	local job = { name = name, label = label, grades = {} }

	for _, v in pairs(grades) do
		job.grades[tostring(v.grade)] = { job_name = name, grade = v.grade, name = v.name, label = v.label, salary = v.salary, skin_male = {}, skin_female = {} }
		parameters[#parameters + 1] = { name, v.grade, v.name, v.label, v.salary }
	end

	MySQL.insert('INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)', { name, label })
	MySQL.prepare('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', parameters)

	ESX.Jobs[name] = job
end

function ESX.RefreshWhitelist()
	local Whitelist = {}
	local wl = MySQL.query.await("SELECT * FROM whitelist")
	for i=1,#wl do
		Whitelist[wl[i].identifier] = true
	end
	Core.Whitelist = Whitelist
end

function ESX.RefreshGangs()
	local Gangs = {}
	local gangs = MySQL.query.await('SELECT * FROM gangs')

	for _, v in ipairs(gangs) do
		Gangs[v.name] = v
		Gangs[v.name].grades = {}
	end

	local gangGrades = MySQL.query.await('SELECT * FROM gang_grades')

	for _, v in ipairs(gangGrades) do
		if Gangs[v.gang_name] then
			Gangs[v.gang_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring gang grades for ^5"%s"^0 due to missing gang'):format(v.gang_name))
		end
	end

	for _, v in pairs(Gangs) do
		if ESX.Table.SizeOf(v.grades) == 0 then
			Gangs[v.name] = nil
			print(('[^3WARNING^7] Ignoring gang ^5"%s"^0 due to no gang grades found'):format(v.name))
		end
	end

	if not Gangs then
		-- Fallback data, if no Gangs exist
		ESX.Gangs['nogang'] = { label = 'No Criminal', grades = { ['0'] = { grade = 0, label = 'No Criminal' } } }
	else
		ESX.Gangs = Gangs
	end
end

function ESX.RefreshJobPlayers()
	Core.jobPlayers = {}
	local players = GetPlayers()
	for k,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer then
			Core.AddPlayerToJobList(xPlayer)
		end
	end
end

function ESX.RefreshJobs()
	local Jobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if ESX.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0 due to no job grades found'):format(v.name))
		end
	end

	if not Jobs then
		-- Fallback data, if no jobs exist
		ESX.Jobs['unemployed'] = { label = 'Unemployed', grades = { ['0'] = { grade = 0, label = 'Unemployed', salary = 200, skin_male = {}, skin_female = {} } } }
	else
		ESX.Jobs = Jobs
	end
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.CanUseItem = function(item)
    return ESX.UsableItemsCallbacks[item] ~= nil
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item.name](source, item)
end

function ESX.RegisterPlayerFunctionOverrides(index, overrides)
	Core.PlayerFunctionOverrides[index] = overrides
end

function ESX.SetPlayerFunctionOverride(index)
	if not index or not Core.PlayerFunctionOverrides[index] then
		return print('[^3WARNING^7] No valid index provided.')
	end

	Config.PlayerFunctionOverride = index
end

function ESX.GetItemLabel(item)
	if Config.OxInventory then
		item = exports.ox_inventory:Items(item)
		if item then
			return item.label
		end
	elseif Config.SaltyInventory then
		item = ESX.Shared.Items[item]
		if item then
			return item.label
		end
	end

	if ESX.Items[item] then
		return ESX.Items[item].label
	else
		print(('[^3WARNING^7] Attemting to get invalid Item -> ^5%s^7'):format(item))
	end
end

function ESX.GetJobs()
	return ESX.Jobs
end

function ESX.GetGangs()
	return ESX.Gangs
end

function ESX.GetUsableItems()
	local Usables = {}
	for k in pairs(ESX.UsableItemsCallbacks) do
		Usables[k] = true
	end
	return Usables
end

if not Config.OxInventory and not Config.SaltyInventory then
	function ESX.CreatePickup(type, name, count, label, playerId, components, tintIndex)
		local pickupId = (Core.PickupId == 65635 and 0 or Core.PickupId + 1)
		local xPlayer = ESX.Players[playerId]
		local coords = xPlayer.getCoords()

		Core.Pickups[pickupId] = { type = type, name = name, count = count, label = label, coords = coords }

		if type == 'item_weapon' then
			Core.Pickups[pickupId].components = components
			Core.Pickups[pickupId].tintIndex = tintIndex
		end

		TriggerClientEvent('esx:createPickup', -1, pickupId, label, coords, type, name, components, tintIndex)
		Core.PickupId = pickupId
	end
end

function ESX.DoesJobExist(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

function ESX.DoesGangExist(gang, grade)
	grade = tostring(grade)

	if gang and grade then
		if ESX.Gangs[gang] and ESX.Gangs[gang].grades[grade] then
			return true
		end
	end

	return false
end

function ESX.GetOnlinePlayersFromJob(jobname, type)
	if not type then type = "amount" end
	if type == "amount" then
		return Core.jobPlayers[jobname]?.amount or 0
	elseif type == "list" then
		return Core.jobPlayers[jobname]?.players or {}
	end
end

function Core.IsPlayerAdmin(playerId)
	if (IsPlayerAceAllowed(playerId, 'command') or GetConvar('sv_lan', '') == 'true') and true or false then
		return true
	end

	local xPlayer = ESX.Players[playerId]

	if xPlayer then
		if Config.AdminGroups[xPlayer.group] then
			return true
		end
	end

	return false
end

function Core.AddPlayerToJobList(xPlayer)
	if xPlayer then
		if xPlayer.job.name then
			if Core.jobPlayers[xPlayer.job.name] then
				Core.jobPlayers[xPlayer.job.name].amount = Core.jobPlayers[xPlayer.job.name].amount + 1
				table.insert(Core.jobPlayers[xPlayer.job.name].players, xPlayer.source)
			else
				Core.jobPlayers[xPlayer.job.name] = {
					amount = 1,
					players = { xPlayer.source }
				}
			end
		end
	end
end

function Core.RemovePlayerFromJobList(xPlayer, lastJob)
	if xPlayer then
		local job = xPlayer.job.name
		if lastJob and lastJob.name then
			job = lastJob.name
		end
		if Core.jobPlayers[job] then
			Core.jobPlayers[job].amount = Core.jobPlayers[job].amount - 1
			for i=1,#Core.jobPlayers[job].players do
				if Core.jobPlayers[job].players[i] == xPlayer.source then
					table.remove(Core.jobPlayers[job].players, i)
					break
				end
			end
		end
	end
end
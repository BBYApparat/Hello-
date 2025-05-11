local GetPlayerPed = GetPlayerPed
local GetEntityCoords = GetEntityCoords

if Config.SaltyInventory then
	function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, gang, name, coords, metadata, user_licenses)
		local targetOverrides = Config.PlayerFunctionOverride and Core.PlayerFunctionOverrides[Config.PlayerFunctionOverride] or {}
	
		local self = {}
	
		self.accounts = accounts
		self.coords = coords
		self.group = group
		self.identifier = identifier
		self.inventory = inventory
		self.job = job
		self.gang = gang
		self.name = name
		self.playerId = playerId
		self.source = playerId
		self.variables = {}
		self.weight = weight
		self.maxWeight = Config.MaxWeight
		self.metadata = metadata
		self.user_licenses = user_licenses
		self.steam = ESX.GetIdentifier(self.source)
	
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.steam, self.group))
	
		local stateBag = Player(self.source).state
		stateBag:set("identifier", self.identifier, true)
		stateBag:set("license", self.license, true)
		stateBag:set("job", self.job, true)
		stateBag:set("gang", self.gang, true)
		stateBag:set("group", self.group, true)
		stateBag:set("name", self.name, true)
		stateBag:set("metadata", self.metadata, true)
	
		function self.triggerEvent(eventName, ...)
			TriggerClientEvent(eventName, self.source, ...)
		end
	
		function self.setCoords(coordinates)
			local Ped = GetPlayerPed(self.source)
			local vector = type(coordinates) == "vector4" and coordinates or type(coordinates) == "vector3" and vector4(coordinates, 0.0) or vec(coordinates.x, coordinates.y, coordinates.z, coordinates.heading or 0.0)
			SetEntityCoords(Ped, vector.xyz, false, false, false, false)
			SetEntityHeading(Ped, vector.w)
		end
	
		function self.getCoords(vector)
			local ped = GetPlayerPed(self.source)
			local coordinates = GetEntityCoords(ped)
	
			if vector then
				return coordinates
			else
				return {
					x = coordinates.x,
					y = coordinates.y,
					z = coordinates.z,
				}
			end
		end
	
		self.updateCoords = function(coords)
			SetTimeout(1000,function()
				local Ped = GetPlayerPed(self.source)
				if DoesEntityExist(Ped) then
					local coords = GetEntityCoords(Ped)
					local distance = #(coords - vector3(self.coords.x, self.coords.y, self.coords.z))
					if distance > 1.5 then
						local heading = GetEntityHeading(Ped)
						self.coords = {
							x = coords.x,
							y = coords.y, 
							z = coords.z, 
							heading = heading or 0.0
						}
					end
				end
				self.updateCoords()
			end)
		end
	
		function self.kick(reason)
			DropPlayer(self.source, reason)
		end
	
		function self.setMoney(money)
			money = ESX.Math.Round(money)
			self.setAccountMoney('money', money)
		end
	
		function self.getMoney()
			return self.getAccount('money').money
		end
	
		function self.addMoney(money, reason)
			money = ESX.Math.Round(money)
			self.addAccountMoney('money', money, reason)
		end
	
		function self.removeMoney(money, reason)
			money = ESX.Math.Round(money)
			self.removeAccountMoney('money', money, reason)
		end
	
		function self.getIdentifier()
			return self.identifier
		end
	
		function self.setGroup(newGroup)
			ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.steam, self.group))
			self.group = newGroup
			Player(self.source).state:set("group", self.group, true)
			ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.steam, self.group))
		end
	
		function self.getGroup()
			return self.group
		end
	
		function self.set(k, v)
			self.variables[k] = v
			Player(self.source).state:set(k, v, true)
		end
	
		function self.get(k)
			return self.variables[k]
		end
	
		function self.getAccounts(minimal)
			if not minimal then
				return self.accounts
			end
	
			local minimalAccounts = {}
	
			for i = 1, #self.accounts do
				minimalAccounts[self.accounts[i].name] = self.accounts[i].money
			end
	
			return minimalAccounts
		end
	
		function self.getAccount(account)
			for i = 1, #self.accounts do
				if self.accounts[i].name == account then
					return self.accounts[i]
				end
			end
			return nil
		end
	
		function self.getJob()
			return self.job
		end

		function self.getGang()
			return self.gang
		end
	
		function self.getName()
			return self.name
		end
	
		function self.setName(newName)
			self.name = newName
			Player(self.source).state:set("name", self.name, true)
		end
	
		function self.setAccountMoney(accountName, money, reason)
			reason = reason or 'unknown'
			if not tonumber(money) then
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
				return
			end
			if money >= 0 then
				local account = self.getAccount(accountName)
	
				if account then
					money = account.round and ESX.Math.Round(money) or money
					self.accounts[account.index].money = money
	
					self.triggerEvent('esx:setAccountMoney', account)
					TriggerEvent('esx:setAccountMoney', self.source, accountName, money, reason)
				else
					print(('[^1ERROR^7] Tried To Set Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
				end
			else
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
			end
		end
	
		function self.addAccountMoney(accountName, money, reason)
			reason = reason or 'Unknown'
			if not tonumber(money) then
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
				return
			end
			if money > 0 then
				local account = self.getAccount(accountName)
				if account then
					money = account.round and ESX.Math.Round(money) or money
					self.accounts[account.index].money = self.accounts[account.index].money + money
	
					self.triggerEvent('esx:setAccountMoney', account)
					TriggerEvent('esx:addAccountMoney', self.source, accountName, money, reason)
				else
					print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
				end
			else
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
			end
		end
	
		function self.removeAccountMoney(accountName, money, reason)
			reason = reason or 'Unknown'
			if not tonumber(money) then
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
				return
			end
			if money > 0 then
				local account = self.getAccount(accountName)
	
				if account then
					money = account.round and ESX.Math.Round(money) or money
					self.accounts[account.index].money = self.accounts[account.index].money - money
	
					self.triggerEvent('esx:setAccountMoney', account)
					TriggerEvent('esx:removeAccountMoney', self.source, accountName, money, reason)
				else
					print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
				end
			else
				print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
			end
		end
		
		self.getUserLicenses = function()
			return self.user_licenses
		end
		
		self.getCountUserLicenses = function()
			return #self.user_licenses
		end

		self.hasLicense = function(name)
			local licenses = self.user_licenses
			for i=1,#licenses do
				if tostring(licenses[i]) == tostring(name) then
					return true
				end
			end
			return false
		end
	
		self.addUserLicense = function(name)
			if not self.hasLicense(name) then
				table.insert(self.user_licenses, tostring(name))
			end
		end
	
		self.setUserLicenses = function(all)
			self.user_licenses = all
		end
	
		self.removeUserLicense = function(b)
			if self.hasLicense(b) then
				table.remove(self.user_licenses, getIndex(self.user_licenses, tostring(b)) )
			end
		end

		function self.getWeight()
			return self.weight
		end
	
		function self.getMaxWeight()
			return self.maxWeight
		end
	
		function self.setMaxWeight(newWeight)
			self.maxWeight = newWeight
			self.triggerEvent('esx:setMaxWeight', self.maxWeight)
		end
	
		function self.setJob(newJob, grade)
			grade = tostring(grade)
			local lastJob = json.decode(json.encode(self.job))
		
			if ESX.DoesJobExist(newJob, grade) then
				local jobObject, gradeObject = ESX.Jobs[newJob], ESX.Jobs[newJob].grades[grade]
		
				self.job.id                  = jobObject.id
				self.job.name                = jobObject.name
				self.job.label               = jobObject.label
		
				self.job.grade               = tonumber(grade)
				self.job.grade_name          = gradeObject.name
				self.job.grade_label         = gradeObject.label
				self.job.grade_salary        = gradeObject.salary
		
				if gradeObject.skin_male then
					self.job.skin_male = json.decode(gradeObject.skin_male)
				else
					self.job.skin_male = {}
				end
		
				if gradeObject.skin_female then
					self.job.skin_female = json.decode(gradeObject.skin_female)
				else
					self.job.skin_female = {}
				end
		
				-- Update the users table with the new job and grade
				MySQL.update('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
					['@job'] = newJob,
					['@job_grade'] = grade,
					['@identifier'] = self.identifier
				}, function(rowsChanged)
					if rowsChanged > 0 then
						print(('Successfully updated job for player %s to %s (grade %s)'):format(self.source, newJob, grade))
					else
						print(('Failed to update job for player %s to %s (grade %s)'):format(self.source, newJob, grade))
					end
				end)
		
				TriggerEvent('esx:setJob', self.source, self.job, lastJob)
				self.triggerEvent('esx:setJob', self.job, lastJob)
				Player(self.source).state:set("job", self.job, true)
			else
				print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, newJob))
			end
		end

		function self.setGang(newGang, grade)
			grade = tostring(grade)
			local lastGang = json.decode(json.encode(self.gang))
		
			if ESX.DoesGangExist(newGang, grade) then
				local gangObject, gradeObject = ESX.Gangs[newGang], ESX.Gangs[newGang].grades[grade]
		
				self.gang.id                  = gangObject.id
				self.gang.name                = gangObject.name
				self.gang.label               = gangObject.label
		
				self.gang.grade               = tonumber(grade)
				self.gang.grade_name          = gradeObject.name
				self.gang.grade_label         = gradeObject.label

				-- Update the users table with the new gang and grade
				MySQL.update('UPDATE users SET gang = @gang, gang_grade = @gang_grade WHERE identifier = @identifier', {
					['@gang'] = newGang,
					['@gang_grade'] = grade,
					['@identifier'] = self.identifier
				}, function(rowsChanged)
					if rowsChanged > 0 then
						print(('Successfully updated gang for player %s to %s (grade %s)'):format(self.source, newGang, grade))
					else
						print(('Failed to update gang for player %s to %s (grade %s)'):format(self.source, newGang, grade))
					end
				end)
		
				TriggerEvent('esx:setGang', self.source, self.gang, lastGang)
				self.triggerEvent('esx:setGang', self.gang, lastGang)
				Player(self.source).state:set("gang", self.gang, true)
			else
				print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setGang()^7 usage for ID: ^5%s^7, Gang: ^5%s^7'):format(self.source, newGang))
			end
		end
	
		function self.showNotification(msg, type, length)
			self.triggerEvent('esx:showNotification', msg, type, length)
		end
	
		function self.showAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
			self.triggerEvent('esx:showAdvancedNotification', sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
		end
	
		function self.showHelpNotification(msg, thisFrame, beep, duration)
			self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
		end
	
		function self.getMeta(index, subIndex)
			if not (index) then return self.metadata end
	
			if type(index) ~= "string" then
				return print("[^1ERROR^7] xPlayer.getMeta ^5index^7 should be ^5string^7!")
			end
	
			local metaData = self.metadata[index]
			if (metaData == nil) then
				return Config.EnableDebug and print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not exist!"):format(index)) or nil
			end
	
			if (subIndex and type(metaData) == "table") then
				local _type = type(subIndex)
	
				if (_type == "string") then
					local value = metaData[subIndex]
					return value
				end
	
				if (_type == "table") then
					local returnValues = {}
	
					for i = 1, #subIndex do
						local key = subIndex[i]
						if (type(key) == "string") then
							returnValues[key] = self.getMeta(index, key)
						else
							print(("[^1ERROR^7] xPlayer.getMeta subIndex should be ^5string^7 or ^5table^7! that contains ^5string^7, received ^5%s^7!, skipping..."):format(type(key)))
						end
					end
	
					return returnValues
				end
	
				return print(("[^1ERROR^7] xPlayer.getMeta subIndex should be ^5string^7 or ^5table^7!, received ^5%s^7!"):format(_type))
			end
	
			return metaData
		end
	
		function self.setMeta(index, value, subValue)
			if not index then
				return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 is Missing!")
			end
	
			if type(index) ~= "string" then
				return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 should be ^5string^7!")
			end
	
			if not value then
				return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 is Missing!"):format(value))
			end
	
			local _type = type(value)
	
			if not subValue then
				if _type ~= "number" and _type ~= "string" and _type ~= "table" then
					return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7!"):format(value))
				end
	
				self.metadata[index] = value
			else
				if _type ~= "string" then
					return print(("[^1ERROR^7] xPlayer.setMeta ^5value^7 should be ^5string^7 as a subIndex!"):format(value))
				end
	
				self.metadata[index][value] = subValue
			end
	
	
			self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
			Player(self.source).state:set('metadata', self.metadata, true)
		end
	
		function self.clearMeta(index)
			if not index then
				return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 is Missing!"):format(index))
			end
	
			if type(index) == 'table' then
				for _, val in pairs(index) do
					self.clearMeta(val)
				end
	
				return
			end
	
			if not self.metadata[index] then
				return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 not exist!"):format(index))
			end
	
			self.metadata[index] = nil
			self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
			Player(self.source).state:set('metadata', self.metadata, true)
		end
		
		self.updatePlayerInventory = function()
			self.triggerEvent('esx:setInventory', self.inventory)
		end
	
		self.updateWeaponAmmo = function(slot, ammo, add)
			if self.inventory[slot] then
				if not self.inventory[slot].info then
					self.inventory[slot].info = {}
				end
				if type(self.inventory[slot].info) == "string" then
					self.inventory[slot].info = {}
				end
				if add then
					self.inventory[slot].info.ammo = self.inventory[slot].info.ammo + ammo
				else
					self.inventory[slot].info.ammo = ammo
				end
			end
			self.triggerEvent('esx:setWeaponAmmo', slot, ammo)
		end
	
		self.updateInventory = function(_data)
			self.inventory = _data
			self.updatePlayerInventory()
		end
	
		self.clearInventory = function()
			self.inventory = {}
			self.updatePlayerInventory()
			self.triggerEvent('inventory:client:removeWeapons')
		end
	
		self.GetTotalWeight = function(inventory)
			local weight = 0
			if not inventory then inventory = self.inventory end
			for _, item in pairs(inventory) do
				local it = ESX.Shared.Items[item.name]
				weight = weight + (it.weight * item.amount)
			end
			return tonumber(weight)
		end
	
		self.GetFirstSlotByItem = function(itemName)
			local items = self.inventory
			for slot, item in pairs(items) do
				if item.name:lower() == itemName:lower() then
					return tonumber(slot)
				end
			end
			return nil
		end
	
		self.GetItemByName = function(item)
			item = tostring(item):lower()
			local slot = self.GetFirstSlotByItem(item)
			return self.inventory[slot]
		end
	
		self.GetFirstSlotByNonRottenItem = function(itemName)
			local items = self.inventory
			for slot, item in pairs(items) do
				if item.name:lower() == itemName:lower() and item.info and item.info.quality and item.info.quality > 0 then
					return tonumber(slot)
				end
			end
			return nil
		end
	
		self.GetNonRottenItemByName = function(item)
			item = tostring(item):lower()
			local slot = self.GetFirstSlotByNonRottenItem(item)
			return self.inventory[slot]
		end
	
		self.GetItemsByName = function(item)
			item = tostring(item):lower()
			local items = {}
			local slots = self.GetSlotsByItem(item)
			for _, slot in pairs(slots) do
				if slot then
					items[#items+1] = self.inventory[slot]
				end
			end
			return items
		end
	
		self.GetNonRottenItemsByName = function(item)
			item = tostring(item):lower()
			local items = {}
			local slots = self.GetSlotsByItem(item)
			for _, slot in pairs(slots) do
				if slot then
					if self.inventory[slot] and self.inventory[slot].info and self.inventory[slot].info.quality and self.inventory[slot].info.quality > 0 then
						items[#items+1] = self.inventory[slot]
					end
				end
			end
			return items
		end
	
		self.GetTotalItemAmount = function(item)
			item = tostring(item):lower()
			local temp_item = self.GetItemsByName(item)
			local temp_amount = 0
			if temp_item and #temp_item > 0 then
				for i=1,#temp_item do
					temp_amount = temp_amount + temp_item[i].amount
				end
			end
			return temp_amount
		end
	
		self.GetTotalNonRottenItemAmount = function(item)
			item = tostring(item):lower()
			local temp_item = self.GetItemsByName(item)
			local temp_amount = 0
			if temp_item and #temp_item > 0 then
				for i=1,#temp_item do
					if temp_item[i] and temp_item[i].info and temp_item[i].info.quality and temp_item[i].info.quality > 0 then
						temp_amount = temp_amount + temp_item[i].amount
					end
				end
			end
			return temp_amount
		end
	
		self.GetItemBySlot = function(slot)
			slot = tonumber(slot)
			return self.inventory[slot]
		end
	
		self.GetSlotsByItem = function(itemName)
			local slotsFound = {}
			if not self.inventory then
				return slotsFound
			end
			for slot, item in pairs(self.inventory) do
				if item.name:lower() == itemName:lower() then
					slotsFound[#slotsFound+1] = slot
				end
			end
			return slotsFound
		end
	
		self.updateItemData = function(slot, data)
			if self.inventory[slot] then
				self.inventory[slot].info = data
				self.triggerEvent('esx:updateItemInfo', slot, data)
			end
		end
	
		self.addInventoryItem = function(item, amount, slot, info)
			local totalWeight = self.GetTotalWeight(self.inventory)
			local itemInfo = ESX.Shared.Items[item:lower()]
			if not itemInfo then
				self.showNotification('This item does not exist')
				return
			end
			amount = tonumber(amount)
			slot = tonumber(slot) or self.GetFirstSlotByItem(item)
			if itemInfo.type == 'weapon' and not info then
				info = {
					serie = tostring(ESX.Shared.RandomInt(2) .. ESX.Shared.RandomStr(3) .. ESX.Shared.RandomInt(1) .. ESX.Shared.RandomStr(2) .. ESX.Shared.RandomInt(3) .. ESX.Shared.RandomStr(4)),
				}
			end
			if (totalWeight + (itemInfo.weight * amount)) <= ESX.Config.MaxWeight then
				if (slot and self.inventory[slot]) and (self.inventory[slot].name:lower() == item:lower()) and (itemInfo.type == 'item' and not itemInfo.unique and itemInfo.itemtype ~= "expiring") then
					self.inventory[slot].amount = self.inventory[slot].amount + amount
					self.updatePlayerInventory()
					TriggerEvent('esx:onAddInventoryItem', self.source, itemInfo.name, amount)
					return true
				elseif not itemInfo.unique and slot or slot and self.inventory[slot] == nil then
					self.inventory[slot] = {
						name = itemInfo.name,
						amount = amount,
						info = info or '',
						slot = slot
					}
					self.updatePlayerInventory()
					TriggerEvent('esx:onAddInventoryItem', self.source, itemInfo.name, amount)
					return true
				elseif itemInfo.unique or (not slot or slot == nil) or (itemInfo.type == 'weapon' or (itemInfo.itemtype and itemInfo.itemtype == "expiring")) then
					for i = 1, ESX.Config.MaxInvSlots, 1 do
						if self.inventory[i] == nil then
							self.inventory[i] = {
								name = itemInfo.name,
								amount = amount,
								info = info or '',
								slot = i
							}
							self.updatePlayerInventory()
							TriggerEvent('esx:onAddInventoryItem', self.source, itemInfo.name, amount)
							return true
						end
					end
				end
			else
				self.showNotification('This item is too heavy')
			end
			return false
		end
	
		self.removeInventoryItem = function(item, amount, slot)
			amount = tonumber(amount)
			slot = tonumber(slot)
			if self.hasInventoryItem(item, amount) then
				if slot then
					if self.inventory[slot].amount > amount then
						self.inventory[slot].amount = self.inventory[slot].amount - amount
						self.updatePlayerInventory()
						TriggerEvent('esx:onRemoveInventoryItem', self.source, item, amount)
					elseif self.inventory[slot].amount == amount then
						self.inventory[slot] = nil
						self.updatePlayerInventory()
						TriggerEvent('esx:onRemoveInventoryItem', self.source, item, amount)
					end
				else
					local slots = self.GetSlotsByItem(item)
					local amountToRemove = amount
					if slots then
						local temp_amount = 0
						for _, slot in pairs(slots) do
							temp_amount = temp_amount + self.inventory[slot].amount
						end
						if temp_amount >= amountToRemove then
							for _,slot in pairs(slots) do
								if self.inventory[slot].amount > amountToRemove then
									local temp_amount = self.inventory[slot].amount
									self.inventory[slot].amount = self.inventory[slot].amount - amountToRemove
									amountToRemove = amountToRemove - temp_amount
									self.updatePlayerInventory()
									TriggerEvent('esx:onRemoveInventoryItem', self.source, item, amount)
									return
								elseif self.inventory[slot].amount == amountToRemove then
									amountToRemove = amountToRemove - self.inventory[slot].amount
									self.inventory[slot] = nil
									self.updatePlayerInventory()
									TriggerEvent('esx:onRemoveInventoryItem', self.source, item, amount)
									return
								else
									if amountToRemove > 0 then
										amountToRemove = amountToRemove - self.inventory[slot].amount
										self.inventory[slot] = nil
										self.updatePlayerInventory()
										TriggerEvent('esx:onRemoveInventoryItem', self.source, item, amount)
									end
								end
							end
						end
					end
				end
			end
		end
	
		self.getInventory = function(minimal)
			if minimal then
				local minimalinv = {}
				for k,v in pairs(self.inventory) do
					if v.amount > 0 then
						minimalinv[v.name] = v.amount
					end
				end
				return minimalinv
			end
			return self.inventory
		end
	
		self.getInventoryItem = function(_name)
			local item = {
				count = 0,
				amount = 0
			}
			for k,v in ipairs(self.inventory) do
				if v and v.name then
					if v.name == _name then
						if v.amount and v.amount > 0 then
							v.count = v.amount
							return v
						end
					end
				end
			end
			return item
		end
	
		self.hasInformedItem = function(name, amount, slot, required)
			if not amount then
				amount = 1
			end
			if not required then
				required = 1
			end
			if slot then
				local item = self.GetItemBySlot(slot)
				local informations = exports.inventory:getItemInformations(item.name)
				if informations and informations.type then
					if item.info and item.info[informations.type] and item.info[informations.type] then
						if item.info[informations.type] >= required then
							if item.name == name and item.amount >= amount then
								return item
							end
						end
					end
				end
			else
				local itemAmount = self.GetTotalItemAmount(name)
				local informations = exports.inventory:getItemInformations(name)
				if informations and informations.type then
					local slots = self.GetSlotsByItem(name)
					for _, tmpslot in pairs(slots) do
						local item = self.GetItemBySlot(tmpslot)
						if item and item.info and item.info[informations.type] and item.info[informations.type] then
							if item.info[informations.type] >= required then
								if itemAmount and itemAmount >= amount then
									return item
								end
							end
						end
					end
				end
			end
			return nil
		end
	
		self.hasInventoryItem = function(_name, _amount, _slot)
			if not _amount then
				_amount = 1
			end
			if _slot then
				local item = self.GetItemBySlot(_slot)
				if item.name == _name and item.amount >= _amount then
					return item and item.amount >= _amount and item.amount - _amount >= 0
				end
				return false
			else
				local itemAmount = self.GetTotalItemAmount(_name)
				if itemAmount and itemAmount >= _amount then
					return itemAmount
				end
				return false
			end
		end
	
		self.canCarryItem = function(name, count)
			if not count then count = 1 end
			local plyweight = self.GetTotalWeight(self.inventory)
			local item = ESX.Shared.Items[name:lower()]
			if item then
				local newweight = plyweight + (item.weight * count)
				local totalWeight = ESX.Config.MaxWeight
				if newweight > totalWeight then
					return false
				else
					return true
				end
			else
				return false
			end
			return false
		end
	
		self.canSwapItems = function(toGive, toRemove)
			local plyWeight = self.GetTotalWeight(self.inventory)
			local maxWeight = ESX.Config.MaxWeight
			local toGiving = 0
			local toRemoving = 0
			for i=1,#toGive do
				local itemData = ESX.Shared.Items[toGive[i].name]
				if itemData and itemData.weight then
					toGiving = toGiving + (itemData.weight * toGive[i].amount)
				end
			end
			for i=1,#toRemove do
				local hasItem = self.hasInventoryItem(toRemove[i].name, toRemove[i].amount)
				local itemData = ESX.Shared.Items[toRemove[i].name]
				if not hasItem then
					return false
				end
				if itemData and itemData.weight then
					toRemoving = toRemoving + (itemData.weight * toRemove[i].amount)
				end
			end
			local new_weight = plyWeight - toRemoving
			local self_weight = new_weight + toGiving
			if self_weight <= maxWeight then
				return true
			end
			return false
		end
	
		self.canSwapItem = function(name1, count1, name2, count2)
			local item1 = ESX.Shared.Items[name1:lower()]
			local item2 = ESX.Shared.Items[name2:lower()]
			if not count1 or not count2 then return false end
			if not item1 and not item2 then return false end
			local hasItem = self.hasInventoryItem(name1, count1)
			if not hasItem then
				return false
			end
			local oldWeight = tonumber(item1.weight * count1)
			local newWeight = tonumber(item2.weight * count2)
			local totalplyWeight = self.GetTotalWeight(self.inventory)
			local weightitem = tonumber(totalplyWeight - oldWeight)
			local newPlyWeight = tonumber(weightitem + newWeight)
			if self.GetTotalItemAmount(name1) >= count1 then
				if newPlyWeight > ESX.Config.MaxWeight then
					return false
				else
					return true
				end
			end
			return false
		end
	
		self.ItemBox = function(item, _type, amount)
			if not amount then amount = 1 end
			if not _type then _type = "add" end
			if not ESX.Shared.Items[item] then
				print(self.source..' triggered itembox for item: '..item..' which is not existed')
				return
			end
			self.triggerEvent('inventory:client:ItemBox', ESX.Shared.Items[item], _type, amount)
		end
	

		for fnName, fn in pairs(targetOverrides) do
			self[fnName] = fn(self)
		end
	
		return self
	end
else
	-- function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, name, coords, metadata)
	-- 	local targetOverrides = Config.PlayerFunctionOverride and Core.PlayerFunctionOverrides[Config.PlayerFunctionOverride] or {}
	
	-- 	local self = {}
	
	-- 	self.accounts = accounts
	-- 	self.coords = coords
	-- 	self.group = group
	-- 	self.identifier = identifier
	-- 	self.inventory = inventory
	-- 	self.job = job
	-- 	self.loadout = loadout
	-- 	self.name = name
	-- 	self.playerId = playerId
	-- 	self.source = playerId
	-- 	self.variables = {}
	-- 	self.weight = weight
	-- 	self.maxWeight = Config.MaxWeight
	-- 	self.metadata = metadata
	-- 	self.steam = ESX.GetIdentifier(self.source)
	
	-- 	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.steam, self.group))
	
	-- 	local stateBag = Player(self.source).state
	-- 	stateBag:set("identifier", self.identifier, true)
	-- 	stateBag:set("license", self.license, true)
	-- 	stateBag:set("job", self.job, true)
	-- 	stateBag:set("group", self.group, true)
	-- 	stateBag:set("name", self.name, true)
	-- 	stateBag:set("metadata", self.metadata, true)
	
	-- 	function self.triggerEvent(eventName, ...)
	-- 		TriggerClientEvent(eventName, self.source, ...)
	-- 	end
	
	-- 	function self.setCoords(coordinates)
	-- 		local Ped = GetPlayerPed(self.source)
	-- 		local vector = type(coordinates) == "vector4" and coordinates or type(coordinates) == "vector3" and vector4(coordinates, 0.0) or
	-- 			vec(coordinates.x, coordinates.y, coordinates.z, coordinates.heading or 0.0)
	-- 		SetEntityCoords(Ped, vector.xyz, false, false, false, false)
	-- 		SetEntityHeading(Ped, vector.w)
	-- 	end
	
	-- 	function self.getCoords(vector)
	-- 		local ped = GetPlayerPed(self.source)
	-- 		local coordinates = GetEntityCoords(ped)
	
	-- 		if vector then
	-- 			return coordinates
	-- 		else
	-- 			return {
	-- 				x = coordinates.x,
	-- 				y = coordinates.y,
	-- 				z = coordinates.z,
	-- 			}
	-- 		end
	-- 	end
	
	-- 	self.updateCoords = function(coords)
	-- 		SetTimeout(1000,function()
	-- 			local Ped = GetPlayerPed(self.source)
	-- 			if DoesEntityExist(Ped) then
	-- 				local coords = GetEntityCoords(Ped)
	-- 				local distance = #(coords - vector3(self.coords.x, self.coords.y, self.coords.z))
	-- 				if distance > 1.5 then
	-- 					local heading = GetEntityHeading(Ped)
	-- 					self.coords = {
	-- 						x = coords.x,
	-- 						y = coords.y, 
	-- 						z = coords.z, 
	-- 						heading = heading or 0.0
	-- 					}
	-- 				end
	-- 			end
	-- 			self.updateCoords()
	-- 		end)
	-- 	end
	
	-- 	function self.kick(reason)
	-- 		DropPlayer(self.source, reason)
	-- 	end
	
	-- 	function self.setMoney(money)
	-- 		money = ESX.Math.Round(money)
	-- 		self.setAccountMoney('money', money)
	-- 	end
	
	-- 	function self.getMoney()
	-- 		return self.getAccount('money').money
	-- 	end
	
	-- 	function self.addMoney(money, reason)
	-- 		money = ESX.Math.Round(money)
	-- 		self.addAccountMoney('money', money, reason)
	-- 	end
	
	-- 	function self.removeMoney(money, reason)
	-- 		money = ESX.Math.Round(money)
	-- 		self.removeAccountMoney('money', money, reason)
	-- 	end
	
	-- 	function self.getIdentifier()
	-- 		return self.identifier
	-- 	end
	
	-- 	function self.setGroup(newGroup)
	-- 		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.steam, self.group))
	-- 		self.group = newGroup
	-- 		Player(self.source).state:set("group", self.group, true)
	-- 		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.steam, self.group))
	-- 	end
	
	-- 	function self.getGroup()
	-- 		return self.group
	-- 	end
	
	-- 	function self.set(k, v)
	-- 		self.variables[k] = v
	-- 		Player(self.source).state:set(k, v, true)
	-- 	end
	
	-- 	function self.get(k)
	-- 		return self.variables[k]
	-- 	end
	
	-- 	function self.getAccounts(minimal)
	-- 		if not minimal then
	-- 			return self.accounts
	-- 		end
	
	-- 		local minimalAccounts = {}
	
	-- 		for i = 1, #self.accounts do
	-- 			minimalAccounts[self.accounts[i].name] = self.accounts[i].money
	-- 		end
	
	-- 		return minimalAccounts
	-- 	end
	
	-- 	function self.getAccount(account)
	-- 		for i = 1, #self.accounts do
	-- 			if self.accounts[i].name == account then
	-- 				return self.accounts[i]
	-- 			end
	-- 		end
	-- 		return nil
	-- 	end
	
	-- 	function self.getInventory(minimal)
	-- 		if minimal then
	-- 			local minimalInventory = {}
	
	-- 			for _, v in ipairs(self.inventory) do
	-- 				if v.count > 0 then
	-- 					minimalInventory[v.name] = v.count
	-- 				end
	-- 			end
	
	-- 			return minimalInventory
	-- 		end
	
	-- 		return self.inventory
	-- 	end
	
	-- 	function self.getJob()
	-- 		return self.job
	-- 	end
	
	-- 	function self.getLoadout(minimal)
	-- 		if not minimal then
	-- 			return self.loadout
	-- 		end
	-- 		local minimalLoadout = {}
	
	-- 		for _, v in ipairs(self.loadout) do
	-- 			minimalLoadout[v.name] = { ammo = v.ammo }
	-- 			if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end
	
	-- 			if #v.components > 0 then
	-- 				local components = {}
	
	-- 				for _, component in ipairs(v.components) do
	-- 					if component ~= 'clip_default' then
	-- 						components[#components + 1] = component
	-- 					end
	-- 				end
	
	-- 				if #components > 0 then
	-- 					minimalLoadout[v.name].components = components
	-- 				end
	-- 			end
	-- 		end
	
	-- 		return minimalLoadout
	-- 	end
	
	-- 	function self.getName()
	-- 		return self.name
	-- 	end
	
	-- 	function self.setName(newName)
	-- 		self.name = newName
	-- 		Player(self.source).state:set("name", self.name, true)
	-- 	end
	
	-- 	function self.setAccountMoney(accountName, money, reason)
	-- 		reason = reason or 'unknown'
	-- 		if not tonumber(money) then
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 			return
	-- 		end
	-- 		if money >= 0 then
	-- 			local account = self.getAccount(accountName)
	
	-- 			if account then
	-- 				money = account.round and ESX.Math.Round(money) or money
	-- 				self.accounts[account.index].money = money
	
	-- 				self.triggerEvent('esx:setAccountMoney', account)
	-- 				TriggerEvent('esx:setAccountMoney', self.source, accountName, money, reason)
	-- 			else
	-- 				print(('[^1ERROR^7] Tried To Set Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
	-- 			end
	-- 		else
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 		end
	-- 	end
	
	-- 	function self.addAccountMoney(accountName, money, reason)
	-- 		reason = reason or 'Unknown'
	-- 		if not tonumber(money) then
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 			return
	-- 		end
	-- 		if money > 0 then
	-- 			local account = self.getAccount(accountName)
	-- 			if account then
	-- 				money = account.round and ESX.Math.Round(money) or money
	-- 				self.accounts[account.index].money = self.accounts[account.index].money + money
	
	-- 				self.triggerEvent('esx:setAccountMoney', account)
	-- 				TriggerEvent('esx:addAccountMoney', self.source, accountName, money, reason)
	-- 			else
	-- 				print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
	-- 			end
	-- 		else
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 		end
	-- 	end
	
	-- 	function self.removeAccountMoney(accountName, money, reason)
	-- 		reason = reason or 'Unknown'
	-- 		if not tonumber(money) then
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 			return
	-- 		end
	-- 		if money > 0 then
	-- 			local account = self.getAccount(accountName)
	
	-- 			if account then
	-- 				money = account.round and ESX.Math.Round(money) or money
	-- 				self.accounts[account.index].money = self.accounts[account.index].money - money
	
	-- 				self.triggerEvent('esx:setAccountMoney', account)
	-- 				TriggerEvent('esx:removeAccountMoney', self.source, accountName, money, reason)
	-- 			else
	-- 				print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
	-- 			end
	-- 		else
	-- 			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number -> ^5%s^7'):format(accountName, self.playerId, money))
	-- 		end
	-- 	end
	
	-- 	function self.getInventoryItem(itemName)
	-- 		return exports.ox_inventory:GetItem(self.source, itemName)
	-- 	end
	
	-- 	function self.addInventoryItem(itemName, count)
	-- 		local item = self.getInventoryItem(itemName)
	
	-- 		if item then
	-- 			count = ESX.Math.Round(count)
	-- 			item.count = item.count + count
	-- 			self.weight = self.weight + (item.weight * count)
	
	-- 			TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
	-- 			self.triggerEvent('esx:addInventoryItem', item.name, item.count)
	-- 		end
	-- 	end
	
	-- 	function self.removeInventoryItem(itemName, count)
	-- 		local item = self.getInventoryItem(itemName)
	
	-- 		if item then
	-- 			count = ESX.Math.Round(count)
	-- 			if count > 0 then
	-- 				local newCount = item.count - count
	
	-- 				if newCount >= 0 then
	-- 					item.count = newCount
	-- 					self.weight = self.weight - (item.weight * count)
	
	-- 					TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
	-- 					self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
	-- 				end
	-- 			else
	-- 				print(('[^1ERROR^7] Player ID:^5%s Tried remove a Invalid count -> %s of %s'):format(self.playerId, count, itemName))
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.setInventoryItem(itemName, count)
	-- 		local item = self.getInventoryItem(itemName)
	
	-- 		if item and count >= 0 then
	-- 			count = ESX.Math.Round(count)
	
	-- 			if count > item.count then
	-- 				self.addInventoryItem(item.name, count - item.count)
	-- 			else
	-- 				self.removeInventoryItem(item.name, item.count - count)
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.getWeight()
	-- 		return self.weight
	-- 	end
	
	-- 	function self.getMaxWeight()
	-- 		return self.maxWeight
	-- 	end
	
	-- 	function self.canCarryItem(itemName, count)
	-- 		if ESX.Items[itemName] then
	-- 			local currentWeight, itemWeight = self.weight, ESX.Items[itemName].weight
	-- 			local newWeight = currentWeight + (itemWeight * count)
	
	-- 			return newWeight <= self.maxWeight
	-- 		else
	-- 			print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(itemName))
	-- 		end
	-- 	end
	
	-- 	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
	-- 		local firstItemObject = self.getInventoryItem(firstItem)
	-- 		local testItemObject = self.getInventoryItem(testItem)
	
	-- 		if firstItemObject.count >= firstItemCount then
	-- 			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
	-- 			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))
	
	-- 			return weightWithTestItem <= self.maxWeight
	-- 		end
	
	-- 		return false
	-- 	end
	
	-- 	function self.setMaxWeight(newWeight)
	-- 		self.maxWeight = newWeight
	-- 		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	-- 	end
	
	-- 	function self.setJob(newJob, grade)
	-- 		grade = tostring(grade)
	-- 		local lastJob = json.decode(json.encode(self.job))
	
	-- 		if ESX.DoesJobExist(newJob, grade) then
	-- 			local jobObject, gradeObject = ESX.Jobs[newJob], ESX.Jobs[newJob].grades[grade]
	
	-- 			self.job.id                  = jobObject.id
	-- 			self.job.name                = jobObject.name
	-- 			self.job.label               = jobObject.label
	
	-- 			self.job.grade               = tonumber(grade)
	-- 			self.job.grade_name          = gradeObject.name
	-- 			self.job.grade_label         = gradeObject.label
	-- 			self.job.grade_salary        = gradeObject.salary
	
	-- 			if gradeObject.skin_male then
	-- 				self.job.skin_male = json.decode(gradeObject.skin_male)
	-- 			else
	-- 				self.job.skin_male = {}
	-- 			end
	
	-- 			if gradeObject.skin_female then
	-- 				self.job.skin_female = json.decode(gradeObject.skin_female)
	-- 			else
	-- 				self.job.skin_female = {}
	-- 			end
	
	-- 			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
	-- 			self.triggerEvent('esx:setJob', self.job, lastJob)
	-- 			Player(self.source).state:set("job", self.job, true)
	-- 		else
	-- 			print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, job))
	-- 		end
	-- 	end
	
	-- 	function self.addWeapon(weaponName, ammo)
	-- 		if not self.hasWeapon(weaponName) then
	-- 			local weaponLabel = ESX.GetWeaponLabel(weaponName)
	
	-- 			table.insert(self.loadout, {
	-- 				name = weaponName,
	-- 				ammo = ammo,
	-- 				label = weaponLabel,
	-- 				components = {},
	-- 				tintIndex = 0
	-- 			})
	
	-- 			GiveWeaponToPed(GetPlayerPed(self.source), joaat(weaponName), ammo, false, false)
	-- 			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
	-- 		end
	-- 	end
	
	-- 	function self.addWeaponComponent(weaponName, weaponComponent)
	-- 		local loadoutNum, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)
	
	-- 			if component then
	-- 				if not self.hasWeaponComponent(weaponName, weaponComponent) then
	-- 					self.loadout[loadoutNum].components[#self.loadout[loadoutNum].components + 1] = weaponComponent
	-- 					local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	-- 					GiveWeaponComponentToPed(GetPlayerPed(self.source), joaat(weaponName), componentHash)
	-- 					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.addWeaponAmmo(weaponName, ammoCount)
	-- 		local _, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			weapon.ammo = weapon.ammo + ammoCount
	-- 			SetPedAmmo(GetPlayerPed(self.source), joaat(weaponName), weapon.ammo)
	-- 		end
	-- 	end
	
	-- 	function self.updateWeaponAmmo(weaponName, ammoCount)
	-- 		local _, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			weapon.ammo = ammoCount
	-- 		end
	-- 	end
	
	-- 	function self.setWeaponTint(weaponName, weaponTintIndex)
	-- 		local loadoutNum, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			local _, weaponObject = ESX.GetWeapon(weaponName)
	
	-- 			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
	-- 				self.loadout[loadoutNum].tintIndex = weaponTintIndex
	-- 				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
	-- 				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.getWeaponTint(weaponName)
	-- 		local _, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			return weapon.tintIndex
	-- 		end
	
	-- 		return 0
	-- 	end
	
	-- 	function self.removeWeapon(weaponName)
	-- 		local weaponLabel, playerPed = nil, GetPlayerPed(self.source)
	
	-- 		if not playerPed then 
	-- 			return print("[^1ERROR^7] xPlayer.removeWeapon ^5invalid^7 player ped!")
	-- 		end
	
	-- 		for k, v in ipairs(self.loadout) do
	-- 			if v.name == weaponName then
	-- 				weaponLabel = v.label
	
	-- 				for _, v2 in ipairs(v.components) do
	-- 					self.removeWeaponComponent(weaponName, v2)
	-- 				end
					
	-- 				local weaponHash = joaat(v.name)
	
	-- 				RemoveWeaponFromPed(playerPed, weaponHash)
	-- 				SetPedAmmo(playerPed, weaponHash, 0)
	
	-- 				table.remove(self.loadout, k)
	-- 				break
	-- 			end
	-- 		end
	
	-- 		if weaponLabel then
	-- 			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
	-- 		end
	-- 	end
	
	-- 	function self.removeWeaponComponent(weaponName, weaponComponent)
	-- 		local loadoutNum, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)
	
	-- 			if component then
	-- 				if self.hasWeaponComponent(weaponName, weaponComponent) then
	-- 					for k, v in ipairs(self.loadout[loadoutNum].components) do
	-- 						if v == weaponComponent then
	-- 							table.remove(self.loadout[loadoutNum].components, k)
	-- 							break
	-- 						end
	-- 					end
	
	-- 					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
	-- 					self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.removeWeaponAmmo(weaponName, ammoCount)
	-- 		local _, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			weapon.ammo = weapon.ammo - ammoCount
	-- 			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
	-- 		end
	-- 	end
	
	-- 	function self.hasWeaponComponent(weaponName, weaponComponent)
	-- 		local _, weapon = self.getWeapon(weaponName)
	
	-- 		if weapon then
	-- 			for _, v in ipairs(weapon.components) do
	-- 				if v == weaponComponent then
	-- 					return true
	-- 				end
	-- 			end
	
	-- 			return false
	-- 		else
	-- 			return false
	-- 		end
	-- 	end
	
	-- 	function self.hasWeapon(weaponName)
	-- 		for _, v in ipairs(self.loadout) do
	-- 			if v.name == weaponName then
	-- 				return true
	-- 			end
	-- 		end
	
	-- 		return false
	-- 	end
	
	-- 	function self.hasItem(item)
	-- 		for _, v in ipairs(self.inventory) do
	-- 			if (v.name == item) and (v.count >= 1) then
	-- 				return v, v.count
	-- 			end
	-- 		end
	
	-- 		return false
	-- 	end
	
	-- 	function self.getWeapon(weaponName)
	-- 		for k, v in ipairs(self.loadout) do
	-- 			if v.name == weaponName then
	-- 				return k, v
	-- 			end
	-- 		end
	-- 	end
	
	-- 	function self.showNotification(msg, type, length)
	-- 		self.triggerEvent('esx:showNotification', msg, type, length)
	-- 	end
	
	-- 	function self.showAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	-- 		self.triggerEvent('esx:showAdvancedNotification', sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	-- 	end
	
	-- 	function self.showHelpNotification(msg, thisFrame, beep, duration)
	-- 		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	-- 	end
	
	-- 	function self.getMeta(index, subIndex)
	-- 		if not (index) then return self.metadata end
	
	-- 		if type(index) ~= "string" then
	-- 			return print("[^1ERROR^7] xPlayer.getMeta ^5index^7 should be ^5string^7!")
	-- 		end
	
	-- 		local metaData = self.metadata[index]
	-- 		if (metaData == nil) then
	-- 			return Config.EnableDebug and print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not exist!"):format(index)) or nil
	-- 		end
	
	-- 		if (subIndex and type(metaData) == "table") then
	-- 			local _type = type(subIndex)
	
	-- 			if (_type == "string") then
	-- 				local value = metaData[subIndex]
	-- 				return value
	-- 			end
	
	-- 			if (_type == "table") then
	-- 				local returnValues = {}
	
	-- 				for i = 1, #subIndex do
	-- 					local key = subIndex[i]
	-- 					if (type(key) == "string") then
	-- 						returnValues[key] = self.getMeta(index, key)
	-- 					else
	-- 						print(("[^1ERROR^7] xPlayer.getMeta subIndex should be ^5string^7 or ^5table^7! that contains ^5string^7, received ^5%s^7!, skipping..."):format(type(key)))
	-- 					end
	-- 				end
	
	-- 				return returnValues
	-- 			end
	
	-- 			return print(("[^1ERROR^7] xPlayer.getMeta subIndex should be ^5string^7 or ^5table^7!, received ^5%s^7!"):format(_type))
	-- 		end
	
	-- 		return metaData
	-- 	end
	
	-- 	function self.setMeta(index, value, subValue)
	-- 		if not index then
	-- 			return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 is Missing!")
	-- 		end
	
	-- 		if type(index) ~= "string" then
	-- 			return print("[^1ERROR^7] xPlayer.setMeta ^5index^7 should be ^5string^7!")
	-- 		end
	
	-- 		if not value then
	-- 			return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 is Missing!"):format(value))
	-- 		end
	
	-- 		local _type = type(value)
	
	-- 		if not subValue then
	-- 			if _type ~= "number" and _type ~= "string" and _type ~= "table" then
	-- 				return print(("[^1ERROR^7] xPlayer.setMeta ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7!"):format(value))
	-- 			end
	
	-- 			self.metadata[index] = value
	-- 		else
	-- 			if _type ~= "string" then
	-- 				return print(("[^1ERROR^7] xPlayer.setMeta ^5value^7 should be ^5string^7 as a subIndex!"):format(value))
	-- 			end
	
	-- 			self.metadata[index][value] = subValue
	-- 		end
	
	
	-- 		self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
	-- 		Player(self.source).state:set('metadata', self.metadata, true)
	-- 	end
	
	-- 	function self.clearMeta(index)
	-- 		if not index then
	-- 			return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 is Missing!"):format(index))
	-- 		end
	
	-- 		if type(index) == 'table' then
	-- 			for _, val in pairs(index) do
	-- 				self.clearMeta(val)
	-- 			end
	
	-- 			return
	-- 		end
	
	-- 		if not self.metadata[index] then
	-- 			return print(("[^1ERROR^7] xPlayer.clearMeta ^5%s^7 not exist!"):format(index))
	-- 		end
	
	-- 		self.metadata[index] = nil
	-- 		self.triggerEvent('esx:updatePlayerData', 'metadata', self.metadata)
	-- 		Player(self.source).state:set('metadata', self.metadata, true)
	-- 	end
	
	-- 	for fnName, fn in pairs(targetOverrides) do
	-- 		self[fnName] = fn(self)
	-- 	end
	
	-- 	return self
	-- end
end
if not lib then return end

local Items = require 'modules.items.shared' --[[@as table<string, OxClientItem>]]

-- Armor damage tracking system
local currentArmorVest = nil
local lastArmor = 0

local function updateArmorVestDamage()
	local currentArmor = GetPedArmour(cache.ped)
	
	if currentArmorVest and lastArmor > currentArmor then
		-- Calculate damage taken and update plate percentage
		local damageTaken = lastArmor - currentArmor
		local playerInv = exports.ox_inventory:GetPlayerItems()
		
		for k, v in pairs(playerInv) do
			if v.name == 'armour' and v.slot == currentArmorVest.slot then
				local metadata = v.metadata or {}
				local currentPlatePercentage = currentArmorVest.platePercentage or 100
				
				-- Reduce plate percentage based on damage (each point of armor = 1% plate damage)
				local newPlatePercentage = math.max(0, currentPlatePercentage - damageTaken)
				metadata.Plate = newPlatePercentage
				
				TriggerServerEvent('ox_inventory:updateMetadata', v.slot, metadata)
				
				if newPlatePercentage <= 0 then
					lib.notify({
						title = 'Armor Vest',
						description = 'Vest plates completely destroyed. Use armor plates to repair.',
						type = 'error'
					})
					currentArmorVest = nil -- Stop tracking this vest
				elseif currentArmor == 0 then
					lib.notify({
						title = 'Armor Vest',
						description = 'Armor depleted. Plate integrity: ' .. newPlatePercentage .. '%',
						type = 'warning'
					})
				end
				
				if currentArmorVest then
					currentArmorVest.platePercentage = newPlatePercentage
				end
				break
			end
		end
	end
	
	lastArmor = currentArmor
end

-- Monitor armor changes
CreateThread(function()
	while true do
		if currentArmorVest then
			updateArmorVestDamage()
		end
		Wait(1000)
	end
end)

-- Event to set current armor vest when equipped
RegisterNetEvent('armour:equipped', function(vestData)
	currentArmorVest = vestData
	lastArmor = GetPedArmour(cache.ped)
end)

-- Command to remove vest and save its current state
RegisterCommand('removevest', function()
	local currentArmor = GetPedArmour(cache.ped)
	
	if currentArmor > 0 and currentArmorVest then
		-- Update the vest's metadata with current armor percentage
		local currentPlatePercentage = currentArmor -- 1:1 ratio between armor and plate percentage
		
		local playerInv = exports.ox_inventory:GetPlayerItems()
		for k, v in pairs(playerInv) do
			if v.name == 'armour' and v.slot == currentArmorVest.slot then
				local metadata = v.metadata or {}
				metadata.Plate = currentPlatePercentage
				
				TriggerServerEvent('ox_inventory:updateMetadata', v.slot, metadata)
				break
			end
		end
		
		-- Remove armor from player
		SetPedArmour(cache.ped, 0)
		currentArmorVest = nil
		lastArmor = 0
		
		lib.notify({
			title = 'Armor Vest',
			description = 'Vest removed and saved with ' .. currentPlatePercentage .. '% plate integrity.',
			type = 'success'
		})
	elseif currentArmor > 0 then
		-- Player has armor but it's not tracked (legacy armor)
		SetPedArmour(cache.ped, 0)
		lib.notify({
			title = 'Armor Vest',
			description = 'Armor removed.',
			type = 'success'
		})
	else
		lib.notify({
			title = 'Armor Vest',
			description = 'No armor vest equipped.',
			type = 'error'
		})
	end
end, false)

local function sendDisplayMetadata(data)
    SendNUIMessage({
		action = 'displayMetadata',
		data = data
	})
end

--- use array of single key value pairs to dictate order
---@param metadata string | table<string, string> | table<string, string>[]
---@param value? string
local function displayMetadata(metadata, value)
	local data = {}

	if type(metadata) == 'string' then
        if not value then return end

        data = { { metadata = metadata, value = value } }
	elseif table.type(metadata) == 'array' then
		for i = 1, #metadata do
			for k, v in pairs(metadata[i]) do
				data[i] = {
					metadata = k,
					value = v,
				}
			end
		end
	else
		for k, v in pairs(metadata) do
			data[#data + 1] = {
				metadata = k,
				value = v,
			}
		end
	end

    if client.uiLoaded then
        return sendDisplayMetadata(data)
    end

    CreateThread(function()
        repeat Wait(100) until client.uiLoaded

        sendDisplayMetadata(data)
    end)
end

exports('displayMetadata', displayMetadata)

---@param _ table?
---@param name string?
---@return table?
local function getItem(_, name)
    if not name then return Items end

	if type(name) ~= 'string' then return end

    name = name:lower()

    if name:sub(0, 7) == 'weapon_' then
        name = name:upper()
    end

    return Items[name]
end

setmetatable(Items --[[@as table]], {
	__call = getItem
})

---@cast Items +fun(itemName: string): OxClientItem
---@cast Items +fun(): table<string, OxClientItem>

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

Item('bandage', function(data, slot)
	local maxHealth = GetEntityMaxHealth(cache.ped)
	local health = GetEntityHealth(cache.ped)
	ox_inventory:useItem(data, function(data)
		if data then
			SetEntityHealth(cache.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
			lib.notify({ description = 'You feel better already' })
		end
	end)
end)

Item('armour', function(data, slot)
	local metadata = data.metadata or {}
	local platePercentage = metadata.Plate or 100
	
	-- Only allow wearing if vest has plates
	if platePercentage > 0 and GetPedArmour(cache.ped) == 0 then
		ox_inventory:useItem(data, function(data)
			if data then
				-- Calculate armor based on plate percentage
				local armorAmount = math.floor(platePercentage)
				
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(cache.ped, armorAmount)
				
				-- Store the vest info for damage tracking
				TriggerEvent('armour:equipped', {
					slot = slot,
					platePercentage = platePercentage
				})
				
				lib.notify({
					title = 'Armor Vest',
					description = 'Vest equipped with ' .. platePercentage .. '% plate integrity (' .. armorAmount .. ' armor)',
					type = 'success'
				})
			end
		end)
	elseif platePercentage <= 0 then
		lib.notify({
			title = 'Armor Vest',
			description = 'This vest has no plates left. Use armor plates to repair it.',
			type = 'error'
		})
	elseif GetPedArmour(cache.ped) > 0 then
		lib.notify({
			title = 'Armor Vest',
			description = 'Remove your current vest first.',
			type = 'error'
		})
	end
end)

Item('armor_plates', function(data, slot)
	local playerInv = exports.ox_inventory:GetPlayerItems()
	local armorVest = nil
	local armorSlot = nil
	
	-- Find armor vest in inventory
	for k, v in pairs(playerInv) do
		if v.name == 'armour' then
			local metadata = v.metadata or {}
			local platePercentage = metadata.Plate or 100
			
			if platePercentage < 100 then
				armorVest = v
				armorSlot = v.slot
				break
			end
		end
	end
	
	if armorVest then
		ox_inventory:useItem(data, function(data)
			if data then
				-- Repair the armor vest
				local metadata = armorVest.metadata or {}
				metadata.Plate = 100
				
				TriggerServerEvent('ox_inventory:updateMetadata', armorSlot, metadata)
				
				lib.notify({
					title = 'Armor Plates',
					description = 'Vest repaired to 100% plate integrity.',
					type = 'success'
				})
			end
		end)
	else
		lib.notify({
			title = 'Armor Plates',
			description = 'No damaged armor vest found in inventory.',
			type = 'error'
		})
	end
end)

client.parachute = false
Item('parachute', function(data, slot)
	if not client.parachute then
		ox_inventory:useItem(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(cache.ped, chute, 0, true, false)
				SetPedGadget(cache.ped, chute, true)
				lib.requestModel(1269906701)
				client.parachute = {CreateParachuteBagObject(cache.ped, true, true), slot?.metadata?.type or -1}
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

Item('phone', function(data, slot)
	local success, result = pcall(function()
		return exports.npwd:isPhoneVisible()
	end)

	if success then
		exports.npwd:setPhoneVisible(not result)
	end
end)

Item('clothing', function(data, slot)
	local metadata = slot.metadata

	if not metadata.drawable then return print('Clothing is missing drawable in metadata') end
	if not metadata.texture then return print('Clothing is missing texture in metadata') end

	if metadata.prop then
		if not SetPedPreloadPropData(cache.ped, metadata.prop, metadata.drawable, metadata.texture) then
			return print('Clothing has invalid prop for this ped')
		end
	elseif metadata.component then
		if not IsPedComponentVariationValid(cache.ped, metadata.component, metadata.drawable, metadata.texture) then
			return print('Clothing has invalid component for this ped')
		end
	else
		return print('Clothing is missing prop/component id in metadata')
	end

	ox_inventory:useItem(data, function(data)
		if data then
			metadata = data.metadata

			if metadata.prop then
				local prop = GetPedPropIndex(cache.ped, metadata.prop)
				local texture = GetPedPropTextureIndex(cache.ped, metadata.prop)

				if metadata.drawable == prop and metadata.texture == texture then
					return ClearPedProp(cache.ped, metadata.prop)
				end

				-- { prop = 0, drawable = 2, texture = 1 } = grey beanie
				SetPedPropIndex(cache.ped, metadata.prop, metadata.drawable, metadata.texture, false);
			elseif metadata.component then
				local drawable = GetPedDrawableVariation(cache.ped, metadata.component)
				local texture = GetPedTextureVariation(cache.ped, metadata.component)

				if metadata.drawable == drawable and metadata.texture == texture then
					return -- item matches (setup defaults so we can strip?)
				end

				-- { component = 4, drawable = 4, texture = 1 } = jeans w/ belt
				SetPedComponentVariation(cache.ped, metadata.component, metadata.drawable, metadata.texture, 0);
			end
		end
	end)
end)

-----------------------------------------------------------------------------------------------

exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

return Items

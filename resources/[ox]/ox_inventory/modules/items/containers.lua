local containers = {}

---@class ItemContainerProperties
---@field slots number
---@field maxWeight number
---@field whitelist? table<string, true> | string[]
---@field blacklist? table<string, true> | string[]

local function arrayToSet(tbl)
	local size = #tbl
	local set = table.create(0, size)

	for i = 1, size do
		set[tbl[i]] = true
	end

	return set
end

---Registers items with itemName as containers (i.e. backpacks, wallets).
---@param itemName string
---@param properties ItemContainerProperties
---@todo Rework containers for flexibility, improved data structure; then export this method.
local function setContainerProperties(itemName, properties)
	local blacklist, whitelist = properties.blacklist, properties.whitelist

	if blacklist then
		local tableType = table.type(blacklist)

		if tableType == 'array' then
			blacklist = arrayToSet(blacklist)
		elseif tableType ~= 'hash' then
			TypeError('blacklist', 'table', type(blacklist))
		end
	end

	if whitelist then
		local tableType = table.type(whitelist)

		if tableType == 'array' then
			whitelist = arrayToSet(whitelist)
		elseif tableType ~= 'hash' then
			TypeError('whitelist', 'table', type(whitelist))
		end
	end

	containers[itemName] = {
		size = { properties.slots, properties.maxWeight },
		blacklist = blacklist,
		whitelist = whitelist,
		items = properties.items or nil, -- ADD THIS LINE HERE
	}
end


setContainerProperties('paperbag', {
	slots = 5,
	maxWeight = 1000,
	blacklist = { 'testburger' }
})

setContainerProperties('pizzabox', {
	slots = 5,
	maxWeight = 1000,
	whitelist = { 'pizza' }
})

setContainerProperties('paperbox', {
	slots = 5,
	maxWeight = 1000,
})

setContainerProperties('uwu_cafe_box', {
	slots = 5,
	maxWeight = 1000,
})

setContainerProperties('medicinebox', {
    slots = 5,
    maxWeight = 1000,
	items = {
		{ name = 'bandage',     count = 5 },
		{ name = 'firstaid',    count = 2 },
		{ name = 'painkillers', count = 3 },
	}
})

setContainerProperties('policeshopbag', {
    slots = 6,
    maxWeight = 2000,
	items = {
		{ name = 'weapon_pumpshotgun', count = 1 },
		{ name = 'ammo-rifle',         count = 2 },
		{ name = 'weapon_microsmg',    count = 1 },
		{ name = 'ammo-45',            count = 2 },
	}
})

setContainerProperties('xanax_box', {
    slots = 5,
    maxWeight = 1000,
})

return containers



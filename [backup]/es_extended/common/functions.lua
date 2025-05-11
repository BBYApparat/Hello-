local Charset = {}

for i = 48, 57 do table.insert(Charset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local weaponsByName = {}
local weaponsByHash = {}

CreateThread(function()
	for index, weapon in pairs(Config.Weapons) do
		weaponsByName[weapon.name] = index
		weaponsByHash[joaat(weapon.name)] = weapon
	end
end)

function ESX.GetRandomString(length)
	math.randomseed(GetGameTimer())

	return length > 0 and ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)] or ''
end

function ESX.GetConfig()
	return Config
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)
	for k,v in pairs(ESX.Shared.Weapons) do
		if v.name == weaponName or v.name == weaponName:lower() then
			return k, v
		end
	end
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in pairs(ESX.Shared.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

ESX.GetWeaponList = function()
	return ESX.Shared.Weapons
end

ESX.GetWeaponLabel = function(weaponName)
	for k,v in pairs(ESX.Shared.Weapons) do
		if v.name == weaponName or v.name == weaponName:lower() then
			return v.label
		end
	end
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	for k,v in pairs(Config.WeaponAttachments) do
		if k == weaponName or k == string.upper(weaponName) then
			for k2,v2 in pairs(v) do
				if v2.component == weaponComponent then
					return v2
				end
			end
		end
	end
end

function ESX.DumpTable(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for _ = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k, v in pairs(table) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			for _ = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '[' .. k .. '] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for _ = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

function ESX.Round(value, numDecimalPlaces)
	return ESX.Math.Round(value, numDecimalPlaces)
end

ESX, PlayerData = exports.es_extended:getSharedObject(), nil

function DumpTable(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

exports("DumpTable", DumpTable)

function Shuffly(tbl)
	local size = #tbl
	for i = size, 2, -1 do
		-- Get a random index between 1 and i
		local j = math.random(1, i)
		-- Swap the elements at indices i and j
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

exports("Shuffly", Shuffly)

CreateThread(function()
	PlayerData = Core.GetPlayerData()
	ManageEntities() -- entities.lua
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
    	DespawnCraftingTables()
		DespawnItemsOnBack()
	end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

AddEventHandler('esx:setPlayerData', function(key, metadata, oldMetadata)
    if key == "metadata" then
        PlayerData.metadata = metadata
    end
end)
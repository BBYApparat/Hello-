ESX = {}
ESX.Players = {}
ESX.Jobs = {}
ESX.Gangs = {}
ESX.Items = {}
ESX.Config = Config
ESX.Shared = Shared
Core = {}
ESX.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}
Core.Whitelist = {}
Core.vehicleTypesByModel = {}
Core.jobPlayers = {}

AddEventHandler("esx:getSharedObject", function(cb)
	cb(ESX)
end)

exports('getSharedObject', function()
	return ESX
end)

if GetResourceState('ox_inventory') ~= 'missing' then
	Config.OxInventory = true
	Config.PlayerFunctionOverride = 'OxInventory'
	SetConvarReplicated('inventory:framework', 'esx')
	SetConvarReplicated('inventory:weight', Config.MaxWeight * 1000)
end

local function StartDBSync()
	CreateThread(function()
		while true do
			Wait(10 * 60 * 1000)
			Core.SavePlayers()
		end
	end)
end

MySQL.ready(function()
	Core.DatabaseConnected = true
	if Config.SaltyInventory then
		ESX.Items = ESX.Shared.Items
	elseif Config.OxInventory then 
		TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
			if ref then
				ESX.Items = ref()
			end
		end)

		AddEventHandler('ox_inventory:itemList', function(items)
			ESX.Items = items
		end)

		while not next(ESX.Items) do
			Wait(0)
		end
	else
		local items = MySQL.query.await('SELECT * FROM items')
		for _, v in ipairs(items) do
			ESX.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
		end
	end
	ESX.RefreshWhitelist()
	ESX.RefreshJobs()
	ESX.RefreshGangs()
    ESX.RefreshJobPlayers()
	print(('[^2INFO^7] ESX ^5Legacy %s^0 initialized!'):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))

	StartDBSync()
	if Config.EnablePaycheck then
		StartPayCheck()
	end
end)

RegisterServerEvent('esx:clientLog', function(msg)
	if Config.EnableDebug then
		print(('[^2TRACE^7] %s^7'):format(msg))
	end
end)

RegisterNetEvent("esx:ReturnVehicleType", function(Type, Request)
	if Core.ClientCallbacks[Request] then
		Core.ClientCallbacks[Request](Type)
		Core.ClientCallbacks[Request] = nil
	end
end)

RegisterNetEvent('esx:refreshJobs', function(cb, triggerCheck)
    if triggerCheck then
        triggerCheck(true)
        return
    end
    local Jobs = {}
    MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
        for k, v in ipairs(jobs) do
            Jobs[v.name] = v
            Jobs[v.name].grades = {}
        end
        MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
            for k, v in ipairs(jobGrades) do
                if Jobs[v.job_name] then
                    Jobs[v.job_name].grades[tostring(v.grade)] = v
                end
            end
            for k2, v2 in pairs(Jobs) do
                if ESX.Table.SizeOf(v2.grades) == 0 then
                    Jobs[v2.name] = nil
                end
            end
            ESX.Jobs = Jobs
            if cb then
                cb(true)
            end
        end)
    end)
end)

RegisterNetEvent('esx:refreshGangs', function(cb, triggerCheck)
    if triggerCheck then
        triggerCheck(true)
        return
    end
    local Gangs = {}
    MySQL.Async.fetchAll('SELECT * FROM gangs', {}, function(gangs)
        for k, v in ipairs(gangs) do
            Gangs[v.name] = v
            Gangs[v.name].grades = {}
        end
        MySQL.Async.fetchAll('SELECT * FROM gang_grades', {}, function(gangGrades)
            for k, v in ipairs(gangGrades) do
                if Gangs[v.gang_name] then
                    Gangs[v.gang_name].grades[tostring(v.grade)] = v
                end
            end
            for k2, v2 in pairs(Gangs) do
                if ESX.Table.SizeOf(v2.grades) == 0 then
                    Gangs[v2.name] = nil
                end
            end
            ESX.Gangs = Gangs
            if cb then
                cb(true)
            end
        end)
    end)
end)

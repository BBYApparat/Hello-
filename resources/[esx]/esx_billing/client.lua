ESX = exports["es_extended"]:getSharedObject()
PlayerData = {}

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
end)

function MyInvoices()
	ESX.TriggerServerCallback("esx_billing:GetInvoices", function(invoices)
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'myinvoices',
			invoices = invoices,
			VAT = Config.VATPercentage
		})			
	end)
end

function SocietyInvoices(society)
	ESX.TriggerServerCallback("esx_billing:GetSocietyInvoices", function(cb, totalInvoices, totalIncome, totalUnpaid, awaitedIncome)
		if json.encode(cb) ~= '[]' then
			SetNuiFocus(true, true)
			SendNUIMessage({
				action = 'societyinvoices',
				invoices = cb,
				totalInvoices = totalInvoices,
				totalIncome = totalIncome,
				totalUnpaid = totalUnpaid,
				awaitedIncome = awaitedIncome,
				VAT = Config.VATPercentage
			})		
		else
			TriggerEvent('inventory:notification', "BILLING", "Your society doesn't have invoices.", 10000, 'info')
			SetNuiFocus(false, false)
		end
	end, society)
end

function CreateInvoice(society)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'createinvoice',
		society = society
	})
end

RegisterCommand(Config.InvoicesCommand, function()
	ExecuteCommand('e tablet2')
	local isAllowed = false
	local jobName = ""
	for k, v in pairs(Config.AllowedSocieties) do
		if v == PlayerData.job.name then
			jobName = v
			isAllowed = true
		end
	end

	if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name == "boss" and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name ~= "boss" and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = true
		})
	elseif not Config.OnlyBossCanAccessSocietyInvoices and isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = true,
			create = true
		})
	elseif not isAllowed then
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'mainmenu',
			society = false,
			create = false
		})
	end
end, false)
-- RegisterKeyMapping(Config.InvoicesCommand, 'Billing', 'keyboard', '')

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		SetNuiFocus(false, false)
		ExecuteCommand('emotecancel')
	elseif data.action == "payInvoice" then
		TriggerServerEvent("esx_billing:PayInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "cancelInvoice" then
		TriggerServerEvent("esx_billing:CancelInvoice", data.invoice_id)
		SetNuiFocus(false, false)
	elseif data.action == "createInvoice" then
		local target = tonumber(data.player_id)
		local player = GetPlayerPed(GetPlayerFromServerId(target))
		local playerDistance = #(GetEntityCoords(player) - GetEntityCoords(PlayerPedId()))

		data.target = target
		data.society = "society_"..PlayerData.job.name
		data.society_name = PlayerData.job.label

		if GetPlayerFromServerId(target) == -1 or playerDistance > 3.0 then
			TriggerEvent('inventory:notification', "BILLING", "Error sending the invoice! Not enough range!", 10000, 'error')
		else
			TriggerServerEvent("esx_billing:CreateInvoice", data)
			TriggerEvent('inventory:notification', "BILLING", "Invoice successfully sent!", 10000, 'success')
		end
		
		SetNuiFocus(false, false)
	elseif data.action == "missingInfo" then
		TriggerEvent('inventory:notification', "BILLING", "Fill in all fields before sending an invoice!", 10000, 'error')
	elseif data.action == "negativeAmount" then
		TriggerEvent('inventory:notification', "BILLING", "You need to set a positive amount!", 10000, 'error')
	elseif data.action == "mainMenuOpenMyInvoices" then
		MyInvoices()
	elseif data.action == "mainMenuOpenSocietyInvoices" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				if Config.OnlyBossCanAccessSocietyInvoices and PlayerData.job.grade_name == "boss" then
					SocietyInvoices(PlayerData.job.label)
				elseif not Config.OnlyBossCanAccessSocietyInvoices then
					SocietyInvoices(PlayerData.job.label)
				elseif Config.OnlyBossCanAccessSocietyInvoices then
					TriggerEvent('inventory:notification', "BILLING", "Only the boss can access the society invoices.", 10000, 'error')
				end
			end
		end
	elseif data.action == "mainMenuOpenCreateInvoice" then
		for k, v in pairs(Config.AllowedSocieties) do
			if v == PlayerData.job.name then
				CreateInvoice(PlayerData.job.label)
			end
		end
	end
end)
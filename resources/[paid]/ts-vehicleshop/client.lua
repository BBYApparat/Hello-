

local client = TriggerEvent
local server = TriggerServerEvent
local AEH = AddEventHandler
local RNE = RegisterNetEvent
local komanda = RegisterCommand
local callback = RegisterNUICallback
local CT = CreateThread

local Charset= {}
local NumberCharset = {}

--local OxVehicles = exports.ox_inventory:Vehicles()

local TestVehicle = nil

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local usalonu = false

ESX = exports.es_extended:getSharedObject()

CreateThread(function()
    if Shared.Blip.ShowBlip == true then
      local blip = AddBlipForCoord(Shared.Blip.BlipCoords)
      SetBlipSprite(blip, 225)
      SetBlipScale(blip, 0.6)
      SetBlipColour(blip, 18)
      SetBlipDisplay(blip, 4)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(Shared.Blip.CarDealerBlipLabel)
      EndTextCommandSetBlipName(blip)
    end

    for k, vehicle in pairs(Shared.Vehicles.cars) do
        local vehClass = GetVehicleClassFromName(joaat(vehicle.model))
        -- if OxVehicles.trunk[vehClass] then
        --     local trunk = OxVehicles.trunk[vehClass][1].."/"..(OxVehicles.trunk[vehClass][2]/1000)
        --     Shared.Vehicles.cars[k].trunk = trunk
        --     Shared.Vehicles.cars[k].brand = GetMakeNameFromVehicleModel(joaat(vehicle.model))
        -- end
        -- print(trunk)
        Shared.Vehicles.cars[k].vehicleType = Shared.Classes[vehClass]
    end
end)

CreateThread(function()
    RequestModel(Shared.Ped.pedModel)
    while not HasModelLoaded(Shared.Ped.pedModel) do
        Wait(1)
    end
    RequestAnimDict("mini@strip_club@idles@bouncer@base")
    while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
      Wait(1)
    end
    ped =  CreatePed(4, Shared.Ped.pedModel,Shared.Ped.location, 3374176, false, true)
    SetEntityHeading(ped, Shared.Ped.heading)
    FreezeEntityPosition(ped, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end)

exports['qtarget']:AddTargetModel({Shared.Ped.pedModel}, {
    options = {
        {
            event = "ts-vehicleshop:OpenShop",
            icon = Shared.QtargetOptions.icon,
            label = Shared.QtargetOptions.label,
            -- canInteract = 
        },
},
    distance = 1.5
})

RegisterNetEvent("sendNotificationCustom")
AddEventHandler("sendNotificationCustom", function(text)
    Notification(text)
end)

RegisterNetEvent('ts-vehicleshop:OpenShop', function()
    ESX.TriggerServerCallback('ts-vehicleshop:getStocks', function(stocks)
        local modelcina
        local stock
        for s, d in pairs(stocks) do
            modelcina = s
            stock = d
            for key, value in pairs(Shared.Vehicles.cars) do
                if value.model == modelcina then
                    Shared.Vehicles.cars[key].stanje = stock
                end
            end
        end
        SetTimecycleModifier('hud_def_blur') -- blur
        SendNUIMessage({action = "otvoriSalon", vozila = Shared.Vehicles.cars, kategorija = "ALL"})
        SetNuiFocus(true, true)
        usalonu = true
    end)
end)

RegisterNUICallback("getVozila", function(data, cb)
    cb(Shared.Vehicles.cars)
end)

callback('kupiVozilo323232', function(data, cb)
    local dataTable = data
    ESX.TriggerServerCallback('ts-vehicleshop:buyVehicleA', function(imaLi)
        if imaLi then
            Wait(500)
            -- Generate new plate
            local newPlate = GeneratePlate()
            
            -- Create default vehicle properties
            local vehicleProps = {
                model = data.model,
                plate = newPlate,
                health = {
                    body = 1000.0,
                    engine = 1000.0,
                    parts = {
                        windows = {},
                        tires = {},
                        doors = {}
                    }
                }
            }

            -- Set garage location
            local garage = 'pillboxgarage'
            
            -- Save vehicle to database with garage location
            server('ts-vehicleshop:setVehicleOwner', vehicleProps, data.photo, data.label, data.model, vehicleProps.health, poslic, garage)
            
            Notification(Shared.Translations.onBuyMessage .. " " .. dataTable.label .. ". Check pillbox garage.")
        else
            Notification('You dont have enough money!')
        end
    end, dataTable.model)
    SetNuiFocus(false, false)
    SetTimecycleModifier('default')
end)

callback("close", function(data, cb)
    SetNuiFocus(false, false)
    SetTimecycleModifier('default')
    cb("ok")
    usalonu = false
end)

AddEventHandler('onResourceStop', function()
	if (GetCurrentResourceName() ~= 'rev-autosalon') then
	    return
	end
    SetTimecycleModifier('default')
	SetNuiFocus(false, false)
end)


LoadModel = function(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(37)
	end
end

RegisterNUICallback('testvehicle', function(data)
	if IsModelInCdimage(joaat(data.model)) then
        lib.showTextUI('Loading Vehicle')
        DoScreenFadeOut(1500)
        
        TriggerServerEvent("ts-vehicleshop:startTestSession")

        Wait(1500)
        
        SetEntityCoords(PlayerPedId(), Shared.TestDrive.CarSpawnLocation, true)
        
        if not HasModelLoaded(joaat(data.model)) then
            print(data.model)
            while not HasModelLoaded(joaat(data.model)) do print(data.model) RequestModel(joaat(data.model)) Wait(0) end
        end
        
        ESX.Game.SpawnLocalVehicle(data.model, Shared.TestDrive.CarSpawnLocation, 64.0, function(myVehicle)
            TestVehicle = myVehicle
            Wait(1500)
            lib.hideTextUI()
            exports.wasabi_carlock:GiveKey(ESX.Math.Trim(GetVehicleNumberPlateText(myVehicle)))
            TaskWarpPedIntoVehicle(PlayerPedId(), myVehicle, -1)
            DoScreenFadeIn(1500)
            
            lib.showTextUI('Press [X] to stop test driving.')
            
            if lib.progressCircle({
                duration = Shared.TestDrive.Timer*1000,
                label = "Test Driving",
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = false,
                },
            }) then
                EndSession()
            else
                EndSession()
            end
        end)
		-- TriggerServerEvent('ts-vehicleshop:checkTestSession', 'car', GetEntityCoords(PlayerPedId()), data.model)
	else
		ESX.ShowNotification(Shared.Translations.assetProblemMessage)
	end
end)

function EndSession()
    DoScreenFadeOut(1500)
    Wait(500)
    FreezeEntityPosition(TestVehicle, true)
    ESX.Game.DeleteVehicle(TestVehicle)
    lib.showTextUI('Moving back')
    Wait(1500)
    SetEntityCoords(PlayerPedId(), vec(Shared.TestDrive.AfterTestDriveLocation.x, Shared.TestDrive.AfterTestDriveLocation.y, Shared.TestDrive.AfterTestDriveLocation.z), true)
    SetEntityHeading(PlayerPedId(), Shared.TestDrive.AfterTestDriveLocation.w)
    TriggerServerEvent("ts-vehicleshop:endTestSession")
    Wait(1500)
    lib.hideTextUI()
    DoScreenFadeIn(1500)
    ESX.ShowNotification("Test Drive Ended", "info", 3500)
end

CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor
	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

function GeneratePlate()
	local generatedPlate
	local doBreak = false
	while true do
		Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Shared.PlateLetters) .. GetRandomNumber(Shared.PlateNumbers))	
		ESX.TriggerServerCallback('ts-vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end
	return generatedPlate
end

function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('ts-vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
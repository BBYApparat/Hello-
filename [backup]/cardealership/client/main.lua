PlayerData = {}

local NumberCharset = {}
local Charset = {}

local inCarDealer = false
local vehiclesLoaded = false

local current_dealership = nil

local vehicleshop_blips = {}
local created_peds = {}

Vehicles = {}
Categories = {}
Classes = {}

for i = 48, 57 do 
    table.insert(NumberCharset, string.char(i)) 
end

for i = 65, 90 do 
    table.insert(Charset, string.char(i)) 
end

for i = 97, 122 do 
    table.insert(Charset, string.char(i)) 
end

local firstToUpper = function(str)
    str = str or "n/a"
    str = str:lower()
    return (str:gsub("^%l", string.upper):gsub('%s%l', string.upper))
end

local GetRandomNumber = function(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

local GetRandomLetter = function(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

local WaitForVehicleToLoad = function(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not IsModelInCdimage(modelHash) then
        return
    end
    if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName("Downloading asset...")
		EndTextCommandBusyString(4)
		while not HasModelLoaded(modelHash) do
			Wait(1)
			DisableAllControlActions(0)
		end
		RemoveLoadingPrompt()
	end
end

local GeneratePlate = function(type)
	local generatedPlate
	local doBreak = false
	local plateSpace = Config.Vehicleshop.PlateUseSpace
	local plateLet = Config.Vehicleshop.PlateLetters
	local plateNum = Config.Vehicleshop.PlateNumbers
	while true do
		Wait(2)
		math.randomseed(GetGameTimer())
		if plateSpace then
			generatedPlate = string.upper(GetRandomLetter(plateLet) .. ' ' .. GetRandomNumber(plateNum))
		else
			generatedPlate = string.upper(GetRandomLetter(plateLet) .. GetRandomNumber(plateNum))
		end
		ESX.TriggerServerCallback('vehicleshop:isPlateTaken', function (isPlateTaken)
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

local GetAvailableVehicleSpawnPoint = function(coords)
	local isClear = false
	if ESX.Game.IsSpawnPointClear(coords, 5) then
		isClear = true
	end
	return isClear
end

FindVehicleByModel = function(model)
    for i=1,#Vehicles do
        if tostring(Vehicles[i].model) == tostring(model) then
            return Vehicles[i]
        end
    end
    return nil
end

SetupClass = function(class)
    class = class:lower()
    if Config.Classes[class] then
        return Config.Classes[class]
    end
    return class
end

SetupVehicleLabel = function(model)
    local model = (type(model) == "string" and GetHashKey(model)) or model
    local label = GetLabelText(model)
    if label == "NULL" then
        label = GetLabelText(GetDisplayNameFromVehicleModel(model))
    end
    if label == "NULL" then
        label = GetDisplayNameFromVehicleModel(model)
    end
    if label == "NULL" then
        label = model
    end
    return label
end

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
end)

RegisterNetEvent("esx:playerLogout", function()
    if inCarDealer then
        closeCarDealer()
        removeBlips()
    end
end)

RegisterNetEvent("vehicleshop:returnServerData", function(vehicles, categories)
    for i=1,#vehicles do
        if IsModelInCdimage(vehicles[i].model) then
            table.insert(Vehicles, vehicles[i])
        end
    end
    Categories = categories
    vehiclesLoaded = true
    for i=1,#Vehicles do
        Vehicles[i].label = SetupVehicleLabel(Vehicles[i].model)
        Vehicles[i].image = 'images/'..Vehicles[i].model..'.jpg'
    end
end)

RegisterNetEvent("vehicleshop:categoryAction", function(action, data)
    if action == "add" then
        Categories[data.name] = data.label
    elseif action == "adjust" then
        Categories[data.name] = data.label
    elseif action == "delete" then
        Categories[data] = nil
    end
    SendNUIMessage({
        update = true,
        vehicles = Vehicles
    })
end)

RegisterNetEvent("vehicleshop:vehicleAction", function(action, data)
    if action == "add" then
        table.insert(Vehicles, {
            model = data.model,
            price = tonumber(data.price),
            stock = tonumber(data.stock),
            category = data.category,
            class = data.class,
            label = SetupVehicleLabel(data.model),
            image = 'images/'..data.model..'.jpg'
        })
    elseif action == "adjust" then
        for i=1,#Vehicles do
            if tostring(Vehicles[i].model) == tostring(data.model) then
                Vehicles[i] = data
                Vehicles[i].label = SetupVehicleLabel(data.model)
                Vehicles[i].image = "images/"..data.model..'.jpg'
                break
            end
        end
    elseif action == "delete" then
        for i=1,#Vehicles do
            if tostring(Vehicles[i].model) == tostring(data) then
                table.remove(Vehicles, i)
                break
            end
        end
    end
    SendNUIMessage({
        update = true,
        vehicles = Vehicles
    })
end)

RegisterNetEvent("vehicleshop:updateVehicleswithCategory", function(oldCat, newCat)
    for i=1,#Vehicles do
        if tostring(Vehicles[i].category) == tostring(oldCat) then
            Vehicles[i].category = newCat
        end
    end
    SendNUIMessage({
        update = true,
        vehicles = Vehicles
    })
end)

RegisterNetEvent("vehicleshop:openStore", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for k,v in pairs(Config.Vehicleshops) do
        if v.preview and v.preview.coords and v.preview.coords.x and v.preview.coords.y and v.preview.coords.z and v.preview.distance then
            if #(vector3(pos.x, pos.y, pos.z) - vector3(v.preview.coords.x, v.preview.coords.y, v.preview.coords.z)) < (v.preview.distance * 3) then
                current_dealership = k
                break
            end 
        end
    end
    openCarDealer()
end)

RegisterNetEvent("vehicleshop:updateVehicleStock", function(model, stock)
    for i=1,#Vehicles do
        if Vehicles[i].model == model then
            Vehicles[i].stock = stock
            break
        end
    end
    SendNUIMessage({
        update = true,
        vehicles = Vehicles
    })
end)

RegisterNUICallback('closeCarDealer', function(data, cb)
    closeCarDealer(cb)
end)

RegisterNUICallback('BuyVehicle', function(data, cb)
    closeCarDealer(cb)
    local model = (type(data.model) == 'number' and data.model or GetHashKey(data.model))
    if not IsModelInCdimage(model) then
        ESX.ShowNotification("Invalid Vehicle Model", "error", 5000)
        return
    end
    if not current_dealership then
        ESX.ShowNotification("Something went wrong. Try relog", "error", 5000)
        return
    end
    local spawn = Config.Vehicleshops[current_dealership].buy_spawn
    if not GetAvailableVehicleSpawnPoint(spawn.pos) then
        ESX.ShowNotification("Spawn point for vehicle blocked", "error", 5000)
        return
    end
    ESX.TriggerServerCallback("vehicleshop:buyVehicle", function(not_type, hasEnoughMoney)
        if hasEnoughMoney then
            isSpawning = true
            ESX.Game.SpawnVehicle(data.model, spawn.coords, spawn.heading, function(vehicle)
                local newPlate = GeneratePlate(true)
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                vehicleProps.plate = newPlate
                SetVehicleNumberPlateText(vehicle, newPlate)
                TriggerEvent('esx_trunk:giveKeys', vehicleProps.plate, "add")
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                TriggerServerEvent("vehicleshop:setVehicleOwned", vehicleProps, data.model, "car")
                isSpawning = false
            end)
        else
            if not_type == "nomoney" then
                ESX.ShowNotification("Not Enough money!", "error", 3000)
                cb(false)
            else
                cb(false)
            end
        end
    end, data.model)
end)

CreateThread(function()
    while not vehiclesLoaded do Wait(500) end
    local foundMarker = false
    for k,v in pairs(Config.Vehicleshops) do
        if v.preview and v.preview.coords and v.preview.type then
            local prev_type = v.preview.type
            local coords = v.preview.coords
            local targetData = v.preview.targetData
            if v.blip then
                local blipData = v.blip
                if blipData.enabled then
                    blip = AddBlipForCoord(v.preview.coords.x, v.preview.coords.y, v.preview.coords.z)
                    if blipData.color and blipData.color ~= 0 then
                        SetBlipColour(blip, blipData.color)
                    end
                    SetBlipScale(blip, blipData.scale or 0.6)
                    SetBlipSprite(blip, blipData.sprite or 326)
                    SetBlipDisplay(blip, 4)
                    SetBlipAsFriendly(blip, blipData.short or true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(v.label)
                    EndTextCommandSetBlipName(blip)
                    table.insert(vehicleshop_blips, blip)
                end
            end
            if prev_type == "target" and Config.Toggles.useTarget then
                if coords.x and coords.y and coords.z and targetData and targetData.type then
                    if targetData.type == "boxzone" then
                        exports[Config.Resources.target]:AddBoxZone(k, vector3(coords.x, coords.y, coords.z), 0.5, 0.5, {
                            name = k,
                            heading = v.preview.heading or 0.0,
                            minZ = coords.z - 1.2,
                            maxZ = coords.z + 1.2, 
                        },{
                            distance = v.preview.distance or 2.0,
                            options = {
                                {
                                    type = "client",
                                    event = "vehicleshop:openStore",
                                    icon = v.preview.targetData.icon or "fas fa-car",
                                    label = "Open "..v.label,
                                }
                            }
                        })
                    elseif targetData.type == "entityzone" then
                        if targetData and targetData.model then
                            local model = GetHashKey(targetData.model)
                            loadModel(model)
                            local created_ped = CreatePed(1, model, vector3(coords.x, coords.y, coords.z - 0.9), false, false)
                            SetEntityHeading(created_ped, pedLoc.h)
                            SetBlockingOfNonTemporaryEvents(created_ped, true)
                            FreezeEntityPosition(created_ped, true)
                            SetEntityInvincible(created_ped, true)
                            table.insert(created_peds, created_ped)
                            SetModelAsNoLongerNeeded(model)
                            exports[Config.Resources.target]:AddEntityZone(k, created_ped, {
                                name = k,
                                heading = v.preview.heading or 0.0,
                                minZ = coords.z - 1.2,
                                maxZ = coords.z + 1.2, 
                            },{
                                distance = v.preview.distance or 2.0,
                                options = {
                                    {
                                        type = "client",
                                        event = "vehicleshop:openStore",
                                        icon = v.preview.targetData.icon or "fas fa-car",
                                        label = "Open "..v.label,
                                    }
                                }
                            })
                        end
                    end
                end
            elseif prev_type == "marker" then
                foundMarker = true
            end
        end
    end
    while foundMarker do
        local sleep = 300
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for k,v in pairs(Config.Vehicleshops) do
            if v.preview and v.preview.coords and v.preview.type then
                if v.preview.type == "marker" and not inCarDealer then
                    local coords = v.preview.coords
                    local distance = v.preview.distance or 2.0
                    if coords.x and coords.y and coords.z then
                        local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(pos.x, pos.y, pos.z))
                        if dist <= (distance * 3) then
                            sleep = 3
                            local markerData = v.preview.markerData
                            DrawMarker(markerData.type or 2, coords.x, coords.y, coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerData.scaleX or 0.5, markerData.scaleY or 0.5, markerData.scaleZ or 0.5, markerData.colorR or 255, markerData.colorG or 255, markerData.colorB or 255, markerData.colorA or 255, false, true, 2, false, false, false, false)
                            if dist <= distance then
                                DrawText3D("[E] - Open "..v.label, coords.x, coords.y, coords.z)
                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent("vehicleshop:openStore")
                                end
                            end
                        end
                    end
                end     
            end
        end
        Wait(sleep)
    end
end)

if Config.Toggles.useGangs then
    RegisterNetEvent(Config.Events.setGangEvent, function(gang)
        setGangData(gang)
    end)
end

if Config.Toggles.useJobDuty then
    RegisterNetEvent(Config.Events.toggleDuty, function(bool)
        togglePlayerDuty(bool)
    end)
end

CreateThread(function()
    if not Config.Toggles.useDefaultDealershipInterior then return end
	RequestIpl('shr_int')
	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission')
	RefreshInterior(interiorID)
end)

openCarDealer = function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        show = true,
        vehicles = Vehicles,
        categories = Categories
    })
    inCarDealer = true
end

closeCarDealer = function(cb)
    SendNUIMessage({show = false})
    current_dealership = nil
    SetNuiFocus(false, false)
    inCarDealer = false
    cb(true)
end

removeBlips = function()
    if vehicleshop_blips and #vehicleshop_blips > 0 then
        for i=1,#vehicleshop_blips do
            RemoveBlip(vehicleshop_blips[i])
        end
    end
    vehicleshop_blips = {}
end

removePeds = function()
    if created_peds and #created_peds > 0 then
        for i=1,#created_peds do
            DeleteEntity(created_peds[i])
        end
        created_peds = {}
    end
end

loadModel = function(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
    end
end

DrawText3D = function(text, x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
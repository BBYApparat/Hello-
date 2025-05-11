PlayerData = {}
ScreenshotWebhook = nil

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(1000) end
    while ESX.GetPlayerData() == nil do Citizen.Wait(1000) end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(1000) end
    playerPed = PlayerPedId()
    PlayerData = ESX.GetPlayerData()
    Citizen.CreateThread(function()
    	exports['spawnmanager']:setAutoSpawn(false)
    end)
    ESX.TriggerServerCallback('ak47_ambulancejob:getwebhook', function(hook)
    	ScreenshotWebhook = hook
    end)
    RequestAnimSet("move_m@injured")
    SetPedMaxHealth(playerPed, Config.MaxHealth)
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		playerPed = PlayerPedId()
		SetPedMaxHealth(playerPed, Config.MaxHealth)
	end
end)

RegisterNetEvent('esx:playerLoaded', function()
	StopEffect()
	Wait(100)
	playerPed = PlayerPedId()
    LocalPlayer.state:set('dead', false, true)
	LocalPlayer.state:set('down', false, true)
	CheckDeadStatus()
	StartDamageEffect()
	SetPedMaxHealth(playerPed, Config.MaxHealth)
end)

RegisterNetEvent('ak47_ambulancejob:heal', function()
	playerPed = PlayerPedId()
	SetPedMaxHealth(playerPed, Config.MaxHealth)
	SetEntityHealth(playerPed, Config.MaxHealth)
	SetStatus('hunger', 100)
	SetStatus('thirst', 100)
	SetStatus('stress', 0)
end)

Citizen.CreateThread(function()
	DoScreenFadeIn(800)
	for k, v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v.pos)
		SetBlipSprite(blip, v.sprite)
		SetBlipScale(blip, v.size)
		SetBlipColour(blip, v.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.label)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('esx:setJob', function(job)
	PlayerData.job = job
end)

function SetStatus(type, value)
	TriggerEvent('esx_status:set', type, value * 10000)
end

function AddStatus(type, value)
	TriggerEvent('esx_status:add', type, value * 10000)
end

function RemoveStatus(type, value)
	TriggerEvent('esx_status:remove', type, value * 10000)
end

RegisterNetEvent('ak47_ambulancejob:notify', function(msg, type)
	--[[
	type:
		success
		warning
		error
		info
	]]
	if type == 'success' then
		ESX.ShowNotification('~g~'..msg)
	elseif type == 'warning' then
		ESX.ShowNotification('~y~'..msg)
	elseif type == 'error' then
		ESX.ShowNotification('~r~'..msg)
	else
		ESX.ShowNotification(msg)
	end
end)

function GetStreet()
    local position = GetEntityCoords(playerPed)
    local var1, var2 = GetStreetNameAtCoord(position.x, position.y, position.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local zone = GetNameOfZone(position.x, position.y, position.z)
    local zoneLabel = GetLabelText(zone)
    hash1 = GetStreetNameFromHashKey(var1)
    return hash1, zoneLabel
end

function getEntityControl(entity)
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) do
		NetworkRequestControlOfEntity(entity)
		Wait(0) 
	end
end

function loadModel(hash)
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do Wait(0) end
	end
end

function loadAnim(dir)
	if not HasAnimDictLoaded(dir) then
		RequestAnimDict(dir)
		while not HasAnimDictLoaded(dir) do Wait(0) end
	end
end

function lerpColorBasedOnDamage(damage)
    damage = math.max(0, math.min(80, damage))
    local t = damage / 80
    local red = 255 * t
    local green = 255 * (1 - t)
    local blue = 0
    return {math.floor(red), math.floor(green), math.floor(blue)}
end

Round = function(value)
	return math.floor((value * 1000) + 0.5) / 1000
end

DisableDownControls = function()
	DisableAllControlActions(0)
	EnableControlAction(0, 47, true) 	--G
	EnableControlAction(0, 245, true) 	--T
	EnableControlAction(0, 249, true) 	--N
	EnableControlAction(0, 288, true) 	--F1
	EnableControlAction(0, 38, true) 	--E
	EnableControlAction(0, 1, true) 	--MOUSE RIGHT
	EnableControlAction(0, 2, true) 	--MOUSE DOWN
	EnableControlAction(0, 201, true) 	--ENTER
	EnableControlAction(0, 202, true) 	--BACKSPACE
	EnableControlAction(0, 27, true) 	--ARROW UP
	EnableControlAction(0, 173, true) 	--ARROW DOWN
	EnableControlAction(0, 174, true) 	--ARROW LEFT
	EnableControlAction(0, 175, true) 	--ARROW RIGHT
end

DisableDeadControls = function()
	DisableAllControlActions(0)
	EnableControlAction(0, 47, true) 	--G
	EnableControlAction(0, 245, true) 	--T
	EnableControlAction(0, 249, true) 	--N
	EnableControlAction(0, 288, true) 	--F1
	EnableControlAction(0, 38, true) 	--E
	EnableControlAction(0, 1, true) 	--MOUSE RIGHT
	EnableControlAction(0, 2, true) 	--MOUSE DOWN
	EnableControlAction(0, 201, true) 	--ENTER
	EnableControlAction(0, 202, true) 	--BACKSPACE
	EnableControlAction(0, 27, true) 	--ARROW UP
	EnableControlAction(0, 173, true) 	--ARROW DOWN
	EnableControlAction(0, 174, true) 	--ARROW LEFT
	EnableControlAction(0, 175, true) 	--ARROW RIGHT
end

PlayingIgnoreAnim = function()
	for i, v in ipairs(Config.IgnoreAnims) do
		if IsEntityPlayingAnim(playerPed, v.dir, v.anim, 3) then
			return true
		end
	end
	return false
end

function DrawText2Ds(x, y, text, scale, font, color)
    SetTextFont(font or 4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    if color then
    	SetTextColour(color[1], color[2], color[3], 255)
    else

    end
    SetTextDropShadow(0.0, 0.0, 0.0, 0.0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function SecToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0
	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))
		return mins, secs
	end
end
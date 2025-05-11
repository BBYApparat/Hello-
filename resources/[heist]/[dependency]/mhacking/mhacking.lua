mhackingCallback = {}
showHelp = false
helpTimer = 0
helpCycle = 4000
isDead = false
isDown = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showHelp then
			if helpTimer > GetGameTimer() then
				showHelpText("Navigate with ~y~W,A,S,D~s~ and agree with ~y~SPACE~s~for the left block code.")
			elseif helpTimer > GetGameTimer()-helpCycle then
				showHelpText("Use ~y~Arrow Keys~s~ and ~y~ENTER~s~ for the right block code")
			else
				helpTimer = GetGameTimer() + helpCycle
			end
			if isDead then
				nuiMsg = {}
				nuiMsg.fail = true
				SendNUIMessage(nuiMsg)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
end)

AddEventHandler('esx:onPlayerDown', function()
    isDown = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
    isDead = false
	isDown = false
end)

function showHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0,0,0,-1)
end

AddEventHandler('mhacking:show', function()
    nuiMsg = {}
	nuiMsg.show = true
	SendNUIMessage(nuiMsg)
	SetNuiFocus(true, false)
end)

AddEventHandler('mhacking:hide', function()
    nuiMsg = {}
	nuiMsg.show = false
	SendNUIMessage(nuiMsg)
	SetNuiFocus(false, false)
	showHelp = false
end)

AddEventHandler('mhacking:start', function(solutionlength, duration, callback)
    mhackingCallback = callback
	nuiMsg = {}
	nuiMsg.s = solutionlength
	nuiMsg.d = duration
	nuiMsg.start = true
	SendNUIMessage(nuiMsg)
	showHelp = true
end)

AddEventHandler('mhacking:setmessage', function(msg)
    nuiMsg = {}
	nuiMsg.displayMsg = msg
	SendNUIMessage(nuiMsg)
end)

RegisterNUICallback('callback', function(data, cb)
	mhackingCallback(data.success, data.remainingtime)
    cb('ok')
end)
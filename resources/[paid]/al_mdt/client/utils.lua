-- Callbacks
local Callbacks = {}; local CallbackId = 0

function TriggerServerCallback(name, cb, ...)
	Callbacks[CallbackId] = cb

	TriggerServerEvent('al_mdt:TriggerServerCallback', name, CallbackId, ...)

	if CallbackId < 65535 then
		CallbackId = CallbackId + 1
	else
		CallbackId = 0
	end
end

RegisterNetEvent('al_mdt:ServerCallback')
AddEventHandler('al_mdt:ServerCallback', function(requestId, ...)
	Callbacks[requestId](...)
	Callbacks[requestId] = nil
end)

RegisterNetEvent('al_mdt:GetCoords')
AddEventHandler('al_mdt:GetCoords', function()
	local playerCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
    TriggerServerEvent('al_mdt:SendCoords', mdt.k, GetIdentifier(), playerCoords)
end)

RegisterNetEvent("al_mdt:Print")
AddEventHandler("al_mdt:Print",function(str)
    print(('^8Server to client: %s'):format(str))
end)

function DeepPrint (e)
    if type(e) == "table" then
        for k,v in pairs(e) do
            print("-> "..k)
            DeepPrint(v)
        end
    else
        print(e)
    end
end

function HelpNotification(str)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function FormatNumber(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function GetJobKey(job)
    for i=1, #Config.MDT.Jobs do
        local v = Config.MDT.Jobs[i]

        if v.job == job then
            return v.type
        end
    end

    return false
end
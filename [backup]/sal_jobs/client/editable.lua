loadAnimDict = function(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(100)
        end
    end
end

loadModel = function(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    if not IsModelInCdimage(model) then
        print("Model ".. model.. ' is not valid!')
        return
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
    end
end

ShowNotification = function(msg, time, type)
    ESX.ShowNotification(msg, time, type)
end

DoMinigame = function(minigame_info, cb)
    local minigame_data = Config.MinigameSettings[minigame_info]
    exports["ps-ui"]:Circle(function(minigameSuccess)
        if cb then
            cb(minigameSuccess)
        end
    end, minigame_data.circles, minigame_data.seconds)
end

ProgressBar = function(text, time, settings, cb)
    if not settings then settings = {} end
    exports.progressbar:Progress({
		name = "jobs_pbar",
		duration = time,
		label = text,
		useWhileDead = settings.whileDead or false,
		canCancel = settings.canCancel or false,
		controlDisables = {
			disableMovement = settings.movement or false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,    
		},
		animation = {
			animDict = settings.dict or nil,
			anim = settings.anim or nil,
			flags = settings.flags or 0
		}
	}, function(cancelled)
        if cb then
            if cancelled then
                cb(true)
            else
                cb(false)
            end
        end
    end) 
end

addStressToPlayer = function(from)
    if not Config.EnableStress then return end
    TriggerEvent("esx_status:add", "stress", Config.StressValues[from])
end

removeStressFromPlayer = function(from)
    if not Config.EnableStress then return end
    TriggerEvent("esx_status:remove", "stress", Config.StressValues[from])
end

RegisterCommand('anchor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        if not IsBoatAnchoredAndFrozen(vehicle) then
            SetBoatFrozenWhenAnchored(vehicle, true)
            SetBoatAnchor(vehicle, true)
            ESX.ShowNotification('Anchor enabled!')
        else
            SetBoatFrozenWhenAnchored(vehicle, false)
            SetBoatAnchor(vehicle, false)
            ESX.ShowNotification('Anchor disabled!')
        end
    end
end)
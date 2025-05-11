handsup = false
local canHandsUp = true
local tryingtohandsup = false

local white = {
	GetHashKey("mp_m_freemode_01"),
	GetHashKey("mp_f_freemode_01"),
	GetHashKey("ig_bankman"),
	GetHashKey("a_m_m_fatlatin_01"),
	GetHashKey("ig_beverly"),
	GetHashKey("ig_clay"),
	GetHashKey("ig_dale"),
    GetHashKey("ig_priest"),
    GetHashKey("cs_priest")
}

AddEventHandler('handsup:toggle', function(param)
	canHandsUp = param
end)

function IsInWhitelist()
    local whitelist = false
    local model = GetEntityModel(PlayerPedId())
    for i = 1, #white do
        if model == white[i] then
            whitelist = true
        end
    end
    return whitelist
end

RegisterCommand('hands', function()
    local canhandsup = true
    if inJoint then
        ClearPedTasks(PlayerPedId())
        inJoint = false
        canhandsup = false
        return
    end
    TriggerEvent('emotes:isInAnimation', function(isbusy2)
        if isbusy2 then
            TriggerEvent('emotes:Cancel')
            canhandsup = false
            return
        end
    end)
    local inNeed = exports.es_extended:isInNeeds()
    if inNeed then
        ClearPedTasks(PlayerPedId())
        TriggerEvent('stopNeeds')
        return
    end
    local isHandcuffed = exports.esx_whitelistedjobs:isPlayerHandcuffed()
    if isHandcuffed then return end
    if canhandsup then
        local wl = IsInWhitelist()
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId())
            local speed = GetEntitySpeed(veh) * 3.6
            if tonumber(speed) > 5 then return end
        end
        if wl then 
            if not ESX.Game.IsPlayerBusy() then
                local playerPed = PlayerPedId()
                local dict = "missminuteman_1ig_2"
                local anim = "handsup_enter"
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(100)
                end
                if handsup then
                    handsup = false
                    ClearPedSecondaryTask(playerPed)
                    TriggerServerEvent('esx_thief:update', handsup)
                else
                    TriggerEvent('inventory:client:restoreWeapons')
                    handsup = true
                    TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                    TriggerServerEvent('esx_thief:update', handsup)
                end
            else
                ExecuteCommand('cancelemote')
            end
        end
    end
end)
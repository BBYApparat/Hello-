if not Framework.QBox() then return end
local QBX = exports.qbx_core

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(5000)
    if Config.UseTalkNPC then
        talkNPC()
    else
        targetNPC()
    end
    initWeed()
end)

function Framework.Notification(_msg, _type, _time)
    exports.qbx_core:Notify(_msg, _type, _time)
end

function Framework.checkJob(filters)
    return QBX:HasGroup(filters)
end

function Framework.GetCurrentCop()
    return lib.callback.await('rep-weed:callback:GetCurrentCop', false)
end

function Framework.getIdentifier()
   return QBX:GetPlayerData().citizenid
end

function Framework.Progressbar(_name, _label, _duration, _canCancel, _onFinish, _onCancel)
    if lib.progressCircle({
        duration = _duration,
        label = _label,
        position = 'bottom',
        useWhileDead = false,
        canCancel = _canCancel,
    }) then
        if _onFinish then
            _onFinish()
        end
    else
        if _onCancel then
            _onCancel()
        end
    end
end
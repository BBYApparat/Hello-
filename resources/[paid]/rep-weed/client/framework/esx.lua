if not Framework.ESX() then return end

local ESX = exports.es_extended:getSharedObject()

local function setPlayerData(playerData)
    Framework.PlayerJob = playerData.job
end

if ESX.PlayerLoaded then
    setPlayerData(ESX.PlayerData)
end

RegisterNetEvent("esx:playerLoaded", function(xPlayer, isNew)
    Wait(5000)
    setPlayerData(xPlayer)
    if Config.UseTalkNPC then
        talkNPC()
    else
        targetNPC()
    end
    initWeed()
end)

RegisterNetEvent('esx:setJob', function (job, lastJob)
    Framework.PlayerJob = job
end)

function Framework.checkJob(filters)
    local _type = type(filters)
    if _type == 'string' then
        local data = Framework.PlayerJob
        if filters == data?.name then
            return true
        end
    elseif _type == 'table' then
        local tabletype = table.type(filters)
        if tabletype == 'hash' then
            for name, grade in pairs(filters) do
                local data = Framework.PlayerJob
                if data?.name == name and grade <= data.grade then
                    return true
                end
            end
        elseif tabletype == 'array' then
            for j = 1, #filters do
                local name = filters[j]
                local data = Framework.PlayerJob
                if data?.name == name then
                    return true
                end
            end
        end
    end
end

function Framework.GetCurrentCop()
    return lib.callback.await('rep-weed:callback:GetCurrentCop', false)
end

function Framework.Notification(_msg, _type, _time)
    ESX.ShowNotification(_msg, _type, _time)
end

function Framework.getIdentifier()
    return ESX.PlayerData.identifier
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
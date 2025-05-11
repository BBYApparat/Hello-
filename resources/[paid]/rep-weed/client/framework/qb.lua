if not Framework.QBCore() or Framework.QBox() then return end

local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCops = 0
local PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(5000)
    PlayerData = QBCore.Functions.GetPlayerData()
    if Config.UseTalkNPC then
        talkNPC()
    else
        targetNPC()
    end
    initWeed()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(value)
    PlayerData = value
end)

function Framework.checkJob(filters)
    local _type = type(filters)
    if _type == 'string' then
        return PlayerData.job.name == filters
    elseif _type == 'table' then
        local tabletype = table.type(filters)
        if tabletype == 'hash' then
            for name, grade in pairs(filters) do
                if PlayerData.job.name == name and grade <= PlayerData.job.grade.level then
                    return true
                end
            end
        elseif tabletype == 'array' then
            for j = 1, #filters do
                local name = filters[j]
                if PlayerData.job.name == name then
                    return true
                end
            end
        end
    end
end

-- Police
RegisterNetEvent('police:SetCopCount', function(amount) -- Update your police count
    CurrentCops = amount
end)

function Framework.GetCurrentCop()
    return CurrentCops
end

function Framework.GetPlayerData()
    return PlayerData
end

function Framework.Notification(_msg, _type, _time)
    QBCore.Functions.Notify(_msg, _type, _time)
end

function Framework.getIdentifier()
    local PlayerData = PlayerData
    return PlayerData.citizenid
end

function Framework.Progressbar(_name, _label, _duration, _canCancel, _onFinish, _onCancel)
    -- exports['progressbar']:Progress({
    --     name = _name,
    --     duration = _duration,
    --     label = _label,
    --     useWhileDead = false,
    --     canCancel = _canCancel,
    --     controlDisables = {},
    --     animation = {},
    --     prop = {},
    --     propTwo = {},
    -- }, function(cancelled)
    --     if not cancelled then
    --         if _onFinish then
    --             _onFinish()
    --         end
    --     else
    --         if _onFinish then
    --             _onFinish()
    --         end
    --     end
    -- end)
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
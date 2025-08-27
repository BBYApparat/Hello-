local QBCore = exports['qb-core']:GetCoreObject()

local Framework = {}

function Framework.getPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

function Framework.getPlayerJob(player)
    if not player then return nil, nil end
    return player.PlayerData.job.name, player.PlayerData.job.type
end

function Framework.getPlayerStress(player)
    if not player then return 0 end
    if not player.PlayerData.metadata['stress'] then
        player.PlayerData.metadata['stress'] = 0
    end
    return player.PlayerData.metadata['stress']
end

function Framework.setPlayerStress(player, amount)
    if not player then return end
    if amount <= 0 then amount = 0 end
    if amount > 100 then amount = 100 end
    player.Functions.SetMetaData('stress', amount)
end

function Framework.addPlayerStress(src, amount)
    local player = Framework.getPlayer(src)
    if not player then return end
    local currentStress = Framework.getPlayerStress(player)
    local newStress = currentStress + amount
    Framework.setPlayerStress(player, newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end

function Framework.removePlayerStress(src, amount)
    local player = Framework.getPlayer(src)
    if not player then return end
    local currentStress = Framework.getPlayerStress(player)
    local newStress = currentStress - amount
    Framework.setPlayerStress(player, newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end

function Framework.notify(src, message, type, duration)
    TriggerClientEvent('QBCore:Notify', src, message, type, duration)
end

function Framework.isJobWhitelisted(jobName, jobType, whitelist)
    return whitelist[jobType] or whitelist[jobName] or false
end

return Framework
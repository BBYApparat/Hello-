local ESX = exports['es_extended']:getSharedObject()

local Framework = {}

function Framework.getPlayer(src)
    return ESX.GetPlayerFromId(src)
end

function Framework.getPlayerJob(player)
    if not player then return nil, nil end
    return player.job.name, player.job.name -- ESX doesn't have job type, use name for both
end

function Framework.getPlayerStress(player)
    if not player then return 0 end
    -- ESX stress is handled via esx_status, not player metadata
    -- We'll trigger the status system directly
    return 0 -- Status system handles the actual values
end

function Framework.setPlayerStress(player, amount)
    if not player then return end
    -- Use ESX status system to set stress
    -- This will be handled by the esx_status resource
end

function Framework.addPlayerStress(src, amount)
    TriggerEvent('esx_status:add', src, 'stress', amount)
end

function Framework.removePlayerStress(src, amount)
    TriggerEvent('esx_status:remove', src, 'stress', amount)
end

function Framework.notify(src, message, type, duration)
    -- Use ox_lib notifications for ESX
    TriggerClientEvent('ox_lib:notify', src, {
        title = type == 'error' and 'Stress Gain' or 'Stress Removed',
        description = message,
        type = type or 'inform',
        duration = duration or 3000
    })
end

function Framework.isJobWhitelisted(jobName, jobType, whitelist)
    return whitelist[jobName] or false
end

return Framework
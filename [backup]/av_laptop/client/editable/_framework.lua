-- Events needed to run checks when a player login, logout or change job

-- For QBCore:
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Triggered when a player spawns
    local player = Core.Functions.GetPlayerData()
    updateJob(player.job)
    TriggerEvent("av_laptop:loaded") -- notify other apps
    jobListCheck() -- used for av_business, ignored if av_business isn't installed
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) -- Triggered when a player job is updated
    updateJob(JobInfo)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() -- Triggered when a player logout
    updateJob({})
    TriggerEvent("av_laptop:unload") -- notify other apps
end)

-- For ESX:
RegisterNetEvent('esx:playerLoaded', function(xPlayer) -- Triggered when a player spawns
    updateJob(xPlayer.job)
    TriggerEvent("av_laptop:loaded") -- notify other apps
    jobListCheck() -- used for av_business, ignored if av_business isn't installed
end)

RegisterNetEvent('esx:onPlayerLogout', function() -- Triggered when a player logout
    updateJob({})
    TriggerEvent("av_laptop:unload") -- notify other apps
end)

RegisterNetEvent('esx:setJob', function(job) -- Triggered when a player job is updated
    updateJob(job)
end)

AddEventHandler('onResourceStart', function(resourceName) -- run job checks if av_laptop is restarted
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    while not Core do Wait(50) end
    if Config.Framework == "qb" then
        local player = Core.Functions.GetPlayerData()
        updateJob(player.job)
    elseif Config.Framework == "esx" then
        updateJob(Core.PlayerData.job)
    end
    jobListCheck()
end)
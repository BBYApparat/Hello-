PlayerJob = nil

function updateJob(job)
    PlayerJob = job
end

function getJobs()
    while not Core do Wait(10) end
    local jobsList = {}
    if Config.Framework == "qb" then
        for k, v in pairs(Core.Shared.Jobs) do
            jobsList[#jobsList+1] = k
        end
    elseif Config.Framework == "esx" then
        local data = lib.callback.await('av_laptop:getJobs', false)
        for k, v in pairs(data) do
            jobsList[#jobsList+1] = k
        end
    end
    return jobsList
end

function refreshJob()
    while not Core do Wait(10) end
    if Config.Framework == "esx" then
        PlayerJob = Core.GetPlayerData().job
    end
    if Config.Framework == "qb" then
        Core.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
        end)
    end
end
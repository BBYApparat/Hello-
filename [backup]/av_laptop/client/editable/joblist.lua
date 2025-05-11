-- Used for av_business, we need a list of all available jobs on your server
jobsList = {}

function jobListCheck()
    if GetResourceState("av_business") == "missing" or GetResourceState("av_cameras") == "missing" then return end
    while not Core and not Config.Framework do Wait(10) end -- Wait for Core to load
    if Config.Framework == "qb" then
        for k, v in pairs(Core.Shared.Jobs) do
            jobsList[#jobsList + 1] = k
        end
    else
        lib.callback('av_laptop:getJobs', false, function(data)
            for k, v in pairs(data) do
                jobsList[#jobsList+1] = k
            end
        end)
    end
end
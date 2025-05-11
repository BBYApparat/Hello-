--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

--[[
    This export opens the catalogue of a shop regardless the position or the distance of it
        jobName : the job name as it is in the Config (Config.Jobs)

    the exports return the success status of the action
]]
exports('catalogueOpen', function(jobName)
    if (not jobName or not Config.JOBS_INITED[jobName]) then return false end

    TriggerServerEvent('lls-newbill:requestToOpenCatalogueMenu_server', {
        name = jobName,
        label = Config.JOBS_INITED[jobName].label
    })
    return true
end)
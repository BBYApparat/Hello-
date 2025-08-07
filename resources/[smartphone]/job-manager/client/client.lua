-- Job Manager Client

-- NUI Callbacks
RegisterNUICallback("getJobData", function(data, cb)
    local result = lib.callback.await('job-manager:getJobData', false)
    cb(result)
end)

RegisterNUICallback("hireEmployee", function(data, cb)
    local result = lib.callback.await('job-manager:hireEmployee', false, data)
    cb(result)
end)

RegisterNUICallback("promoteEmployee", function(data, cb)
    local result = lib.callback.await('job-manager:promoteEmployee', false, data)
    cb(result)
end)

RegisterNUICallback("demoteEmployee", function(data, cb)
    local result = lib.callback.await('job-manager:demoteEmployee', false, data)
    cb(result)
end)

RegisterNUICallback("fireEmployee", function(data, cb)
    local result = lib.callback.await('job-manager:fireEmployee', false, data)
    cb(result)
end)

RegisterNUICallback("giveBonus", function(data, cb)
    local result = lib.callback.await('job-manager:giveBonus', false, data)
    cb(result)
end)

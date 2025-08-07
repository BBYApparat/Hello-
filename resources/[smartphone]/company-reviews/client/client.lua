-- Company Reviews Client

-- NUI Callbacks
RegisterNUICallback("getCompanies", function(data, cb)
    local result = lib.callback.await('company-reviews:getCompanies', false)
    cb(result)
end)

RegisterNUICallback("saveCompanyReview", function(data, cb)
    local result = lib.callback.await('company-reviews:saveReview', false, data)
    cb(result)
end)

RegisterNUICallback("addCompanyReply", function(data, cb)
    local result = lib.callback.await('company-reviews:addReply', false, data)
    cb(result)
end)

RegisterNUICallback("setCompanyOwner", function(data, cb)
    local result = lib.callback.await('company-reviews:setCompanyOwner', false, data)
    cb(result)
end)

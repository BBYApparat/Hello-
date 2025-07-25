local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('police_radar:getPlayerJob', function(source, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then
        cb(xPlayer.job.name)
    else
        cb(nil)
    end
end)
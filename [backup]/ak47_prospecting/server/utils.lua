ESX = ESX or nil
if ESX == nil then
    TriggerEvent(Config.SharedObjectName, function(obj) ESX = obj end)
end
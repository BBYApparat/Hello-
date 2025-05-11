ESX = ESX or nil

if ESX == nil then
    TriggerEvent(Config.SharedObjectName, function(obj) ESX = obj end)
end

Citizen.CreateThread(function()
    for i, v in pairs(Config.Salon) do
    	for j, k in pairs(v.job) do
        	TriggerEvent('esx_society:registerSociety', j, j, 'society_'..j, 'society_'..j, 'society_'..j, {type = 'private'})
        end
    end
    for i, v in pairs(Config.Tattoos) do
        for j, k in pairs(v.job) do
        	TriggerEvent('esx_society:registerSociety', j, j, 'society_'..j, 'society_'..j, 'society_'..j, {type = 'private'})
        end
    end
end)

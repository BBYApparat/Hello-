--[[ QBCore ]]
AddEventHandler('QBCore:Server:PlayerLoaded', function(obj)
      TriggerEvent('okokPhone:Server:PlayerLoaded', obj.PlayerData.source)
      TriggerClientEvent('okokPhone:Client:playerLoaded', obj.PlayerData.source)
end)

--[[ ESX ]]
AddEventHandler('esx:playerLoaded', function(source)
      local src = tonumber(source) --[[ @as number ]]
      TriggerEvent('okokPhone:Server:PlayerLoaded', src)
      TriggerClientEvent('okokPhone:Client:playerLoaded', src)
end)

AddEventHandler('ox:playerLoaded', function(source, userid, charid)
      TriggerEvent('okokPhone:Server:PlayerLoaded', source)
      TriggerClientEvent('okokPhone:Client:playerLoaded', source)
end)


RegisterNetEvent('QBCore:ToggleDuty', function(data)
      local src = source
      local Player = Framework.Functions.GetPlayer(src)
end)

RegisterServerCallback('esx:getJobInfo', function(source, jobName)
      return Framework.Jobs[jobName]
end)

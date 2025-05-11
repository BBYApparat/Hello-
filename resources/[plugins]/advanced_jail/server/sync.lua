AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            Citizen.Wait(3000)
            local xPlayers = ESX.GetPlayers()
            if xPlayers[1] ~= nil then
                good = true
                for i = 1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                        }, function(result)
                        local newData = nil
                        newData = json.decode(result[1].jail_data)
                        if newData.jailtime > 0 then
                            TriggerEvent('advanced_jail:ReJail', xPlayer.source, newData)
                        elseif xPlayer.job.name == 'prisoner' then
                            xPlayer.setJob(Config.DefaultSetJob.Name, Config.DefaultSetJob.Grade)
                        end
                    end)
                    local items = MySQL.Sync.fetchAll('SELECT * FROM items')
                    for i = 1, #items, 1 do
                        table.insert(Items, {name = items[i].name, label = items[i].label})
                    end
                end
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i = 1, #inJail, 1 do
            for k = 1, #inJail[i].Players, 1 do
                if inJail[i].Players[k].Player ~= nil then
                    MySQL.Async.fetchAll('SELECT jail_data FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = inJail[i].Players[k].Player
                        }, function(result)
                        local newData = nil
                        local data = nil
                        newData = json.decode(result[1].jail_data)
                        newData.jailtime = inJail[i].Players[k].Timie
                        data = json.encode(newData)
                        MySQL.Sync.execute('UPDATE users SET jail_data = @jail_data WHERE identifier = @identifier', {
                            ['@identifier'] = inJail[i].Players[k].Player,
                            ['@jail_data'] = data
                        })
                    end)
                end
            end
        end
    end
end)
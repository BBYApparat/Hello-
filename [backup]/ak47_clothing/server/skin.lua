RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
        ['@skin'] = json.encode(skin),
        ['@identifier'] = xPlayer.identifier
    })
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    }, function(users)
        local user, skin = users[1]
        local jobSkin = {
            skin_male = xPlayer.job.skin_male,
            skin_female = xPlayer.job.skin_female
        }
        if user.skin then
            skin = json.decode(user.skin)
        end
        cb(skin, jobSkin)
    end)
end)

if Config.ESXVersion == '1.1' then
    TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, args, user)
        TriggerClientEvent('esx_skin:openSaveableMenu', source)
    end, function(source, args, user)
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Insufficient permissions!')
    end, {help = 'change skin'})

    TriggerEvent('es:addGroupCommand', 'forceskin', 'admin', function(source, args, user)
        if args[1] then
            TriggerClientEvent('esx_skin:openSaveableMenu', tonumber(args[1]))
        else
            TriggerClientEvent('esx_skin:openSaveableMenu', source)
        end
    end, function(source, args, user)
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Insufficient permissions!')
    end, {help = 'give skin menu'})
else
    ESX.RegisterCommand('skin', {'superadmin', 'admin'}, function(xPlayer, args, showError)
        xPlayer.triggerEvent('esx_skin:openSaveableMenu')
    end, false, {help = 'change skin'})

    ESX.RegisterCommand('forceskin', {'superadmin', 'admin'}, function(xPlayer, args, showError)
        args.playerId.triggerEvent('esx_skin:openSaveableMenu')
    end, true, {help = 'Give skin menu', validate = true, arguments = {
    {name = 'playerId', help = 'The player id', type = 'player'}}})
end

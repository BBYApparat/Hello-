-- ESX MDT Commands System

-- MDT Toggle Command
ESX.RegisterCommand('mdt', 'user', function(xPlayer, args, showError)
    if HasMDTAccess(xPlayer) then
        TriggerClientEvent('esx_mdt:client:toggle', xPlayer.source)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You do not have access to the MDT system')
    end
end, false, {help = 'Open Mobile Data Terminal'})

-- Tablet Command (for businesses)
ESX.RegisterCommand('tablet', 'user', function(xPlayer, args, showError)
    if HasMDTAccess(xPlayer) then
        TriggerClientEvent('esx_mdt:client:toggle', xPlayer.source)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You do not have access to the tablet system')
    end
end, false, {help = 'Open Business Tablet'})

-- Set Callsign Command
ESX.RegisterCommand('setcallsign', 'user', function(xPlayer, args, showError)
    local targetId = tonumber(args.target)
    local newCallsign = args.callsign
    
    if not targetId or not newCallsign then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Usage: /setcallsign [player_id] [callsign]')
        return
    end
    
    local targetPlayer = GetESXPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Player not found')
        return
    end
    
    -- Check if target has emergency job
    if not HasMDTAccess(targetPlayer) then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Target is not emergency personnel')
        return
    end
    
    -- Check if callsign already exists
    local existingCallsign = MySQL.scalar.await('SELECT id FROM mdt_callsigns WHERE callsign = ? AND identifier != ?', {
        newCallsign, targetPlayer.identifier
    })
    
    if existingCallsign then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Callsign already in use')
        return
    end
    
    -- Get target player info
    local targetJob = targetPlayer.getJob()
    local targetName = targetPlayer.getName()
    local firstName, lastName = targetName:match('(%S+)%s+(%S+)')
    if not firstName then firstName, lastName = targetName, '' end
    
    -- Update or insert callsign
    MySQL.query('DELETE FROM mdt_callsigns WHERE identifier = ?', {targetPlayer.identifier})
    
    MySQL.insert('INSERT INTO mdt_callsigns (identifier, firstname, lastname, callsign, job, department) VALUES (?, ?, ?, ?, ?, ?)', {
        targetPlayer.identifier,
        firstName,
        lastName,
        newCallsign,
        targetJob.name,
        targetJob.name
    })
    
    TriggerClientEvent('esx:showNotification', xPlayer.source, ('Callsign %s assigned to %s'):format(newCallsign, targetName))
    TriggerClientEvent('esx:showNotification', targetPlayer.source, ('Your callsign has been set to %s'):format(newCallsign))
    
end, false, {help = 'Set player callsign', validate = true, arguments = {
    {name = 'target', help = 'Player server ID', type = 'number'},
    {name = 'callsign', help = 'Callsign to assign', type = 'string'}
}})

-- Reclaim Callsign Command
ESX.RegisterCommand('reclaimcallsign', 'user', function(xPlayer, args, showError)
    local callsign = args.callsign
    
    if not callsign then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Usage: /reclaimcallsign [callsign]')
        return
    end
    
    -- Get info about the callsign before deleting
    local callsignInfo = MySQL.single.await('SELECT firstname, lastname FROM mdt_callsigns WHERE callsign = ?', {callsign})
    
    local result = MySQL.query.await('DELETE FROM mdt_callsigns WHERE callsign = ?', {callsign})
    
    if result.affectedRows > 0 then
        local playerName = callsignInfo and (callsignInfo.firstname .. ' ' .. callsignInfo.lastname) or 'Unknown'
        TriggerClientEvent('esx:showNotification', xPlayer.source, ('Callsign %s reclaimed from %s'):format(callsign, playerName))
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Callsign not found')
    end
    
end, false, {help = 'Reclaim a callsign', validate = true, arguments = {
    {name = 'callsign', help = 'Callsign to reclaim', type = 'string'}
}})

-- Clear Emergency Blips Command
ESX.RegisterCommand('clearblips', 'user', function(xPlayer, args, showError)
    if HasMDTAccess(xPlayer) then
        TriggerClientEvent('esx_mdt:client:clearBlips', xPlayer.source)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Emergency blips cleared')
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You do not have access to this command')
    end
end, false, {help = 'Clear emergency alert blips'})

-- Admin Commands for MDT System
ESX.RegisterCommand('addmdtsysadmin', 'admin', function(xPlayer, args, showError)
    local targetId = tonumber(args.target)
    
    if not targetId then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Usage: /addmdtsysadmin [player_id]')
        return
    end
    
    local targetPlayer = GetESXPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Player not found')
        return
    end
    
    -- Add system admin flag to player (you could store this in a separate table or metadata)
    MySQL.query('INSERT INTO mdt_people (identifier, firstname, lastname, flags) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE flags = ?', {
        targetPlayer.identifier,
        'System',
        'Admin', 
        json.encode({system_admin = true}),
        json.encode({system_admin = true})
    })
    
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'MDT System Admin granted to ' .. targetPlayer.getName())
    TriggerClientEvent('esx:showNotification', targetPlayer.source, 'You have been granted MDT System Admin privileges')
    
end, false, {help = 'Grant MDT System Admin privileges', validate = true, arguments = {
    {name = 'target', help = 'Player server ID', type = 'number'}
}})

ESX.RegisterCommand('removemdtsysadmin', 'admin', function(xPlayer, args, showError)
    local targetId = tonumber(args.target)
    
    if not targetId then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Usage: /removemdtsysadmin [player_id]')
        return
    end
    
    local targetPlayer = GetESXPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Player not found')
        return
    end
    
    -- Remove system admin flag
    MySQL.query('UPDATE mdt_people SET flags = ? WHERE identifier = ?', {
        json.encode({system_admin = false}),
        targetPlayer.identifier
    })
    
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'MDT System Admin revoked from ' .. targetPlayer.getName())
    TriggerClientEvent('esx:showNotification', targetPlayer.source, 'Your MDT System Admin privileges have been revoked')
    
end, false, {help = 'Revoke MDT System Admin privileges', validate = true, arguments = {
    {name = 'target', help = 'Player server ID', type = 'number'}
}})
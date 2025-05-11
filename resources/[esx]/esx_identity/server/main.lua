local playerIdentity = {}
local alreadyRegistered = {}
local multichar = ESX.GetConfig().Multichar

ESX.RegisterServerCallback('esx_identity:registerIdentity', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if not alreadyRegistered[xPlayer.identifier] then
            if checkNameFormat(data.firstname) and checkNameFormat(data.lastname) and checkSexFormat(data.sex) and checkDOBFormat(data.dateofbirth) and checkHeightFormat(data.height) then
                playerIdentity[xPlayer.identifier] = {
                    firstName = formatName(data.firstname),
                    lastName = formatName(data.lastname),
                    dateOfBirth = data.dateofbirth,
                    sex = data.sex,
                    height = data.height
                }
                local currentIdentity = playerIdentity[xPlayer.identifier]
                xPlayer.setName(('%s %s'):format(currentIdentity.firstName, currentIdentity.lastName))
                xPlayer.set('firstName', currentIdentity.firstName)
                xPlayer.set('lastName', currentIdentity.lastName)
                xPlayer.set('dateofbirth', currentIdentity.dateOfBirth)
                xPlayer.set('sex', currentIdentity.sex)
                xPlayer.set('height', currentIdentity.height)

                local userMeta = {
                    firstname = currentIdentity.firstName,
                    lastname = currentIdentity.lastName,
                    dateofbirth = currentIdentity.dateOfBirth,
                    height = currentIdentity.height,
                    sex = currentIdentity.sex,
                }
                xPlayer.setMeta('user', userMeta)
                saveIdentityToDatabase(xPlayer.identifier, currentIdentity)
                alreadyRegistered[xPlayer.identifier] = true
                playerIdentity[xPlayer.identifier] = nil
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        if multichar and checkNameFormat(data.firstname) and checkNameFormat(data.lastname) and checkSexFormat(data.sex) and checkDOBFormat(data.dateofbirth) and checkHeightFormat(data.height) then
            TriggerEvent('esx_identity:completedRegistration', source, data)
            cb(true)
        end
    end
end)

if Config.EnableCommands then
    ESX.RegisterCommand('char', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.getName() then
            xPlayer.showNotification(_U('active_character', xPlayer.getName()))
        else
            xPlayer.showNotification(_U('error_active_character'))
        end
    end, false, {help = _U('show_active_character')})

    ESX.RegisterCommand('chardel', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.getName() then
            if Config.UseDeferrals then
                xPlayer.kick(_('deleted_identity'))
                Citizen.Wait(1500)
                deleteIdentity(xPlayer)
                xPlayer.showNotification(_U('deleted_character'))
                playerIdentity[xPlayer.identifier] = nil
                alreadyRegistered[xPlayer.identifier] = false
            else
                deleteIdentity(xPlayer)
                xPlayer.showNotification(_U('deleted_character'))
                playerIdentity[xPlayer.identifier] = nil
                alreadyRegistered[xPlayer.identifier] = false
                TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
            end
        else
            xPlayer.showNotification(_U('error_delete_character'))
        end
    end, false, {help = _U('delete_character')})
end

if Config.EnableDebugging then
    ESX.RegisterCommand('xPlayerGetFirstName', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.get('firstName') then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_first_name', xPlayer.get('firstName')))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_first_name'))
        end
    end, false, {help = _U('debug_xPlayer_get_first_name')})

    ESX.RegisterCommand('xPlayerGetLastName', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.get('lastName') then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_last_name', xPlayer.get('lastName')))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_last_name'))
        end
    end, false, {help = _U('debug_xPlayer_get_last_name')})

    ESX.RegisterCommand('xPlayerGetFullName', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.getName() then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_full_name', xPlayer.getName()))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_full_name'))
        end
    end, false, {help = _U('debug_xPlayer_get_full_name')})

    ESX.RegisterCommand('xPlayerGetSex', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.get('sex') then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_sex', xPlayer.get('sex')))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_sex'))
        end
    end, false, {help = _U('debug_xPlayer_get_sex')})

    ESX.RegisterCommand('xPlayerGetDOB', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.get('dateofbirth') then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_dob', xPlayer.get('dateofbirth')))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_dob'))
        end
    end, false, {help = _U('debug_xPlayer_get_dob')})

    ESX.RegisterCommand('xPlayerGetHeight', 'user', function(xPlayer, args, showError)
        if xPlayer and xPlayer.get('height') then
            xPlayer.showNotification(_U('return_debug_xPlayer_get_height', xPlayer.get('height')))
        else
            xPlayer.showNotification(_U('error_debug_xPlayer_get_height'))
        end
    end, false, {help = _U('debug_xPlayer_get_height')})
end

function deleteIdentity(xPlayer)
    if alreadyRegistered[xPlayer.identifier] then
        xPlayer.setName(('%s %s'):format(nil, nil))
        xPlayer.set('firstName', nil)
        xPlayer.set('lastName', nil)
        xPlayer.set('dateofbirth', nil)
        xPlayer.set('sex', nil)
        xPlayer.set('height', nil)

        deleteIdentityFromDatabase(xPlayer)
    end
end

function saveIdentityToDatabase(identifier, identity)
    MySQL.Sync.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height WHERE identifier = @identifier', {
        ['@identifier']  = identifier,
        ['@firstname'] = identity.firstName,
        ['@lastname'] = identity.lastName,
        ['@dateofbirth'] = identity.dateOfBirth,
        ['@sex'] = identity.sex,
        ['@height'] = identity.height
    })
end

function deleteIdentityFromDatabase(xPlayer)
    MySQL.Sync.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height , skin = @skin WHERE identifier = @identifier', {
        ['@identifier']  = xPlayer.identifier,
        ['@firstname'] = NULL,
        ['@lastname'] = NULL,
        ['@dateofbirth'] = NULL,
        ['@sex'] = NULL,
        ['@height'] = NULL,
        ['@skin'] = NULL
    })

    if Config.FullCharDelete then
        MySQL.Sync.execute('UPDATE addon_account_data SET money = 0 WHERE account_name = @account_name AND owner = @owner', {
            ['@account_name'] = 'bank_savings',
            ['@owner'] = xPlayer.identifier
        })

        MySQL.Sync.execute('UPDATE addon_account_data SET money = 0 WHERE account_name = @account_name AND owner = @owner', {
            ['@account_name'] = 'caution',
            ['@owner'] = xPlayer.identifier
        })

        MySQL.Sync.execute('UPDATE datastore_data SET data = @data WHERE name = @name AND owner = @owner', {
            ['@data'] = '\'{}\'',
            ['@name'] = 'user_ears',
            ['@owner'] = xPlayer.identifier
        })

        MySQL.Sync.execute('UPDATE datastore_data SET data = @data WHERE name = @name AND owner = @owner', {
            ['@data'] = '\'{}\'',
            ['@name'] = 'user_glasses',
            ['@owner'] = xPlayer.identifier
        })

        MySQL.Sync.execute('UPDATE datastore_data SET data = @data WHERE name = @name AND owner = @owner', {
            ['@data'] = '\'{}\'',
            ['@name'] = 'user_helmet',
            ['@owner'] = xPlayer.identifier
        })

        MySQL.Sync.execute('UPDATE datastore_data SET data = @data WHERE name = @name AND owner = @owner', {
            ['@data'] = '\'{}\'',
            ['@name'] = 'user_mask',
            ['@owner'] = xPlayer.identifier
        })
    end
end

function checkNameFormat(name)
    if not checkAlphanumeric(name) then
        if not checkForNumbers(name) then
            local stringLength = string.len(name)
            if stringLength > 0 and stringLength < Config.MaxNameLength then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function checkDOBFormat(dob)
    local date = tostring(dob)
    if checkDate(date) then
        return true
    else
        return false
    end
end

function checkSexFormat(sex)
    if sex == "m" or sex == "M" or sex == "f" or sex == "F" then
        return true
    else
        return false
    end
end

function checkHeightFormat(height)
    local numHeight = tonumber(height)
    if numHeight < Config.MinHeight or numHeight > Config.MaxHeight then
        return false
    else
        return true
    end
end

function formatName(name)
    local loweredName = convertToLowerCase(name)
    local formattedName = convertFirstLetterToUpper(loweredName)
    return formattedName
end

function convertToLowerCase(str)
    return string.lower(str)
end

function convertFirstLetterToUpper(str)
    return str:gsub("^%l", string.upper)
end

function checkAlphanumeric(str)
    return (string.match(str, "%W"))
end

function checkForNumbers(str)
    return (string.match(str,"%d"))
end

function checkDate(str)
    if string.match(str, '(%d%d%d%d)/(%d%d)/(%d%d)') ~= nil then
        local y, m, d = string.match(str, '(%d+)/(%d+)/(%d+)')
        y = tonumber(y)
        m = tonumber(m)
        d = tonumber(d)
        if ((d <= 0) or (d > 31)) or ((m <= 0) or (m > 12)) or ((y <= Config.LowestYear) or (y > Config.HighestYear)) then
            return false
        elseif m == 4 or m == 6 or m == 9 or m == 11 then
            if d > 30 then
                return false
            else
                return true
            end
        elseif m == 2 then
            if y%400 == 0 or (y%100 ~= 0 and y%4 == 0) then
                if d > 29 then
                    return false
                else
                    return true
                end
            else
                if d > 28 then
                    return false
                else
                    return true
                end
            end
        else
            if d > 31 then
                return false
            else
                return true
            end
        end
    else
        return false
    end
end

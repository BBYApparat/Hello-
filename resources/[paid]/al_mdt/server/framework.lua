
if Config.UsingQBCore then
    QBCore = exports['qb-core']:GetCoreObject()

    function DecodeCharInfo(player)
        player.charinfo = json.decode(player.charinfo)
        return player
    end

    SQL.SyncFetch = function(...)
        return exports.oxmysql:executeSync(...)
    end

    SQL.AsyncExecute = function(...)
        exports.oxmysql:execute(...)
    end

    SQL.AsyncInsert = function(...)
        exports.oxmysql:insert(...)
    end
elseif Config.UsingESX then
    ESX = nil; TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    SQL.SyncFetch = function(...)
        return MySQL.Sync.fetchAll(...)
    end

    SQL.AsyncExecute = function(...)
        MySQL.Async.execute(...)
    end

    SQL.AsyncInsert = function(...)
        MySQL.Async.insert(...)
    end
else
    -- Integrate your own SQL system or use the ones from above
    SQL.SyncFetch = function(...)
        
    end

    SQL.AsyncExecute = function(...)
        
    end

    SQL.AsyncInsert = function(...)
        
    end
end

function RemoveMoney(src, amount, forced)
    if Config.UsingESX then -- ESX Method
        local xPlayer = ESX.GetPlayerFromId(src)

        if xPlayer then
            if forced then -- Remove money regardless of amount player has (Used for overdue fines -- in config)
                xPlayer.removeMoney(amount)
                SendSocietyMoney(amount)
                return true
            else
                if xPlayer.getMoney() >= amount then
                    xPlayer.removeMoney(amount)
                    SendSocietyMoney(amount)
                    return true
                end
            end
        end

        return false
    elseif Config.UsingQBCore then -- QBCore Method
        local xPlayer = QBCore.Functions.GetPlayer(src)

        if xPlayer then
            if forced then -- Remove money regardless of amount player has (Used for overdue fines -- in config)
                xPlayer.Functions.RemoveMoney('bank', amount, 'Fine payment')
                SendSocietyMoney(amount)
                return true
            else
                if xPlayer.PlayerData.money['cash'] >= amount then
                    xPlayer.Functions.RemoveMoney('cash', amount, 'Fine payment')
                    SendSocietyMoney(amount)
                    return true
                end
            end
        end

        return false
    else
        -- Setup your own system that reflects your framework
    end
end

function SendSocietyMoney(amount)
    if Config.Society.enabled and string.len(Config.Society.account) > 0 then
        if Config.UsingESX then
            TriggerEvent('esx_addonaccount:getSharedAccount', Config.Society.account, function(account)
				account.addMoney(amount)
			end)
        elseif Config.UsingQBCore then
            exports['qb-management']:AddMoney(Config.Society.account, amount)
        else
            -- Setup your own system that reflects your framework
        end
    end
end

function GrantLicense(src, target, license)
    if Config.UsingESX then
        local xPlayer = ESX.GetPlayerFromIdentifier(target)

        if xPlayer then
            TriggerEvent('esx_license:addLicense', xPlayer.source, license)
            GrantedLicenseAlert(src, target, license)
            return true
        end
    elseif Config.UsingQBCore then
        local xPlayer = QBCore.Functions.GetPlayerByCitizenId(target)

        if xPlayer then
            local licenseTable = xPlayer.PlayerData.metadata['licences']
            licenseTable[license] = true

            xPlayer.Functions.SetMetaData('licences', licenseTable)
            GrantedLicenseAlert(src, target, license)
            return true
        end
    else
        -- Setup your own system that reflects your framework
    end

    return false
end

function JailPlayer(src, identifier, reason, time)
    -- Note: 'src' is the player submitting the report
    -- 'time' is measured out in minutes
    -- 'reason' will return false if Config.MDT.General.JailReason is false

    if Config.UsingESX then -- ESX Method
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier) -- For player id, use xPlayer.source

        -- Use your jailing script here 
    elseif Config.UsingQBCore then -- QBCore Method
        local xPlayer = QBCore.Functions.GetPlayerByCitizenId(identifier) -- For player id, use xPlayer.PlayerData.source

        -- Use your jailing script here 
    else
        -- Setup your own system that reflects your framework
    end
end

function FetchCharName(identifier)
    if Config.UsingESX then -- ESX Method
        local resp = DbQueries.characters.FetchCharName(identifier)
        
        return resp and ('%s %s'):format(resp.firstname, resp.lastname) or false
    elseif Config.UsingQBCore then -- QBCore Method
        local resp = DbQueries.characters.FetchCharName(identifier)
        resp = DecodeCharInfo(resp)

        return resp and ('%s %s'):format(resp.charinfo.firstname, resp.charinfo.lastname) or false
    else
        -- Setup your own system that reflects your framework
    end
end

-- Database Queries --
if Config.UsingESX then -- ESX Method
    Citizen.CreateThread(function()
        DbQueries.characters = {
            FetchCharName = function(identifier)
                return SQL.SyncFetch('SELECT firstname, lastname FROM `users` WHERE identifier = @identifier', { ['identifier'] = identifier })[1]
            end,
    
            FetchByName = function(firstName, lastName, gender)
                local firstNameMatches = {}; local lastNameMatches = {}
    
                firstName = string.lower(firstName); lastName = string.lower(lastName) -- Make names lowercase to match accurately
    
                if gender then
                    -- Format gender string
                    gender = gender == 'Male' and 'm' or 'f'

                    if firstName ~= '' then
                        firstNameMatches = SQL.SyncFetch('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE LOWER(firstname) LIKE @firstName AND sex LIKE @gender', {
                            ['firstName'] = ('%%%s%%'):format(firstName),
                            ['gender'] = gender,
                        })
                    end

                    if lastName ~= '' then
                        lastNameMatches = SQL.SyncFetch('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE LOWER(lastname) LIKE @lastName AND sex LIKE @gender', {
                            ['lastName'] = ('%%%s%%'):format(lastName),
                            ['gender'] = gender,
                        })
                    end
                else
                    if firstName ~= '' then
                        firstNameMatches = SQL.SyncFetch('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE LOWER(firstname) LIKE @firstName', {
                            ['firstName'] = ('%%%s%%'):format(firstName),
                        })
                    end

                    if lastName ~= '' then
                        lastNameMatches = SQL.SyncFetch('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE LOWER(lastname) LIKE @lastName', {
                            ['lastName'] = ('%%%s%%'):format(lastName),
                        })
                    end
                end
    
                local finalResults = {}
                for i=1, #firstNameMatches do
                    table.insert(finalResults, firstNameMatches[i])
                end
    
                for i=1, #lastNameMatches do
                    local duplicateFound = false
                    for index=1, #finalResults do
                        if lastNameMatches[i].identifier == finalResults[index].identifier then
                            duplicateFound = true
                            break
                        end
                    end
    
                    if not duplicateFound then
                        table.insert(finalResults, lastNameMatches[i])
                    end
                end
    
                -- Format data
                local resp = {}
                for i=1, #finalResults do
                    local player = finalResults[i]
                    table.insert(resp, {
                        identifier = player.identifier,
                        firstName = player.firstname,
                        lastName = player.lastname,
                        dob = player.dateofbirth,
                        sex = player.sex == 'm' and 'Male' or 'Female',
                    })
                end
    
                return resp
            end,
    
            FetchByIdentifier = function(identifier)
                local result = SQL.SyncFetch('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE identifier = @identifier', { ['identifier'] = identifier })[1]
    
                if result then
                    -- Format data
                    local resp = {
                        identifier = result.identifier,
                        firstName = result.firstname,
                        lastName = result.lastname,
                        dob = result.dateofbirth,
                        sex = result.sex == 'm' and 'Male' or 'Female',
                    }
    
                    return resp
                else
                    return false
                end
            end,
    
            FetchLicenses = function(identifier)
                local licenses = SQL.SyncFetch('SELECT type FROM `user_licenses` WHERE owner = @identifier', {
                    ['identifier'] = identifier,
                })
                local formattedArray = {}
    
                -- Accepts all license types except for written test. You can remove this for loop if you want to include that
                for i=1, #licenses do
                    local license = licenses[i].type
                    if license ~= 'dmv' then
                        table.insert(formattedArray, license)
                    end
                end
    
                return formattedArray
            end,
    
            FetchOwnedVehicles = function(identifier)
                local resp = SQL.SyncFetch('SELECT plate FROM `owned_vehicles` WHERE owner = @identifier', {
                    ['identifier'] = identifier,
                })
    
                return resp
            end,
    
            FetchVehicleOwnerByPlate = function(plate)
                return SQL.SyncFetch('SELECT owner FROM `owned_vehicles` WHERE plate = @plate', {['plate'] = plate})[1].owner
            end,
    
            RevokeLicense = function(identifier, license)
                SQL.AsyncExecute('DELETE FROM `user_licenses` WHERE `owner` = @identifier AND `type` = @license;',
                {
                    ['identifier'] = identifier,
                    ['license'] = license,
                }, function(affectedRows) print('Deleted licenses: '..affectedRows) end)
            end
        }

        DbQueries.vehProfiles.FetchVehicles = function(plate)
            local resp = SQL.SyncFetch('SELECT plate FROM `owned_vehicles` WHERE plate LIKE @plate', {
                ['plate'] = ('%%%s%%'):format(plate),
            })

            return resp
        end
    end)
elseif Config.UsingQBCore then -- QBCore Method
    Citizen.CreateThread(function()
        DbQueries.characters = {
            FetchCharName = function(identifier)
                return SQL.SyncFetch('SELECT charinfo FROM `players` WHERE citizenid = @identifier', { ['identifier'] = identifier })[1]
            end,
    
            FetchByName = function(firstName, lastName, gender)
                local firstNameMatches = {}; local lastNameMatches = {}
    
                firstName = string.lower(firstName); lastName = string.lower(lastName) -- Make names lowercase to match accurately
    
                if gender then
                    -- Format gender string
                    gender = (gender == 'Male') and 0 or 1
    
                    if firstName ~= '' then
                        firstNameMatches = SQL.SyncFetch('SELECT citizenid, charinfo FROM `players` WHERE JSON_VALUE(charinfo, "$.firstname") LIKE @firstName AND JSON_VALUE(charinfo, "$.gender") LIKE @gender', {
                            ['firstName'] = ('%%%s%%'):format(firstName),
                            ['gender'] = gender,
                        })
                    end

                    if lastName ~= '' then
                        lastNameMatches = SQL.SyncFetch('SELECT citizenid, charinfo FROM `players` WHERE JSON_VALUE(charinfo, "$.lastname") LIKE @lastName AND JSON_VALUE(charinfo, "$.gender") LIKE @gender', {
                            ['lastName'] = ('%%%s%%'):format(lastName),
                            ['gender'] = gender,
                        })
                    end
                else
                    if firstName ~= '' then
                        firstNameMatches = SQL.SyncFetch('SELECT citizenid, charinfo FROM `players` WHERE JSON_VALUE(charinfo, "$.firstname") LIKE @firstName', {
                            ['firstName'] = ('%%%s%%'):format(firstName),
                        })
                    end

                    if lastName ~= '' then
                        lastNameMatches = SQL.SyncFetch('SELECT citizenid, charinfo FROM `players` WHERE JSON_VALUE(charinfo, "$.lastname") LIKE @lastName', {
                            ['lastName'] = ('%%%s%%'):format(lastName),
                        })
                    end
                end
    
                local finalResults = {}
                for i=1, #firstNameMatches do
                    table.insert(finalResults, firstNameMatches[i])
                end
    
                for i=1, #lastNameMatches do
                    local duplicateFound = false
                    for index=1, #finalResults do
                        if lastNameMatches[i].citizenid == finalResults[index].citizenid then
                            duplicateFound = true
                            break
                        end
                    end
    
                    if not duplicateFound then
                        table.insert(finalResults, lastNameMatches[i])
                    end
                end
    
                -- Format data
                local resp = {}
                for i=1, #finalResults do
                    local player = finalResults[i]
                    player = DecodeCharInfo(player)
    
                    table.insert(resp, {
                        identifier = player.citizenid,
                        firstName = player.charinfo.firstname,
                        lastName = player.charinfo.lastname,
                        dob = player.charinfo.birthdate,
                        sex = player.charinfo.gender == 0 and 'Male' or 'Female',
                    })
                end
    
                return resp
            end,
    
            FetchByIdentifier = function(identifier)
                local result = SQL.SyncFetch('SELECT citizenid, charinfo FROM `players` WHERE citizenid = @identifier', { ['identifier'] = identifier })[1]
                result = DecodeCharInfo(result)
    
                if result then
                    -- Format data
                    local resp = {
                        identifier = result.citizenid,
                        firstName = result.charinfo.firstname,
                        lastName = result.charinfo.lastname,
                        dob = result.charinfo.birthdate,
                        sex = result.charinfo.gender == 0 and 'Male' or 'Female',
                    }
    
                    return resp
                else
                    return false
                end
            end,
    
            FetchLicenses = function(identifier)
                local xPlayer = QBCore.Functions.GetPlayerByCitizenId(identifier)
                local licenses = {}
                if xPlayer then -- If player online
                    local licenseTable = xPlayer.PlayerData.metadata['licences'] or {}

                    for i,v in pairs(licenseTable) do
                        if v then
                            table.insert(licenses, i)
                        end
                    end
                else -- If player offline
                    local resp = SQL.SyncFetch('SELECT metadata FROM `players` WHERE citizenid = @identifier', {
                        ['identifier'] = identifier,
                    })[1]
    
                    for i,v in pairs(json.decode(resp.metadata).licences) do
                        if v then
                            table.insert(licenses, i)
                        end
                    end
                end

                return licenses
            end,
    
            FetchOwnedVehicles = function(identifier)
                local resp = SQL.SyncFetch('SELECT plate FROM `player_vehicles` WHERE citizenid = @identifier', {
                    ['identifier'] = identifier,
                })
    
                return resp
            end,
    
            FetchVehicleOwnerByPlate = function(plate)
                return SQL.SyncFetch('SELECT citizenid FROM `player_vehicles` WHERE plate = @plate', {['plate'] = plate})[1].citizenid
            end,
    
            RevokeLicense = function(identifier, license)
                local xPlayer = QBCore.Functions.GetPlayerByCitizenId(identifier)

                if xPlayer then -- If player online
                    local licenseTable = xPlayer.PlayerData.metadata['licences']

                    if licenseTable[license] then
                        licenseTable[license] = false

                        xPlayer.Functions.SetMetaData('licences', licenseTable)
                        print(('Removed "%s" license from online player (%s)'):format(license, identifier))
                    end
                else -- If player offline
                    local resp = SQL.SyncFetch('SELECT metadata FROM `players` WHERE citizenid = @identifier', {
                        ['identifier'] = identifier,
                    })[1]
    
                    if resp then
                        resp.metadata = json.decode(resp.metadata)
    
                        if resp.metadata.licences[license] then
                            resp.metadata.licences[license] = false

                            SQL.AsyncExecute('UPDATE `players` SET metadata = @metadata WHERE citizenid = @identiifer',
                                {
                                    ['identifier'] = id,
                                    ['metadata']   = json.encode(resp.metadata),
                                },
                            function(affectedRows)
                                print(('Removed "%s" license from offline player (%s)'):format(license, identifier))
                            end)
                        end
                    end
                end
            end
        }

        DbQueries.vehProfiles.FetchVehicles = function(plate)
            local resp = SQL.SyncFetch('SELECT plate FROM `player_vehicles` WHERE plate LIKE @plate', {
                ['plate'] = ('%%%s%%'):format(plate),
            })

            return resp
        end
    end)
else
    -- Setup your own system that reflects your framework (Use the others as guidance)
    Citizen.CreateThread(function()
        DbQueries.characters = {
            FetchCharName = function(identifier)
                
            end,
    
            FetchByName = function(firstName, lastName, gender)
                
            end,
    
            FetchByIdentifier = function(identifier)
                
            end,
    
            FetchLicenses = function(identifier)
                
            end,
    
            FetchOwnedVehicles = function(identifier)
                
            end,
    
            FetchVehicleOwnerByPlate = function(plate)
                
            end,
    
            RevokeLicense = function(identifier, license)
                
            end
        }
    end)
end
function FetchCharactersByName(firstName, lastName, gender) -- Fetch characters by name and gender filter
    if firstName ~= nil and lastName ~= nil then
        local resp = DbQueries.characters.FetchByName(firstName, lastName, gender)

        for i=1, #resp do
            local char = resp[i]

            local finalResults = {
                identifier = char.identifier,
                firstName = char.firstName,
                lastName = char.lastName,
                dob = char.dob,
                sex = char.sex,
                photoId = '',
                contact = {
                    phone = '',
                    address = '',
                    relatedTo = {}
                },
                notes = '',
            }

            resp[i] = finalResults
        end

        return resp
    else
        return false
    end
end

function FetchCharacter(identifier) -- Fetch character
    if identifier ~= nil then
        local resp = DbQueries.characters.FetchByIdentifier(identifier)

        if resp then
            local char = resp

            char = {
                identifier = char.identifier,
                firstName = char.firstName,
                lastName = char.lastName,
                dob = char.dob,
                sex = char.sex,
                photoId = '',
                contact = {
                    phone = '',
                    address = '',
                    relatedTo = {}
                },
                notes = '',
            }

            return char
        else
            return false
        end

    else
        return false
    end
end

function FetchCharacterLicenses(identifier) -- Fetch character licenses
    return DbQueries.characters.FetchLicenses(identifier)
end
RegisterCallback('al_mdt:FetchCharacterLicenses', function(source, ...)
    TriggerProtFunction('FetchCharacterLicenses', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchCharacterLicenses(...))
        end
    end, ...)
end)

RegisterCallback('al_mdt:FetchCharName', function(source, ...)
    TriggerProtFunction('FetchCharName', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchCharName(...))
        end
    end, ...)
end)

function RevokeLicense(src, identifier, license) -- Revoke license
    if identifier ~= nil and license ~= nil then
        DbQueries.characters.RevokeLicense(identifier, license)
        RevokedLicenseAlert(src, identifier, license)
    end
end
RegisterNetEvent('al_mdt:RevokeLicense', function(...)
    TriggerProtFunction('RevokeLicense', source, function(src, key, ...)
        if VerifyKey(src, key) then
            RevokeLicense(src, ...)
        end
    end, ...)
end)

RegisterCallback('al_mdt:GrantLicense', function(source, ...) -- Grant license
    TriggerProtFunction('GrantLicense', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(GrantLicense(src, ...))
        end
    end, ...)
end)
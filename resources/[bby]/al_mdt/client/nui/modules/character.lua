RegisterNUICallback('getCharacterByName', function(data, cb)
    TriggerServerCallback('al_mdt:FetchProfilesByName', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, data.firstName, data.lastName, data.gender)
end)

RegisterNUICallback('getCharacterDetailedProfile', function(data, cb)
    TriggerServerCallback('al_mdt:FetchDetailedProfile', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, data.identifier)
end)

RegisterNUICallback('getCriminalRecord', function(identifier, cb)
    TriggerServerCallback('al_mdt:FetchRecord', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, identifier)
end)


RegisterNUICallback('getCharacterLicenses', function(data, cb)
    TriggerServerCallback('al_mdt:FetchCharacterLicenses', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, data.identifier)
end)

RegisterNUICallback('revokeLicense', function(data, cb)
    TriggerServerEvent('al_mdt:RevokeLicense', mdt.k, data.identifier, data.license)

    cb({})
end)

RegisterNUICallback('grantLicense', function(data, cb)
    TriggerServerCallback('al_mdt:GrantLicense', function(resp)
        cb(resp)
    end, mdt.k, data.identifier, data.license)
end)
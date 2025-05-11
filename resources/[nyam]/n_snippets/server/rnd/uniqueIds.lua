RegisterNetEvent('esx:playerLoaded', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local shouldUpdateMetadata = false

        if not xPlayer.metadata.citizenId then
            local cid = CreateCitizenId()
            xPlayer.setMeta('citizenId', cid)
            shouldUpdateMetadata = true
        end
        if not xPlayer.metadata.fingerprintId then
            local fnid = CreateFingerId()
            xPlayer.setMeta('fingerprintId', fnid)
            shouldUpdateMetadata = true
        end
        if shouldUpdateMetadata then
            xPlayer = ESX.GetPlayerFromId(_source)
            print('User: ' .. GetPlayerName(xPlayer.source) .. ', Character: ' .. xPlayer.name
                ..'\nGot new Identities for Citizen ID & Fingerprint ID.'
                ..'\nCitizen ID: ' .. xPlayer.metadata.citizenId .. ', Fingerprint ID: ' .. xPlayer.metadata.fingerprintId)
        end
    end
end)

function CreateCitizenId()
    local CitizenId = tostring(ESX.GetRandomString(3) .. math.random(10000, 99999)):upper()
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM users WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.citizenid")) = ?) AS uniqueCheck', { CitizenId })
    if result == 0 then return CitizenId end
    return CreateCitizenId()
end

function CreateFingerId()
    local FingerId = tostring(ESX.GetRandomString(2) .. math.random(100, 999) .. ESX.GetRandomString(1) .. math.random(10, 99) .. ESX.GetRandomString(3) .. math.random(1000, 9999))
    local result = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM users WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata, "$.fingerprint")) = ?) AS uniqueCheck', { FingerId })
    if result == 0 then return FingerId end
    return CreateFingerId()
end
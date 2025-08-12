-- Bolos/Warrants --
function FetchBolos() -- Bolo fetch
    local response = {
        persons = DbQueries.bolos.person.fetchAll(),
        vehicles = DbQueries.bolos.vehicle.fetchAll(),
        warrants = DbQueries.warrants.fetchAll()
    }

    return response
end
RegisterCallback('al_mdt:FetchBolos', function(source, ...)
    TriggerProtFunction('FetchBolos', source, function(src, cb, key)
        if VerifyKey(src, key) then
            cb(FetchBolos())
        end
    end, ...)
end)

function AddBolo(src, type, ...) -- Bolo add
    if type == 'vehicle' then
        DbQueries.bolos.vehicle.Add(function(creator, plate)
            SyncBolos(src, type)
            BoloAddedAlert(src, type, creator, plate)
        end, ...)
    elseif type == 'person' then
        DbQueries.bolos.person.Add(function(creator, name)
            SyncBolos(src, type)
            BoloAddedAlert(src, type, creator, name)
        end, ...)
    elseif type == 'warrant' then
        DbQueries.warrants.Add(function(creator, name)
            SyncBolos(src, type)
            BoloAddedAlert(src, type, creator, name)
        end, ...)
    end
end
RegisterNetEvent('al_mdt:AddBolo', function(...)
    TriggerProtFunction('AddBolo', source, function(src, key, ...)
        if VerifyKey(src, key) then
            AddBolo(src, ...)
        end
    end, ...)
end)

function UpdateBolo(src, type, id, name, ...) -- Bolo update
    if type == 'vehicle' then
        local plate = name
        DbQueries.bolos.vehicle.Update(id, plate, ...)
        BoloUpdatedAlert(src, type, id, plate)
    elseif type == 'person' then
        DbQueries.bolos.person.Update(id, name, ...)
        BoloUpdatedAlert(src, type, id, name)
    elseif type == 'warrant' then
        DbQueries.warrants.Update(id, name, ...)
        BoloUpdatedAlert(src, type, id, name)
    end
end
RegisterNetEvent('al_mdt:UpdateBolo', function(...)
    TriggerProtFunction('UpdateBolo', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateBolo(src, ...)
        end
    end, ...)
end)

function RemoveBolo(src, type, id) -- Remove bolo
    if type and id then
        if type == 'vehicle' then
            DbQueries.bolos.vehicle.Remove(id)
        elseif type == 'person' then
            DbQueries.bolos.person.Remove(id)
        elseif type == 'warrant' then
            DbQueries.warrants.Remove(id)
        end
        BoloDeletedAlert(src, type, id)
    end
end
RegisterNetEvent('al_mdt:RemoveBolo', function(...)
    TriggerProtFunction('RemoveBolo', source, function(src, key, ...)
        if VerifyKey(src, key) then
            RemoveBolo(src, ...)
        end
    end, ...)
end)

-- Syncing with clients
function SyncBolos(player, type)
    local bolos = {
        persons = DbQueries.bolos.person.FetchAll(),
        vehicles = DbQueries.bolos.vehicle.FetchAll(),
        warrants = DbQueries.warrants.FetchAll()
    }

    for identifier,v in pairs(onlineUsers) do
        if (player and player ~= v.id) then
            TriggerClientEvent('al_mdt:SyncBolos', v.id, {
                bolos = bolos,
                type = type,
            })
        else
            TriggerClientEvent('al_mdt:SyncBolos', v.id, {
                bolos = bolos,
            })
        end
    end
end
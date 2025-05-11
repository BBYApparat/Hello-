RegisterNUICallback('addBolo', function(data, cb)
    -- data.type -> 'vehicle', 'person', or 'warrant'
    -- data.entry -> Bolo data (varies per type)

    if data.type then
        if data.type == 'vehicle' then
            TriggerServerEvent('al_mdt:AddBolo',
                mdt.k,
                data.type,
                data.creator,
                data.plate,
                data.model,
                data.lastSeen,
                data.color,
                data.description,
                data.reason,
                data.notes,
                data.date
            )
        elseif data.type == 'person' or data.type == 'warrant' then
            TriggerServerEvent('al_mdt:AddBolo',
                mdt.k,
                data.type,
                data.creator,
                data.name,
                data.lastSeen,
                data.reason,
                data.description,
                data.notes,
                data.date,
                data.targetIdentifier
            )
        end
    end

    cb({}) -- Required cb to web app
end)

RegisterNUICallback('updateBolo', function(data, cb)
    -- data.type -> 'vehicle', 'person', or 'warrant'
    -- data.entry -> Bolo data (varies per type)

    if data.type then
        if data.type == 'vehicle' then
            TriggerServerEvent('al_mdt:UpdateBolo',
                mdt.k,
                data.type,
                data.id,
                data.plate,
                data.model,
                data.lastSeen,
                data.color,
                data.description,
                data.reason,
                data.notes,
                data.date
            )
        elseif data.type == 'person' or data.type == 'warrant' then
            TriggerServerEvent('al_mdt:UpdateBolo',
                mdt.k,
                data.type,
                data.id,
                data.name,
                data.lastSeen,
                data.reason,
                data.description,
                data.notes,
                data.date,
                data.targetIdentifier
            )
        end
    end

    cb({}) -- Required cb to web app
end)

RegisterNUICallback('removeBolo', function(data, cb)
    -- data.type -> 'vehicle', 'person', or 'warrant'
    -- data.id -> Bolo id

    if data.type then
        TriggerServerEvent('al_mdt:RemoveBolo',
            mdt.k,
            data.type,
            data.id
        )
    end

    cb({}) -- Required cb to web app
end)

-- Sync to client
RegisterNetEvent('al_mdt:SyncBolos', function(data)
    SendNUIMessage({
        type = 'SyncBolos',
        bolos = data.bolos,
        boloType = data.type or false
    })
end)
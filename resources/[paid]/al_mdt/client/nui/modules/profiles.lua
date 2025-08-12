-- Characters
RegisterNUICallback('updateProfile', function(data, cb)
    if data.identifier then
        TriggerServerEvent('al_mdt:UpdateProfile',
            mdt.k,
            data.identifier,
            data.photoId,
            data.contact,
            data.notes
        )
    end

    cb({}) -- Required cb to web app
end)

-- Vehicle
RegisterNUICallback('getVehProfile', function(plate, cb)
    TriggerServerCallback('al_mdt:FetchVehProfile', function(resp)
        --[[
            resp.plate
            resp.model
            resp.color
            resp.photoId
            resp.notes

            resp.ownerIdentifier
            resp.owner = {
                firstName,
                lastName,
                dob,
                sex
            }
        ]]
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, plate)
end)

RegisterNUICallback('updateVehProfile', function(data, cb)
    if data.plate then
        TriggerServerEvent('al_mdt:UpdateVehProfile',
            mdt.k,
            data.plate,
            data.model,
            data.color,
            data.photoId,
            data.notes
        )
    end

    cb({}) -- Required cb to web app
end)

RegisterNUICallback('getVehiclePlates', function(data, cb)
    TriggerServerCallback('al_mdt:FetchVehiclePlates', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, data.plate)
end)
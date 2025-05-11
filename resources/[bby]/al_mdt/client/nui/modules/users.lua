RegisterNUICallback('setStatus', function(data, cb)
    TriggerServerEvent('al_mdt:SetStatus', mdt.k, data.identifier, data.status)

    cb({})
end)

RegisterNUICallback('goOnDuty', function(data, cb)
    TriggerServerEvent('al_mdt:GoOnDuty', mdt.k, data.identifier, data.job, data.time)
    TriggerEvent('al_mdt:ClockedIn')

    cb({})
end)

RegisterNUICallback('goOffDuty', function(data, cb)
    TriggerServerEvent('al_mdt:GoOffDuty', mdt.k, data.identifier, data.time)
    TriggerEvent('al_mdt:ClockedOut')

    cb({})
end)

RegisterNUICallback('setGPS', function(identifier, cb)
    TriggerServerCallback('al_mdt:SetGPS', function(coords)
        SetNewWaypoint(coords.x, coords.y)
    end, mdt.k, identifier)

    cb({})
end)

RegisterNUICallback('getJobActivity', function(data, cb)
    TriggerServerCallback('al_mdt:GetJobActivity', function(resp)
        cb(resp)
    end, mdt.k, data.job, data.page, data.getTotal, data.date)
end)

RegisterNUICallback('getActivityStatistics', function(data, cb)
    TriggerServerCallback('al_mdt:GetActivityStatistics', function(resp)
        cb(resp)
    end, mdt.k, data.identifier, data.job)
end)

RegisterNUICallback('getActivityLog', function(data, cb)
    TriggerServerCallback('al_mdt:GetActivityLog', function(resp)
        cb(resp)
    end, mdt.k, data.identifier, data.job, data.page, data.getTotal)
end)

RegisterNUICallback('setUserCallsign', function(data, cb)
    TriggerServerEvent('al_mdt:SetUserCallsign', mdt.k, data.identifier, data.callsign)

    cb({})
end)

-- Sync to client
RegisterNetEvent('al_mdt:SyncUsers', function(data)
    SendNUIMessage({
        type = 'SyncUsers',
        data = data,
    })
end)
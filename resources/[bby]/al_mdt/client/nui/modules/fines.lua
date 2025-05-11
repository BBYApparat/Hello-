RegisterNUICallback('payFine', function(data, cb)
    TriggerServerCallback('al_mdt:PayFine', function(resp)
        cb(resp)
    end, mdt.k, data.id, data.fine)
end)

RegisterNUICallback('exemptFine', function(data, cb)
    TriggerServerEvent('al_mdt:ExemptFine', mdt.k, data)
end)


RegisterNUICallback('fetchFines', function(identifier, cb)
    TriggerServerCallback('al_mdt:FetchFines', function(resp) -- Returns all of the characters' fines
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, identifier)
end)


RegisterNUICallback('fetchDetailedFine', function(id, cb)
    TriggerServerCallback('al_mdt:FetchFine', function(resp) -- Returns details about a single fine
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, id)
end)

function CheckOverdueFines()
    TriggerServerCallback('al_mdt:CheckOverdueFines', function(resp) -- Returns amount paid in fines
        if resp then
            ShowNotification(('$%s of overdue unpaid fines were automatically paid!'):format(FormatNumber(resp)), 'primary', 10000)
        end
    end, mdt.k, GetIdentifier())
end
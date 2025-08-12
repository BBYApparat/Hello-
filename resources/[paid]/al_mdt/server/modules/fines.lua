function PayFine(src, id, fine, forced)
    if id and fine then
        if RemoveMoney(src, fine, forced) then
            UpdateFine(id, false, false, 1)
            FinePayedAlert(src, id, fine)
            return true
        end
    end

    return false
end
RegisterCallback('al_mdt:PayFine', function(source, ...)
    TriggerProtFunction('PayFine', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(PayFine(src, ...))
        end
    end, ...)
end)

function ExemptFine(src, id)
    if id then
        UpdateFine(id, false, false, 1)
        FineExemptedAlert(src, id)
    end
end
RegisterNetEvent('al_mdt:ExemptFine', function(...)
    TriggerProtFunction('ExemptFine', source, function(src, key, ...)
        if VerifyKey(src, key) then
            ExemptFine(src, ...)
        end
    end, ...)
end)

function UpdateFine(id, fine, dueDate, paid)
    if id and (fine or dueDate or paid) then
        DbQueries.fines.Update(id, fine, dueDate, paid)
    end
end
RegisterNetEvent('al_mdt:UpdateFine', function(...)
    TriggerProtFunction('UpdateFine', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateFine(...)
        end
    end, ...)
end)

function FetchFines(identifier)
    if identifier then
        return DbQueries.fines.FetchAll(identifier)
    else
        return false
    end
end
RegisterCallback('al_mdt:FetchFines', function(source, ...)
    TriggerProtFunction('FetchFines', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchFines(...))
        end
    end, ...)
end)

function FetchFine(id)
    if id then
        local fine = DbQueries.fines.Fetch(id)

        if fine then
            local record = DbQueries.crimRecord.Fetch(fine.reference)

            if record then
                local input = json.decode(record.input)
                local charges = json.decode(record.data)
                fine.record = {
                    total = charges.total,
                    criminalCharges = charges.criminalCharges,
                    chargesStr = input.charges,
                }
            end
            return fine
        end
    end
    return false
end
RegisterCallback('al_mdt:FetchFine', function(source, ...)
    TriggerProtFunction('FetchFine', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchFine(...))
        end
    end, ...)
end)

function CheckOverdueFines(src, identifier)
    local allOverdue = DbQueries.fines.FetchAllUnpaid(identifier, true)
    local total = 0

    for i,val in pairs(allOverdue) do
        total = total + val.fine
        PayFine(src, val.id, val.fine, true)
    end

    return total > 0 and total or false
end
RegisterCallback('al_mdt:CheckOverdueFines', function(source, ...)
    TriggerProtFunction('CheckOverdueFines', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(CheckOverdueFines(src, ...))
        end
    end, ...)
end)
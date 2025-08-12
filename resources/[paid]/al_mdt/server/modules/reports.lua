function AddReport(src, identifier, type, submittedBy, description, input, data, date) -- Add crim report record
    if identifier and type and description and input and data and date then
        local fine = 0
        if data.total.fines > 0 then
            input = json.decode(input)
            if data.total.fineReduction >= 0 and string.len(input.fineReduction) > 0 then
                fine = data.total.fineReduction
            else
                fine = data.total.fines
            end
            input = json.encode(input)
        end

        DbQueries.crimRecord.Add(identifier, type, submittedBy, description, input, data, date, function(id)
            if fine > 0 then
                DbQueries.fines.Add(identifier, fine, id, date, data.dueDate)
            end
            ReportAddedAlert(src, type, id, identifier, fine)
        end)
    end
end
RegisterNetEvent('al_mdt:AddReport', function(...)
    TriggerProtFunction('AddReport', source, function(src, key, ...)
        if VerifyKey(src, key) then
            AddReport(src, ...)
        end
    end, ...)
end)

function UpdateReport(src, id, type, description, input, data, date) -- Update crim report record
    if id and type and description and input and data and date then
        DbQueries.crimRecord.Update(id, type, description, input, data, date)
        ReportUpdatedAlert(src, type, id)
    end
end
RegisterNetEvent('al_mdt:UpdateReport', function(...)
    TriggerProtFunction('UpdateReport', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateReport(src, ...)
        end
    end, ...)
end)

function FetchRecord(identifier) -- Fetch crim record from identifier
    if identifier ~= nil then
        return DbQueries.crimRecord.FetchAll(identifier)
    else
        return false
    end
end
RegisterCallback('al_mdt:FetchRecord', function(source, ...)
    TriggerProtFunction('FetchRecord', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchRecord(...))
        end
    end, ...)
end)

function FetchReport(id) -- Fetch report
    if id then
        return DbQueries.crimRecord.Fetch(id)
    else
        return false
    end
end
RegisterCallback('al_mdt:FetchReport', function(source, ...)
    TriggerProtFunction('FetchReport', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchReport(...))
        end
    end, ...)
end)

function DeleteReport(src, id) -- Delete report
    if id then
        DbQueries.crimRecord.Delete(id)
        ReportDeletedAlert(src, id)
    end
end
RegisterNetEvent('al_mdt:DeleteReport', function(...)
    TriggerProtFunction('DeleteReport', source, function(src, key, ...)
        if VerifyKey(src, key) then
            DeleteReport(src, ...)
        end
    end, ...)
end)

function FetchReports(page, getTotalPages, filter) -- Fetch recent reports
    if page then
        return DbQueries.crimRecord.FetchAllWithFilter(page, getTotalPages, filter)
    else
        return {}
    end
end
RegisterCallback('al_mdt:FetchReports', function(source, ...)
    TriggerProtFunction('FetchReports', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchReports(...))
        end
    end, ...)
end)

function FetchRecentReports(identifier) -- Fetch recent reports
    if identifier then
        return DbQueries.crimRecord.FetchRecentReports(identifier)
    else
        return {}
    end
end
RegisterCallback('al_mdt:FetchRecentReports', function(source, ...)
    TriggerProtFunction('FetchRecentReports', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchRecentReports(...))
        end
    end, ...)
end)

RegisterNetEvent('al_mdt:JailPlayer', function(...)
    TriggerProtFunction('JailPlayer', source, function(src, key, ...)
        if VerifyKey(src, key) then
            JailPlayer(source, ...) -- Found in framework.lua
        end
    end, ...)
end)
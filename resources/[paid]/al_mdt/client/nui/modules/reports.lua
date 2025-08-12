RegisterNUICallback('addRecordEntry', function(data, cb)
    TriggerServerEvent('al_mdt:AddReport', mdt.k, data.identifier, data.entry.type, data.entry.submittedBy, data.entry.description, json.encode(data.entry.input), data.entry.data, data.entry.date)

    cb({})
end)

RegisterNUICallback('updateRecordEntry', function(entry, cb)
    TriggerServerEvent('al_mdt:UpdateReport', mdt.k, entry.id, entry.type, entry.description, json.encode(entry.input), json.encode(entry.data), entry.date)

    cb({})
end)

RegisterNUICallback('deleteRecordEntry', function(entryId, cb)
    TriggerServerEvent('al_mdt:DeleteReport', mdt.k, entryId)

    cb({})
end)

RegisterNUICallback('fetchReport', function(id, cb)
    TriggerServerCallback('al_mdt:FetchReport', function(resp)
        if resp then
            cb(resp)
        else
            cb(false)
        end
    end, mdt.k, id)
end)

RegisterNUICallback('fetchSelfRecentReports', function(identifier, cb)
    TriggerServerCallback('al_mdt:FetchRecentReports', function(resp)
        cb(resp)
    end, mdt.k, identifier)
end)

RegisterNUICallback('fetchReports', function(data, cb)
    TriggerServerCallback('al_mdt:FetchReports', function(resp)
        local pageData = resp.pageData

        if pageData then
            for i=1, #pageData do
                local report = pageData[i]
                report.input = json.decode(report.input)
                report.submittedBy = report.input.submittedBy
                report.input = nil
            end
        else
            pageData = {}
        end

        cb(resp)
    end, mdt.k, data.page, data.getTotalPages, data.filter)
end)

RegisterNUICallback('jailPlayer', function(data, cb)
    if data.time <= 0 then return end
    TriggerServerEvent('al_mdt:JailPlayer', mdt.k, data.identifier, data.reason, data.time)

    cb({})
end)

RegisterNUICallback('openReportStash', function(data, cb)
    TriggerServerEvent('al_mdt:OpenReportStash', mdt.k, data.reportId, data.stashId)

    cb({})
end)
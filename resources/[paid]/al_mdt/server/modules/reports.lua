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

function OpenReportStash(src, reportId, stashId)
    if reportId and stashId then
        local stashLabel = "Arrest Report #" .. reportId .. " - Evidence Stash"
        
        -- Register the stash with ox_inventory (15 slots, 50kg weight limit)
        exports.ox_inventory:RegisterStash(stashId, stashLabel, 15, 50000)
        
        -- Log the stash access
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            print('^3[AL_MDT] ^0Player ' .. xPlayer.getName() .. ' (' .. xPlayer.identifier .. ') opened report stash: ' .. stashId)
            LogStashAccess(xPlayer.identifier, xPlayer.getName(), stashId, 'STASH_OPENED', 'Opened evidence stash for report #' .. reportId)
        end
        
        -- Trigger client to open the stash
        TriggerClientEvent('al_mdt:openReportStash', src, stashId)
    end
end

function LogStashAccess(identifier, playerName, stashId, action, details)
    -- Create a comprehensive log entry
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local logEntry = string.format(
        '[%s] Player: %s (%s) | Action: %s | Stash: %s | Details: %s',
        timestamp, playerName, identifier, action, stashId, details or 'N/A'
    )
    
    -- Print to server console
    print('^2[STASH LOG] ^7' .. logEntry)
    
    -- You could also save to a database table here
    -- Example:
    -- MySQL.Async.execute('INSERT INTO stash_logs (identifier, player_name, stash_id, action, details, timestamp) VALUES (@identifier, @player_name, @stash_id, @action, @details, @timestamp)', {
    --     ['@identifier'] = identifier,
    --     ['@player_name'] = playerName,
    --     ['@stash_id'] = stashId,
    --     ['@action'] = action,
    --     ['@details'] = details,
    --     ['@timestamp'] = timestamp
    -- })
end

RegisterNetEvent('al_mdt:OpenReportStash', function(...)
    TriggerProtFunction('OpenReportStash', source, function(src, key, ...)
        if VerifyKey(src, key) then
            OpenReportStash(src, ...)
        end
    end, ...)
end)

-- Hook into ox_inventory to track stash item changes
AddEventHandler('ox_inventory:stashSaved', function(stashId, stashData)
    -- Check if this is a report stash
    if string.find(stashId, 'report_stash_') then
        local reportId = string.gsub(stashId, 'report_stash_', '')
        
        -- Get all players to find who might have made the change
        local players = GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
            if xPlayer then
                -- Log the stash change (we can't determine exact item changes without deeper hooks)
                LogStashAccess(
                    xPlayer.identifier, 
                    xPlayer.getName(), 
                    stashId, 
                    'STASH_MODIFIED', 
                    'Items added/removed from evidence stash for report #' .. reportId
                )
                break -- Only log once per stash change
            end
        end
    end
end)

-- Alternative method using ox_inventory hooks (if available)
if GetResourceState('ox_inventory') == 'started' then
    -- Try to hook into item add/remove events
    AddEventHandler('ox_inventory:itemAdded', function(source, item, count, slot)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local inventory = exports.ox_inventory:GetInventory(source, false)
            if inventory and inventory.type == 'stash' and string.find(inventory.id, 'report_stash_') then
                local reportId = string.gsub(inventory.id, 'report_stash_', '')
                LogStashAccess(
                    xPlayer.identifier,
                    xPlayer.getName(),
                    inventory.id,
                    'ITEM_ADDED',
                    string.format('Added %dx %s to evidence stash for report #%s', count, item, reportId)
                )
            end
        end
    end)
    
    AddEventHandler('ox_inventory:itemRemoved', function(source, item, count, slot)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local inventory = exports.ox_inventory:GetInventory(source, false)
            if inventory and inventory.type == 'stash' and string.find(inventory.id, 'report_stash_') then
                local reportId = string.gsub(inventory.id, 'report_stash_', '')
                LogStashAccess(
                    xPlayer.identifier,
                    xPlayer.getName(),
                    inventory.id,
                    'ITEM_REMOVED',
                    string.format('Removed %dx %s from evidence stash for report #%s', count, item, reportId)
                )
            end
        end
    end)
end
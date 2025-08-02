local dutyPlayers = {} -- Cache for duty status
local jobCounts = {} -- Cache for job counts

-- PERFORMANCE: Optimized initialization without SQL file loading
CreateThread(function()
    Wait(1000) -- Wait for MySQL to be ready
    
    -- PERFORMANCE: Create tables directly without file loading
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `job_duty` (
            `identifier` VARCHAR(60) NOT NULL,
            `job` VARCHAR(50) NOT NULL,
            `on_duty` TINYINT(1) NOT NULL DEFAULT 0,
            `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            
            PRIMARY KEY (`identifier`, `job`),
            INDEX (`job`),
            INDEX (`on_duty`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ]])
    
    print('[BBY Jobs] Database tables initialized')
    
    -- Load existing duty status into memory
    loadAllDutyStatus()
end)

-- Load all duty status from database
function loadAllDutyStatus()
    local results = exports.oxmysql:query_sync('SELECT * FROM job_duty WHERE on_duty = 1') or {}
    
    for _, row in ipairs(results) do
        if not dutyPlayers[row.identifier] then
            dutyPlayers[row.identifier] = {}
        end
        dutyPlayers[row.identifier][row.job] = true
        
        -- Update job counts
        jobCounts[row.job] = (jobCounts[row.job] or 0) + 1
    end
    
    print(('[BBY Jobs] Loaded %d duty records'):format(#results))
    
    -- Update all clients with current blip status
    updateAllBlips()
end

-- Get player's current duty status for a job
function getPlayerDutyStatus(identifier, job)
    return dutyPlayers[identifier] and dutyPlayers[identifier][job] or false
end

-- Set player duty status
function setPlayerDutyStatus(identifier, job, onDuty)
    if not Config.DutyJobs then
        return false, "Configuration not loaded"
    end
    
    local hasJob = false
    for _, dutyJob in ipairs(Config.DutyJobs) do
        if dutyJob == job then
            hasJob = true
            break
        end
    end
    
    if not hasJob then
        return false, "Job does not support duty system"
    end
    
    local currentStatus = getPlayerDutyStatus(identifier, job)
    if currentStatus == onDuty then
        return false, onDuty and "Already on duty" or "Already off duty"
    end
    
    -- Update cache
    if not dutyPlayers[identifier] then
        dutyPlayers[identifier] = {}
    end
    dutyPlayers[identifier][job] = onDuty
    
    -- Update database
    if onDuty then
        exports.oxmysql:execute('INSERT INTO job_duty (identifier, job, on_duty) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE on_duty = 1, last_updated = CURRENT_TIMESTAMP', {
            identifier, job
        })
        jobCounts[job] = (jobCounts[job] or 0) + 1
    else
        exports.oxmysql:execute('UPDATE job_duty SET on_duty = 0, last_updated = CURRENT_TIMESTAMP WHERE identifier = ? AND job = ?', {
            identifier, job
        })
        jobCounts[job] = math.max((jobCounts[job] or 1) - 1, 0)
        dutyPlayers[identifier][job] = nil
    end
    
    print(('[BBY Jobs] %s %s duty for job: %s (Total on duty: %d)'):format(identifier, onDuty and "went on" or "went off", job, jobCounts[job] or 0))
    
    -- Update blips for all clients
    updateJobBlips(job)
    
    return true, onDuty and "You are now on duty" or "You are now off duty"
end

-- Get count of players on duty for a job
function getJobDutyCount(job)
    return jobCounts[job] or 0
end

-- Update blips for all clients for a specific job
function updateJobBlips(job)
    local count = getJobDutyCount(job)
    TriggerClientEvent('bby_jobs:updateJobBlip', -1, job, count > 0)
end

-- Update all blips
function updateAllBlips()
    for job, _ in pairs(Config.JobBlips or {}) do
        updateJobBlips(job)
    end
end

-- Event handlers
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local identifier = xPlayer.identifier
    
    -- Load player's duty status from database
    local results = exports.oxmysql:query_sync('SELECT job, on_duty FROM job_duty WHERE identifier = ?', {identifier}) or {}
    
    if not dutyPlayers[identifier] then
        dutyPlayers[identifier] = {}
    end
    
    for _, row in ipairs(results) do
        if row.on_duty == 1 then
            dutyPlayers[identifier][row.job] = true
            
            -- Send duty status to client
            TriggerClientEvent('bby_jobs:setDutyStatus', playerId, row.job, true)
        end
    end
    
    -- Send current blip states to new player
    Wait(2000) -- Wait for client to fully load
    for job, blipData in pairs(Config.JobBlips or {}) do
        local hasOnDuty = getJobDutyCount(job) > 0
        TriggerClientEvent('bby_jobs:updateJobBlip', playerId, job, hasOnDuty)
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    -- Set all player's jobs to off duty
    if dutyPlayers[identifier] then
        for job, onDuty in pairs(dutyPlayers[identifier]) do
            if onDuty then
                setPlayerDutyStatus(identifier, job, false)
            end
        end
        dutyPlayers[identifier] = nil
    end
end)

-- Server events
RegisterServerEvent('bby_jobs:toggleDuty')
AddEventHandler('bby_jobs:toggleDuty', function(job)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if player has the job
    if xPlayer.job.name ~= job then
        TriggerClientEvent('esx:showNotification', source, 'You do not have this job!', 'error')
        return
    end
    
    local identifier = xPlayer.identifier
    local currentStatus = getPlayerDutyStatus(identifier, job)
    local success, message = setPlayerDutyStatus(identifier, job, not currentStatus)
    
    if success then
        TriggerClientEvent('esx:showNotification', source, message, 'success')
        TriggerClientEvent('bby_jobs:setDutyStatus', source, job, not currentStatus)
        
        -- Trigger event for other resources
        TriggerEvent('bby_jobs:dutyChanged', source, job, not currentStatus)
    else
        TriggerClientEvent('esx:showNotification', source, message, 'error')
    end
end)

-- Commands
ESX.RegisterCommand('duty', "user", function(xPlayer, args, showError)
    local job = xPlayer.job.name
    local identifier = xPlayer.identifier
    local currentStatus = getPlayerDutyStatus(identifier, job)
    local success, message = setPlayerDutyStatus(identifier, job, not currentStatus)
    
    if success then
        xPlayer.showNotification(message)
        TriggerClientEvent('bby_jobs:setDutyStatus', xPlayer.source, job, not currentStatus)
        
        -- Trigger event for other resources
        TriggerEvent('bby_jobs:dutyChanged', xPlayer.source, job, not currentStatus)
    else
        xPlayer.showNotification(message)
    end
end, false, {help = "Toggle your job duty status"})

-- Admin command to set duty for others
ESX.RegisterCommand('setduty', "admin", function(xPlayer, args, showError)
    if not args.target or not args.job then
        return showError("Usage: /setduty [player] [job] [on/off]")
    end
    
    local targetPlayer = args.target
    local job = args.job
    local dutyStatus = args.status == "on"
    
    local identifier = targetPlayer.identifier
    local success, message = setPlayerDutyStatus(identifier, job, dutyStatus)
    
    if success then
        xPlayer.showNotification(('Set %s duty %s for %s'):format(job, dutyStatus and "on" or "off", targetPlayer.name))
        targetPlayer.showNotification(message)
        TriggerClientEvent('bby_jobs:setDutyStatus', targetPlayer.source, job, dutyStatus)
        
        -- Trigger event for other resources
        TriggerEvent('bby_jobs:dutyChanged', targetPlayer.source, job, dutyStatus)
    else
        xPlayer.showNotification(message)
    end
end, false, {help = "Set player duty status", validate = true, arguments = {
    {name = 'target', help = 'Target player', type = 'player'},
    {name = 'job', help = 'Job name', type = 'string'},
    {name = 'status', help = 'on/off', type = 'string'}
}})

-- Exports
exports('getPlayerDutyStatus', getPlayerDutyStatus)
exports('setPlayerDutyStatus', setPlayerDutyStatus)
exports('getJobDutyCount', getJobDutyCount)
exports('isPlayerOnDuty', function(identifier, job)
    return getPlayerDutyStatus(identifier, job)
end)

print('[BBY Jobs] Server started successfully')
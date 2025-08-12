local ESX = nil

CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(0)
    end
end)

-- Database initialization
MySQL.ready(function()
    -- Create citizen notes table
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `police_mdt_notes` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `citizen_id` varchar(60) NOT NULL,
            `officer_id` varchar(60) NOT NULL,
            `officer_name` varchar(100) NOT NULL,
            `note` text NOT NULL,
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `citizen_id` (`citizen_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    -- Create citizen violations table
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `police_mdt_violations` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `citizen_id` varchar(60) NOT NULL,
            `officer_id` varchar(60) NOT NULL,
            `officer_name` varchar(100) NOT NULL,
            `violation` text NOT NULL,
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `citizen_id` (`citizen_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    -- Create crimes table (for current crimes)
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `police_mdt_crimes` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `type` varchar(100) NOT NULL,
            `location` text NOT NULL,
            `description` text,
            `reported_by` varchar(60),
            `status` varchar(50) NOT NULL DEFAULT 'active',
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    -- Create police records table
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `police_mdt_records` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `citizen_id` varchar(60) NOT NULL,
            `officer_id` varchar(60) NOT NULL,
            `officer_name` varchar(100) NOT NULL,
            `type` varchar(100) NOT NULL,
            `description` text NOT NULL,
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `citizen_id` (`citizen_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    
    print('[Police MDT] Database tables initialized')
end)

-- Search citizen by name
ESX.RegisterServerCallback('police_mdt:searchCitizenByName', function(source, cb, name)
    local searchName = '%' .. name .. '%'
    
    MySQL.Async.fetchAll('SELECT * FROM users WHERE CONCAT(firstname, " ", lastname) LIKE @name LIMIT 10', {
        ['@name'] = searchName
    }, function(result)
        if result and #result > 0 then
            -- If multiple results, return the first one for now
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

-- Search citizen by State ID
ESX.RegisterServerCallback('police_mdt:searchCitizenByStateId', function(source, cb, stateId)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE state_id = @state_id LIMIT 1', {
        ['@state_id'] = stateId
    }, function(result)
        if result and #result > 0 then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

-- Add note to citizen
RegisterServerEvent('police_mdt:addNote')
AddEventHandler('police_mdt:addNote', function(citizenId, note)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local officerName = xPlayer.getName()
    
    MySQL.Async.execute('INSERT INTO police_mdt_notes (citizen_id, officer_id, officer_name, note) VALUES (@citizen_id, @officer_id, @officer_name, @note)', {
        ['@citizen_id'] = citizenId,
        ['@officer_id'] = xPlayer.identifier,
        ['@officer_name'] = officerName,
        ['@note'] = note
    })
end)

-- Add violation to citizen
RegisterServerEvent('police_mdt:addViolation')
AddEventHandler('police_mdt:addViolation', function(citizenId, violation)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local officerName = xPlayer.getName()
    
    MySQL.Async.execute('INSERT INTO police_mdt_violations (citizen_id, officer_id, officer_name, violation) VALUES (@citizen_id, @officer_id, @officer_name, @violation)', {
        ['@citizen_id'] = citizenId,
        ['@officer_id'] = xPlayer.identifier,
        ['@officer_name'] = officerName,
        ['@violation'] = violation
    })
    
    -- Also add to police records
    MySQL.Async.execute('INSERT INTO police_mdt_records (citizen_id, officer_id, officer_name, type, description) VALUES (@citizen_id, @officer_id, @officer_name, @type, @description)', {
        ['@citizen_id'] = citizenId,
        ['@officer_id'] = xPlayer.identifier,
        ['@officer_name'] = officerName,
        ['@type'] = 'Violation',
        ['@description'] = violation
    })
end)

-- Get notes for citizen
ESX.RegisterServerCallback('police_mdt:getNotes', function(source, cb, citizenId)
    MySQL.Async.fetchAll('SELECT * FROM police_mdt_notes WHERE citizen_id = @citizen_id ORDER BY date DESC', {
        ['@citizen_id'] = citizenId
    }, function(result)
        local notes = {}
        
        for i = 1, #result do
            table.insert(notes, {
                id = result[i].id,
                note = result[i].note,
                officer_name = result[i].officer_name,
                date = result[i].date
            })
        end
        
        cb(notes)
    end)
end)

-- Get violations for citizen
ESX.RegisterServerCallback('police_mdt:getViolations', function(source, cb, citizenId)
    MySQL.Async.fetchAll('SELECT * FROM police_mdt_violations WHERE citizen_id = @citizen_id ORDER BY date DESC', {
        ['@citizen_id'] = citizenId
    }, function(result)
        local violations = {}
        
        for i = 1, #result do
            table.insert(violations, {
                id = result[i].id,
                violation = result[i].violation,
                officer_name = result[i].officer_name,
                date = result[i].date
            })
        end
        
        cb(violations)
    end)
end)

-- Get current crimes
ESX.RegisterServerCallback('police_mdt:getCurrentCrimes', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM police_mdt_crimes WHERE status = @status ORDER BY date DESC LIMIT 20', {
        ['@status'] = 'active'
    }, function(result)
        local crimes = {}
        
        for i = 1, #result do
            table.insert(crimes, {
                id = result[i].id,
                type = result[i].type,
                location = result[i].location,
                description = result[i].description or '',
                date = result[i].date
            })
        end
        
        cb(crimes)
    end)
end)

-- Search police records by name
ESX.RegisterServerCallback('police_mdt:searchRecordsByName', function(source, cb, name)
    local searchName = '%' .. name .. '%'
    
    -- First get citizen ID from users table
    MySQL.Async.fetchAll('SELECT identifier FROM users WHERE CONCAT(firstname, " ", lastname) LIKE @name LIMIT 1', {
        ['@name'] = searchName
    }, function(userResult)
        if userResult and #userResult > 0 then
            local citizenId = userResult[1].identifier
            
            -- Get all records for this citizen
            MySQL.Async.fetchAll('SELECT * FROM police_mdt_records WHERE citizen_id = @citizen_id ORDER BY date DESC', {
                ['@citizen_id'] = citizenId
            }, function(recordResult)
                local records = {}
                
                for i = 1, #recordResult do
                    table.insert(records, {
                        id = recordResult[i].id,
                        type = recordResult[i].type,
                        description = recordResult[i].description,
                        officer_name = recordResult[i].officer_name,
                        date = recordResult[i].date
                    })
                end
                
                cb(records)
            end)
        else
            cb({})
        end
    end)
end)

-- Search police records by State ID
ESX.RegisterServerCallback('police_mdt:searchRecordsByStateId', function(source, cb, stateId)
    -- First get citizen ID from users table using state_id
    MySQL.Async.fetchAll('SELECT identifier FROM users WHERE state_id = @state_id LIMIT 1', {
        ['@state_id'] = stateId
    }, function(userResult)
        if userResult and #userResult > 0 then
            local citizenId = userResult[1].identifier
            
            -- Get all records for this citizen
            MySQL.Async.fetchAll('SELECT * FROM police_mdt_records WHERE citizen_id = @citizen_id ORDER BY date DESC', {
                ['@citizen_id'] = citizenId
            }, function(recordResult)
                local records = {}
                
                for i = 1, #recordResult do
                    table.insert(records, {
                        id = recordResult[i].id,
                        type = recordResult[i].type,
                        description = recordResult[i].description,
                        officer_name = recordResult[i].officer_name,
                        date = recordResult[i].date
                    })
                end
                
                cb(records)
            end)
        else
            cb({})
        end
    end)
end)

-- Call backup
RegisterServerEvent('police_mdt:callBackup')
AddEventHandler('police_mdt:callBackup', function(location, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local officerName = xPlayer.getName()
    local message = string.format("🚨 BACKUP REQUESTED 🚨\nOfficer: %s\nLocation: %s\nReason: %s", officerName, location, reason)
    
    -- Send backup call to all police officers
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        if xTarget and xTarget.job then
            local isPolice = false
            for j = 1, #Config.PoliceMDT.PoliceJobs do
                if xTarget.job.name == Config.PoliceMDT.PoliceJobs[j] then
                    isPolice = true
                    break
                end
            end
            
            if isPolice then
                TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Police Dispatch', 'Backup Request', message, 'CHAR_CALL911', 1)
                TriggerClientEvent('chat:addMessage', xPlayers[i], {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><b>BACKUP REQUESTED</b><br>Officer: {0}<br>Location: {1}<br>Reason: {2}</div>',
                    args = {officerName, location, reason}
                })
            end
        end
    end
    
    -- Log backup call
    print(string.format('[Police MDT] Backup called by %s at %s - Reason: %s', officerName, location, reason))
end)

-- Utility function to add a crime (can be used by other scripts)
function AddCrime(crimeType, location, description, reportedBy)
    MySQL.Async.execute('INSERT INTO police_mdt_crimes (type, location, description, reported_by) VALUES (@type, @location, @description, @reported_by)', {
        ['@type'] = crimeType,
        ['@location'] = location,
        ['@description'] = description or '',
        ['@reported_by'] = reportedBy or 'System'
    })
end

-- Export the AddCrime function for other scripts to use
exports('AddCrime', AddCrime)

-- Example crimes for testing (you can remove this later)
CreateThread(function()
    Wait(10000) -- Wait 10 seconds after server start
    
    -- Add some sample crimes for testing
    AddCrime('Vehicle Theft', 'Legion Square', 'Red sedan stolen from parking lot', 'Citizen Report')
    AddCrime('Robbery', 'Fleeca Bank Downtown', 'Armed robbery in progress', '911 Call')
    AddCrime('Assault', 'Grove Street', 'Fight reported outside bar', 'Anonymous Tip')
end)
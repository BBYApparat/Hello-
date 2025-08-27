ESX = exports['es_extended']:getSharedObject()

-- Initialize MDT System
CreateThread(function()
    -- Wait for database to be ready
    while not MySQL do
        Wait(100)
    end
    
    -- Create all necessary tables
    CreateMDTTables()
    
    print('[ESX_MDT] ^2Mobile Data Terminal initialized successfully^7')
end)

function CreateMDTTables()
    -- Callsigns table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_callsigns (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(60) NOT NULL,
            firstname VARCHAR(50),
            lastname VARCHAR(50),  
            callsign VARCHAR(20) NOT NULL UNIQUE,
            job VARCHAR(20) NOT NULL,
            department VARCHAR(20),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX(identifier),
            INDEX(callsign),
            INDEX(job)
        )
    ]])
    
    -- Incidents/Reports table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_reports (
            id INT AUTO_INCREMENT PRIMARY KEY,
            report_id VARCHAR(20) UNIQUE NOT NULL,
            title VARCHAR(255) NOT NULL,
            content TEXT NOT NULL,
            type ENUM('incident', 'arrest', 'citation', 'bolo', 'warrant') NOT NULL,
            author_identifier VARCHAR(60) NOT NULL,
            author_name VARCHAR(100) NOT NULL,
            author_callsign VARCHAR(20),
            department VARCHAR(20),
            suspects JSON,
            evidence JSON,
            location VARCHAR(255),
            time_of_incident DATETIME,
            status ENUM('active', 'closed', 'archived') DEFAULT 'active',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX(report_id),
            INDEX(author_identifier),
            INDEX(type),
            INDEX(status)
        )
    ]])
    
    -- People/Suspects table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_people (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(60) UNIQUE,
            firstname VARCHAR(50) NOT NULL,
            lastname VARCHAR(50) NOT NULL,
            dob DATE,
            description TEXT,
            mugshot_url VARCHAR(255),
            flags JSON,
            notes TEXT,
            created_by VARCHAR(60),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX(identifier),
            INDEX(firstname, lastname),
            INDEX(dob)
        )
    ]])
    
    -- Warrants table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_warrants (
            id INT AUTO_INCREMENT PRIMARY KEY,
            warrant_id VARCHAR(20) UNIQUE NOT NULL,
            suspect_identifier VARCHAR(60),
            suspect_name VARCHAR(100) NOT NULL,
            charges JSON NOT NULL,
            description TEXT,
            issued_by VARCHAR(60) NOT NULL,
            issued_by_name VARCHAR(100) NOT NULL,
            department VARCHAR(20),
            status ENUM('active', 'served', 'expired') DEFAULT 'active',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX(warrant_id),
            INDEX(suspect_identifier),
            INDEX(status)
        )
    ]])
    
    -- Evidence table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_evidence (
            id INT AUTO_INCREMENT PRIMARY KEY,
            evidence_id VARCHAR(20) UNIQUE NOT NULL,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            type VARCHAR(50) NOT NULL,
            location VARCHAR(255),
            collected_by VARCHAR(60) NOT NULL,
            collected_by_name VARCHAR(100) NOT NULL,
            related_reports JSON,
            status ENUM('collected', 'processed', 'archived') DEFAULT 'collected',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            INDEX(evidence_id),
            INDEX(collected_by),
            INDEX(type),
            INDEX(status)
        )
    ]])
    
    -- Vehicle flags/notes table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS mdt_vehicles (
            id INT AUTO_INCREMENT PRIMARY KEY,
            plate VARCHAR(20) NOT NULL,
            model VARCHAR(50),
            color VARCHAR(50),
            flags JSON,
            notes TEXT,
            owner_identifier VARCHAR(60),
            owner_name VARCHAR(100),
            status ENUM('clean', 'flagged', 'stolen', 'impounded') DEFAULT 'clean',
            flagged_by VARCHAR(60),
            flagged_by_name VARCHAR(100),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY unique_plate (plate),
            INDEX(plate),
            INDEX(owner_identifier),
            INDEX(status)
        )
    ]])
end

-- Helper functions
function GetESXPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function HasMDTAccess(xPlayer)
    print('[ESX_MDT SERVER] HasMDTAccess called')
    
    if not xPlayer then 
        print('[ESX_MDT SERVER] HasMDTAccess: xPlayer is nil')
        return false 
    end
    
    local job = xPlayer.getJob()
    print('[ESX_MDT SERVER] HasMDTAccess: job =', json.encode(job))
    
    if not job then 
        print('[ESX_MDT SERVER] HasMDTAccess: job is nil')
        return false 
    end
    
    print('[ESX_MDT SERVER] HasMDTAccess: Checking job.name =', job.name)
    print('[ESX_MDT SERVER] HasMDTAccess: AllowedJobs =', json.encode(Config.AllowedJobs))
    
    -- Check if job is allowed
    for _, allowedJobName in ipairs(Config.AllowedJobs) do
        print('[ESX_MDT SERVER] HasMDTAccess: Comparing', job.name, 'with', allowedJobName)
        if job.name == allowedJobName then
            print('[ESX_MDT SERVER] HasMDTAccess: MATCH FOUND - returning true')
            return true
        end
    end
    
    print('[ESX_MDT SERVER] HasMDTAccess: NO MATCH - returning false')
    return false
end

function HasPermission(xPlayer, permission)
    if not xPlayer then return false end
    
    local job = xPlayer.getJob()
    if not job then return false end
    
    local jobPerms = Config.Permissions[job.name]
    if not jobPerms then return false end
    
    local gradePerms = jobPerms[job.grade]
    if not gradePerms then return false end
    
    return gradePerms[permission] == true
end

function GenerateReportId()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = ''
    for i = 1, 8 do
        local rand = math.random(#chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

function GenerateEvidenceId()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = 'EV'
    for i = 1, 6 do
        local rand = math.random(#chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

function GenerateWarrantId()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = 'WR'
    for i = 1, 6 do
        local rand = math.random(#chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

-- Export functions
exports('HasMDTAccess', HasMDTAccess)
exports('HasPermission', HasPermission)
exports('GetESXPlayer', GetESXPlayer)
-- ESX MDT Callbacks System

-- Get player data for MDT
ESX.RegisterServerCallback('esx_mdt:getPlayerData', function(source, cb)
    print('[ESX_MDT SERVER] getPlayerData callback called for source:', source)
    
    local xPlayer = GetESXPlayer(source)
    print('[ESX_MDT SERVER] xPlayer:', xPlayer and 'found' or 'nil')
    
    if not xPlayer then 
        print('[ESX_MDT SERVER] No xPlayer found, returning false')
        cb(false)
        return 
    end
    
    local job = xPlayer.getJob()
    print('[ESX_MDT SERVER] Player job:', json.encode(job))
    
    local hasMDTAccess = HasMDTAccess(xPlayer)
    print('[ESX_MDT SERVER] HasMDTAccess result:', hasMDTAccess)
    
    if not hasMDTAccess then
        print('[ESX_MDT SERVER] Player does not have MDT access, returning false')
        cb(false)
        return
    end
    
    local callsignData = MySQL.single.await('SELECT callsign FROM mdt_callsigns WHERE identifier = ?', {xPlayer.identifier})
    print('[ESX_MDT SERVER] Callsign data:', callsignData and callsignData.callsign or 'none')
    
    local permissions = Config.Permissions[job.name] and Config.Permissions[job.name][job.grade] or {}
    print('[ESX_MDT SERVER] Permissions:', json.encode(permissions))
    
    local playerData = {
        source = source,
        identifier = xPlayer.identifier,
        name = xPlayer.getName(),
        job = job.name,
        jobLabel = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label,
        callsign = callsignData and callsignData.callsign or nil,
        permissions = permissions
    }
    
    print('[ESX_MDT SERVER] Returning player data:', json.encode(playerData))
    cb(playerData)
end)

-- Search people
ESX.RegisterServerCallback('esx_mdt:searchPeople', function(source, cb, searchTerm)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasMDTAccess(xPlayer) then
        cb(false)
        return
    end
    
    local query = [[
        SELECT u.identifier, u.firstname, u.lastname, u.dateofbirth, u.sex, u.height, 
               mp.description, mp.mugshot_url, mp.flags, mp.notes
        FROM users u
        LEFT JOIN mdt_people mp ON u.identifier = mp.identifier
        WHERE u.firstname LIKE ? OR u.lastname LIKE ? OR CONCAT(u.firstname, ' ', u.lastname) LIKE ?
        LIMIT 50
    ]]
    
    local searchPattern = '%' .. searchTerm .. '%'
    local results = MySQL.query.await(query, {searchPattern, searchPattern, searchPattern})
    
    -- Format results
    for i = 1, #results do
        if results[i].flags then
            results[i].flags = json.decode(results[i].flags)
        end
    end
    
    cb(results)
end)

-- Get person details
ESX.RegisterServerCallback('esx_mdt:getPersonDetails', function(source, cb, identifier)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasMDTAccess(xPlayer) then
        cb(false)
        return
    end
    
    local query = [[
        SELECT u.identifier, u.firstname, u.lastname, u.dateofbirth, u.sex, u.height, u.accounts,
               mp.description, mp.mugshot_url, mp.flags, mp.notes,
               mc.callsign, j.name as job_name, j.label as job_label, j.grade
        FROM users u
        LEFT JOIN mdt_people mp ON u.identifier = mp.identifier
        LEFT JOIN mdt_callsigns mc ON u.identifier = mc.identifier
        LEFT JOIN jobs j ON u.job = j.name
        WHERE u.identifier = ?
    ]]
    
    local result = MySQL.single.await(query, {identifier})
    
    if result then
        if result.flags then
            result.flags = json.decode(result.flags)
        end
        if result.accounts then
            result.accounts = json.decode(result.accounts)
        end
        
        -- Get related reports
        local reports = MySQL.query.await('SELECT * FROM mdt_reports WHERE JSON_CONTAINS(suspects, JSON_OBJECT("identifier", ?)) ORDER BY created_at DESC LIMIT 10', {identifier})
        result.reports = reports
        
        -- Get active warrants
        local warrants = MySQL.query.await('SELECT * FROM mdt_warrants WHERE suspect_identifier = ? AND status = "active"', {identifier})
        result.warrants = warrants
    end
    
    cb(result)
end)

-- Search vehicles
ESX.RegisterServerCallback('esx_mdt:searchVehicles', function(source, cb, searchTerm)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasMDTAccess(xPlayer) then
        cb(false)
        return
    end
    
    local query = [[
        SELECT ov.plate, ov.vehicle, ov.owner, u.firstname, u.lastname,
               mv.flags, mv.notes, mv.status
        FROM owned_vehicles ov
        LEFT JOIN users u ON ov.owner = u.identifier
        LEFT JOIN mdt_vehicles mv ON ov.plate = mv.plate
        WHERE ov.plate LIKE ? OR ov.vehicle LIKE ?
        LIMIT 50
    ]]
    
    local searchPattern = '%' .. searchTerm .. '%'
    local results = MySQL.query.await(query, {searchPattern, searchPattern})
    
    -- Format results
    for i = 1, #results do
        if results[i].flags then
            results[i].flags = json.decode(results[i].flags)
        end
        if results[i].vehicle then
            results[i].vehicle = json.decode(results[i].vehicle)
        end
    end
    
    cb(results)
end)

-- Search reports
ESX.RegisterServerCallback('esx_mdt:searchReports', function(source, cb, searchData)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasMDTAccess(xPlayer) then
        cb(false)
        return
    end
    
    local query = 'SELECT * FROM mdt_reports WHERE 1=1'
    local params = {}
    
    if searchData.type and searchData.type ~= '' then
        query = query .. ' AND type = ?'
        table.insert(params, searchData.type)
    end
    
    if searchData.search and searchData.search ~= '' then
        query = query .. ' AND (title LIKE ? OR content LIKE ? OR author_name LIKE ?)'
        local searchPattern = '%' .. searchData.search .. '%'
        table.insert(params, searchPattern)
        table.insert(params, searchPattern) 
        table.insert(params, searchPattern)
    end
    
    if searchData.status and searchData.status ~= '' then
        query = query .. ' AND status = ?'
        table.insert(params, searchData.status)
    end
    
    query = query .. ' ORDER BY created_at DESC LIMIT 50'
    
    local results = MySQL.query.await(query, params)
    
    -- Decode JSON fields
    for i = 1, #results do
        if results[i].suspects then
            results[i].suspects = json.decode(results[i].suspects)
        end
        if results[i].evidence then
            results[i].evidence = json.decode(results[i].evidence)
        end
    end
    
    cb(results)
end)

-- Create report
ESX.RegisterServerCallback('esx_mdt:createReport', function(source, cb, reportData)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasPermission(xPlayer, 'create_reports') then
        cb(false)
        return
    end
    
    local job = xPlayer.getJob()
    local callsignData = MySQL.single.await('SELECT callsign FROM mdt_callsigns WHERE identifier = ?', {xPlayer.identifier})
    
    local reportId = GenerateReportId()
    
    local success = MySQL.insert.await([[
        INSERT INTO mdt_reports (report_id, title, content, type, author_identifier, author_name, 
                                author_callsign, department, suspects, evidence, location, 
                                time_of_incident, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        reportId,
        reportData.title,
        reportData.content,
        reportData.type,
        xPlayer.identifier,
        xPlayer.getName(),
        callsignData and callsignData.callsign or nil,
        job.name,
        json.encode(reportData.suspects or {}),
        json.encode(reportData.evidence or {}),
        reportData.location,
        reportData.time_of_incident,
        'active'
    })
    
    cb(success and reportId or false)
end)

-- Get report details
ESX.RegisterServerCallback('esx_mdt:getReport', function(source, cb, reportId)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasMDTAccess(xPlayer) then
        cb(false)
        return
    end
    
    local report = MySQL.single.await('SELECT * FROM mdt_reports WHERE report_id = ?', {reportId})
    
    if report then
        if report.suspects then
            report.suspects = json.decode(report.suspects)
        end
        if report.evidence then
            report.evidence = json.decode(report.evidence)
        end
    end
    
    cb(report)
end)

-- Update report
ESX.RegisterServerCallback('esx_mdt:updateReport', function(source, cb, reportId, updateData)
    local xPlayer = GetESXPlayer(source)
    if not xPlayer or not HasPermission(xPlayer, 'edit_reports') then
        cb(false)
        return
    end
    
    local success = MySQL.update.await([[
        UPDATE mdt_reports 
        SET title = ?, content = ?, suspects = ?, evidence = ?, location = ?, 
            time_of_incident = ?, status = ?
        WHERE report_id = ?
    ]], {
        updateData.title,
        updateData.content,
        json.encode(updateData.suspects or {}),
        json.encode(updateData.evidence or {}),
        updateData.location,
        updateData.time_of_incident,
        updateData.status,
        reportId
    })
    
    cb(success)
end)
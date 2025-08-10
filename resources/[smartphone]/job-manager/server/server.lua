-- Job Manager Server
local QBCore = nil
local ESX = nil

-- Framework detection
if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports["es_extended"]:getSharedObject()
end

-- Online players cache
local onlinePlayers = {}

-- Track player connections
AddEventHandler('playerConnecting', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    if identifier then
        onlinePlayers[identifier] = {
            source = src,
            joinTime = os.time()
        }
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    if identifier and onlinePlayers[identifier] then
        -- Update last seen in database
        if ESX then
            exports.oxmysql:update_async('UPDATE users SET last_seen = NOW() WHERE identifier = ?', { identifier })
        elseif QBCore then
            exports.oxmysql:update_async('UPDATE players SET last_login = NOW() WHERE citizenid = ?', { identifier })
        end
        
        onlinePlayers[identifier] = nil
    end
end)

-- Get job data and employees
lib.callback.register('job-manager:getJobData', function(source)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check if player has management permissions (grade 1 or higher)
    if playerGrade < 1 then
        return { success = false, message = "UNAUTHORIZED" }
    end
    
    -- Get job information
    local jobInfo = GetJobInfo(playerJob)
    if not jobInfo then
        return { success = false, message = "Job information not found" }
    end
    
    -- Get job grades
    local grades = GetJobGrades(playerJob)
    
    -- Get all employees
    local employees = GetJobEmployees(playerJob)
    
    -- Add online status to employees
    for i = 1, #employees do
        local employee = employees[i]
        employee.isOnline = onlinePlayers[employee.identifier] ~= nil
    end
    
    return {
        success = true,
        jobData = {
            name = playerJob,
            label = jobInfo.label,
            grade = playerGrade,
            gradeName = GetGradeName(playerJob, playerGrade),
            grades = grades
        },
        employees = employees
    }
end)

-- Hire employee
lib.callback.register('job-manager:hireEmployee', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check permissions
    if playerGrade < 2 then
        return { success = false, message = "Insufficient permissions to hire employees" }
    end
    
    -- Check if hire grade is valid and lower than manager's grade
    if data.grade >= playerGrade then
        return { success = false, message = "Cannot hire employee with equal or higher grade" }
    end
    
    -- Find target player
    local targetPlayer = FindPlayer(data.playerInput)
    if not targetPlayer then
        return { success = false, message = "Player not found" }
    end
    
    local targetIdentifier = GetPlayerIdentifier(GetPlayerSource(targetPlayer))
    local targetName = GetPlayerName(targetPlayer)
    
    -- Check if player is already employed by this job
    local currentJob = GetPlayerJob(targetPlayer)
    if currentJob == playerJob then
        return { success = false, message = "Player is already employed by this company" }
    end
    
    -- Set player job
    local success = SetPlayerJob(targetPlayer, playerJob, data.grade)
    if success then
        -- Notify both players
        TriggerClientEvent('okokRequests:notify', src, {
            title = "Job Manager",
            text = string.format("Successfully hired %s", targetName),
            duration = 3000
        })
        
        TriggerClientEvent('okokRequests:notify', GetPlayerSource(targetPlayer), {
            title = "Job Manager",
            text = string.format("You have been hired by %s", GetJobInfo(playerJob).label),
            duration = 5000
        })
        
        return { success = true }
    else
        return { success = false, message = "Failed to set player job" }
    end
end)

-- Promote employee
lib.callback.register('job-manager:promoteEmployee', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check permissions
    if playerGrade < 2 then
        return { success = false, message = "Insufficient permissions" }
    end
    
    -- Find target player
    local targetPlayer = FindPlayerByIdentifier(data.employeeId)
    if not targetPlayer then
        -- Player is offline, update database directly
        return UpdateOfflinePlayerJob(data.employeeId, playerJob, 'promote', playerGrade)
    end
    
    local targetGrade = GetPlayerJobGrade(targetPlayer)
    local newGrade = targetGrade + 1
    
    -- Check if new grade would exceed manager's grade
    if newGrade >= playerGrade then
        return { success = false, message = "Cannot promote to equal or higher grade than yours" }
    end
    
    -- Check if already at max grade
    local maxGrade = GetMaxJobGrade(playerJob)
    if targetGrade >= maxGrade then
        return { success = false, message = "Employee is already at maximum grade" }
    end
    
    local success = SetPlayerJob(targetPlayer, playerJob, newGrade)
    if success then
        TriggerClientEvent('okokRequests:notify', GetPlayerSource(targetPlayer), {
            title = "Job Manager",
            text = string.format("You have been promoted to %s", GetGradeName(playerJob, newGrade)),
            duration = 5000
        })
        
        return { success = true }
    else
        return { success = false, message = "Failed to promote employee" }
    end
end)

-- Demote employee
lib.callback.register('job-manager:demoteEmployee', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check permissions
    if playerGrade < 2 then
        return { success = false, message = "Insufficient permissions" }
    end
    
    -- Find target player
    local targetPlayer = FindPlayerByIdentifier(data.employeeId)
    if not targetPlayer then
        -- Player is offline, update database directly
        return UpdateOfflinePlayerJob(data.employeeId, playerJob, 'demote', playerGrade)
    end
    
    local targetGrade = GetPlayerJobGrade(targetPlayer)
    local newGrade = targetGrade - 1
    
    -- Check if already at minimum grade
    if targetGrade <= 0 then
        return { success = false, message = "Employee is already at minimum grade" }
    end
    
    -- Check permissions
    if targetGrade >= playerGrade then
        return { success = false, message = "Cannot demote employee with equal or higher grade" }
    end
    
    local success = SetPlayerJob(targetPlayer, playerJob, newGrade)
    if success then
        TriggerClientEvent('okokRequests:notify', GetPlayerSource(targetPlayer), {
            title = "Job Manager",
            text = string.format("You have been demoted to %s", GetGradeName(playerJob, newGrade)),
            duration = 5000
        })
        
        return { success = true }
    else
        return { success = false, message = "Failed to demote employee" }
    end
end)

-- Fire employee
lib.callback.register('job-manager:fireEmployee', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check permissions
    if playerGrade < 2 then
        return { success = false, message = "Insufficient permissions" }
    end
    
    -- Find target player
    local targetPlayer = FindPlayerByIdentifier(data.employeeId)
    if not targetPlayer then
        -- Player is offline, update database directly
        return UpdateOfflinePlayerJob(data.employeeId, 'unemployed', 'fire', playerGrade)
    end
    
    local targetGrade = GetPlayerJobGrade(targetPlayer)
    
    -- Check permissions
    if targetGrade >= playerGrade then
        return { success = false, message = "Cannot fire employee with equal or higher grade" }
    end
    
    local success = SetPlayerJob(targetPlayer, 'unemployed', 0)
    if success then
        TriggerClientEvent('okokRequests:notify', GetPlayerSource(targetPlayer), {
            title = "Job Manager",
            text = "You have been fired from your job",
            duration = 5000
        })
        
        return { success = true }
    else
        return { success = false, message = "Failed to fire employee" }
    end
end)

-- Give bonus
lib.callback.register('job-manager:giveBonus', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local playerJob = GetPlayerJob(Player)
    local playerGrade = GetPlayerJobGrade(Player)
    
    -- Check permissions
    if playerGrade < 1 then
        return { success = false, message = "Insufficient permissions" }
    end
    
    -- Check society funds (ESX) or company account
    local jobName = playerJob
    if ESX then
        local society = exports.oxmysql:single_async('SELECT money FROM addon_account_data WHERE account_name = ?', { 'society_' .. jobName })
        local societyMoney = society and society.money or 0
        
        if societyMoney < data.amount then
            return { success = false, message = "Insufficient company funds" }
        end
        
        -- Deduct from society
        exports.oxmysql:update_async('UPDATE addon_account_data SET money = money - ? WHERE account_name = ?', { data.amount, 'society_' .. jobName })
    end
    
    -- Find target player
    local targetPlayer = FindPlayerByIdentifier(data.employeeId)
    if not targetPlayer then
        return { success = false, message = "Employee must be online to receive bonus" }
    end
    
    -- Give money to employee
    local success = AddPlayerMoney(targetPlayer, data.amount)
    if success then
        TriggerClientEvent('okokRequests:notify', GetPlayerSource(targetPlayer), {
            title = "Job Manager",
            text = string.format("You received a $%d bonus!", data.amount),
            duration = 5000
        })
        
        return { success = true }
    else
        return { success = false, message = "Failed to give bonus" }
    end
end)

-- Utility functions
function GetPlayer(src)
    if ESX then
        return ESX.GetPlayerFromId(src)
    elseif QBCore then
        return QBCore.Functions.GetPlayer(src)
    end
    return nil
end

function GetPlayerIdentifier(src)
    if not src then return nil end
    
    if ESX then
        local Player = ESX.GetPlayerFromId(src)
        return Player and Player.identifier
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        return Player and Player.PlayerData.citizenid
    end
    return nil
end

function GetPlayerJob(Player)
    if ESX then
        return Player.job and Player.job.name
    elseif QBCore then
        return Player.PlayerData.job and Player.PlayerData.job.name
    end
    return nil
end

function GetPlayerJobGrade(Player)
    if ESX then
        return Player.job and Player.job.grade or 0
    elseif QBCore then
        return Player.PlayerData.job and Player.PlayerData.job.grade.level or 0
    end
    return 0
end

function GetPlayerName(Player)
    if ESX then
        return Player.getName()
    elseif QBCore then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    end
    return "Unknown"
end

function GetPlayerSource(Player)
    if ESX then
        return Player.source
    elseif QBCore then
        return Player.PlayerData.source
    end
    return nil
end

function GetJobInfo(jobName)
    if ESX then
        local job = exports.oxmysql:single_async('SELECT label FROM jobs WHERE name = ?', { jobName })
        return job
    elseif QBCore then
        return QBCore.Shared.Jobs[jobName]
    end
    return nil
end

function GetJobGrades(jobName)
    if ESX then
        local grades = exports.oxmysql:query_async('SELECT grade, name, salary FROM job_grades WHERE job_name = ? ORDER BY grade ASC', { jobName })
        return grades or {}
    elseif QBCore then
        local job = QBCore.Shared.Jobs[jobName]
        if not job or not job.grades then return {} end
        
        local grades = {}
        for gradeLevel, gradeData in pairs(job.grades) do
            table.insert(grades, {
                grade = gradeLevel,
                name = gradeData.name,
                salary = gradeData.payment
            })
        end
        
        table.sort(grades, function(a, b) return a.grade < b.grade end)
        return grades
    end
    return {}
end

function GetJobEmployees(jobName)
    if ESX then
        local employees = exports.oxmysql:query_async([[
            SELECT u.identifier, u.firstname, u.lastname, u.job_grade, jg.name as grade_name, u.last_seen
            FROM users u 
            JOIN job_grades jg ON u.job = jg.job_name AND u.job_grade = jg.grade
            WHERE u.job = ?
            ORDER BY u.job_grade DESC, u.firstname ASC
        ]], { jobName })
        
        local formatted = {}
        for i = 1, #employees do
            local emp = employees[i]
            table.insert(formatted, {
                identifier = emp.identifier,
                name = emp.firstname .. ' ' .. emp.lastname,
                grade = emp.job_grade,
                gradeName = emp.grade_name,
                lastSeen = emp.last_seen,
                hireDate = emp.last_seen -- Placeholder, could be enhanced
            })
        end
        return formatted
    elseif QBCore then
        local employees = exports.oxmysql:query_async([[
            SELECT citizenid, charinfo, job
            FROM players 
            WHERE JSON_EXTRACT(job, '$.name') = ?
            ORDER BY JSON_EXTRACT(job, '$.grade.level') DESC
        ]], { jobName })
        
        local formatted = {}
        for i = 1, #employees do
            local emp = employees[i]
            local charinfo = json.decode(emp.charinfo)
            local job = json.decode(emp.job)
            
            table.insert(formatted, {
                identifier = emp.citizenid,
                name = charinfo.firstname .. ' ' .. charinfo.lastname,
                grade = job.grade.level,
                gradeName = job.grade.name,
                lastSeen = emp.last_login,
                hireDate = emp.last_login -- Placeholder, could be enhanced
            })
        end
        return formatted
    end
    return {}
end

function GetGradeName(jobName, grade)
    if ESX then
        local gradeInfo = exports.oxmysql:single_async('SELECT name FROM job_grades WHERE job_name = ? AND grade = ?', { jobName, grade })
        return gradeInfo and gradeInfo.name or 'Unknown'
    elseif QBCore then
        local job = QBCore.Shared.Jobs[jobName]
        if job and job.grades and job.grades[grade] then
            return job.grades[grade].name
        end
        return 'Unknown'
    end
    return 'Unknown'
end

function GetMaxJobGrade(jobName)
    if ESX then
        local maxGrade = exports.oxmysql:single_async('SELECT MAX(grade) as max_grade FROM job_grades WHERE job_name = ?', { jobName })
        return maxGrade and maxGrade.max_grade or 0
    elseif QBCore then
        local job = QBCore.Shared.Jobs[jobName]
        if not job or not job.grades then return 0 end
        
        local max = 0
        for gradeLevel, _ in pairs(job.grades) do
            if gradeLevel > max then
                max = gradeLevel
            end
        end
        return max
    end
    return 0
end

function FindPlayer(input)
    local players = GetPlayers()
    
    -- Try to find by exact ID first
    local playerId = tonumber(input)
    if playerId then
        for _, id in ipairs(players) do
            if tonumber(id) == playerId then
                return GetPlayer(id)
            end
        end
    end
    
    -- Try to find by name
    local inputLower = string.lower(input)
    for _, id in ipairs(players) do
        local player = GetPlayer(id)
        if player then
            local name = GetPlayerName(player)
            if string.find(string.lower(name), inputLower, 1, true) then
                return player
            end
        end
    end
    
    return nil
end

function FindPlayerByIdentifier(identifier)
    local players = GetPlayers()
    
    for _, id in ipairs(players) do
        local playerIdentifier = GetPlayerIdentifier(id)
        if playerIdentifier == identifier then
            return GetPlayer(id)
        end
    end
    
    return nil
end

function SetPlayerJob(Player, jobName, grade)
    if ESX then
        Player.setJob(jobName, grade)
        return true
    elseif QBCore then
        local success = Player.Functions.SetJob(jobName, grade)
        return success
    end
    return false
end

function AddPlayerMoney(Player, amount)
    if ESX then
        Player.addMoney(amount)
        return true
    elseif QBCore then
        local success = Player.Functions.AddMoney('cash', amount)
        return success
    end
    return false
end

function UpdateOfflinePlayerJob(identifier, jobName, action, managerGrade)
    if ESX then
        local currentJob = exports.oxmysql:single_async('SELECT job, job_grade FROM users WHERE identifier = ?', { identifier })
        if not currentJob then
            return { success = false, message = "Employee not found" }
        end
        
        local newGrade = currentJob.job_grade
        if action == 'promote' then
            newGrade = newGrade + 1
            if newGrade >= managerGrade then
                return { success = false, message = "Cannot promote to equal or higher grade than yours" }
            end
        elseif action == 'demote' then
            newGrade = newGrade - 1
            if newGrade < 0 then
                return { success = false, message = "Employee is already at minimum grade" }
            end
        elseif action == 'fire' then
            jobName = 'unemployed'
            newGrade = 0
        end
        
        exports.oxmysql:update_async('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { jobName, newGrade, identifier })
        return { success = true }
    elseif QBCore then
        local player = exports.oxmysql:single_async('SELECT job FROM players WHERE citizenid = ?', { identifier })
        if not player then
            return { success = false, message = "Employee not found" }
        end
        
        local job = json.decode(player.job)
        local newGrade = job.grade.level
        
        if action == 'promote' then
            newGrade = newGrade + 1
            if newGrade >= managerGrade then
                return { success = false, message = "Cannot promote to equal or higher grade than yours" }
            end
        elseif action == 'demote' then
            newGrade = newGrade - 1
            if newGrade < 0 then
                return { success = false, message = "Employee is already at minimum grade" }
            end
        elseif action == 'fire' then
            jobName = 'unemployed'
            newGrade = 0
        end
        
        local newJob = {
            name = jobName,
            grade = {
                level = newGrade,
                name = GetGradeName(jobName, newGrade)
            }
        }
        
        exports.oxmysql:update_async('UPDATE players SET job = ? WHERE citizenid = ?', { json.encode(newJob), identifier })
        return { success = true }
    end
    
    return { success = false, message = "Framework not supported" }
end
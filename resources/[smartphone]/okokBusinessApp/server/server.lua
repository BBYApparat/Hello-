-- Initialize ESX using modern exports method
local ESX = exports['es_extended']:getSharedObject()

-- Get business directory data
RegisterNUICallback('getBusinessData', function(data, cb)
    local businesses = {}
    
    -- Get all configured jobs
    for _, job in ipairs(Config.Jobs) do
        local onlineEmployees = {}
        
        -- Get all online players with this job
        local xPlayers = ESX.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == job.name then
                table.insert(onlineEmployees, {
                    serverId = playerId,
                    name = xPlayer.getName(),
                    grade = xPlayer.job.grade,
                    gradeLabel = xPlayer.job.grade_label,
                    phoneNumber = xPlayer.getPhoneNumber and xPlayer.getPhoneNumber() or "Unknown"
                })
            end
        end
        
        -- Add business to list
        table.insert(businesses, {
            name = job.name,
            label = job.label,
            description = job.description,
            icon = job.icon,
            color = job.color,
            rating = job.rating,
            category = job.category,
            emergency = job.emergency or false,
            onlineCount = #onlineEmployees,
            employees = onlineEmployees
        })
    end
    
    cb({
        success = true,
        businesses = businesses,
        categories = Config.Categories
    })
end)

-- Get specific business details
RegisterNUICallback('getBusinessDetails', function(data, cb)
    local businessName = data.businessName
    local src = source
    
    if not businessName then
        cb({success = false, message = "Business name required"})
        return
    end
    
    -- Find the business config
    local businessConfig = nil
    for _, job in ipairs(Config.Jobs) do
        if job.name == businessName then
            businessConfig = job
            break
        end
    end
    
    if not businessConfig then
        cb({success = false, message = "Business not found"})
        return
    end
    
    -- Get online employees
    local employees = {}
    local xPlayers = ESX.GetPlayers()
    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job.name == businessName then
            table.insert(employees, {
                serverId = playerId,
                name = xPlayer.getName(),
                grade = xPlayer.job.grade,
                gradeLabel = xPlayer.job.grade_label,
                phoneNumber = xPlayer.getPhoneNumber and xPlayer.getPhoneNumber() or ("555-" .. string.format("%04d", playerId))
            })
        end
    end
    
    cb({
        success = true,
        business = businessConfig,
        employees = employees
    })
end)

-- Get employee contact details for calling/messaging
RegisterNUICallback('getEmployeeContact', function(data, cb)
    local targetId = data.targetId
    local src = source
    
    if not targetId then
        cb({success = false, message = "Target ID required"})
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    
    if not xPlayer or not targetPlayer then
        cb({success = false, message = "Player not found"})
        return
    end
    
    -- Get phone numbers - try different methods for phone number retrieval
    local targetNumber
    if targetPlayer.getPhoneNumber then
        targetNumber = targetPlayer.getPhoneNumber()
    elseif targetPlayer.get then
        targetNumber = targetPlayer.get('phoneNumber')
    else
        -- Fallback to generated number
        targetNumber = "555-" .. string.format("%04d", targetId)
    end
    
    cb({
        success = true,
        contact = {
            name = targetPlayer.getName(),
            phoneNumber = targetNumber,
            job = targetPlayer.job.label,
            grade = targetPlayer.job.grade_label
        }
    })
end)

-- Handle business call logging (optional)
RegisterServerEvent('okokBusinessApp:server:logBusinessCall')
AddEventHandler('okokBusinessApp:server:logBusinessCall', function(targetId, businessName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    
    if xPlayer and targetPlayer then
        print(("[Business Directory] %s called %s from %s business"):format(
            xPlayer.getName(), 
            targetPlayer.getName(), 
            businessName
        ))
        
        -- Could add database logging here if needed
        -- MySQL.Async.execute('INSERT INTO business_calls ...')
    end
end)

-- Handle business message logging (optional)
RegisterServerEvent('okokBusinessApp:server:logBusinessMessage')
AddEventHandler('okokBusinessApp:server:logBusinessMessage', function(targetId, message, businessName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    
    if xPlayer and targetPlayer then
        print(("[Business Directory] %s messaged %s from %s business: %s"):format(
            xPlayer.getName(), 
            targetPlayer.getName(), 
            businessName,
            message
        ))
        
        -- Notify target player about business inquiry
        TriggerClientEvent('okokBusinessApp:client:messageReceived', targetId, 
            xPlayer.getName(), xPlayer.getName(), message, businessName)
    end
end)

-- Handle triggering server events from NUI
RegisterNUICallback('triggerServerEvent', function(data, cb)
    local eventName = data.eventName
    local args = data.args or {}
    
    if eventName then
        TriggerServerEvent(eventName, table.unpack(args))
        cb({success = true})
    else
        cb({success = false, message = "Event name required"})
    end
end)
-- Initialize ESX using modern exports method
local ESX = exports['es_extended']:getSharedObject()

-- Function to get average rating for a business
local function getBusinessRating(businessName)
    local rating = 0
    local ratingCount = 0
    
    local result = MySQL.Sync.fetchAll('SELECT AVG(rating) as avg_rating, COUNT(*) as count FROM business_ratings WHERE business_name = ?', {businessName})
    
    if result and result[1] then
        rating = result[1].avg_rating or 0
        ratingCount = result[1].count or 0
    end
    
    return math.max(1, math.min(5, math.floor(rating + 0.5))), ratingCount -- Round to nearest integer, ensure 1-5 range
end

-- Function to get player mugshot
local function getPlayerMugshot(serverId)
    local mugshot = nil
    
    -- Try to get cached mugshot first
    local result = MySQL.Sync.fetchAll('SELECT mugshot FROM player_mugshots WHERE server_id = ?', {serverId})
    if result and result[1] and result[1].mugshot then
        return result[1].mugshot
    end
    
    -- If no cached mugshot, request new one from client
    TriggerClientEvent('okokBusinessApp:requestMugshot', serverId, serverId)
    return nil -- Will be cached and available next time
end

-- Store mugshot in database
RegisterServerEvent('okokBusinessApp:storeMugshot')
AddEventHandler('okokBusinessApp:storeMugshot', function(serverId, mugshotBase64)
    local src = source
    
    if serverId and mugshotBase64 then
        -- Store/update mugshot in database
        MySQL.Async.execute('INSERT INTO player_mugshots (server_id, mugshot, updated_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE mugshot = VALUES(mugshot), updated_at = NOW()', 
        {serverId, mugshotBase64})
        
        print(("[Business Directory] Stored mugshot for player %s"):format(serverId))
    end
end)

-- Get business directory data
ESX.RegisterServerCallback('okokBusinessApp:getBusinessData', function(source, cb)
    -- Wrap in pcall for error handling
    local success, result = pcall(function()
        local businesses = {}
    
    -- Get all configured jobs
    for _, job in ipairs(Config.Jobs) do
        local onlineEmployees = {}
        
        -- Get all online players with this job
        local xPlayers = ESX.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == job.name then
                local mugshot = getPlayerMugshot(playerId)
                
                table.insert(onlineEmployees, {
                    serverId = playerId,
                    name = xPlayer.getName(),
                    grade = xPlayer.job.grade,
                    gradeLabel = xPlayer.job.grade_label,
                    phoneNumber = xPlayer.getPhoneNumber and xPlayer.getPhoneNumber() or "Unknown",
                    mugshot = mugshot
                })
            end
        end
        
        -- Get dynamic rating from database
        local businessRating, ratingCount = getBusinessRating(job.name)
        
        -- Add business to list
        table.insert(businesses, {
            name = job.name,
            label = job.label,
            description = job.description,
            icon = job.icon,
            color = job.color,
            rating = businessRating,
            ratingCount = ratingCount,
            category = job.category,
            emergency = job.emergency or false,
            onlineCount = #onlineEmployees,
            employees = onlineEmployees,
            image = job.image or nil
        })
    end
    
        return {
            success = true,
            businesses = businesses,
            categories = Config.Categories
        }
    end)
    
    if success then
        cb(result)
    else
        print("Error in getBusinessData:", result)
        cb({success = false, message = "Internal server error"})
    end
end)

-- Get specific business details
ESX.RegisterServerCallback('okokBusinessApp:getBusinessDetails', function(source, cb, businessName)
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
            local mugshot = getPlayerMugshot(playerId)
            
            table.insert(employees, {
                serverId = playerId,
                name = xPlayer.getName(),
                grade = xPlayer.job.grade,
                gradeLabel = xPlayer.job.grade_label,
                phoneNumber = xPlayer.getPhoneNumber and xPlayer.getPhoneNumber() or ("555-" .. string.format("%04d", playerId)),
                mugshot = mugshot
            })
        end
    end
    
    -- Get dynamic rating
    local businessRating, ratingCount = getBusinessRating(businessName)
    
    -- Update business config with dynamic rating
    local businessWithRating = {}
    for k, v in pairs(businessConfig) do
        businessWithRating[k] = v
    end
    businessWithRating.rating = businessRating
    businessWithRating.ratingCount = ratingCount
    
    cb({
        success = true,
        business = businessWithRating,
        employees = employees
    })
end)

-- Get employee contact details for calling/messaging
ESX.RegisterServerCallback('okokBusinessApp:getEmployeeContact', function(source, cb, targetId)
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

-- Submit business rating
ESX.RegisterServerCallback('okokBusinessApp:submitRating', function(source, cb, businessName, rating, comment)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        cb({success = false, message = "Player not found"})
        return
    end
    
    if not businessName or not rating or rating < 1 or rating > 5 then
        cb({success = false, message = "Invalid rating data"})
        return
    end
    
    local identifier = xPlayer.getIdentifier()
    
    -- Insert or update rating
    MySQL.Async.execute('INSERT INTO business_ratings (user_identifier, business_name, rating, comment) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment), updated_at = CURRENT_TIMESTAMP', 
    {identifier, businessName, rating, comment or ''}, function(affectedRows)
        if affectedRows > 0 then
            cb({success = true, message = "Rating submitted successfully"})
        else
            cb({success = false, message = "Failed to submit rating"})
        end
    end)
end)

-- Get user's existing rating for a business
ESX.RegisterServerCallback('okokBusinessApp:getUserRating', function(source, cb, businessName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        cb({success = false, message = "Player not found"})
        return
    end
    
    local identifier = xPlayer.getIdentifier()
    
    MySQL.Async.fetchAll('SELECT rating, comment FROM business_ratings WHERE user_identifier = ? AND business_name = ?', 
    {identifier, businessName}, function(result)
        if result and result[1] then
            cb({
                success = true,
                rating = result[1].rating,
                comment = result[1].comment
            })
        else
            cb({success = true, rating = 0, comment = ""})
        end
    end)
end)

-- Note: NUI callbacks should be in client scripts, not server scripts
-- The triggerServerEvent functionality should be handled client-side
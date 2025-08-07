-- Company Reviews Server
local QBCore = nil
local ESX = nil

-- Framework detection
if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports["es_extended"]:getSharedObject()
end

-- Get companies with reviews and replies
lib.callback.register('company-reviews:getCompanies', function(source)
    local src = source
    
    -- First, sync ESX jobs with companies table if ESX is available
    if ESX then
        syncESXJobs()
    end
    
    local companies = MySQL.query.await([[
        SELECT 
            c.id,
            c.name,
            c.description,
            c.category,
            c.image_url,
            c.owner_identifier,
            COALESCE(AVG(r.rating), 0) as average_rating,
            COUNT(r.id) as total_reviews
        FROM company_reviews_companies c
        LEFT JOIN company_reviews_reviews r ON c.id = r.company_id
        GROUP BY c.id
        ORDER BY c.name
    ]])
    
    if not companies then
        return { success = false, message = "Failed to fetch companies" }
    end
    
    -- Get reviews for each company
    for i = 1, #companies do
        local company = companies[i]
        
        local reviews = MySQL.query.await([[
            SELECT 
                r.id,
                r.reviewer_name,
                r.rating,
                r.review_text,
                r.created_at,
                rep.reply_text,
                rep.created_at as reply_date
            FROM company_reviews_reviews r
            LEFT JOIN company_reviews_replies rep ON r.id = rep.review_id
            WHERE r.company_id = ?
            ORDER BY r.created_at DESC
        ]], { company.id })
        
        company.reviews = reviews or {}
    end
    
    return {
        success = true,
        companies = companies
    }
end)

-- Save review
lib.callback.register('company-reviews:saveReview', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local identifier = GetPlayerIdentifier(Player)
    local playerName = GetPlayerName(Player)
    
    -- Check if company exists
    local existingCompany = MySQL.single.await('SELECT id FROM company_reviews_companies WHERE LOWER(name) = LOWER(?)', { data.companyName })
    
    local companyId
    if existingCompany then
        companyId = existingCompany.id
        
        -- Update company description if provided
        if data.description and #data.description > 0 then
            MySQL.update.await('UPDATE company_reviews_companies SET description = ? WHERE id = ?', { data.description, companyId })
        end
    else
        -- Create new company
        companyId = MySQL.insert.await([[
            INSERT INTO company_reviews_companies (name, description, category) 
            VALUES (?, ?, ?)
        ]], { data.companyName, data.description or '', data.category })
        
        if not companyId then
            return { success = false, message = "Failed to create company" }
        end
    end
    
    -- Check if player already reviewed this company
    local existingReview = MySQL.single.await([[
        SELECT id FROM company_reviews_reviews 
        WHERE company_id = ? AND reviewer_identifier = ?
    ]], { companyId, identifier })
    
    if existingReview then
        -- Update existing review
        local success = MySQL.update.await([[
            UPDATE company_reviews_reviews 
            SET rating = ?, review_text = ?, updated_at = CURRENT_TIMESTAMP()
            WHERE id = ?
        ]], { data.rating, data.reviewText, existingReview.id })
        
        if success then
            return { success = true, message = "Review updated successfully" }
        else
            return { success = false, message = "Failed to update review" }
        end
    else
        -- Create new review
        local reviewId = MySQL.insert.await([[
            INSERT INTO company_reviews_reviews (company_id, reviewer_identifier, reviewer_name, rating, review_text) 
            VALUES (?, ?, ?, ?, ?)
        ]], { companyId, identifier, playerName, data.rating, data.reviewText })
        
        if reviewId then
            return { success = true, message = "Review added successfully" }
        else
            return { success = false, message = "Failed to save review" }
        end
    end
end)

-- Add company reply (only for company owners)
lib.callback.register('company-reviews:addReply', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local identifier = GetPlayerIdentifier(Player)
    
    -- Check if player owns this company
    local company = MySQL.single.await([[
        SELECT id, name FROM company_reviews_companies 
        WHERE id = ? AND owner_identifier = ?
    ]], { data.companyId, identifier })
    
    if not company then
        return { success = false, message = "You don't have permission to reply for this company" }
    end
    
    -- Check if reply already exists
    local existingReply = MySQL.single.await('SELECT id FROM company_reviews_replies WHERE review_id = ?', { data.reviewId })
    
    if existingReply then
        -- Update existing reply
        local success = MySQL.update.await([[
            UPDATE company_reviews_replies 
            SET reply_text = ?, updated_at = CURRENT_TIMESTAMP()
            WHERE review_id = ?
        ]], { data.replyText, data.reviewId })
        
        if success then
            return { success = true, message = "Reply updated successfully" }
        else
            return { success = false, message = "Failed to update reply" }
        end
    else
        -- Create new reply
        local replyId = MySQL.insert.await([[
            INSERT INTO company_reviews_replies (review_id, company_id, reply_text, replied_by) 
            VALUES (?, ?, ?, ?)
        ]], { data.reviewId, data.companyId, data.replyText, identifier })
        
        if replyId then
            return { success = true, message = "Reply added successfully" }
        else
            return { success = false, message = "Failed to save reply" }
        end
    end
end)

-- Set company owner
lib.callback.register('company-reviews:setCompanyOwner', function(source, data)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then
        return { success = false, message = "Player not found" }
    end
    
    local identifier = GetPlayerIdentifier(Player)
    
    -- Update company owner
    local success = MySQL.update.await([[
        UPDATE company_reviews_companies 
        SET owner_identifier = ? 
        WHERE LOWER(name) = LOWER(?) AND owner_identifier IS NULL
    ]], { identifier, data.companyName })
    
    if success then
        return { success = true, message = "You are now the owner of " .. data.companyName }
    else
        return { success = false, message = "Company not found or already has an owner" }
    end
end)

-- Get player function that works with both frameworks
function GetPlayer(src)
    if ESX then
        return ESX.GetPlayerFromId(src)
    elseif QBCore then
        return QBCore.Functions.GetPlayer(src)
    end
    return nil
end

-- Get player identifier
function GetPlayerIdentifier(Player)
    if ESX then
        return Player.identifier
    elseif QBCore then
        return Player.PlayerData.citizenid
    end
    return nil
end

-- Get player name
function GetPlayerName(Player)
    if ESX then
        return Player.getName()
    elseif QBCore then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    end
    return "Unknown"
end

-- Sync ESX jobs with companies table
function syncESXJobs()
    -- Get all ESX jobs
    local jobs = MySQL.query.await('SELECT name, label FROM jobs WHERE 1')
    
    if jobs then
        for i = 1, #jobs do
            local job = jobs[i]
            
            -- Skip default jobs
            if job.name ~= 'unemployed' and job.name ~= 'police' and job.name ~= 'ambulance' then
                -- Check if company already exists
                local existingCompany = MySQL.single.await([[
                    SELECT id FROM company_reviews_companies WHERE LOWER(name) = LOWER(?)
                ]], { job.label })
                
                if not existingCompany then
                    -- Determine category based on job name
                    local category = 'services' -- default
                    if string.find(job.name:lower(), 'mechanic') or string.find(job.name:lower(), 'auto') then
                        category = 'automotive'
                    elseif string.find(job.name:lower(), 'restaurant') or string.find(job.name:lower(), 'burger') or string.find(job.name:lower(), 'pizza') then
                        category = 'restaurant'
                    elseif string.find(job.name:lower(), 'shop') or string.find(job.name:lower(), 'store') or string.find(job.name:lower(), 'mall') then
                        category = 'retail'
                    elseif string.find(job.name:lower(), 'hospital') or string.find(job.name:lower(), 'clinic') then
                        category = 'healthcare'
                    elseif string.find(job.name:lower(), 'club') or string.find(job.name:lower(), 'casino') or string.find(job.name:lower(), 'entertainment') then
                        category = 'entertainment'
                    end
                    
                    -- Insert new company from ESX job
                    MySQL.insert.await([[
                        INSERT INTO company_reviews_companies (name, description, category) 
                        VALUES (?, ?, ?)
                    ]], { job.label, 'Business registered in the city', category })
                end
            end
        end
    end
end

function getCompanySocietyMoney(jobName)
    if not ESX then return 0 end
    
    local society = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', { 'society_' .. jobName })
    return society and society.money or 0
end
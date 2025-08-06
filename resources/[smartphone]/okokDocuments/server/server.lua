-- okokDocuments Server
-- ESX Document Management System

local ESX = exports['es_extended']:getSharedObject()

-- Create database table on resource start
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `phone_documents` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `title` varchar(100) NOT NULL,
            `content` longtext NOT NULL,
            `type` varchar(50) NOT NULL DEFAULT 'other',
            `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
            `lastupdate` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
    
    if Config.Debug then
        print('^2[okokDocuments]^7 Database table created/verified')
    end
end)

-- Utility Functions
local function GetPlayerFromId(source)
    return ESX.GetPlayerFromId(source)
end

local function GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

local function SendNotification(source, title, message, type, duration)
    notifyDI(source, {
        app = 'Documents',
        title = title,
        text = message,
        duration = duration or Config.Notifications.duration
    })
end

-- Get all documents for a player
RegisterNetEvent('okokDocuments:server:getDocuments', function()
    local src = source
    local xPlayer = GetPlayerFromId(src)
    
    if not xPlayer then
        if Config.Debug then
            print('^3[okokDocuments]^7 Player not found: ' .. src)
        end
        return
    end
    
    local identifier = xPlayer.identifier
    
    MySQL.query('SELECT * FROM phone_documents WHERE identifier = ? ORDER BY lastupdate DESC', {identifier}, function(result)
        TriggerClientEvent('okokDocuments:client:receiveDocuments', src, {
            success = true,
            documents = result or {}
        })
    end)
end)

-- Save document (create or update)
RegisterNetEvent('okokDocuments:server:saveDocument', function(data)
    local src = source
    local xPlayer = GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local identifier = xPlayer.identifier
    
    -- Validate data
    if not data.title or not data.content or not data.action then
        TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
            success = false,
            message = 'Invalid document data'
        })
        return
    end
    
    -- Sanitize inputs
    local title = string.sub(data.title, 1, Config.Documents.maxTitleLength)
    local content = string.sub(data.content, 1, Config.Documents.maxContentLength)
    local docType = data.type or 'other'
    
    if data.action == 'new' then
        -- Check document limit
        MySQL.query('SELECT COUNT(*) as count FROM phone_documents WHERE identifier = ?', {identifier}, function(result)
            local count = result[1]?.count or 0
            
            if count >= Config.Documents.maxDocumentsPerPlayer then
                TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
                    success = false,
                    message = 'Document limit reached'
                })
                return
            end
            
            -- Create new document
            MySQL.insert('INSERT INTO phone_documents (identifier, title, content, type) VALUES (?, ?, ?, ?)', 
                {identifier, title, content, docType}, function(insertId)
                if insertId then
                    SendNotification(src, 'Documents', 'Document created successfully')
                    TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
                        success = true,
                        message = 'Document created',
                        id = insertId
                    })
                else
                    TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
                        success = false,
                        message = 'Failed to create document'
                    })
                end
            end)
        end)
        
    elseif data.action == 'update' and data.id then
        -- Update existing document
        MySQL.update('UPDATE phone_documents SET title = ?, content = ?, type = ?, lastupdate = CURRENT_TIMESTAMP WHERE id = ? AND identifier = ?', 
            {title, content, docType, data.id, identifier}, function(affectedRows)
            if affectedRows > 0 then
                SendNotification(src, 'Documents', 'Document updated successfully')
                TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
                    success = true,
                    message = 'Document updated'
                })
            else
                TriggerClientEvent('okokDocuments:client:saveDocumentResponse', src, {
                    success = false,
                    message = 'Document not found or access denied'
                })
            end
        end)
    end
end)

-- Delete document
RegisterNetEvent('okokDocuments:server:deleteDocument', function(data)
    local src = source
    local xPlayer = GetPlayerFromId(src)
    
    if not xPlayer or not data.id then return end
    
    local identifier = xPlayer.identifier
    
    MySQL.update('DELETE FROM phone_documents WHERE id = ? AND identifier = ?', {data.id, identifier}, function(affectedRows)
        if affectedRows > 0 then
            SendNotification(src, 'Documents', 'Document deleted successfully')
            TriggerClientEvent('okokDocuments:client:deleteDocumentResponse', src, {
                success = true,
                message = 'Document deleted'
            })
        else
            TriggerClientEvent('okokDocuments:client:deleteDocumentResponse', src, {
                success = false,
                message = 'Document not found or access denied'
            })
        end
    end)
end)

-- Share document locally (to nearby players)
RegisterNetEvent('okokDocuments:server:shareDocumentLocal', function(data)
    local src = source
    local xPlayer = GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    local senderName = xPlayer.getName()
    local senderCoords = GetEntityCoords(GetPlayerPed(src))
    
    -- Find nearby players
    local nearbyPlayers = {}
    local players = ESX.GetExtendedPlayers()
    
    for _, player in pairs(players) do
        if player.source ~= src then
            local targetCoords = GetEntityCoords(GetPlayerPed(player.source))
            local distance = #(senderCoords - targetCoords)
            
            if distance <= Config.Sharing.localShareDistance then
                table.insert(nearbyPlayers, player.source)
            end
        end
    end
    
    if #nearbyPlayers == 0 then
        TriggerClientEvent('okokDocuments:client:shareLocalResponse', src, {
            success = false,
            message = 'No players nearby'
        })
        return
    end
    
    -- Send document to nearby players
    for _, playerId in ipairs(nearbyPlayers) do
        TriggerClientEvent('okokDocuments:client:receiveSharedDocument', playerId, {
            senderName = senderName,
            title = data.title,
            content = data.content,
            type = data.type,
            temporary = true
        })
    end
    
    SendNotification(src, 'Documents', 'Document shared with ' .. #nearbyPlayers .. ' nearby player(s)')
    TriggerClientEvent('okokDocuments:client:shareLocalResponse', src, {
        success = true,
        message = 'Document shared locally'
    })
end)

-- Share document permanently (by State ID)
RegisterNetEvent('okokDocuments:server:shareDocumentPermanent', function(data)
    local src = source
    local xPlayer = GetPlayerFromId(src)
    
    if not xPlayer or not data.stateId then return end
    
    local senderName = xPlayer.getName()
    
    -- Find target player by State ID (assuming State ID is stored in a specific way)
    -- This will need to be adapted based on how your server stores State IDs
    local targetPlayer = nil
    local players = ESX.GetExtendedPlayers()
    
    for _, player in pairs(players) do
        -- Adjust this query based on your database structure
        -- You might need to check users table or another table for State ID
        if tostring(player.source) == data.stateId then -- Temporary - replace with proper State ID lookup
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        TriggerClientEvent('okokDocuments:client:sharePermanentResponse', src, {
            success = false,
            message = 'Player with State ID ' .. data.stateId .. ' not found'
        })
        return
    end
    
    if targetPlayer.identifier == xPlayer.identifier then
        TriggerClientEvent('okokDocuments:client:sharePermanentResponse', src, {
            success = false,
            message = 'You cannot send a document to yourself'
        })
        return
    end
    
    -- Create document for target player
    MySQL.insert('INSERT INTO phone_documents (identifier, title, content, type) VALUES (?, ?, ?, ?)', 
        {targetPlayer.identifier, '[RECEIVED] ' .. data.title, data.content, data.type}, function(insertId)
        if insertId then
            -- Notify both players
            SendNotification(src, 'Documents', 'Document sent successfully')
            SendNotification(targetPlayer.source, 'Documents', 'New document received from ' .. senderName)
            
            TriggerClientEvent('okokDocuments:client:sharePermanentResponse', src, {
                success = true,
                message = 'Document sent'
            })
            
            -- Refresh target player's documents
            TriggerEvent('okokDocuments:server:getDocuments', targetPlayer.source)
        else
            TriggerClientEvent('okokDocuments:client:sharePermanentResponse', src, {
                success = false,
                message = 'Failed to send document'
            })
        end
    end)
end)

-- Command to refresh documents (for testing)
if Config.Debug then
    RegisterCommand('reloaddocs', function(source, args, rawCommand)
        local src = source
        if src > 0 then
            TriggerEvent('okokDocuments:server:getDocuments', src)
            print('^2[okokDocuments]^7 Documents reloaded for player: ' .. src)
        end
    end, false)
end

print('^2[okokDocuments]^7 Server started successfully')
-- okokDocuments Client
-- ESX Document Management System Client-Side

local ESX = exports['es_extended']:getSharedObject()

-- NUI Callbacks for handling web interface requests

-- Get all documents for the player
RegisterNUICallback('getDocuments', function(data, cb)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client requesting documents')
    end
    
    TriggerServerEvent('okokDocuments:server:getDocuments')
    
    -- Callback will be handled by server response
    cb({ success = true })
end)

-- Save document (create or update)
RegisterNUICallback('saveDocument', function(data, cb)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client saving document:', json.encode(data))
    end
    
    TriggerServerEvent('okokDocuments:server:saveDocument', data)
    
    cb({ success = true })
end)

-- Delete document
RegisterNUICallback('deleteDocument', function(data, cb)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client deleting document:', json.encode(data))
    end
    
    TriggerServerEvent('okokDocuments:server:deleteDocument', data)
    
    cb({ success = true })
end)

-- Share document locally
RegisterNUICallback('shareDocumentLocal', function(data, cb)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client sharing document locally:', json.encode(data))
    end
    
    TriggerServerEvent('okokDocuments:server:shareDocumentLocal', data)
    
    cb({ success = true })
end)

-- Share document permanently by State ID
RegisterNUICallback('shareDocumentPermanent', function(data, cb)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client sharing document permanently:', json.encode(data))
    end
    
    TriggerServerEvent('okokDocuments:server:shareDocumentPermanent', data)
    
    cb({ success = true })
end)

-- Client Events for handling server responses

-- Receive documents from server
RegisterNetEvent('okokDocuments:client:receiveDocuments', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Client received documents:', json.encode(data))
    end
    
    -- Send data to NUI
    SendNUIMessage({
        action = 'receiveDocuments',
        data = data
    })
end)

-- Handle save document response
RegisterNetEvent('okokDocuments:client:saveDocumentResponse', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Save document response:', json.encode(data))
    end
    
    -- Send response to NUI
    SendNUIMessage({
        action = 'saveDocumentResponse',
        data = data
    })
end)

-- Handle delete document response
RegisterNetEvent('okokDocuments:client:deleteDocumentResponse', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Delete document response:', json.encode(data))
    end
    
    -- Send response to NUI
    SendNUIMessage({
        action = 'deleteDocumentResponse',
        data = data
    })
end)

-- Handle local share response
RegisterNetEvent('okokDocuments:client:shareLocalResponse', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Share local response:', json.encode(data))
    end
    
    -- Send response to NUI
    SendNUIMessage({
        action = 'shareLocalResponse',
        data = data
    })
end)

-- Handle permanent share response
RegisterNetEvent('okokDocuments:client:sharePermanentResponse', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Share permanent response:', json.encode(data))
    end
    
    -- Send response to NUI
    SendNUIMessage({
        action = 'sharePermanentResponse',
        data = data
    })
end)

-- Receive shared document from another player
RegisterNetEvent('okokDocuments:client:receiveSharedDocument', function(data)
    if Config.Debug then
        print('^2[okokDocuments]^7 Received shared document:', json.encode(data))
    end
    
    -- Show notification about received document using Dynamic Island
    notifyDI({
        app = 'Documents',
        title = 'Document Received',
        text = 'New document from ' .. data.senderName .. ': ' .. data.title,
        duration = Config.Notifications.duration
    })
    
    -- If this is a temporary document (local share), show it in UI
    if data.temporary then
        SendNUIMessage({
            action = 'showTemporaryDocument',
            data = data
        })
    else
        -- For permanent documents, refresh the documents list
        TriggerServerEvent('okokDocuments:server:getDocuments')
    end
end)

-- Phone App Integration
RegisterNetEvent('okokPhone:documentApp', function()
    if Config.Debug then
        print('^2[okokDocuments]^7 Document app opened')
    end
    
    -- Load documents when app is opened
    TriggerServerEvent('okokDocuments:server:getDocuments')
end)

-- Handle phone app visibility
RegisterNetEvent('okokPhone:setVisibility', function(state, app)
    if app == 'documents' then
        SetNuiFocus(state, state)
        
        if state then
            -- App opened - load documents
            TriggerServerEvent('okokDocuments:server:getDocuments')
        end
        
        if Config.Debug then
            print('^2[okokDocuments]^7 App visibility:', state)
        end
    end
end)

-- Commands for development/testing
if Config.Debug then
    RegisterCommand('testdoc', function(source, args, rawCommand)
        -- Test document creation
        TriggerServerEvent('okokDocuments:server:saveDocument', {
            title = 'Test Document',
            content = 'This is a test document created via command.',
            type = 'other',
            action = 'new'
        })
    end, false)
    
    RegisterCommand('loaddocs', function(source, args, rawCommand)
        -- Refresh documents
        TriggerServerEvent('okokDocuments:server:getDocuments')
    end, false)
end

print('^2[okokDocuments]^7 Client started successfully')
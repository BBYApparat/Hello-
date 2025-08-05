-- Business App Client Side
-- Handles client-side integration with okokPhone systems

-- Initialize ESX
local ESX = exports['es_extended']:getSharedObject()

-- Handle call initiation from NUI
RegisterNUICallback('initiateCall', function(data, cb)
    local targetNumber = data.targetNumber
    local targetName = data.targetName
    
    if not targetNumber then
        cb({success = false, message = "Target number required"})
        return
    end
    
    -- Use okokPhone's call system
    if GetResourceState("okokPhone") == "started" then
        -- Try different possible okokPhone call exports/events
        local success = false
        
        -- Method 1: Try export
        if exports.okokPhone and exports.okokPhone.startCall then
            success = exports.okokPhone:startCall(targetNumber)
        end
        
        -- Method 2: Try client event
        if not success then
            TriggerEvent('okokPhone:client:startCall', targetNumber, targetName)
            success = true
        end
        
        -- Method 3: Try server event
        if not success then
            TriggerServerEvent('okokPhone:server:startCall', targetNumber)
            success = true
        end
        
        cb({success = success, message = success and "Call initiated" or "Failed to start call"})
    else
        cb({success = false, message = "okokPhone not available"})
    end
end)

-- Handle message sending from NUI
RegisterNUICallback('sendMessage', function(data, cb)
    local targetNumber = data.targetNumber
    local message = data.message
    local targetName = data.targetName
    
    if not targetNumber or not message then
        cb({success = false, message = "Target number and message required"})
        return
    end
    
    -- Use okokPhone's messaging system
    if GetResourceState("okokPhone") == "started" then
        local success = false
        
        -- Method 1: Try export
        if exports.okokPhone and exports.okokPhone.sendMessage then
            success = exports.okokPhone:sendMessage(targetNumber, message)
        end
        
        -- Method 2: Try client event
        if not success then
            TriggerEvent('okokPhone:client:sendMessage', {
                number = targetNumber,
                message = message,
                name = targetName
            })
            success = true
        end
        
        -- Method 3: Try server event
        if not success then
            TriggerServerEvent('okokPhone:server:sendMessage', targetNumber, message)
            success = true
        end
        
        cb({success = success, message = success and "Message sent" or "Failed to send message"})
    else
        cb({success = false, message = "okokPhone not available"})
    end
end)

-- Get client player data for phone integration
RegisterNUICallback('getClientData', function(data, cb)
    local playerData = ESX.GetPlayerData()
    
    if playerData then
        cb({
            success = true,
            data = {
                name = playerData.name,
                job = playerData.job,
                identifier = playerData.identifier,
                phoneNumber = playerData.phoneNumber or "Unknown"
            }
        })
    else
        cb({success = false, message = "Failed to get player data"})
    end
end)

-- Handle incoming calls (if needed for business app features)
RegisterNetEvent('okokBusinessApp:client:incomingCall')
AddEventHandler('okokBusinessApp:client:incomingCall', function(callerNumber, callerName, businessName)
    -- Could be used to show special UI for business-related calls
    TriggerEvent('chat:addMessage', {
        color = { 0, 255, 0 },
        multiline = true,
        args = { "Business Directory", ("Incoming call from %s (%s)"):format(callerName, businessName) }
    })
end)

-- Handle message notifications (if needed)
RegisterNetEvent('okokBusinessApp:client:messageReceived')
AddEventHandler('okokBusinessApp:client:messageReceived', function(senderNumber, senderName, message, businessName)
    -- Could be used to show special notifications for business messages
    if GetResourceState("okokNotify") == "started" then
        exports.okokNotify:Alert("Business Message", ("Message from %s: %s"):format(senderName, message), 5000, "info")
    end
end)
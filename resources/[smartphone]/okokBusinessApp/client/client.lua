-- Business App Client Side
-- Handles client-side integration with okokPhone systems

-- Initialize ESX
local ESX = exports['es_extended']:getSharedObject()

-- Get business directory data
RegisterNUICallback('getBusinessData', function(data, cb)
    -- Request data from server
    ESX.TriggerServerCallback('okokBusinessApp:getBusinessData', function(result)
        cb(result)
    end)
end)

-- Get specific business details
RegisterNUICallback('getBusinessDetails', function(data, cb)
    ESX.TriggerServerCallback('okokBusinessApp:getBusinessDetails', function(result)
        cb(result)
    end, data.businessName)
end)

-- Get employee contact details
RegisterNUICallback('getEmployeeContact', function(data, cb)
    ESX.TriggerServerCallback('okokBusinessApp:getEmployeeContact', function(result)
        cb(result)
    end, data.targetId)
end)

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

-- ===== MUGSHOT HANDLING =====

-- Handle mugshot request from server
RegisterNetEvent('okokBusinessApp:requestMugshot')
AddEventHandler('okokBusinessApp:requestMugshot', function(targetServerId)
    -- Check if MugShotBase64 resource is available
    if not GetResourceState('MugShotBase64') or GetResourceState('MugShotBase64') ~= 'started' then
        print('[okokBusinessApp] MugShotBase64 resource not found or not started')
        return
    end
    
    -- Get the target player's ped
    local targetPlayer = GetPlayerFromServerId(targetServerId)
    if targetPlayer == -1 then
        print('[okokBusinessApp] Target player not found for mugshot: ' .. targetServerId)
        return
    end
    
    local targetPed = GetPlayerPed(targetPlayer)
    if not DoesEntityExist(targetPed) then
        print('[okokBusinessApp] Target ped not found for mugshot: ' .. targetServerId)
        return
    end
    
    -- Create a thread to generate the mugshot
    CreateThread(function()
        -- Wait a moment to ensure ped is loaded
        Wait(100)
        
        -- Get mugshot using MugShotBase64 export
        local mugshot = exports["MugShotBase64"]:GetMugShotBase64(targetPed, true)
        
        if mugshot and mugshot ~= "" then
            -- Send mugshot back to server for caching
            TriggerServerEvent('okokBusinessApp:storeMugshot', targetServerId, mugshot)
            print('[okokBusinessApp] Generated mugshot for player: ' .. targetServerId)
        else
            print('[okokBusinessApp] Failed to generate mugshot for player: ' .. targetServerId)
        end
    end)
end)

-- Auto-generate mugshot for self on job change (optimization)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    -- Check if MugShotBase64 resource is available
    if not GetResourceState('MugShotBase64') or GetResourceState('MugShotBase64') ~= 'started' then
        return
    end
    
    -- Only generate for jobs that are in the business directory
    local isBusinessJob = false
    if Config and Config.Jobs then
        for _, configJob in ipairs(Config.Jobs) do
            if configJob.name == job.name then
                isBusinessJob = true
                break
            end
        end
    end
    
    if isBusinessJob then
        CreateThread(function()
            Wait(2000) -- Wait for job change to fully process
            
            local playerPed = PlayerPedId()
            local mugshot = exports["MugShotBase64"]:GetMugShotBase64(playerPed, true)
            
            if mugshot and mugshot ~= "" then
                TriggerServerEvent('okokBusinessApp:storeMugshot', GetPlayerServerId(PlayerId()), mugshot)
                print('[okokBusinessApp] Auto-updated mugshot after job change')
            end
        end)
    end
end)

-- Command to manually refresh your mugshot (for testing/admin purposes)
RegisterCommand('refreshmugshot', function()
    if not GetResourceState('MugShotBase64') or GetResourceState('MugShotBase64') ~= 'started' then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = { "okokBusinessApp", "MugShotBase64 resource not found or not started" }
        })
        return
    end
    
    local playerPed = PlayerPedId()
    local mugshot = exports["MugShotBase64"]:GetMugShotBase64(playerPed, true)
    
    if mugshot and mugshot ~= "" then
        TriggerServerEvent('okokBusinessApp:storeMugshot', GetPlayerServerId(PlayerId()), mugshot)
        TriggerEvent('chat:addMessage', {
            color = { 0, 255, 0 },
            args = { "okokBusinessApp", "Mugshot refreshed successfully" }
        })
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = { "okokBusinessApp", "Failed to generate mugshot" }
        })
    end
end, false)
-- Info App Client Side
-- Enhanced client-side integration for better performance and real-time data

-- Initialize ESX
local ESX = exports['es_extended']:getSharedObject()

-- Get player info for the Info app (server callback)
RegisterNUICallback('getPlayerInfo', function(data, cb)
    -- Request data from server
    ESX.TriggerServerCallback('okok_infoapp:getPlayerInfo', function(result)
        cb(result)
    end)
end)

-- Get current job status (on-demand only)
RegisterNUICallback('getJobStatus', function(data, cb)
    local playerData = ESX.GetPlayerData()
    
    if not playerData then
        cb({success = false, message = "Player data not available"})
        return
    end
    
    -- Check if player is on duty (if using duty system)
    local onDuty = true
    if GetResourceState("okokBossMenu") == "started" then
        onDuty = exports['okokBossMenu']:isJobOnDuty()
    elseif playerData.job and playerData.job.name then
        onDuty = not string.find(playerData.job.name, "off")
    end
    
    cb({
        success = true,
        data = {
            job = playerData.job,
            onDuty = onDuty
        }
    })
end)

-- Optional: Handle NUI focus events for app opening
RegisterNUICallback('onAppOpen', function(data, cb)
    -- App opened - no automatic refresh, data will be fetched on demand
    cb({success = true})
end)


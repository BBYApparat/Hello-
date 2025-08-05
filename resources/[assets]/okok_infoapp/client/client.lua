-- Info App Client Side
-- Enhanced client-side integration for better performance and real-time data

-- Initialize ESX
local ESX = exports['es_extended']:getSharedObject()
local playerData = {}
local lastUpdate = 0
local updateInterval = 5000 -- Update every 5 seconds

-- Cache player data locally for performance
local function updatePlayerData()
    if ESX then
        playerData = ESX.GetPlayerData()
        lastUpdate = GetGameTimer()
    end
end

-- Get cached or fresh player data
local function getPlayerData()
    local currentTime = GetGameTimer()
    if currentTime - lastUpdate > updateInterval then
        updatePlayerData()
    end
    return playerData
end

-- Enhanced player info retrieval with client-side data
RegisterNUICallback('getPlayerInfoClient', function(data, cb)
    local currentPlayerData = getPlayerData()
    
    if not currentPlayerData or not currentPlayerData.identifier then
        cb({success = false, message = "Player data not available"})
        return
    end
    
    -- Get client-side accessible data
    local clientInfo = {
        success = true,
        data = {
            name = currentPlayerData.name or "Unknown",
            identifier = currentPlayerData.identifier,
            job = {
                name = currentPlayerData.job.name,
                label = currentPlayerData.job.label,
                grade = currentPlayerData.job.grade,
                grade_label = currentPlayerData.job.grade_label
            },
            -- Money data needs to come from server for security
            needsServerData = true
        }
    }
    
    cb(clientInfo)
end)

-- Get real-time job status
RegisterNUICallback('getJobStatus', function(data, cb)
    local currentPlayerData = getPlayerData()
    
    if not currentPlayerData then
        cb({success = false, message = "Player data not available"})
        return
    end
    
    -- Check if player is on duty (if using duty system)
    local onDuty = true
    if GetResourceState("okokBossMenu") == "started" then
        onDuty = exports['okokBossMenu']:isJobOnDuty()
    elseif currentPlayerData.job and currentPlayerData.job.name then
        onDuty = not string.find(currentPlayerData.job.name, "off")
    end
    
    cb({
        success = true,
        data = {
            job = currentPlayerData.job,
            onDuty = onDuty,
            lastUpdate = GetGameTimer()
        }
    })
end)

-- Listen for ESX player data updates
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    updatePlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if playerData then
        playerData.job = job
        lastUpdate = GetGameTimer()
        
        -- Notify NUI about job change
        SendNUIMessage({
            type = 'jobUpdated',
            job = job
        })
    end
end)

-- Listen for money updates (if available)
RegisterNetEvent('esx:addedMoney')
AddEventHandler('esx:addedMoney', function(money, newMoney)
    -- Notify NUI that money data should be refreshed
    SendNUIMessage({
        type = 'moneyUpdated',
        account = 'money'
    })
end)

RegisterNetEvent('esx:removedMoney')
AddEventHandler('esx:removedMoney', function(money, newMoney)
    -- Notify NUI that money data should be refreshed
    SendNUIMessage({
        type = 'moneyUpdated',
        account = 'money'
    })
end)

-- Handle bank account updates
RegisterNetEvent('esx:addedAccountMoney')
AddEventHandler('esx:addedAccountMoney', function(account, money, newMoney)
    if account == 'bank' then
        SendNUIMessage({
            type = 'moneyUpdated',
            account = 'bank'
        })
    end
end)

RegisterNetEvent('esx:removedAccountMoney')
AddEventHandler('esx:removedAccountMoney', function(account, money, newMoney)
    if account == 'bank' then
        SendNUIMessage({
            type = 'moneyUpdated',
            account = 'bank'
        })
    end
end)

-- Periodic data sync for active NUI
CreateThread(function()
    while true do
        Wait(updateInterval)
        
        -- Only update if NUI is likely active (basic check)
        if GetGameTimer() - lastUpdate > updateInterval * 2 then
            updatePlayerData()
        end
    end
end)

-- Initialize player data when resource starts
CreateThread(function()
    Wait(1000) -- Wait for ESX to be ready
    updatePlayerData()
end)

-- Handle NUI focus events to refresh data
RegisterNUICallback('onNUIFocus', function(data, cb)
    if data.focused then
        updatePlayerData()
    end
    cb({success = true})
end)


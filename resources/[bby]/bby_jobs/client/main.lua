local activeBlips = {} -- Store active blips
local playerDutyStatus = {} -- Store player's duty status

-- Create blip for a job
function createJobBlip(job, blipData)
    if activeBlips[job] then
        RemoveBlip(activeBlips[job])
    end
    
    local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
    SetBlipSprite(blip, blipData.sprite or Config.DefaultBlip.sprite)
    SetBlipColour(blip, blipData.color or Config.DefaultBlip.color)
    SetBlipScale(blip, blipData.scale or Config.DefaultBlip.scale)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.label or job)
    EndTextCommandSetBlipName(blip)
    
    activeBlips[job] = blip
    
    print(('[BBY Jobs] Created blip for job: %s'):format(job))
end

-- Remove blip for a job
function removeJobBlip(job)
    if activeBlips[job] then
        RemoveBlip(activeBlips[job])
        activeBlips[job] = nil
        print(('[BBY Jobs] Removed blip for job: %s'):format(job))
    end
end

-- Update job blip visibility
function updateJobBlipVisibility(job, shouldShow)
    local blipData = Config.JobBlips[job]
    if not blipData then return end
    
    if shouldShow and not activeBlips[job] then
        createJobBlip(job, blipData)
    elseif not shouldShow and activeBlips[job] then
        removeJobBlip(job)
    end
end

-- Get player's duty status for current job
function isPlayerOnDuty(job)
    return playerDutyStatus[job] or false
end

-- Set player duty status (visual updates)
function setPlayerDutyStatus(job, onDuty)
    playerDutyStatus[job] = onDuty
    
    -- Visual feedback
    if onDuty then
        ESX.ShowNotification(('~g~ON DUTY~w~ - %s'):format(job:upper()), 'success')
        
        -- Add duty indicator to HUD (you can customize this)
        CreateThread(function()
            while playerDutyStatus[job] do
                Wait(0)
                if IsControlJustPressed(0, 344) then -- F11 key (you can change this)
                    ESX.ShowNotification(('Duty Status: ~g~ON DUTY~w~ (%s)'):format(job:upper()))
                end
            end
        end)
    else
        ESX.ShowNotification(('~r~OFF DUTY~w~ - %s'):format(job:upper()), 'error')
    end
end

-- Event handlers
RegisterNetEvent('bby_jobs:updateJobBlip')
AddEventHandler('bby_jobs:updateJobBlip', function(job, shouldShow)
    updateJobBlipVisibility(job, shouldShow)
end)

RegisterNetEvent('bby_jobs:setDutyStatus')
AddEventHandler('bby_jobs:setDutyStatus', function(job, onDuty)
    setPlayerDutyStatus(job, onDuty)
end)

-- Commands for easy duty toggle
RegisterCommand('toggleduty', function()
    local playerData = ESX.GetPlayerData()
    if playerData and playerData.job then
        TriggerServerEvent('bby_jobs:toggleDuty', playerData.job.name)
    else
        ESX.ShowNotification('Unable to get job information', 'error')
    end
end, false)

RegisterCommand('dutycheck', function()
    local playerData = ESX.GetPlayerData()
    if playerData and playerData.job then
        local job = playerData.job.name
        local status = isPlayerOnDuty(job) and '~g~ON DUTY~w~' or '~r~OFF DUTY~w~'
        ESX.ShowNotification(('Job: %s | Status: %s'):format(job:upper(), status))
    end
end, false)

-- Key mappings (you can customize these)
RegisterKeyMapping('toggleduty', 'Toggle Job Duty', 'keyboard', 'F6')
RegisterKeyMapping('dutycheck', 'Check Duty Status', 'keyboard', 'F7')

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Remove all blips
        for job, blip in pairs(activeBlips) do
            RemoveBlip(blip)
        end
        activeBlips = {}
    end
end)

-- Initialize
CreateThread(function()
    -- Wait for ESX to be ready
    while not ESX do
        Wait(100)
    end
    
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    
    -- Add command suggestions
    TriggerEvent('chat:addSuggestion', '/duty', 'Toggle your job duty status')
    TriggerEvent('chat:addSuggestion', '/toggleduty', 'Toggle your job duty status')
    TriggerEvent('chat:addSuggestion', '/dutycheck', 'Check your current duty status')
    
    print('[BBY Jobs] Client initialized')
end)

-- Export functions
exports('isPlayerOnDuty', isPlayerOnDuty)
exports('getPlayerDutyStatus', function(job)
    return playerDutyStatus[job] or false
end)

print('[BBY Jobs] Client loaded successfully')
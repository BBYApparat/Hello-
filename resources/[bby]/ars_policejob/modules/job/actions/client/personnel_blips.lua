-- Optimized Personnel Blips System for Police & Ambulance
local ESX = exports['es_extended']:getSharedObject()
local playerBlips = {}  -- Store all player blips
local lastUpdateTime = 0
local updateInterval = 2000  -- Update every 2 seconds for performance

-- Job configurations
local jobConfig = {
    ['police'] = {
        onFoot = { sprite = 1, color = 3, scale = 0.8 },      -- Blue
        inVehicle = { sprite = 56, color = 3, scale = 0.9 }   -- Blue car
    },
    ['sheriff'] = {
        onFoot = { sprite = 1, color = 5, scale = 0.8 },      -- Yellow  
        inVehicle = { sprite = 56, color = 5, scale = 0.9 }   -- Yellow car
    },
    ['leo'] = {
        onFoot = { sprite = 1, color = 2, scale = 0.8 },      -- Green
        inVehicle = { sprite = 56, color = 2, scale = 0.9 }   -- Green car
    },
    ['ambulance'] = {
        onFoot = { sprite = 1, color = 1, scale = 0.8 },      -- Red
        inVehicle = { sprite = 56, color = 1, scale = 0.9 }   -- Red car  
    },
    ['fire'] = {
        onFoot = { sprite = 1, color = 6, scale = 0.8 },      -- Purple
        inVehicle = { sprite = 56, color = 6, scale = 0.9 }   -- Purple car
    },
    ['ems'] = {
        onFoot = { sprite = 1, color = 1, scale = 0.8 },      -- Red
        inVehicle = { sprite = 56, color = 1, scale = 0.9 }   -- Red car
    }
}

-- Check if player should have blips visible
local function shouldShowBlips()
    if not ESX then return false end
    if not player or not player.inDuty or not player.inDuty() then return false end
    
    local playerData = ESX.GetPlayerData()
    if not playerData or not playerData.job then return false end
    
    return jobConfig[playerData.job.name] ~= nil
end

-- OPTIMIZED: Create or update blip for a player with minimal native calls
local function createOrUpdateBlip(playerId, playerData)
    -- ✅ Cache all native calls at once
    local ped = GetPlayerPed(playerId)
    if not DoesEntityExist(ped) then return end
    
    local coords = GetEntityCoords(ped)
    local inVehicle = IsPedInAnyVehicle(ped, false)
    
    -- ✅ Use cached data instead of calling natives repeatedly
    local jobName = playerData.job
    local playerName = playerData.name
    local callsign = playerData.callsign or "UNASSIGNED"
    
    if not jobConfig[jobName] then return end
    
    -- ✅ Extract last name ONCE and cache it (expensive string operations)
    local lastName = "Unknown"
    local spacePos = string.find(playerName, " [^ ]*$")  -- Find last space
    if spacePos then
        lastName = string.sub(playerName, spacePos + 1)  -- Get everything after last space
    end
    
    -- ✅ Prepare display text before blip operations
    local displayText = string.format("%s %s", callsign, lastName)
    local config = inVehicle and jobConfig[jobName].inVehicle or jobConfig[jobName].onFoot
    
    -- Remove existing blip if it exists (minimize blip operations)
    if playerBlips[playerId] then
        RemoveBlip(playerBlips[playerId])
    end
    
    -- ✅ Batch all blip native calls together
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, config.sprite)
    SetBlipColour(blip, config.color)
    SetBlipScale(blip, config.scale)
    SetBlipAsShortRange(blip, true)
    SetBlipCategory(blip, 7)
    
    -- ✅ Set blip name in one operation
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(displayText)
    EndTextCommandSetBlipName(blip)
    
    playerBlips[playerId] = blip
end

-- Remove blip for a player
local function removeBlip(playerId)
    if playerBlips[playerId] then
        RemoveBlip(playerBlips[playerId])
        playerBlips[playerId] = nil
    end
end

-- OPTIMIZED: Update all personnel blips with cached data
local function updatePersonnelBlips()
    local currentBlips = {}
    local myServerId = GetPlayerServerId(PlayerId())  -- ✅ Cache this native call
    
    -- Update existing and create new blips
    for playerId, data in pairs(personnelData) do
        local playerIdNum = tonumber(playerId)
        
        -- Skip self
        if playerIdNum ~= myServerId then
            createOrUpdateBlip(GetPlayerFromServerId(playerIdNum), data)
            currentBlips[playerIdNum] = true
        end
    end
    
    -- Remove blips for players no longer on duty
    for playerId, blip in pairs(playerBlips) do
        if not currentBlips[playerId] then
            RemoveBlip(blip)
            playerBlips[playerId] = nil
        end
    end
end

-- OPTIMIZED: Separate threads for different update frequencies
local isInRange = false
local personnelData = {}

-- Slow thread: Get personnel data from server (every 3 seconds)
CreateThread(function()
    while true do
        if shouldShowBlips() then
            lib.callback('ars_policejob:getOnDutyPersonnel', false, function(data)
                personnelData = data or {}
            end)
        else
            personnelData = {}
        end
        Wait(3000)  -- Update personnel list every 3 seconds
    end
end)

-- Medium thread: Update blip positions (every 1.5 seconds)
CreateThread(function()
    while true do
        if shouldShowBlips() and next(personnelData) then
            updatePersonnelBlips()
        end
        Wait(1500)  -- Update blip positions every 1.5 seconds
    end
end)

-- Fast thread: Only for cleanup checks (every 5 seconds)
CreateThread(function()
    while true do
        if not shouldShowBlips() then
            -- Clear all blips if player shouldn't see them
            for playerId, blip in pairs(playerBlips) do
                RemoveBlip(blip)
            end
            playerBlips = {}
        end
        Wait(5000)  -- Cleanup check every 5 seconds
    end
end)

-- Clean up blips when player goes off duty
RegisterNetEvent('esx:setJob', function(job)
    if not jobConfig[job.name] then
        -- Player switched to non-emergency job, clear all blips
        for playerId, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)

-- Clean up on duty status change
RegisterNetEvent('ars_policejob:dutyStatusUpdated', function(status)
    if not status then
        -- Player went off duty, clear all blips
        for playerId, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)

-- Clean up blips when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for playerId, blip in pairs(playerBlips) do
            RemoveBlip(blip)
        end
        playerBlips = {}
    end
end)

-- Callsign command
RegisterCommand('callsign', function(source, args)
    if not args[1] then
        lib.notify({
            title = 'Callsign',
            description = 'Usage: /callsign [callsign]\n\nFormats:\nPolice/Sheriff/LEO: 4-Adam-29\nAmbulance/EMS/Fire: C-01 or Chief-01',
            type = 'info',
            duration = 8000
        })
        return
    end
    
    local callsign = table.concat(args, " ")  -- Join all args in case of spaces
    TriggerServerEvent('ars_policejob:setCallsign', callsign)
end, false)

-- Add command suggestion
TriggerEvent('chat:addSuggestion', '/callsign', 'Set your emergency services callsign', {
    { name = 'callsign', help = 'Your callsign (Police: 4-Adam-29, EMS: C-01)' }
})
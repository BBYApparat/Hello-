local ESX = nil
local playerData = {}
local mdtOpen = false

CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    
    playerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    playerData.job = job
end)

-- Check if player is police and in emergency vehicle while stationary
local function canOpenMDT()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if not vehicle or vehicle == 0 then
        return false, Config.PoliceMDT.Messages.NotInVehicle
    end
    
    -- Check if player is police
    local hasPermission = false
    if playerData.job then
        for i = 1, #Config.PoliceMDT.PoliceJobs do
            if playerData.job.name == Config.PoliceMDT.PoliceJobs[i] then
                hasPermission = true
                break
            end
        end
    end
    
    if not hasPermission then
        return false, Config.PoliceMDT.Messages.NoPermission
    end
    
    -- Check if vehicle is emergency vehicle
    if Config.PoliceMDT.EmergencyVehiclesOnly then
        local vehicleClass = GetVehicleClass(vehicle)
        if vehicleClass ~= 18 then -- 18 = Emergency vehicle class
            return false, Config.PoliceMDT.Messages.NotEmergencyVehicle
        end
    end
    
    -- Check if vehicle is stationary
    local speed = GetEntitySpeed(vehicle) * 2.237 -- Convert to MPH
    if speed > Config.PoliceMDT.MaxSpeed then
        return false, Config.PoliceMDT.Messages.VehicleMoving
    end
    
    -- Check if player is driver
    if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        return false, Config.PoliceMDT.Messages.NotDriver
    end
    
    return true, nil
end

-- Main MDT menu
local function openMDTMenu()
    local canOpen, errorMsg = canOpenMDT()
    
    if not canOpen then
        ESX.ShowNotification(errorMsg, 'error')
        return
    end
    
    mdtOpen = true
    
    local elements = {
        {label = '🔍 Search Citizen', value = 'search_citizen'},
        {label = '⚠️ View Current Crimes', value = 'view_crimes'},
        {label = '📋 Search Police Records', value = 'search_records'},
        {label = '🚨 Call Backup', value = 'call_backup'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_mdt', {
        title = 'Police MDT - GTA IV Style',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'search_citizen' then
            searchCitizen()
        elseif data.current.value == 'view_crimes' then
            viewCurrentCrimes()
        elseif data.current.value == 'search_records' then
            searchPoliceRecords()
        elseif data.current.value == 'call_backup' then
            callBackup()
        end
    end, function(data, menu)
        menu.close()
        mdtOpen = false
    end)
end

-- Search citizen function
function searchCitizen()
    local elements = {
        {label = '👤 Search by Name', value = 'search_name'},
        {label = '🆔 Search by State ID', value = 'search_stateid'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search_citizen_type', {
        title = 'Search Citizen',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        
        if data.current.value == 'search_name' then
            searchCitizenByName()
        elseif data.current.value == 'search_stateid' then
            searchCitizenByStateId()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Search citizen by name
function searchCitizenByName()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'search_citizen_name', {
        title = 'Enter Citizen Name'
    }, function(data, menu)
        local name = data.value
        if name == nil or name == '' then
            ESX.ShowNotification(Config.PoliceMDT.Messages.InvalidName, 'error')
            return
        end
        
        menu.close()
        
        -- Search for citizen in database by name
        ESX.TriggerServerCallback('police_mdt:searchCitizenByName', function(citizenData)
            if citizenData then
                showCitizenProfile(citizenData)
            else
                ESX.ShowNotification(Config.PoliceMDT.Messages.CitizenNotFound, 'error')
            end
        end, name)
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Search citizen by State ID
function searchCitizenByStateId()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'search_citizen_stateid', {
        title = 'Enter State ID Number'
    }, function(data, menu)
        local stateId = tonumber(data.value)
        if stateId == nil or stateId <= 0 then
            ESX.ShowNotification('Please enter a valid State ID number', 'error')
            return
        end
        
        menu.close()
        
        -- Search for citizen in database by state ID
        ESX.TriggerServerCallback('police_mdt:searchCitizenByStateId', function(citizenData)
            if citizenData then
                showCitizenProfile(citizenData)
            else
                ESX.ShowNotification('No citizen found with State ID: ' .. stateId, 'error')
            end
        end, stateId)
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Show citizen profile
function showCitizenProfile(citizenData)
    local elements = {
        {label = 'Name: ' .. citizenData.firstname .. ' ' .. citizenData.lastname, value = 'info'},
        {label = '🆔 State ID: ' .. (citizenData.state_id or 'Not Assigned'), value = 'info'},
        {label = 'DOB: ' .. (citizenData.dateofbirth or 'Unknown'), value = 'info'},
        {label = 'Sex: ' .. (citizenData.sex or 'Unknown'), value = 'info'},
        {label = 'Height: ' .. (citizenData.height or 'Unknown'), value = 'info'},
        {label = '────────────────────', value = 'separator'},
        {label = '📝 Add Note', value = 'add_note'},
        {label = '⚖️ Add Violation', value = 'add_violation'},
        {label = '────────────────────', value = 'separator'},
        {label = '📋 View Notes', value = 'view_notes'},
        {label = '⚖️ View Violations', value = 'view_violations'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_profile', {
        title = 'Citizen Profile - ' .. citizenData.firstname .. ' ' .. citizenData.lastname,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'add_note' then
            addNote(citizenData.identifier)
        elseif data.current.value == 'add_violation' then
            addViolation(citizenData.identifier)
        elseif data.current.value == 'view_notes' then
            viewNotes(citizenData.identifier)
        elseif data.current.value == 'view_violations' then
            viewViolations(citizenData.identifier)
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Add note to citizen
function addNote(citizenId)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'add_note', {
        title = 'Enter Note'
    }, function(data, menu)
        local note = data.value
        if note == nil or note == '' then
            ESX.ShowNotification(Config.PoliceMDT.Messages.InvalidNote, 'error')
            return
        end
        
        menu.close()
        
        TriggerServerEvent('police_mdt:addNote', citizenId, note)
        ESX.ShowNotification(Config.PoliceMDT.Messages.NoteAdded, 'success')
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Add violation to citizen
function addViolation(citizenId)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'add_violation', {
        title = 'Enter Violation'
    }, function(data, menu)
        local violation = data.value
        if violation == nil or violation == '' then
            ESX.ShowNotification(Config.PoliceMDT.Messages.InvalidViolation, 'error')
            return
        end
        
        menu.close()
        
        TriggerServerEvent('police_mdt:addViolation', citizenId, violation)
        ESX.ShowNotification(Config.PoliceMDT.Messages.ViolationAdded, 'success')
        
    end, function(data, menu)
        menu.close()
    end)
end

-- View notes for citizen
function viewNotes(citizenId)
    ESX.TriggerServerCallback('police_mdt:getNotes', function(notes)
        local elements = {}
        
        if #notes == 0 then
            table.insert(elements, {label = 'No notes found', value = 'none'})
        else
            for i = 1, #notes do
                table.insert(elements, {
                    label = notes[i].date .. ' - ' .. notes[i].note,
                    value = 'note_' .. i
                })
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'view_notes', {
            title = 'Citizen Notes',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            -- Notes are read-only for now
        end, function(data, menu)
            menu.close()
        end)
    end, citizenId)
end

-- View violations for citizen
function viewViolations(citizenId)
    ESX.TriggerServerCallback('police_mdt:getViolations', function(violations)
        local elements = {}
        
        if #violations == 0 then
            table.insert(elements, {label = 'No violations found', value = 'none'})
        else
            for i = 1, #violations do
                table.insert(elements, {
                    label = violations[i].date .. ' - ' .. violations[i].violation,
                    value = 'violation_' .. i
                })
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'view_violations', {
            title = 'Citizen Violations',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            -- Violations are read-only for now
        end, function(data, menu)
            menu.close()
        end)
    end, citizenId)
end

-- View current crimes (placeholder)
function viewCurrentCrimes()
    ESX.TriggerServerCallback('police_mdt:getCurrentCrimes', function(crimes)
        local elements = {}
        
        if #crimes == 0 then
            table.insert(elements, {label = 'No active crimes reported', value = 'none'})
        else
            for i = 1, #crimes do
                table.insert(elements, {
                    label = crimes[i].type .. ' - ' .. crimes[i].location,
                    value = 'crime_' .. i
                })
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'current_crimes', {
            title = 'Current Crimes',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            -- Crime details can be expanded here
        end, function(data, menu)
            menu.close()
        end)
    end)
end

-- Search police records
function searchPoliceRecords()
    local elements = {
        {label = '👤 Search by Name', value = 'search_name'},
        {label = '🆔 Search by State ID', value = 'search_stateid'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search_records_type', {
        title = 'Search Police Records',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        
        if data.current.value == 'search_name' then
            searchRecordsByName()
        elseif data.current.value == 'search_stateid' then
            searchRecordsByStateId()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Search records by name
function searchRecordsByName()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'search_records_name', {
        title = 'Enter Name to Search Records'
    }, function(data, menu)
        local name = data.value
        if name == nil or name == '' then
            ESX.ShowNotification(Config.PoliceMDT.Messages.InvalidName, 'error')
            return
        end
        
        menu.close()
        
        ESX.TriggerServerCallback('police_mdt:searchRecordsByName', function(records)
            showPoliceRecords(records, 'Name: ' .. name)
        end, name)
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Search records by State ID
function searchRecordsByStateId()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'search_records_stateid', {
        title = 'Enter State ID to Search Records'
    }, function(data, menu)
        local stateId = tonumber(data.value)
        if stateId == nil or stateId <= 0 then
            ESX.ShowNotification('Please enter a valid State ID number', 'error')
            return
        end
        
        menu.close()
        
        ESX.TriggerServerCallback('police_mdt:searchRecordsByStateId', function(records)
            showPoliceRecords(records, 'State ID: ' .. stateId)
        end, stateId)
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Show police records
function showPoliceRecords(records, searchInfo)
    local elements = {}
    
    if #records == 0 then
        table.insert(elements, {label = 'No records found', value = 'none'})
    else
        for i = 1, #records do
            table.insert(elements, {
                label = records[i].date .. ' - ' .. records[i].type .. ': ' .. records[i].description,
                value = 'record_' .. i
            })
        end
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search_records', {
        title = 'Police Records - ' .. searchInfo,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        -- Record details can be expanded here
    end, function(data, menu)
        menu.close()
    end)
end

-- Call backup
function callBackup()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local street1, street2 = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local streetName = GetStreetNameFromHashKey(street1)
    local area = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z))
    
    local location = streetName .. ", " .. area
    
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'backup_reason', {
        title = 'Enter Backup Reason'
    }, function(data, menu)
        local reason = data.value or 'Assistance requested'
        menu.close()
        
        TriggerServerEvent('police_mdt:callBackup', location, reason)
        ESX.ShowNotification(Config.PoliceMDT.Messages.BackupCalled, 'success')
        
    end, function(data, menu)
        menu.close()
    end)
end

-- Key mapping to open MDT
RegisterCommand('mdt', function()
    openMDTMenu()
end, false)

-- Register key mapping
RegisterKeyMapping('mdt', 'Open Police MDT', 'keyboard', 'F5')

-- Disable MDT when player exits vehicle or moves
CreateThread(function()
    while true do
        Wait(1000)
        
        if mdtOpen then
            local canStillOpen, _ = canOpenMDT()
            if not canStillOpen then
                ESX.UI.Menu.CloseAll()
                mdtOpen = false
                ESX.ShowNotification(Config.PoliceMDT.Messages.MDTClosed, 'info')
            end
        end
    end
end)
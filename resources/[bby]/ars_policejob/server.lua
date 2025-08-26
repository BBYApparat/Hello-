-- Initialize ESX
local ESX = exports['es_extended']:getSharedObject()

-- temp fix
local function convertGroupsToStashFormat(groupsArray, minGrade)
    local stashGroups = {}
    for _, groupName in ipairs(groupsArray) do
        stashGroups[groupName] = minGrade or 0
    end
    return stashGroups
end


CreateThread(function()
    for index, station in pairs(Config.PoliceStations) do
        local cfg = station

        if cfg.armory.require_storage then
            local armory = cfg.armory.storage
            exports.ox_inventory:RegisterStash(armory.stashId, armory.stashLabel, 500, 1000 * 1000, nil, convertGroupsToStashFormat(station.jobs, armory.minGradeAccess), nil)
            -- print(("^3DEBUG: %s ^7"):format("Armory stash registered " .. armory.stashId))
        end

        for id, stash in pairs(cfg.stash) do
            exports.ox_inventory:RegisterStash(id, stash.label, stash.slots, stash.weight * 1000, cfg.stash.shared and true or nil, convertGroupsToStashFormat(station.jobs), stash.pos)
            -- print(("^3DEBUG: %s ^7"):format("Stash registered " .. id))
        end
    end
end)

lib.callback.register('ars_policejob:getItemCount', function(source, stash, item)
    local inventory = stash

    local items = exports.ox_inventory:Search(inventory, 'count', item)

    return items
end)

RegisterNetEvent('ars_policejob:giveItemToPlayer', function(stash, item, quantity, storage, jobs)
    if not hasJob(source, jobs) or not source or source < 1 then return end

    exports.ox_inventory:AddItem(source, item, quantity)

    if storage then
        exports.ox_inventory:RemoveItem(stash, item, quantity)
    end
end)

RegisterNetEvent('ars_policejob:activateBlip', function(data)
    if not hasJob(source, Config.Interactions.jobs) or not source or source < 1 then return end

    TriggerClientEvent('ars_policejob:activateBlip', -1, data)
end)

RegisterNetEvent('ars_policejob:createEmergencyBlip', function(data)
    if not hasJob(source, Config.Interactions.jobs) or not source or source < 1 then return end

    TriggerClientEvent('ars_policejob:createEmergencyBlip', -1, data)
end)


RegisterNetEvent("ars_policejob:updateDuty", function(value)
    local source = source
    local playerIdentifier = GetPlayerIdentifierByType(source, "license")
    SetResourceKvpInt("policejob_duty:" .. playerIdentifier, value == true and 1 or 0)
    TriggerClientEvent("ars_policejob:dutyStatusUpdated", source, value)
end)

lib.callback.register('ars_policejob:getDutyStatus', function(source)
    local playerIdentifier = GetPlayerIdentifierByType(source, "license")
    local value = GetResourceKvpInt("policejob_duty:" .. playerIdentifier)

    return value == 1 and true or false
end)

-- lib.versionCheck('Arius-Development/ars_policejob')

-- LSPD Vehicle Plate Tracking System
local vehiclePlates = {} -- Store plate -> officer info
local plateCounter = 0   -- Sequential plate counter

-- Load plate counter from KVP storage
CreateThread(function()
    local storedCounter = GetResourceKvpInt("lspd_plate_counter")
    if storedCounter > 0 then
        plateCounter = storedCounter
    end
end)

-- Generate next LSPD plate number
local function getNextPlateNumber()
    plateCounter = plateCounter + 1
    SetResourceKvpInt("lspd_plate_counter", plateCounter)
    return string.format("LSPD%04d", plateCounter)
end

-- Register vehicle with officer
RegisterNetEvent('ars_policejob:registerVehicle', function(vehicle, plate, vehicleLabel)
    local source = source
    local playerData = ESX.GetPlayerFromId(source)
    
    if not playerData then return end
    
    local officerInfo = {
        name = playerData.getName(),
        identifier = playerData.identifier,
        job = playerData.job.name,
        grade = playerData.job.grade,
        vehicle = vehicleLabel,
        timestamp = os.time()
    }
    
    vehiclePlates[plate] = officerInfo
    
    -- Store in KVP for persistence
    SetResourceKvp("lspd_plate_" .. plate, json.encode(officerInfo))
end)

-- Enhanced plate lookup callback for both LSPD and civilian vehicles
lib.callback.register('ars_policejob:getVehicleOwner', function(source, plate)
    -- First check LSPD vehicles in memory
    if vehiclePlates[plate] then
        vehiclePlates[plate].vehicleType = 'LSPD'
        return vehiclePlates[plate]
    end
    
    -- Check LSPD vehicles in KVP storage
    local storedData = GetResourceKvp("lspd_plate_" .. plate)
    if storedData then
        local officerInfo = json.decode(storedData)
        officerInfo.vehicleType = 'LSPD'
        vehiclePlates[plate] = officerInfo -- Cache it
        return officerInfo
    end
    
    -- Check civilian vehicles in database
    local result = MySQL.query.await('SELECT ov.owner, ov.plate, ov.vehicle, ov.model, ov.garage, u.firstname, u.lastname FROM owned_vehicles ov LEFT JOIN users u ON ov.owner = u.identifier WHERE ov.plate = ?', {
        plate
    })
    
    if result and result[1] then
        local vehicleData = result[1]
        local vehicleInfo = json.decode(vehicleData.vehicle or '{}')
        
        local civilianInfo = {
            name = (vehicleData.firstname and vehicleData.lastname) and 
                   (vehicleData.firstname .. ' ' .. vehicleData.lastname) or 
                   'Unknown Owner',
            identifier = vehicleData.owner,
            vehicleType = 'Civilian',
            vehicle = vehicleData.model and json.decode(vehicleData.model).name or 'Unknown Vehicle',
            plate = vehicleData.plate,
            garage = vehicleData.garage,
            timestamp = os.time() - 86400 -- Default to 1 day ago
        }
        
        return civilianInfo
    end
    
    return nil
end)

-- Generate plate callback
lib.callback.register('ars_policejob:generatePlate', function(source)
    return getNextPlateNumber()
end)

-- Personnel blips system - get all on duty emergency personnel
lib.callback.register('ars_policejob:getOnDutyPersonnel', function(source)
    local emergencyJobs = {'police', 'sheriff', 'leo', 'ambulance', 'fire', 'ems'}
    local personnel = {}
    
    local xPlayers = ESX.GetExtendedPlayers()
    
    for _, xPlayer in pairs(xPlayers) do
        if xPlayer and xPlayer.job and table.contains(emergencyJobs, xPlayer.job.name) then
            -- Check if player is on duty
            local playerIdentifier = GetPlayerIdentifierByType(xPlayer.source, "license")
            local dutyStatus = GetResourceKvpInt("policejob_duty:" .. playerIdentifier)
            
            if dutyStatus == 1 then  -- On duty
                -- Get callsign
                local callsign = GetResourceKvp("callsign_" .. playerIdentifier) or "UNASSIGNED"
                
                personnel[tostring(xPlayer.source)] = {
                    name = xPlayer.getName(),
                    job = xPlayer.job.name,
                    grade = xPlayer.job.grade,
                    source = xPlayer.source,
                    callsign = callsign
                }
            end
        end
    end
    
    return personnel
end)

-- Callsign management system
RegisterNetEvent('ars_policejob:setCallsign', function(callsign)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- Check if player is emergency personnel
    local emergencyJobs = {'police', 'sheriff', 'leo', 'ambulance', 'fire', 'ems'}
    if not table.contains(emergencyJobs, xPlayer.job.name) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Callsign',
            description = 'Only emergency personnel can set callsigns.',
            type = 'error'
        })
        return
    end
    
    -- Check if on duty
    local playerIdentifier = GetPlayerIdentifierByType(source, "license")
    local dutyStatus = GetResourceKvpInt("policejob_duty:" .. playerIdentifier)
    
    if dutyStatus ~= 1 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Callsign',
            description = 'You must be on duty to set a callsign.',
            type = 'error'
        })
        return
    end
    
    -- Validate callsign format based on job
    local validFormat = false
    local jobType = xPlayer.job.name
    
    if jobType == 'ambulance' or jobType == 'ems' or jobType == 'fire' then
        -- Format: C-01, Chief-01, M-01, etc.
        validFormat = string.match(callsign, "^[A-Za-z]+-[0-9][0-9]$") or string.match(callsign, "^[A-Za-z][A-Za-z][A-Za-z][A-Za-z]+-[0-9][0-9]$")
    elseif jobType == 'police' or jobType == 'sheriff' or jobType == 'leo' then
        -- Format: 4-Adam-29, 1-Boy-12, etc.
        validFormat = string.match(callsign, "^[0-9]-[A-Za-z]+-[0-9][0-9]$")
    end
    
    if not validFormat then
        local formatExample = ""
        if jobType == 'ambulance' or jobType == 'ems' or jobType == 'fire' then
            formatExample = "Examples: C-01, Chief-01, M-12"
        else
            formatExample = "Examples: 4-Adam-29, 1-Boy-12"
        end
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Callsign',
            description = 'Invalid callsign format. ' .. formatExample,
            type = 'error'
        })
        return
    end
    
    -- Check if callsign is already taken
    local allPlayers = ESX.GetExtendedPlayers()
    for _, otherPlayer in pairs(allPlayers) do
        if otherPlayer.source ~= source then
            local otherIdentifier = GetPlayerIdentifierByType(otherPlayer.source, "license")
            local otherCallsign = GetResourceKvp("callsign_" .. otherIdentifier)
            if otherCallsign == callsign then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Callsign',
                    description = 'This callsign is already in use.',
                    type = 'error'
                })
                return
            end
        end
    end
    
    -- Save callsign
    SetResourceKvp("callsign_" .. playerIdentifier, callsign)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Callsign',
        description = 'Callsign set to: ' .. callsign,
        type = 'success'
    })
end)

-- Utility function to check if value exists in table
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Vehicle fine system
lib.callback.register('ars_policejob:fineVehicle', function(source, plate, reason, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not hasJob(source, Config.Interactions.jobs) then
        return { success = false, message = "Not authorized" }
    end
    
    -- First check LSPD vehicles
    if vehiclePlates[plate] then
        local officerInfo = vehiclePlates[plate]
        return { 
            success = false, 
            message = "Cannot fine LSPD vehicle assigned to Officer " .. officerInfo.name 
        }
    end
    
    -- Check KVP storage for LSPD vehicles
    local storedData = GetResourceKvp("lspd_plate_" .. plate)
    if storedData then
        local officerInfo = json.decode(storedData)
        return { 
            success = false, 
            message = "Cannot fine LSPD vehicle assigned to Officer " .. officerInfo.name 
        }
    end
    
    -- Check civilian vehicles in database
    local result = MySQL.query.await('SELECT ov.owner, ov.plate, u.firstname, u.lastname FROM owned_vehicles ov LEFT JOIN users u ON ov.owner = u.identifier WHERE ov.plate = ?', {
        plate
    })
    
    if result and result[1] then
        local vehicleData = result[1]
        local ownerName = (vehicleData.firstname and vehicleData.lastname) and 
                         (vehicleData.firstname .. ' ' .. vehicleData.lastname) or 
                         'Unknown Owner'
        
        -- Check if owner is online
        local targetPlayer = ESX.GetPlayerFromIdentifier(vehicleData.owner)
        
        if targetPlayer then
            -- Player is online, send mail notification via okokPhone
            local email = {
                sender = "LSPD",
                recipients = {vehicleData.owner},
                subject = "Traffic Citation",
                body = string.format(
                    "Dear %s,\n\nYou have received a traffic citation for your vehicle (Plate: %s).\n\nReason: %s\nFine Amount: $%s\n\nThis fine has been automatically processed.\n\nRegards,\nLos Santos Police Department",
                    ownerName,
                    plate,
                    reason,
                    amount
                )
            }
            
            -- Send via okokPhone export
            if exports.okokPhone then
                exports.okokPhone:sendNewEmail(email)
            end
            
            -- Remove money from player
            targetPlayer.removeBank(tonumber(amount))
            
            return { 
                success = true, 
                message = string.format("Fine sent to %s ($%s). Owner has been notified via mail.", ownerName, amount)
            }
        else
            -- Player is offline
            return { 
                success = false, 
                message = string.format("Vehicle owner (%s) is currently unavailable.", ownerName)
            }
        end
    else
        -- No owner found
        return { 
            success = false, 
            message = "This vehicle does not belong to anyone." 
        }
    end
end)

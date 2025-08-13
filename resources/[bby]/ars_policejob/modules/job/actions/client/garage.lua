local IsPositionOccupied       = IsPositionOccupied
local CreateVehicle            = CreateVehicle
local SetModelAsNoLongerNeeded = SetModelAsNoLongerNeeded
local NetworkFadeInEntity      = NetworkFadeInEntity
local TaskEnterVehicle         = TaskEnterVehicle
local GetPedInVehicleSeat      = GetPedInVehicleSeat
local IsControlJustReleased    = IsControlJustReleased
local TaskLeaveVehicle         = TaskLeaveVehicle
local FreezeEntityPosition     = FreezeEntityPosition
local NetworkFadeOutEntity     = NetworkFadeOutEntity
local DeleteVehicle            = DeleteVehicle
local DrawMarker               = DrawMarker
local Wait                     = Wait
local IsEntityDead             = IsEntityDead
local vector3                  = vector3
local TaskVehicleDriveWander   = TaskVehicleDriveWander
local DeletePed                = DeletePed

local depositPositions         = {}

local function openCarList(garage)
    local vehicles = {}
    local playerPed = cache.ped
    local jobGrade = getPlayerJobGrade()

    for k, v in pairs(garage.vehicles) do
        -- Show all vehicles but indicate if they're locked
        local canSpawn = jobGrade >= v.min_grade
        local title = v.label
        if not canSpawn then
            title = title .. " (Rank " .. v.min_grade .. " required)"
        end

        table.insert(vehicles, {
            title = title,
            disabled = not canSpawn,
            onSelect = function(data)
                if not canSpawn then
                    lib.notify({
                        title = 'Garage',
                        description = 'You need rank ' .. v.min_grade .. ' or higher to access this vehicle.',
                        type = 'error'
                    })
                    return
                end

                local isPosOccupied = IsPositionOccupied(garage.spawn.x, garage.spawn.y, garage.spawn.z, 10, false, true, true, false, false, 0, false)

                if isPosOccupied then 
                    lib.notify({
                        title = 'Garage',
                        description = 'Spawn point is blocked.',
                        type = 'error'
                    })
                    return 
                end

                local model = lib.requestModel(v.spawn_code)

                if not model then return end

                local vehicle = CreateVehicle(model, garage.spawn.x, garage.spawn.y, garage.spawn.z, garage.spawn.w, true, false)
                SetModelAsNoLongerNeeded(model)
                NetworkFadeInEntity(vehicle, 1)
                
                -- Generate custom LSPD plate
                lib.callback('ars_policejob:generatePlate', false, function(customPlate)
                    if customPlate then
                        -- Set the custom plate
                        SetVehicleNumberPlateText(vehicle, customPlate)
                        
                        -- Apply vehicle modifications
                        lib.setVehicleProperties(vehicle, v.modifications)
                        
                        -- Register vehicle with server
                        TriggerServerEvent('ars_policejob:registerVehicle', vehicle, customPlate, v.label)
                        
                        -- Player enters vehicle
                        TaskEnterVehicle(playerPed, vehicle, -1, -1, 1.0, 1, 0)
                        
                        lib.notify({
                            title = 'Garage',
                            description = 'Vehicle spawned: ' .. v.label .. ' (Plate: ' .. customPlate .. ')',
                            type = 'success'
                        })
                    end
                end)
            end
        })
    end

    lib.registerContext({
        id = 'vehicleList',
        title = 'Police Garage',
        options = vehicles
    })
    lib.showContext('vehicleList')
end


local function depositVehicle(data)
    if hasJob(data.jobs) then
        local playerPed = cache.ped
        local playerVehicle = cache.vehicle
        if playerVehicle and GetPedInVehicleSeat(playerVehicle, -1) ~= 0 then
            DrawMarker(0, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8,
                0.8, 0.8, 199, 208, 209, 100, false, true, 2, nil, nil, false)

            if data.currentDistance < 2 and IsControlJustReleased(0, 38) then
                TaskLeaveVehicle(playerPed, playerVehicle, 64)

                while cache.vehicle do Wait(100) end

                local vehicleToDelete = playerVehicle

                lib.hideTextUI()

                local policeDriver = utils.createPed(data.model, data.driverSpawnCoords)
                FreezeEntityPosition(policeDriver, false)

                TaskEnterVehicle(policeDriver, vehicleToDelete, -1, -1, 1.0, 1, 0)

                Wait(1000)

                while GetPedInVehicleSeat(vehicleToDelete, 0) ~= 0 do Wait(1) end
                while GetPedInVehicleSeat(vehicleToDelete, 1) ~= 0 do Wait(1) end
                while GetPedInVehicleSeat(vehicleToDelete, 2) ~= 0 do Wait(1) end

                TaskVehicleDriveWander(policeDriver, vehicleToDelete, 60.0, 8)

                Wait(20 * 1000) -- 20 seconds

                NetworkFadeOutEntity(vehicleToDelete, false, true)
                NetworkFadeOutEntity(policeDriver, false, true)

                Wait(1 * 1000)

                DeleteVehicle(vehicleToDelete)
                DeletePed(policeDriver)

                vehicleToDelete = nil
                policeDriver = nil
            end
        end
    end
end

function initGarage(data, jobs)
    for index, garage in pairs(data) do
        -- Create NPC for garage interaction
        local ped = utils.createPed(garage.model, garage.pedPos)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'garageGuy' .. ped,
                label = locale('garage_interact_label'),
                icon = 'fa-solid fa-car',
                distance = 3,
                groups = jobs,
                canInteract = function(entity, distance, coords, name, bone)
                    return not IsEntityDead(entity) and player.inDuty()
                end,
                onSelect = function(data)
                    openCarList(garage)
                end,
            }
        })

        depositPositions[index] = lib.points.new({
            coords = garage.deposit,
            distance = 5,
            onEnter = function(self)
                if cache.vehicle and hasJob(jobs) then
                    lib.showTextUI(locale('deposit_vehicle'))
                end
            end,
            onExit = function(self)
                lib.hideTextUI()
            end,
            nearby = function(self)
                self.model = garage.model
                self.driverSpawnCoords = garage.driverSpawnCoords
                self.jobs = jobs
                depositVehicle(self)
            end

        })
    end
end

-- Plate lookup command for officers with ps-dispatch integration
RegisterCommand('platecheck', function(source, args)
    if not args[1] then
        lib.notify({
            title = 'Plate Check',
            description = 'Usage: /platecheck [plate]',
            type = 'error'
        })
        return
    end
    
    if not player.inDuty() then
        lib.notify({
            title = 'Plate Check',
            description = 'You must be on duty to use this command.',
            type = 'error'
        })
        return
    end
    
    local plate = string.upper(args[1])
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    lib.callback('ars_policejob:getVehicleOwner', false, function(ownerInfo)
        if ownerInfo then
            local timeAgo = os.time() - ownerInfo.timestamp
            local timeStr = timeAgo > 3600 and math.floor(timeAgo / 3600) .. " hours ago" or math.floor(timeAgo / 60) .. " minutes ago"
            
            -- Send to ps-dispatch with different messages for LSPD vs Civilian
            if exports['ps-dispatch'] then
                if ownerInfo.vehicleType == 'LSPD' then
                    exports['ps-dispatch']:CustomAlert({
                        coords = playerCoords,
                        message = "Plate Check - LSPD Vehicle",
                        dispatchCode = "plate_check_lspd",
                        code = "10-28",
                        icon = "fas fa-shield-alt",
                        priority = 2,
                        plate = plate,
                        vehicle = ownerInfo.vehicle,
                        name = ownerInfo.name,
                        alertTime = 15,
                        jobs = { 'police', 'sheriff', 'leo' },
                        alert = {
                            radius = 0,
                            sprite = 56,
                            color = 3,
                            scale = 0.8,
                            length = 3,
                            sound = "Lose_1st",
                            sound2 = "GTAO_FM_Events_Soundset"
                        }
                    })
                else
                    exports['ps-dispatch']:CustomAlert({
                        coords = playerCoords,
                        message = "Plate Check - Civilian Vehicle",
                        dispatchCode = "plate_check_civilian",
                        code = "10-28",
                        icon = "fas fa-user",
                        priority = 2,
                        plate = plate,
                        vehicle = ownerInfo.vehicle,
                        name = ownerInfo.name,
                        alertTime = 15,
                        jobs = { 'police', 'sheriff', 'leo' },
                        alert = {
                            radius = 0,
                            sprite = 1,
                            color = 5,
                            scale = 0.8,
                            length = 3,
                            sound = "Lose_1st",
                            sound2 = "GTAO_FM_Events_Soundset"
                        }
                    })
                end
            end
            
            local notificationDesc = ""
            if ownerInfo.vehicleType == 'LSPD' then
                notificationDesc = string.format(
                    'Plate: %s\nType: LSPD Vehicle\nOfficer: %s\nRank: %d\nVehicle: %s\nIssued: %s',
                    plate,
                    ownerInfo.name,
                    ownerInfo.grade or 0,
                    ownerInfo.vehicle,
                    timeStr
                )
            else
                notificationDesc = string.format(
                    'Plate: %s\nType: Civilian Vehicle\nOwner: %s\nVehicle: %s\nGarage: %s',
                    plate,
                    ownerInfo.name,
                    ownerInfo.vehicle,
                    ownerInfo.garage or "Unknown"
                )
            end
            
            lib.notify({
                title = 'Plate Check Results',
                description = notificationDesc,
                type = 'success',
                duration = 8000
            })
        else
            -- Send failed plate check to dispatch
            if exports['ps-dispatch'] then
                exports['ps-dispatch']:CustomAlert({
                    coords = playerCoords,
                    message = "Plate Check - No Records Found",
                    dispatchCode = "plate_check_fail",
                    code = "10-28",
                    icon = "fas fa-exclamation-triangle",
                    priority = 2,
                    plate = plate,
                    alertTime = 10,
                    jobs = { 'police', 'sheriff', 'leo' },
                    alert = {
                        radius = 0,
                        sprite = 1,
                        color = 1,
                        scale = 0.8,
                        length = 2,
                        sound = "Lose_1st",
                        sound2 = "GTAO_FM_Events_Soundset"
                    }
                })
            end
            
            lib.notify({
                title = 'Plate Check',
                description = 'No records found for plate: ' .. plate,
                type = 'error'
            })
        end
    end, plate)
end, false)

-- SVP (Super Vehicle Plate) command - checks nearby vehicle
RegisterCommand('svp', function(source, args)
    if not player.inDuty() then
        lib.notify({
            title = 'SVP Check',
            description = 'You must be on duty to use this command.',
            type = 'error'
        })
        return
    end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Find closest vehicle within 5 units
    local closestVehicle = nil
    local closestDistance = 5.0
    
    for vehicle in exports.ox_lib:getNearbyVehicles(playerCoords, 5.0, true) do
        local vehicleCoords = GetEntityCoords(vehicle.entity)
        local distance = #(playerCoords - vehicleCoords)
        
        if distance < closestDistance then
            closestVehicle = vehicle.entity
            closestDistance = distance
        end
    end
    
    if not closestVehicle then
        lib.notify({
            title = 'SVP Check',
            description = 'No vehicle found nearby.',
            type = 'error'
        })
        return
    end
    
    local plate = GetVehicleNumberPlateText(closestVehicle)
    local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
    local vehicleCoords = GetEntityCoords(closestVehicle)
    local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z))
    
    -- Clean up plate text
    plate = string.gsub(plate, "^%s*(.-)%s*$", "%1") -- Trim whitespace
    
    -- Start radio animation and progress bar
    lib.requestAnimDict('random@arrests', 1000)
    TaskPlayAnim(playerPed, 'random@arrests', 'generic_radio_chatter', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    -- Show progress circle
    if lib.progressCircle({
        duration = 5500,
        position = 'bottom',
        label = 'Running plate check...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,    -- Allow walking
            car = true,      -- Disable car
            combat = true,   -- Disable combat
            mouse = false    -- Allow mouse
        }
    }) then
        -- Progress completed successfully
        ClearPedTasks(playerPed) -- Stop animation
        
        -- Perform plate check
        lib.callback('ars_policejob:getVehicleOwner', false, function(ownerInfo)
        if ownerInfo then
            local timeAgo = os.time() - ownerInfo.timestamp
            local timeStr = timeAgo > 3600 and math.floor(timeAgo / 3600) .. " hours ago" or math.floor(timeAgo / 60) .. " minutes ago"
            
            -- Send to ps-dispatch with different alerts for LSPD vs Civilian
            if exports['ps-dispatch'] then
                if ownerInfo.vehicleType == 'LSPD' then
                    exports['ps-dispatch']:CustomAlert({
                        coords = playerCoords,
                        message = "SVP - LSPD Vehicle Located",
                        dispatchCode = "svp_lspd",
                        code = "10-28",
                        icon = "fas fa-shield-alt",
                        priority = 2,
                        plate = plate,
                        vehicle = vehicleModel,
                        name = ownerInfo.name,
                        alertTime = 20,
                        jobs = { 'police', 'sheriff', 'leo' },
                        alert = {
                            radius = 15.0,
                            sprite = 56,
                            color = 2,
                            scale = 0.9,
                            length = 4,
                            sound = "Lose_1st",
                            sound2 = "GTAO_FM_Events_Soundset",
                            flash = false
                        }
                    })
                else
                    exports['ps-dispatch']:CustomAlert({
                        coords = playerCoords,
                        message = "SVP - Civilian Vehicle Check",
                        dispatchCode = "svp_civilian",
                        code = "10-28",
                        icon = "fas fa-user",
                        priority = 2,
                        plate = plate,
                        vehicle = vehicleModel,
                        name = ownerInfo.name,
                        alertTime = 15,
                        jobs = { 'police', 'sheriff', 'leo' },
                        alert = {
                            radius = 10.0,
                            sprite = 1,
                            color = 5,
                            scale = 0.8,
                            length = 3,
                            sound = "Lose_1st",
                            sound2 = "GTAO_FM_Events_Soundset"
                        }
                    })
                end
            end
            
            local notificationDesc = ""
            if ownerInfo.vehicleType == 'LSPD' then
                notificationDesc = string.format(
                    'Plate: %s\nType: LSPD Vehicle\nVehicle: %s\nOfficer: %s\nRank: %d\nLocation: %s\nIssued: %s',
                    plate,
                    vehicleModel,
                    ownerInfo.name,
                    ownerInfo.grade or 0,
                    streetName or "Unknown",
                    timeStr
                )
            else
                notificationDesc = string.format(
                    'Plate: %s\nType: Civilian Vehicle\nVehicle: %s\nOwner: %s\nLocation: %s\nGarage: %s',
                    plate,
                    vehicleModel,
                    ownerInfo.name,
                    streetName or "Unknown",
                    ownerInfo.garage or "Unknown"
                )
            end
            
            lib.notify({
                title = 'SVP Check Results',
                description = notificationDesc,
                type = 'success',
                duration = 10000
            })
        else
            -- Send unknown vehicle check to dispatch
            if exports['ps-dispatch'] then
                exports['ps-dispatch']:CustomAlert({
                    coords = playerCoords,
                    message = "SVP - Unknown Vehicle",
                    dispatchCode = "svp_unknown",
                    code = "10-28",
                    icon = "fas fa-question-circle",
                    priority = 2,
                    plate = plate,
                    vehicle = vehicleModel,
                    alertTime = 15,
                    jobs = { 'police', 'sheriff', 'leo' },
                    alert = {
                        radius = 10.0,
                        sprite = 1,
                        color = 1,
                        scale = 0.8,
                        length = 3,
                        sound = "Lose_1st",
                        sound2 = "GTAO_FM_Events_Soundset"
                    }
                })
            end
            
            lib.notify({
                title = 'SVP Check',
                description = string.format(
                    'Plate: %s\nVehicle: %s\nLocation: %s\nStatus: Unknown/Unregistered Vehicle',
                    plate,
                    vehicleModel,
                    streetName or "Unknown"
                ),
                type = 'error',
                duration = 8000
            })
        end
        end, plate)
    else
        -- Progress was cancelled
        ClearPedTasks(playerPed) -- Stop animation
        lib.notify({
            title = 'SVP Check',
            description = 'Plate check cancelled.',
            type = 'error'
        })
    end
end, false)

-- Suggestion for commands
TriggerEvent('chat:addSuggestion', '/platecheck', 'Check LSPD vehicle ownership by plate number', {
    { name = 'plate', help = 'License plate number' }
})

TriggerEvent('chat:addSuggestion', '/svp', 'Super Vehicle Plate - Check nearby vehicle ownership', {})

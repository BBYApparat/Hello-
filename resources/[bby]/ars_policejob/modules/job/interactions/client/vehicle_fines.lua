-- Declare the function first
local openFineDialog

local function initVehicleFines()
    -- Add ox_target to all vehicles for police officers
    exports.ox_target:addGlobalVehicle({
        {
            name = 'police_fine_vehicle',
            label = 'Fine Vehicle',
            icon = 'fas fa-ticket-alt',
            groups = {'police', 'sheriff', 'leo'},
            canInteract = function(entity, distance, coords, name, bone)
                return player.inDuty() and not IsPedInVehicle(PlayerPedId(), entity, false)
            end,
            onSelect = function(data)
                local vehicle = data.entity
                local plate = GetVehicleNumberPlateText(vehicle)
                local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                
                -- Clean up plate text
                plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")
                
                -- Open fine dialog
                openFineDialog(plate, vehicleModel)
            end,
        }
    })
end

-- Define the function
openFineDialog = function(plate, vehicleModel)
    -- Create input dialog for fine reason
    local reasonInput = lib.inputDialog('Vehicle Fine - ' .. plate, {
        {
            type = 'input',
            label = 'Fine Reason',
            description = 'Enter the reason for the fine',
            required = true,
            min = 5,
            max = 200
        },
        {
            type = 'number',
            label = 'Fine Amount ($)',
            description = 'Enter the fine amount in dollars',
            required = true,
            min = 1,
            max = 10000
        }
    })
    
    if not reasonInput then return end
    
    local reason = reasonInput[1]
    local amount = reasonInput[2]
    
    if not reason or not amount then
        lib.notify({
            title = 'Vehicle Fine',
            description = 'Invalid input provided.',
            type = 'error'
        })
        return
    end
    
    -- Confirm the fine
    local confirmed = lib.alertDialog({
        header = 'Confirm Fine',
        content = string.format(
            'Vehicle: %s\nPlate: %s\nReason: %s\nAmount: $%s\n\nAre you sure you want to issue this fine?',
            vehicleModel,
            plate,
            reason,
            amount
        ),
        centered = true,
        cancel = true
    })
    
    if confirmed == 'confirm' then
        -- Process the fine
        lib.callback('ars_policejob:fineVehicle', false, function(result)
            if result.success then
                lib.notify({
                    title = 'Vehicle Fine',
                    description = result.message,
                    type = 'success',
                    duration = 8000
                })
                
                -- Send to ps-dispatch if available
                if exports['ps-dispatch'] then
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    exports['ps-dispatch']:CustomAlert({
                        coords = playerCoords,
                        message = "Vehicle Citation Issued",
                        dispatchCode = "vehicle_citation",
                        code = "10-99",
                        icon = "fas fa-ticket-alt",
                        priority = 2,
                        plate = plate,
                        vehicle = vehicleModel,
                        alertTime = 10,
                        jobs = { 'police', 'sheriff', 'leo' },
                        alert = {
                            radius = 5.0,
                            sprite = 1,
                            color = 6,
                            scale = 0.7,
                            length = 2,
                            sound = "Lose_1st",
                            sound2 = "GTAO_FM_Events_Soundset"
                        }
                    })
                end
            else
                lib.notify({
                    title = 'Vehicle Fine',
                    description = result.message,
                    type = 'error',
                    duration = 6000
                })
            end
        end, plate, reason, amount)
    end
end

-- Initialize the system
CreateThread(function()
    Wait(2000) -- Wait for dependencies
    initVehicleFines()
end)
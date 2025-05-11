local vehicleTowed = nil
local currentTruck = nil
local canTowVehicle = false
local haveAttachedVehicle = false

createAddModelTarget('flatbed', {
    {
        label = locale('target_tow_vehicle'),
        icon = 'far fa-arrow-alt-circle-up',
        canInteract = function()
            return (vehicleTowed == nil) 
        end,
        onSelect = function(data)
            currentTruck = data.entity
            canTowVehicle = true
            showTextUI(locale('textui_tow_help'), "eye")
        end,
        action = function(entity)
            currentTruck = entity
            canTowVehicle = true
            showTextUI(locale('textui_tow_help'), "eye")
        end
    },
    {
        label = locale('target_drop_vehicle'),
        icon = 'far fa-arrow-alt-circle-up',
        canInteract = function()
            return (vehicleTowed ~= nil) 
        end,
        onSelect = function()
            dropVehicle()
        end,
        action = function()
            dropVehicle()
        end
    },
}, 2.5)

createGlobalVehicleTarget({
    {
        label = locale('target_tow_vehicle'),
        icon = 'far fa-arrow-alt-circle-up',
        canInteract = function(entity)
            return (GetHashKey(entity) ~= GetHashKey(currentTruck) and canTowVehicle and haveAttachedVehicle == false)
        end,
        onSelect = function(data) towVehicle(data.entity) end,
        action = function(entity) towVehicle(entity) end
    }
}, 2.5)

towVehicle = function(vehicle)
    AttachEntityToEntity(vehicle, currentTruck, GetEntityBoneIndexByName(currentTruck, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 0.85, 0, 0, 0, 1, 1, 0, 1, 0, 1)
    FreezeEntityPosition(vehicle, true)
    vehicleTowed = vehicle
    haveAttachedVehicle = true
    hideTextUI()
end

dropVehicle = function()
    local coord = GetEntityCoords(currentTruck)
    FreezeEntityPosition(vehicleTowed, false)
    Wait(250)
    AttachEntityToEntity(vehicleTowed, currentTruck, 20, -0.5, -13.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    DetachEntity(vehicleTowed, true, true)
    vehicleTowed = nil
    haveAttachedVehicle = false
    canTowVehicle = false
end
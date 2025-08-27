local OR, XOR, AND = 1, 3, 4
local function bitOper(flag, checkFor, oper)
    local result, mask, sum = 0, 2 ^ 31
    repeat
        sum, flag, checkFor = flag + checkFor + mask, flag % mask, checkFor % mask
        result, mask = result + mask * oper % (sum - flag - checkFor), mask / 2
    until mask < 1
    return result
end

local function addDownforceFlag(vehicle)
    local adv_flags = GetVehicleHandlingInt(vehicle, 'CCarHandlingData', 'strAdvancedFlags')
    local hasDownforceFlag = bitOper(adv_flags, 134217728, AND) == 134217728
    
    -- Remove flags 512 and 2048 if present
    if not hasDownforceFlag then
        adv_flags = bitOper(adv_flags, 134217728, OR)
    end

    local newFlags = math.floor(adv_flags)
    SetVehicleHandlingField(vehicle, 'CCarHandlingData', 'strAdvancedFlags', newFlags)
end

AddEventHandler("esx:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
    addDownforceFlag(vehicle)
    if IsThisModelACar(GetEntityModel(vehicle)) then
        ToggleItemBack(false)
    end
end)

AddEventHandler('esx:exitedVehicle', function(vehicle, plate, seat, displayName, netId)
    if IsThisModelACar(GetEntityModel(vehicle)) then
        ToggleItemBack(true)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local veh = GetVehiclePedIsIn(cache.ped)
        if DoesEntityExist(veh) and GetPedInVehicleSeat(veh, -1) == cache.ped then
            local model = GetEntityModel(veh)
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(veh) then
                DisableControlAction(0, 59)
                DisableControlAction(0, 60)
            else
                Wait(500)
            end
        else
            Wait(5000)
        end
    end
end)

RegisterNetEvent("n_snippts:adminKey", function(_)
    if _ then
        local veh = GetVehiclePedIsIn(cache.ped)
        exports['SimpleCarlock']:GiveKey(Framework.Math.Trim(GetVehicleNumberPlateText(veh)))
    end
end)
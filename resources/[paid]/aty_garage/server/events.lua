RegisterNetEvent("aty_garage:takeOutVehicle", function(plate, netId)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    local vehicles = GetPlayerVehicles(src)

    for k, v in pairs(vehicles) do
        if removeSpaces(v.plate) == removeSpaces(plate) then
            if Utils.Framework == "qb-core" then
                ExecuteSql('UPDATE '..Config.VehicleDataName..' SET state = 0 WHERE '..Config.VehicleIdentifier..' = ? AND plate = ?', { GetIdentifier(src), plate })
            elseif Utils.Framework == "es_extended" then
                ExecuteSql('UPDATE '..Config.VehicleDataName..' SET stored = 0 WHERE '..Config.VehicleIdentifier..' = ? AND plate = ?', { GetIdentifier(src), plate })
            end

            return
        end
    end
end)

-- Handle vehicle key assignment for SimpleCarlock
RegisterNetEvent("aty_garage:giveVehicleKeys", function(plate)
    local src = source
    
    -- Check if SimpleCarlock is running and give keys
    if GetResourceState('SimpleCarlock') == 'started' then
        exports['SimpleCarlock']:giveKeys(src, plate)
    end
end)
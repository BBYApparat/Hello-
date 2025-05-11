RegisterNUICallback("closeMenu", function(_, cb)
    UIActive = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback("spawnVehicle", function(data, cb)
    UIActive = false
    SetNuiFocus(false, false)
    cb('ok')

    local vehicles = GetGamePool("CVehicle")

    for _, vehicle in pairs(vehicles) do
        local plate = GetVehicleNumberPlateText(vehicle)

        if removeSpaces(plate) == removeSpaces(data.vehicle.plate) then
            Config.Notify('Vehicle is already out of the garage')
            return
        end
    end

    if data.garage == "impound" then
        local result = TriggerCallback("payImpound")

        if not result then
            Config.Notify('You do not have enough money to get your vehicle out of the impound')
            return
        end
    end

    local pedCoords = GetEntityCoords(PlayerPedId())
    local coords = SelectFreeCoord(GetClosestGarage(pedCoords))

    SpawnVehicle(data.vehicle?.mods and data.vehicle?.mods or data.vehicle?.vehicle, coords)
    Config.Notify('Vehicle has been spawned')
end)

function SelectFreeCoord(garage)
    for _, v in pairs(garage.spawnCoords) do
        local free = true

        for _, veh in pairs(GetGamePool("CVehicle")) do
            local vehCoords = GetEntityCoords(veh)
            local distance = #(vector3(v.x, v.y, v.z) - vehCoords)

            if distance < 5.0 then
                free = false
                break
            end
        end

        if free then
            return vector4(v.x, v.y, v.z, v.w)
        end
    end

    return garage.spawnCoords[1]
end
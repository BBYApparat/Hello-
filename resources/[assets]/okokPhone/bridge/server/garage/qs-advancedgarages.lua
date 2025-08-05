local env = {
    vec3 = vec3,
    vector3 = vector3,
    vector4 = vector4,
    vec4 = vector4,
    GetResourceState = GetResourceState,
    pairs =
        pairs,
    ipairs = ipairs
}
Ok.require("@qs-advancedgarages.config.config", env)
local qsConfig = env.Config

local functions = {}

local findQuery = CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1'

function functions:getVehicleLocation(plate, owner, source)
    local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
    if not vehicle then return end


    local impounded = vehicle.garage and qsConfig.Garages[vehicle.garage]?.isImpound or false
    local state = vehicle.garage == "OUT" and 0 or (impounded and 2 or 1)

    if state == 0 then
        return self.findVehicleOutsideByPlate(plate)
    else
        for garageName, data in pairs(qsConfig.Garages) do
            if garageName == vehicle.garage then
                return data.coords.menuCoords
            end
        end
    end
end

function functions.removeVehicleFromGarage(plate)
    local removeQuery = CurrentFramework == 'esx' and
        'UPDATE owned_vehicles SET garage = "OUT", stored = 0 WHERE plate = ?' or
        'UPDATE player_vehicles SET garage = "OUT", state = 0 WHERE plate = ?'

    MySQL.prepare.await(removeQuery, { plate })
end

function functions.isVehicleStored(plate)
    local storedQuery = CurrentFramework == 'esx' and
        'SELECT garage FROM owned_vehicles WHERE plate = ?' or
        'SELECT garage FROM player_vehicles WHERE plate = ?'
    return MySQL.prepare.await(storedQuery, { plate }) ~= "OUT"
end

function functions:getPlayerVehicles(identifier)
    local getQuery = CurrentFramework == 'esx' and
        'SELECT * FROM owned_vehicles WHERE owner = ?' or
        'SELECT * FROM player_vehicles WHERE citizenid = ?'

    local result = MySQL.rawExecute.await(getQuery, { identifier })
    if not result then return end

    local vehicles = {}
    for _, vehicle in ipairs(result) do
        local impounded = vehicle.garage and qsConfig.Garages[vehicle.garage]?.isImpound or false
        local mods = json.decode(CurrentFramework == 'esx' and vehicle.vehicle or vehicle.mods)
        table.insert(vehicles, {
            model = mods.model,
            plate = vehicle.plate,
            mods = mods,
            garage = vehicle.garage or vehicle.parking,
            state = vehicle.garage == "OUT" and 0 or (impounded and 2 or 1)
        })
    end

    return vehicles
end

RegisterNetEventOK("garage:vehicleSpawned", function(netId)
    exports['qs-advancedgarages']:setVehicleToPersistent(netId)
end)

return functions

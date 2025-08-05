Ok.require("@op-garages.config.garages")

---@type table<string, {Type: string, CenterOfZone: vector3, SpawnCoords: vector4, AccessCoords: vector4, Zone: function}>
local garages = Config.Garages

local functions = {}

local findQuery = CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? OR co_owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? OR co_owner = ? LIMIT 1'

function functions:getVehicleLocation(plate, owner, source)
    local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
    if not vehicle then return end

    local state = vehicle.state

    if state == 0 then
        return self.findVehicleOutsideByPlate(plate)
    else
        for garageName, data in pairs(garages) do
            if garageName == vehicle.garage then
                return data.SpawnCoords
            end
        end
    end
end

function functions.removeVehicleFromGarage(plate)
    local removeQuery = CurrentFramework == 'esx' and
        'UPDATE owned_vehicles SET parking = NULL, stored = 0 WHERE plate = ?' or
        'UPDATE player_vehicles SET garage = NULL, state = 0 WHERE plate = ?'

    MySQL.prepare.await(removeQuery, { plate })
end

function functions.isVehicleStored(plate)
    local storedQuery = CurrentFramework == 'esx' and
        'SELECT state FROM owned_vehicles WHERE plate = ?' or
        'SELECT state FROM player_vehicles WHERE plate = ?'
    return MySQL.prepare.await(storedQuery, { plate }) == 1
end

function functions:getPlayerVehicles(identifier, source)
    local prom = promise:new()
    exports["op-garages"]:getAllVehicles(source, "car", function(result)
        prom:resolve(result)
    end)

    local result = Citizen.Await(prom)

    local vehicles = {}
    for _, vehicle in ipairs(result) do
        local mods = json.decode(CurrentFramework == 'esx' and vehicle.vehicle or vehicle.mods)
        table.insert(vehicles, {
            model = mods.model,
            plate = vehicle.plate,
            mods = mods,
            garage = vehicle.garage or vehicle.parking,
            state = vehicle.state == 0 and 2 or 1
        })
    end

    return vehicles
end

return functions

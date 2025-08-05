local hex_2_GarageConfig = exports['hex_2_Garage']:getConfig()


local function findGarageCoords(garageId)
    for _, garage in ipairs(hex_2_GarageConfig.Garages) do
        if garage.id == garageId then
            return garage.coords --[[ @as vector3 ]]
        end
    end
end

local function findImpoundCoords(impoundId)
    for _, impound in ipairs(hex_2_GarageConfig.Impound) do
        if impound.name == impoundId then
            return impound.coords --[[ @as vector3 ]]
        end
    end
    return hex_2_GarageConfig.Impound[1].coords
end

---@type GarageBridge
local functions = {}

local findQuery =
    CurrentFramework == 'esx' and 'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1'

---Finds the location of a vehicle
---@param plate string
---@param owner string
---@return vector3 | nil
---@diagnostic disable-next-line: duplicate-set-field
function functions:getVehicleLocation(plate, owner, source)
    local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
    if not vehicle then return end

    local state = CurrentFramework == 'esx' and vehicle.stored or vehicle.state

    --- If vehicle is outside
    if state == 0 then
        return self.findVehicleOutsideByPlate(plate)

        --- If vehicle is in garage
    elseif state == 1 then
        return findGarageCoords(CurrentFramework == 'esx' and vehicle.parking or vehicle.garage)
        --- If vehicle is impounded
    elseif state == 2 then
        return findImpoundCoords(vehicle.location)
    end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET stored = ?, parking = NULL WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET state = ?, garage = NULL WHERE plate = ? LIMIT 1'
function functions.removeVehicleFromGarage(plate)
    MySQL.prepare.await(removeQuery, { 0, plate })
end

local storedQuery =
    CurrentFramework == 'esx' and
    'SELECT stored FROM owned_vehicles WHERE plate = ?' or
    'SELECT state FROM player_vehicles WHERE plate = ?'
---@return boolean
function functions.isVehicleStored(plate)
    return MySQL.prepare.await(storedQuery, { plate }) == 1
end

local getQuery = CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE owner = ?' or
    'SELECT * FROM player_vehicles WHERE citizenid = ?'

---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
function functions:getPlayerVehicles(char_id)
    local result = MySQL.rawExecute.await(getQuery, { char_id })
    if not result then return end

    local vehicles = {}

    for _, vehicle in ipairs(result) do
        local mods = CurrentFramework == "esx" and json.decode(vehicle.vehicle) or json.decode(vehicle.mods)
        table.insert(vehicles, {
            model = mods.model,
            plate = vehicle.plate,
            mods = mods,
            garage = CurrentFramework == 'esx' and vehicle.parking or vehicle.garage,
            state = CurrentFramework == 'esx' and vehicle.stored or vehicle.state
        })
    end

    return vehicles
end

return functions

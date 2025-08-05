---@class Ak47QbGarage
---@field gid string
---@field name string
---@field polyzone string
---@field spawns string
---@field setting string
---@field realparked string
---@field reposition string
---@field trailerpos string

local garages = MySQL.query.await("SELECT * FROM ak47_qb_garage") --[[ @as Ak47QbGarage[] ]]

for _, garage in ipairs(garages) do
    garage.spawns = json.decode(garage.spawns)
end


local function findGarageCoords(name)
    for _, garage in ipairs(garages) do
        if garage.gid == name then
            return vector3(garage.spawns[1].x, garage.spawns[1].y, garage.spawns[1].z)
        end
    end
end

--[[ @type GarageBridge ]]
local functions = {}

function functions.removeVehicleFromGarage(plate)
    MySQL.prepare.await("UPDATE player_vehicles SET state = ?, garage = NULL  WHERE plate = ? LIMIT 1", { 0, plate })
end

function functions.isVehicleStored(plate)
    return MySQL.prepare.await("SELECT state FROM player_vehicles WHERE plate = ? LIMIT 1", { plate }) == 1
end

---@return vector3 | nil
function functions:getVehicleLocation(plate, owner)
    local vehicle = MySQL.prepare.await(
        "SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1",
        { plate, owner })
    if not vehicle then return end

    --- If vehicle is outside
    if vehicle.state == 0 then
        return self.findVehicleOutsideByPlate(plate)

        --- If vehicle is in garage
    elseif vehicle.state == 1 then
        return findGarageCoords(vehicle.garage)
        --- If vehicle is impounded
    elseif vehicle.state == 2 then
        return
    end
end

---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
function functions:getPlayerVehicles(char_id)
    local result = MySQL.rawExecute.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { char_id })
    if not result then return end

    local vehicles = {}

    for _, vehicle in ipairs(result) do
        table.insert(vehicles, {
            model = vehicle.vehicle,
            plate = vehicle.plate,
            mods = json.decode(vehicle.mods),
            garage = vehicle.garage,
            state = vehicle.state
        })
    end

    return vehicles
end

return functions

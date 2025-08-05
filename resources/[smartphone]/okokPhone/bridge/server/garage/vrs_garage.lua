if not lib then
  local chunk = LoadResourceFile('ox_lib', 'init.lua')
  load(chunk, '@@ox_lib/init.lua', 't')()
end

local env = {
  vec2 = vec2,
  vec3 = vec3,
  vec4 = vec4,
  vector3 = vector3,
  vector2 = vector2,
  vector4 = vector4,
  lib = lib,
}
Ok.require('@vrs_garage.shared.config', env)
local config = env.Config -- vrs_garage Config Table
---@return vector3 | nil
local function findGarageCoords(garageId)
  for k, v in pairs(config.Garages) do
    if k == garageId then
      return v.access
    end
  end
end

local function findImpoundCoords(impoundId)
  for k, v in pairs(config.Impounds) do
    if k == impoundId then
      return v.access
    end
  end
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
function functions:getVehicleLocation(plate, owner)
  local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
  if not vehicle then return end

  --- If vehicle is outside
  if vehicle.stored == 0 then
    return self.findVehicleOutsideByPlate(plate)

    --- If vehicle is in garage
  elseif vehicle.stored == 1 then
    return findGarageCoords(vehicle.garage_id)
    --- If vehicle is impounded
  elseif vehicle.stored == 2 then
    return findImpoundCoords(vehicle.impound)
  end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET stored = ?, parking = NULL WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET state = ?, parking = NULL WHERE plate = ? LIMIT 1'
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
      garage = vehicle.parking,
      state = vehicle.state or vehicle.stored
    })
  end

  return vehicles
end

return functions

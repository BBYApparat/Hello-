local env = { vector3 = vector3, vector4 = vector4, vec3 = vec3, vec4 = vec4 }
Ok.require("@loaf_garage.config.config", env)
local loafConfig = env.Config

local garages = loafConfig.Garages
local impounds = loafConfig.Impounds

---@type GarageBridge
local functions = {}

local findQuery =
    CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1'

---Finds the location of a vehicle
---@param plate string
---@param owner string
---@return vector3 | nil
---@diagnostic disable-next-line: duplicate-set-field
function functions:getVehicleLocation(plate, owner)
  local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
  if not vehicle then return end
  local state = CurrentFramework == "esx" and vehicle.stored or vehicle.state

  --- If vehicle is outside
  if state == 0 then
    local coords = self.findVehicleOutsideByPlate(plate)
    --vehicle is impounded
    if not coords then
      local impoundInfo = impounds[1]
      if impoundInfo then
        return vector3(impoundInfo.retrieve.x, impoundInfo.retrieve.y, impoundInfo.retrieve.z)
      end
    end

    --- If vehicle is in garage
  elseif state == 1 then
    local garageInfo = garages[vehicle.garage]?.retrieve
    if garageInfo then
      return vector3(garageInfo.x, garageInfo.y, garageInfo.z)
    end
  end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET stored = ?, garage = "" WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET state = ?, garage = "" WHERE plate = ? LIMIT 1'
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
      garage = vehicle.garage,
      state = CurrentFramework == "esx" and vehicle.stored or vehicle.state
    })
  end

  return vehicles
end

return functions

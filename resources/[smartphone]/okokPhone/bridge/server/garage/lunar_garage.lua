local env = { vector3 = vector3, vector4 = vector4, vec3 = vec3, vec4 = vec4 }
Ok.require("@lunar_garage.config.config", env)
local Config = env.Config -- Lunar Garage Config

---@return vector3 | nil
local function findGarageCoords(source)
  local coords = GetEntityCoords(GetPlayerPed(source))
  local closest = nil
  local closestDistance = nil
  for i, v in ipairs(Config.Garages) do
    if v.Type == "car" then
      local distance = #(coords - v.Position)
      if closest == nil or distance < closestDistance then
        closest = v.Position
        closestDistance = distance
      end
    end
  end

  return closest
end

---@type GarageBridge
local functions = {}

local findQuery =
    CurrentFramework == 'esx' and 'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1'

---Finds the location of a vehicle
---@param plate string
---@param owner string
---@param source number
---@return vector3 | nil
---@diagnostic disable-next-line: duplicate-set-field
function functions:getVehicleLocation(plate, owner, source)
  local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
  if not vehicle then return end

  if vehicle.stored == 1 then
    return findGarageCoords(source)
  end

  --- If vehicle is outside
  if vehicle.stored == 0 then
    return self.findVehicleOutsideByPlate(plate) or Config.Impounds[1].Position
  end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET stored = ? WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET stored = ? WHERE plate = ? LIMIT 1'
function functions.removeVehicleFromGarage(plate)
  MySQL.prepare.await(removeQuery, { 0, plate })
end

local storedQuery =
    CurrentFramework == 'esx' and
    'SELECT stored FROM owned_vehicles WHERE plate = ?' or
    'SELECT stored FROM player_vehicles WHERE plate = ?'
---@return boolean
function functions.isVehicleStored(plate)
  return MySQL.prepare.await(storedQuery, { plate }) == 1
end

local getQuery = CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE owner = ? AND `type` = "car"' or
    'SELECT * FROM player_vehicles WHERE citizenid = ? AND `type` = "car"'

---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
function functions:getPlayerVehicles(char_id)
  local result = MySQL.rawExecute.await(getQuery, { char_id })
  if not result then return end

  local vehicles = {}

  for _, vehicle in ipairs(result) do
    local state = vehicle.stored == 1 and 1 or 0
    local mods = CurrentFramework == "esx" and json.decode(vehicle.vehicle) or json.decode(vehicle.mods)
    table.insert(vehicles, {
      model = mods.model,
      plate = vehicle.plate,
      mods = json.decode(vehicle.mods or vehicle.vehicle),
      garage = "", -- Irrelevant for Lunar Garage
      state = state
    })
  end

  return vehicles
end

return functions

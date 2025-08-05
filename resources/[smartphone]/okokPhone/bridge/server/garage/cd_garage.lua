local cd_garagesConfig = exports['cd_garage']:GetConfig()

---@return vector3 | nil
local function findGarageCoords(garageId)
  for _, v in pairs(cd_garagesConfig.Locations) do
    if v.Garage_ID == garageId then
      return vector3(v.x_1, v.y_1, v.z_1)
    end
  end
end

local function findImpoundCoords(impoundId)
  local success, result = pcall(function()
    for k, v in pairs(cd_garagesConfig.ImpoundLocations) do
      if v.ImpoundID == impoundId then
        return vector3(v.coords.x, v.coords.y, v.coords.z)
      end
    end
  end)
  if success then
    return result
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
  if vehicle.impound == 1 then
    return findImpoundCoords(vehicle.impound)
  end

  if vehicle.in_garage == 0 then
    return self.findVehicleOutsideByPlate(plate)
  end

  if vehicle.in_garage == 1 then
    return findGarageCoords(vehicle.garage_id)
  end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET in_garage = ?, garage_id = NULL WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET in_garage = ?, garage_id = NULL WHERE plate = ? LIMIT 1'
function functions.removeVehicleFromGarage(plate)
  MySQL.prepare.await(removeQuery, { 0, plate })
end

local storedQuery =
    CurrentFramework == 'esx' and
    'SELECT in_garage FROM owned_vehicles WHERE plate = ?' or
    'SELECT in_garage FROM player_vehicles WHERE plate = ?'
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
    local state = 0
    if vehicle.in_garage == 1 then
      state = 1
    end

    if vehicle.impound ~= 0 then
      state = 2
    end

    local mods = CurrentFramework == "esx" and json.decode(vehicle.vehicle) or json.decode(vehicle.mods)
    table.insert(vehicles, {
      model = mods.model,
      plate = vehicle.plate,
      mods = mods,
      garage = vehicle.garage_id,
      state = state
    })
  end

  return vehicles
end

return functions

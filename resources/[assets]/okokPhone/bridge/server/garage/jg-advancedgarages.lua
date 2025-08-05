---@class JgGarage
---@field name string
---@field label string
---@field type "car" | "sea" | "air"
---@field takeVehicle vector3
---@field putVehicle vector3
---@field spawnPoint vector3
---@field showBlip boolean
---@field blipName string
---@field blipNumber number
---@field blipColor number
---@field vehicle "car" | "sea" | "air"

---@type table<string, JgGarage>
local jgGarages = exports['jg-advancedgarages']:getAllGarages()

--- Using a loop instead of direct memory access
--- due to some reports of duplicate keys
---@return JgGarage?
local function findGarageById(garageId)
  for _, v in pairs(jgGarages) do
    if v.name == garageId then
      return v
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

  if vehicle.in_garage == 0 and vehicle.impound == 0 then
    return self.findVehicleOutsideByPlate(plate)
  elseif vehicle.in_garage == 1 then
    local garage = findGarageById(vehicle.garage_id)
    if garage then
      return garage.takeVehicle
    end
  elseif vehicle.impound == 1 then
    -- Todo: Implement impound
  end
end

local removeQuery =
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET in_garage = ?, stored = ?, garage_id = NULL WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET in_garage = ?, state = ?, garage_id = NULL WHERE plate = ? LIMIT 1'
function functions.removeVehicleFromGarage(plate)
  MySQL.prepare.await(removeQuery, { 0, 0, plate })
end

local storedQuery =
    CurrentFramework == 'esx' and 'SELECT in_garage FROM owned_vehicles WHERE plate = ? LIMIT 1' or
    'SELECT in_garage FROM player_vehicles WHERE plate = ? LIMIT 1'
---@return boolean
function functions.isVehicleStored(plate)
  return MySQL.prepare.await(storedQuery, { plate }) == 1
end

local getQuery = CurrentFramework == 'esx' and 'SELECT * FROM owned_vehicles WHERE owner = ?' or
    'SELECT * FROM player_vehicles WHERE citizenid = ?'

---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
function functions:getPlayerVehicles(char_id)
  local result = MySQL.rawExecute.await(getQuery, { char_id })
  if not result then return end

  local vehicles = {}

  for _, vehicle in ipairs(result) do
    local mods = CurrentFramework == 'esx' and json.decode(vehicle.vehicle) or json.decode(vehicle.mods)
    table.insert(vehicles, {
      model = mods.model,
      plate = vehicle.plate,
      mods = mods,
      garage = vehicle.garage_id,
      state = vehicle.in_garage == 1 and 1 or (vehicle.impound == 1 and 2) or 0
    })
  end

  return vehicles
end

return functions

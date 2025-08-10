--- Load garages

---@class GarageBridge
local functions = {}


local list = {
  "cd_garage",
  "jg-advancedgarages",
  "vrs_garage",
  "okokGarage",
  "loaf_garage",
  "lunar_garage",
  "ak47_qb_garage",
  "ak47_garage",
  "qs-advancedgarages",
  "m-Garages",
  "op-garages",
  "hex_2_Garage",
  "aty_garage"
}

local foundGarageScript = false
for _, r in ipairs(list) do
  if GetResourceState(r) == "started" then
    foundGarageScript = true
    functions = Ok.require(('bridge.server.garage.%s'):format(r))
    break
  end
end

--- Attempts to find coordinates of a vehicle outside
---@param plate string
---@return vector3 | nil
function functions.findVehicleOutsideByPlate(plate)
  local vehList = GetAllVehicles()

  --Remove white spaces from plate
  local trimmedPlate = plate:gsub('%s+', '')

  for _, veh in ipairs(vehList --[[ @as number[] ]]) do
    local p = GetVehicleNumberPlateText(veh)
    if trimmedPlate == p:gsub('%s+', '') then
      return GetEntityCoords(veh)
    end
  end
end

if foundGarageScript then return functions end

--- Fallback, didn't find a garage script
--- Framework specific functions
if CurrentFramework == 'esx' then
  -- if not GetResourceState('esx_garage') == 'started' then
  --   error("No compatible garage script found, check bridge/server/garage, for more info")
  --   return
  -- end

  -- local garages = exports["esx_garage"]:getGarages()
  -- local impounds = exports["esx_garage"]:getImpounds()

  function functions.removeVehicleFromGarage(plate)
    MySQL.prepare.await("UPDATE owned_vehicles SET stored = ?, parking = NULL WHERE plate = ? LIMIT 1", { 0, plate })
  end

  function functions.isVehicleStored(plate)
    return MySQL.prepare.await("SELECT stored FROM owned_vehicles WHERE plate = ? LIMIT 1", { plate }) == 1
  end

  ---@return vector3 | nil
  function functions:getVehicleLocation(plate, owner)
    local vehicle = MySQL.prepare.await("SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1",
      { plate, owner })
    if not vehicle then return end

    --- If vehicle is outside
    if vehicle.stored == 0 then
      return self.findVehicleOutsideByPlate(plate)

      --- If vehicle is in garage
    elseif vehicle.stored == 1 then
      local garageInfo = garages[vehicle.parking]
      if garageInfo then
        return vector3(garageInfo.EntryPoint.x, garageInfo.EntryPoint.y, garageInfo.EntryPoint.z)
      end
    elseif vehicle.stored == 2 then
      local impoundInfo = impounds[vehicle.pound]
      if impoundInfo then
        return vector3(impoundInfo.SpawnPoint.x, impoundInfo.SpawnPoint.y, impoundInfo.SpawnPoint.z)
      end
    end
  end

  ---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
  function functions:getPlayerVehicles(char_id, source)
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { char_id })
    if not result then return end

    local vehicles = {}

    for _, vehicle in ipairs(result) do
      local data = json.decode(vehicle.vehicle)
      table.insert(vehicles, {
        model = data.model,
        plate = vehicle.plate,
        mods = json.decode(vehicle.mods),
        garage = vehicle.parking,
        state = vehicle.stored
      })
    end

    return vehicles
  end
elseif CurrentFramework == 'qb' then
  if not GetResourceState('qb-garages') == 'started' then
    error("No compatible garage script found, check bridge/server/garage, for more info")
    return
  end

  local env = { vector3 = vector3, vector4 = vector4, vec3 = vec3, vec4 = vec4, vector2 = vector2, vec2 = vec2 }
  Ok.require("@qb-garages.config", env)
  local garages = env.Config.Garages

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
      return garages[vehicle.garage]?.takeVehicle --[[ @as vector3[]? ]]

      --- If vehicle is impounded
    elseif vehicle.state == 2 then
      return garages[vehicle.garage]?.takeVehicle --[[ @as vector3[]? ]]
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
elseif CurrentFramework == 'qbx' then
  if not GetResourceState('qbx_garages') == 'started' then
    error("No compatible garage script found, check bridge/server/garage, for more info")
    return
  end

  local garages = exports["qbx_garages"]:GetGarages()

  function functions.isVehicleStored(plate)
    return MySQL.prepare.await("SELECT state FROM player_vehicles WHERE plate = ? LIMIT 1", { plate }) == 1
  end

  function functions.removeVehicleFromGarage(plate)
    MySQL.prepare.await("UPDATE player_vehicles SET state = ?, garage = NULL WHERE plate = ? LIMIT 1", { 0, plate })
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
      local coords = garages[vehicle.garage]?.accessPoints?[1]?.coords --[[ @as vector4? ]]
      if coords then
        return vector3(coords.x, coords.y, coords.z)
      end

      --- If vehicle is impounded
    elseif vehicle.state == 2 then
      local coords = garages["impoundlot"]?.accessPoints?[1]?.coords --[[ @as vector4? ]]
      if coords then
        return vector3(coords.x, coords.y, coords.z)
      end
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
elseif CurrentFramework == 'ox' then
  local Ox = Framework --[[ @as OxServer ]]

  function functions.isVehicleStored(plate)
    local result = MySQL.prepare.await("SELECT stored FROM vehicles WHERE plate = ? LIMIT 1", { plate })
    return result ~= nil and result ~= "impound"
  end

  --- This part needs to be adapted to the proper garage script
  --- I have one here: https://github.com/luxu-gg/luxu_garages_ox
  --- You can find more here https://github.com/overextended/awesome-ox?tab=readme-ov-file
  ---@return vector3 | nil
  function functions:getVehicleLocation(plate, owner)
    local garage = MySQL.prepare.await(
      "SELECT stored FROM vehicles WHERE plate = ? AND owner = ? LIMIT 1",
      { plate, owner })
    if not garage then return end

    --- If vehicle is outside
    if garage == nil then
      return self.findVehicleOutsideByPlate(plate)

      --- If vehicle is in garage
    elseif garage ~= "impound" then
      return vector3(0, 0, 0)

      --- If vehicle is impounded
    else
      return vector3(0, 0, 0)
    end
  end

  ---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
  function functions:getPlayerVehicles(char_id)
    local result = MySQL.rawExecute.await('SELECT * FROM vehicles where owner = ?', { char_id })
    if not result then return end

    local vehicles = {}

    for _, vehicle in ipairs(result) do
      vehicles[#vehicles + 1] = {
        model  = vehicle.model,
        plate  = vehicle.plate,
        mods   = json.decode(vehicle.data.properties),
        garage = vehicle.stored,
        state  = vehicle.stored == 'impound' and 2 or (vehicle.stored and 1 or 0)
      }
    end

    return vehicles
  end
end


return functions

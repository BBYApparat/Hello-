local cUtils = Ok.require("client.open.functions")
local Wait = Wait

---@type VehicleInfo[]
local cachedVehicles = {}

local vehicleModelNames = setmetatable({}, {
  __index = function(tbl, key --[[ @as number | string ]])
    local hash = tonumber(key)
    if hash then
      rawset(tbl, key, GetDisplayNameFromVehicleModel(hash))
      return tbl[key]
    elseif type(key) == "string" then
      rawset(tbl, key, key)
      return tbl[key]
    end

    return key --[[ @as string ]]
  end
})

---@return VehicleInfo | false
local function checkCar(plate)
  for _, veh in ipairs(cachedVehicles) do
    if veh.plate == plate then
      return veh
    end
  end
  return false
end


---@param data {plate:string,model:string, mods:table}
local function bringCar(data)
  local playerPed = PlayerPedId()
  local pedCoords = GetEntityCoords(playerPed)

  local plate = data.plate
  local modelHash = type(data.model) == "number" and data.model or joaat(data.model)

  if Config.Garage.BringVehicle.disableValet then
    Ok.requestModel(modelHash)
    local vehicle = CreateVehicle(modelHash, pedCoords.x, pedCoords.y, pedCoords.z, 0, true, false)
    cUtils:setVehicleProperties(vehicle, data.mods)
    SetVehicleNumberPlateText(vehicle, plate)
    cUtils:GiveVehicleKeys(vehicle, plate, data.model)
    cUtils:vehicleSpawned(vehicle, plate)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    triggerServerEvent('garage:vehicleSpawned', NetworkGetNetworkIdFromEntity(vehicle))
    return
  end

  local drivingFlags = Config.Garage.BringVehicle.drivingStyleFlag or 786691

  if not checkCar(plate) then
    notifyDI({
      app = "garage",
      title = Locales.error,
      text = Locales.bring_vehicle_error_message,
      duration = 3000,
    })
    return
  end

  local offset = Config.Garage.BringVehicle.spawnDistance or 40
  local tempCoords = vec3(pedCoords.x + offset, pedCoords.y + offset, pedCoords.z)
  local spawnCoords = tempCoords
  -- local _, roadCoords = GetPointOnRoadSide(tempCoords.x, tempCoords.y, tempCoords.z, 0)
  local success, outPosition, outHeading = GetClosestVehicleNodeWithHeading(tempCoords.x, tempCoords.y, tempCoords.z,
    1,
    3.0,
    0)
  if success then
    spawnCoords = outPosition
  else
    local success, coords = GetPointOnRoadSide(tempCoords.x, tempCoords.y, tempCoords.z, 0)
    if success then
      spawnCoords = coords
    end
  end

  -- Create Vehicle
  Ok.requestModel(modelHash)
  local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0, true, false)
  SetEntityHeading(vehicle, outHeading)
  SetModelAsNoLongerNeeded(modelHash)
  -- Apply Vehicle Mods
  repeat Wait(0) until DoesEntityExist(vehicle)

  cUtils:setVehicleProperties(vehicle, data.mods)
  SetVehicleNumberPlateText(vehicle, plate)
  cUtils:vehicleSpawned(vehicle, plate)
  triggerServerEvent('garage:vehicleSpawned', NetworkGetNetworkIdFromEntity(vehicle))
  -- Create Blip
  local blip = AddBlipForEntity(vehicle)
  SetBlipSprite(blip, 326)
  SetBlipColour(blip, 5)
  -- Create Ped
  Ok.requestModel(`a_m_y_business_01`)
  local ped = CreatePedInsideVehicle(vehicle, 4, `a_m_y_business_01`, -1, true, true)
  -- Drive to Player
  TaskVehicleAimAtPed(ped, playerPed)
  TaskVehicleDriveToCoord(ped, vehicle, pedCoords.x, pedCoords.y, pedCoords.z, 10.0, 1, modelHash, drivingFlags, 10.0, 1)

  local startTime = GetGameTimer()
  CreateThread(function()
    while true do
      if not DoesEntityExist(vehicle) then return end

      local vehCoords = GetEntityCoords(vehicle)
      local myCoords = GetEntityCoords(playerPed)
      local distance = #(myCoords - vehCoords)

      local timePassed = GetGameTimer() - startTime
      if distance < 6.0 or (timePassed > 30 * 1000) then
        local coords = GetEntityCoords(vehicle)
        local heading = GetEntityHeading(vehicle)
        local ped = GetPedInVehicleSeat(vehicle, -1)
        if ped then
          TaskVehiclePark(ped, vehicle, coords.x, coords.y, coords.z, heading, 0, 90, true)
          TaskLeaveAnyVehicle(ped, 0, 0)
          SetTimeout(3000, function()
            DeletePed(ped)
          end)
        end
        RemoveBlip(blip)
        cUtils:GiveVehicleKeys(vehicle, plate, GetDisplayNameFromVehicleModel(modelHash))
        return
      end
      TaskVehicleDriveToCoord(ped, vehicle, pedCoords.x, pedCoords.y, pedCoords.z, 10.0, 1, modelHash,
        drivingFlags,
        10.0, 1)

      Wait(1000)
    end
  end)
end

local function canBringVehicle(model)
  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)
  local zCoord = coords.z - 15.0
  local modelHash = requestModel(model)

  local vehicle = CreateVehicle(modelHash, coords.x, coords.y, zCoord, 0, false, false)
  local modelType = GetVehicleClass(vehicle)
  DeleteEntity(vehicle)
  return modelType ~= 14 and modelType ~= 15 and modelType ~= 16
end

---@param data {plate:string,model:string}
---@param cb function
RegisterNuiCallback('garage:BringCar', function(data, cb)
  if not canBringVehicle then
    notifyDI({
      app = "garage",
      title = Locales.error,
      text = Locales.bring_vehicle_error_message,
      duration = 3000,
    })
    return cb(false)
  end

  local result = triggerServerCallback('garage:bringCar', data.plate) --[[ @as table? | "no_money" | nil ]]

  if result == "no_money" then
    notifyDI({
      app = "garage",
      title = Locales.error,
      text = Locales.not_enough_money,
      duration = 3000,
    })
    cb(false)
    return
  elseif result then
    notifyDI({
      app = "garage",
      title = Locales.request_success,
      text = Locales.vehicle_is_coming,
      duration = 3000,
    })

    local info = {
      plate = data.plate,
      model = result.model,
      mods = result
    }
    cb(true)
    bringCar(info)
  else
    notifyDI({
      app = "garage",
      title = Locales.error,
      text = Locales.bring_vehicle_error_message,
      duration = 3000,
    })
    cb(false)
  end
end)

RegisterNuiCallback('garage:getPlayerVehicles', function(_, cb)
  cachedVehicles = triggerServerCallback('garage:getPlayerVehicles') or {}

  for _, veh in ipairs(cachedVehicles) do
    veh.model = vehicleModelNames[veh.model]
  end

  cb(cachedVehicles)
end)

---@param data {plate:string}
---@param cb function
RegisterNuiCallback('garage:TrackCar', function(data, cb)
  local coords = triggerServerCallback('garage:TrackCar', data) --[[ @as vector3 | false ]]

  if not coords then
    notifyDI({
      app = "garage",
      title = Locales.error,
      text = Locales.track_vehicle_error_message,
      duration = 3000,
    })
    return cb(false)
  end


  SetNewWaypoint(coords.x, coords.y)

  cb(true)
end)

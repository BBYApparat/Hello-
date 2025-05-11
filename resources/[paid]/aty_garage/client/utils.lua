--- A simple wrapper around SendNUIMessage that you can use to
--- dispatch actions to the React frame.
---
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

--- A simple debug print function that is dependent on a convar
--- will output a nice prettfied message if debugMode is on
function debugPrint(...)
  if not Config.Debug then return end
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
    appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

function TriggerCallback(name, ...)
  local id = GetRandomIntInRange(0, 999999)
  local eventName = currentResourceName..":triggerCallback:" .. id
  local eventHandler
  local promise = promise:new()
  RegisterNetEvent(eventName)
  local eventHandler = AddEventHandler(eventName, function(...)
      promise:resolve(...)
  end)

  SetTimeout(15000, function()
    promise:resolve("timeout")
    RemoveEventHandler(eventHandler)
  end)
  local args = {...}
  TriggerServerEvent(name, id, args)

  local result = Citizen.Await(promise)
  RemoveEventHandler(eventHandler)
  return result
end

function GetClosestPedToPlayer()
  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed)
  local closestPed = nil
  local closestDistance = 1000.0
  local peds = GetGamePool('CPed')

  for k, ped in pairs(peds) do
    if ped ~= playerPed then
      local pedPos = GetEntityCoords(ped)
      local distance = #(playerPos - pedPos)
      if distance < closestDistance then
        closestPed = ped
        closestDistance = distance
      end
    end
  end

  return closestPed, closestDistance
end

function GetClosestVehicleToPlayer()
  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed)
  local closestVehicle = nil
  local closestDistance = 1000.0
  local vehicles = GetGamePool('CVehicle')

  for k, vehicle in pairs(vehicles) do
    if vehicle ~= playerPed then
      local vehiclePos = GetEntityCoords(vehicle)
      local distance = #(playerPos - vehiclePos)
      if distance < closestDistance then
        closestVehicle = vehicle
        closestDistance = distance
      end
    end
  end
  
  return closestVehicle, closestDistance
end

---@param dict string The animation dictionary to load
function LoadAnimDict(dict)
  RequestAnimDict(dict)

  while not HasAnimDictLoaded(dict) do
    Wait(0)
  end
end

---@param dict string The model dictionary to load
function LoadObject(dict)
  RequestModel(dict)

  while not HasModelLoaded(dict) do
    Wait(0)
  end
end

---@param x number The x coordinate
---@param y number The y coordinate
---@param z number The z coordinate
---@param model string The model to create
---@param cb function The callback to run after the ped is created
function CreatePedOnCoord(x, y, z, model, cb)
  local pedModel = GetHashKey(model)
  RequestModel(pedModel)
  while not HasModelLoaded(pedModel) do
    Wait(0)
  end
  local ped = CreatePed(4, pedModel, x, y, z, 0.0, true, false)
  SetEntityAsMissionEntity(ped, true, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  SetModelAsNoLongerNeeded(pedModel)
  if cb then
    cb(ped)
  end
  return ped
end

---@param x number The x coordinate
---@param y number The y coordinate
---@param z number The z coordinate
---@param sprite number The sprite to use for the blip
---@param color number The color to use for the blip
---@param text string The text to display on the blip
function CreateBlipOnCoords(x, y, z, sprite, color, text)
  local blip = AddBlipForCoord(x, y, z)
  SetBlipSprite(blip, sprite)
  SetBlipColour(blip, color)
  SetBlipScale(blip, 0.8)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(text)
  EndTextCommandSetBlipName(blip)
  return blip
end

---@param t table
function table_size(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

---@param x number The x coordinate
---@param y number The y coordinate
---@param z number The z coordinate
---@param text string The text to draw
function DrawText3D(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)

  if onScreen then
    SetTextScale(0.25, 0.25)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextDropshadow(0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)
  end
end

---@param text string The text to display
function ShowNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

---@param entity number The entity to play the animation on
---@param dict string The animation dictionary
---@param anim string The animation to play
---@param cb function The callback to run after the animation is played
function PlayAnimationWithEntity(entity, dict, anim, cb)
  LoadAnimDict(dict)
  TaskPlayAnim(entity, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
  if cb then
    cb()
  end
end

function table_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function ClearTableKeys(t)
  local t2 = {}

  for k, v in pairs(t) do
      table.insert(t2, v)
  end

  return t
end

function GetVehicleProperties(vehicle)
  if DoesEntityExist(vehicle) then
    if Utils.Framework == "es_extended" then
      props = Utils.FrameworkObject.Game.GetVehicleProperties(vehicle)
    else
      props = Utils.FrameworkObject.Functions.GetVehicleProperties(vehicle)
    end
  else
    return
  end

  for k, v in pairs(props) do
    if type(v) == "string" then
      v = StringArrayToArray(v)
    end
  end

  return props
end

local Init = {
  Frameworks  =  { "es_extended", "qb-core" },
}

Utils = {
  Framework,
  FrameworkObject,
  FrameworkShared,
}

Citizen.CreateThread(function()
  InitFramework()
end)

function InitFramework()
  if Utils.Framework ~= nil then return end
  for i = 1, #Init.Frameworks do
      if IsDuplicityVersion() then
          if GetResourceState(Init.Frameworks[i]) == "started" then
              Utils.Framework = Init.Frameworks[i]
              Utils.FrameworkObject = InitFrameworkObject()
              Utils.FrameworkShared = InitFrameworkShared()
          end
      else
          if GetResourceState(Init.Frameworks[i]) == "started" then
              Utils.Framework = Init.Frameworks[i]

              Utils.FrameworkObject = InitFrameworkObject()
              Utils.FrameworkShared = InitFrameworkShared()
          end
      end
  end
end

function InitFrameworkObject()
  if Utils.Framework == "es_extended" then
      local ESX = nil
      Citizen.CreateThread(function()
        while ESX == nil do
          Citizen.Wait(100)
          TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
      end)
      Wait(1000)
      if ESX == nil then
          ESX = exports["es_extended"]:getSharedObject()
      end
      return ESX
  elseif Utils.Framework == "qb-core" then
      local QBCore = nil
      Citizen.CreateThread(function()
        while QBCore == nil do
          Citizen.Wait(100)
          TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        end
      end)
      Wait(1000)
      if QBCore == nil then
          QBCore = exports["qb-core"]:GetCoreObject()
      end
      return QBCore
  end
end

function InitFrameworkShared()
  while Utils.FrameworkObject == nil do
      Citizen.Wait(100)
  end
  if Utils.Framework == "qb-core" then
      return Utils.FrameworkObject.Shared
  elseif Utils.Framework == "es_extended" then
      return Utils.FrameworkObject.Config
  end
end

function SpawnVehicle(props, coords)
  if Utils.Framework == "es_extended" then
      Utils.FrameworkObject.Game.SpawnVehicle(props.model, coords, coords.w, function(vehicle)

        print(json.encode(props, { indent = true }))

        if props and props.engineHealth then
          Utils.FrameworkObject.Game.SetVehicleProperties(vehicle, props)

          if Config.VisuallyDamageCars then
            doCarDamage(vehicle, props)
          end
        end

        SetVehicleEngineOn(vehicle, true, true)

        if Config.Warp then
          TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end
        
        Config.SetFuelExport(vehicle, props?.fuelLevel)
        TriggerServerEvent("aty_garage:takeOutVehicle", props.plate, NetworkGetNetworkIdFromEntity(vehicle))
    end)
  elseif Utils.Framework == "qb-core" then
      Utils.FrameworkObject.Functions.SpawnVehicle(props.model, function(vehicle)
        if Config.Warp then
          TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end

        if props and props.engineHealth then
          Utils.FrameworkObject.Functions.SetVehicleProperties(vehicle, props)

          if Config.VisuallyDamageCars then
            doCarDamage(vehicle, props)
          end
        end

        Config.SetFuelExport(vehicle, props?.fuelLevel)
        TriggerServerEvent("aty_garage:takeOutVehicle", props.plate, NetworkGetNetworkIdFromEntity(vehicle))
        TriggerEvent("qb-vehiclekeys:client:AddKeys", Utils.FrameworkObject.Functions.GetPlate(vehicle))
        
        SetVehicleEngineOn(vehicle, true, true)
    end, coords, true, false)
  end
end

function doCarDamage(currentVehicle, veh)
  local props = veh
  local engine = veh.engineHealth + 0.0
  local body = veh.bodyHealth + 0.0

  if engine < 200.0 then engine = 200.0 end
  if engine  > 1000.0 then engine = 950.0 end
  if body < 150.0 then body = 150.0 end

  Wait(100)
  SetVehicleEngineHealth(currentVehicle, engine)

  if Config.SaveDamage.Windows then
      if props.windows and #props.windows > 0 then
          for i = 1, #props.windows do
              SmashVehicleWindow(currentVehicle, props.windows[i])
          end
      end
  end

  if Config.SaveDamage.Doors then
      if props.doors and #props.doors > 0 then
          for i = 1, #props.doors do
              SetVehicleDoorBroken(currentVehicle, props.doors[i], true)
          end
      end
  end

  if Config.SaveDamage.Tyres then
      if props.tyres and #props.tyres > 0 then
          for i = 1, #props.doors do
              SetVehicleTyreBurst(currentVehicle, props.tyres[i].id, props.tyres[i].complete, 990.0)
          end
      end
  end

  if body < 1000 then
      SetVehicleBodyHealth(currentVehicle, 999.0)
  end
end

function removeSpaces(str)
    return str:gsub("%s+", "")
end

local Init = {
  Frameworks  =  { "es_extended", "qb-core" },
}

Utils = {
  Framework,
  FrameworkObject,
  FrameworkShared,
}

Citizen.CreateThread(function()
  InitFramework()
end)

function InitFramework()
  if Utils.Framework ~= nil then return end
  
  for i = 1, #Init.Frameworks do
    if IsDuplicityVersion() then
        if GetResourceState(Init.Frameworks[i]) == "started" then
            Utils.Framework = Init.Frameworks[i]
            Utils.FrameworkObject = InitFrameworkObject()
            Utils.FrameworkShared = InitFrameworkShared()
        end
    else
        if GetResourceState(Init.Frameworks[i]) == "started" then
            Utils.Framework = Init.Frameworks[i]

            Utils.FrameworkObject = InitFrameworkObject()
            Utils.FrameworkShared = InitFrameworkShared()
        end
    end
  end

  initialized = true
end

function InitFrameworkObject()
  if Utils.Framework == "es_extended" then
    local ESX = nil
      if Config.OldESX then
        Citizen.CreateThread(function()
          while ESX == nil do
            Citizen.Wait(100)
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
          end
        end)
        Wait(1000)
      end
      if ESX == nil then
          ESX = exports["es_extended"]:getSharedObject()
      end
      return ESX
  elseif Utils.Framework == "qb-core" then
      local QBCore = nil
      Citizen.CreateThread(function()
        while QBCore == nil do
          Citizen.Wait(100)
          TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        end
      end)
      Wait(1000)
      if QBCore == nil then
          QBCore = exports["qb-core"]:GetCoreObject()
      end
      return QBCore
  end
end

function InitFrameworkShared()
  while Utils.FrameworkObject == nil do
      Citizen.Wait(100)
  end
  if Utils.Framework == "qb-core" then
      return Utils.FrameworkObject.Shared
  elseif Utils.Framework == "es_extended" then
      return Utils.FrameworkObject.Config
  end
end

function StringArrayToArray(str)
    local tbl = {}
    
    -- Anahtar-değer çiftlerini ayıklamak için gsub kullan
    str = str:gsub("[{}\"]", "") -- Süslü parantezleri ve çift tırnakları kaldır
    for key, value in string.gmatch(str, "([^:,]+):([^:,]+)") do
        -- Anahtar ve değerleri tabloya ekle
        tbl[key] = tonumber(value) or value -- Değer sayıya dönüştürülebiliyorsa dönüştür
    end

    print(json.encode(tbl))
    
    return tbl
end
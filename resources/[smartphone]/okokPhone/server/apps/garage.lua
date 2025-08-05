---@class VehicleInfo
---@field model string
---@field plate string
---@field mods table
---@field garage string
---@field stored boolean
---@field state number

local garage = Ok.require("bridge.server.garage.main")
local pendingSpawns = {
  --[[ plate:true ]]
}

---@return VehicleInfo | nil
RegisterServerCallback('garage:getPlayerVehicles', function(source)
  local playerObj = Utils:getPlayerObject(source)
  if not playerObj then return end
  local char_id = Utils:getCharacterId(playerObj)
  return garage:getPlayerVehicles(char_id, source)
end)

if Config?.Garage?.BringVehicle?.enabled then
  ---@return table | "no_money" | nil
  RegisterServerCallback("garage:bringCar", function(source, plate)
    local playerObj = Utils:getPlayerObject(source)
    local charId = playerObj and Utils:getCharacterId(playerObj)
    if not charId or not playerObj then return end

    local mods = {}
    if not garage.isVehicleStored(plate) then return end

    if CurrentFramework == 'qb' or CurrentFramework == 'qbx' then
      --[[ Get Vehicle State and Mods ]]
      local result = MySQL.prepare.await(
        "SELECT mods FROM player_vehicles WHERE plate = ? AND citizenid = ?",
        { plate, charId }) --[[ @as string? ]]


      mods = result and json.decode(result)
    elseif (CurrentFramework == 'esx') then
      local result = MySQL.prepare.await(
        "SELECT vehicle FROM owned_vehicles WHERE plate = ? AND owner = ?", { plate, charId }) --[[ @as string? ]]

      mods = result and json.decode(result)
    end


    if not mods then return end
    -- Check if has enough money


    local balance = Utils:getAccountMoney("bank", playerObj)

    if balance < Config.Garage.BringVehicle.price then
      return "no_money"
    elseif Config.Garage.BringVehicle.price > 0 then
      Utils:removeAccountMoney("bank", Config.Garage.BringVehicle.price, playerObj)
    end

    if CurrentFramework == 'ox' then
      -- todo
    end

    -- Update Vehicle State
    garage.removeVehicleFromGarage(plate)

    pendingSpawns[plate] = true
    return mods
  end)
end

---@param data {plate:string}
RegisterServerCallback("garage:TrackCar", function(source, data)
  local playerObj = Utils:getPlayerObject(source)
  local charId = playerObj and Utils:getCharacterId(playerObj)
  if not charId then return end
  return garage:getVehicleLocation(data.plate, charId)
end)

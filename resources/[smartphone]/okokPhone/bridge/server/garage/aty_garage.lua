--- aty_garage Bridge for okokPhone
-- Load aty_garage config for garage coordinates
local env = { vector3 = vector3, vector4 = vector4, vec3 = vec3, vec4 = vec4 }
Ok.require("@aty_garage.shared.config", env)
local atyConfig = env.Config

local garages = atyConfig.Garages

---@class GarageBridge
local functions = {}

-- Optimized database queries based on framework
local findQuery = 
    CurrentFramework == 'esx' and 
    'SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? LIMIT 1' or
    'SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? LIMIT 1'

local removeQuery = 
    CurrentFramework == 'esx' and
    'UPDATE owned_vehicles SET stored = ?, parking = NULL WHERE plate = ? LIMIT 1' or
    'UPDATE player_vehicles SET state = ?, garage = NULL WHERE plate = ? LIMIT 1'

local storedQuery = 
    CurrentFramework == 'esx' and
    'SELECT stored FROM owned_vehicles WHERE plate = ?' or
    'SELECT state FROM player_vehicles WHERE plate = ?'

local getQuery = 
    CurrentFramework == 'esx' and
    'SELECT * FROM owned_vehicles WHERE owner = ?' or
    'SELECT * FROM player_vehicles WHERE citizenid = ?'

---@param plate string
function functions.removeVehicleFromGarage(plate)
    MySQL.prepare.await(removeQuery, { 0, plate })
end

---@param plate string
---@return boolean
function functions.isVehicleStored(plate)
    return MySQL.prepare.await(storedQuery, { plate }) == 1
end

---@param plate string
---@param owner string
---@return vector3 | nil
function functions:getVehicleLocation(plate, owner)
    local vehicle = MySQL.prepare.await(findQuery, { plate, owner })
    if not vehicle then return end
    
    local state = CurrentFramework == "esx" and vehicle.stored or vehicle.state
    local garageName = CurrentFramework == "esx" and vehicle.parking or vehicle.garage
    
    -- If vehicle is outside
    if state == 0 then
        return self.findVehicleOutsideByPlate(plate)
    -- If vehicle is in garage
    elseif state == 1 then
        if garageName and garages[garageName] then
            local garage = garages[garageName]
            return vector3(garage.vehicleCoords.x, garage.vehicleCoords.y, garage.vehicleCoords.z)
        end
    -- If vehicle is impounded
    elseif state == 2 then
        if garages["impound"] then
            local impound = garages["impound"]
            return vector3(impound.vehicleCoords.x, impound.vehicleCoords.y, impound.vehicleCoords.z)
        end
    end
    
    return nil
end

---@param char_id string
---@param source number
---@return {model:string, plate:string, mods:table, garage:string, state:number}[] | nil
function functions:getPlayerVehicles(char_id, source)
    local result = MySQL.rawExecute.await(getQuery, { char_id })
    if not result then return {} end
    
    local vehicles = {}
    
    for _, vehicle in ipairs(result) do
        local mods, model, garage, state
        
        if CurrentFramework == "esx" then
            local vehicleData = type(vehicle.vehicle) == "string" and json.decode(vehicle.vehicle) or vehicle.vehicle
            mods = vehicleData
            model = vehicleData.model or vehicle.vehicle
            garage = vehicle.parking or "unknown"
            state = vehicle.stored or 0
        else
            mods = type(vehicle.mods) == "string" and json.decode(vehicle.mods) or (vehicle.mods or {})
            model = vehicle.vehicle
            garage = vehicle.garage or "unknown" 
            state = vehicle.state or 0
        end
        
        table.insert(vehicles, {
            model = model,
            plate = vehicle.plate,
            mods = mods,
            garage = garage,
            state = state
        })
    end
    
    return vehicles
end

return functions
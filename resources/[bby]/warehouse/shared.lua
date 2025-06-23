-- Initialize ESX
ESX = exports["es_extended"]:getSharedObject()

-- Shared functions
function makeBlip(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, data.sprite or 473)
    SetBlipColour(blip, data.col or 0)
    SetBlipScale(blip, data.scale or 0.7)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(tostring(data.name) or 'Warehouse')
    EndTextCommandSetBlipName(blip)
    if Config.Debug then 
        print("^5Debug^7: ^6Blip ^2created for location^7: '^6"..data.name.."^7'") 
    end
    return blip
end

function getStreetandZone(coords)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local playerStreetsLocation = currentStreetName .. ", " .. zone
    return playerStreetsLocation
end

-- Check if player is admin
function IsPlayerAdmin(source)
    if not source then return false end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    
    local playerGroup = xPlayer.getGroup()
    
    for _, adminGroup in pairs(Config.AdminGroups) do
        if playerGroup == adminGroup then
            return true
        end
    end
    
    return false
end

-- Generate unique warehouse ID
function GenerateWarehouseId()
    return math.random(10000, 99999)
end

-- Validate coordinates
function ValidateCoords(coords)
    if not coords then return false end
    if type(coords) ~= "table" and type(coords) ~= "vector4" and type(coords) ~= "vector3" then return false end
    if not coords.x or not coords.y or not coords.z then return false end
    return true
end

-- Distance calculation
function GetDistance(pos1, pos2)
    if not ValidateCoords(pos1) or not ValidateCoords(pos2) then return 999999 end
    return #(vector3(pos1.x, pos1.y, pos1.z) - vector3(pos2.x, pos2.y, pos2.z))
end

-- Format money
function FormatMoney(amount)
    if not amount or amount == 0 then return "$0" end
    local formatted = tostring(amount)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return "$" .. formatted
end

-- Warehouse utility functions
WarehouseUtils = {}

function WarehouseUtils.GetStashName(warehouseId)
    return "warehouse_" .. warehouseId .. "_esx"
end

function WarehouseUtils.GetInstanceId(warehouseId)
    return 1000 + warehouseId -- Base instance ID offset
end

function WarehouseUtils.IsWarehouseOwner(playerId, warehouseData)
    if not warehouseData or not warehouseData.owner then return false end
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false end
    return warehouseData.owner == xPlayer.identifier
end

function WarehouseUtils.ValidatePassword(inputPassword, correctPassword)
    if not inputPassword or not correctPassword then return false end
    return tostring(inputPassword) == tostring(correctPassword)
end
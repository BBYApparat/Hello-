RegisterCallback("isVehicleOwned", function(src, plate)
    local vehicles = GetPlayerVehicles(src)

    for k, v in pairs(vehicles) do
        if removeSpaces(v.plate) == removeSpaces(plate) then
            return true
        end
    end

    return false
end)

RegisterCallback("storeVehicle", function(src, data)
    local identifier = GetIdentifier(src)
    local props = data[1]
    local bodyDamage = data[2]
    local engineDamage = data[3]
    local fuel = data[4]
    local garage = data[5]

    local vehicles = GetPlayerVehicles(src)

    for k, v in pairs(vehicles) do
        if removeSpaces(v.plate) == removeSpaces(props.plate) then
            local vehProps = type(props) == "table" and json.encode(props) or props

            if Utils.Framework == "qb-core" then
                ExecuteSql('UPDATE '..Config.VehicleDataName..' SET garage = ?, state = 1, mods = ?, fuel = ?, engine = ?, body = ? WHERE '..Config.VehicleIdentifier..' = ? AND plate = ?', { garage, vehProps, fuel, engineDamage, bodyDamage, identifier, props.plate })
            elseif Utils.Framework == "es_extended" then
                ExecuteSql('UPDATE '..Config.VehicleDataName..' SET parking = ?, vehicle = ?, stored = 1 WHERE '..Config.VehicleIdentifier..' = ? AND plate = ?', { garage, vehProps, identifier, props.plate })
            end

            return true
        end
    end

    return false
end)

RegisterCallback("getGarageData", function(src, garage)
    local garageName = garage.garage
    local result = {}

    if garage.garage == "impound" then
        if Utils.Framework == "qb-core" then
            local identifier = GetIdentifier(src)
            result = ExecuteSql('SELECT * FROM '..Config.VehicleDataName..' WHERE ((state = 0 OR state = 2) OR (garage = "impound" AND state = 1)) AND '..Config.VehicleIdentifier..' = ?', { identifier })
        elseif Utils.Framework == "es_extended" then
            local identifier = GetIdentifier(src)
            result = ExecuteSql('SELECT * FROM '..Config.VehicleDataName..' WHERE ((stored = 0 OR stored = 2) OR (parking = "impound" AND stored = 1)) AND '..Config.VehicleIdentifier..' = ?', { identifier })
        end
    else
        local identifier = GetIdentifier(src)
        if Config.UseSharedGarages then
            result = ExecuteSql('SELECT * FROM '..Config.VehicleDataName..' WHERE '..Config.VehicleIdentifier..' = ?', { identifier })
        else
            result = ExecuteSql('SELECT * FROM '..Config.VehicleDataName..' WHERE '..Config.VehicleIdentifier..' = ? AND '..Config.VehicleGarageName..' = ?', { identifier, garageName })
        end
    end

    if result then
        for k, v in pairs(result) do
            if Utils.Framework == "qb-core" then
                v.mods = json.decode(v.mods)

                for j, mod in pairs(v.mods) do
                    if j == "bodyHealth" then
                        v.mods[j] = string.format("%.1f", v.mods[j])
                    end
    
                    if j == "engineHealth" then
                        v.mods[j] = string.format("%.1f", v.mods[j])
                    end
    
                    if j == "fuelLevel" then
                        v.mods[j] = string.format("%.1f", v.mods[j])
                    end
                end
            elseif Utils.Framework == "es_extended" then
                v.vehicle = type(v.vehicle) == "string" and json.decode(v.vehicle) or v.vehicle

                for j, mod in pairs(v.vehicle) do
                    if j == "bodyHealth" then
                        v.vehicle[j] = string.format("%.1f", v.vehicle[j])
                    end
    
                    if j == "engineHealth" then
                        v.vehicle[j] = string.format("%.1f", v.vehicle[j])
                    end
    
                    if j == "fuelLevel" then
                        v.vehicle[j] = string.format("%.1f", v.vehicle[j])
                    end
                end
            end
        end

        return result
    end

    return {}
end)

RegisterCallback("payImpound", function(src)
    local identifier = GetIdentifier(src)
    local money = GetMoney(src, "bank")

    if money >= Config.ImpoundPrice then
        RemoveMoney(src, Config.ImpoundPrice)
        return true
    end

    return false
end)

function GetPlayerVehicles(src)
    local identifier = GetIdentifier(src)

    local vehicles = ExecuteSql('SELECT * FROM '..Config.VehicleDataName..' WHERE '..Config.VehicleIdentifier..' = ?', { identifier })

    if vehicles then
        for k, v in pairs(vehicles) do
            vehicles[k].vehicle = json.decode(v.vehicle)
        end

        return vehicles
    end

    return {}
end

function removeSpaces(str)
    return str:gsub("%s+", "")
end

-- function StringArrayToArray(str)
--     local tbl = {}

--     print(str)

--     -- Süslü parantezleri ve çift tırnakları kaldır
--     str = str:gsub("[{}\"]", "")

--     -- Anahtar-değer çiftlerini ayıklamak için döngü
--     for key, value in string.gmatch(str, "([^:,]+):([^:,]+)") do
--         -- Eğer değer bir string array ise düzelt
--         if value:match("^%[.*$") then
--             -- Hatalı array formatını düzelt
--             value = value:gsub("%[([^%]]*)", function(content)
--                 local fixedArray = {}
--                 -- Eğer içerik boşsa (yani sadece bir değer varsa), bunu da array'e ekle
--                 if content == "" then
--                     table.insert(fixedArray, 255) -- Varsayılan bir değer eklenebilir
--                 else
--                     for num in string.gmatch(content, "%d+") do
--                         table.insert(fixedArray, tonumber(num))
--                     end
--                 end
--                 return table.concat(fixedArray, ", ")
--             end)
--             -- Array'i tabloya çevir
--             local array = {}
--             for num in string.gmatch(value, "%d+") do
--                 table.insert(array, tonumber(num))
--             end
--             tbl[key] = array
--         else
--             -- Düz bir değer ise, sayıya dönüştürülebiliyorsa dönüştür
--             tbl[key] = tonumber(value) or value
--         end
--     end

--     return tbl
-- end
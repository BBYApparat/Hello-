local Vehicles = {}
local Categories = {}

local doesModelExistInDB = function(model)
    for i=1,#Vehicles do
        if (tostring(model) == tostring(Vehicles[i].model)) then
            return true
        end
    end
    return false
end

local doesCategoryExistInDB = function(category)
    if Categories[category] then
        return true
    end
    return false
end

local getVehicleByModel = function(model)
    for i=1,#Vehicles do
        if tostring(model) == tostring(Vehicles[i].model) then
            return Vehicles[i]
        end
    end
    return nil
end

MySQL.ready(function()
    local vehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicles")
    local categories = MySQL.Sync.fetchAll("SELECT * FROM vehicle_categories")

    if not vehicles or #vehicles == 0 then
        print("Error: No vehicles found in the database.")
        return
    end

    if not categories or #categories == 0 then
        print("Error: No categories found in the database.")
        return
    end

    for i=1,#vehicles do
        local current_vehicle = vehicles[i]
        table.insert(Vehicles,{
            model = current_vehicle.model,
            price = current_vehicle.price,
            stock = current_vehicle.stock,
            category = current_vehicle.category,
            class = current_vehicle.class
        })
    end

    for i=1,#categories do
        local current_cat = categories[i]
        Categories[current_cat.name] = current_cat.label
    end

    Wait(3000)
    TriggerClientEvent("vehicleshop:returnServerData", -1, Vehicles, Categories)
end)


ESX.RegisterServerCallback("vehicleshop:buyVehicle", function(source, cb, model)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if doesModelExistInDB(model) then
        local veh_data = getVehicleByModel(model)
        if veh_data.stock then
            if veh_data.stock > 0 then
                local money = xPlayer.getMoney()
                local bank = xPlayer.getAccount("bank").money
                local pass = false
                if money >= veh_data.price then
                    xPlayer.removeMoney(veh_data.price)
                    pass = true
                elseif bank >= veh_data.price then
                    xPlayer.removeAccountMoney("bank", veh_data.price)
                    pass = true
                end
                if not pass then
                    cb("nomoney", false)
                else
                    local stock = 0
                    for i=1,#Vehicles do
                        if Vehicles[i].model == model then
                            Vehicles[i].stock = Vehicles[i].stock - 1
                            stock = Vehicles[i].stock
                            TriggerClientEvent("vehicleshop:updateVehicleStock", -1, model, stock)
                            break
                        end
                    end
                    MySQL.update("UPDATE vehicles SET stock = @stock WHERE model = @model", {
                        ["@stock"] = stock,
                        ["@model"] = model
                    })
                    BoughtVehicles[xPlayer.identifier] = model
                    xPlayer.showNotification("You have successfully purchased this vehicle.")
                end
            else
                xPlayer.showNotification("There are no vehicles left in stock", "error", 5000)
                cb("stock", false)
            end
        end
    else
        xPlayer.showNotification("This model does not exists on server!", "error", 5000)
        cb("invalid", false)
    end
end)

RegisterServerEvent('vehicleshop:setVehicleOwned', function(props, name, _type)
    local src = source
    local plate = ESX.Shared.Trim(props.plate)
    local makeName = tostring(name)
    local vehtype = _type
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local job = xPlayer.job.name
    if BoughtVehicles[identifier] and tostring(BoughtVehicles[identifier]) == tostring(name) then
        BoughtVehicles[identifier] = nil
        if justBoughtJobVehicle[identifier] then
            justBoughtJobVehicle[identifier] = nil
            MySQL.Async.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, model, type, stored, job) VALUES (:owner, :plate, :vehicle, :model, :type, :stored, :job)',{
                ["owner"] = identifier,
                ["plate"] = plate,
                ["vehicle"] = json.encode(props),
                ["model"] = makeName,
                ["type"] = vehtype,
                ["stored"] = 0,
                ["job"] = job
            }, function(rowsChanged)
                local veh_data = getVehicleByModel(model)
                local price = veh_data.price
                TriggerEvent('betrayed_garage:boughtvehicle', plate)
                TriggerEvent('esx:sendLog', "cardealer", { color = 32768, title = "Vehicleshop Logs", message = "**"..GetPlayerName(src)..' ('..src..') - '..identifier..' bought a Job '..job..' Vehicle **\n Price: **$'..price..'**\n Model: **'..makeName..'**'})
            end)
        else
            MySQL.Async.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, model, type, stored) VALUES (:owner, :plate, :vehicle, :model, :type, :stored)',{
                ["owner"] = identifier,
                ["plate"] = plate,
                ["vehicle"] = json.encode(props),
                ["model"] = makeName,
                ["type"] = vehtype,
                ["stored"] = 0
            }, function(rowsChanged)
                local veh_data = getVehicleByModel(model)
                local price = veh_data.price
                TriggerEvent('esx:sendLog', "cardealer", { color = 32768, title = "Vehicleshop Logs", message = "**"..GetPlayerName(source)..' ('..source..') - '..xPlayer.identifier..' bought a Vehicle **\n Price: **$'..price..'**\n Model: **'..makeName..'**'})
            end)
        end
    else
        return
    end
end)

ESX.RegisterServerCallback('vehicleshop:isPlateTaken', function (source, cb, plate)
    plate = ESX.Shared.Trim(plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate OR fakeplate = @plate', {
		['@plate'] = plate
	}, function (result)
        if result and result[1] then
            cb(true)
        else
            cb(false)
        end
	end)
end)

RegisterServerEvent("vehicleshop:addNewCategory", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group ~= "superadmin" then
        return
    end
    if not data.name or not data.label then
        xPlayer.showNotification("Invalid data parsed", "error", 5000)
        return
    end
    if doesCategoryExistInDB(data.name) then
        xPlayer.showNotification("Category already exists in db", "error", 5000)
        return
    end
    MySQL.insert("INSERT INTO vehicle_categories (name, label) VALUES (@name, @label)",{
        ['@name'] = data.name,
        ['@label'] = data.label
    })
    Categories[data.name] = data.label
    TriggerClientEvent("vehicleshop:categoryAction", -1, "add", data)
end)

RegisterServerEvent("vehicleshop:adjustCategory", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group ~= "superadmin" then
        return
    end
    local category = data.category
    if not doesCategoryExistInDB(category) then
        xPlayer.showNotification("Invalid category deletion", "error", 5000)
        return
    end
    MySQL.update("UPDATE vehicle_categories SET label = @label WHERE name = @name",{
        ['@label'] = data.label,
        ['@name'] = data.name
    })
    Categories[data.name] = data.label
    TriggerClientEvent("vehicleshop:categoryAction", -1, "adjust", data)
end)

RegisterServerEvent("vehicleshop:deleteCategory", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group ~= "superadmin" then
        return
    end
    local category = data.category
    if not doesCategoryExistInDB(category) then
        xPlayer.showNotification("Invalid category deletion", "error", 5000)
        return
    end
    MySQL.query("DELETE FROM vehicle_categories WHERE name = @name",{
        ['@name'] = category
    })
    Categories[category] = nil
    local selectedCategory = nil
    for k,v in pairs(Categories) do
        selectedCategory = k
        break
    end
    for i=1,#Vehicles do
        if tostring(Vehicles[i].category) == tostring(category) then
            Vehicles[i].category = selectedCategory
        end
    end
    TriggerClientEvent("vehicleshop:categoryAction", -1, "delete", category)
    TriggerClientEvent("vehicleshop:updateVehicleswithCategory", category, selectedCategory)
end)

RegisterServerEvent("vehicleshop:addNewVehicle", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group ~= "superadmin" then
        return
    end
    if not data.model or not data.price or not data.stock or not data.category or not data.class then
        xPlayer.showNotification("Invalid data parsed", "error", 5000)
        return
    end
    if not Config.Classes[data.class] then
        xPlayer.showNotification("Invalid class parsed", "error", 5000)
        return
    end
    if not Categories[data.category] then
        xPlayer.showNotification("Invalid category parsed", "error", 5000)
        return
    end
    if data.price <= 0 then
        xPlayer.showNotification("Price must be higher than zero", "error", 5000)
        return
    end
    if doesModelExistInDB(data.model) then
        xPlayer.showNotification("This model already exists in Vehicle DB", "error", 5000)
        return
    end
    MySQL.insert("INSERT INTO vehicles (model, price, category, stock, class) VALUES (@model, @price, @category, @stock, @class)",{
        ['@model'] = data.model,
        ['@price'] = tonumber(data.price),
        ['@category'] = data.category,
        ['@stock'] = tonumber(data.stock),
        ['@class'] = data.class
    })
    table.insert(Vehicles,{
        model = data.model,
        price = tonumber(data.price),
        stock = tonumber(data.stock),
        category = data.category,
        class = data.class
    })
    TriggerClientEvent("vehicleshop:vehicleAction", -1, "add", data)
end)

RegisterServerEvent("vehicleshop:adjustVehicle", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local pass = false
    local vehicleData
    if xPlayer.group ~= "superadmin" then
        return
    end
    if not data.model then
        xPlayer.showNotification("Invalid data parsed", "error", 5000)
        return
    end
    if data.action == "price" then
        if not data.price then
            xPlayer.showNotification("Invalid data parsed", "error", 5000)
            return
        end
        data.price = tonumber(data.price)
        if data.price <= 0 then
            xPlayer.showNotification("Price has to be higher than 0", "error", 5000)
            return
        end
        for i=1,#Vehicles do
            if tostring(Vehicles[i].model) == tostring(data.model) then
                Vehicles[i].price = data.price
                pass = true
                vehicleData = Vehicles[i]
                break
            end
        end
        if pass then
            MySQL.update("UPDATE vehicles SET price = @price WHERE model = @model",{
                ['@price'] = data.price,
                ['@model'] = data.model
            })
            TriggerClientEvent("vehicleshop:vehicleAction", -1, "adjust", vehicleData)
        end
    elseif data.action == "stock" then
        if not data.stock then
            xPlayer.showNotification("Invalid data parsed", "error", 5000)
            return
        end
        if data.stock < 0 then
            xPlayer.showNotification("Stock has to be 0 or higher", "error", 5000)
            return
        end
        for i=1,#Vehicles do
            if tostring(Vehicles[i].model) == tostring(data.model) then
                Vehicles[i].stock = data.stock
                pass = true
                vehicleData = Vehicles[i]
                break
            end
        end
        if pass then
            MySQL.update("UPDATE vehicles SET stock = @stock WHERE model = @model",{
                ['@stock'] = data.stock,
                ['@model'] = data.model
            })
            TriggerClientEvent("vehicleshop:vehicleAction", -1, "adjust", vehicleData)
        end
    elseif data.action == "class" then
        if not data.class then
            xPlayer.showNotification("Invalid data parsed", "error", 5000)
            return
        end
        if not Config.Classes[data.class] then
            xPlayer.showNotification("Invalid Class chosen", "error", 5000)
            return
        end
        for i=1,#Vehicles do
            if tostring(Vehicles[i].model) == tostring(data.model) then
                Vehicles[i].class = data.class
                pass = true
                vehicleData = Vehicles[i]
                break
            end
        end
        if pass then
            MySQL.update("UPDATE vehicles SET class = @class WHERE model = @model",{
                ['@class'] = data.class,
                ['@model'] = data.model
            })
            TriggerClientEvent("vehicleshop:vehicleAction", -1, "adjust", vehicleData)
        end
    else
        xPlayer.showNotification("Invalid data parsed", "error", 5000)
        return
    end
end)

RegisterServerEvent("vehicleshop:deleteVehicle", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group ~= "superadmin" then
        return
    end
    if not data.model then
        xPlayer.showNotification("Invalid data parsed", "error", 5000)
        return
    end
    if not doesModelExistInDB(data.model) then
        xPlayer.showNotification("Invalid model parsed", "error", 5000)
        return
    end
    local pass = false
    for i=1,#Vehicles do
        if tostring(Vehicles[i].model) == tostring(data.model) then
            table.remove(Vehicles, i)
            TriggerClientEvent("vehicleshop:vehicleAction", -1, "remove", data.model)
            pass = true
            break
        end
    end
    if pass then
        MySQL.query("DELETE FROM vehicles WHERE model = @model",{
            ['@model'] = data.model
        })
    end
end)
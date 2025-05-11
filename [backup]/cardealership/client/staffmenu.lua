local dialog = function(question, input, cb)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), input, {
        title = question
    }, function (data, menu)
        menu.close()
        if cb then
            cb(data.value)
        end
    end, function(_, menu) menu.close() end)
end

local dialogInt = function(question, input, cb)
    dialog(question, input, function(result)
        if not result or result == "" or not tonumber(result) or (tonumber(result) == 0 and string.match(question:lower(), "price")) or tonumber(result) < 0 then
            ESX.ShowNotification("The number you have entered, is not valid.", "error", 3000)
            return
        end

        cb(tonumber(result))
    end)
end

local dialogMSG = function(question, input, cb)
    dialog(question, input, function(result)
        if not result or (#result < 3 and not tonumber(result)) then
            ESX.ShowNotification("The text you have typed is too short.", "error", 3000)
            return
        end

        cb(result)
    end)
end

RegisterNetEvent("vehicleshop:addNewCategory", function()
    local cat_data = {}
    dialogMSG("Category Name", "vehicleshop_new_category_name", function(name)
        cat_data.name = name
        dialogMSG("Category Label", "vehicleshop_new_category_label", function(label)
            cat_data.label = label
            TriggerServerEvent("vehicleshop:addNewCategory", cat_data)
        end)
    end)
end)

RegisterNetEvent("vehicleshop:addNewVehicle", function()
    local vehicle_data = {}
    dialogMSG("Vehicle Model", "vehicleshop_new_vehicle_model", function(model)
        vehicle_data.model = model
        dialogInt("Vehicle Price $", "vehicleshop_new_vehicle_price", function(price)
            vehicle_data.price = price
            dialogInt("Vehicle Stock", "vehicleshop_new_vehicle_stock", function(stock)
                vehicle_data.stock = stock
                TriggerServerEvent("vehicleshop:addNewVehicle", vehicle_data)
            end)
        end)
    end)
end)

RegisterNetEvent("vehicleshop:adjustPrice", function(data)
    local model = data.model
    dialogInt("Vehicle Price $", "vehicleshop_vehicle_price_"..model, function(price)
        local data = {
            action = "price",
            model = model,
            price = price
        }
        TriggerServerEvent("vehicleshop:adjustVehicle", data)
    end)
end)

RegisterNetEvent("vehicleshop:adjustStock", function(data)
    local model = data.model
    dialogInt("Vehicle Stock", "vehicleshop_vehicle_stock_"..model, function(stock)
        local data = {
            action = "stock",
            model = model,
            stock = stock
        }
        TriggerServerEvent("vehicleshop:adjustVehicle", data)
    end)
end)

RegisterNetEvent("vehicleshop:adjustClass", function(data)
    local model = data.model
    local current = data.class
    local elements = {}
    for name, label in pairs(Config.Classes) do
        local text = label
        if name == current then
            text = label.. " (Current)"
        end
        local data = {
            action = "class",
            model = model, 
            class = name
        }
        table.insert(elements,{
            title = text,
            description = "Click to adjust Vehicle class for "..SetupVehicleLabel(model),
            serverEvent = "vehicleshop:adjustVehicle",
            args = data
        })
    end
    table.insert(elements,{
        title = "Cancel",
        event = ""
    })
    lib.registerContext({
        id = "vehicle_class_change_"..model,
        title = "Change Vehicle Class",
        options = elements
    })
    lib.showContext("vehicle_class_change_"..model)
end)

RegisterNetEvent("vehicleshop:deleteVehicle", function(data)
    local model = data.model
    local elements = {}
    table.insert(elements,{ title = SetupVehicleLabel(model), description = "Are you sure you want to delete this vehicle?", disabled = true})
    table.insert(elements,{ title = "Yes", description = "This action is permanent and you can't undo this.", serverEvent = "vehicleshop:deleteVehicle", args = {model = model}})
    table.insert(elements,{ title = "No", description = "This cancels the vehicle deletion!", event = ""})
    lib.registerContext({
        id = "vehicle_deletion_"..model,
        title = "Delete Vehicle",
        options = elements,
    })
    lib.showContext("vehicle_deletion_"..model)
end)

RegisterNetEvent("vehicleshop:manageCategory", function(data)
    local cat = data.name
    local action = data.action
    if action == "label" then
        dialogMSG("Category Label", "vehicleshop_adjust_label_cat", function(label)
            local data = {
                name = cat,
                label = label
            }
            TriggerServerEvent("vehicleshop:adjustCategory", data)
        end)
    elseif action == "delete" then
        local elements = {}
        table.insert(elements,{ title = Categories[cat], description = "Are you sure you want to delete this category?", disabled = true})
        table.insert(elements,{ title = "Yes", description = "This action is permanent and you can't undo this.", serverEvent = "vehicleshop:deleteCategory", args = {category = cat}})
        table.insert(elements,{ title = "No", description = "This cancels the category deletion!", event = ""})
        lib.registerContext({
            id = "category_deletion_"..cat,
            title = "Delete Vehicle",
            options = elements,
        })
        lib.showContext("category_deletion_"..cat)
    end
end)

RegisterNetEvent("vehicleshop:manageCategory", function(data)
    local category = data.category
    local elements = {}
    if Categories[category] then
        table.insert(elements,{
            title = label.." ("..name..")",
            description = "Manage Category Options"
        })
        table.insert(elements,{
            title = "Label",
            description = "Change Category Label",
            event = "vehicleshop:manageCategory",
            args = { name = name, action = "label" }
        })
        table.insert(elements, {
            title = "Delete",
            description = "Delete this category",
            event = "vehicleshop:manageCategory",
            args = { name = name, action = "delete" }
        })
        table.insert(elements, {
            title = "Cancel",
            event = ""
        })
        lib.registerContext({
            id = "manage_category_"..name,
            title = "Manage Vehicle",
            options = elements
        })
        lib.showContext("manage_category_"..name)
    else
        ESX.ShowNotification("Invalid Category", "error", 5000)
    end
end)

RegisterNetEvent("vehicleshop:manageVehicle", function(data)
    local model = data.model
    local elements = {}
    local modelData = FindVehicleByModel(model)
    if modelData then
        table.insert(elements,{
            title = SetupVehicleLabel(model).." ("..model..")",
            description = "Manage Vehicle Options",
            disabled = true
        })
        table.insert(elements,{
            title = "Price (Current: $"..modelData.price..")",
            description = "Adjust vehicle price for "..SetupVehicleLabel(model),
            event = "vehicleshop:adjustPrice",
            args = { model = model }
        })
        table.insert(elements,{
            title = "Stock (Current: "..modelData.stock..")",
            description = "Adjust vehicle stock for "..SetupVehicleLabel(model),
            event = "vehicleshop:adjustStock",
            args = { model = model }
        })
        table.insert(elements,{
            title = "Class (Current: "..SetupClass(modelData.class)..")",
            description = "Change vehicle class for "..SetupVehicleLabel(model),
            event = "vehicleshop:adjustClass",
            args = { model = model, class = modelData.class }
        })
        table.insert(elements,{
            title = "Delete",
            description = "Delete vehicle with name "..SetupVehicleLabel(model),
            event = "vehicleshop:deleteVehicle",
            args = { model = model }
        })
        table.insert(elements,{
            title = "Cancel",
            event = ""
        })
        lib.registerContext({
            id = "manage_vehicle_"..model,
            title = "Manage Vehicle",
            options = elements
        })
        lib.showContext("manage_vehicle_"..model)
    else
        ESX.ShowNotification("Invalid Model", "error", 5000)
    end
end)

RegisterNetEvent("vehicleshop:openVehicleshopManagement", function()
    local elements = {}
    table.insert(elements, {
        title = "Vehicles",
        description = "Manage Server Vehicles",
        event = "vehicleshop:openVehiclesManagement"
    })
    table.insert(elements,{
        title = "Categories",
        description = "Manage Server Categories",
        event = "vehicleshop:openCategoriesManagement"
    })
    table.insert(elements,{
        title = "Cancel",
        event = ""
    })
    lib.registerContext({
        id = "manage_vehicleshop",
        title = "Vehicle Shop",
        options = elements
    })
    lib.showContext("manage_vehicleshop")
end)

RegisterNetEvent("vehicleshop:openCategoriesManagement", function()
    local elements = {}
    table.insert(elements, {
        title = "Add category",
        description = "Add a new vehicle category to the shop",
        event = "vehicleshop:addNewCategory"
    })
    local temp_categories = Categories
    for name, label in pairs(temp_categories) do
        table.insert(elements,{
            title = label,
            description = "Click to manage this category",
            event = "vehicleshop:manageCategory",
            args = {category = name}
        })
    end
    table.insert(elements, {
        title = "Cancel",
        event = ""
    })
    lib.registerContext({
        id = "manage_vehicleshop_categories",
        title = "Vehicle Shop Categories",
        options = elements
    })
    lib.showContext("manage_vehicleshop_categories")
end)

RegisterNetEvent("vehicleshop:printVehicles", function(data)
    local elements = {}
    local action = data.action
    local value = data.value
    if action == "category" then
        for i=1,#Vehicles do
            local veh_data = Vehicles[i]
            if tostring(veh_data.category) == tostring(value) then
                local label = SetupVehicleLabel(veh_data.model)
                table.insert(elements, {
                    title = label.." ("..veh_data.model..")",
                    description = "Click to edit vehicle",
                    event = "vehicleshop:manageVehicle",
                    args = { model = veh_data.model }
                })
            end
        end
    elseif action == "class" then
        for i=1,#Vehicles do
            local veh_data = Vehicles[i]
            if tostring(veh_data.class) == tostring(value) then
                local label = SetupVehicleLabel(veh_data.model)
                table.insert(elements, {
                    title = label.." ("..veh_data.model..")",
                    description = "Click to edit vehicle",
                    event = "vehicleshop:manageVehicle",
                    args = { model = veh_data.model }
                })
            end
        end
    end
    table.insert(elements, {
        title = "Cancel",
        event = "vehicleshop:searchVehiclePrompt",
        args = { action = action }
    })
    if #elements > 1 then
        lib.registerContext({
            id = "manage_vehicleshop_search_prompt_"..action,
            title = "Search Vehicle by "..action,
            options = elements
        })
        lib.showContext("manage_vehicleshop_search_prompt_"..action)
    end
end)

RegisterNetEvent("vehicleshop:searchVehiclePrompt", function(data)
    local action = data.action
    local elements = {}
    local text = ""
    if action == "model" then
        local veh_model
        dialogMSG("Vehicle Model", "vehicleshop_search_vehicle_model", function(model)
            veh_model = tostring(model)
            Wait(500)
            if not veh_model then
                ESX.ShowNotification("Invalid model name parsed", "error", 5000)
                TriggerEvent("vehicleshop:searchVehiclePrompt", { action = action })
                return
            end
            for i=1,#Vehicles do
                local vehicle_data = Vehicles[i]
                local makeName = GetMakeNameFromVehicleModel(vehicle_data.model):lower()
                local label = SetupVehicleLabel(vehicle_data.model)
                if vehicle_data.model == veh_model or string.match(vehicle_data.model, veh_model) or string.match(veh_model, vehicle_data.model) or veh_model == label or veh_model == makeName or string.match(veh_model, makeName) or string.match(veh_model, label) or string.match(makeName, veh_model) or string.match(label, veh_model) then
                    table.insert(elements, {
                        title = label.." ("..vehicle_data.model..")",
                        description = "Click to edit vehicle",
                        event = "vehicleshop:manageVehicle",
                        args = { model = vehicle_data.model }
                    })
                end
            end
            text = "There's not any vehicle matching your search: Model Name ("..veh_model..")"
            table.insert(elements, {
                title = "Cancel",
                event = "vehicleshop:searchVehicleList"
            })
            if #elements > 1 then
                lib.registerContext({
                    id = "manage_vehicleshop_search_prompt",
                    title = "Search Vehicle",
                    options = elements
                })
                lib.showContext("manage_vehicleshop_search_prompt")
            else
                ESX.ShowNotification(text, "error", 5000)
            end
        end)
    elseif action == "category" then
        for name, label in pairs(Categories) do
            table.insert(elements,{
                title = label.." ("..name..")",
                description = "Select to show all vehicles in this category",
                event = "vehicleshop:printVehicles",
                args = { action = "category", value = name }
            })
        end
    elseif action == "class" then
        for name, label in pairs(Config.Classes) do
            table.insert(elements,{
                title = label.." ("..name..")",
                description = "Select to show all vehicles in this class",
                event = "vehicleshop:printVehicles",
                args = { action = "class", value = name }
            })
        end
    elseif action == "stock" then
        dialogInt("Vehicle Stock", "vehicleshop_search_vehicle_stock", function(stock)
            local veh_stock = tonumber(stock)
            for i=1,#Vehicles do
                if tonumber(Vehicles[i].stock) == veh_stock then
                    table.insert(elements,{
                        title = SetupVehicleLabel(Vehicles[i].model),
                        description = "Click to edit Vehicle",
                        event = "vehicleshop:manageVehicle",
                        args = { model = Vehicles[i].model }
                    })
                end
            end
            text = "There's not any vehicle matching your search : Stock("..veh_stock..")"
            table.insert(elements, {
                title = "Cancel",
                event = "vehicleshop:searchVehicleList"
            })
            if #elements > 1 then
                lib.registerContext({
                    id = "manage_vehicleshop_search_prompt",
                    title = "Search Vehicle",
                    options = elements
                })
                lib.showContext("manage_vehicleshop_search_prompt")
            else
                ESX.ShowNotification(text, "error", 5000)
            end
        end)
    elseif action == "invalid" then
        for i=1,#Vehicles do
            local vehicle_data = Vehicles[i]
            if not IsModelInCdimage(vehicle_data.model) then
                table.insert(elements,{
                    title = vehicle_data.model.." (Invalid)",
                    description = "Click to manage this vehicle",
                    event = "vehicleshop:manageVehicle",
                    args = { model = vehicle_data.model }
                })
            end
        end
        text = "There's not any vehicle matching your search : Invalid Vehicles"
        table.insert(elements, {
            title = "Cancel",
            event = "vehicleshop:searchVehicleList"
        })
        if #elements > 1 then
            lib.registerContext({
                id = "manage_vehicleshop_search_prompt",
                title = "Search Vehicle",
                options = elements
            })
            lib.showContext("manage_vehicleshop_search_prompt")
        else
            ESX.ShowNotification(text, "error", 5000)
        end
    end
end)

RegisterNetEvent("vehicleshop:searchVehicleList", function()
    local elements = {
        { title = "Model / Label", description = "Search a vehicle by model or brand name.", event = "vehicleshop:searchVehiclePrompt", args = { action = "model" } },
        { title = "Category", description = "Search a vehicle by category name", event = "vehicleshop:searchVehiclePrompt", args = { action = "category"} },
        { title = "Class", description = "Search a vehicle by class", event = "vehicleshop:searchVehiclePrompt", args = { action = "class" } },
        { title = "Stock", description = "Search a vehicle by stock", event = "vehicleshop:searchVehiclePrompt", args = { action = "stock"} }
    }
    local count = 0
    for i=1,#Vehicles do
        if not IsModelInCdimage(Vehicles[i].model) then
            count = count + 1
        end
    end
    if count > 0 then
        table.insert(elements,{
            title = "Invalid Vehicles",
            description = "We found invalid vehicles into car dealership (Model missing or not started as resource). Click to show them",
            event = "vehicleshop:searchVehiclePrompt",
            args = { action = "invalid" }
        })
    end
    table.insert(elements,{
        title = "Cancel",
        event = "vehicleshop:openVehiclesManagement"
    })
    lib.registerContext({
        id = "manage_vehicleshop_search_list",
        title = "Search Vehicle",
        options = elements
    })
    lib.showContext("manage_vehicleshop_search_list")
end)

RegisterNetEvent("vehicleshop:openVehiclesManagement", function()
    local elements = {}
    table.insert(elements, {
        title = "Add vehicle",
        description = "Add a new vehicle to the shop",
        event = "vehicleshop:addNewVehicle"
    })
    table.insert(elements,{
        title = "Search Vehicle",
        description = "Search a vehicle by model, category, class or stock",
        event = "vehicleshop:searchVehicleList"
    })
    local temp_vehicles = Vehicles
    table.sort(temp_vehicles, function(a, b)
        return a.model < b.model
    end)
    for i=1,#temp_vehicles do
        -- if IsModelInCdimage(temp_vehicles[i].model) then
            table.insert(elements,{ 
                title = SetupVehicleLabel(temp_vehicles[i].model),
                description = "Click to manage this vehicle",
                event = "vehicleshop:manageVehicle",
                args = { model = temp_vehicles[i].model }
            })
        -- end
    end
    table.insert(elements, {
        title = "Cancel",
        event = "vehicleshop:openVehicleshopManagement"
    })
    lib.registerContext({
        id = "manage_vehicleshop_vehicles",
        title = "Vehicle Shop Vehicles",
        options = elements
    })
    lib.showContext("manage_vehicleshop_vehicles")
end)

local openCarDealerManager = function()
    TriggerEvent("vehicleshop:openVehicleshopManagement") 
end

exports("openCarDealerManager", openCarDealerManager)
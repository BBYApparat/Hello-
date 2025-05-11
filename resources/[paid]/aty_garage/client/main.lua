Blips = {}
Peds = {}
UIActive = false
Job = nil

-- ### Get players job ### --
CreateThread(function()
    while not initialized do
        Wait(1000)
    end
    
    while Job == nil do
        if Utils.Framework == "qb-core" then
            Job = Utils.FrameworkObject.Functions.GetPlayerData()?.job?.name
        else
            Job = Utils.FrameworkObject.GetPlayerData()?.job?.name
        end

        if Job ~= nil then
            break
        end

        Wait(1000)
    end
end)

-- ### Create blips for garages ### -- 
CreateThread(function()
    debugPrint("Creating blips for garages")
    
    local garages = Config.Garages

    for k, v in pairs(garages) do
        if v.blip.show then
            local blip = AddBlipForCoord(v.pedCoords)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blip.size)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blip)
            table.insert(Blips, blip)
        end
    end

    debugPrint("Blips created")
    debugPrint("Creating peds for garages")
    
    local hash = GetHashKey("s_m_y_valet_01")
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    for k, v in pairs(garages) do
        local ped = CreatePed(4, hash, v.pedCoords.x, v.pedCoords.y, v.pedCoords.z - 1.0, v.pedCoords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        table.insert(Peds, ped)
    end

    debugPrint("Peds created")
end)

--- ### Closest garage loop ### --
CreateThread(function()
    local sleep = 500

    while true do
        Wait(sleep)

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local closestGarage = GetClosestGarage(pedCoords)
        local inRange = false
        local inVehicle = nil

        if closestGarage and not UIActive then
            local distance = 1000.0
            local inVehicle = IsPedInAnyVehicle(ped, false)
            local coords = inVehicle and closestGarage.vehicleCoords or vector3(closestGarage.pedCoords.x, closestGarage.pedCoords.y, closestGarage.pedCoords.z)

            distance = #(pedCoords - coords)

            if inVehicle and distance < 25.0 then
                inRange = true
            elseif distance <= 5.0 then
                inRange = true
            elseif distance > 5.0 then
                inRange = false
            end

            if inRange then
                sleep = 0

                if inVehicle then
                    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                end

                if distance < 2.0 then
                    if inVehicle then
                        DrawText3D(coords.x, coords.y, coords.z + 1.0, "Press [E] to store your vehicle")

                        if IsControlJustReleased(0, 38) then
                            StoreVehicle(closestGarage, GetVehiclePedIsIn(ped, false))
                        end
                    elseif not inVehicle then
                        DrawText3D(coords.x, coords.y, coords.z, "Press [E] to access the garage")

                        if IsControlJustReleased(0, 38) then
                            OpenGarage(closestGarage)
                        end
                    end
                end
            else
                sleep = 500
            end
        end
    end
end)

function StoreVehicle(garage, vehicle)
    local isVehicleOwned = TriggerCallback("isVehicleOwned", GetVehicleNumberPlateText(vehicle))

    if isVehicleOwned then
        local vehicleProps = GetVehicleProperties(vehicle)
        local bodyDamage = GetVehicleBodyHealth(vehicle)
        local engineDamage = GetVehicleEngineHealth(vehicle)
        local fuel = Config.GetFuelExport(vehicle)
        local garage = garage.garage

        local resp = TriggerCallback("storeVehicle", {vehicleProps, bodyDamage, engineDamage, fuel, garage})

        if resp then
            local pedsInVehicle = {}

            for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
                if not IsVehicleSeatFree(vehicle, i) then
                    table.insert(pedsInVehicle, GetPedInVehicleSeat(vehicle, i))
                end
            end

            for k, v in pairs(pedsInVehicle) do
                TaskLeaveVehicle(v, vehicle, 0)
            end

            while #pedsInVehicle > 0 do
                Wait(0)
                for k, v in pairs(pedsInVehicle) do
                    if not IsPedInVehicle(v, vehicle, false) then
                        table.remove(pedsInVehicle, k)
                    end
                end
            end

            local opacity = 255
            local reducer = 2

            while opacity >= 0 do
                if reducer < 1 then
                    reducer = 1
                end

                opacity = opacity - reducer
                
                if opacity < 0 then
                    opacity = 0
                end

                SetEntityAlpha(vehicle, opacity, 1)
                Wait(1)

                if opacity == 0 then
                    break
                end
            end

            Config.Notify('Vehicle has been stored')
            SetEntityAlpha(vehicle, 0, false) -- Ensure the vehicle is fully transparent at the end
            DeleteVehicle(vehicle)
        else
            Config.Notify('Failed to store vehicle')
        end
    else
        Config.Notify('You do not own this vehicle')
    end
end

function OpenGarage(garage)
    local garageData = TriggerCallback("getGarageData", garage)

    if garageData and next(garageData) then
        local garageName = garage.label

        for k, vehicle in pairs(garageData) do
            local vehProps = vehicle?.mods or vehicle.vehicle
            local displaytext = string.gsub(GetDisplayNameFromVehicleModel(vehProps.model), "%s+", ""):lower()
            
            vehicle.brandName = GetLabelText(displaytext)
            vehicle.modelName = ""
            vehicle.health = vehProps.bodyHealth
            vehicle.state = vehicle?.stored and vehicle.stored or vehicle.state
            vehicle.mileage = Config.MileAgeFunction(vehicle.plate)

            for k, v in pairs(VehModels) do
                if string.gsub(k, "%s+", ""):lower() == displaytext then
                    vehicle.modelName = v
                end
            end
        end

        local data = {
            garage = garageName,
            garageType = garage.garage,
            vehicles = garageData
        }

        UIActive = true
        SetNuiFocus(1, 1)
        SendNUIMessage({
            action = "openGarage",
            garage = data
        })
    else
        debugPrint("There are no vehicles in this garage")
    end
end

function GetClosestGarage(coords)
    local closestGarage = nil
    local distance = 1000.0

    for k, v in pairs(Config.Garages) do
        local dist = #(coords - vector3(v.pedCoords.x, v.pedCoords.y, v.pedCoords.z))

        if dist < distance and (Job == v.job or v.job == "all") then
            distance = dist
            closestGarage = v
        end
    end

    return closestGarage
end

function GetVehModels(self)
    return VehModels[GetDisplayNameFromVehicleModel(GetEntityModel(self))] or "None"
end
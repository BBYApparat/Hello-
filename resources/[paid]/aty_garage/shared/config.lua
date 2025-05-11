Config = {
    OldESX = false,
    
    locale = "en",
    Debug = true,

    UseSharedGarages = true, -- If true, players will be able take out their vehicles from every garage

    VehicleDataName = "owned_vehicles", -- This is automatically set based on the framework you are using
    VehicleIdentifier = "owner", -- This is automatically set based on the framework you are using
    VehicleGarageName = "parking", -- This is automatically set based on the framework you are using

    ImpoundPrice = 5000, -- Price to get the vehicle out of the impound

    Warp = true, -- If true, the player will warp into the vehicle when spawned
    VisuallyDamageCars = true, -- If true, the vehicle will be visually damaged when spawned
    SaveDamage = { -- If true, the damage of the vehicle will be saved
        Windows = true,
        Doors = true,
        Tyres = true,
    },

    SetFuelExport = function(vehicle, fuel)
        local fuel = type(fuel) == "number" and fuel or tonumber(fuel)

        if GetResourceState("LegacyFuel") == "started" then 
            exports["LegacyFuel"]:SetFuel(vehicle, fuel)
        elseif GetResourceState("ox_fuel") == "starting" then
            Entity(vehicle).state.fuel = fuel
        else
            SetVehicleFuelLevel(vehicle, fuel)
        end
    end,

    GetFuelExport = function(vehicle)
        if GetResourceState("LegacyFuel") == "started" then 
            return exports["LegacyFuel"]:GetFuel(vehicle)
        elseif GetResourceState("ox_fuel") == "starting" then
            return Entity(vehicle).state.fuel
        else
            return GetVehicleFuelLevel(vehicle)
        end
    end,

    MileAgeFunction = function(plate)
        return 100 -- Your function to get the mileage of the vehicle
    end,

    Notify = function(message)
        TriggerEvent("QBCore:Notify", message)
    end,

    Garages = {
        ["pillboxgarage"] = {
            label = "Pillbox Hospital",
            garage = "pillboxgarage",
            pedCoords = vector4(213.8914, -808.5035, 31.0149, 158.3446),
            vehicleCoords = vector3(214.6786, -790.8074, 30.8426),
            heading = 0.0,
            radius = 5.0,
            job = "police",
            blip = {
                show = true,
                sprite = 357,
                color = 3,
                size = 0.8,
                label = "Garage",
            },
            spawnCoords = {
                vector4(219.1859, -791.3597, 30.7713, 69.3137),
                vector4(220.1740, -788.9644, 30.7766, 68.5961),
                vector4(221.1771, -786.4949, 30.7771, 69.5429),
                vector4(228.2616, -789.1275, 30.6759, 249.2231),
                vector4(227.0665, -794.6635, 30.6466, 248.7322),
            }
        },
        ["motelgarage"] = {
            label = "Motel Garage",
            garage = "motelgarage",
            pedCoords = vector4(275.2575, -345.5514, 45.1734, 339.7914),
            vehicleCoords = vector3(272.9397, -334.8697, 44.9199),
            heading = 0.0,
            radius = 5.0,
            job = "all",
            blip = {
                show = true,
                sprite = 357,
                color = 3,
                size = 0.8,
                label = "Garage",
            },
            spawnCoords = {
                vector4(276.0407, -339.7231, 44.9199, 68.5029),
                vector4(277.4628, -336.1428, 44.9199, 68.5029),
                vector4(278.8322, -333.0151, 44.9199, 68.5029),
                vector4(279.9323, -329.7714, 44.9199, 68.5029),
                vector4(281.4118, -327.1048, 44.9199, 68.5029),
            }
        },
        ["casinogarage"] = {
            label = "Casino Garage",
            garage = "casinogarage",
            pedCoords = vector4(886.7740, 0.0724, 78.7650, 146.9156),
            vehicleCoords = vector3(881.9100, -6.5380, 78.7641),
            heading = 0.0,
            radius = 5.0,
            job = "all",
            blip = {
                show = true,
                sprite = 357,
                color = 3,
                size = 0.8,
                label = "Garage",
            },
            spawnCoords = {
                vector4(877.4516, 3.9555, 78.7641, 146.3100),
                vector4(874.6347, 5.7846, 78.7641, 146.3103),
                vector4(871.9400, 7.6075, 78.7641, 146.3100),
                vector4(894.1552, -5.8961, 78.7641, 146.3100),
                vector4(897.8660, -8.3788, 78.7641, 146.3100),
            }
        },
        ["sapcounsel"] = {
            label = "San Andreas Parking",
            garage = "sapcounsel",
            pedCoords = vector4(-331.0177, -780.7586, 33.9645, 37.6650),
            vehicleCoords = vector3(-336.6863, -774.6515, 33.9673),
            heading = 0.0,
            radius = 5.0,
            job = "all",
            blip = {
                show = true,
                sprite = 357,
                color = 3,
                size = 0.8,
                label = "Garage",
            },
            spawnCoords = {
                vector4(-341.5609, -767.2601, 33.9695, 87.7799),
                vector4(-337.2890, -751.1777, 33.9685, 358.6099),
                vector4(-334.3765, -751.0726, 33.9685, 358.6099),
                vector4(-331.6621, -750.8774, 33.9685, 358.6099),
                vector4(-328.9863, -750.3669, 33.9685, 358.6099),
            }
        },
        ["spanishave"] = {
            label = "Spanish Ave Parking",
            garage = "spanishave",
            pedCoords = vector4(-1159.5237, -739.3665, 19.8899, 219.6015),
            vehicleCoords = vector3(-1152.6439, -747.3824, 19.3848),
            heading = 0.0,
            radius = 5.0,
            job = "all",
            blip = {
                show = true,
                sprite = 357,
                color = 3,
                size = 0.8,
                label = "Garage",
            },
            spawnCoords = {
                vector4(-1146.7148, -745.9486, 19.6110, 109.8661),
                vector4(-1144.3370, -749.1892, 19.4510, 109.8661),
                vector4(-1141.8031, -752.1013, 19.3109, 109.8661),
                vector4(-1139.3784, -754.8450, 19.1799, 109.8661),
                vector4(-1136.6248, -757.9227, 19.0187, 109.8661),
            }
        },
        ["impound"] = {
            label = "Impounds",
            garage = "impound",
            pedCoords = vector4(408.9973, -1622.8748, 29.2919, 230.3999),
            vehicleCoords = vector3(402.2783, -1632.4142, 29.2919),
            heading = 0.0,
            radius = 5.0,
            job = "all",
            blip = {
                show = true,
                sprite = 357,
                color = 1,
                size = 0.8,
                label = "Impounds",
            },
            spawnCoords = {
                vector4(396.8939, -1643.6415, 29.2919, 320.6169),
                vector4(399.4290, -1645.7704, 29.2919, 320.6169),
                vector4(401.7447, -1648.0758, 29.2924, 320.6169),
                vector4(404.1126, -1649.9866, 29.2936, 320.6169),
                vector4(406.1588, -1651.7144, 29.2924, 320.6169),
                vector4(408.5187, -1653.7551, 29.2919, 320.6169),
            }
        },
    },
}

CreateThread(function()
    while GetResourceState("qb-core") == "starting" or GetResourceState("es_extended") == "starting" do  
        Wait(100)

        if timeOut >= 10 then
            print("QBCore is not started, please make sure QBCore is started before starting this resource.")
            break
        end

        timeOut = timeOut + 1
    end

    if GetResourceState("qb-core") == "started" then
        Config.VehicleDataName = "player_vehicles"
        Config.VehicleIdentifier = "citizenid"
        Config.VehicleGarageName = "garage"
    elseif GetResourceState("es_extended") == "started" then
        Config.VehicleDataName = "owned_vehicles"
        Config.VehicleIdentifier = "owner"
        Config.VehicleGarageName = "parking"
    end
end)
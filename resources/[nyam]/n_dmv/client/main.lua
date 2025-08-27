-- DMV School 
-- Tech Development -  /tHAbhd94vS
local ESX = exports.es_extended:getSharedObject()
local SpawnedPeds, Blips = {}, {}

postNUI = function(data)
    SendNUIMessage(data)
end

OpenDMV = function()
    ESX.TriggerServerCallback('n_dmv:getData', function(licenses, money, bank) 
        postNUI({
            type = "SET_CONFIG",
            config = Config
        })
        postNUI({
            type = "SET_MONEY",
            cash = money,
            bank = bank
        })
        postNUI({
            type = "OPEN",
            licenses = licenses,
            license = Config.License
        })
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(500)
    end)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
end)

RegisterNUICallback('removeMoney', function(data)
    local account = data.account
    local amount = tonumber(data.amount)
    TriggerServerEvent('n_dmv:removeMoney', account, amount)
end)

RegisterNetEvent('n_dmv:updateLicense', function(licenses)
    postNUI({
        type = "UPDATE_LICENSE",
        licenses = licenses,
    })
    -- ESX.TriggerServerCallback('n_dmv:getData', function(licenses) 
    --     postNUI({
    --         type = "UPDATE_LICENSE",
    --         licenses = licenses,
    --     })
    -- end)
end)

RegisterNUICallback('theoryOk', function(data)
    local license = data.license
    TriggerServerEvent("n_dmv:givelicense", license)
end)

RegisterNUICallback('practiceOk', function(data)
    local license = data.license
    TriggerServerEvent("n_dmv:givelicense", license)
end)

local step = 0
local maxSpeed = nil
local sleep = 1000
local error = 0

SetUpMarker = function()
    step = step + 1
    local randomNumber = math.random(1, #Config.PracticeCoords)
    local coords = Config.PracticeCoords[randomNumber]
    coords = coords[step]
    if coords == nil then
        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        postNUI({
            type = "DISPLAY_RESULTS_AFTER_DRIVE",
            speedLimitReached = error,
        })
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(500)
        step = 0
        sleep = 1000
        return
    end
    maxSpeed = coords.speedLimit or nil
    coords = coords.coordinate
    SetNewWaypoint(coords.x, coords.y)
    sleep = 0
    CreateThread(function()
        while true do
            Wait(sleep)
            DrawMarker(Config.MarkerSettings.type, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, Config.MarkerSettings.size, Config.MarkerSettings.color, 100, Config.MarkerSettings.bump, true, 2, Config.MarkerSettings.rotate, false, false, false)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil then
                local speed = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
                if maxSpeed ~= nil and speed > maxSpeed then
                    sleep = 1000
                    error = error + 1
                    exports.n_snippets:Notify(Lang("error.speed_limit", {current = error, max = Config.MaxErrors, limit = maxSpeed}), "error", 10000, "Driving School")
                    Wait(15000)
                else
                    sleep = 0
                end
            end
            local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, GetEntityCoords(PlayerPedId()), true)
            if distance < 1.5 then
                SetUpMarker()
                break 
            end
        end
    end)
end

RegisterNUICallback('startPractice', function(data)
    local license = data.license
    for k,v in pairs(Config.License) do 
        if v.id == license then
            local vehicle = v.vehicle
            ESX.Game.SpawnVehicle(vehicle.model, vehicle.coords, vehicle.heading, function(veh) 
                exports.SimpleCarlock:GiveKey(ESX.Math.Trim(vehicle.plate))
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
                Wait(2500)
                exports.n_snippets:Notify("Do no forget, speed limit is 50", "info", 5000, "Driving School")
                for i = 1, 5 do
                    Wait(30000)
                    exports.n_snippets:Notify("Do no forget, speed limit is 50", "info", 5000, "Driving School")
                end
            end)
            break
        end
    end
    SetUpMarker()
end)

if Config.Interact == 'esx' then
    local sleep2 = 1000
    CreateThread(function()
        while true do
            Wait(sleep2)
            for k,v in pairs(Config.DMVSchool) do 
                DrawMarker(Config.MarkerSettings.type, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, Config.MarkerSettings.size, Config.MarkerSettings.color, 100, Config.MarkerSettings.bump, true, 2, Config.MarkerSettings.rotate, false, false, false)

                local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(PlayerPedId()), true)
                if distance < 5.5 then
                    sleep2 = 0
                    ESX.ShowHelpNotification(Config.Lang[Config.Language]["open_dmv"])
                    if IsControlJustReleased(0, 38) then
                        OpenDMV()
                    end
                else
                    sleep2 = 1000
                end
            end
        end
    end)
elseif Config.Interact == 'ox' then
    CreateThread(function()
        for k, coords in pairs(Config.DMVSchool) do
            -- exports.ox_target:addBoxZone({
            --     coords = vector3(v.x, v.y, v.z),
            --     size = vector3(2, 2, 2),
            --     distance = 1.85,
            --         options = {
            --         {
            --             name = 'dmv_school',
            --             icon = 'fas fa-car',
            --             label = Lang("targets.dmv_school"),
            --             onSelect = function() 
            --                 OpenDMV()
            --             end,
            --         }
            --     }
            -- })
            exports.n_snippets:SpawnPed({ped = Config.Peds[math.random(1, #Config.Peds)], options = {coords.x, coords.y, coords.z-1, coords.h, false, 0}}, function(entity)
                local _entity = entity
                SpawnedPeds[#SpawnedPeds+1] = _entity
                -- local _entity = entity
                TaskStartScenarioInPlace(_entity, "WORLD_HUMAN_AA_COFFEE", 0, true)
                FreezeEntityPosition(_entity, true)
                SetEntityInvincible(_entity, true)
                SetBlockingOfNonTemporaryEvents(_entity, true)
    
                exports.n_snippets:addLocalEntity({
                    entity = _entity,
                    distance = 1.1,
                    options = {
                        label = Lang("targets.dmv_school"),
                        icon = "fas fa-car",
                        distance = 1.1,
                        onSelect = function()
                            OpenDMV()
                        end,
                    }
                })

                exports.n_snippets:CreateBlip({
                    coords = vector3(coords.x, coords.y, coords.z),
                    label = "Driving School",
                    sprite = 545,
                    color = 18,
                    size = 0.8
                }, function(blip)
                    Blips[#Blips+1] = blip
                end)
            end)
        end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    for i = 1, #SpawnedPeds do DeleteEntity(SpawnedPeds[i]) end
    for ii = 1, #Blips do RemoveBlip(Blips[ii]) end
end)
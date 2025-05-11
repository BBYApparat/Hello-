local ESX = exports.es_extended:getSharedObject()
local inChips = false
local currentShop, currentData
local pedSpawned = false
local listen = false
local ShopPed = {}
local NewZones = {}

-- Functions
local function createBlips()
    if pedSpawned then return end
    
    for store in pairs(Config.Locations) do
        if Config.Locations[store]["showblip"] then
            local StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"]["x"], Config.Locations[store]["coords"]["y"], Config.Locations[store]["coords"]["z"])
            SetBlipSprite(StoreBlip, Config.Locations[store]["blipsprite"])
            SetBlipScale(StoreBlip, Config.Locations[store]["blipscale"])
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.Locations[store]["blipcolor"])
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end

local function openShop(shop, data)
    exports.ox_inventory:openInventory('shop', { type = shop, id = 1 })
end

local function listenForControl()
    if listen then return end
    
    CreateThread(function()
        listen = true
        while listen do
            if IsControlJustPressed(0, 38) then -- E
                TriggerServerEvent('n_shops:server:SetShopList')
                print("E key pressed...")
                if inChips then
                    exports["qb-core"]:KeyPressed()
                    TriggerServerEvent("n_shops:server:sellChips")
                    print("Selling casino chips...")
                else
                    exports["qb-core"]:KeyPressed()
                    openShop(currentShop, currentData)
                end
                listen = false
                break
            end
            Wait(0)
        end
    end)
end

local ShopPed = {}
local pedSpawned = false

local function createPeds()
    if pedSpawned then return end

    for k, v in pairs(Config.Locations) do
        local current = type(v["ped"]) == "number" and v["ped"] or joaat(v["ped"])

        RequestModel(current)
        local loadStartTime = GetGameTimer()

        while not HasModelLoaded(current) do
            Wait(100)
            if GetGameTimer() - loadStartTime > 5000 then
                print("Failed to load model for ped at store: " .. v.label)
                break
            end
        end

        if HasModelLoaded(current) then
            TriggerEvent('nyam_snippets:blockEntity', 'ped', current)
            ShopPed[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
            TaskStartScenarioInPlace(ShopPed[k], v["scenario"], 0, true)
            FreezeEntityPosition(ShopPed[k], true)
            SetEntityInvincible(ShopPed[k], true)
            SetBlockingOfNonTemporaryEvents(ShopPed[k], true)

            -- Add ox_target interaction
            if Config.UseTarget then
                local options = {
                    {
                        name = 'shop_' .. k,
                        label = v["targetLabel"],
                        icon = v["targetIcon"],
                        distance = 2.0,
                        onSelect = function()
                            if v.item then
                                local hasItem = exports.ox_inventory:Search('count', v.item) > 0
                                if not hasItem then
                                    lib.notify({
                                        title = 'Error',
                                        description = 'You need the required item',
                                        type = 'error'
                                    })
                                    return
                                end
                            end

                            -- Check job if required
                            if v.requiredJob then
                                local playerJob = lib.callback.await('ox_target:getPlayerJob', false)
                                if not playerJob or playerJob.name ~= v.requiredJob then
                                    lib.notify({
                                        title = 'Error',
                                        description = 'You do not have the required job',
                                        type = 'error'
                                    })
                                    return
                                end
                            end

                            -- Check gang if required
                            if v.requiredGang then
                                local playerGang = lib.callback.await('ox_target:getPlayerGang', false)
                                if not playerGang or playerGang.name ~= v.requiredGang then
                                    lib.notify({
                                        title = 'Error',
                                        description = 'You do not have the required gang',
                                        type = 'error'
                                    })
                                    return
                                end
                            end

                            openShop(k, Config.Locations[k])
                        end,
                        canInteract = function(entity, distance)
                            return distance <= 2.0
                        end
                    }
                }

                exports.ox_target:addLocalEntity(ShopPed[k], options)
            end

            print("Ped spawned for store: " .. v.label .. " at coordinates: " .. v["coords"].x .. ", " .. v["coords"].y .. ", " .. v["coords"].z)
        else
            print("Ped model failed to load for store: " .. v.label)
        end

        Wait(500)
    end

    -- Casino Chips Ped
    local current = type(Config.SellCasinoChips.ped) == 'number' and Config.SellCasinoChips.ped or joaat(Config.SellCasinoChips.ped)

    RequestModel(current)
    while not HasModelLoaded(current) do
        Wait(0)
    end

    TriggerEvent('nyam_snippets:blockEntity', 'ped', current)
    ShopPed["casino"] = CreatePed(0, current, Config.SellCasinoChips.coords.x, Config.SellCasinoChips.coords.y, Config.SellCasinoChips.coords.z-1, Config.SellCasinoChips.coords.w, false, false)
    FreezeEntityPosition(ShopPed["casino"], true)
    SetEntityInvincible(ShopPed["casino"], true)
    SetBlockingOfNonTemporaryEvents(ShopPed["casino"], true)

    -- Add ox_target for casino chips ped
    if Config.UseTarget then
        exports.ox_target:addLocalEntity(ShopPed["casino"], {
            {
                name = 'sell_casino_chips',
                label = 'Sell Chips',
                icon = 'fa-solid fa-coins',
                distance = 2.0,
                onSelect = function()
                    TriggerServerEvent("n_shops:server:sellChips")
                end,
                canInteract = function(entity, distance)
                    return distance <= 2.0
                end
            }
        })
    end

    pedSpawned = true
    print("All peds have been spawned.")
end



local function deletePeds()
    if not pedSpawned then return end

    for _, v in pairs(ShopPed) do
        DeletePed(v)
    end
    pedSpawned = false
end

-- Events
RegisterNetEvent("n_shops:client:UpdateShop", function(shop, itemData, amount)
    TriggerServerEvent("n_shops:server:UpdateShopItems", shop, itemData, amount)
end)

RegisterNetEvent("n_shops:client:SetShopItems", function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent("n_shops:client:RestockShopItems", function(shop, amount)
    if not Config.Locations[shop].products then return end
    for k in pairs(Config.Locations[shop].products) do
        Config.Locations[shop].products[k].amount = Config.Locations[shop]["products"][k].amount + amount
    end
end)

RegisterNetEvent('esx:playerLoaded', function(userData)
    print("Player loaded, setting up shops...")
    PlayerData = userData
    createBlips()
    createPeds()
    TriggerServerEvent('n_shops:server:SetShopList')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerData = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    createBlips()
    Wait(5000)
    createPeds()
    TriggerServerEvent('n_shops:server:SetShopList')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    deletePeds()
end)

-- Threads
if not Config.UseTarget then
    CreateThread(function()
        for shop in pairs(Config.Locations) do
            NewZones[#NewZones+1] = CircleZone:Create(vector3(Config.Locations[shop]["coords"]["x"], Config.Locations[shop]["coords"]["y"], Config.Locations[shop]["coords"]["z"]), Config.Locations[shop]["radius"], {
                useZ = true,
                debugPoly = false,
                name = shop,
            })
        end

        local combo = ComboZone:Create(NewZones, {name = "RandomZOneName", debugPoly = false})
        combo:onPlayerInOut(function(isPointInside, _, zone)
            if isPointInside then
                currentShop = zone.name
                TriggerServerEvent('n_shops:server:SetShopList')
                currentData = Config.Locations[zone.name]
                exports["qb-core"]:DrawText(Lang:t("info.open_shop"))
                listenForControl()
            else
                exports["qb-core"]:HideText()
                listen = false
            end
        end)

        local sellChips = CircleZone:Create(vector3(Config.SellCasinoChips.coords["x"], Config.SellCasinoChips.coords["y"], Config.SellCasinoChips.coords["z"]), Config.SellCasinoChips.radius, {useZ = true})
        sellChips:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inChips = true
                exports["qb-core"]:DrawText(Lang:t("info.sell_chips"))
            else
                inChips = false
                exports["qb-core"]:HideText()
            end
        end)
    end)
end

CreateThread(function()
    for k1, v in pairs(Config.Locations) do
        if v.requiredJob and next(v.requiredJob) then
            for k in pairs(v.requiredJob) do
                Config.Locations[k1].requiredJob[k] = 0
            end
        end
        if v.requiredGang and next(v.requiredGang) then
            for k in pairs(v.requiredGang) do
                Config.Locations[k1].requiredGang[k] = 0
            end
        end
    end
    print("Job and gang requirements set.")
end)

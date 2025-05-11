ESX = ESX or nil
PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.SharedObjectName, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('ak47_clothing:notify')
AddEventHandler('ak47_clothing:notify', function(msg)
    ESX.ShowNotification(msg)
end)

RegisterNetEvent('ak47_clothing:openbossaction')
AddEventHandler('ak47_clothing:openbossaction', function(job)
    inBossMenu = false
    TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
        menu.close()
    end)
end)

function onOpenSkinMenu()
    -- here you can place trigger to hide your hud
end

function onCloseSkinMenu()
    -- here you can place trigger to show your hud
end

local cutScenePlayed = false
function playCutScene()
    if not cutScenePlayed then
        cutScenePlayed = true
        
        --place your cutscene here
    end
end

Citizen.CreateThread(function()
    for k, v in pairs (Config.Stores) do
        if v.blip.enable then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipColour(blip, v.blip.color)
            SetBlipScale (blip, v.blip.size)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
        end
    end
    for i, v in pairs(Config.Salon) do
        if v.blip.enable then
            local blip = AddBlipForCoord(v.boss_action)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipColour(blip, v.blip.color)
            SetBlipScale (blip, v.blip.size)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.name)
            EndTextCommandSetBlipName(blip)
        end
    end
    for i, v in pairs(Config.Tattoos) do
        if v.blip.enable then
            local blip = AddBlipForCoord(v.boss_action)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipColour(blip, v.blip.color)
            SetBlipScale (blip, v.blip.size)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k, v in pairs(Config.Stores) do
            local dist = #(pos - v.coords)
            if dist < 30 then
                if not creatingCharacter then
                    DrawMarker(2, Config.Stores[k].coords.x, Config.Stores[k].coords.y, Config.Stores[k].coords.z + 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 0, 0, 200, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 5 then
                        DrawText3Ds(Config.Stores[k].coords.x, Config.Stores[k].coords.y, Config.Stores[k].coords.z + 1.25, '~g~E~w~ - To Access')
                        if IsControlJustPressed(0, 38) then -- E
                            ESX.TriggerServerCallback('ak47_clothing:canBuyClothes', function(cb)
                                if cb then
                                    ESX.TriggerServerCallback('ak47_clothing:getOutfits', function(result)
                                        menu = {}
                                        for j, k in pairs(v.container) do
                                            table.insert(menu, {menu = k.type, label = k.title, selected = j == 1, true, false})
                                        end
                                        if Config.StoreOutfitOption then
                                            table.insert(menu, {menu = "myOutfits", label = "My Outfits", selected = false, outfits = result})
                                        end
                                        openMenu(menu)
                                    end)
                                end
                            end, v.price)
                        end
                    end
                end
                inRange = true
            end
        end
        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(0)
    end
end)

exports('openOutfit', function()
    ESX.TriggerServerCallback('ak47_clothing:getOutfits', function(result)
        openMenu({
            {menu = "myOutfits", label = "My Outfits", selected = true, outfits = result},
        })
    end)
end)

RegisterNetEvent('ak47_clothing:openOutfit', function()
    ESX.TriggerServerCallback('ak47_clothing:getOutfits', function(result)
        openMenu({
            {menu = "myOutfits", label = "My Outfits", selected = true, outfits = result},
        })
    end)
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k, v in pairs(Config.DressingRooms) do
            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist < 30 then
                if not creatingCharacter then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 0, 0, 200, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 5 then
                        DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, '~g~E~w~ - To Change')
                        if IsControlJustPressed(0, 38) and dist < 2.0 then
                            if v.jobs.all or v.jobs[PlayerData.job.name] then
                                ESX.TriggerServerCallback('ak47_clothing:getOutfits', function(result)
                                    SetEntityHeading(ped, v.coords.w)
                                    openMenu({
                                        {menu = "myOutfits", label = "My Outfits", selected = true, outfits = result},
                                    })
                                end)
                            else
                                ESX.ShowNotification('~r~Your job is not allowed to use this!')
                            end
                        end
                    end
                end
                inRange = true
            end
        end
        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if creatingCharacter then
            InvalidateIdleCam()
            SetPedCanPlayAmbientIdles(PlayerPedId(), true, false)
        else
            Citizen.Wait(1000)
        end
    end
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function closeMenu()
    SendNUIMessage({action = "close"})
    disableCam()
end

function OpenAccessoryMenu()
    local elements = {
        {label = 'Glasses', value = 'glasses'},
        {label = 'Torso', value = 'torso'},
        {label = 'Pants', value = 'pants'},
        {label = 'Shoes', value = 'shoes'},
        {label = 'Mask', value = 'mask'},
        {label = 'Hat', value = 'helmet'},
        {label = 'Bag', value = 'bag'},
        {label = 'Ears', value = 'ear'},
        {label = 'Chain', value = 'chain'},
    {label = 'Vest', value = 'vest'}}

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'action_menu', {
        title = 'Accessories',
        align = 'right',
        elements = elements
        }, function(data, menu)
        TriggerEvent('ak47_clothing:'..data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

if Config.UseAccessoryMenu then
    RegisterCommand('accessoires', function()
        --if ESX.IsPlayerDown() or ESX.IsPlayerDead() then return end
        OpenAccessoryMenu()
    end)
    RegisterKeyMapping('accessoires', 'Accessories Menu', 'keyboard', Config.AccessoryMenuKey)
end

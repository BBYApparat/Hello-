if Config.UsePawnShop then
    local menuOpen = false
    local wasOpen = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local letSleep = true
            for i, v in pairs(Config.Shops) do
                local distance = #(vector3(v.pos.x, v.pos.y, v.pos.z) - coords)
                if distance < 3.5 then
                    letSleep = false
                    DrawTxt3D(vector3(v.pos.x, v.pos.y, v.pos.z + 1.0), i)
                    if distance < 2.0 and not menuOpen then
                        ESX.ShowHelpNotification(_U('etosell'))
                        if IsControlJustReleased(0, 38) then
                            OpenDrugShop(i, v.items, vector3(v.pos.x, v.pos.y, v.pos.z))
                        end
                    end
                end
            end
            if letSleep then
                Citizen.Wait(1000)
            end
        end
    end)

    function OpenDrugShop(id, items, coord)
        ESX.UI.Menu.CloseAll()
        local elements = {}
        menuOpen = true
        Citizen.CreateThread(function()
            while menuOpen do
                Citizen.Wait(0)
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                if GetDistanceBetweenCoords(coords, coord, true) > 2.0 then
                    menuOpen = false
                    ESX.UI.Menu.CloseAll()
                end
            end
        end)
        for k, v in pairs(ESX.GetPlayerData().inventory) do
            if v.name and items[v.name] and v.count > 0 then
                local price = items[v.name].price
                table.insert(elements, {
                    label = ('%s - <span style="color:red;">%s</span>'):format(items[v.name].label, _U('shop_item', ESX.Math.GroupDigits(price), v.count)),
                    name = v.name,
                    price = price,
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawn_shop', {
            title = id,
            align = 'top-left',
            elements = elements
            }, function(data, menu)
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pawn_shop_sell', {
                title = _U('how_much')}, function(data2, menu2)
                local amount = tonumber(data2.value)
                TriggerServerEvent('ak47_prospecting:sell', data.current.name, amount, data.current.price)
                menu.close()
                menu2.close()
                Citizen.Wait(1000)
                OpenDrugShop(id, items)
            end, function(data2, menu2)
                menu.close()
                menu2.close()
                OpenDrugShop(id, items)
            end)
        end, function(data, menu)
            menu.close()
            menuOpen = false
        end)
    end

    function CreateBlipCircle(coords, text, color, sprite, radius, size)
        local blip = AddBlipForRadius(coords, radius)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, color)
        SetBlipAlpha (blip, 128)
        blip = AddBlipForCoord(coords)
        SetBlipHighDetail(blip, true)
        SetBlipSprite (blip, sprite)
        SetBlipScale (blip, size)
        SetBlipColour (blip, color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blip)
    end

    Citizen.CreateThread(function()
        for i, v in pairs(Config.Shops) do
        	if v.blip.enable then
    		    local blip = AddBlipForCoord(v.pos)
    		    SetBlipHighDetail(blip, true)
    		    SetBlipSprite (blip, v.blip.sprite)
    		    SetBlipScale (blip, v.blip.size)
    		    SetBlipColour (blip, v.blip.color)
    		    SetBlipAsShortRange(blip, true)
    		    BeginTextCommandSetBlipName("STRING")
    		    AddTextComponentString(v.blip.name)
    		    EndTextCommandSetBlipName(blip)
    		end
        end
    end)

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            if menuOpen then
                ESX.UI.Menu.CloseAll()
            end
        end
    end)
end

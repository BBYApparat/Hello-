if not Framework.QBox() then return end

function Framework.Notification(src, _msg, _type, _time)
    exports.qbx_core:Notify(src, _msg, _type, _time)
end

function Framework.CustomNotify(src, header, msg, icon, colour, length)
    TriggerClientEvent('rep-tablet:client:CustomNotification', src,
        header or "NO HEADER",
        msg or "NO MSG",
        icon or "fas fa-phone-square",
        colour or "#e84118",
        length or 7500
    )
end

function Framework.getIdentifier(src)
    local player = exports.qbx_core:GetPlayer(src)
    return player.PlayerData.citizenid
end

function Framework.AddItem(src, _item, _amount, _metadata, _slot)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:AddItem(src, _item, _amount, _metadata, _slot)
    elseif Config.Inventory == 'qs' then
        return exports['qs-inventory']:AddItem(src, _item, _amount, _slot, _metadata)
    end
end

function Framework.RemoveItem(src, _item, _amount, _slot)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:RemoveItem(src, _item, _amount, nil, _slot)
    elseif Config.Inventory == 'qs' then
        return exports['qs-inventory']:RemoveItem(src, _item, _amount, _slot)
    end
end

function Framework.getPlayerRep(src)
    local player = exports.qbx_core:GetPlayer(src)
    return player.PlayerData.metadata['weed_rep']
end

function Framework.setPlayerRep(src, amount)
    local player = exports.qbx_core:GetPlayer(src)
    player.Functions.SetMetaData('weed_rep', amount)
end

function Framework.earnCorner(src, _money)
    local player = exports.qbx_core:GetPlayer(src)
    player.Functions.AddMoney('cash', _money, 'cornersell')
    local chance = math.random(0 , 100)
    if chance < 10 then -- transfer bands
        local _random = math.random(10, 20)
        local _rate = math.random(450, 550)
        if Framework.RemoveItem(src, 'bands', _random) then
            player.Functions.AddMoney('cash', _random * _rate, 'transfer bands')
        end
    end
    if chance > 90 then -- transfer rolls
        local _random = math.random(30, 60)
        local _rate = math.random(45, 100)
        if Framework.RemoveItem(src, 'rolls', _random) then
            player.Functions.AddMoney('cash', _random * _rate, 'transfer rolls')
        end
    end
end

function Framework.earnTaco(src, _money)
    local player = exports.qbx_core:GetPlayer(src)
    player.Functions.AddMoney('cash', _money, 'taco')
end

lib.callback.register('rep-weed:callback:checkOwner', function(source, plate)
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?',{plate}, function(result)
        if result[1] then
            return true
        else
            return false
        end
    end)
end)

lib.callback.register('rep-weed:callback:GetCurrentCop', function()
   return exports.qbx_core:GetDutyCountType('leo')
end)

if Config.Inventory == 'ox' then
    exports(Config.Items["wateringcan"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            TriggerClientEvent('rep-weed:client:fillWater', inventory.id, i)
            return
        end
    end)

    exports(Config.Items["femaleseed"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
           local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            TriggerClientEvent('rep-weed:client:plantWeed', inventory.id, i)
            return
        end
    end)

    exports(Config.Items["driedbud"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
           local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            TriggerClientEvent('rep-weed:client:rollJoint', inventory.id, i)
            return
        end
    end)

    exports(Config.Items["weedbaggie"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
           local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            TriggerClientEvent('rep-weed:client:rollJoint', inventory.id, i)
            return
        end
    end)

    exports(Config.Items["weedpackage"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
           local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            TriggerClientEvent('rep-weed:client:prepareBaggies', inventory.id, i)
            return
        end
    end)

    exports(Config.Items["joint"], function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            local i = exports.ox_inventory:GetSlot(inventory.id, slot)
            if Framework.RemoveItem(inventory.id, i.name, 1, slot) then
                TriggerClientEvent('rep-weed:client:smokeWeed', inventory.id, i)
                local metadata = {}
                metadata.n = i.metadata.n or 0
                metadata.p = i.metadata.p or 0
                metadata.k = i.metadata.k or 0
                local r = math.random(1, 100)
                if r > 70 then
                    if r > 80 then
                        Framework.AddItem(source, Config.Items['maleseed'], math.random(1, 3))
                    end
                    if r < 90 then
                        Framework.AddItem(source, Config.Items['femaleseed'], math.random(1, 3), metadata)
                    end
                end
            end
            return
        end
    end)
elseif Config.Inventory == 'qs' then
    -- item: Name of the item you want to create
    -- cb: Item creation logic identical to your framework's
    exports['qs-inventory']:CreateUsableItem(Config.Items["wateringcan"],  function(source, item)
        TriggerClientEvent('rep-weed:client:fillWater', source, item)
    end)

    exports['qs-inventory']:CreateUsableItem(Config.Items["femaleseed"], function(source, item)
        TriggerClientEvent('rep-weed:client:plantWeed', source, item)
    end)

    exports['qs-inventory']:CreateUsableItem(Config.Items["driedbud"], function(source, item)
        TriggerClientEvent('rep-weed:client:rollJoint', source, item)
    end)

    exports['qs-inventory']:CreateUsableItem(Config.Items["weedbaggie"], function(source, item)
        TriggerClientEvent('rep-weed:client:rollJoint', source, item)
    end)

    exports['qs-inventory']:CreateUsableItem(Config.Items["weedpackage"], function(source, item)
        TriggerClientEvent('rep-weed:client:prepareBaggies', source, item)
    end)

    exports['qs-inventory']:CreateUsableItem(Config.Items["joint"], function(source, item)
        if Framework.RemoveItem(source, item.name, 1, item.slot) then
            TriggerClientEvent('rep-weed:client:smokeWeed', source, item)
            local info = {}
            info.n = item.info.n or 0
            info.p = item.info.p or 0
            info.k = item.info.k or 0
            local r = math.random(1, 100)
            if r > 70 then
                if r > 80 then
                    Framework.AddItem(source, Config.Items['maleseed'], math.random(1, 3))
                end
                if r < 90 then
                    Framework.AddItem(source, Config.Items['femaleseed'], math.random(1, 3), info)
                end
            end
        end
    end)
end
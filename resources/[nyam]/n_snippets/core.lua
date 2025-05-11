function Lang(key, data)
    local translation = Translations[Config.Options.lang]
    local parts = {}
    for part in string.gmatch(key, "[^.]+") do
        table.insert(parts, part)
    end
    
    for _, part in ipairs(parts) do
        translation = translation[part]
        if not translation then
            return "Translation not found for key: " .. key
        end
    end
    
    if data then
        for placeholder, value in pairs(data) do
            translation = string.gsub(translation, "{" .. placeholder .. "}", value)
        end
    end
    
    return translation
end

if IsDuplicityVersion() then
    Core = {}
    Framework = nil

    if Config.Options.framework == "qb" then
        Framework = exports["qb-core"]:GetCoreObject()
    elseif Config.Options.framework == "esx" then
        Framework = exports["es_extended"]:getSharedObject()
    elseif Config.Options.framework == "custom" then
        Framework = Custom.GetFramework()
    end
    
    function Core.Notify(source, text, type, time, title)
        if not type then type = "primary" end
        if not time then time = 5000 end
        if Config.Options.notify == "default" then
            if Config.Options.framework == "qb" then
                Framework.Functions.Notify(source, text, type, time)
            elseif Config.Options.framework == "esx" then
                TriggerClientEvent("esx:showNotification", source, text, type, time)
            else
                TriggerClientEvent("ox_lib:notify", source, {title = Lang("general.notify_title"), description = text, duration = time, type = type})
            end
        elseif Config.Options.notify == "qb" then
            Framework.Functions.Notify(source, text, type, time)
        elseif Config.Options.notify == "esx" then
            TriggerClientEvent("esx:showNotification", source, text, type, time)
        elseif Config.Options.notify == "ox" then
            TriggerClientEvent("ox_lib:notify", source, {title = Lang("general.notify_title"), description = text, duration = time, type = type})
        elseif Config.Options.notify == "ps-ui" then
            TriggerClientEvent("ps-ui:Notify", source, text, type, time)
        elseif Config.Options.notify == "okok" then
            TriggerClientEvent("okokNotify:Alert", source, Lang("general.notify_title"), text, time, type, true)
        elseif Config.Options.notify == "wasabi" then
            TriggerClientEvent('wasabi_notify:notify', source, title, text, time, type, true)
        elseif Config.Options.notify == "custom" then
            Custom.Notify(source, Lang("general.notify_title"), text, type, time)
        end
    end

    function Core.GetPlayer(source)
        local _source = source
        if Config.Options.framework == "qb" then
            return Framework.Functions.GetPlayer(_source)
        elseif Config.Options.framework == "esx" then
            return Framework.GetPlayerFromId(_source)
        elseif Config.Options.framework == "custom" then
            return Custom.GetPlayer(_source)
        end
    end

    function Core.GetPlayerJob(source)
        local _source = source
        if Config.Options.framework == "qb" then
            return Framework.Functions.GetPlayer(_source).PlayerData.job
        elseif Config.Options.framework == "esx" then
            return Framework.GetPlayerFromId(_source).job
        elseif Config.Options.framework == "custom" then
            return Custom.GetPlayerJob(_source)
        end
    end

    function Core.GetTotalDuty(job)
        local _job = job
        if Config.Options.framework == "qb" then
            return Framework.Functions.GetDutyCount(_job)
        elseif Config.Options.framework == "esx" then
            -- return Framework.GetPlayerFromId(_source).job
        elseif Config.Options.framework == "custom" then
            -- return Custom.GetPlayerJob(_source)
        end
    end

    function Core.AddItem(source, item, amount, slot, metadata)
        local _source, _item, _amount, _slot, _metadata = source, item, amount, slot, metadata
        local xPlayer = Core.GetPlayer(_source)
        local identifier = xPlayer.identifier or xPlayer.PlayerData.identifier

        if Config.Options.inventory == "qb" or Config.Options.inventory == "qs" or Config.Options.inventory == "lj" then
            -- TriggerClientEvent('inventory:client:ItemBox',_source, Framework.Shared.Items[_item], "add")
            return xPlayer.Functions.AddItem(_item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "ox" then
            return exports.ox_inventory:AddItem(_source, _item, _amount, _metadata, _slot)
        elseif Config.Options.inventory == "mf" then
            return exports["mf-inventory"]:addInventoryItem(identifier, _item, _amount, _source, 100.0, _slot, _metadata)
        elseif Config.Options.inventory == "core" then
            return exports["core_inventory"]:addItem("content-" ..  identifier:gsub(":", ""), _item, _amount, _slot, "content")
        elseif Config.Options.inventory == "custom" then
            return Custom.AddItem(_source, _item, _amount, _slot, _metadata)
        end
    end
    
    function Core.RemoveItem(source, item, amount, slot, metadata)
        local _source, _item, _amount, _slot, _metadata = source, item, amount, slot, metadata
        local xPlayer = Core.GetPlayer(_source)
        local identifier = xPlayer.identifier or xPlayer.PlayerData.identifier

        if Config.Options.inventory == "qb" or Config.Options.inventory == "qs" or Config.Options.inventory == "lj" then
            -- TriggerClientEvent('inventory:client:ItemBox', _source, Framework.Shared.Items[_item], "remove")
            return xPlayer.Functions.AddItem(_item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "ox" then
            return exports.ox_inventory:RemoveItem(_source, _item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "mf" then
            return exports["mf-inventory"]:removeInventoryItem(identifier, name,_item, _amount , _source, _slot, _metadata)
        elseif Config.Options.inventory == "core" then
            return exports["core_inventory"]:removeItemExact("content-" ..  identifier:gsub(":", ""), _item, _amount)
        elseif Config.Options.inventory == "custom" then
            return Custom.RemoveItem(_source, _item, _amount, _slot, _metadata)
        end
    end

    function Core.HasItem(source, item, amount, slot, metadata)
        local _source, _item, _amount, _slot, _metadata = source, item, amount, slot, metadata
        local xPlayer = Core.GetPlayer(_source)
        local identifier = xPlayer.identifier or xPlayer.PlayerData.identifier

        if Config.Options.inventory == "qb" or Config.Options.inventory == "qs" or Config.Options.inventory == "lj" then
            return xPlayer.Functions.AddItem(_item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "ox" then
            return exports.ox_inventory:Search(_source, "count", _item) >= amount
        elseif Config.Options.inventory == "mf" then
            return exports["mf-inventory"]:getInventoryItem(identifier, _item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "core" then
            return exports["core_inventory"]:getItems("content-" ..  identifier:gsub(":", ""), item)
        elseif Config.Options.inventory == "custom" then
            return Custom.HasItem(_source, _item, _amount, _slot, _metadata)
        end
    end

    function Core.GetItem(source, item, slot, metadata)
        local _source, _item, _slot, _metadata = source, item, slot, metadata
        local xPlayer = Core.GetPlayer(_source)
        local identifier = xPlayer.identifier or xPlayer.PlayerData.identifier

        if Config.Options.inventory == "qb" or Config.Options.inventory == "qs" or Config.Options.inventory == "lj" then
            if slot then
                return xPlayer.Functions.GetItemBySlot(_slot)
            else
                return xPlayer.Functions.GetItemsByName(_item)
            end
        elseif Config.Options.inventory == "ox" then
            return exports.ox_inventory:GetItem(_source, item, _metadata, false)
        elseif Config.Options.inventory == "mf" then
            return exports["mf-inventory"]:getInventoryItem(identifier, _item, _amount, _slot, _metadata)
        elseif Config.Options.inventory == "core" then
            return exports["core_inventory"]:getItem("content-" ..  identifier:gsub(":", ""), _item)
        elseif Config.Options.inventory == "custom" then
            return Custom.GetItem(_source, _item, _amount, _slot, _metadata)
        end
    end
    
    function Core.AddMoney(source, moneyType, amount, reason)
        local _source, _moneyType, _amount, _reason = source, moneyType, amount, reason
        local xPlayer = Core.GetPlayer(_source)

        if Config.Options.framework == "esx" then
            return xPlayer.addAccountMoney(_moneyType, _amount, _reason)
        elseif Config.Options.framework == "qb" then
            return xPlayer.Functions.AddMoney(_moneyType, _amount, _reason)
        end
        
        return nil
    end

    function Core.RemoveMoney(source, moneyType, amount, reason)
        local _source, _moneyType, _amount, _reason = source, moneyType, amount, reason
        local xPlayer = Core.GetPlayer(_source)
        if Config.Options.framework == "esx" then
            return xPlayer.removeAccountMoney(_moneyType, _amount, _reason)
        elseif Config.Options.framework == "qb" then
            return xPlayer.Functions.RemoveMoney(_moneyType, _amount, _reason)
        end 
        
        return nil
    end

    function Core.GetMoney(source, moneyType)
        local _source, _moneyType = source, moneyType
        local xPlayer = Core.GetPlayer(_source)
        
        if Config.Options.framework == "esx" then
            return xPlayer.getAccount(_moneyType).money
        elseif Config.Options.framework == "qb" then
            return xPlayer.PlayerData.money[_moneyType]
        end 
    end
else
    Core = {}
    Core.Target = {}
    Framework = nil

    if Config.Options.framework == "qb" then
        Framework = exports["qb-core"]:GetCoreObject()
    elseif Config.Options.framework == "esx" then
        Framework = exports["es_extended"]:getSharedObject()
    elseif Config.Options.framework == "custom" then
        Framework = Custom.GetFramework()
    end

    function Core.Notify(text, type, time, title)
        if not type then type = "primary" end
        if not time then time = 5000 end
        if Config.Options.notify == "default" then
            if Config.Options.framework == "qb" then
                Framework.Functions.Notify(text, type, time)
            elseif Config.Options.framework == "esx" then
                Framework.ShowNotification(text, type, time)
            else
                lib.notify({title = Lang("general.notify_title"), description = text, duration = time, type = type})
            end
        elseif Config.Options.notify == "qb" then
            Framework.Functions.Notify(text, type, time)
        elseif Config.Options.notify == "esx" then
            exports["esx_notify"]:Notify(type, time, text)
        elseif Config.Options.notify == "ox" then
            lib.notify({title = Lang("general.notify_title"), description = text, duration = time, type = type})
        elseif Config.Options.notify == "ps-ui" then
            exports["ps-ui"]:Notify(text, type, time)
        elseif Config.Options.notify == "okok" then
            exports["okokNotify"]:Alert(Lang("general.notify_title"), text, time, type, true)
        elseif Config.Options.notify == "wasabi" then
            exports.wasabi_notify:notify(title, text, time, type, true)
        elseif Config.Options.notify == "custom" then
            Custom.Notify(Lang("general.notify_title"), text, type, time)
        end
    end
    
    function Core.GetPlayerData()
        if Config.Options.framework == "qb" then
            return Framework.Functions.GetPlayerData()
        elseif Config.Options.framework == "esx" then
            return Framework.GetPlayerData()
        elseif Config.Options.inventory == "custom" then
            return Custom.GetPlayerData()
        end
    end

    function Core.HasItem(item)
        if Config.Options.inventory == "qb" or Config.Options.inventory == "qs" or Config.Options.inventory == "lj" then
            return Framework.Functions.HasItem(item)
        elseif Config.Options.inventory == "ox" then
            return exports.ox_inventory:Search("count", item) >= 1
        elseif Config.Options.inventory == "mf" then
            return print("mf inventory doesnt support client-side check")
        elseif Config.Options.inventory == "core" then
            return print("core inventory doesnt support client-side check")
        elseif Config.Options.inventory == "custom" then
            return Custom.HasItem(item)
        end
    end
    
    function Core.Target.AddPosition(data)
        if Config.Options.target == "qb" then
            return exports["qb-target"]:AddBoxZone(data.id, data.coords, data.size, data.size, {
                name = data.id,
                heading = data.heading,
                debugPoly = data.debug,
                minZ = data.minZ,
                maxZ = data.maxZ,
            }, {
                options = data.options,
                distance = data.distance
            })
        elseif Config.Options.target == "q" then
            
        elseif Config.Options.target == "ox" then
            return exports.ox_target:addBoxZone({coords = data.coords, size = vector3(data.size, data.size, data.size), ratation = data.heading, debug = data.debug, options = data.options})
        end
    end

    function Core.Target.addLocalEntity(data) 

        if Config.Options.target == "ox" then
            exports.ox_target:addLocalEntity(data.entity, data.options)
        end

    end

    function Core.Target.Remove(id)
        if Config.Options.target == "qb" then
            exports["qb-target"]:RemoveZone(id)
        elseif Config.Options.target == "q" then
            
        elseif Config.Options.target == "ox" then
            exports.ox_target:removeZone(id)
        end
    end

    function Core.Target.Disable(bool)
        if Config.Options.target == "ox" then
            exports.ox_target:disableTargeting(bool)
        elseif Config.Options.target == "qb" then
            exports["qb-target"]:DisableTarget(bool)
        end
    end

    function Core.Dispatch(store)
        if Config.Options.dispatch == "ps" then
            exports["ps-dispatch"]:StoreRobbery(store.camId)
        elseif Config.Options.dispatch == "custom" then
            Custom.Dispatch(store)
        end
    end
    
    function Core.GetPeds(ignoreList)
        local pedPool = GetGamePool('CPed')
        local peds = {}
        ignoreList = ignoreList or {}
        for i = 1, #pedPool, 1 do
            local found = false
            for j = 1, #ignoreList, 1 do
                if ignoreList[j] == pedPool[i] then
                    found = true
                end
            end
            if not found then
                peds[#peds + 1] = pedPool[i]
            end
        end
        return peds
    end

    function Core.GetClosestPed(coords, ignoreList)
        local ped = PlayerPedId()
        if coords then
            coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
        else
            coords = GetEntityCoords(ped)
        end
        ignoreList = ignoreList or {}
        local peds = Core.GetPeds(ignoreList)
        local closestDistance = -1
        local closestPed = -1
        for i = 1, #peds, 1 do
            local pedCoords = GetEntityCoords(peds[i])
            local distance = #(pedCoords - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPed = peds[i]
                closestDistance = distance
            end
        end
        return closestPed, closestDistance
    end

    function Core.MakeEntityFaceEntity(entity1, entity2)
        local p1 = GetEntityCoords(entity1, true)
        local p2 = GetEntityCoords(entity2, true)
    
        local dx = p2.x - p1.x
        local dy = p2.y - p1.y
    
        local heading = GetHeadingFromVector_2d(dx, dy)
        SetEntityHeading(entity1, heading)
    
        return true
    end

    function Core.RequestModel(modelHash, cb)
        modelHash = (type(modelHash) == "number" and modelHash or joaat(modelHash))
    
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
    
            while not HasModelLoaded(modelHash) do
                Wait(0)
            end
        end
    
        if cb ~= nil then
            cb()
        end
    end
    
    function Core.RequestAnim(animDict, cb)
        if not HasAnimDictLoaded(animDict) then
            RequestAnimDict(animDict)
    
            while not HasAnimDictLoaded(animDict) do
                Wait(0)
            end
        end
    
        if cb ~= nil then
            cb()
        end
    end

    function Core.SpawnEntity(data, cb)
        local model = type(data.object) == "number" and data.object or joaat(data.object)
        local vector = type(data.coords) == "vector3" and data.coords or vec(data.coords.x, data.coords.y, data.coords.z)
        
        CreateThread(function()
            Core.RequestModel(model)
            local obj = CreateObject(model, vector.xyz, data.networked, false, true)
            cb(obj)

            return obj
        end)
    end

    function Core.SpawnPed(data, cb)
        local model = Core.RequestModel(data.ped)
        CreateThread(function()
            local ped = CreatePed(5, data.ped, table.unpack(data.options))

            SetModelAsNoLongerNeeded(data.ped)
            
            if cb then cb(ped) end

            return ped
        end)
    end

    function Core.CreateBlip(data, cb)
        local CoreBlip = AddBlipForCoord(data.coords)
        SetBlipSprite(CoreBlip, data.sprite)
        SetBlipScale(CoreBlip, data.size)
        SetBlipDisplay(CoreBlip, 4)
        SetBlipColour(CoreBlip, data.color)
        SetBlipAsShortRange(CoreBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(data.label)
        EndTextCommandSetBlipName(CoreBlip)
        if cb then cb(CoreBlip) end
        return CoreBlip
    end
end
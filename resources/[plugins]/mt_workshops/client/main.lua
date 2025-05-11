lib.locale()
zone = {}
insideZone = {}

RegisterNetEvent('mt_workshops:client:notify', notify)

startScript = function()
    if Config.inventory == 'ox_inventory' then exports.ox_inventory:displayMetadata({ plate = locale('metadata_plate') }) end

    for k, v in pairs(Config.labelEntry) do
        AddTextEntry(v.hash, v.label)
    end

    for k, v in pairs(Config.stations) do
        if v.blip?.enabled then
            local blipCoords = (v.type == 'zone' and v.zone) and v.zone?.points[1] or (v.zone == 'prop' and v.prop) and vec3(v.prop.coords.x, v.prop.coords.y, v.prop.coords.z)
            createBlip(blipCoords, v.blip.sprite, v.blip.display, v.blip.scale, v.blip.color, v.label)
        end

        if v.type == 'zone' and v.zone then
            lib.zones.poly({
                points = v.zone.points,
                thickness = v.zone.thickness,
                debug = Config.debug,
                onEnter = function()
                    if (not v.job) or (getPlayerJob() == v.job) then
                        showTextUI(locale('textui_inside_station', v.label), "tools")
                    end
                end,
                onExit = function()
                    if (not v.job) or (getPlayerJob() == v.job) then
                        hideTextUI()
                    end
                end,
                inside = function()
                    if IsControlJustPressed(0, 38) then
                        if (not v.job) or (getPlayerJob() == v.job) then
                            openStation(k)
                        end
                    end
                end
            })
        elseif v.type == 'prop' and v.prop then
            createProp(v.prop.model, v.prop.coords, v.prop.coords.w)
            lib.zones.sphere({
                coords = vec3(v.prop.coords.x, v.prop.coords.y, v.prop.coords.z),
                radius = v.prop.radius,
                debug = Config.debug,
                onEnter = function()
                    if (not v.job) or (getPlayerJob() == v.job) then showTextUI(locale('textui_inside_station', v.label), "tools") end
                end,
                onExit = function()
                    if (not v.job) or (getPlayerJob() == v.job) then hideTextUI() end
                end,
                inside = function()
                    if IsControlJustPressed(0, 38) then openStation(k) end
                end
            })
        else
            print(string.format("~r~The station (%s) %s is with the wrong type or mission prop or zone field!!", k, v.label))
        end
    end

    for k, v in pairs(Config.workshops) do
        if v.enabled then
            if Config.framework == 'esx' then TriggerServerEvent('mt_workshops:server:registerESXSociety', v.job, v.label) end
            
            if v.blip?.enabled then
                createBlip(v.blip.coords, v.blip.sprite, v.blip.display, v.blip.scale, v.blip.color, v.label)
            end

            zone[k] = lib.zones.poly({
                points = v.zone.points,
                thickness = v.zone.thickness,
                debug = Config.debug,
                onEnter = function()
                    onZoneEnter(v.job)
                end,
                onExit = function()
                    onZoneExit(v.job) 
                end,
            })

            if v.managements then
                for mk, mv in pairs(v.managements) do
                    createSphereZoneTarget(mv.coords, mv.radius, {
                        {
                            debug = Config.debug,
                            label = locale("target_management"),
                            icon = "fas fa-user-tie",
                            onSelect = managementMenu,
                            action = managementMenu,
                            canInteract = function()
                                return (getPlayerJob() == v.job and isPlayerJobBoss())
                            end
                        }
                    }, 2.5, string.format("management_%s_%s", k, mk))
                end
            end

            if v.stashes then
                for sk, sv in pairs(v.stashes) do
                    createSphereZoneTarget(sv.coords, sv.radius, {
                        {
                            debug = Config.debug,
                            label = locale("target_stash"),
                            icon = "fas fa-cube",
                            onSelect = function()
                                openStash(("stash_%s_%s"):format(k, sk), locale("stash_label"), sv.slots, sv.weight)
                            end,
                            action = function()
                                openStash(("stash_%s_%s"):format(k, sk), locale("stash_label"), sv.slots, sv.weight)
                            end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end
                        }
                    }, 2.5, string.format("stash_%s_%s", k, sk))
                end
            end

            if v.shops then
                for sk, sv in pairs(v.shops) do
                    local options = {}
                    for ck, cv in pairs(sv.categories) do
                        options[#options + 1] = {
                            debug = Config.debug,
                            label = locale("target_shop", Config.shops[cv].categoryLabel),
                            icon = "fas fa-shopping-cart",
                            onSelect = function()
                                openShop(("shop_%s_%s"):format(k, sk), locale("shop_label", Config.shops[cv].categoryLabel), Config.shops[cv].items)
                            end,
                            action = function()
                                openShop(("shop_%s_%s"):format(k, sk), locale("shop_label", Config.shops[cv].categoryLabel), Config.shops[cv].items)
                            end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end
                        }
                    end
                    createSphereZoneTarget(sv.coords, sv.radius, options, 2.5, string.format("shop_%s_%s", k, sk))
                end
            end

            if v.crafts then
                for ck, cv in pairs(v.crafts) do
                    local options = {}
                    for cck, ccv in pairs(cv.categories) do
                        options[#options + 1] = {
                            debug = Config.debug,
                            label = locale("target_craft", Config.crafts[ccv].categoryLabel),
                            icon = "fas fa-tools",
                            onSelect = function()
                                openCraft(("craft_%s_%s"):format(k, ck), locale("craft_label", Config.crafts[ccv].categoryLabel), Config.crafts[ccv].items)
                            end,
                            action = function()
                                openCraft(("craft_%s_%s"):format(k, ck), locale("craft_label", Config.crafts[ccv].categoryLabel), Config.crafts[ccv].items)
                            end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end
                        }
                    end
                    createSphereZoneTarget(cv.coords, cv.radius, options, 2.5, string.format("craft_%s_%s", k, ck))
                end
            end

            if v.garage then
                for a, b in pairs(v.garage) do
                    local options = {
                        {
                            distance = 2.5,
                            label = locale('target_garage'),
                            icon = 'fas fa-car',
                            onSelect = function() openGarage(v.job, a) end,
                            action = function() openGarage(v.job, a) end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end,
                        }
                    }   
                    loadModel('prop_park_ticket_01')
                    local garageProp = CreateObject(GetHashKey('prop_park_ticket_01'), b.coords.x, b.coords.y, b.coords.z, false, false, false)
                    SetEntityHeading(garageProp, b.coords.w)
                    FreezeEntityPosition(garageProp, true)
                    createEntityTarget(garageProp, options, 2.5, 'garage_shop_'..v.job..'_'..a)
                end
            end

            if v.registers then
                for a, b in pairs(v.registers) do
                    local options = {
                        {
                            distance = 2.5,
                            label = locale('target_register'),
                            icon = 'fas fa-cash-register',
                            onSelect = function() openRegister(v.job, a) end,
                            action = function() openRegister(v.job, a) end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end,
                        }
                    }
                    createSphereZoneTarget(b.coords, b.radius, options, 2.5, 'register_target_'..k..'_'..a)

                    if b.prop then
                        createProp(b.prop, b.coords, b.propHeading or 0.0)
                    end
                end
            end

            if v.mission then
                for a, b in pairs(v.mission) do
                    local options = {
                        {
                            distance = 2.5,
                            label = locale('target_ask_mission'),
                            icon = 'fas fa-phone',
                            onSelect = function() askMission(v.job, a) end,
                            action = function() askMission(v.job, a) end,
                            canInteract = function()
                                return (getPlayerJob() == v.job)
                            end,
                        }
                    }
                    createSphereZoneTarget(b.coords, b.radius, options, 2.5, 'mission_target_'..k..'_'..a)

                    if b.prop then
                        createProp(b.prop, b.coords, b.propHeading or 0.0)
                    end
                end
            end
        end
    end
end

CreateThread(startScript)

RegisterNuiCallback('hideFrame', function(data, cb)
    ShowNUI(data.name, false)
    cb(true)
end)

ShowNUI = function(action, shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendNUIMessage({ action = action, data = shouldShow })
end
  
SendNUI = function(action, data)
    data.locale = json.decode(LoadResourceFile(cache.resource, ('locales/%s.json'):format(Config.locale or 'en')))
    SendNUIMessage({ action = action, data = data })
end

RegisterNuiCallback('craftItem', function(data, cb)
    local canCraft = lib.callback.await('mt_workshops:server:canCraftItem', false, data.ingredients)
    if not canCraft then notify(locale('notify_error_missing_items'), 'error') return end
    ShowNUI('setVisibleCraftingMenu', false)
    if progressBar(locale('progress_craft'), data.duration, { car = true, walk = true }, { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 6 }, {}) then
        lib.callback.await('mt_workshops:server:craftItem', false, data.name, data.count, data.ingredients)
    end
    openCraft(data.id, data.craftLabel, data.oldItems)
    cb(true)
end)

RegisterNetEvent('mt_workshops:client:checkVehicleClass', function()
    if not IsPedInAnyVehicle(cache.ped, false) then notify(locale('notify_error_no_vehicle_in'), 'error') return end
    notify(locale('notify_check_class', getVehicleClass(GetVehiclePedIsIn(cache.ped, false))))
end)
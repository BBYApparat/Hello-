Plants = {}
MyStrains = {}
onDuty = false
_entites = {}
function talkNPC()
    local _model, _pos = lib.callback.await('rep-weed:callback:bossNPC', false)
    bossNpc = exports['rep-talkNPC']:CreateNPC({
        npc = _model,
        coords = _pos,
        name = Lang.bossNpc.name,
        animScenario = Lang.bossNpc.animScenario,
        tag = Lang.bossNpc.tag,
        color = Lang.bossNpc.color,
        startMSG = Lang.bossNpc.startMSG
    }, {
        [1] = {
            label = Lang.bossNpc.button1[1],
            shouldClose = true,
            action = function()
                TriggerEvent('rep-weed:client:signIn')
            end,
            canInteract = function()
                return not onDuty and Config.TacoShop.status
            end,
        },
        [2] = {
            label = Lang.bossNpc.button2[1],
            shouldClose = true,
            action = function()
                TriggerEvent('rep-weed:client:signOut')
            end,
            canInteract = function()
                return onDuty and Config.TacoShop.status
            end,
        },
        [3] = {
            label = Lang.bossNpc.button3[1],
            shouldClose = true,
            action = function()
                TriggerEvent('rep-weed:client:checkStrain')
            end,
        },
        [4] = {
            label = Lang.bossNpc.button4[1],
            shouldClose = true,
            action = function()
            end
        }
    })
end

function targetNPC()
    local _model, _pos = lib.callback.await('rep-weed:callback:bossNPC', false)
    lib.requestModel(_model, 500)
    bossNpc = CreatePed(0, _model, _pos.x, _pos.y, _pos.z, _pos.w, false, true)
    SetPedFleeAttributes(bossNpc, 0, false)
    SetPedDiesWhenInjured(bossNpc, false)
    TaskStartScenarioInPlace(bossNpc, Lang.bossNpc.animScenario, 0, true)
    SetPedKeepTask(bossNpc, true)
    SetBlockingOfNonTemporaryEvents(bossNpc, true)
    SetEntityInvincible(bossNpc, true)
    FreezeEntityPosition(bossNpc, true)
    if Config.Target == 'ox_target' then
        exports.ox_target:addLocalEntity(bossNpc,
        {
            {
                onSelect = function(entity)
                    TriggerEvent('rep-weed:client:signIn')
                end,
                icon = Lang.target.signin.icon,
                label = Lang.target.signin.label,
                distance = 1.5,
                canInteract = function()
                    return not onDuty and Config.TacoShop.status
                end,
            },
            {
                onSelect = function(entity)
                    TriggerEvent('rep-weed:client:signOut')
                end,
                icon = Lang.target.signout.icon,
                label = Lang.target.signout.label,
                distance = 1.5,
                canInteract = function()
                    return onDuty and Config.TacoShop.status
                end,
            },
            {
                onSelect = function(entity)
                    TriggerEvent('rep-weed:client:checkStrain')
                end,
                icon = Lang.target.checkstrain.icon,
                label = Lang.target.checkstrain.label,
                distance = 1.5,
            },
        })
    else
        exports[Config.Target]:AddTargetEntity(bossNpc, {
            options =  {
                {
                    action = function()
                        TriggerEvent('rep-weed:client:signIn')
                    end,
                    icon = Lang.target.signin.icon,
                    label = Lang.target.signin.label,
                    canInteract = function()
                        return not onDuty and Config.TacoShop.status
                    end,
                },
                {
                    action = function()
                        TriggerEvent('rep-weed:client:signOut')
                    end,
                    icon = Lang.target.signout.icon,
                    label = Lang.target.signout.label,
                    canInteract = function()
                        return onDuty and Config.TacoShop.status
                    end,
                },
                {
                    action = function()
                        TriggerEvent('rep-weed:client:checkStrain')
                    end,
                    icon = Lang.target.checkstrain.icon,
                    label = Lang.target.checkstrain.label,
                },
            },
            distance = 1.5
        })
    end
end

function initWeed()
    if Config.Target == 'ox_target' then
        exports.ox_target:addGlobalVehicle({
            {
                icon = Lang.target.start_cornerselling.icon,
                label = Lang.target.start_cornerselling.label,
                distance = 1.5,
                onSelect = function(data)
                    startConnerSelling(data.entity)
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return not cornerselling and not IsPedInAnyVehicle(cache.ped, false) and hasItem(Config.Items['weedbaggie'], 1) and Config.Cornerselling.status
                end,
            },
            {
                icon = Lang.target.stop_cornerselling.icon,
                label = Lang.target.stop_cornerselling.label,
                distance = 1.5,
                onSelect = function(data)
                    stopConnerSelling()
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return cornerselling and currentVehicle == entity and not IsPedInAnyVehicle(cache.ped, false) and Config.Cornerselling.status
                end,
            },
        })
        exports.ox_target:addGlobalPed({
            {
                icon = Lang.target.cornerselling.icon,
                label = Lang.target.cornerselling.label,
                distance = 1.5,
                onSelect = function(data)
                    connerSelling(data.entity)
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return cornerselling and listPedsSelling[entity] and not IsPedInAnyVehicle(PlayerPedId(), false) and Config.Cornerselling.status
                end,
            },
        })
    else
        exports[Config.Target]:AddGlobalVehicle({
            options = {
                {
                    icon = Lang.target.start_cornerselling.icon,
                    label = Lang.target.start_cornerselling.label,
                    action = function(entity)
                        startConnerSelling(entity)
                    end,
                    canInteract = function(entity)
                        return not cornerselling and not IsPedInAnyVehicle(cache.ped, false) and hasItem(Config.Items['weedbaggie'], 1) and Config.Cornerselling.status
                    end,
                },
                {
                    icon = Lang.target.stop_cornerselling.icon,
                    label = Lang.target.stop_cornerselling.label,
                    action = function(entity)
                        stopConnerSelling()
                    end,
                    canInteract = function(entity)
                        return cornerselling and currentVehicle == entity and  not IsPedInAnyVehicle(cache.ped, false) and Config.Cornerselling.status
                    end,
                }
            },
            distance = 1.5,
        })
        exports[Config.Target]:AddGlobalPed({
            options = {
                {
                    icon = Lang.target.start_cornerselling.icon,
                    label = Lang.target.start_cornerselling.label,
                    type = "client",
                    action = function(entity)
                        connerSelling(entity)
                    end,
                    canInteract = function(entity)
                        return cornerselling and listPedsSelling[entity] and not IsPedInAnyVehicle(PlayerPedId(), false) and Config.Cornerselling.status
                    end,
                },
            },
            distance = 1.5,
        })
    end
    for k,v in pairs (Config.TacoShop.points) do
        if Config.Target == 'ox_target' then
            exports.ox_target:addSphereZone({
                coords = vector3(v.pos.x, v.pos.y, v.pos.z + 1.0),
                radius = 1.0,
                debug =  Config.Debug,
                drawSprite = true,
                distance = 1.5,
                options = {
                    {
                        icon = Lang.target.droppack.icon,
                        label = Lang.target.droppack.label,
                        onSelect = function(data)
                            dropPackage()
                        end,
                        canInteract = function(entity, distance, coords, name, bone)
                            if onDuty and tacoIndex == k and Config.TacoShop.status then
                                return true
                            end
                            return false
                        end,
                    }
                }
            })
        else
            exports[Config.Target]:AddCircleZone("tacoshop_"..k, vector3(v.pos.x, v.pos.y, v.pos.z + 1.0), 1.0, {
                name = "tacoshop_"..k,
                debugPoly = Config.Debug,
            }, {
                options = {
                    {
                        icon = Lang.target.droppack.icon,
                        label = Lang.target.droppack.label,
                        action = function(entity)
                            dropPackage()
                        end,
                        canInteract = function(entity, distance, data)
                            if onDuty and tacoIndex == k and Config.TacoShop.status then
                                return true
                            end
                            return false
                        end,
                        drawDistance = 10.0,
                        drawColor = {255, 255, 255, 255},
                        successDrawColor = {30, 144, 255, 255},
                    }
                },
                distance = 1.5,
            })
        end
    end
    local _model = {}
    for k,v in pairs(Config.Plant.growthObjects) do
        table.insert(_model, v.model)
    end
    if Config.Target == 'ox_target' then
        exports.ox_target:addModel(_model, {
                {
                    onSelect = function(data)
                        checkPlant(data.entity)
                    end,
                    icon = Lang.target.check.icon,
                    label = Lang.target.check.label,
                    distance = 1.5,
                },
                {
                    onSelect = function(data)
                        harvestPlant(data.entity)
                    end,
                    icon = Lang.target.harvest.icon,
                    label = Lang.target.harvest.label,
                    distance = 1.5,
                },
            }
        )
    else
        exports[Config.Target]:AddTargetModel(_model,{
            options =  {
                {
                    action = function(entity)
                        checkPlant(entity)
                    end,
                    icon = Lang.target.check.icon,
                    label = Lang.target.check.label,
                },
                {
                    action = function(entity)
                        harvestPlant(entity)
                    end,
                    icon = Lang.target.harvest.icon,
                    label = Lang.target.harvest.label,
                },
            },
            distance = 1.5
        })
    end
    if Config.HyperData then
        SendNUIMessage({
            event = "connect"
        })
    else
        TriggerServerEvent('rep-weed:join')
    end
    Config.TacoShop.points = lib.callback.await('rep-weed:callback:getConfigTaco', false)
    weedProcessingLocation  = lib.callback.await('rep-weed:callback:getweedProcessingLocation', false)
    for _index, _value in pairs(Config.Plant.packageLocation) do
        local _model = Config.TacoShop.ped[math.random(#Config.TacoShop.ped)]
        lib.requestModel(_model)
        local _ped = CreatePed(0, _model, _value.ped.x, _value.ped.y, _value.ped.z, _value.ped.w, false, true)
        SetPedFleeAttributes(_ped, 0, false)
        SetPedDiesWhenInjured(_ped, false)
        SetBlockingOfNonTemporaryEvents(_ped, true)
        SetEntityInvincible(_ped, true)
        FreezeEntityPosition(_ped, true)
        lib.requestAnimDict('mp_arresting')
        TaskPlayAnim(_ped, 'mp_arresting', 'a_uncuff', 3.0, 1.0, -1, 49, 0, false, false, false)
        SetPedKeepTask(_ped, true)
        local object = CreateObject(joaat("bkr_prop_weed_table_01a"), _value.table.x, _value.table.y, _value.table.z, false, false, false)
        SetEntityHeading(object,  _value.table.w)
        SetEntityInvincible(object, true)
        FreezeEntityPosition(object, true)
        _entites[#_entites+1] = _ped
        _entites[#_entites+1] = object
        if Config.Target == 'ox_target' then
            exports.ox_target:addLocalEntity(_ped,
            {
                {
                    onSelect = function(data)
                        TriggerEvent('rep-weed:client:packageGood', _index)
                    end,
                    icon = Lang.target.packageGood.icon,
                    label = Lang.target.packageGood.label,
                    distance = 1.5,
                    canInteract = function()
                        return not weedProcessingLocation[_index].itemCollect and not weedProcessingLocation[_index].isWeedProcessing and hasItem(Config.Items['driedbud'])
                    end,
                },
                {
                    onSelect = function(entity)
                        TriggerServerEvent('rep-weed:server:collectPackageGood', _index)
                    end,
                    icon = Lang.target.collectPackage.icon,
                    label = Lang.target.collectPackage.label,
                    distance = 1.5,
                    canInteract = function()
                        return weedProcessingLocation[_index].itemCollect
                    end,
                },
            }
        )
        else
            exports[Config.Target]:AddTargetEntity(_ped, {
                options = {
                    {
                        action = function (entity)
                            TriggerEvent('rep-weed:client:packageGood', _index)
                        end,
                        icon = Lang.target.packageGood.icon,
                        label = Lang.target.packageGood.label,
                        canInteract = function()
                            return not weedProcessingLocation[_index].itemCollect and not weedProcessingLocation[_index].isWeedProcessing and hasItem(Config.Items['driedbud'])
                        end,
                    },
                    {
                        action = function ()
                            TriggerServerEvent('rep-weed:server:collectPackageGood', _index)
                        end,
                        icon = Lang.target.collectPackage.icon,
                        label = Lang.target.collectPackage.label,
                        canInteract = function()
                            return weedProcessingLocation[_index].itemCollect
                        end,
                    },
                },
                distance = 1.5,
            })
        end
    end
end

function setInventoryDisabled(bool)
    if Config.Inventory == 'ox' then
        LocalPlayer.state.invBusy = bool
    elseif Config.Inventory == 'qs' then
        exports['qs-inventory']:setInventoryDisabled(bool)
    elseif Config.Inventory == 'old-qb' or Config.Inventory == 'new-qb' then
        LocalPlayer.state:set("inv_busy", bool, true)
    end
end

function hasItem(_item, _count)
    if not _count then
        _count = 1
    end
    if Config.Inventory == 'ox' then
        local count = exports.ox_inventory:Search('count', _item)
        if count >= _count then
            return true
        else
            return false
        end
    elseif Config.Inventory == 'qs' then
        local count = exports['qs-inventory']:Search(_item)
        if count >= _count then
            return true
        else
            return false
        end
    elseif Config.Inventory == 'old-qb' or Config.Inventory == 'new-qb' then
        return exports['qb-inventory']:HasItem(_item)
    end
end

function showTextUi(msg)
    lib.showTextUI(msg, {
        position = 'left-center'
    })
end

function hideTextUi()
    lib.hideTextUI()
end

function policeAlert(type)
    if type == 'cornering' then
        -- police alert for cornering here
        -- exports['ps-dispatch']:SuspiciousActivity() -- Project-Sloth ps-dispatch
        -- exports['qb-dispatch']:Oxy() -- Project-SLoth qb-dispatch
        -- TriggerServerEvent('police:server:policeAlert', 'Suspicious Hand-off') -- Regular qbcore
    else
        -- policeAlert for Weed Run here
        -- exports['ps-dispatch']:SuspiciousActivity() -- Project-SLoth ps-dispatch
        -- exports['qb-dispatch']:Oxy() -- Project-SLoth qb-dispatch
        -- TriggerServerEvent('police:server:policeAlert', 'Suspicious Hand-off') -- Regular qbcore
    end
    -- These are just examples, you will have to implement your own preferred dispatch service!
end

local isJonting = false

function effectJoint(lvl)
    isJonting = true
    Wait(5000)
    if not lvl then
        lvl = 0
    end
    CreateThread(function()
        while true do
            if IsEntityPlayingAnim(cache.ped, "amb@world_human_aa_smoke@male@idle_a", "idle_b", 3) or IsPedUsingScenario(cache.ped, 'WORLD_HUMAN_SMOKING_POT') then
                TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
                SetPedArmour(cache.ped, GetPedArmour(cache.ped) + math.random(Config.Plant.jointEffect.addArmorAmount[lvl].min, Config.Plant.jointEffect.addArmorAmount[lvl].max))
            else
                break
            end
            Wait(Config.Plant.jointEffect.time * 1000)
        end
    end)
end

CreateThread(function ()
    while true do
        if isJonting then
            if IsControlJustPressed(0, 73) then
                ClearPedTasks(cache.ped)
                isJonting = false
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    if Config.Inventory == 'ox' then
        exports.ox_inventory:displayMetadata({
            strain = 'Strain',
            dry = 'Dry',
            water = 'Water',
            remainweight = 'Weights Left'
        })
    end
end)

RegisterNUICallback('REGISTER_DATASET', function(data, cb)
    if data.name == 'Plants' then
        for _index, _value in pairs(data.data) do
            Plants[tonumber(_index)] = _value
        end
    elseif data.name == 'Strain' then
        for _index, _value in pairs(data.data) do
            MyStrains[tonumber(_index)] = _value
        end
    end
    cb('true')
end)

RegisterNetEvent('REGISTER_DATASET', function (data)
    if data.name == 'Plants' then
        for _index, _value in pairs(data.data) do
            Plants[tonumber(_index)] = _value
        end
    elseif data.name == 'Strain' then
        for _index, _value in pairs(data.data) do
            MyStrains[tonumber(_index)] = _value
        end
    end
end)

RegisterNUICallback('UPDATE_DATASET', function(data, cb)
    local _data = data.data
    for k, v in pairs(Plants) do
        if _data[tostring(k)] then
            Plants[k].water = _data[tostring(k)].water
        else
            removeWeed(k)
            Plants[k] = nil
        end
    end
    cb('true')
end)

RegisterNetEvent('UPDATE_DATASET', function (data)
    local _data = data.data
    for k, v in pairs(Plants) do
        if _data[tostring(k)] then
            Plants[k].water = _data[tostring(k)].water
        else
            removeWeed(k)
            Plants[k] = nil
        end
    end
end)

RegisterNUICallback('SYNC_DATASET', function(data, cb)
    if data.name == 'Plants' then
        if data.index2 == 'add' then
            Plants[data.index] = data.data
        else
            if Plants[data.index] then
                Plants[data.index][data.index2] = data.data
            else
                print("Plants "..data.index.." nil")
            end
        end
    elseif data.name == 'Strain' then
        if data.index2 == 'add' then
            MyStrains[data.index] = data.data
        else
            if MyStrains[data.index] then
                MyStrains[data.index][data.index2] = data.data
            else
                print("MyStrains "..data.index.." nil")
            end
        end
    end
    cb('true')
end)

RegisterNetEvent('SYNC_DATASET', function (data)
    if data.name == 'Plants' then
        if data.index2 == 'add' then
            Plants[data.index] = data.data
        else
            if Plants[data.index] then
                Plants[data.index][data.index2] = data.data
            else
                print("Plants "..data.index.." nil")
            end
        end
    elseif data.name == 'Strain' then
        if data.index2 == 'add' then
            MyStrains[data.index] = data.data
        else
            if MyStrains[data.index] then
                MyStrains[data.index][data.index2] = data.data
            else
                print("MyStrains "..data.index.." nil")
            end
        end
    end
end)

RegisterNUICallback('REMOVE_DATASET', function(data, cb)
    if data.name == 'Plants' then
        removeWeed(data.index)
        Plants[data.index] = nil
    end
    cb('true')
end)

RegisterNetEvent('REMOVE_DATASET', function (data)
    if data.name == 'Plants' then
        removeWeed(data.index)
        Plants[data.index] = nil
    end
end)

AddEventHandler('onResourceStart', function(r)
    if r == GetCurrentResourceName() then
        if Config.UseTalkNPC then
            talkNPC()
        else
            targetNPC()
        end
        initWeed()
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then
        for id, plant in pairs(Plants) do
            removeWeed(id)
        end
        for _index, _value in pairs(_entites) do
            DeleteEntity(_value)
        end
        DeleteEntity(bossNpc)
    end
end)

CreateThread(function()
    while true do
        local pos = GetEntityCoords(cache.ped)
        local dis = 20.0
        if IsPedInAnyPlane(cache.ped) or IsPedInAnyHeli(cache.ped) then
            dis = 200.0
        end
        for id, plant in pairs(Plants) do
            if #(pos - vector3(plant.x, plant.y, plant.z)) < dis then
                local plantGrowth = getPlantGrowthPercent(plant)
                local curStage = getStageFromPercent(plantGrowth)
                if plant.isRendered and plant.stage ~= curStage then
                    removeWeed(id)
                end
                if not plant.isRendered or (plant.isRendered and plant.stage ~= curStage) then
                    local weedPlant = createWeedStageAtCoords(curStage, vector3(plant.x, plant.y, plant.z))
                    plant.isRendered = true
                    plant.object = weedPlant
                    plant.stage = curStage
                end
            end
            if #(pos - vector3(plant.x, plant.y, plant.z)) >= dis and plant.isRendered then
                removeWeed(id)
            end
        end
        Wait(1500)
    end
end)

RegisterNetEvent('rep-weed:client:chiduong', function ()
    local _pPos = GetEntityCoords(bossNpc)
    SetNewWaypoint(_pPos.x, _pPos.y)
end)

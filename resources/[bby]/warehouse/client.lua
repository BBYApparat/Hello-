-- Client-side warehouse management
local Warehouses = {}
local Targets = {}
local Blips = {}
local InWarehouse = false
local CurrentWarehouse = nil

-- Initialize
CreateThread(function()
    while ESX == nil do
        Wait(0)
    end
    
    Wait(1000)
    RefreshWarehouses()
end)

-- Refresh warehouses from server
function RefreshWarehouses()
    ESX.TriggerServerCallback('esx_warehouse:getWarehouses', function(warehouses)
        Warehouses = warehouses
        CreateWarehouseTargets()
        CreateWarehouseBlips()
    end)
end

-- Create warehouse blips
function CreateWarehouseBlips()
    -- Clear existing blips
    for _, blip in pairs(Blips) do
        RemoveBlip(blip)
    end
    Blips = {}
    
    for warehouseId, warehouse in pairs(Warehouses) do
        local color = warehouse.owned and 1 or 2 -- Red if owned, Green if available
        local name = warehouse.owned and ("Warehouse #" .. warehouseId .. " (Owned)") or ("Warehouse #" .. warehouseId .. " (Available)")
        
        local blip = makeBlip({
            coords = warehouse.outside,
            sprite = 473,
            col = color,
            scale = 0.7,
            name = name
        })
        
        Blips[warehouseId] = blip
    end
end

-- Create warehouse targets
function CreateWarehouseTargets()
    -- Clear existing targets
    for _, target in pairs(Targets) do
        exports.ox_target:removeZone(target)
    end
    Targets = {}
    
    for warehouseId, warehouse in pairs(Warehouses) do
        local targetId = "warehouse_" .. warehouseId
        
        local target = exports.ox_target:addBoxZone({
            coords = warehouse.outside.xyz,
            size = vec3(2.0, 2.0, 2.0),
            rotation = warehouse.outside.w,
            options = {
                {
                    name = 'warehouse_interact',
                    icon = 'fas fa-warehouse',
                    label = 'Interact with Warehouse',
                    onSelect = function()
                        OpenWarehouseMenu(warehouseId)
                    end,
                    distance = 3.0
                }
            }
        })
        
        Targets[warehouseId] = target
    end
end

-- Open warehouse menu
function OpenWarehouseMenu(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse then return end
    
    ESX.TriggerServerCallback('esx_warehouse:isOwner', function(isOwner)
        ESX.TriggerServerCallback('esx_warehouse:isOwned', function(isOwned)
            local menuOptions = {}
            
            -- Admin options
            local playerData = ESX.GetPlayerData()
            local isAdmin = false
            
            for _, group in pairs(Config.AdminGroups) do
                if playerData.group == group then
                    isAdmin = true
                    break
                end
            end
            
            if isAdmin then
                table.insert(menuOptions, {
                    title = '🔧 Admin: Delete Warehouse',
                    description = 'Delete this warehouse permanently',
                    onSelect = function()
                        local alert = lib.alertDialog({
                            header = 'Delete Warehouse',
                            content = 'Are you sure you want to delete this warehouse?',
                            centered = true,
                            cancel = true
                        })
                        
                        if alert == 'confirm' then
                            TriggerServerEvent('esx_warehouse:admin:deleteWarehouse', warehouseId)
                        end
                    end
                })
                
                if isOwned and not isOwner then
                    table.insert(menuOptions, {
                        title = '🔧 Admin: Enter Warehouse',
                        description = 'Enter warehouse without password',
                        onSelect = function()
                            TriggerServerEvent('esx_warehouse:enterWarehouse', warehouseId, warehouse.password)
                        end
                    })
                end
            end
            
            -- Police options
            if playerData.job and playerData.job.name == 'police' then
                table.insert(menuOptions, {
                    title = '👮 Police Raid',
                    description = 'Raid this warehouse',
                    onSelect = function()
                        TriggerServerEvent('esx_warehouse:policeRaid', warehouseId)
                    end
                })
            end
            
            -- Owner options
            if isOwner then
                table.insert(menuOptions, {
                    title = '🏠 Enter Warehouse',
                    description = 'Enter your warehouse',
                    onSelect = function()
                        EnterWarehouse(warehouseId)
                    end
                })
                
                table.insert(menuOptions, {
                    title = '🔑 Change Password',
                    description = 'Change warehouse password',
                    onSelect = function()
                        ChangePassword(warehouseId)
                    end
                })
                
                table.insert(menuOptions, {
                    title = '💰 Sell Warehouse',
                    description = 'Sell warehouse for $' .. Config.WareHouseSellPrice,
                    onSelect = function()
                        local alert = lib.alertDialog({
                            header = 'Sell Warehouse',
                            content = 'Are you sure you want to sell this warehouse for $' .. Config.WareHouseSellPrice .. '?',
                            centered = true,
                            cancel = true
                        })
                        
                        if alert == 'confirm' then
                            TriggerServerEvent('esx_warehouse:sellWarehouse', warehouseId)
                        end
                    end
                })
            elseif not isOwned then
                table.insert(menuOptions, {
                    title = '💵 Buy Warehouse',
                    description = 'Purchase for $' .. warehouse.price,
                    onSelect = function()
                        local alert = lib.alertDialog({
                            header = 'Buy Warehouse',
                            content = 'Purchase this warehouse for $' .. warehouse.price .. '?',
                            centered = true,
                            cancel = true
                        })
                        
                        if alert == 'confirm' then
                            TriggerServerEvent('esx_warehouse:buyWarehouse', warehouseId)
                        end
                    end
                })
            elseif isOwned and not isOwner then
                table.insert(menuOptions, {
                    title = '🏠 Enter Warehouse',
                    description = 'Enter with password',
                    onSelect = function()
                        EnterWarehouse(warehouseId)
                    end
                })
            end
            
            lib.registerContext({
                id = 'warehouse_menu',
                title = 'Warehouse #' .. warehouseId,
                options = menuOptions
            })
            
            lib.showContext('warehouse_menu')
        end, warehouseId)
    end, warehouseId)
end

-- Enter warehouse with password prompt
function EnterWarehouse(warehouseId)
    local input = lib.inputDialog('Enter Warehouse', {
        {type = 'input', label = 'Password', password = true, required = true}
    })
    
    if input and input[1] then
        TriggerServerEvent('esx_warehouse:enterWarehouse', warehouseId, input[1])
    end
end

-- Change password
function ChangePassword(warehouseId)
    local input = lib.inputDialog('Change Password', {
        {type = 'input', label = 'New Password', required = true, min = 4, max = 20}
    })
    
    if input and input[1] then
        TriggerServerEvent('esx_warehouse:updatePassword', warehouseId, input[1])
    end
end

-- Create interior targets (exit and stash)
function CreateInteriorTargets(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse then return end
    
    local interior = Config.Interiors[warehouse.interior_type]
    if not interior then return end
    
    -- Exit target
    local exitTarget = exports.ox_target:addBoxZone({
        coords = interior.exit.xyz,
        size = vec3(1.5, 1.5, 2.0),
        rotation = interior.exit.w,
        options = {
            {
                name = 'warehouse_exit',
                icon = 'fas fa-door-open',
                label = 'Exit Warehouse',
                onSelect = function()
                    TriggerServerEvent('esx_warehouse:exitWarehouse')
                end,
                distance = 2.0
            }
        }
    })
    
    -- Stash target
    local stashTarget = exports.ox_target:addBoxZone({
        coords = interior.stash,
        size = vec3(2.0, 2.0, 1.5),
        rotation = 0.0,
        options = {
            {
                name = 'warehouse_stash',
                icon = 'fas fa-box',
                label = 'Open Storage',
                onSelect = function()
                    TriggerServerEvent('esx_warehouse:openStash', warehouseId)
                end,
                distance = 3.0
            }
        }
    })
    
    -- Store targets for cleanup
    Targets['exit_' .. warehouseId] = exitTarget
    Targets['stash_' .. warehouseId] = stashTarget
end

-- Remove interior targets
function RemoveInteriorTargets(warehouseId)
    if Targets['exit_' .. warehouseId] then
        exports.ox_target:removeZone(Targets['exit_' .. warehouseId])
        Targets['exit_' .. warehouseId] = nil
    end
    
    if Targets['stash_' .. warehouseId] then
        exports.ox_target:removeZone(Targets['stash_' .. warehouseId])
        Targets['stash_' .. warehouseId] = nil
    end
end

-- Admin: Create warehouse at current location
RegisterCommand('createwarehouse', function(source, args)
    local playerData = ESX.GetPlayerData()
    local isAdmin = false
    
    for _, group in pairs(Config.AdminGroups) do
        if playerData.group == group then
            isAdmin = true
            break
        end
    end
    
    if not isAdmin then
        ESX.ShowNotification('You do not have permission!', 'error')
        return
    end
    
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local warehouseCoords = vector4(coords.x, coords.y, coords.z, heading)
    
    local input = lib.inputDialog('Create Warehouse', {
        {type = 'select', label = 'Interior Type', options = {
            {value = 'warehouse_small', label = 'Small Warehouse'},
            {value = 'warehouse_medium', label = 'Medium Warehouse'},
            {value = 'warehouse_large', label = 'Large Warehouse'}
        }, default = 'warehouse_small'},
        {type = 'number', label = 'Price', default = Config.DefaultSettings.price, min = 1000, max = 1000000},
        {type = 'input', label = 'Password', default = 'changeme', required = true}
    })
    
    if input then
        TriggerServerEvent('esx_warehouse:admin:createWarehouse', warehouseCoords, input[1], input[2], input[3])
    end
end)

-- Events
RegisterNetEvent('esx_warehouse:refreshWarehouses', function()
    RefreshWarehouses()
end)

RegisterNetEvent('esx_warehouse:teleportToInterior', function(coords, warehouseId)
    InWarehouse = true
    CurrentWarehouse = warehouseId
    
    -- Fade out
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Teleport
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    -- Fade in
    Wait(100)
    DoScreenFadeIn(500)
    
    -- Create interior targets
    Wait(1000)
    CreateInteriorTargets(warehouseId)
    
    ESX.ShowNotification('Welcome to Warehouse #' .. warehouseId, 'info')
end)

RegisterNetEvent('esx_warehouse:teleportOutside', function(coords)
    InWarehouse = false
    
    -- Remove interior targets
    if CurrentWarehouse then
        RemoveInteriorTargets(CurrentWarehouse)
    end
    
    CurrentWarehouse = nil
    
    -- Fade out
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Teleport
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    -- Fade in
    Wait(100)
    DoScreenFadeIn(500)
    
    ESX.ShowNotification('You left the warehouse', 'info')
end)

RegisterNetEvent('esx_warehouse:openStashClient', function(stashName)
    exports.ox_inventory:openInventory('stash', stashName)
end)

-- Admin give warehouse command
RegisterNetEvent('esx_warehouse:admin:giveWarehouseMenu', function()
    local playerData = ESX.GetPlayerData()
    local isAdmin = false
    
    for _, group in pairs(Config.AdminGroups) do
        if playerData.group == group then
            isAdmin = true
            break
        end
    end
    
    if not isAdmin then
        ESX.ShowNotification('You do not have permission!', 'error')
        return
    end
    
    -- Get list of warehouses
    local warehouseOptions = {}
    for warehouseId, warehouse in pairs(Warehouses) do
        table.insert(warehouseOptions, {
            value = warehouseId,
            label = 'Warehouse #' .. warehouseId .. (warehouse.owned and ' (Owned)' or ' (Available)')
        })
    end
    
    if #warehouseOptions == 0 then
        ESX.ShowNotification('No warehouses available', 'error')
        return
    end
    
    local input = lib.inputDialog('Give Warehouse', {
        {type = 'select', label = 'Warehouse', options = warehouseOptions},
        {type = 'number', label = 'Player ID', required = true, min = 1}
    })
    
    if input then
        TriggerServerEvent('esx_warehouse:admin:giveWarehouse', input[1], input[2])
    end
end)

-- Register admin give warehouse command
RegisterCommand('givewarehouse', function()
    TriggerEvent('esx_warehouse:admin:giveWarehouseMenu')
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Clear all targets
        for _, target in pairs(Targets) do
            exports.ox_target:removeZone(target)
        end
        
        -- Clear all blips
        for _, blip in pairs(Blips) do
            RemoveBlip(blip)
        end
    end
end)
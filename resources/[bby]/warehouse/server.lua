-- Complete Fixed ESX Warehouse Server
local Warehouses = {}
local ActiveInstances = {}

-- Initialize database
CreateThread(function()
    MySQL.ready(function()
        -- Create warehouses table if it doesn't exist
        MySQL.execute([[
            CREATE TABLE IF NOT EXISTS `warehouses` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `location` int(11) NOT NULL,
                `outside_coords` longtext NOT NULL,
                `interior_type` varchar(50) NOT NULL DEFAULT 'warehouse_small',
                `owned` tinyint(1) NOT NULL DEFAULT 0,
                `owner` varchar(50) DEFAULT NULL,
                `stashsize` int(11) NOT NULL DEFAULT 3000000,
                `slots` int(11) NOT NULL DEFAULT 50,
                `price` int(11) NOT NULL DEFAULT 50000,
                `date_purchased` datetime DEFAULT NULL,
                `passwordset` tinyint(1) NOT NULL DEFAULT 1,
                `password` varchar(255) NOT NULL DEFAULT 'changeme',
                `created_by` varchar(50) DEFAULT NULL,
                `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                UNIQUE KEY `location` (`location`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ]])
        
        -- Fix existing problematic data
        MySQL.execute([[
            UPDATE warehouses 
            SET date_purchased = NULL 
            WHERE date_purchased IS NOT NULL 
            AND (date_purchased > '2030-01-01' OR date_purchased < '2020-01-01')
        ]])
        
        LoadWarehouses()
        print("^2[ESX Warehouses]^7 Database initialized and warehouses loaded!")
    end)
end)

-- Load warehouses from database
function LoadWarehouses()
    MySQL.query('SELECT * FROM warehouses', {}, function(result)
        if result then
            for _, warehouse in pairs(result) do
                local outsideCoords = json.decode(warehouse.outside_coords)
                local warehouseId = tonumber(warehouse.location)
                Warehouses[warehouseId] = {
                    id = warehouse.id,
                    location = warehouseId,
                    outside = vector4(outsideCoords.x, outsideCoords.y, outsideCoords.z, outsideCoords.w),
                    interior_type = warehouse.interior_type,
                    owned = warehouse.owned == 1,
                    owner = warehouse.owner,
                    stashsize = warehouse.stashsize,
                    slots = warehouse.slots,
                    price = warehouse.price,
                    date_purchased = warehouse.date_purchased,
                    passwordset = warehouse.passwordset == 1,
                    password = warehouse.password,
                    created_by = warehouse.created_by
                }
            end
            print("^2[ESX Warehouses]^7 Loaded " .. #result .. " warehouses from database")
        end
    end)
end

-- Get all warehouses
ESX.RegisterServerCallback('esx_warehouse:getWarehouses', function(source, cb)
    cb(Warehouses)
end)

-- Get warehouse details
ESX.RegisterServerCallback('esx_warehouse:getDetails', function(source, cb, warehouseId)
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if warehouse then
        cb(warehouse)
    else
        cb(false)
    end
end)

-- Check if warehouse is owned
ESX.RegisterServerCallback('esx_warehouse:isOwned', function(source, cb, warehouseId)
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if warehouse then
        cb(warehouse.owned)
    else
        cb(false)
    end
end)

-- Check if player is owner
ESX.RegisterServerCallback('esx_warehouse:isOwner', function(source, cb, warehouseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb(false)
        return 
    end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if warehouse and warehouse.owner == xPlayer.identifier then
        cb(true)
    else
        cb(false)
    end
end)

-- Check if password is set
ESX.RegisterServerCallback('esx_warehouse:isPasswordSet', function(source, cb, warehouseId)
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if warehouse then
        cb(warehouse.passwordset)
    else
        cb(false)
    end
end)

-- Admin: Create warehouse
RegisterNetEvent('esx_warehouse:admin:createWarehouse', function(coords, interiorType, price, password)
    local source = source
    if not IsPlayerAdmin(source) then
        TriggerClientEvent('esx:showNotification', source, 'You do not have permission!', 'error')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local warehouseId = GenerateWarehouseId()
    
    -- Check if location already exists nearby
    for _, warehouse in pairs(Warehouses) do
        if GetDistance(coords, warehouse.outside) < 10.0 then
            TriggerClientEvent('esx:showNotification', source, 'Warehouse too close to existing one!', 'error')
            return
        end
    end
    
    local coordsJson = json.encode({x = coords.x, y = coords.y, z = coords.z, w = coords.w or 0.0})
    
    MySQL.insert('INSERT INTO warehouses (location, outside_coords, interior_type, price, password, created_by) VALUES (?, ?, ?, ?, ?, ?)',
        {warehouseId, coordsJson, interiorType, price, password, xPlayer.identifier}, 
        function(insertId)
            if insertId then
                Warehouses[warehouseId] = {
                    id = insertId,
                    location = warehouseId,
                    outside = coords,
                    interior_type = interiorType,
                    owned = false,
                    owner = nil,
                    stashsize = Config.DefaultSettings.stashsize,
                    slots = Config.DefaultSettings.slots,
                    price = price,
                    date_purchased = nil,
                    passwordset = true,
                    password = password,
                    created_by = xPlayer.identifier
                }
                
                TriggerClientEvent('esx:showNotification', source, 'Warehouse created successfully!', 'success')
                TriggerClientEvent('esx_warehouse:refreshWarehouses', -1)
                
                if Config.Debug then
                    print("^2[ESX Warehouses]^7 Warehouse " .. warehouseId .. " created by " .. xPlayer.getName())
                end
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to create warehouse!', 'error')
            end
        end
    )
end)

-- Admin: Delete warehouse
RegisterNetEvent('esx_warehouse:admin:deleteWarehouse', function(warehouseId)
    local source = source
    if not IsPlayerAdmin(source) then
        TriggerClientEvent('esx:showNotification', source, 'You do not have permission!', 'error')
        return
    end
    
    warehouseId = tonumber(warehouseId)
    if Warehouses[warehouseId] then
        MySQL.execute('DELETE FROM warehouses WHERE location = ?', {warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                Warehouses[warehouseId] = nil
                TriggerClientEvent('esx:showNotification', source, 'Warehouse deleted successfully!', 'success')
                TriggerClientEvent('esx_warehouse:refreshWarehouses', -1)
                
                if Config.Debug then
                    print("^2[ESX Warehouses]^7 Warehouse " .. warehouseId .. " deleted")
                end
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to delete warehouse!', 'error')
            end
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
    end
end)

-- Admin: Give warehouse to player
RegisterNetEvent('esx_warehouse:admin:giveWarehouse', function(warehouseId, targetId)
    local source = source
    if not IsPlayerAdmin(source) then
        TriggerClientEvent('esx:showNotification', source, 'You do not have permission!', 'error')
        return
    end
    
    warehouseId = tonumber(warehouseId)
    targetId = tonumber(targetId)
    
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, 'Player not found!', 'error')
        return
    end
    
    local warehouse = Warehouses[warehouseId]
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    local currentTime = os.date('%Y-%m-%d %H:%M:%S')
    
    MySQL.execute('UPDATE warehouses SET owned = 1, owner = ?, date_purchased = ? WHERE location = ?',
        {xTarget.identifier, currentTime, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.owned = true
                warehouse.owner = xTarget.identifier
                warehouse.date_purchased = currentTime
                
                TriggerClientEvent('esx:showNotification', source, 'Warehouse given to ' .. xTarget.getName(), 'success')
                TriggerClientEvent('esx:showNotification', targetId, 'You have been given a warehouse!', 'success')
                TriggerClientEvent('esx_warehouse:refreshWarehouses', -1)
                
                -- Force immediate refresh for both admin and target
                SetTimeout(100, function()
                    TriggerClientEvent('esx_warehouse:forceRefresh', source)
                    TriggerClientEvent('esx_warehouse:forceRefresh', targetId)
                end)
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to give warehouse!', 'error')
            end
        end
    )
end)

-- Buy warehouse
RegisterNetEvent('esx_warehouse:buyWarehouse', function(warehouseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    if warehouse.owned then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse already owned!', 'error')
        return
    end
    
    if xPlayer.getMoney() < warehouse.price then
        TriggerClientEvent('esx:showNotification', source, 'Insufficient funds!', 'error')
        return
    end
    
    xPlayer.removeMoney(warehouse.price)
    
    local currentTime = os.date('%Y-%m-%d %H:%M:%S')
    
    MySQL.execute('UPDATE warehouses SET owned = 1, owner = ?, date_purchased = ? WHERE location = ?',
        {xPlayer.identifier, currentTime, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.owned = true
                warehouse.owner = xPlayer.identifier
                warehouse.date_purchased = currentTime
                
                TriggerClientEvent('esx:showNotification', source, 'Warehouse purchased successfully!', 'success')
                TriggerClientEvent('esx_warehouse:refreshWarehouses', -1)
                
                -- Force immediate refresh for the buyer
                SetTimeout(100, function()
                    TriggerClientEvent('esx_warehouse:forceRefresh', source)
                end)
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to purchase warehouse!', 'error')
                xPlayer.addMoney(warehouse.price) -- Refund
            end
        end
    )
end)

-- Sell warehouse
RegisterNetEvent('esx_warehouse:sellWarehouse', function(warehouseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse or warehouse.owner ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You do not own this warehouse!', 'error')
        return
    end
    
    xPlayer.addMoney(Config.WareHouseSellPrice)
    
    MySQL.execute('UPDATE warehouses SET owned = 0, owner = NULL, date_purchased = NULL, stashsize = ?, slots = ? WHERE location = ?',
        {Config.DefaultSettings.stashsize, Config.DefaultSettings.slots, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.owned = false
                warehouse.owner = nil
                warehouse.date_purchased = nil
                warehouse.stashsize = Config.DefaultSettings.stashsize
                warehouse.slots = Config.DefaultSettings.slots
                
                TriggerClientEvent('esx:showNotification', source, 'Warehouse sold successfully!', 'success')
                TriggerClientEvent('esx_warehouse:refreshWarehouses', -1)
                
                -- Force immediate refresh for the seller
                SetTimeout(100, function()
                    TriggerClientEvent('esx_warehouse:forceRefresh', source)
                end)
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to sell warehouse!', 'error')
            end
        end
    )
end)

-- Update password
RegisterNetEvent('esx_warehouse:updatePassword', function(warehouseId, newPassword)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse or (warehouse.owner ~= xPlayer.identifier and not IsPlayerAdmin(source)) then
        TriggerClientEvent('esx:showNotification', source, 'You do not have permission!', 'error')
        return
    end
    
    MySQL.execute('UPDATE warehouses SET password = ?, passwordset = 1 WHERE location = ?',
        {newPassword, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.password = newPassword
                warehouse.passwordset = true
                
                TriggerClientEvent('esx:showNotification', source, 'Password updated successfully!', 'success')
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to update password!', 'error')
            end
        end
    )
end)

-- Enter warehouse instance
RegisterNetEvent('esx_warehouse:enterWarehouse', function(warehouseId, password)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    -- Check password
    if warehouse.passwordset and warehouse.password ~= password then
        TriggerClientEvent('esx:showNotification', source, 'Wrong password!', 'error')
        return
    end
    
    local instanceId = WarehouseUtils.GetInstanceId(warehouseId)
    local interior = Config.Interiors[warehouse.interior_type]
    
    if not interior then
        TriggerClientEvent('esx:showNotification', source, 'Interior not found!', 'error')
        return
    end
    
    -- Set player to instance
    SetPlayerRoutingBucket(source, instanceId)
    ActiveInstances[source] = {warehouseId = warehouseId, instanceId = instanceId}
    
    -- Teleport player to interior
    TriggerClientEvent('esx_warehouse:teleportToInterior', source, interior.spawn, warehouseId)
    
    if Config.Debug then
        print("^2[ESX Warehouses]^7 Player " .. xPlayer.getName() .. " entered warehouse " .. warehouseId)
    end
end)

-- Exit warehouse instance
RegisterNetEvent('esx_warehouse:exitWarehouse', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local instanceData = ActiveInstances[source]
    if not instanceData then
        TriggerClientEvent('esx:showNotification', source, 'You are not in a warehouse!', 'error')
        return
    end
    
    local warehouse = Warehouses[instanceData.warehouseId]
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    -- Remove player from instance
    SetPlayerRoutingBucket(source, 0)
    ActiveInstances[source] = nil
    
    -- Teleport player outside
    TriggerClientEvent('esx_warehouse:teleportOutside', source, warehouse.outside)
    
    if Config.Debug then
        print("^2[ESX Warehouses]^7 Player " .. xPlayer.getName() .. " exited warehouse " .. instanceData.warehouseId)
    end
end)

-- Open stash
RegisterNetEvent('esx_warehouse:openStash', function(warehouseId)
    local source = source
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    local stashName = WarehouseUtils.GetStashName(warehouseId)
    
    -- Register stash if it doesn't exist
    if not exports.ox_inventory:GetInventory(stashName) then
        exports.ox_inventory:RegisterStash(stashName, "Warehouse #" .. warehouseId, warehouse.slots, warehouse.stashsize)
    end
    
    TriggerClientEvent('esx_warehouse:openStashClient', source, stashName)
end)

-- Police raid
RegisterNetEvent('esx_warehouse:policeRaid', function(warehouseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or xPlayer.job.name ~= 'police' then
        TriggerClientEvent('esx:showNotification', source, 'You are not authorized!', 'error')
        return
    end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse then
        TriggerClientEvent('esx:showNotification', source, 'Warehouse not found!', 'error')
        return
    end
    
    local instanceId = WarehouseUtils.GetInstanceId(warehouseId)
    local interior = Config.Interiors[warehouse.interior_type]
    
    -- Set player to instance for raid
    SetPlayerRoutingBucket(source, instanceId)
    ActiveInstances[source] = {warehouseId = warehouseId, instanceId = instanceId}
    
    TriggerClientEvent('esx_warehouse:teleportToInterior', source, interior.spawn, warehouseId)
    TriggerClientEvent('esx:showNotification', source, 'Raiding warehouse #' .. warehouseId, 'info')
    
    if Config.Debug then
        print("^2[ESX Warehouses]^7 Police raid on warehouse " .. warehouseId .. " by " .. xPlayer.getName())
    end
end)

-- Warehouse renewal
RegisterNetEvent('esx_warehouse:renewWarehouse', function(warehouseId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse or warehouse.owner ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You do not own this warehouse!', 'error')
        return
    end
    
    if xPlayer.getMoney() < warehouse.price then
        TriggerClientEvent('esx:showNotification', source, 'Insufficient funds!', 'error')
        return
    end
    
    xPlayer.removeMoney(warehouse.price)
    
    -- Proper date calculation for renewal
    local renewalDate
    if warehouse.date_purchased then
        -- Add 7 days to current date_purchased
        renewalDate = os.date('%Y-%m-%d %H:%M:%S', os.time() + (7 * 24 * 60 * 60))
    else
        -- If no date_purchased, start from now
        renewalDate = os.date('%Y-%m-%d %H:%M:%S', os.time() + (7 * 24 * 60 * 60))
    end
    
    MySQL.execute('UPDATE warehouses SET date_purchased = ? WHERE location = ?',
        {renewalDate, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.date_purchased = renewalDate
                TriggerClientEvent('esx:showNotification', source, 'Warehouse renewed for 7 days!', 'success')
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to renew warehouse!', 'error')
                xPlayer.addMoney(warehouse.price) -- Refund
            end
        end
    )
end)

-- Upgrade warehouse size
RegisterNetEvent('esx_warehouse:upgradeSize', function(warehouseId, sizeIncrease)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse or warehouse.owner ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You do not own this warehouse!', 'error')
        return
    end
    
    local upgradeCost = 0
    if sizeIncrease == 500 then
        upgradeCost = Config.Upgradation.StashSize["500 Kg"]
    elseif sizeIncrease == 1000 then
        upgradeCost = Config.Upgradation.StashSize["1000 Kg"]
    elseif sizeIncrease == 1500 then
        upgradeCost = Config.Upgradation.StashSize["1500 Kg"]
    end
    
    if xPlayer.getMoney() < upgradeCost then
        TriggerClientEvent('esx:showNotification', source, 'Insufficient funds! Need $' .. upgradeCost, 'error')
        return
    end
    
    xPlayer.removeMoney(upgradeCost)
    
    local newSize = warehouse.stashsize + (sizeIncrease * 1000)
    
    MySQL.execute('UPDATE warehouses SET stashsize = ? WHERE location = ?',
        {newSize, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.stashsize = newSize
                TriggerClientEvent('esx:showNotification', source, 'Storage upgraded to ' .. (newSize/1000) .. 'kg!', 'success')
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to upgrade storage!', 'error')
                xPlayer.addMoney(upgradeCost) -- Refund
            end
        end
    )
end)

-- Upgrade warehouse slots
RegisterNetEvent('esx_warehouse:upgradeSlots', function(warehouseId, slotIncrease)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    warehouseId = tonumber(warehouseId)
    local warehouse = Warehouses[warehouseId]
    if not warehouse or warehouse.owner ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', source, 'You do not own this warehouse!', 'error')
        return
    end
    
    local upgradeCost = 0
    if slotIncrease == 20 then
        upgradeCost = Config.Upgradation.Slots["+20"]
    elseif slotIncrease == 40 then
        upgradeCost = Config.Upgradation.Slots["+40"]
    elseif slotIncrease == 60 then
        upgradeCost = Config.Upgradation.Slots["+60"]
    end
    
    if xPlayer.getMoney() < upgradeCost then
        TriggerClientEvent('esx:showNotification', source, 'Insufficient funds! Need $' .. upgradeCost, 'error')
        return
    end
    
    xPlayer.removeMoney(upgradeCost)
    
    local newSlots = warehouse.slots + slotIncrease
    
    MySQL.execute('UPDATE warehouses SET slots = ? WHERE location = ?',
        {newSlots, warehouseId}, function(affectedRows)
            if affectedRows > 0 then
                warehouse.slots = newSlots
                TriggerClientEvent('esx:showNotification', source, 'Slots upgraded to ' .. newSlots .. '!', 'success')
            else
                TriggerClientEvent('esx:showNotification', source, 'Failed to upgrade slots!', 'error')
                xPlayer.addMoney(upgradeCost) -- Refund
            end
        end
    )
end)

-- Admin commands
ESX.RegisterCommand('createwarehouse', 'admin', function(xPlayer, args, showError)
    local coords = GetEntityCoords(GetPlayerPed(xPlayer.source))
    local heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
    local warehouseCoords = vector4(coords.x, coords.y, coords.z, heading)
    
    local interiorType = args.interior or 'warehouse_small'
    local price = tonumber(args.price) or Config.DefaultSettings.price
    local password = args.password or 'changeme'
    
    TriggerEvent('esx_warehouse:admin:createWarehouse', warehouseCoords, interiorType, price, password)
end, false, {
    help = 'Create a warehouse at your location',
    validate = false,
    arguments = {
        {name = 'interior', help = 'Interior type (warehouse_small/medium/large)', type = 'string'},
        {name = 'price', help = 'Warehouse price', type = 'number'},
        {name = 'password', help = 'Default password', type = 'string'}
    }
})

ESX.RegisterCommand('deletewarehouse', 'admin', function(xPlayer, args, showError)
    local warehouseId = tonumber(args.id)
    if not warehouseId then
        showError('Invalid warehouse ID')
        return
    end
    
    TriggerEvent('esx_warehouse:admin:deleteWarehouse', warehouseId)
end, false, {
    help = 'Delete a warehouse',
    validate = true,
    arguments = {
        {name = 'id', help = 'Warehouse ID', type = 'number'}
    }
})

ESX.RegisterCommand('givewarehouse', 'admin', function(xPlayer, args, showError)
    local warehouseId = tonumber(args.warehouseid)
    local targetId = tonumber(args.playerid)
    
    if not warehouseId or not targetId then
        showError('Invalid arguments')
        return
    end
    
    TriggerEvent('esx_warehouse:admin:giveWarehouse', warehouseId, targetId)
end, false, {
    help = 'Give warehouse to a player',
    validate = true,
    arguments = {
        {name = 'warehouseid', help = 'Warehouse ID', type = 'number'},
        {name = 'playerid', help = 'Player ID', type = 'number'}
    }
})

-- Player disconnect cleanup
AddEventHandler('playerDropped', function(reason)
    local source = source
    if ActiveInstances[source] then
        ActiveInstances[source] = nil
    end
end)
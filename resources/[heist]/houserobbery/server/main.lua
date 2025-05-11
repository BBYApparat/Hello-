ESX = exports["es_extended"]:getSharedObject()


local robbing = {}
local robbableItems = Config.Items
local robbers = {}

local function lockpick(source, amount)
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cops = 0
    for k,v in pairs(Config.Cops) do
        cops = cops
    end
    if not Config.Cops[xPlayer.job.name] then
        -- TriggerClientEvent('lockerrobbery:attempt', source)
        TriggerClientEvent('houserobbery:attempt', source, amount, cops)
    else
        xPlayer.showNotification('Your job is not allowed to do this action')
    end
end

RegisterNetEvent('houserobbery:lockpick', function(house)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local amount = exports.ox_inventory:GetItemCount(src, "lockpick")

    if amount and amount > 0 then
        lockpick(src, amount)
    end
end)

ESX.RegisterServerCallback('houserobbery:alreadyrobbed', function(source, cb, id)
    cb(Config.Houses[id].robbed)
end)

RegisterServerEvent('houserobbery:removeLockpick', function()
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('lockpick', 1)
    xPlayer.showNotification('~y~The lockpick bent out of shape!') 
end)

RegisterServerEvent('houserobbery:registerhouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if robbers[xPlayer.identifier] then
        xPlayer.triggerEvent("houserobbery:alreadyInRobbery")
        return
    end
    robbers[xPlayer.identifier] = id
    table.insert(robbing, id)
    Config.Houses[id].robbed = true
    TriggerClientEvent('houserobbery:updatehouse', -1, robbing)
end)

RegisterServerEvent('houserobbery:setRobbed', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    Config.Houses[id].robbed = true
    TriggerClientEvent('houserobbery:updatehouse', -1, robbing)
end)

RegisterServerEvent('houserobbery:deregisterhouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if robbers[xPlayer.identifier] then
        robbers[xPlayer.identifier] = nil
        for i = 1, #robbing, 1 do
            if robbing[i] == id then
                table.remove(robbing, i)
            end
        end
        TriggerClientEvent('houserobbery:updatehouse', -1, robbing)
    end
end)

RegisterServerEvent('houseRobbery:notify', function(type, houseInfo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if type == "waypoint_set" then
        exports["lb-phone"]:SendNotification(xPlayer.source, {
            app = "Wallet",
            title = "Robbery Location Set",
            content = "GPS has been set to: " .. houseInfo,
            icon = ".ui/dist/assets/img/icons/apps/apps/Wallet.jpg",
        }, function(res)
            print("Notification sent (waypoint set):", res)
        end)
    elseif type == "limit_reached" then
        exports["lb-phone"]:SendNotification(xPlayer.source, {
            app = "Wallet",
            title = "Robbery Limit Reached",
            content = "There to many robbed houses right now. Please wait!",
            icon = ".ui/dist/assets/img/icons/apps/apps/Wallet.jpg",
        }, function(res)
            print("Notification sent (limit reached):", res)
        end)
    elseif type == "wrong_time" then
        exports["lb-phone"]:SendNotification(xPlayer.source, {
            app = "Wallet",
            title = "Wrong Time",
            content = "Are you crazy? They will see us.",
            icon = ".ui/dist/assets/img/icons/apps/apps/Wallet.jpg",
        }, function(res)
            print("Notification sent (wrong time):", res)
        end)
    end
end)

RegisterNetEvent("houserobbery:searchItem", function(place)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not Config.Items[place] then print('place ' , place, ' not found') return end

    if robbers[xPlayer.identifier] then
        local gotItem = getRandomItemFromCategory(place)
        if gotItem then
            xPlayer.addInventoryItem(gotItem.id, gotItem.quantity)
        else
            xPlayer.showNotification("No item found")
        end
    else
        -- ban me :)
    end
end)

function getRandomItemFromCategory(category)
    -- Get the list of items for the specified category
    if not Config.Items[category] then
        print("Invalid category: " .. category)
        return nil
    end

    local items = shuffle(Config.Items[category])
    
    for i = 1, 10, 1 do
        local item = items[math.random(1, #items)]
        local roll = math.random(1, Config.MaxChance)
        if roll <= item.chance then
            local qty = math.random(item.qtyMin, item.qtyMax)
            return {id = item.id, quantity = qty}
        end
    end

    return nil
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

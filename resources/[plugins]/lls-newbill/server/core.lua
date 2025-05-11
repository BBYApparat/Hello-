--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

ESX = nil

local openRequests = {}

CreateThread(function()
    while (ESX == nil) do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(100)
    end

    databaseAsyncExecute([[
        CREATE TABLE IF NOT EXISTS `newbill` (
            `shopName` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
            `shopMoney` INT(255) UNSIGNED NOT NULL,
            `itemsData` LONGTEXT NOT NULL COLLATE 'utf8_bin',
            PRIMARY KEY (`shopName`)
        )
    ]])
end)

-- BOSS
RegisterServerEvent('lls-newbill:requestToOpenBossMenu_server')
AddEventHandler('lls-newbill:requestToOpenBossMenu_server', function()
    local playerId = source

    if (playerId == nil) then
        return
    end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer == nil) then
        return
    end
    
    if (Config.JOBS_INITED[esxPlayer.job.name] == nil or esxPlayer.job.grade_name ~= Config.JOBS_INITED[esxPlayer.job.name].bossGradeName) then
        return
    end

    local shopData = {name = esxPlayer.job.name, label = Config.JOBS_INITED[esxPlayer.job.name].label}

    databaseAsyncFetchData('SELECT shopMoney, itemsData FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = shopData.name
    }, function(result)
        local bossBankMoney = 0
        local itemsData = {}
        local cleanItemsData = {}

        if (result ~= nil and result[1] ~= nil) then
            if (result[1]['shopMoney'] ~= nil) then
                bossBankMoney = tonumber(result[1]['shopMoney'])
                
                if (bossBankMoney < 0) then
                    bossBankMoney = 0
                end
            end

            if (result[1]['itemsData'] ~= nil) then
                itemsData = json.decode(result[1]['itemsData'])
                
                for i = 1, #itemsData, 1 do
                    if (Config.AVAILABLE_ITEMS_INITED[itemsData[i].name] ~= nil) then
                        if (itemsData[i].price < 0) then
                            itemsData[i].price = 0
                        end

                        if (itemsData[i].percent < 0) then
                            itemsData[i].percent = 0
                        end

                        if (itemsData[i].percent > 100) then
                            itemsData[i].percent = 100
                        end

                        itemsData[i].label = getLabelOfItem(itemsData[i].name)
                        table.insert(cleanItemsData, itemsData[i])
                    else
                        debugMessage('Missing item: ' .. itemsData[i].name)
                    end
                end
            end
        end

        TriggerClientEvent('lls-newbill:openBossMenu_client', playerId, shopData, cleanItemsData, bossBankMoney)
    end)
end)

RegisterServerEvent('lls-newbill:saveBossData_server')
AddEventHandler('lls-newbill:saveBossData_server', function(itemsData)
    if (source == nil or itemsData == nil) then
        return
    end
    
    local esxPlayer = ESX.GetPlayerFromId(source)
    if (esxPlayer == nil) then
        return
    end

    if (Config.JOBS_INITED[esxPlayer.job.name] == nil or esxPlayer.job.grade_name ~= Config.JOBS_INITED[esxPlayer.job.name].bossGradeName) then
        return
    end

    local items = {}
    local data = {}
    for i = 1, #itemsData, 1 do
        items[itemsData[i].name] = items[itemsData[i].name] or 0
        if (items[itemsData[i].name] ~= 1) then
            if (Config.AVAILABLE_ITEMS_INITED[itemsData[i].name] ~= nil) then  
                if (type(itemsData[i].price) == 'number' and type(itemsData[i].percent) == 'number') then
                    if (itemsData[i].price < 0) then
                        itemsData[i].price = 0
                    end

                    if (itemsData[i].percent < 0) then
                        itemsData[i].price = 0
                    end

                    if (itemsData[i].percent > 100) then
                        itemsData[i].price = 100
                    end

                    table.insert(data, {name = itemsData[i].name, price = itemsData[i].price, percent = itemsData[i].percent})
                    items[itemsData[i].name] = 1
                end
            end
        end
    end

    databaseAsyncExecute('INSERT INTO newbill (shopName, shopMoney, itemsData) VALUES (@shopName, @shopMoney, @itemsData) ON DUPLICATE KEY UPDATE itemsData = @itemsData', {
        ['@shopName'] = esxPlayer.job.name,
        ['@shopMoney'] = 0,
        ['@itemsData'] = json.encode(data)
    })
end)

RegisterServerEvent('lls-newbill:withdrawBoss_server')
AddEventHandler('lls-newbill:withdrawBoss_server', function()
    local src = source

    if (src == nil) then
        return
    end
    
    local esxPlayer = ESX.GetPlayerFromId(src)
    if (esxPlayer == nil) then
        return
    end

    if (Config.JOBS_INITED[esxPlayer.job.name] == nil or esxPlayer.job.grade_name ~= Config.JOBS_INITED[esxPlayer.job.name].bossGradeName) then
        return
    end

    databaseAsyncFetchData('SELECT shopMoney FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = esxPlayer.job.name
    }, function(result)
        if (result ~= nil and result[1] ~= nil and result[1]['shopMoney'] ~= nil) then
            databaseAsyncExecute('UPDATE newbill SET shopMoney = @shopNewMoney WHERE shopName = @shopName', {
                ['@shopName'] = esxPlayer.job.name,
                ['@shopNewMoney'] = 0
            })

            addPlayerCashMoney(src, result[1]['shopMoney'])
        end
    end)
end)

-- CATALOGUE
RegisterServerEvent('lls-newbill:requestToOpenCatalogueMenu_server')
AddEventHandler('lls-newbill:requestToOpenCatalogueMenu_server', function(shopData)
    local playerId = source

    if (playerId == nil) then
        return
    end

    if (Config.JOBS_INITED[shopData.name] == nil) then
        return
    end

    databaseAsyncFetchData('SELECT itemsData FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = shopData.name
    }, function(result)
        if (result ~= nil and result[1] ~= nil and result[1]['itemsData'] ~= nil) then
            local itemsData = json.decode(result[1]['itemsData'])
            local cleanItemsData = {}

            for i = 1, #itemsData, 1 do
                if (Config.AVAILABLE_ITEMS_INITED[itemsData[i].name] ~= nil) then
                    if (itemsData[i].price < 0) then
                        itemsData[i].price = 0
                    end

                    if (itemsData[i].percent < 0) then
                        itemsData[i].percent = 0
                    end

                    if (itemsData[i].percent > 100) then
                        itemsData[i].percent = 100
                    end

                    itemsData[i].label = getLabelOfItem(itemsData[i].name)
                    table.insert(cleanItemsData, itemsData[i])
                else
                    debugMessage('Missing item: ' .. itemsData[i].name)
                end
            end

            TriggerClientEvent('lls-newbill:openCatalogueMenu_client', playerId, shopData, cleanItemsData)
        end
    end)
end)

-- SELLER
RegisterServerEvent('lls-newbill:requestToOpenSellerMenu_server')
AddEventHandler('lls-newbill:requestToOpenSellerMenu_server', function()
    local playerId = source

    if (playerId == nil) then
        return
    end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer == nil) then
        return
    end

    if (Config.JOBS_INITED[esxPlayer.job.name] == nil) then
        return
    end

    local shopData = {name = esxPlayer.job.name, label = Config.JOBS_INITED[esxPlayer.job.name].label}

    databaseAsyncFetchData('SELECT itemsData FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = shopData.name
    }, function(result)
        if (result ~= nil and result[1] ~= nil and result[1]['itemsData'] ~= nil) then
            local itemsData = json.decode(result[1]['itemsData'])
            local cleanItemsData = {}

            for i = 1, #itemsData, 1 do
                if (Config.AVAILABLE_ITEMS_INITED[itemsData[i].name] ~= nil) then
                    if (itemsData[i].price < 0) then
                        itemsData[i].price = 0
                    end

                    if (itemsData[i].percent < 0) then
                        itemsData[i].percent = 0
                    end

                    if (itemsData[i].percent > 100) then
                        itemsData[i].percent = 100
                    end

                    itemsData[i].label = getLabelOfItem(itemsData[i].name)
                    itemsData[i].hasAmount = getCountOfPlayerItem(playerId, itemsData[i].name)
                    
                    table.insert(cleanItemsData, itemsData[i])
                end
            end

            TriggerClientEvent('lls-newbill:openSellerMenu_client', playerId, shopData, cleanItemsData)
        end
    end)
end)

RegisterServerEvent('lls-newbill:requestToBill_server')
AddEventHandler('lls-newbill:requestToBill_server', function(targetId, itemsData)
    local playerId = source
    
    if (playerId == nil or targetId == nil or itemsData == nil or targetId <= 0) then
        return
    end

    if (playerId == targetId) then
        return
    end
    
    if (not GetPlayerName(targetId)) then
        return
    end
    
    if (openRequests[targetId] ~= nil) then
        showNotification(playerId, 'Customer has already an open bill.')
        return
    end

    if (#(GetEntityCoords(GetPlayerPed(targetId)) - GetEntityCoords(GetPlayerPed(playerId))) > (Config.PlayerMaxDistance + 1)) then
        showNotification(playerId, 'Customer is too far.')
        return
    end

    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer == nil) then
        return
    end

    if (Config.JOBS_INITED[esxPlayer.job.name] == nil) then
        return
    end

    local shopData = {name = esxPlayer.job.name, label = Config.JOBS_INITED[esxPlayer.job.name].label}
    
    local inputItemsData = {}
    for i = 1, #itemsData, 1 do
        if (Config.AVAILABLE_ITEMS_INITED[itemsData[i].name] ~= nil) then
            if (itemsData[i].quantity > 0) then
                local tempCount = getCountOfPlayerItem(playerId, itemsData[i].name)

                if (tempCount > 0) then
                    if (itemsData[i].quantity > tempCount) then
                        itemsData[i].quantity = tempCount
                    end

                    table.insert(inputItemsData, {name = itemsData[i].name, quantity = itemsData[i].quantity})
                end
            end
        end
    end

    databaseAsyncFetchData('SELECT itemsData FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = shopData.name
    }, function(result)
        if (result ~= nil and result[1] ~= nil and result[1]['itemsData'] ~= nil) then
            local dbItemsData = json.decode(result[1]['itemsData'])

            local dbValidItemsData = {}
            for i = 1, #inputItemsData, 1 do
                for j = 1, #dbItemsData, 1 do
                    if (inputItemsData[i].name == dbItemsData[j].name) then
                        if (Config.AVAILABLE_ITEMS_INITED[dbItemsData[j].name] ~= nil) then
                            if (dbItemsData[j].price < 0) then
                                dbItemsData[j].price = 0
                            end
                            
                            table.insert(dbValidItemsData, {name = dbItemsData[j].name, label = getLabelOfItem(dbItemsData[j].name), quantity = inputItemsData[i].quantity, price = dbItemsData[j].price, percent = dbItemsData[j].percent})
                            break
                        end
                    end
                end
            end

            openRequests[targetId] = {sellerId = playerId, itemsData = dbValidItemsData, shopData = shopData}
            TriggerClientEvent('lls-newbill:openCustomerMenu_client', targetId, openRequests[targetId].sellerId, shopData, dbValidItemsData)
        end
    end)
end)

-- CUSTOMER
RegisterServerEvent('lls-newbill:requestToOpenCustomerMenu_server')
AddEventHandler('lls-newbill:requestToOpenCustomerMenu_server', function()
    local targetId = source

    if (openRequests[targetId] == nil) then
        return
    end

    TriggerClientEvent('lls-newbill:openCustomerMenu_client', targetId, openRequests[targetId].sellerId, openRequests[targetId].shopData, openRequests[targetId].itemsData)
end)

RegisterServerEvent('lls-newbill:cancelOrder_server')
AddEventHandler('lls-newbill:cancelOrder_server', function(targerId)
    targetId = targerId or source

    if (openRequests[targetId] == nil) then
        return
    end

    local esxPlayer = ESX.GetPlayerFromId(openRequests[targetId].sellerId)
    if (esxPlayer == nil) then
        return
    end

    showNotification(openRequests[targetId].sellerId, 'Order canceled.')
    showNotification(targetId, 'Order canceled.')

    openRequests[targetId] = nil
end)

RegisterServerEvent('lls-newbill:payOrder_server')
AddEventHandler('lls-newbill:payOrder_server', function(tips)
    local targetId = source

    tips = tonumber(tips) or 0
    if (tips < 0) then
        tips = 0
    end

    if (openRequests[targetId] == nil) then
        return
    end

    if (#(GetEntityCoords(GetPlayerPed(targetId)) - GetEntityCoords(GetPlayerPed(openRequests[targetId].sellerId))) > (Config.PlayerMaxDistance + 1)) then
        TriggerEvent('lls-newbill:cancelOrder_server', targetId)
        return
    end

    local esxTargetPlayer = ESX.GetPlayerFromId(targetId)
    local esxSellerPlayer = ESX.GetPlayerFromId(openRequests[targetId].sellerId)
    if (esxTargetPlayer == nil or esxSellerPlayer == nil) then
        TriggerEvent('lls-newbill:cancelOrder_server', targetId)
        return
    end

    for i = 1, #openRequests[targetId].itemsData, 1 do
        if (Config.AVAILABLE_ITEMS_INITED[openRequests[targetId].itemsData[i].name] ~= nil) then
            if (openRequests[targetId].itemsData[i].quantity > 0) then
                if (getCountOfPlayerItem(openRequests[targetId].sellerId, openRequests[targetId].itemsData[i].name) < openRequests[targetId].itemsData[i].quantity) then
                    TriggerEvent('lls-newbill:cancelOrder_server', targetId)
                    return
                end
            end
        end
    end

    local totalMoney = math.floor(tips)
    
    for i = 1, #openRequests[targetId].itemsData, 1 do
        local tempMoney = math.floor(openRequests[targetId].itemsData[i].price * openRequests[targetId].itemsData[i].quantity)
        totalMoney = totalMoney + tempMoney
    end

    if (Config.TypeOfMoneyToUse == 4) then
        if (getPlayerBankMoney(targetId) >= totalMoney) then
            removePlayerBankMoney(targetId, totalMoney)
        elseif (getPlayerCashMoney(targetId) >= totalMoney) then
            removePlayerCashMoney(targetId, totalMoney)
        else
            TriggerEvent('lls-newbill:cancelOrder_server', targetId)

            showNotification(targetId, 'Not enough money for the order.')
            return
        end
    elseif (Config.TypeOfMoneyToUse == 3) then
        if (getPlayerCashMoney(targetId) >= totalMoney) then
            removePlayerCashMoney(targetId, totalMoney)
        elseif (getPlayerBankMoney(targetId) >= totalMoney) then
            removePlayerBankMoney(targetId, totalMoney)
        else
            TriggerEvent('lls-newbill:cancelOrder_server', targetId)

            showNotification(targetId, 'Not enough money for the order.')
            return
        end
    elseif (Config.TypeOfMoneyToUse == 2) then
        if (getPlayerBankMoney(targetId) >= totalMoney) then
            removePlayerBankMoney(targetId, totalMoney)
        else
            TriggerEvent('lls-newbill:cancelOrder_server', targetId)

            showNotification(targetId, 'Not enough money for the order.')
            return
        end
    elseif (Config.TypeOfMoneyToUse == 1) then
        if (getPlayerCashMoney(targetId) >= totalMoney) then
            removePlayerCashMoney(targetId, totalMoney)
        else
            TriggerEvent('lls-newbill:cancelOrder_server', targetId)

            showNotification(targetId, 'Not enough money for the order.')
            return
        end
    else
        TriggerEvent('lls-newbill:cancelOrder_server', targetId)

        debugMessage('Not a valid money type')
        return
    end

    local bossMoney = 0
    local sellerMoney = 0

    for i = 1, #openRequests[targetId].itemsData, 1 do
        addPlayerItem(targetId, openRequests[targetId].itemsData[i].name, openRequests[targetId].itemsData[i].quantity)
        removePlayerItem(openRequests[targetId].sellerId, openRequests[targetId].itemsData[i].name, openRequests[targetId].itemsData[i].quantity)

        local tempMoney = math.floor(openRequests[targetId].itemsData[i].price * openRequests[targetId].itemsData[i].quantity)
                
        bossMoney = bossMoney + math.floor((tempMoney * openRequests[targetId].itemsData[i].percent / 100))
        sellerMoney = sellerMoney + math.floor((tempMoney * (1.0 -  openRequests[targetId].itemsData[i].percent / 100)))
    end
    
    addPlayerCashMoney(openRequests[targetId].sellerId, (sellerMoney + tips))
    
    local requestJob = openRequests[targetId].shopData.name
    databaseAsyncFetchData('SELECT shopMoney FROM newbill WHERE shopName = @shopName', {
        ['@shopName'] = requestJob
    }, function(result)
        if (result ~= nil and result[1] ~= nil and result[1]['shopMoney'] ~= nil) then
            databaseAsyncExecute('UPDATE newbill SET shopMoney = @shopNewMoney WHERE shopName = @shopName', {
                ['@shopName'] = requestJob,
                ['@shopNewMoney'] = result[1]['shopMoney'] + bossMoney
            })
        end
    end)
    
    if (tips > 0) then
        showNotification(openRequests[targetId].sellerId, 'Customer paid the order. $' .. totalMoney .. ' + tips $' .. tips .. '!')
    else
        showNotification(openRequests[targetId].sellerId, 'Customer paid the order. $' .. totalMoney .. '!')
    end

    showNotification(targetId, 'You paid the order. $' .. totalMoney .. '!')

    openRequests[targetId] = nil
end)

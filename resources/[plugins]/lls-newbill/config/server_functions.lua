--[[
    Do NOT REMOVE any of the functions
    Do NOT RENAME any of the functions
    Do NOT CHANGE any of the parameters of any function

    You can change the code inside the functions to use your base, inventory etc. at your own risk, not support will be given at this
]]

--[[
    Displays notification
        playerId : the server player's id
        msg : the text to display in the notification
]]
function showNotification(playerId, msg)
    playerId = tonumber(playerId)

    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not msg) then return end

    TriggerClientEvent('lls-newbill:cl:showNotification', playerId, msg)
end

--[[
    Returns the current player cash money
        playerId : the server player's id
]]
function getPlayerCashMoney(playerId) -- 
    playerId = tonumber(playerId)

    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return 0 end

    if (not ESX) then return 0 end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        return esxPlayer.getMoney()
    end

    return 0
end

--[[
    Adds cash money to the current balance of the player
        playerId : the server player's id
        amount : the amount of the cash to add
]]
function addPlayerCashMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount) then return end

    if (not ESX) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.addMoney(amount)
    end
end

--[[
    Removes cash money from the current balance of the player
        playerId : the server player's id
        amount : the amount of the cash to remove
]]
function removePlayerCashMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount) then return end

    if (not ESX) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.removeMoney(amount)
    end
end

--[[
    Returns the current player bank money
        playerId : the server player's id
]]
function getPlayerBankMoney(playerId) -- returns the current player bank money
    playerId = tonumber(playerId)
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return 0 end

    if (not ESX) then return 0 end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        return esxPlayer.getAccount('bank').money
    end

    return 0
end

--[[
    Removes bank money from the current balance of the player
        playerId : the server player's id
        amount : the amount of the bank money to remove
]]
function removePlayerBankMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount) then return end

    if (not ESX) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.removeAccountMoney('bank', amount)
    end
end

--[[
    Returns the label (display name) of the item (by default uses the Config.AvailableItems)
        itemName : the item name
]]
function getLabelOfItem(itemName)
    if (not itemName) then return '' end
    if (not Config.AVAILABLE_ITEMS_INITED[itemName]) then return end

    return Config.AVAILABLE_ITEMS_INITED[itemName].label
end

--[[
    Returns amount of an item that player has on him
        playerId : the server player's id
        itemName : the item name
]]
function getCountOfPlayerItem(playerId, itemName)
    playerId = tonumber(playerId)
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return 0 end
    if (not itemName) then return 0 end

    if (not ESX) then return 0 end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        return esxPlayer.getInventoryItem(itemName).count
    end

    return 0
end

--[[
    Adds items on the player's inventory
        playerId : the server player's id
        itemName : the item name
        itemAmount : the amount of the item
]]
function addPlayerItem(playerId, itemName, itemAmount)
    playerId = tonumber(playerId)
    itemAmount = tonumber(itemAmount)

    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not itemName) then return end
    if (not itemAmount or itemAmount < 1) then return end

    if (not ESX) then return end

    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.addInventoryItem(itemName, itemAmount)
    end
end

--[[
    Removes items of the player's inventory
        playerId : the server player's id
        itemName : the item name
        itemAmount : the amount of the item
]]
function removePlayerItem(playerId, itemName, itemAmount)
    playerId = tonumber(playerId)
    itemAmount = tonumber(itemAmount)

    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not itemName) then return end
    if (not itemAmount or itemAmount < 1) then return end

    if (not ESX) then return end

    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.removeInventoryItem(itemName, itemAmount)
    end
end

--[[
    Fetch Data from the database
        query : the sql query to execute
        parameters : the parameters to pass in the query safer
        callbackFunction : the function to call asynchronous after the query finishes, uses up to one parameter 
]]
function databaseAsyncFetchData(query, parameters, callbackFunction)
    if (not query) then return end

    MySQL.Async.fetchAll(query,
        parameters ~= nil and parameters or {},
        function(result)
            if (callbackFunction ~= nil) then
                callbackFunction(result)
            end
        end
    )
end

--[[
    Execute query to the database
        query : the sql query to execute
        parameters : the parameters to pass in the query safer
        callbackFunction : the function to call asynchronous after the query finishes, uses up to one parameter 
]]
function databaseAsyncExecute(query, parameters, callbackFunction)
    if (not query) then return end

    MySQL.Async.execute(query,
        parameters ~= nil and parameters or {},
        function(result)
            if (callbackFunction ~= nil) then
                callbackFunction(result)
            end
        end
    )
end

--[[
    Debug Messages to print in the control for errors or other feedback a developer can use, turn it on in the Config file (Config.enableDebugMessages) only for testing purposes
        msg : the message to display
]]
function debugMessage(msg)
    if (not Config.enableDebugMessages) then return end
    if (not msg) then return end

    print('[lls-newbill] ' .. msg)
end
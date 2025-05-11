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
function showNotification(msg)
    if (not msg) then return end

    if (not ESX) then return end

    ESX.ShowNotification(msg)
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
--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

CreateThread(function()
    RegisterCommand('catalogue', function()
        requestToOpenCatalogueMenu()
    end)
    TriggerEvent('chat:addSuggestion', '/catalogue', 'Show catalogue of near shop.')

    RegisterCommand('bill', function()
        requestToOpenSellerMenu()
    end)
    TriggerEvent('chat:addSuggestion', '/bill', 'Open employee bill.')

    RegisterCommand('billboss', function()
        requestToOpenBossMenu()
    end)
    TriggerEvent('chat:addSuggestion', '/billboss', 'Open boss bill.')

    RegisterCommand('oldbill', function()
        requestToOpenCustomerMenu()
    end)
    TriggerEvent('chat:addSuggestion', '/oldbill', 'Open customer pending bill.')

    if (Config.enableKeyMapping) then
        RegisterKeyMapping('catalogue', 'Show catalogue of near shop', 'keyboard', Config.keyMappingDefaultKeys.catalogue)
        RegisterKeyMapping('bill', 'Open employee bill', 'keyboard', Config.keyMappingDefaultKeys.bill)
        RegisterKeyMapping('billboss', 'Open boss bill', 'keyboard', Config.keyMappingDefaultKeys.billboss)
        RegisterKeyMapping('oldbill', 'Open customer pending bill', 'keyboard', Config.keyMappingDefaultKeys.oldbill)
    end
end)
AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    if name == "cigsredwood" then Core.AddItem(playerId, "cigarette", 1) end
    
    if name == "cigarette" then
        local myLighter = exports.ox_inventory:Search(playerId, "slots", "lighter")
        
        if #myLighter > 1 then myLighter = myLighter[math.random(1, #myLighter)] else myLighter = myLighter[1] end
        
        if myLighter and myLighter.metadata.gas > 0 then
            myLighter.metadata.gas = myLighter.metadata.gas - 0.5
            exports.ox_inventory:SetMetadata(playerId, myLighter.slot, myLighter.metadata)
            exports.ox_inventory:SetDurability(playerId, myLighter.slot, myLighter.metadata.gas)
            exports.ox_inventory:RemoveItem(playerId, name, 1, nil, slotId)
            -- TriggerClientEvent("n_snippets:animations:startSmoking", playerId)
        else
            Core.Notify(playerId, "You need fire to light your cig lawl", "error", 3500)
        end
    end
    
end)

local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
    payload.metadata.gas = 100
    return payload.metadata
end, {
    itemFilter = {
        lighter = true
    }
})
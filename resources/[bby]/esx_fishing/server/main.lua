local Baits = {
    ["Fish"] = "fishingbait",
    ["Shrimps"] = "shrimps",
    ["Turtle"] = "turtle",
    ["No attached fishing bait"] = "none",
}

RegisterNetEvent('esx_fishing:server:ReceiveFish', function(zone, rodId, metadata)
    local xPlayer = ESX.GetPlayerFromId(source)
    local myRod = exports.ox_inventory:GetSlotWithItem(xPlayer.source, 'fishingrod', { fishing_bait = metadata.fishing_bait })

    if myRod and myRod.metadata.fishing_bait then
        local baitItem = Baits[myRod.metadata.fishing_bait]
        local zone = tonumber(zone)
        local source = tonumber(source)
        local itemTable = Config.DefaultItems
        local maxChance = Config.DefaultMaxChance

        -- if zone and Config.FishingZones[zone] and Config.FishingZones[zone].Items then
        --     itemTable = Config.FishingZones[zone].Items
        -- end

        -- if zone and Config.FishingZones[zone] and Config.FishingZones[zone].MaxChance then
        --     maxChance = Config.FishingZones[zone].MaxChance
        -- end

        itemTable = shuffle(itemTable)
        
        for i = 1, Config.RetryCount, 1 do
            local item = itemTable[math.random(1, #itemTable)]
            local random = math.random(1, maxChance)
            if item.baits[baitItem] and item.chance >= random then
                if exports.ox_inventory:GetItem(xPlayer.source, baitItem, nil, true) > 0 then
                    exports.ox_inventory:RemoveItem(xPlayer.source, baitItem, 1)
                else
                    xPlayer.showNotification("You've run out of bait. Fishing stopped.", "error", 5500)
                    myRod.metadata.fishing_bait = nil
                    exports.ox_inventory:SetMetadata(xPlayer.source, myRod.slot, myRod.metadata)
                end

                if xPlayer.canCarryItem(item.name, 1) then
                    xPlayer.addInventoryItem(item.name, 1)
                    xPlayer.showNotification("You caught something!", "success", 5500)
                else
                    exports.ox_inventory:CustomDrop('No Inventory Space', {{item.name, 1}}, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                    xPlayer.showNotification("You cant pick up the catch, items droped on the ground", "error", 10000)
                end
                return
            end
        end

        if exports.ox_inventory:GetItem(xPlayer.source, baitItem, nil, true) > 0 then
            exports.ox_inventory:RemoveItem(xPlayer.source, baitItem, 1)
        else
            xPlayer.showNotification("You've run out of bait. Fishing stopped.", "error", 5500)
            myRod.metadata.fishing_bait = nil
            exports.ox_inventory:SetMetadata(xPlayer.source, myRod.slot, myRod.metadata)
        end
        xPlayer.showNotification("You didn't catch anything this time.", "info", 5500)
    else
        xPlayer.showNotification("Your fishing rod doesn't have any bait attached.", "error", 5500)
    end
end)

AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    if name == "fishingrod" then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        
        if not metadata or not metadata.fishing_bait then 
            xPlayer.showNotification("You need to attach bait to your rod first", "error", 3500)
            return
        end

        TriggerClientEvent('esx_fishing:client:FishingRod', xPlayer.source, slotId, metadata)
    end
end)

for baitLabel, baitItemName in pairs(Baits) do
    ESX.RegisterUsableItem(baitItemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local myRods = exports.ox_inventory:Search(xPlayer.source, "slots", "fishingrod")
        
        if #myRods == 0 then
            xPlayer.showNotification("You need a fishing rod to attach bait", "error", 3500)
            return
        end
        
        local myRod = exports.ox_inventory:GetSlot(xPlayer.source, myRods[1].slot)
        

        if myRod.metadata and myRod.metadata.fishing_bait then
            if myRod.metadata.fishing_bait == baitLabel then
                exports.n_snippets:Notify(xPlayer.source, "Already got " .. myRod.metadata.fishing_bait .. " as bait", "error", 3500, "Fishing Rod")
                return
            elseif myRod.metadata.fishing_bait ~= baitLabel then
                exports.ox_inventory:AddItem(xPlayer.source, Baits[myRod.metadata.fishing_bait], 1)
                exports.n_snippets:Notify(xPlayer.source, "Removed " .. myRod.metadata.fishing_bait .. " from the rod", "info", 3500, "Fishing Rod")
            end
        end
        
        TriggerClientEvent("esx_fishing:placeBaitAnim", xPlayer.source)
        exports.ox_inventory:RemoveItem(xPlayer.source, baitItemName, 1)
        myRod.metadata.fishing_bait = baitLabel
        exports.ox_inventory:SetMetadata(xPlayer.source, myRod.slot, myRod.metadata)
        exports.n_snippets:Notify(xPlayer.source, "Bait " .. baitLabel .. " attached to " .. myRod.label, "info", 3500, "Fishing Rod")
    end)
end

local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
    payload.metadata.fishing_bait = false
    return payload.metadata
end, {
    itemFilter = {
        fishingrod = true
    }
})

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end
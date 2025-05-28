banPlayer = function(ban_type, script, ban_reason)
    print("Ban attempt "..ban_type..' from '..script..' as '..ban_reason)
end

GiveHuntingRewards = function(playerId, animalWeight)
    local src = playerId
    local xPlayer = ESX.GetPlayerFromId(src)
    
    -- Define the possible items to reward
    local items = {
        "meat",
        "skin_deer_medium",
        "deer_horn"
    }
    
    -- Iterate through each item and give a random quantity
    for _, item in ipairs(items) do
        local itemQuantity = math.random(1, 3) -- Random number between 1 and 3
        xPlayer.addInventoryItem(item, itemQuantity)
        
        -- Send a notification to the player for each item
        TriggerClientEvent('esx:showNotification', src, "You received " .. itemQuantity .. "x " .. item .. " for the hunt.")
    end
end



RegisterNetEvent('esx_fishing:server:ReceiveFish', function(zone)
    local src = source
    local zone = tonumber(zone)
    local xPlayer = ESX.GetPlayerFromId(src)
    if fishing[xPlayer.identifier] then
        if fishing[xPlayer.identifier] > 5 then
            print("Player "..GetPlayerName(src)..' - ('..src..') - '..xPlayer.identifier..' caught cheating in fishing. Should ban? (Spammed)')
            banPlayer("cheater", "fishing", "Too fast fish gathering")
            return
        end
    end
    if not fishing[xPlayer.identifier] then
        fishing[xPlayer.identifier] = 1
    else
        fishing[xPlayer.identifier] = fishing[xPlayer.identifier] + 1
    end
    if not IsCloseToFishingRod(src) then
        banPlayer("cheater", "fishing", "Away from location")
        local coords = GetEntityCoords(GetPlayerPed(src))
        print("Player "..GetPlayerName(src)..' - ('..src..') - '..xPlayer.identifier..' caught cheating in fishing. Should ban? (Away from location) Coords: vector3('..coords.x..", "..coords.y..', '..coords.z..")")
        return
    end
    local locationData = Config.Jobs["fishing"]
    local itemTable = locationData.DefaultItems
    local maxChance = locationData.DefaultMaxChance
    if zone and locationData.FishingZones[zone] and locationData.FishingZones[zone].Items then
        itemTable = locationData.FishingZones[zone].Items
    end
    if zone and locationData.FishingZones[zone] and locationData.FishingZones[zone].MaxChance then
        maxChance = locationData.FishingZones[zone].MaxChance
    end
    itemTable = shuffle(itemTable)
    SetTimeout(2000, function()
        fishing[xPlayer.identifier] = fishing[xPlayer.identifier] - 1 
    end)
    local givenItem = false
    for i = 1, locationData.RetryCount, 1 do
        local item = itemTable[math.random(1, #itemTable)]
        local random = math.random(1, maxChance)

        if random >= item.chance and not givenItem then
            if xPlayer.canCarryItem(item.name, 1) then
                xPlayer.addInventoryItem(item.name, 1)
            else
                local items = {
                    { item.name, 1 }
                }
                -- exports.inventory:CreateSVDrop(src, items)
                exports.ox_inventory:CustomDrop('Dropped Items', items, xPlayer.getCoords())
                xPlayer.triggerEvent("jobs:ShowNotification", locationData.notifications["cannot_carry_item"], 5000, "error")
            end
            givenItem = true
            break
        end
    end
    if not givenItem then
        local alternativeItems = {
            {name = "empty_bottle", chance = 60},
            {name = "ring", chance = 10},
<<<<<<< Updated upstream:ak47base/[backup]/sal_jobs/server/editable.lua
            -- {name = "rolex", chance = 10}
        }

        local function getRandomItem()
            local randomValue = math.random(1, 100)

            for _, item in ipairs(alternativeItems) do
                if randomValue <= item.chance then
                    return item.name
                end
            end

            return nil 
        end

=======
            {name = "rolex", chance = 10}
        }

        local function getRandomItem()
              local randomValue = math.random(1, 100)
              local cumulativeChance = 0

              for _, item in ipairs(alternativeItems) do
                cumulativeChance = cumulativeChance + item.chance
                if randomValue <= cumulativeChance then
                    return item.name
                end
              end

              return nil
            
        end


>>>>>>> Stashed changes:ak47base/resources/[jobs]/sal_jobs/server/editable.lua
        local selectedItems = getRandomItem()

        if selectedItems then
            xPlayer.addInventoryItem(selectedItems, 1)
        else   
            print("test")
        end
    end
end)

ESX.RegisterUsableItem('fishingrod', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local locationData = Config.Jobs['fishing']
    local cur_item = exports.ox_inventory:GetItemCount(source, locationData.baititem.name)
    
    if cur_item and cur_item > 0 then
        xPlayer.removeInventoryItem(locationData.baititem.name, locationData.baititem.amount)
        TriggerClientEvent('esx_fishing:client:FishingRod', source)
    else
        xPlayer.triggerEvent("jobs:ShowNotification", locationData.notifications["need_fishing_bait"], 3000, "error")
    end
end)
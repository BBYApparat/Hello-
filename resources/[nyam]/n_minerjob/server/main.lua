RegisterNetEvent("n_minerjob:rockDestroyed", function(rock, zoneId)
    local _source = source
    local Player = Core.GetPlayer(_source)
    local MyCoords = GetEntityCoords(GetPlayerPed(_source))

    if not rock.coords then 
        print(Player.identifier, 'ban me', 'miner job 1')
        return
    end

    if rock.coords and #(MyCoords-rock.coords) > 15.0 then
        print(Player.identifier, 'ban me', 'miner job 2')
        return
    end

    if not zoneId then
        print(Player.identifier, 'ban me', 'miner job 3')
        return
    end

    local ItemsLost = {}
    
    for i = 1, math.random(Config.Options.minItems, Config.Options.maxItems) do
        local randomIndex = math.random(1, #Config.Mining.items[zoneId])
        local item = Config.Mining.items[zoneId][randomIndex]

        local AmoutToGive = math.random(item.amount.min, item.amount.max)

        if Player.canCarryItem(item.name, AmoutToGive) then
            Core.AddItem(_source, item.name, AmoutToGive)
        else
            local ItemData = exports.ox_inventory:Items(item.name)
            if not ItemData.stack then
                for i = 1, AmoutToGive do
                    ItemsLost[#ItemsLost+1] = {item.name, 1}
                end
            else
                ItemsLost[#ItemsLost+1] = {item.name, AmoutToGive}
            end
        end
    end
    
    if #ItemsLost > 0 then
        Core.Notify(_source, Lang("error.no_inventory_space"), "error", 10000)
        exports.ox_inventory:CustomDrop('No Inventory Space', ItemsLost, MyCoords)
    end
end)
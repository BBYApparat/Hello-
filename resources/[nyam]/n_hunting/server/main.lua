RegisterNetEvent("n_hunting:harvestedAnimal", function(animalType)
    local _source = source
    local Player = Core.GetPlayer(_source)
    local MyCoords = GetEntityCoords(GetPlayerPed(_source))
    local ItemsLost = {}

    for index, item in pairs(Config.Animals[string.lower(animalType)].reward) do
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
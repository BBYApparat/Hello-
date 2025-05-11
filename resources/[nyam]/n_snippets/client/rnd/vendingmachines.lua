function TryBuyFromVendingMachine(entity, machine)

    if exports.ox_inventory:GetItemCount("money") >= Config.VendingMachines[machine].price then

        Core.MakeEntityFaceEntity(cache.ped, entity)
        RequestAmbientAudioBank("VENDING_MACHINE")
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
        Core.RequestAnim("mp_common_miss")
        Core.RequestAnim("mini@sprunk")
        
        TaskPlayAnim(cache.ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
        Wait(4750)
        TaskPlayAnim(cache.ped, "mp_common_miss", "put_away_coke", 8.0, 5.0, -1, true, 1, 0, 0, 0)
        
        Wait(350)
        
        ClearPedTasks(cache.ped)
        ReleaseAmbientAudioBank()

        RemoveAnimDict("mini@sprunk")
        RemoveAnimDict("mp_common_miss")

        TriggerServerEvent("n_vendingmachines:afterEmote", machine)

    else
        Core.Notify(Lang("error.not_enough_money", {reqMoney = Config.VendingMachines[machine].price}), "error", 5000)
    end
end

CreateThread(function()
    local models = {}
    
    for objectId in pairs(Config.VendingMachines) do models[#models+1] = objectId end
    
    exports.ox_target:addModel(models, {
        {
            icon = 'fas fa-coins',
            label = 'Use Vending Machine',
            --    return exports.ox_inventory:GetItemCount("money") >= Config.VendingMachines[GetEntityModel(entity)].price
            distance = 0.9,
            onSelect = function(data)
                TryBuyFromVendingMachine(data.entity, GetEntityModel(data.entity))
            end
        },
    })
end)
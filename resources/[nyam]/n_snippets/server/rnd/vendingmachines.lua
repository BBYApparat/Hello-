RegisterNetEvent("n_vendingmachines:afterEmote", function(machine)
    local xPlayer = Core.GetPlayer(source)
    
    if Core.GetMoney(source, "money") >= Config.VendingMachines[machine].price then
        for i = 1, #Config.VendingMachines[machine].items do
            Core.AddItem(source, Config.VendingMachines[machine].items[i].name, Config.VendingMachines[machine].items[i].amount)
        end
        Core.RemoveMoney(source, "money", Config.VendingMachines[machine].price, "Vending Machine")
    end
end)
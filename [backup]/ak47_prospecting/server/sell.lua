RegisterServerEvent('ak47_prospecting:sell')
AddEventHandler('ak47_prospecting:sell', function(itemName, amount, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = price
    local xItem = xPlayer.getInventoryItem(itemName)
    if not price then
        return
    end
    if xItem and xItem.count < amount then
        TriggerClientEvent('ak47_prospecting:notify', xPlayer.source, _U('not_enough'))
        return
    end
    price = ESX.Math.Round(price * amount)
    xPlayer.addMoney(price)
    xPlayer.removeInventoryItem(xItem.name, amount)
    TriggerClientEvent('ak47_prospecting:notify', xPlayer.source, _U('sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)
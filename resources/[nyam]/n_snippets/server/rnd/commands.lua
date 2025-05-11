ESX.RegisterCommand('mymetadata', "superadmin", function(xPlayer, args)
    print(DumpTable(xPlayer.metadata))
end, true, {
    help = "Check your Metadata",
    validate = true
})

ESX.RegisterCommand('slotmetadata', "superadmin", function(xPlayer, args)
    print(DumpTable(exports.ox_inventory:GetSlot(xPlayer.source, tonumber(args.slotId))))
end, true, {
    help = "Check your state ID",
    validate = true,
    arguments = {
        {name = "slotId", help = "Desired Slot ID", type = "number"}
    }
})

ESX.RegisterCommand('id', "user", function(xPlayer, args)
    xPlayer.showNotification("State ID: " .. xPlayer.source, "info", 3500)
end, true, {
    help = "Check your state ID",
    validate = true
})

ESX.RegisterCommand('clearinventory', "admin", function(xPlayer, args)
    local _source = source
	local xTarget = args.playerId
    local xPlayer = xPlayer
    
    if xTarget then
        exports.ox_inventory:ClearInventory(xTarget.source)
        xPlayer.showNotification(Lang("inventory.target_inventory_wiped", {playerId = args.playerId.name}), 'info', 5000)
        xTarget.showNotification(Lang("inventory.my_inventory_wiped"), 'info', 5000)
    else
        xPlayer.showNotification(Lang("error.target_not_online", {playerId = args.playerId}), 'error', 5000)
    end
end, true, {
    help = "Clear target's inventory",
    validate = false,
    arguments = {
        { name = "playerId", help = Lang("commands.player_target"), type = "player" }
    }
})

ESX.RegisterCommand('adminkey', "admin", function(xPlayer, args)
    local _source = source
	local xTarget = args.playerId
    TriggerClientEvent("n_snippts:adminKey", xTarget.source, true)
end, true, {
    help = "Give keys to target from his current driving vehicle",
    validate = false,
    arguments = {
        { name = "playerId", help = Lang("commands.player_target"), type = "player" }
    }
})
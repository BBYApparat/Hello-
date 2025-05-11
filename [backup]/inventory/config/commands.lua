Config.Commands = {
    rob = { cmdName = "rob", minGroup = "user" }, --Inventory Player Search Command. No Params
    weaponrep = { cmdName = "repairweapon", minGroup = "superadmin" }, -- Inventory Admin Weapon Repair Command. No Params
    fixui = { cmdName = "fixui"} -- This fixes the ui if a player has a low pc and the inventory is stucked on his screen (Never happened but to be safe.) Check functions.lua fixUi function
}

Config.Mappings = {
    openinventory = { cmdName = "openinv", key = "TAB", label = "Open Inventory"},
    hotbar = { cmdName = "hotbar", key = "z", label = "Toggle keybind slots"}
}
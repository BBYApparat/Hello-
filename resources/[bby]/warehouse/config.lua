Config = {}

-- Framework Settings
Config.Framework = 'esx' -- esx only
Config.Inventory = 'ox' -- ox_inventory only
Config.Target = 'ox' -- ox_target only

-- Warehouse Settings
Config.WareHouseSellPrice = 5000
Config.RefreshBlipInterval = 6 -- In Hours
Config.RentPeriod = 7 -- Days
Config.Debug = false

-- Admin Settings
Config.AdminGroups = {'admin', 'superadmin'} -- ESX groups that can manage warehouses

-- Default Warehouse Settings
Config.DefaultSettings = {
    stashsize = 3000000, -- 3000kg in grams
    slots = 50,
    price = 50000,
    password = "changeme"
}

-- Upgrade Costs
Config.Upgradation = {
    StashSize = {
        ["500 Kg"] = 50000,
        ["1000 Kg"] = 100000,
        ["1500 Kg"] = 200000,
    },
    Slots = {
        ["+20"] = 10000,
        ["+40"] = 20000,
        ["+60"] = 30000,
    },
}

-- Interior Coordinates (MLO or Custom Interiors)
Config.Interiors = {
    warehouse_small = {
        spawn = vector4(1088.0, -3099.0, -39.0, 90.0),
        exit = vector4(1092.0, -3099.0, -39.0, 270.0),
        stash = vector3(1085.0, -3095.0, -39.0),
    },
    warehouse_medium = {
        spawn = vector4(1088.0, -3099.0, -39.0, 90.0),
        exit = vector4(1092.0, -3099.0, -39.0, 270.0),
        stash = vector3(1085.0, -3095.0, -39.0),
    },
    warehouse_large = {
        spawn = vector4(1088.0, -3099.0, -39.0, 90.0),
        exit = vector4(1092.0, -3099.0, -39.0, 270.0),
        stash = vector3(1085.0, -3095.0, -39.0),
    }
}

-- Warehouse Locations (Admin created warehouses will be stored in database)
Config.WareHouses = {
    -- Example warehouses - these will be created by admins in-game
    -- [1] = {
    --     outside = vector4(912.16, -2174.31, 30.49, 267.01),
    --     interior_type = "warehouse_small",
    --     owner = nil,
    --     password = "admin123",
    --     price = 50000,
    --     stashsize = 3000000,
    --     slots = 50,
    --     owned = false,
    --     date_purchased = nil,
    --     passwordset = true
    -- }
}

-- Notification function
function ShowNotification(message, type, duration)
    if Config.Framework == 'esx' then
        ESX.ShowNotification(message, type, duration or 5000)
    end
end
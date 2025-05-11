Config.Warehouses = {
    ["pistols"] = {
        label = "Pistols & Attachments",
        items = {
            {
                name = "pistol_stock",
                costs = {
                    { name = "steel",  count = 100 },
                    { name = "copper", count = 100 },
                    { name = "scrap",  count = 100 },
                },
            },
            {
                name = "pistol_frame",
                costs = {
                    { name = "steel", count = 50 },
                    { name = "scrap", count = 50 },
                    { name = "copper", count = 50 },
                },
            },
            {
                name = "weapon_appistol",
                costs = {
                    { name = "pistol_stock", count = 1 },
                    { name = "pistol_frame", count = 1 },
                },
            },
            {
                name = "weapon_heavypistol",
                costs = {
                    { name = "pistol_stock", count = 1 },
                    { name = "pistol_frame", count = 1 },
                },
            },
            {
                name = "weapon_pistol50",
                costs = {
                    { name = "pistol_stock", count = 1 },
                    { name = "pistol_frame", count = 1 },
                },
            },
            {
                name = "weapon_vintagepistol",
                costs = {
                    { name = "pistol_stock", count = 1 },
                    { name = "pistol_frame", count = 1 },
                },
            },
            {
                name = "weapon_machinepistol",
                costs = {
                    { name = "pistol_stock", count = 1 },
                    { name = "pistol_frame", count = 1 },
                },
            },
        }
    },
    ["smg"] = {
        label = "SMG's & Attachments",
        items = {
            {
                name = "smg_barrel", 
                label = "SMG Barrel",
                costs = {
                    { name = "steel", count = 50 },
                    { name = "scrap", count = 50 },
                    { name = "copper", count = 50 },
                },
            },
            {
                name = "smg_receiver", 
                label = "SMG Receiver",
                costs = {
                    { name = "steel", count = 40 },
                    { name = "scrap", count = 40 },
                    { name = "copper", count = 40 },
                },
            },
            {
                name = "smg_stock", 
                label = "SMG Stock",
                costs = {
                    { name = "steel",  count = 30 },
                    { name = "copper", count = 40 },
                    { name = "scrap",  count = 40 },
                },
            },
            {
                name = "smg_magazine", 
                label = "SMG Magazine",
                costs = {
                    { name = "steel", count = 50 },
                    { name = "scrap", count = 50 },
                    { name = "copper", count = 50 },
                },
            },
            {
                name = "weapon_microsmg", 
                label = "Micro SMG",
                costs = {
                    { name = "smg_barrel", count = 1 },
                    { name = "smg_receiver", count = 1 },
                    { name = "smg_stock", count = 1 },
                    { name = "smg_magazine", count = 1 },
                },
            },
            {
                name = "weapon_smg", 
                label = "SMG",
                costs = {
                    { name = "smg_barrel", count = 1 },
                    { name = "smg_receiver", count = 1 },
                    { name = "smg_stock", count = 1 },
                    { name = "smg_magazine", count = 1 },
                },
            },
            {
                name = "weapon_assaultsmg", 
                label = "Assault SMG",
                costs = {
                    { name = "smg_barrel", count = 1 },
                    { name = "smg_receiver", count = 1 },
                    { name = "smg_stock", count = 1 },
                    { name = "smg_magazine", count = 1 },
                },
            },
        }
    },
    ["heavy"] = {
        label = "Heavy Weapons & Attachments",
        items = {
            {
                name = "sg_barrel",
                costs = {
                    { name = "steel", count = 150 },
                    { name = "scrap", count = 150 },
                    { name = "copper", count = 150 },
                },
            },
            {
                name = "sg_chamber",
                costs = {
                    { name = "steel", count = 100 },
                    { name = "scrap", count = 100 },
                    { name = "copper", count = 100 },
                },
            },
            {
                name = "sg_comb",
                costs = {
                    { name = "steel", count = 100 },
                    { name = "scrap", count = 100 },
                    { name = "copper", count = 100 },
                },
            },
            {
                name = "weapon_combatmg",
                costs = {
                    { name = "smg_barrel", count = 1 },
                    { name = "smg_receiver", count = 1 },
                    { name = "smg_stock", count = 1 },
                    { name = "smg_magazine", count = 1 },
                },
            },
            {
                name = "weapon_gusenberg",
                costs = {
                    { name = "smg_barrel", count = 1 },
                    { name = "smg_receiver", count = 1 },
                    { name = "smg_stock", count = 1 },
                    { name = "smg_magazine", count = 1 },
                },
            },
            {
                name = "weapon_sawnoffshotgun",
                costs = {
                    { name = "sg_chamber", count = 1 },
                    { name = "sg_comb", count = 1 },
                    { name = "sg_barrel", count = 1 },
                },
            },
            {
                name = "weapon_heavyshotgun",
                costs = {
                    { name = "sg_chamber", count = 1 },
                    { name = "sg_comb", count = 1 },
                    { name = "sg_barrel", count = 1 },
                },
            },
        }
    },
    ["rifles"] = {
        label = "Rifles & Attachments",
        items = {
            {
                name = "ar_barrel",
                costs = {},
            },
            {
                name = "ar_receiver",
                costs = {},
            },
            {
                name = "ar_stock",
                costs = {},
            },
            {
                name = "ar_magazine",
                costs = {},
            },
            {
                name = "weapon_assaultrifle",
                costs = {
                    { name = "ar_barrel", count = 1 },
                    { name = "ar_receiver", count = 1 },
                    { name = "ar_stock", count = 1 },
                    { name = "ar_magazine", count = 1 },
                },
            },
            {
                name = "weapon_bullpuprifle",
                costs = {
                    { name = "ar_barrel", count = 1 },
                    { name = "ar_receiver", count = 1 },
                    { name = "ar_stock", count = 1 },
                    { name = "ar_magazine", count = 1 },
                },
            },
        }
    },
    ["utilities"] = {
        label = "Utilities & Throwables",
        items = {
            {
                name = "weapon_grenade",
                costs = {}
            },
            {
                name = "weapon_molotov",
                costs = {}
            },
            {
                name = "weapon_bzgas",
                costs = {}
            },
        }
    }
}

Config.WarehouseLocations = {
    { door = {x = -775.17, y = -2632.19, z = 13.94}, warehouseId = "pistols" },
    { door = {x = 947.08, y = -1250.28, z = 27.08}, warehouseId = "smg"       },
    -- { door = {x = 1197.25, y = -3253.41, z = 7.10}, warehouseId = "heavy"     },
    -- { door = {}, warehouseId = "rifles"    },
    -- { door = {x = 1123.16, y = -1304.61, z = 34.72}, warehouseId = "utilities" },
}
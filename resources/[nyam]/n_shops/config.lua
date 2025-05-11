Config = {}
Config.UseTruckerJob = true -- true = The shops stock is based on when truckers refill it | false = shop inventory never runs out
Config.UseTarget = true -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)
Config.FirearmsLicenseCheck = false -- Whether a arms dealer checks for a firearms license
Config.ShopsInvJsonFile = './json/shops-inventory.json' -- json file location
Config.SellCasinoChips = {
    coords = vector4(950.37, 34.72, 71.87, 33.82),
    radius = 1.5,
    ped = 's_m_y_casino_01'
}
Config.Products = {
    ["seller_vangelico"] = {
        [1] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "silverchain", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [2] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "silver_ring", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [3] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "ruby_ring_silver", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [4] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "ruby_ring_gold", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [5] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "diamond_ring_silver", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [6] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "diamond_necklace_silver", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [7] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "diamond_earring_silver", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
    },
    ["huntingtrader"] = {
        [1] = {
            name = "weapon_dagger",
            amount = 9999,
            price = 300,
            info = {},
            type = "item",
        },
        [2] = {
            name = "weapon_musket",
            amount = 9999,
            price = 1000,
            info = {},
            type = "item",
        },
        [3] = {
            name = "ammo-musket",
            amount = 9999,
            price = 100,
            info = {},
            type = "item",
        },
    },
    ["pickaxe_miner"] = {
        [1] = {
            name = "pickaxe",
            amount = 9999,
            price = 300,
            info = {},
            type = "item",
        },
    },
    ["seller_hunter"] = {
        [1] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "boar_meat", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [2] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 100, -- Ποσότητα που θα πάρει x1
            currency = "boar_pelt", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [3] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 80, -- Ποσότητα που θα πάρει x1
            currency = "boar_tusks", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [4] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 90, -- Ποσότητα που θα πάρει x1
            currency = "deer_meat", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [5] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 100, -- Ποσότητα που θα πάρει x1
            currency = "deer_pelt", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [6] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 100, -- Ποσότητα που θα πάρει x1
            currency = "deer_horn", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
    },
    ["seller_miner"] = {
        [1] = {
            name = "money",
            amount = 250,
            currency = "copper_ingot",
            price = 1,
            info = {},
            type = "item",
        },
        [2] = {
            name = "money",
            amount = 400,
            currency = "silver_ingot",
            price = 1,
            info = {},
            type = "item",
        },
        [3] = {
            name = "money",
            amount = 600,
            currency = "iron_ingot",
            price = 1,
            info = {},
            type = "item",
        },
        [4] = {
            name = "money",
            amount = 800,
            currency = "titanium_ingot",
            price = 1,
            info = {},
            type = "item",
        },
        [5] = {
            name = "money",
            amount = 900,
            currency = "gold_ingot",
            price = 1,
            info = {},
            type = "item",
        },
    },
    ["seller_farmer"] = {
        [1] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 50, -- Ποσότητα που θα πάρει x1
            currency = "apple", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [2] = {
            name = "money",
            amount = 40,
            currency = "orange",
            price = 1,
            info = {},
            type = "item",
        },
        [3] = {
            name = "money",
            amount = 30,
            currency = "pear",
            price = 1,
            info = {},
            type = "item",
        },
        [4] = {
            name = "money",
            amount = 40,
            currency = "cherry",
            price = 1,
            info = {},
            type = "item",
        },
        [5] = {
            name = "money",
            amount = 40,
            currency = "peach",
            price = 1,
            info = {},
            type = "item",
        },
        [6] = {
            name = "money",
            amount = 50,
            currency = "banana",
            price = 1,
            info = {},
            type = "item",
        },
        [7] = {
            name = "money",
            amount = 50,
            currency = "strawberry",
            price = 1,
            info = {},
            type = "item",
        },
        [8] = {
            name = "money",
            amount = 50,
            currency = "blueberry",
            price = 1,
            info = {},
            type = "item",
        },
        [9] = {
            name = "money",
            amount = 50,
            currency = "grape",
            price = 1,
            info = {},
            type = "item",
        },
        [10] = {
            name = "money",
            amount = 50,
            currency = "kiwi",
            price = 1,
            info = {},
            type = "item",
        },
        [11] = {
            name = "money",
            amount = 40,
            currency = "lemon",
            price = 1,
            info = {},
            type = "item",
        },
        [12] = {
            name = "money",
            amount = 50,
            currency = "watermelon",
            price = 1,
            info = {},
            type = "item",
        },
    },
    ["seller_fisher_ilegall"] = {
        [1] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 1000, -- Ποσότητα που θα πάρει x1
            currency = "turtle", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [2] = {
            name = "money",
            amount = 20000,
            currency = "whale",
            price = 1,
            info = {},
            type = "item",
        },
    },
    ["seller_fisher_legall"] = {
        [1] = {
            name = "money", -- Τι θα πάρει ο User στο Trade
            amount = 100, -- Ποσότητα που θα πάρει x1
            currency = "salmon", -- Τι θα δώσει ο User
            price = 1, -- Ποσότητα που θα δώσει ο user
            info = {},
            type = "item",
        },
        [2] = {
            name = "money",
            amount = 100,
            currency = "shrimps",
            price = 1,
            info = {},
            type = "item",
        },
        [3] = {
            name = "money",
            amount = 130,
            currency = "lobster",
            price = 1,
            info = {},
            type = "item",
        },
    },
    ["fishing_trader"] = {
        [1] = {
            name = "fishingbait",
            amount = 9999,
            price = 10,
            info = {},
            type = "item",
        },
        [2] = {
            name = "fishingrod",
            amount = 9999,
            price = 500,
            info = {},
            type = "item",
        },
    },
    ["seller_robbery"] = {
        [1] = {
            name = "money", -- What the User will receive in the Trade
            amount = 30, -- Amount they will receive x1
            currency = "scrap", -- What the User will give
            price = 1, -- Amount the user will give
            info = {},
            type = "item",
        },
        [2] = {
            name = "money",
            amount = 150,
            currency = "goldenwatch",
            price = 1,
            info = {},
            type = "item",
        },
        [3] = {
            name = "money",
            amount = 300,
            currency = "gold_ingot",
            price = 1,
            info = {},
            type = "item",
        },
        [4] = {
            name = "money",
            amount = 200,
            currency = "goldchain",
            price = 1,
            info = {},
            type = "item",
        },
        [5] = {
            name = "money",
            amount = 500,
            currency = "diamond",
            price = 1,
            info = {},
            type = "item",
        },
        [6] = {
            name = "money",
            amount = 250,
            currency = "ring",
            price = 1,
            info = {},
            type = "item",
        },
        [7] = {
            name = "money",
            amount = 100,
            currency = "black_usb",
            price = 1,
            info = {},
            type = "item",
        },
        [8] = {
            name = "money",
            amount = 1000,
            currency = "mysterious_white_card",
            price = 1,
            info = {},
            type = "item",
        },
        [9] = {
            name = "money",
            amount = 400,
            currency = "sapphire",
            price = 1,
            info = {},
            type = "item",
        },
        [10] = {
            name = "money",
            amount = 350,
            currency = "emerald",
            price = 1,
            info = {},
            type = "item",
        },
        [11] = {
            name = "money",
            amount = 275,
            currency = "emerald_ring_gold",
            price = 1,
            info = {},
            type = "item",
        },
        [12] = {
            name = "money",
            amount = 225,
            currency = "emerald_ring_silver",
            price = 1,
            info = {},
            type = "item",
        },
        [13] = {
            name = "money",
            amount = 300,
            currency = "sapphire_ring_silver",
            price = 1,
            info = {},
            type = "item",
        },
        [14] = {
            name = "money",
            amount = 350,
            currency = "sapphire_ring_gold",
            price = 1,
            info = {},
            type = "item",
        },
    },
    ["normal"] = {
        [1] = {
            name = "water",
            price = 200,
            amount = 10,
            info = {},
            type = "item",
        },
        [2] = {
            name = "tost",
            price = 150,
            amount = 10,
            info = {},
            type = "item",
        },
        [3] = {
            name = "coffeetogo",
            price = 200,
            amount = 10,
            info = {},
            type = "item",
        },
        [4] = {
            name = "chocolate",
            price = 600, 
            amount = 50,
            info = {},
            type = "item",
        },
        [5] = {
            name = "notepad",
            price = 1000,
            amount = 10,
            info = {},
            type = "item",
        },
        [6] = {
            name = "rollingpaper",
            price = 40,
            amount = 50,
            info = {},
            type = "item",
        },
        [7] = {
            name = "cigsredwood",
            price = 40,
            amount = 50,
            info = {},
            type = "item",
        },
        [8] = {
            name = "lighter",
            price = 40,
            amount = 50,
            info = {},
            type = "item",
        },
    },
    ["digitalden"] = {
        [1] = {
            name = "phone",
            price = 2000,
            amount = 10,
            info = {},
            type = "item",
        },
        [2] = {
            name = "radio",
            price = 1500,
            amount = 10,
            info = {},
            type = "item",
        },
        [3] = {
            name = "laptop",
            price = 10200,
            amount = 10,
            info = {},
            type = "item",
        },
        [4] = {
            name = "gopro",
            price = 70000,
            amount = 10,
            info = {},
            type = "item",
        }
    },

    ["liquor"] = {
        [1] = {
            name = "beer",
            price = 7,
            amount = 50,
            info = {},
            type = "item",
        },
        [2] = {
            name = "whiskey",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "vodka",
            price = 12,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["fruit_shops"] = {
        [1] = {
            name = "apple",
            price = 7,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["vegetables_shop"] = {
        [1] = {
            name = "egg_crate",
            price = 7,
            amount = 50,
            info = {},
            type = "item",
        },
        [2] = {
            name = "pasta",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "milk",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["blackmarket_shop"] = {
        [1] = {
            name = "",
            price = 7,
            amount = 50,
            info = {},
            type = "item",
        },
        [2] = {
            name = "pasta",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "milk",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["weedshop"] = {
        [1] = {
            name = "joint",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
        },
        [2] = {
            name = "weapon_poolcue",
            price = 100,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "weed_nutrition",
            price = 20,
            amount = 50,
            info = {},
            type = "item",
        },
        [4] = {
            name = "empty_weed_bag",
            price = 2,
            amount = 1000,
            info = {},
            type = "item",
        },
        [5] = {
            name = "rolling_paper",
            price = 2,
            amount = 1000,
            info = {},
            type = "item",
        },
    },
    ["gearshop"] = {
        [1] = {
            name = "diving_gear",
            price = 2500,
            amount = 10,
            info = {},
            type = "item",
        },
        [2] = {
            name = "jerry_can",
            price = 200,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["leisureshop"] = {
        [1] = {
            name = "parachute",
            price = 2500,
            amount = 10,
            info = {},
            type = "item",
        },
        [2] = {
            name = "binoculars",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "diving_gear",
            price = 2500,
            amount = 10,
            info = {},
            type = "item",
        },
        [4] = {
            name = "diving_fill",
            price = 500,
            amount = 10,
            info = {},
            type = "item",
        }
        -- [4] = {
        --     name = "smoketrailred",
        --     price = 250,
        --     amount = 50,
        --     info = {},
        --     type = "item",
        -- },
    },
    ["weapons"] = {
        [1] = {
            name = "weapon_knife",
            price = 1250,
            amount = 250,
            info = {},
            type = "item",
        },
        [2] = {
            name = "weapon_bat",
            price = 1250,
            amount = 250,
            info = {},
            type = "item",
        },
        [3] = {
            name = "weapon_hatchet",
            price = 1250,
            amount = 250,
            info = {},
            type = "item",
            requiredJob = { ["mechanic"]=0, ["police"]=0 }
        },
        [4] = {
            name = "weapon_snspistol",
            price = 11500,
            amount = 5,
            info = {},
            type = "weapon",
            license = 'weapon'
        },
        [5] = {
            name = "weapon_vintagepistol",
            price = 14000,
            amount = 5,
            info = {},
            type = "item",
            license = 'weapon'
        },
        [6] = {
            name = "ammo-9",
            price = 50,
            amount = 250,
            info = {},
            type = "item",
            license = 'weapon'
        }
    },
    ["casino"] = {
        [1] = {
            name = 'casinochips',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        }
    },
    ["judge"] = {
        [1] = {
            name = 'dojbadge',
            price = 250,
            amount = 250,
            info = {},
            type = 'item',
        },
        [2] = {
            name = "radio",
            price = 250,
            amount = 50,
            info = {},
            type = "item",
        },
        [3] = {
            name = "emptydocument",
            price = 250,
            amount = 50,
            info = {},
            type = "item",
        },
        [4] = {
            name = "portablecopier",
            price = 250,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["robberies"] = {
        [1] = {
            name = 'hacking_computer',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [2] = {
            name = 'trojan_usb',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [3] = {
            name = 'thermite',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [4] = {
            name = 'cutter',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [5] = {
            name = 'laser_drill',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [6] = {
            name = 'weapon_switchblade',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        },
        [7] = {
            name = 'gas_mask',
            price = 1,
            amount = 999999,
            info = {},
            type = 'item',
        }
    },
    ["jail"] = {
        [1] = {
            name = "sandwich",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
        },
        [2] = {
            name = "water_bottle",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
        }
    },
    ["megamall"] = {
        [1] = {
            name = "notepad",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 1
        },
        [2] = {
            name = "smallscales",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 2
        },
        [3] = {
            name = "wateringcan",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 3
        },
        [4] = {
            name = "qualityscales",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 4
        },
        [5] = {
            name = "fertilizer",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 5
        },
        [6] = {
            name = "cutter",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 6
        },
        [7] = {
            name = "emptybaggies",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 7
        },
    },
    ["brewery"] = {
        [1] = {
            name = "ice",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 1
        },
        [2] = {
            name = "raw_coffee",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 2
        },
        [3] = {
            name = "wine_red",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 3
        },
        [4] = {
            name = "wine_rose",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 4
        },
        [5] = {
            name = "wine_white",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 5
        },
        [6] = {
            name = "whiskey",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 6
        },
        [7] = {
            name = "vodka",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 7
        },
        [8] = {
            name = "tequila",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 8
        },
        [9] = {
            name = "beer",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 9
        },
    },
    ["pops"] = {
        [1] = {
            name = "bleachwipes",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 1
        },
        [2] = {
            name = "bandage",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 2
        },
        [3] = {
            name = "icepack",
            price = 2500,
            amount = 2500,
            info = {},
            type = "item",
            slot = 3
        }
    }
}

Config.Locations = {
    ['seller_vangelico'] = {
        ['label'] = 'Jewellery Trader',
        ['coords'] = vector4(-622.46, -229.65, 38.06, 307.77),
        ['ped'] = 'csb_agatha',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Sell Jewellery',
        ['products'] = "seller_vangelico",
        ['showblip'] = true,
        ['blipsprite'] = 363,
        ['blipscale'] = 0.9,
        ['blipcolor'] = 52,
        ['delivery'] = vector4(2955.75, 2744.01, 43.63, 195.21),
        ['useStock'] = true,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['huntingtrader'] = {
        ['label'] = 'Hunting Trader',
        ['coords'] = vector4(-770.08, 5595.92, 33.49, 168.28),
        ['ped'] = 'CS_Hunter',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Buy Hunting Materials',
        ['products'] = "huntingtrader",
        ['showblip'] = true,
        ['blipsprite'] = 363,
        ['blipscale'] = 0.9,
        ['blipcolor'] = 52,
        ['delivery'] = vector4(2955.75, 2744.01, 43.63, 195.21),
        ['useStock'] = true,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['minerpickaxe'] = {
        ['label'] = 'Miner',
        ['coords'] = vector4(2955.75, 2744.01, 43.63, 195.21),
        ['ped'] = 'cs_floyd',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "pickaxe_miner",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2955.75, 2744.01, 43.63, 195.21),
        ['useStock'] = true,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['seller_hunter1'] = {
        ['label'] = 'Seller [Hunting]',
        ['coords'] = vector4(969.05, -2109.26, 31.48, 74.89) ,
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Sell Wild Materials',
        ['products'] = "seller_hunter",
        ['showblip'] = true,
        ['blipsprite'] = 642,
        ['blipscale'] = 0.75,
        ['blipcolor'] = 52,
        ['delivery'] = vector4(969.05, -2109.26, 31.48, 74.89) ,
        ['useStock'] = false,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['seller_miner1'] = {
        ['label'] = 'Seller [Ores]',
        ['coords'] = vector4(1080.01, -1982.6, 31.47, 344.64),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Sell Ores',
        ['products'] = "seller_miner",
        ['showblip'] = false,
        ['blipsprite'] = 642,
        ['blipscale'] = 0.75,
        ['blipcolor'] = 2,
        ['delivery'] = vector4(1080.01, -1982.6, 31.47, 344.64),
        ['useStock'] = false,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['seller_farmer1'] = {
        ['label'] = 'Seller [Vegetables]',
        ['coords'] = vector4(-1253.23, -1442.22, 4.37, 125.94),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Sell Vegetables',
        ['products'] = "seller_farmer",
        ['showblip'] = true,
        ['blipsprite'] = 642,
        ['blipscale'] = 0.75,
        ['blipcolor'] = 2,
        ['delivery'] = vector4(-1253.23, -1442.22, 4.37, 125.94),
        ['useStock'] = false,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['seller_fisher1'] = {
        ['label'] = 'Seller [Fishing]',
        ['coords'] = vector4(-1252.69, -1191.98, 7.3, 103.07),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "seller_fisher_legall",
        ['showblip'] = true,
        ['blipsprite'] = 642,
        ['blipscale'] = 0.75,
        ['blipcolor'] = 3,
        ['delivery'] = vector4(-1252.69, -1191.98, 7.3, 103.07),
        ['useStock'] = false,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    ['seller_fisher_illegal'] = {
        ['label'] = 'Seller [Fishing]',
        ['coords'] = vector4(-1101.66, 2722.44, 18.8, 356.41) ,
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "seller_fisher_ilegall",
        ['showblip'] = false,
        ['blipsprite'] = 210,
        ['blipscale'] = 0.85,
        ['blipcolor'] = 3,
        ['delivery'] = vector4(-1101.66, 2722.44, 18.8, 356.41) ,
        ['useStock'] = false,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },

    ['fishing_trader1'] = {
        ['label'] = 'Fishing Trader',
        ['coords'] = vector4(-3283.22, 970.02, 8.35, 182.68),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "fishing_trader",
        ['showblip'] = true,
        ['blipsprite'] = 210,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 3,
        ['delivery'] = vector4(-3283.22, 970.02, 8.35, 182.68),
        ['useStock'] = true,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },
    
    ['247supermarket'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(24.47, -1346.62, 29.5, 271.66),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(26.45, -1315.51, 29.62, 0.07),
        ['useStock'] = true,
        -- ['requiredJob'] = {'police', 'police', 'police', 'police'},
    },

    ['247supermarket2'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(-3039.54, 584.38, 7.91, 17.27),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3047.95, 590.71, 7.62, 19.53)
    },

    ['247supermarket3'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(-3242.97, 1000.01, 12.83, 357.57),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3245.76, 1005.25, 12.83, 269.45)
    },

    ['247supermarket4'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(1728.07, 6415.63, 35.04, 242.95),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1741.76, 6419.61, 35.04, 6.83)
    },

    ['247supermarket5'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(1959.82, 3740.48, 32.34, 301.57),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1963.81, 3750.09, 32.26, 302.46)
    },

    ['247supermarket6'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(549.13, 2670.85, 42.16, 99.39),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(541.54, 2663.53, 42.17, 120.51)
    },

    ['247supermarket7'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(2677.47, 3279.76, 55.24, 335.08),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2662.19, 3264.95, 55.24, 168.55)
    },

    ['247supermarket8'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(2556.66, 380.84, 108.62, 356.67),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2553.24, 399.73, 108.56, 344.86)
    },

    ['247supermarket9'] = {
        ['label'] = '24/7 Supermarket',
        ['coords'] = vector4(372.66, 326.98, 103.57, 253.73),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(379.97, 357.3, 102.56, 26.42)
    },

    -- LTD Gasoline Locations
    ['ltdgasoline'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-47.02, -1758.23, 29.42, 45.05),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-40.51, -1747.45, 29.29, 326.39)
    },

    ['ltdgasoline2'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-706.06, -913.97, 19.22, 88.04),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-702.89, -917.44, 19.21, 181.96)
    },

    ['ltdgasoline3'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-1820.02, 794.03, 138.09, 135.45),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1829.29, 801.49, 138.41, 41.39)
    },

    ['ltdgasoline4'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(1164.71, -322.94, 69.21, 101.72),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1160.62, -312.06, 69.28, 3.77)
    },

    ['ltdgasoline5'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(1697.87, 4922.96, 42.06, 324.71),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1702.68, 4917.28, 42.22, 139.27)
    },

    -- Rob's Liquor Locations
    ['robsliquor'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-1221.58, -908.15, 12.33, 35.49),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1226.92, -901.82, 12.28, 213.26)
    },

    ['robsliquor2'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-1486.59, -377.68, 40.16, 139.51),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1468.29, -387.61, 38.79, 220.13)
    },

    ['robsliquor3'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-2966.39, 391.42, 15.04, 87.48),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-2961.49, 376.25, 15.02, 111.41)
    },

    ['robsliquor4'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(1165.17, 2710.88, 38.16, 179.43),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1194.52, 2722.21, 38.62, 9.37)
    },

    ['robsliquor5'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(1134.2, -982.91, 46.42, 277.24),
        ['ped'] = 'csb_hugh',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "normal",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1129.73, -989.27, 45.97, 280.98)
    },

    -- Hardware Store Locations
    ['digitalden'] = {
        ['label'] = 'Hardware Store',
        ['coords'] = vector4(-1271.55, -1411.18, 4.37, 116.38),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Open Hardware Store',
        ['products'] = 'digitalden',
        ['showblip'] = false,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1271.55, -1411.18, 4.37, 116.38)
    },

    ['pops'] = {
        ['label'] = 'Pop’s Pills',
        ['coords'] = vector4(-1196.18, -1458.5, 4.38, 34.75),
        ['ped'] = 's_m_m_doctor_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Open Pop’s Pills Store',
        ['products'] = 'pops',
        ['showblip'] = true,
        ['blipsprite'] = 403,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1196.18, -1458.5, 4.38, 34.75)
    },
    
    -- Ammunation Locations
    ['ammunation'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-661.96, -933.53, 21.83, 177.05),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-660.61, -938.14, 21.83, 167.22)
    },
    ['ammunation2'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(809.68, -2159.13, 29.62, 1.43),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(820.97, -2146.7, 28.71, 359.98)
    },
    ['ammunation3'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(1692.67, 3761.38, 34.71, 227.65),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1687.17, 3755.47, 34.34, 163.69)
    },
    ['ammunation4'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-331.23, 6085.37, 31.45, 228.02),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-341.72, 6098.49, 31.32, 11.05)
    },
    ['ammunation5'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(253.63, -51.02, 69.94, 72.91),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(249.0, -50.64, 69.94, 60.71)
    },
    ['ammunation6'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(23.0, -1105.67, 29.8, 162.91),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-5.82, -1107.48, 29.0, 164.32)
    },
    ['ammunation7'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(2567.48, 292.59, 108.73, 349.68),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2578.77, 285.53, 108.61, 277.2)
    },
    ['ammunation8'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-1118.59, 2700.05, 18.55, 221.89),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1127.67, 2708.18, 18.8, 41.76)
    },
    ['ammunation9'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(841.92, -1035.32, 28.19, 1.56),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(847.83, -1020.36, 27.88, 88.29)
    },
    ['ammunation10'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-1304.19, -395.12, 36.7, 75.03),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1302.44, -385.23, 36.62, 303.79)
    },
    ['ammunation11'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-3173.31, 1088.85, 20.84, 244.18),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Ammunation',
        ['products'] = "weapons",
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3183.6, 1084.35, 20.84, 68.13)
    },

    ['fruit_shops'] = {
        ['label'] = 'Fruit Shop',
        ['coords'] = vector4(-1206.11, -1460.52, 4.37, 297.04),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['products'] = "fruit_shops",
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1206.11, -1460.52, 4.37, 297.04)
    },

    ['vegetables_shop'] = {
        ['label'] = 'Vegetable Shop',
        ['coords'] = vector4(-1225.28, -1485.05, 4.37, 33.75),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['products'] = "vegetables_shop",
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1845.8175, 2585.9312, 45.6721, 96.7577)
    },

    ['prison'] = {
        ['label'] = 'Canteen Shop',
        ['coords'] = vector4(1777.59, 2560.52, 44.62, 187.83),
        ['ped'] = false,
        ['products'] = "prison",
        ['showblip'] = false,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1845.8175, 2585.9312, 45.6721, 96.7577)
    },

    
    ['megamall'] = {
        ['label'] = 'Mega Mall',
        ['coords'] = vector4(46.36, -1749.24, 29.64, 45.56),
        ['ped'] = 'a_m_m_salton_01',
        ['scenario'] = 'WORLD_HUMAN_AA_SMOKE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "megamall",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1845.8175, 2585.9312, 45.6721, 96.7577)
    },

    ['brewery'] = {
        ['label'] = 'Brewery',
        ['coords'] = vector4(-1271.21, -1418.59, 4.37, 31.55),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'PROP_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "brewery",
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1271.21, -1418.59, 4.37, 31.55)
    },


    ['blackmarket'] = {
        ['label'] = 'Black Market',
        ['coords'] = vector4(1080.47, 209.67, 87.54, 242.24),
        ['ped'] = 'a_m_y_smartcaspat_01',
        ['scenario'] = 'PROP_HUMAN_SEAT_ARMCHAIR',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['products'] = "blackmarket_shop",
        ['delivery'] = vector4(1080.47, 209.67, 87.54, 242.24)
    }

}
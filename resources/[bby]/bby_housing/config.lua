Config = {}

-- Police and Emergency Services Configuration
Config.PoliceJobs = {
    'police',
    'sheriff',
    'leo',
    'trooper'
}

-- Raid System Configuration
Config.RaidSettings = {
    RequireWarrant = true, -- Set to false to allow raids without warrants
    RaidDuration = 300, -- 5 minutes in seconds
    RaidCooldown = 1800, -- 30 minutes cooldown between raids on same house
    AllowedItems = { -- Items police can confiscate during raids
        'weed',
        'cocaine',
        'meth',
        'lsd',
        'opium',
        'cannabis',
        'marijuana',
        'drugs',
        'pistol',
        'rifle',
        'smg',
        'shotgun'
    }
}

-- Doorbell System Configuration
Config.DoorbellSettings = {
    EnableSounds = true,
    DoorbellRange = 50.0, -- Range for doorbell sound
    NotificationDuration = 10000, -- 10 seconds
    MaxVisitorHistory = 10 -- Maximum doorbell history entries per house
}

-- Decoration System Configuration
Config.DecorationSettings = {
    MaxDecorationsPerHouse = 50, -- Maximum decorations per house
    PlacementRange = 10.0, -- Maximum placement range from player
    SnapToGround = true, -- Snap decorations to ground
    EnableRotation = true, -- Allow rotation during placement
    EnablePreview = true -- Show preview during placement
}

-- Available Decorations Shop
Config.Decorations = {
    -- Furniture
    {
        category = "Furniture",
        items = {
            {
                name = "Modern Chair",
                model = "v_club_stagechair",
                price = 150,
                description = "A comfortable modern chair"
            },
            {
                name = "Coffee Table",
                model = "prop_coffee_table_01",
                price = 300,
                description = "Glass coffee table"
            },
            {
                name = "Office Chair",
                model = "prop_chair_01a",
                price = 200,
                description = "Ergonomic office chair"
            },
            {
                name = "Dining Table",
                model = "prop_table_04_chr",
                price = 500,
                description = "Wooden dining table"
            },
            {
                name = "Bookshelf",
                model = "prop_bookshelf_01",
                price = 400,
                description = "Tall wooden bookshelf"
            }
        }
    },
    -- Electronics
    {
        category = "Electronics",
        items = {
            {
                name = "Flat Screen TV",
                model = "prop_tv_flat_01",
                price = 800,
                description = "55-inch flat screen TV"
            },
            {
                name = "Desktop Computer",
                model = "prop_dyn_pc_02",
                price = 600,
                description = "Gaming desktop computer"
            },
            {
                name = "Sound System",
                model = "prop_boom_01",
                price = 350,
                description = "High-quality sound system"
            },
            {
                name = "Radio",
                model = "prop_radio_01",
                price = 100,
                description = "Vintage radio player"
            }
        }
    },
    -- Decorative
    {
        category = "Decorative",
        items = {
            {
                name = "Potted Plant",
                model = "prop_plant_01a",
                price = 75,
                description = "Small decorative plant"
            },
            {
                name = "Floor Lamp",
                model = "prop_floor_lamp_01",
                price = 200,
                description = "Modern floor lamp"
            },
            {
                name = "Picture Frame",
                model = "prop_picture_01",
                price = 50,
                description = "Decorative picture frame"
            },
            {
                name = "Vase",
                model = "prop_vase_01",
                price = 80,
                description = "Ceramic decorative vase"
            },
            {
                name = "Rug",
                model = "prop_rug_01",
                price = 120,
                description = "Persian-style rug"
            }
        }
    },
    -- Storage
    {
        category = "Storage",
        items = {
            {
                name = "Wardrobe",
                model = "prop_wardrobe_01",
                price = 600,
                description = "Large wooden wardrobe"
            },
            {
                name = "Chest of Drawers",
                model = "prop_chest_01a",
                price = 300,
                description = "4-drawer chest"
            },
            {
                name = "Safe",
                model = "prop_ld_int_safe_01",
                price = 1200,
                description = "Secure metal safe"
            }
        }
    }
}

-- House types with different interiors
Config.HouseTypes = {
    ['poor'] = {
        label = 'Poor House',
        interior = {
            coords = vector4(266.0, -1007.0, -101.0, 0.0), -- Motel room interior
            exit = vector3(266.207, -1007.098, -100.977), -- Updated exit coordinates
            stash = vector3(265.77, -999.349, -99.009), -- Updated stash coordinates  
            garage_entry = vector3(264.0, -1000.5, -101.0),
            wardrobe = vector3(262.683, -999.846, -99.009), -- Wardrobe/clothing
            decoration_shop = vector3(262.683, -999.846, -99.009), -- Decoration management
            bed = vector3(262.683, -999.846, -99.009), -- Bed/rest area
            kitchen = vector3(262.683, -999.846, -99.009), -- Kitchen/food area
            price_multiplier = 1.0
        },
        garage = {
            interior = vector4(240.0, -1004.8, -99.0, 90.0), -- Underground garage
            exit = vector3(237.0, -1004.8, -99.0),
            spawn_slots = {
                vector4(228.5, -998.5, -99.0, 90.0),
                vector4(228.5, -1002.5, -99.0, 90.0),
                vector4(228.5, -1006.5, -99.0, 90.0),
                vector4(228.5, -1010.5, -99.0, 90.0),
                vector4(228.5, -1014.5, -99.0, 90.0)
            }
        }
    },
    ['medium'] = {
        label = 'Medium House',
        interior = {
            coords = vector4(-174.38, -1007.2, -99.0, 0.0), -- Apartment interior
            exit = vector3(-174.02, -1002.0, -99.0),
            stash = vector3(-178.9, -1000.5, -99.0),
            garage_entry = vector3(-170.0, -1000.5, -99.0),
            price_multiplier = 1.5
        },
        garage = {
            interior = vector4(-31.84, -621.28, 35.0, 90.0), -- Maze Bank garage
            exit = vector3(-35.0, -621.28, 35.0),
            spawn_slots = {
                vector4(-22.5, -615.5, 35.0, 0.0),
                vector4(-22.5, -619.5, 35.0, 0.0),
                vector4(-22.5, -623.5, 35.0, 0.0),
                vector4(-22.5, -627.5, 35.0, 0.0),
                vector4(-22.5, -631.5, 35.0, 0.0)
            }
        }
    },
    ['luxury'] = {
        label = 'Luxury House',  
        interior = {
            coords = vector4(-1449.16, -539.52, 34.74, 0.0), -- Eclipse Towers apartment
            exit = vector3(-1451.67, -540.57, 34.74),
            stash = vector3(-1457.26, -530.21, 34.74),
            garage_entry = vector3(-1445.0, -544.0, 34.74),
            price_multiplier = 3.0
        },
        garage = {
            interior = vector4(-136.0, -583.0, 32.0, 90.0), -- Eclipse garage interior
            exit = vector3(-140.0, -583.0, 32.0),
            spawn_slots = {
                vector4(-145.5, -574.5, 32.0, 0.0),
                vector4(-145.5, -578.5, 32.0, 0.0),
                vector4(-145.5, -582.5, 32.0, 0.0),
                vector4(-145.5, -586.5, 32.0, 0.0),
                vector4(-145.5, -590.5, 32.0, 0.0)
            }
        }
    }
}

-- House locations around the map (15 houses with different types)
Config.Houses = {
    -- Poor Houses (5)
    [1] = {
        id = 1,
        coords = vector3(-174.35, -1436.23, 31.24), -- Grove Street house
        garage_coords = vector3(-178.35, -1436.23, 31.24), -- Garage entrance nearby
        type = 'poor',
        base_price = 35000,
        owned = false,
        owner = nil
    },
    [2] = {
        id = 2,
        coords = vector3(-127.31, -1457.54, 33.89), -- Grove Street house 2
        garage_coords = vector3(-131.31, -1457.54, 33.89),
        type = 'poor',
        base_price = 40000,
        owned = false,
        owner = nil
    },
    [3] = {
        id = 3,
        coords = vector3(119.15, -1461.14, 29.14), -- Davis area
        garage_coords = vector3(115.15, -1461.14, 29.14),
        type = 'poor',
        base_price = 30000,
        owned = false,
        owner = nil
    },
    [4] = {
        id = 4,
        coords = vector3(312.24, -1956.26, 24.62), -- Davis area 2
        garage_coords = vector3(308.24, -1956.26, 24.62),
        type = 'poor',
        base_price = 28000,
        owned = false,
        owner = nil
    },
    [5] = {
        id = 5,
        coords = vector3(348.78, -1820.93, 28.89), -- Davis area 3
        garage_coords = vector3(344.78, -1820.93, 28.89),
        type = 'poor',
        base_price = 32000,
        owned = false,
        owner = nil
    },
    
    -- Medium Houses (5)
    [6] = {
        id = 6,
        coords = vector3(-9.53, -1438.54, 31.1), -- Near Franklin's house
        garage_coords = vector3(-13.53, -1438.54, 31.1),
        type = 'medium',
        base_price = 75000,
        owned = false,
        owner = nil
    },
    [7] = {
        id = 7,
        coords = vector3(23.11, -1447.06, 30.89), -- Near Franklin's house 2
        garage_coords = vector3(19.11, -1447.06, 30.89),
        type = 'medium',
        base_price = 70000,
        owned = false,
        owner = nil
    },
    [8] = {
        id = 8,
        coords = vector3(1259.48, -1761.87, 49.66), -- El Burro Heights
        garage_coords = vector3(1255.48, -1761.87, 49.66),
        type = 'medium',
        base_price = 85000,
        owned = false,
        owner = nil
    },
    [9] = {
        id = 9,
        coords = vector3(1379.58, -1515.85, 56.9), -- El Burro Heights 2
        garage_coords = vector3(1375.58, -1515.85, 56.9),
        type = 'medium',
        base_price = 90000,
        owned = false,
        owner = nil
    },
    [10] = {
        id = 10,
        coords = vector3(1006.04, -1337.28, 31.90), -- Mirror Park area
        garage_coords = vector3(1002.04, -1337.28, 31.90),
        type = 'medium',
        base_price = 80000,
        owned = false,
        owner = nil
    },
    
    -- Luxury Houses (5)
    [11] = {
        id = 11,
        coords = vector3(1210.73, -1228.35, 35.22), -- Mirror Park area 2
        garage_coords = vector3(1206.73, -1228.35, 35.22),
        type = 'luxury',
        base_price = 150000,
        owned = false,
        owner = nil
    },
    [12] = {
        id = 12,
        coords = vector3(1323.18, -1651.88, 52.23), -- El Burro Heights 3
        garage_coords = vector3(1319.18, -1651.88, 52.23),
        type = 'luxury',
        base_price = 160000,
        owned = false,
        owner = nil
    },
    [13] = {
        id = 13,
        coords = vector3(-1149.71, -1520.83, 10.63), -- Vespucci Canals
        garage_coords = vector3(-1153.71, -1520.83, 10.63),
        type = 'luxury',
        base_price = 200000,
        owned = false,
        owner = nil
    },
    [14] = {
        id = 14,
        coords = vector3(-1308.05, -1228.68, 4.89), -- Del Perro area
        garage_coords = vector3(-1312.05, -1228.68, 4.89),
        type = 'luxury',
        base_price = 180000,
        owned = false,
        owner = nil
    },
    [15] = {
        id = 15,
        coords = vector3(-820.02, -1073.32, 11.33), -- Little Seoul
        garage_coords = vector3(-824.02, -1073.32, 11.33),
        type = 'luxury',
        base_price = 170000,
        owned = false,
        owner = nil
    }
}
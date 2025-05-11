Config = Config or {}

Config.Locale = 'en'

Config.DrawDistance  = 5.0
Config.MarkerType    = 1
Config.MarkerSize    = {x = 2.5, y = 2.5, z = 0.5}
Config.MarkerColor   = {r = 60, g = 179, b = 113, a = 255}
Config.UseOxInventory = true

Config.DistanceToInteract = 2.0
Config.TimeToRecolect = 5000 --- In miliseconds

Config.Farms = {
    Apple = {
        Blip = {
            active  = true,
            coords  = vec3(2325.658, 4761.7646, 35.3383),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 1,
        },

        Zones = {
            vec3(2325.658, 4761.7646, 35.3383),
            vec3(2327.4397, 4770.812, 35.3807),
            vec3(2324.5562, 4746.9751, 35.3255),
            vec3(2343.4829, 4755.6084, 34.0372),
            vec3(2339.3142, 4767.1074, 34.0771),
            vec3(2339.3391, 4741.3511, 35.0943),
            vec3(2353.4775, 4760.3389, 34.5284),
        },

        ItemName = 'apple',
    },

    Orange = {
        Blip = {
            active  = true,
            coords  = vec3(347.8063, 6505.1909, 27.9985),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 81,
        },

        Zones = {
            vec3(347.8063, 6505.1909, 27.9985),
            vec3(355.226, 6504.8828, 27.8282),
        },

        ItemName = 'orange',
    },

    Pear = {
        Blip = {
            active  = true,
            coords  = vec3(2064.2126, 4819.52, 41.452),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 25,
        },

        Zones = {
            vec3(2064.2126, 4819.52, 41.452),
            vec3(2086.0752, 4825.6187, 41.1552),
        },

        ItemName = 'pear',
    },

    Cherry = {
        Blip = {
            active  = true,
            coords  = vec3(2316.8899, 5008.7749, 42.1238),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 6,
        },

        Zones = {
            vec3(2316.8899, 5008.7749, 42.1238),
            vec3(2316.6121, 5023.4224, 42.9045),
        },

        ItemName = 'cherry',
    },

    Peach = {
        Blip = {
            active  = true,
            coords  = vec3(263.954, 6506.2642, 30.1377),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 41,
        },

        Zones = {
            vec3(263.954, 6506.2642, 30.1377),
            vec3(273.3794, 6507.5273, 29.8491),
        },

        ItemName = 'peach',
    },

    Banana = {
        Blip = {
            active  = true,
            coords  = vec3(2016.1273, 4800.5098, 41.3909),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 5,
        },

        Zones = {
            vec3(2016.1273, 4800.5098, 41.3909),
            vec3(2003.7551, 4787.0229, 41.2767),
        },

        ItemName = 'banana',
    },

    Strawberry = {
        Blip = {
            active  = true,
            coords  = vec3(2094.4412, 4918.4678, 39.0438),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 69,
        },

        Zones = {
            vec3(2094.4412, 4918.4678, 39.0438),
            vec3(2093.3669, 4916.8594, 39.0883),
        },

        ItemName = 'strawberry',
    },

    Blueberry = {
        Blip = {
            active  = true,
            coords  = vec3(2002.3296, 4818.6514, 41.9856),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 38,
        },

        Zones = {
            vec3(2002.3296, 4818.6514, 41.9856),
            vec3(2001.4473, 4819.5435, 42.2422),
        },

        ItemName = 'blueberry',
    },

    Grape = {
        Blip = {
            active  = true,
            coords  = vec3(1941.713, 5084.269, 40.7254),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 27,
        },

        Zones = {
            vec3(1941.713, 5084.269, 40.7254),
            vec3(1936.7863, 5088.4775, 41.0482),
        },

        ItemName = 'grape',
    },

    Kiwi = {
        Blip = {
            active  = true,
            coords  = vec3(1877.366, 4850.063, 44.3105),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 24,
        },

        Zones = {
            vec3(1877.366, 4850.063, 44.3105),
            vec3(1878.5507, 4848.8071, 44.3344),
        },

        ItemName = 'kiwi',
    },

    Lemon = {
        Blip = {
            active  = true,
            coords  = vec3(1815.9979, 5015.1519, 55.611),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 46,
        },

        Zones = {
            vec3(1815.9979, 5015.1519, 55.611),
            vec3(1814.9727, 5014.3198, 55.3196),
        },

        ItemName = 'lemon',
    },

    Mango = {
        Blip = {
            active  = true,
            coords  = vec3(2389.4907, 5004.5469, 45.2739),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 66,
        },

        Zones = {
            vec3(2389.4907, 5004.5469, 45.2739),
            vec3(2377.6086, 5004.125, 44.0965),
        },

        ItemName = 'mango',
    },

    Watermelon = {
        Blip = {
            active  = true,
            coords  = vec3(2341.4661, 5107.9175, 45.7731),
            sprite  = 1,
            display = 4,
            scale   = 0.25,
            color   = 59,
        },

        Zones = {
            vec3(2341.4661, 5107.9175, 45.7731),
            vec3(2340.4465, 5106.0469, 45.5998),
        },

        ItemName = 'watermelon',
    }
}

Config.ProcessZone = {
    Blip = {
        active  = false,
        coords  = vec3(96.10, 6363.17, 31.36),
        sprite  = 267,
        display = 4,
        scale   = 1.0,
        color   = 43,
    },

    Zones = {
        vec3(96.10, 6363.17, 31.36)
    },

    Items = {
        'pear',
        'apple'
    },

    ItemBox = 'box_fruits',

    Quantity = 5
}


Config.SellZones = {
    Blip = {
        active  = false,
        sprite  = 267,
        display = 4,
        scale   = 0.5,
        color   = 43,
    },

    Zones = {
        {coords = vec3(1087.99, 6508.29, 21.04), sellPrice = 20},
        {coords = vec3(46.66, -1749.65, 29.61), sellPrice = 40}
    }

}

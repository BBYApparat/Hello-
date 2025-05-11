Config = {}

Config.EnableStress = true

Config.TargetResourceName = "qb-target"

Config.Jobs = {
    ['hunter'] = {
        needsJob = false,
        maxDeers = 45,
        requiredWeapon = GetHashKey('WEAPON_DAGGER'),
        animalModel = GetHashKey('a_c_deer'),
        slaughteringTime = 5000,
        notifications = {
            ["deer_unavailable"] = 'Someone else is slaughtering this.',
            ["no_dagger"] = 'You need a knife to slaughter the deer',
            ["deer_weight"] = "Deer Weight: ",
            ["kg"] = "kg",
        },
        animations = {
            {
                dict = "amb@medic@standing@kneel@base",
                anim = "base"
            },
            {
                dict = "anim@gangops@facility@servers@bodysearch@",
                anim = "player_search"
            }
        },
        progressBar = {
            label = "Slaughtering Deer...",
            canCancel = false,
        },
        blipData = {
            enabled = true,
            text = "Hunting Area",
            color = 31,
            sprite = 141,
            scale = 1.2
        },
        circleBlipData = {
            display = 3,
            color = 18,
            alpha = 128,
            text = "Hunting Zone"
        },
        targetData = {
            icon = "fas fa-right-to-bracket",
            label = "Slaughter Deer"
        },
        deerLocations = {
            { pos = { x = -693.789, y = 4855.275, z = 195.219, h = 6.35 }, used = false },
            { pos = { x = -669.418, y = 5012.222, z = 165.194, h = 6.35 }, used = false },
            { pos = { x = -783.792, y = 5217.456, z = 107.443, h = 6.35 }, used = false },
            { pos = { x = -554.753, y = 5166.493, z = 99.208, h = 6.35 }, used = false },
            { pos = { x = -960.91, y = 5001.16, z = 183.0, h = 6.35 }, used = false },
            { pos = { x = -442.898, y = 5087.9, z = 136.558, h = 6.35 }, used = false },
            { pos = { x = -781.333, y = 5120.98, z = 142.857, h = 6.35 }, used = false },
            { pos = { x = -953.903, y = 5317.661, z = 72.499, h = 6.35 }, used = false },
            { pos = { x = -795.05, y = 4973.98, z = 206.82, h = 6.35 }, used = false },
            { pos = { x = -912.45, y = 4688.46, z = 269.41, h = 6.35 }, used = false },
            { pos = { x = -722.57, y = 5361.91, z = 61.74, h = 6.35 }, used = false },
            { pos = { x = -879.86, y = 5160.02, z = 147.7, h = 6.35 }, used = false },
            { pos = { x = -878.92, y = 4912.42, z = 272.46, h = 6.35 }, used = false },
            { pos = { x = -884.75, y = 4912.91, z = 270.92, h = 85.00 }, used = false },
            { pos = { x = -886.07, y = 4921.58, z = 264.51, h = 18.40 }, used = false },
            { pos = { x = -891.92, y = 4936.93, z = 252.52, h = 22.15 }, used = false },
            { pos = { x = -894.31, y = 4942.78, z = 248.15, h = 22.16 }, used = false },
            { pos = { x = -893.47, y = 4960.04, z = 238.06, h = 337.40 }, used = false },
            { pos = { x = -597.22, y = 5340.72, z = 70.41, h = 341.67 }, used = false },
            { pos = { x = -501.47, y = 5179.07, z = 89.35, h = 177.93 }, used = false },
            { pos = { x = -530.26, y = 5079.65, z = 122.65, h = 165.04 }, used = false },
            { pos = { x = -450.74, y = 5131.11, z = 115.50, h = 297.17 }, used = false },
            { pos = { x = -810.11, y = 4741.59, z = 222.13, h = 231.64 }, used = false },
            { pos = { x = -647.11, y = 4706.41, z = 228.51, h = 231.61 }, used = false },
            { pos = { x = -501.68, y = 4782.54, z = 212.80, h = 231.75 }, used = false },
            { pos = { x = -469.52, y = 4839.55, z = 212.17, h = 305.20 }, used = false },
            { pos = { x = -990.34, y = 5155.83, z = 134.97, h = 313.80 }, used = false },
            { pos = { x = -968.01, y = 5220.16, z = 110.04, h = 327.21 }, used = false },
            { pos = { x = -948.42, y = 4819.33, z = 308.79, h = 296.34 }, used = false },
            { pos = { x = -614.09, y = 4667.02, z = 194.57, h = 296.34 }, used = false },
            { pos = { x = -723.92, y = 5284.89, z = 74.32, h = 45.50 }, used = false },
            { pos = { x = -582.16, y = 5456.11, z = 69.19, h = 76.78 }, used = false },
            { pos = { x = -692.44, y = 5124.98, z = 115.55, h = 330.42 }, used = false },
            { pos = { x = -791.09, y = 4987.55, z = 206.32, h = 59.12 }, used = false },
            { pos = { x = -520.55, y = 5124.21, z = 122.43, h = 205.75 }, used = false },
            { pos = { x = -973.14, y = 5103.44, z = 132.29, h = 139.87 }, used = false },
            { pos = { x = -694.98, y = 5043.61, z = 159.21, h = 289.50 }, used = false },
            { pos = { x = -873.24, y = 5204.98, z = 149.98, h = 321.12 }, used = false },
            { pos = { x = -821.78, y = 4954.33, z = 204.97, h = 180.66 }, used = false },
            { pos = { x = -469.15, y = 5297.22, z = 77.12, h = 17.98 }, used = false },
            { pos = { x = -551.98, y = 5213.11, z = 94.33, h = 142.78 }, used = false },
            { pos = { x = -793.31, y = 4843.19, z = 236.65, h = 55.32 }, used = false },
            { pos = { x = -612.45, y = 4623.78, z = 199.22, h = 274.22 }, used = false },
            { pos = { x = -700.32, y = 4831.21, z = 206.19, h = 83.78 }, used = false },
            { pos = { x = -893.76, y = 4921.44, z = 265.12, h = 18.66 }, used = false },
            { pos = { x = -900.43, y = 5021.45, z = 221.19, h = 347.89 }, used = false },
        },
        blipCircle = { centre = vector3(-776.287, 5022.088, 175.0), radius = 350.0 }
    },
    ["fishing"] = {
        needsJob = false,
        fishingProp = GetHashKey("prop_fishing_rod_01"),
        ZoneAlert = false,
        DebugPoly = false,
        DefaultMaxChance = 10,
        RetryCount = 2,
        baititem = {
            name = "fishingbait",
            amount = 1
        },
        FishingZones = {
            [1] = { -- Example of a BoxZone (box = true)
                coords = vector3(713.31, 4113.7, 35.78),
                heading = 179,
                length = 44.4,
                width = 5.0,
                minZ = 33.78,
                maxZ = 36.98,
                box = true,
                CastTime = {minimum = 10, maximum = 20}, --Minimum & Maximum Time in seconds between fishing and minigame
                MiniGame = {countMin = 2, countMax = 5, timeMin = 2000, timeMax = 2500, gapMin = 5, gapMax = 10},
                Stress   = {AddOnFail = 100000, RemoveOnSuccess = 300000},
                RemoveFishingRodHealth = {onSuccess = 2, onFail = 5},
                Items = {
                    {chance = 3, name = 'catfish'},
                    {chance = 4, name = 'stripedbass'},
                    {chance = 9, name = 'goldfish'},
                    {chance = 5, name = 'redfish'},
                },
                MaxChance = 10,
            },
            [2] = { -- Example of a BoxZone (box = true)
                coords = vector3(3542.36, 5310.26, 0.96),
                heading = 0.0,
                length = 200.0,
                width = 200.0,
                minZ = -2.0,
                maxZ = 10.0,
                box = true,
                CastTime = {minimum = 10, maximum = 20}, --Minimum & Maximum Time in seconds between fishing and minigame
                MiniGame = {countMin = 3, countMax = 6, timeMin = 2000, timeMax = 4000, gapMin = 5, gapMax = 8},
                Stress   = {AddOnFail = 100000, RemoveOnSuccess = 300000},
                RemoveFishingRodHealth = {onSuccess = 4, onFail = 10},
                Items = {
                    {chance = 3, name = 'catfish'},
                    {chance = 4, name = 'stripedbass'},
                    {chance = 6, name = 'goldfish'},
                    {chance = 5, name = 'redfish'},
                    {chance = 7, name = 'largemouthbass'},
                    {chance = 5, name = 'salmon'},
                    {chance = 6, name = 'stingray'},
                    {chance = 9, name = 'whale'},
                    {chance = 10, name = 'bluewhale'},
                },
                MaxChance = 10,
            },
        },
        DefaultItems = {
            {chance = 1, name = 'bluewhale'},
            {chance = 1, name = 'catfish'},
            {chance = 1, name = 'goldfish'},
            {chance = 1, name = 'largemouthbass'},
            {chance = 1, name = 'redfish'},
            {chance = 1, name = 'salmon'},
            {chance = 1, name = 'stingray'},
            {chance = 1, name = 'stripedbass'},
            {chance = 1, name = 'whale'},
        },
        animations = {
            {
                dict = "mini@tennis",
                anim = "forehand_ts_md_far"
            },
            {
                dict = "amb@world_human_stand_fishing@idle_a",
                anim = "idle_a"
            },
            {
                dict = "anim@move_m@trash",
                anim = "pickup"
            }
        },
        notifications = {
            ["fish_got_away"] = "The fish got away",
            ["no_fishingrod_found"] = "You need a fishing rod in order to catch a fish.",
            ["fishing_away_from_location"] = "You can't fish over there.",
            ["need_fishing_bait"] = "You need a fishing bait in order to fish.",
            ["cannot_carry_item"] = "You cannot carry this item. It's dropped on the floor. Collect it fast!",
        },
    }
}

Config.JobSellers = {
    ["hunting"] = {
        coords = { x = 8.75, y = 3685.2546, z = 39.6185, heading = 198.0466 },
        blipData = {
            enabled = true,
            sprite = 59,
            color = 10,
            scale = 0.6,
            text = "Hunting Seller"
        },
        targetData = {
            icon = "fas fa-shop",
            distance = 2.0,
            label = 'Hunting Seller',
        },
        pedData = {
            enabled = true,
            model = GetHashKey("cs_lestercrest"),
            scenario = "WORLD_HUMAN_STAND_MOBILE"
        },
        items = {
            { name = "", price = 100 }
        }
    },
    ["fishing"] = {
        coords = { x = -105.4501, y = 2808.103, z = 53.1587 , heading = 180.00},
        blipData = {
            enabled = true,
            sprite = 59,
            color = 2,
            scale = 0.6,
            text = "Fish Seller"
        },
        targetData = {
            icon = "fas fa-shop",
            distance = 2.0,
            label = "Fish Seller"
        },
        pedData = {
            enabled = true,
            model = GetHashKey("cs_joeminuteman"),
            scenario = "WORLD_HUMAN_STAND_MOBILE"
        },
        items = {
            { name = "redfish", price = 70 },
            { name = "stripedbass", price = 90 },
            { name = "catfish", price = 100 },
            { name = "goldfish", price = 200 }
        }
    }
}

Config.StressValues = {
    -- Add
    ["fishing_failed"] = 2000,

    -- Remove
    ["fishing_success"] = 1000,
}

Config.MinigameSettings = {
    ["fishing_try_fish"] = { circles = 3, seconds = 10 },

}
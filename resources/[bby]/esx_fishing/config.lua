Config = {}

Config.ZoneAlert = true
Config.DebugPoly = false

Config.DefaultCastTime = {minimum = 1, maximum = 2} --Minimum & Maximum Time in seconds between fishing and minigame
Config.DefaultMiniGame = {countMin = 1, countMax = 3, timeMin = 2000, timeMax = 4000, gapMin = 5, gapMax = 10}
Config.DefaultStress   = {AddOnFail = 10000, RemoveOnSuccess = 30000}
Config.DefaultRemoveFishingRodHealth = {onSuccess = 3, onFail = 5}
Config.DefaultMaxChance = 100 --Increse this to get item easily
Config.DefaultItems = {
    {chance = 70, name = 'salmon', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
    {chance = 85, name = 'shrimps', baits = {["fishingbait"] = true, ["shrimps"] = false, ["turtle"] = false}},
    {chance = 60, name = 'lobster', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
    {chance = 5, name = 'turtle', baits = {["fishingbait"] = false, ["shrimps"] = true, ["turtle"] = false}},
    {chance = 2, name = 'whale', baits = {["fishingbait"] = false, ["shrimps"] = false, ["turtle"] = true}},
}

Config.RetryCount = 10 -- if player don't get item after a successful minigame

Config.FishingZones = {
    [1] = { -- Example of a BoxZone (box = true)
        coords = vector3(713.31, 4113.7, 35.78),
        heading = 179,
        length = 44.4,
        width = 5.0,
        minZ = 33.78,
        maxZ = 36.98,
        box = true,

        CastTime = {minimum = 10, maximum = 20}, --Minimum & Maximum Time in seconds between fishing and minigame
        MiniGame = {countMin = 2, countMax = 5, timeMin = 2000, timeMax = 4000, gapMin = 5, gapMax = 10},
        Stress   = {AddOnFail = 100000, RemoveOnSuccess = 300000},
        RemoveFishingRodHealth = {onSuccess = 2, onFail = 5},
        Items = {
            {chance = 70, name = 'salmon', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
            {chance = 85, name = 'shrimps', baits = {["fishingbait"] = true, ["shrimps"] = false, ["turtle"] = false}},
            {chance = 60, name = 'lobster', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
            {chance = 20, name = 'turtle', baits = {["fishingbait"] = false, ["shrimps"] = true, ["turtle"] = false}},
            {chance = 10, name = 'whale', baits = {["fishingbait"] = false, ["shrimps"] = false, ["turtle"] = true}},
        },
        MaxChance = 100,
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
            {chance = 70, name = 'salmon', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
            {chance = 85, name = 'shrimps', baits = {["fishingbait"] = true, ["shrimps"] = false, ["turtle"] = false}},
            {chance = 60, name = 'lobster', baits = {["fishingbait"] = true, ["shrimps"] = true, ["turtle"] = true}},
            {chance = 20, name = 'turtle', baits = {["fishingbait"] = false, ["shrimps"] = true, ["turtle"] = false}},
            {chance = 10, name = 'whale', baits = {["fishingbait"] = false, ["shrimps"] = false, ["turtle"] = true}},
        },
        MaxChance = 100,
    },
    
}

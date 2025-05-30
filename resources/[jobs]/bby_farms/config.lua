-- config.lua
Config = {}

-- General Settings
Config.CowModel = 'a_c_cow'
Config.MilkItem = 'milk_raw'
Config.MilkItemLabel = 'Raw Milk'

-- Milk Settings
Config.MinMilk = 1 -- Minimum milk per successful milking
Config.MaxMilk = 3 -- Maximum milk per successful milking

-- Minigame Settings
Config.MinigameAttempts = 5 -- Number of key prompts in minigame
Config.MinigameTimeout = 3 -- Seconds to respond to each prompt

-- Cooldown Settings (in minutes)
Config.CowCooldowns = {
    [1] = 15, -- Cow #1 - 15 minutes
    [2] = 20, -- Cow #2 - 20 minutes  
    [3] = 12, -- Cow #3 - 12 minutes
    [4] = 25, -- Cow #4 - 25 minutes
    [5] = 18, -- Cow #5 - 18 minutes
    [6] = 22, -- Cow #6 - 22 minutes
    [7] = 14, -- Cow #7 - 14 minutes
    [8] = 28, -- Cow #8 - 28 minutes
    [9] = 16, -- Cow #9 - 16 minutes
}

-- Database Settings
Config.PersistentCooldowns = false -- Set to true if you want cooldowns to persist across server restarts
Config.SaveInterval = 300 -- How often to save cooldowns to database (seconds)

-- Cow Locations
Config.CowLocations = {
    -- Farm Area Near Grapeseed
    {
        coords = vector3(2447.12, 4740.89, 34.31),
        heading = 45.0
    },
    {
        coords = vector3(2454.78, 4735.21, 34.18),
        heading = 120.0
    },
    {
        coords = vector3(2461.45, 4742.67, 34.25),
        heading = 200.0
    },
    {
        coords = vector3(2449.89, 4748.12, 34.33),
        heading = 290.0
    },
    {
        coords = vector3(2466.23, 4750.78, 34.19),
        heading = 15.0
    },
    {
        coords = vector3(2442.67, 4753.45, 34.41),
        heading = 340.0
    },
    {
        coords = vector3(2458.91, 4758.23, 34.27),
        heading = 180.0
    },
    -- Additional farm area
    {
        coords = vector3(2471.12, 4743.89, 34.22),
        heading = 75.0
    },
    {
        coords = vector3(2439.45, 4760.67, 34.38),
        heading = 250.0
    },
}

-- Alternative locations (uncomment to use different areas)
--[[
-- Sandy Shores Farm Area
Config.CowLocations = {
    {
        coords = vector3(1899.45, 4925.67, 48.89),
        heading = 45.0
    },
    {
        coords = vector3(1905.78, 4920.21, 48.75),
        heading = 120.0
    },
    {
        coords = vector3(1912.45, 4927.67, 48.82),
        heading = 200.0
    },
    {
        coords = vector3(1897.89, 4933.12, 48.91),
        heading = 290.0
    },
    {
        coords = vector3(1918.23, 4935.78, 48.68),
        heading = 15.0
    },
    {
        coords = vector3(1893.67, 4938.45, 48.95),
        heading = 340.0
    },
    {
        coords = vector3(1920.91, 4942.23, 48.73),
        heading = 180.0
    },
    {
        coords = vector3(1915.12, 4948.89, 48.79),
        heading = 75.0
    },
    {
        coords = vector3(1888.45, 4945.67, 48.98),
        heading = 250.0
    },
}
--]]

--[[
-- Paleto Bay Farm Area  
Config.CowLocations = {
    {
        coords = vector3(-1142.45, 4925.67, 220.89),
        heading = 45.0
    },
    {
        coords = vector3(-1148.78, 4920.21, 220.75),
        heading = 120.0
    },
    {
        coords = vector3(-1155.45, 4927.67, 220.82),
        heading = 200.0
    },
    {
        coords = vector3(-1140.89, 4933.12, 220.91),
        heading = 290.0
    },
    {
        coords = vector3(-1161.23, 4935.78, 220.68),
        heading = 15.0
    },
    {
        coords = vector3(-1136.67, 4938.45, 220.95),
        heading = 340.0
    },
    {
        coords = vector3(-1163.91, 4942.23, 220.73),
        heading = 180.0
    },
    {
        coords = vector3(-1158.12, 4948.89, 220.79),
        heading = 75.0
    },
    {
        coords = vector3(-1131.45, 4945.67, 220.98),
        heading = 250.0
    },
}
--]]
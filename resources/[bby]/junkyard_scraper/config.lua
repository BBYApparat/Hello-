Config = {}

-- Bot position
Config.BotPosition = vector3(2367.917, 3156.318, 48.209)
Config.BotHeading = 180.0
Config.BotModel = `s_m_y_construct_01` -- Construction worker NPC

-- Junkyard zone boundaries (polygon points)
Config.JunkyardZone = {
    vector3(2398.807, 3162.263, 46.915),
    vector3(2436.059, 3162.058, 48.431),
    vector3(2437.565, 3025.928, 48.024),
    vector3(2326.401, 3024.34, 48.04),
    vector3(2327.113, 3079.724, 47.978),
    vector3(2342.438, 3169.86, 46.332)
}

-- Junkyard object models that can be scraped
Config.ScrapableModels = {
    10106915,
    591265130,
    -915224107,
    322493792,
    -273279397
}

-- Animation settings
Config.ScrapAnimation = {
    dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
    anim = 'weed_inspecting_high_base_inspector',
    flag = 1
}

-- Progress bar settings
Config.ProgressTime = 10000 -- 10 seconds per stage

-- Scrap stages and rewards
Config.ScrapStages = {
    [1] = {
        label = 'Scrapping 1/3',
        items = {
            {name = 'scrap', count = math.random(2, 4)},
            {name = 'plastic', count = math.random(1, 3)}
        }
    },
    [2] = {
        label = 'Scrapping 2/3', 
        items = {
            {name = 'scrapelectronics', count = math.random(1, 3)},
            {name = 'rubber', count = math.random(2, 4)},
            {name = 'iron_nugget', count = math.random(1, 2)}
        }
    },
    [3] = {
        label = 'Scrapping 3/3',
        items = {
            {name = 'steel', count = math.random(1, 3)},
            {name = 'copper_nugget', count = math.random(2, 4)},
            {name = 'iron_nugget', count = math.random(2, 3)}
        }
    }
}

-- Debug mode
Config.Debug = true
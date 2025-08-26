Config = {}

-- Bot position
Config.BotPosition = vector3(2367.917, 3156.318, 48.209)

-- Junkyard zone boundaries (polygon points)
Config.JunkyardZone = {
    vector2(2398.807, 3162.263),
    vector2(2436.059, 3162.058),
    vector2(2437.565, 3025.928),
    vector2(2326.401, 3024.34),
    vector2(2327.113, 3079.724),
    vector2(2342.438, 3169.86)
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
        label = 'Stage 1/3 - Initial Scrapping',
        items = {
            {name = 'scrap', count = math.random(1, 3)},
            {name = 'plastic', count = math.random(1, 2)}
        }
    },
    [2] = {
        label = 'Stage 2/3 - Deep Scrapping', 
        items = {
            {name = 'scrapelectronics', count = math.random(1, 2)},
            {name = 'rubber', count = math.random(1, 3)}
        }
    },
    [3] = {
        label = 'Stage 3/3 - Final Scrapping',
        items = {
            {name = 'copper_nugget', count = math.random(1, 2)},
            {name = 'iron_nugget', count = math.random(1, 2)},
            {name = 'glass', count = math.random(1, 3)}
        }
    }
}

-- Debug mode
Config.Debug = true
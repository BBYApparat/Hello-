Config = {}

Config.Options = {
    devMode = false, -- helps you restarting the resource.
    checkVersion = true, -- checking latest version for updates
    lang = "en",
    framework = "esx",   -- "qb", "esx", "custom"
    inventory = "ox",   -- "qb", "qs", "lj", "ox", "mf", "core", "custom"
    target = "ox",      -- "qb", "q", "ox" | (ox supports both qb-target/q-target)
    notify = "default", -- "default", "qb", "esx", "ox", "ps-ui", "okok", "custom" | (default = will use default framework notify) (custom = you have to impliment at shared/client/custom.lua)
    grounds = {-1286696947, -1885547121, 223086562, -461750719, 1333033863, -1595148316, -1915425863, 510490462, 951832588, -2041329971, 1109728704, -1942898710, -840216541, 2128369009},
    waitBefeSpawn = 0.1, -- Wait before spawning animals once user got inside area
    respawnOnLeft = 5, -- spawn new animals when number is reached
    maxSpawn = 30, -- The maximum allowed animals to be spawn
    allowedKnive = {
        `weapon_dagger`
    }
}

Config.Animals = {
    ["deer"] = {
        ped = `a_c_deer`,
        spawnAmount = {min = 1, max = 15},
        reward = {
            {name = 'deer_meat', amount = {min = 1, max = 5}},
            {name = 'deer_pelt', amount = {min = 1, max = 1}},
            {name = 'deer_horn', amount = {min = 1, max = 1}},
        }
    },
    ["boar"] = {
        ped = `a_c_boar`,
        spawnAmount = {min = 1, max = 15},
        reward = {
            {name = 'boar_meat', amount = {min = 1, max = 5}},
            {name = 'boar_pelt', amount = {min = 1, max = 1}},
            {name = 'boar_tusks', amount = {min = 1, max = 1}},
        }
    },
}
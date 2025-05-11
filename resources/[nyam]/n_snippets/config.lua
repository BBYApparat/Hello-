Config = {}

Config.Options = {
    devMode = false, -- helps you restarting the resource.
    checkVersion = true, -- checking latest version for updates
    lang = "en",
    framework = "esx",   -- "qb", "esx", "custom"
    inventory = "ox",   -- "qb", "qs", "lj", "ox", "mf", "core", "custom"
    target = "ox",      -- "qb", "q", "ox" | (ox supports both qb-target/q-target)
    notify = "wasabi", -- "default", "qb", "esx", "ox", "ps-ui", "okok", "custom" | (default = will use default framework notify) (custom = you have to impliment at shared/client/custom.lua)
}


Config.Modifier = {}
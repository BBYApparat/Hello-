Config = {}

Config.UsingESX = true
Config.UsingQBCore = false

Config.Society = {
    enabled = false,
    account = 'society_police' -- Change this to the account of your choosing (typically the name of the job)
}

Config.DiscordLogs = {
    -- Discord logs are disabled by default, if enabled;
    -- be sure to change the webhooks below
    enabled = false,

    -- Webhook colors (all discord logs are set to orange by default however they can be changed in the logging.lua)
    colors = {
        green = 25367,
        yellow = 13866548,
        grey = 7371644,
        red = 8261888,
        orange = 10835739,
        blue = 2191525,
        purple = 7419530,
    },

    webhooks = {
        bolos = 'CHANGE_ME',
        licenses = 'CHANGE_ME',
        fines = 'CHANGE_ME',
        profiles = 'CHANGE_ME',
        reports = 'CHANGE_ME',
        users = 'CHANGE_ME',
    }
}
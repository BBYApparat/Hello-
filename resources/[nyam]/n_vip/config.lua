Config = {}

Config.Options = {
    lang = "en"
}

Config.VIP = {
    inventory = {
        weight = 50 -- how many extra weight for inventory, in kg
    },
    salary = {
        amount = 25 -- how many extra (%) more salary for user
    },
    status = {

    }
}

exports("getConfig", function() return Config end)
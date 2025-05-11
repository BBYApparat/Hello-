Config = {}

Config.Locale = 'en'

Config.UseEyeTarget = true
Config.TargetResource = "qb-target" -- qb-target, qtarget, etc.
Config.UseProgressbar = true
Config.ProgressbarResource = "progressbar"

Config.UseTabletLogs = false

Config.MaxDistance = {
    give = 3.0,
    rob = 3.0
}

Config.MinComposterItems = 3
Config.FertilizerPerItems = 3

Config.PoliceJobs = {
	['police'] = true,
	['sheriff'] = true,
}

Config.StandardDumpsters = {
    ["police_trash1"] = true,
    ["police_trash2"] = true,
    ["police_trash3"] = true,
    ["police_trash4"] = true,
}

Config.RequirePermissionInventories = {
    ["policeevidence"] = {
        logsName = "police",
        logsLabel = "Police Evidence Logs",
        whitelistedJobs = {
            ["police"] = true,
        },
        whitelistedGrades = {
            ['29'] = true,
            ['30'] = true
        },
    },
}

Config.MechanicItems = {
    { 
        name = "mechanic_toolbox",
        onUse = function()
            exports.mt_workshops:openToolboxMenu()
        end,
    },
    { 
        name = "neons_controller",
        onUse = function()
            exports.mt_workshops:openLightsController()
        end,
    },
    {
        name = "mods_list",
        onUse = function(table, item)
            exports.mt_workshops:openCosmeticsMenu(table, item)
        end,
    }
}
Config = {}
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.IdleCamera = true
Config.JointEffectTime = 60
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    [`SHAMAL`] = true,
    [`LUXOR`] = true,
    [`LUXOR2`] = true,
    [`JET`] = true,
    [`LAZER`] = true,
    [`BUZZARD`] = true,
    [`BUZZARD2`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    [`TITAN`] = true,
    [`RHINO`] = true,
    [`FIRETRUK`] = true,
    [`MULE`] = true,
    [`MAVERICK`] = true,
    [`BLIMP`] = true,
    [`AIRTUG`] = true,
    [`CAMPER`] = true,
    [`HYDRA`] = true,
    [`OPPRESSOR`] = true,
    [`technical3`] = true,
    [`insurgent3`] = true,
    [`apc`] = true,
    [`tampa3`] = true,
    [`trailersmall2`] = true,
    [`halftrack`] = true,
    [`hunter`] = true,
    [`vigilante`] = true,
    [`akula`] = true,
    [`barrage`] = true,
    [`khanjali`] = true,
    [`caracara`] = true,
    [`blimp3`] = true,
    [`menacer`] = true,
    [`oppressor2`] = true,
    [`scramjet`] = true,
    [`strikeforce`] = true,
    [`cerberus`] = true,
    [`cerberus2`] = true,
    [`cerberus3`] = true,
    [`scarab`] = true,
    [`scarab2`] = true,
    [`scarab3`] = true,
    [`rrocket`] = true,
    [`ruiner2`] = true,
    [`deluxo`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.CraftingLocations = {
    ['blacksmith'] = {
        label = 'Blacksmith',
        coords = {x = 110.0, y = -1280.0, z = 29.0},
        recipes = 'blacksmith',
        jobs = {
            ['mechanic'] = true,
            ['bennys'] = true
        }
    },
    ['carpenter'] = {
        label = 'Carpenter',
        coords = {x = 120.0, y = -1270.0, z = 29.0},
        recipes = 'carpenter',
        jobs = {
            ['builder'] = true
        }
    }
}

Config.Recipes = {
    ['blacksmith'] = {
        [1] = {
            name = "repairkit",
            outputAmount = 1,
            duration = 5000, -- 5 seconds
            ingredients = {
                iron = 2,
                rubber = 1
            }
        },
        -- More recipes...
    },
    ['carpenter'] = {
        [1] = {
            name = "woodenchair",
            outputAmount = 1,
            duration = 10000, -- 10 seconds
            ingredients = {
                wood = 4,
                nails = 10
            }
        },
        -- More recipes...
    }
}

Config.Stashes = {
    {
        id = "police_locker",
        label = "Police Locker",
        slots = 50,
        weight = 100000,
        coords = vector3(451.7, -992.8, 30.7),
        jobs = {"police"}
    },
    {
        id = "hospital_storage",
        label = "Hospital Storage",
        slots = 100,
        weight = 200000,
        coords = vector3(306.5, -601.7, 43.3),
        jobs = {"ambulance"}
    },
    {
        id = "mechanic_toolbox",
        label = "Mechanic's Toolbox",
        slots = 30,
        weight = 50000,
        coords = vector3(-347.4, -133.0, 39.0),
        jobs = {"mechanic"}
    },
    -- Add more stashes as needed
}


Config.cash = 10000

Config.items = {
    {name = "phone", count = 1},
    {name = "id_card", count = 1},
    {name = "water", count = 5},
    {name = "bread", count = 5}
}

Config.AnimWeapons = {
    -- Melee
    WEAPON_KNIFE = false,           -- If it is set to true it will use the jerrycan style.
    WEAPON_NIGHTSTICK = false,
    WEAPON_HAMMER = false,
    WEAPON_BAT = false,
    WEAPON_GOLFCLUB = false,
    WEAPON_CROWBAR = false,
    WEAPON_BOTTLE = false,
    WEAPON_DAGGER = false,
    WEAPON_HATCHET = false,
    WEAPON_KNUCKLE = false,
    WEAPON_MACHETE = false,
    WEAPON_FLASHLIGHT = false,
    WEAPON_SWITCHBLADE = false,
    WEAPON_POOLCUE = false,
    WEAPON_PIPEWRENCH = false,
    WEAPON_BATTLEAXE = false,
    WEAPON_STONE_HATCHET = false,

    -- Handguns
    WEAPON_PISTOL = true,
    WEAPON_COMBATPISTOL = true,
    WEAPON_APPISTOL = true,
    WEAPON_PISTOL50 = true,
    WEAPON_SNSPISTOL = true,
    WEAPON_HEAVYPISTOL = true,
    WEAPON_VINTAGEPISTOL = true,
    WEAPON_STUNGUN = true,
    WEAPON_FLAREGUN = true,
    WEAPON_MARKSMANPISTOL = true,
    WEAPON_REVOLVER = true,
    WEAPON_DOUBLEACTION = true,
    WEAPON_RAYPISTOL = true,
    WEAPON_CERAMICPISTOL = true,
    WEAPON_NAVYREVOLVER = true,

    -- SMGs
    WEAPON_MICROSMG = true,
    WEAPON_SMG = true,
    WEAPON_ASSAULTSMG = true,
    WEAPON_COMBATPDW = true,
    WEAPON_MACHINEPISTOL = true,
    WEAPON_MINISMG = true,
    WEAPON_RAYCARBINE = true,

    -- Shotguns
    WEAPON_PUMPSHOTGUN = true,
    WEAPON_SAWNOFFSHOTGUN = true,
    WEAPON_ASSAULTSHOTGUN = true,
    WEAPON_BULLPUPSHOTGUN = true,
    WEAPON_MUSKET = true,
    WEAPON_HEAVYSHOTGUN = true,
    WEAPON_DBSHOTGUN = true,
    WEAPON_AUTOSHOTGUN = true,

    -- Assault Rifles
    WEAPON_ASSAULTRIFLE = true,
    WEAPON_CARBINERIFLE = true,
    WEAPON_ADVANCEDRIFLE = true,
    WEAPON_SPECIALCARBINE = true,
    WEAPON_BULLPUPRIFLE = true,
    WEAPON_COMPACTRIFLE = true,
    WEAPON_MILITARYRIFLE = true,
    WEAPON_HEAVYRIFLE = true,
    WEAPON_TACTICALRIFLE = true,

    -- LMGs
    WEAPON_MG = true,
    WEAPON_COMBATMG = true,
    WEAPON_GUSENBERG = true,

    -- Sniper Rifles
    WEAPON_SNIPERRIFLE = true,
    WEAPON_HEAVYSNIPER = true,
    WEAPON_MARKSMANRIFLE = true,
    WEAPON_PRECISIONRIFLE = true,

    -- Heavy Weapons
    WEAPON_RPG = true,
    WEAPON_GRENADELAUNCHER = true,
    WEAPON_GRENADELAUNCHER_SMOKE = true,
    WEAPON_MINIGUN = true,
    WEAPON_FIREWORK = true,
    WEAPON_RAILGUN = true,
    WEAPON_HOMINGLAUNCHER = true,
    WEAPON_COMPACTLAUNCHER = true,
    WEAPON_RAYMINIGUN = true,
    WEAPON_EMPLAUNCHER = true,

    -- Throwables
    WEAPON_GRENADE = false,
    WEAPON_STICKYBOMB = false,
    WEAPON_SMOKEGRENADE = false,
    WEAPON_BZGAS = false,
    WEAPON_MOLOTOV = false,
    WEAPON_FIREEXTINGUISHER = false,
    WEAPON_PETROLCAN = false,
    WEAPON_BALL = false,
    WEAPON_FLARE = false,
    WEAPON_SNOWBALL = false,
    WEAPON_PIPEBOMB = false
}

Config.MapModel = "prop_tourist_map_01"                   -- Map model to attach
Config.AnimDict = "amb@world_human_clipboard@male@idle_a" -- Animation dictionary
Config.AnimName = "idle_a"                                -- Animation name

Config.AllowKeyOpen = false

Config.OpenKey = 47 -- [G] key

Config.CloseOnDeath = true   -- true = close map if player dies
Config.CloseOnFall = true    -- true = close map if player falls or ragdolls
Config.CloseInVehicle = true -- true = close map if player enters a vehicle
Config.CloseOnWeapon = true  -- true = close map if player switches weapon

Config.LogLevel = "INFO" 
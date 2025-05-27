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
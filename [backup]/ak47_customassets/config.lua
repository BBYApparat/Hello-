Config = {}

Config.Blips = { --Commnent out if you don't need blips
    -- {pos = vector3(-57.38, -1099.396, 26.38), sprite = 225, color = 3, size = 0.6, radius = 0.0, name = 'PDM'},
    -- {pos = vector3(301.95, 201.05, 109.56), sprite = 121, color = 7, size = 0.6, radius = 0.0, name = 'Raul Nightclub'},
    -- {pos = vector3( -451.4737,  -33.34594, 109.56), sprite = 93, color = 7, size = 0.6, radius = 0.0, name = 'Hookah Lounge'},
    -- {pos = vector3(-818.95, -710.05, 109.56), sprite = 93, color = 7, size = 0.6, radius = 0.0, name = 'Wi Wang'},
    -- {pos = vector3(2780.44, 3457.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'Stop Car'},
    -- {pos = vector3(208.2, -192.49, 53.97), sprite = 75, color = 6, size = 0.6, radius = 0.0, name = 'Sushi Bar'},
    -- {pos = vector3(278.2, 141.49, 53.97), sprite = 75, color = 6, size = 0.6, radius = 0.0, name = 'Polar Ice'},
    -- {pos = vector3(-1086.12, -2044.18, 13.18), sprite = 72, color = 2, size = 0.6, radius = 0.0, name = 'Motors Mechanic'},
    -- {pos = vector3(-1686.57, -1079.83, 65.5), sprite = 75, color = 2, size = 0.6, radius = 0.0, name = 'Candy Shop'},
    -- {pos = vector3(895.44, -2115.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'East Customs'},
    -- {pos = vector3(965.44, -1030.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'Big Tuna'},
    {pos = vector3(-547.44, -198.4, 55.51), sprite = 419, color = 0, size = 0.6, radius = 0.0, name = 'Town Hall'},
    {pos = vector3(313.24, -225.98, 54.22), sprite = 475, color = 0, size = 0.6, radius = 0.0, name = 'Motel'},
    {pos = vector3(-368.44, -132.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'Ls Customs'},
    {pos = vector3(-581.57, -1070.83, 65.5), sprite = 75, color = 2, size = 0.6, radius = 0.0, name = 'UwU Cat Cafe'},
    {pos = vector3(-1179.04, -884.5, 15.97), sprite = 75, color = 1, size = 0.6, radius = 0.0, name = 'Burgershot'},
    {pos = vector3(5.04, -1605.5, 15.97), sprite = 75, color = 1, size = 0.6, radius = 0.0, name = 'Tacos'},
    {pos = vector3(714.39, 4123.1, 35.81), sprite = 308, color = 2, size = 0.6, radius = 0.0, name = 'Fishing'},
    {pos = vector3(-1388.95, -586.05, 109.56), sprite = 93, color = 7, size = 0.6, radius = 0.0, name = 'Bahamas Nightclub'},
    {pos = vector3(130.95, -1300.05, 109.56), sprite = 121, color = 7, size = 0.6, radius = 0.0, name = 'Vanilla Nightclub'},
    {pos = vector3(-1278.92, -1413.07, 4.34), sprite = 521, color = 7, size = 0.6, radius = 0.0, name = 'Digital Den'},
    {pos = vector3(-1816.17, -1193.23, 14.3), sprite = 75, color = 7, size = 0.6, radius = 0.0, name = 'Pearls'},
    {pos = vector3(-191.3, -1159.43, 23.24), sprite = 50, color = 1, size = 0.6, radius = 0.0, name = 'Impound'},
}

Config.NoHeadShot = true
Config.HandsupKey = 'x'

Config.WaterMark = {
    [1] = '~g~WELCOME~s~ ~r~TO ESX LEGACY~s~ ~y~BASE V3~s~',
    [2] = '~y~CHECK ~b~GUIDEBOOK ~g~COMMAND ~r~/doc~s~',
    [3] = 'JOIN: ~b~discord.gg/SecondLifeRP~s~',
}

Config.PauseTag = '~g~WELCOME~s~ ~r~TO ESX LEGACY~s~ ~y~BASE V3~s~'

Config.AntiVdm = false

Config.NoDriveBy = false
Config.PassengerDriveBy = true -- only effective if Config.DriveBy = true
Config.DriveByOutsideCity = true -- only effective if Config.DriveBy = true
Config.CityCenter = vector3(-227.05, -1005.62, 29.34) -- only effective if DriveByOutsideCity = true
Config.DriveByBlockRadius = 2000 -- only effective if DriveByOutsideCity = true

--Priority Cooldown /cooldown time
Config.AllowedGroup = {
    ['mod'] = true,
    ['admin'] = true,
    ['superadmin'] = true
}

Config.AllowedJobs = {
    ['police'] = true,
    ['sheriff'] = true,
}

Config.Traffic = {
    pedDensityMultiplier = 0.1,
    vehicleDensityMultiplier = 0.1,

    cmd_v_dens = 'v_dens', -- change ingame vehicle density /v_dens 0.2
    cmd_p_dens = 'p_dens', -- change ingame ped density /p_dens 0.2
    cmd_r_dens = 'r_dens', -- reset density /r_dens
    groups = {
        admin = true,
        superadmin = true,
    }
}

Config.Props = {
    mechanic_atm1 = {
        coords = vector3(-347.05,-108.26, 38.17),
        heading = 159.69,
        prop = 'prop_atm_02',
    },
    luxauto_atm = {
        coords = vector3(-775.68, -237.33, 36.29),
        heading = 121.09,
        prop = 'prop_atm_02',
    },
    cookies_atm = {
        coords = vector3(-949.95, -1186.44, 3.7),
        heading = 298.70,
        prop = 'prop_atm_02',
    },
    icebox_atm = {
        coords = vector3(-1233.86, -803.51, 16.88),
        heading = 222.90,
        prop = 'prop_atm_01',
    },
    icebox_tv = {
        coords = vector3(-1239.93, -796.9, 18.88),
        heading = 38.40,
        prop = 'prop_tv_flat_01',
    },
    hookah_tv = {
        coords = vector3(-417.16, -27.61, 41.73),
        heading = 266.90,
        prop = 'prop_tv_flat_01',
    }, 
    bennys_atm1 = {
        coords = vector3(-218.26, -1311.22, 30.50),
        heading = 269.50,
        prop = 'prop_fleeca_atm',
    },
    weaponlicense_atm1 = {
        coords = vector3(815.38, -2147.97, 28.63),
        heading = 180.0,
        prop = 'prop_fleeca_atm',
    },
}

Config.AFK = {
    enable = false,
    secondsUntilKick = 1800
}

Config.Binoculars = {
    fov_max = 70.0,
    fov_min = 5.0, -- max zoom level (smaller fov is more zoom)
    zoomspeed = 10.0, -- camera zoom speed
    speed_lr = 8.0, -- speed by which the camera pans left-right
    speed_ud = 8.0, -- speed by which the camera pans up-down
}

Config.Bulletproof = {
    ignored_jobs = {
        police = true,
        sheriff = true,
    },
    delay = 6000,
    skin_male = {bproof_1 = 9, bproof_2 = 3},
    skin_female = {bproof_1 = 6, bproof_2 = 3},
    default_skin_male = {bproof_1 = 0, bproof_2 = 0},
    default_skin_female = {bproof_1 = 0, bproof_2 = 0},
}

Config.ID = {
    key = 'F9',
    max_distance = 4.5,
}

Config.NoObject = {
    {pos = vector3(218.04, -809.19, 30.71), obj = -1184516519, radius = 100.0}, --Main Garag Barrier
    {pos = vector3(225.55, -738.58, 34.2), obj = -1184516519, radius = 100.0}, --Main Garag Barrier
    {pos = vector3(218.04, -809.19, 30.71), obj = 307771752, radius = 100.0}, --Main Garag Barrier
    {pos = vector3(225.55, -738.58, 34.2), obj = 307771752, radius = 100.0}, --Main Garag Barrier
    {pos = vector3(266.64, -348.54, 44.76), obj = 242636620, radius = 100.0}, --Motel Garag Barrier
    {pos = vector3(285.86, -355.1, 45.11), obj = 406416082, radius = 100.0}, --Motel Garag Barrier
    {pos = vector3(328.57, -272.73, 54.21), obj = 200846641, radius = 100.0}, --Motel Garag Barrier
}

Config.NoPed = {
    {pos = vector3(-1387.71, -609.2, 30.32), radius = 25.0}, --Bahamas
    {pos = vector3(113.15, -1286.71, 28.26), radius = 25.0}, --Unicorn
}

Config.Peacetime = {
    command = 'peacetime', 
    groups = {
        admin = true,
        superadmin = true,
    },
    time = 15,  -- minute
}

Config.Recoil = {
    [`weapon_pistol`] = 0.4, -- PISTOL
    [`weapon_combatpistol`] = 0.3, -- COMBAT PISTOL
    [`weapon_vintagepistol`] = 0.6, -- VINTAGE PISTOL
    [`weapon_heavypistol`] = 0.8, -- HEAVY PISTOL
    [`weapon_appistol`] = 0.6, -- AP PISTOL
    [`weapon_minismg`] = 0.6, -- MINI SMG
    [`weapon_microsmg`] = 0.1, -- MICRO SMG
    [`weapon_smg`] = 0.3, -- SMG
    [`weapon_assaultsmg`] = 0.3, -- ASSAULT SMG
    [`weapon_assaultrifle`] = 0.7, -- ASSAULT RIFLE
    [`weapon_assaultrifle_mk2`] = 0.7, -- ASSAULT RIFLE MK2
    [`weapon_carbinerifle`] = 0.6, -- CARBINE RIFLE
    [`weapon_carbinerifle_mk2`] = 0.6, -- CARBINE RIFLE MK2
    [`weapon_pumpshotgun`] = 0.8, -- PUMP SHOTGUN
    [`weapon_sawnoffshotgun`] = 1.2, -- SAWNOFF SHOTGUN
    [`weapon_stungun`] = 0.1, -- STUN GUN
}

Config.Takehostage = {
    AllowedWeapons = {
        "WEAPON_APPISTOL",
        "WEAPON_COMBATPISTOL",
        "WEAPON_PISTOL",
        "WEAPON_APPISTOL",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_MARKSMANPISTOL",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_STUNGUN",
        "WEAPON_REVOLVER",
        "WEAPON_MACHINEPISTOL",
    }
}

Config.BlacklistedVehs = {
    [`JET`] = true,
    [`LAZER`] = true,
    [`ANNIHILATOR`] = true,
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

Config.FreezeObjects = {
    [`prop_traffic_01a`] = true,
    [`prop_traffic_01b`] = true,
    [`prop_traffic_01d`] = true,
    [`prop_traffic_02a`] = true,
    [`prop_traffic_02b`] = true,
    [`prop_traffic_lightset_01`] = true,
    [`prop_traffic_rail_1a`] = true,
    [`prop_traffic_rail_1c`] = true,
    [`prop_traffic_rail_2`] = true,
    [`prop_traffic_rail_3`] = true,
    [`prop_streetlight_01`] = true,
    [`prop_streetlight_01b`] = true,
    [`prop_streetlight_02`] = true,
    [`prop_streetlight_03`] = true,
    [`prop_streetlight_03b`] = true,
    [`prop_streetlight_03c`] = true,
    [`prop_streetlight_03d`] = true,
    [`prop_streetlight_03e`] = true,
    [`prop_streetlight_04`] = true,
    [`prop_streetlight_05`] = true,
    [`prop_streetlight_05_b`] = true,
    [`prop_streetlight_06`] = true,
    [`prop_streetlight_07a`] = true,
    [`prop_streetlight_07b`] = true,
    [`prop_streetlight_08`] = true,
    [`prop_streetlight_09`] = true,
    [`prop_streetlight_10`] = true,
    [`prop_streetlight_11a`] = true,
    [`prop_streetlight_11b`] = true,
    [`prop_streetlight_11c`] = true,
    [`prop_streetlight_12a`] = true,
    [`prop_streetlight_12b`] = true,
    [`prop_streetlight_14a`] = true,
    [`prop_streetlight_15a`] = true,
    [`prop_streetlight_16a`] = true,
    [`prop_dumpster_02a`] = true,
    [`prop_bollard_04`] = true,
}


Config.TackleDistance				= 3.0
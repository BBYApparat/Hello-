Config = {}

-- General Settings
Config.SpawnChance = 0.6 -- 60% chance for a suitcase to spawn in a car (increased for testing)
Config.MaxSuitcasesTotal = 50 -- Maximum total number of suitcases in the world
Config.UpdateInterval = 5000 -- How often to check for new cars (ms) - reduced for faster spawning

-- Suitcase Props (randomly selected)
Config.SuitcaseProps = {
    'prop_ld_suitcase_01',
    'prop_ld_case_01_s',
    'prop_ld_case_01'
}

-- Car Density Settings (increase parked cars)
Config.IncreaseParkedDensity = true -- Enable increased parked car density
Config.ParkedDensity = 1.0 -- 1.0 = max parked car density (default is 0.2)
Config.VehicleDensity = 0.5 -- Moving vehicle density

-- Theft Settings
Config.StealTime = 5000 -- Time to steal suitcase when unlocked (ms)
Config.SmashTime = 3000 -- Time to smash window (ms)
Config.SmashStealTime = 7000 -- Time to steal after smashing window (ms)
Config.WindowSmashWeapon = `WEAPON_CROWBAR` -- Required weapon to smash windows
Config.WindowSmashItem = 'crowbar' -- Item required to smash windows (if using item instead of weapon)
Config.UseItemForSmash = false -- Use item instead of weapon check

-- Rewards
Config.Rewards = {
    money = {
        min = 500,
        max = 2500,
        chance = 0.7 -- 70% chance for money
    },
    items = {
        {item = 'phone', min = 1, max = 1, chance = 0.2},
        {item = 'laptop', min = 1, max = 1, chance = 0.1},
        {item = 'watch', min = 1, max = 2, chance = 0.15},
        {item = 'diamond', min = 1, max = 3, chance = 0.05},
        {item = 'goldchain', min = 1, max = 2, chance = 0.1},
        {item = 'rolex', min = 1, max = 1, chance = 0.08},
        {item = 'money', min = 100, max = 500, chance = 0.4}
    }
}

-- Police Alert Settings
Config.AlertPolice = true
Config.AlertChance = 0.3 -- 30% chance to alert police when smashing window
Config.AlertDispatch = 'ps-dispatch' -- Dispatch system to use (ps-dispatch, cd_dispatch, custom)

-- Animations
Config.Animations = {
    smashWindow = {
        dict = 'melee@large_wpn@streamed_core',
        anim = 'ground_attack_on_spot',
        flag = 1
    },
    stealSuitcase = {
        dict = 'mini@repair',
        anim = 'fixing_a_player',
        flag = 1
    }
}

-- Debug
Config.Debug = true -- Enable debug prints and markers
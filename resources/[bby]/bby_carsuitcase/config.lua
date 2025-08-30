Config = {}

-- General Settings
Config.SpawnChance = 0.3 -- 30% chance for a suitcase to spawn in a parked car
Config.MaxSuitcasesPerArea = 5 -- Maximum number of suitcases in a given area
Config.SpawnRadius = 100.0 -- Radius to check for parked cars around player
Config.UpdateInterval = 30000 -- How often to check for new parked cars (ms)
Config.SuitcaseProp = 'prop_ld_suitcase_01' -- Suitcase prop model

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
Config.Debug = false -- Enable debug prints and markers
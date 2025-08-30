Config = {}

-- ================== CAR LOOTING SETTINGS ==================
-- General Settings
Config.SpawnChance = 1.0 -- 100% chance for ALL parked cars to have suitcases
Config.MaxSuitcasesTotal = 200 -- Increased limit for more suitcases
Config.UpdateInterval = 3000 -- Check every 3 seconds for new cars

-- Suitcase Props (randomly selected)
Config.SuitcaseProps = {
    'prop_ld_suitcase_01',
    'prop_ld_case_01_s',
    'prop_ld_case_01'
}

-- Note: Car density is now controlled via esx-smallresources/client/density.lua

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

-- ================== POSTBOX LOOTING SETTINGS ==================

-- Postbox Settings
Config.PostboxRequireLockpick = true -- Require lockpick item to open postboxes
Config.PostboxLockpickTime = 5000 -- Time to lockpick postbox (ms)
Config.PostboxStealTime = 3000 -- Time to reach inside and steal (ms)
Config.PostboxHandStuckChance = 0.7 -- 70% chance for hand to get stuck

-- Individual postbox cooldowns (random between min and max)
Config.PostboxResetTimeMin = 900000 -- 15 minutes minimum
Config.PostboxResetTimeMax = 3600000 -- 60 minutes maximum
Config.PostboxResetTime = 1800000 -- 30 minutes default (fallback)

-- Postbox Rewards
Config.PostboxRewards = {
    envelope = {
        min = 2,
        max = 3
    },
    extraItems = { -- Additional items that might be found
        {item = 'money', min = 50, max = 200, chance = 0.3},
        {item = 'phone', min = 1, max = 1, chance = 0.05}
    }
}

-- Postbox Animations
Config.PostboxAnimations = {
    lockpick = {
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        anim = 'machinic_loop_mechandplayer',
        flag = 1
    },
    reach = {
        dict = 'mini@repair',
        anim = 'fixing_a_ped',
        flag = 49
    }
}
Config = {}

-- ================== CAR LOOTING SETTINGS ==================
-- General Settings
Config.SpawnChance = 0.7 -- 70% chance for parked cars to have suitcases (reduced for performance)
Config.MaxSuitcasesTotal = 100 -- Maximum suitcases at once (reduced for performance)
Config.UpdateInterval = 10000 -- Check every 10 seconds for new cars (increased for performance)
Config.MaxScanDistance = 150.0 -- Only scan vehicles within this distance
Config.DisableInitialSpawn = false -- Set to true to disable initial spawn on resource start

-- Player-specific cooldowns (each player has their own timer)
Config.CarLootCooldownMin = 300000 -- 5 minutes minimum before same player can loot same car
Config.CarLootCooldownMax = 900000 -- 15 minutes maximum
Config.CarLootCooldown = 600000 -- 10 minutes default (fallback)

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
Config.Debug = false -- Enable debug prints and markers (SET TO FALSE FOR PRODUCTION!)

-- ================== PERFORMANCE SETTINGS ==================
-- Adjust these if experiencing lag

Config.Performance = {
    -- For low-end servers, set to 'low'
    -- For high-end servers, set to 'high'
    Mode = 'balanced', -- 'low', 'balanced', 'high'
    
    -- Thread intervals (milliseconds)
    PostboxNearbyCheck = 1000, -- How often to check for nearby postboxes
    PostboxRescan = 30000, -- How often to rescan all postboxes
    PostboxCooldownCheck = 120000, -- How often to check cooldowns
    
    CarScanInterval = 10000, -- How often to scan for cars
    CarCooldownCheck = 30000, -- How often to check car cooldowns
    CarKeepAliveCheck = 15000, -- How often to prevent car despawn
    
    -- Distance settings
    MaxPostboxDistance = 50.0, -- Max distance to process postboxes
    MaxCarScanDistance = 150.0, -- Max distance to scan cars
    MaxCarSpawnDistance = 100.0, -- Max distance to spawn suitcases
}

-- Apply performance presets
if Config.Performance.Mode == 'low' then
    -- Settings for low-end servers
    Config.Performance.PostboxNearbyCheck = 2000
    Config.Performance.PostboxRescan = 60000
    Config.Performance.PostboxCooldownCheck = 300000
    Config.Performance.CarScanInterval = 20000
    Config.Performance.CarCooldownCheck = 60000
    Config.Performance.MaxCarScanDistance = 100.0
    Config.MaxSuitcasesTotal = 50
elseif Config.Performance.Mode == 'high' then
    -- Settings for high-end servers
    Config.Performance.PostboxNearbyCheck = 500
    Config.Performance.PostboxRescan = 15000
    Config.Performance.PostboxCooldownCheck = 60000
    Config.Performance.CarScanInterval = 5000
    Config.Performance.CarCooldownCheck = 15000
    Config.Performance.MaxCarScanDistance = 200.0
    Config.MaxSuitcasesTotal = 150
end

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
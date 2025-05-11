-- config.lua
Config = {}

Config.Server = {
    CooldownTime = 1800, -- 30 minutes in seconds
    RequiredCops = 1,
    RewardRange = {1000, 3000},
    PoliceJobName = 'police',
    AllowedItems = {
        'lockpick' -- Required item to start robbery
    }
}

Config.Client = {
    RegisterProps = 'prop_till_01',
    MinigameTime = 20, -- seconds
    ProgressBarTime = 30, -- seconds
    MaxDistance = 3.0,
    Debug = false, -- Default debug state
    DebugDistance = 100.0, -- Distance to show debug text
    Commands = {
        toggleDebug = 'registerdebug', -- Command to toggle debug mode
        printLocations = 'registerlocations' -- Command to print all locations
    },
    RestrictDebug = true, -- Only allow admins to use debug commands
    Animations = {
        dict = 'anim@heists@ornate_bank@grab_cash',
        clip = 'grab'
    },
    Blips = {
        sprite = 628,
        color = 1,
        scale = 0.8,
        label = 'Robbable Register'
    }
}
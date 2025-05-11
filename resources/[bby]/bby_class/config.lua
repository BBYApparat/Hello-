Config = {}

-- Police jobs that can use pursuit mode
Config.PoliceJobs = {
    ['police'] = true,
    ['sheriff'] = true
}

-- Pursuit modes with progressively higher performance levels
Config.PursuitModes = {
    ["C"] = {
        name = "CAUTIOUS",
        label = "Cautious Pursuit",
        description = "5% performance boost. Suitable for city areas with traffic",
        icon = "car-side",
        speedMultiplier = 1.05,
        accelerationMultiplier = 1.05,
        handling = 1.02,
        braking = 1.05,
        color = {r = 0, g = 255, b = 0},     -- Green
        minRank = 0
    },
    ["B"] = {
        name = "BASIC",
        label = "Basic Pursuit",
        description = "10% performance boost. Standard patrol response",
        icon = "car",
        speedMultiplier = 1.1,
        accelerationMultiplier = 1.1,
        handling = 1.05,
        braking = 1.1,
        color = {r = 0, g = 150, b = 255},   -- Light blue
        minRank = 0
    },
    ["A"] = {
        name = "ADVANCED",
        label = "Advanced Pursuit",
        description = "20% performance boost. For highway pursuits",
        icon = "car-burst",
        speedMultiplier = 1.2,
        accelerationMultiplier = 1.15,
        handling = 1.1, 
        braking = 1.15,
        color = {r = 255, g = 165, b = 0},   -- Orange
        minRank = 0
    },
    ["S"] = {
        name = "SUPERIOR",
        label = "Superior Pursuit",
        description = "30% performance boost. For emergency situations only",
        icon = "car-on",
        speedMultiplier = 1.3,
        accelerationMultiplier = 1.2,
        handling = 1.15,
        braking = 1.2,
        color = {r = 255, g = 0, b = 0},     -- Red
        minRank = 0
    }
}

-- All police vehicles can use any pursuit mode
Config.PursuitVehicles = {
    -- Standard patrol vehicles
    ["police"] = true,
    ["police2"] = true,
    ["police3"] = true,
    ["police4"] = true,
    ["sheriff"] = true,
    ["sheriff2"] = true,
    
    -- Specialty vehicles
    ["fbi"] = true,
    ["fbi2"] = true,
    ["policeb"] = true,
    ["policeold1"] = true,
    ["policeold2"] = true,
    ["policet"] = true,
    ["riot"] = true,
    ["polmav"] = true
}

-- Menu settings using ox_lib context menu
Config.Menu = {
    title = "Pursuit Mode",
    position = "right",
    canClose = true
}

-- UI display settings for pursuit mode indicator
Config.UI = {
    enabled = true,
    position = {x = 0.01, y = 0.01},
    showBoostPercentage = true,
    showClass = true
}

-- Controls
Config.Controls = {
    openMenuKey = 168,       -- F7 key to open pursuit mode menu
    command = 'pursuit',     -- Command to open pursuit menu
    radialmenuEvent = 'police_pursuit:toggleMenu' -- Event to add to radial menu
}

-- Disable pursuit mode in these situations
Config.DisableOn = {
    seatChange = true,      -- When changing seats
    vehicleExit = true,     -- When exiting vehicle
    jobChange = true,       -- When changing job
    engineOff = true        -- When engine is turned off
}
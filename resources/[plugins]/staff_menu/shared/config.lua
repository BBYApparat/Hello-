Config = {}

-- Menu Key Binding
Config.MenuKey = 'F6' -- Key to open staff menu

-- Staff Groups (in order of hierarchy)
Config.StaffGroups = {
    ['owner'] = { level = 4, label = 'Owner' },
    ['admin'] = { level = 3, label = 'Admin' },
    ['moderator'] = { level = 2, label = 'Moderator' },
    ['helper'] = { level = 1, label = 'Helper' }
}

-- Weather Options
Config.WeatherTypes = {
    { value = 'EXTRASUNNY', label = 'Extra Sunny' },
    { value = 'CLEAR', label = 'Clear' },
    { value = 'NEUTRAL', label = 'Neutral' },
    { value = 'SMOG', label = 'Smog' },
    { value = 'FOGGY', label = 'Foggy' },
    { value = 'OVERCAST', label = 'Overcast' },
    { value = 'CLOUDS', label = 'Clouds' },
    { value = 'CLEARING', label = 'Clearing' },
    { value = 'RAIN', label = 'Rain' },
    { value = 'THUNDER', label = 'Thunder' },
    { value = 'SNOW', label = 'Snow' },
    { value = 'BLIZZARD', label = 'Blizzard' },
    { value = 'SNOWLIGHT', label = 'Light Snow' },
    { value = 'XMAS', label = 'Christmas' },
    { value = 'HALLOWEEN', label = 'Halloween' }
}

-- Permissions for different actions
Config.Permissions = {
    -- Everyone gets these
    ['noclip'] = { minLevel = 1 },
    ['fixgarage'] = { minLevel = 1 },
    ['goto'] = { minLevel = 1 },
    ['bring'] = { minLevel = 1 },
    ['blips'] = { minLevel = 1 },
    
    -- Higher level permissions
    ['changegroup'] = { minLevel = 3 }, -- Admin+
    ['weather'] = { minLevel = 2 }, -- Moderator+
    ['spawncar'] = { minLevel = 2 }, -- Moderator+
    ['kick'] = { minLevel = 2 }, -- Moderator+
    ['ban'] = { minLevel = 2 }, -- Moderator+
    ['unban'] = { minLevel = 3 }, -- Admin+
    ['heal'] = { minLevel = 2 }, -- Moderator+
    ['armor'] = { minLevel = 2 }, -- Moderator+
    ['revive'] = { minLevel = 2 }, -- Moderator+
    ['freeze'] = { minLevel = 2 }, -- Moderator+
    ['spectate'] = { minLevel = 2 } -- Moderator+
}

-- Blip Settings
Config.Blips = {
    showStaff = true, -- Show staff with different colors
    showHealth = true,
    showArmor = true,
    showFood = true,
    showWater = true,
    updateInterval = 1000, -- Update every second
    
    -- Blip colors for different groups
    colors = {
        ['owner'] = { r = 255, g = 0, b = 255 }, -- Magenta
        ['admin'] = { r = 255, g = 0, b = 0 }, -- Red  
        ['moderator'] = { r = 255, g = 165, b = 0 }, -- Orange
        ['helper'] = { r = 0, g = 255, b = 0 }, -- Green
        ['user'] = { r = 255, g = 255, b = 255 } -- White
    }
}
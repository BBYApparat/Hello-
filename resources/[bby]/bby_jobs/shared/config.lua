Config = {}

-- Jobs that have duty system
Config.DutyJobs = {
    'police',
    'sheriff',
    'ambulance',
    'fire',
    'mechanic',
    'taxi',
    'tow'
}

-- Blip configurations for jobs when on duty
Config.JobBlips = {
    police = {
        coords = vector3(428.23, -981.28, 30.71), -- Mission Row PD
        sprite = 60,
        color = 29,
        scale = 0.8,
        label = "Police Department"
    },
    sheriff = {
        coords = vector3(-449.13, 6014.25, 31.72), -- Paleto Sheriff
        sprite = 60,
        color = 29,
        scale = 0.8,
        label = "Sheriff Department"
    },
    ambulance = {
        coords = vector3(295.87, -1448.13, 29.97), -- Central Medical
        sprite = 61,
        color = 1,
        scale = 0.8,
        label = "Medical Center"
    },
    fire = {
        coords = vector3(1692.62, 3584.95, 35.62), -- Sandy Shores Fire
        sprite = 436,
        color = 1,
        scale = 0.8,
        label = "Fire Department"
    },
    mechanic = {
        coords = vector3(-347.32, -133.66, 39.01), -- LS Customs
        sprite = 446,
        color = 5,
        scale = 0.8,
        label = "Mechanic Shop"
    },
    taxi = {
        coords = vector3(907.24, -150.37, 74.17), -- Downtown Cab Co.
        sprite = 198,
        color = 5,
        scale = 0.8,
        label = "Taxi Service"
    },
    tow = {
        coords = vector3(408.91, -1622.68, 29.29), -- Tow Yard
        sprite = 68,
        color = 5,
        scale = 0.8,
        label = "Tow Service"
    }
}

-- Default blip settings
Config.DefaultBlip = {
    sprite = 280,
    color = 0,
    scale = 0.8
}
Config = {}

Config.Options = {
    devMode = false, -- helps you restarting the resource.
    checkVersion = true, -- checking latest version for updates
    lang = "en",
    framework = "esx",   -- "qb", "esx", "custom"
    inventory = "ox",   -- "qb", "qs", "lj", "ox", "mf", "core", "custom"
    target = "ox",      -- "qb", "q", "ox" | (ox supports both qb-target/q-target)
    notify = "default", -- "default", "qb", "esx", "ox", "ps-ui", "okok", "custom" | (default = will use default framework notify) (custom = you have to impliment at shared/client/custom.lua)
}

Config.Interact = "ox"

Config.DMVSchool = { 
    vector4(222.06, -1395.19, 30.59, 277.64)
}

Config.Peds = {
    `a_f_m_bevhills_02`,
    `a_f_m_ktown_01`,
    `a_f_m_soucentmc_01`,
    `a_m_m_soucent_02`,
    `a_m_y_soucent_04`
}

Config.Language = "en"

Config.SpeedMultiplier = 3.6 -- 3.6 for kmh, 2.236936 for mph

Config.MaxErrors = 2 -- Max errors before fail

Config.MarkerSettings = {
    type = 2,
    size = vector3(1.0, 1.0, 1.0),
    color = vector3(255, 255, 255),
    rotate = false,
    dump = false
}

Config.PuntiMinimi = 5 -- Minimum points to pass the theory test

-- ATTENTION: Modifying the id after a user has already obtained a license causes them to be lost
Config.License = {
    {
        label = 'License Bike',
        category = 'BIKE',
        id = 'drive_bike',
        img = 'bike.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'faggio',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'License Car',
        category = 'CAR',
        id = 'drive',
        img = 'car.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'blista',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'License Truck',
        category = 'TRUCK',
        id = 'drive_truck',
        img = 'truck.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'pounder',
            coords = vector3(225.34, -1401.78, 30.19),
            heading = 145.1,
            plate = "DMV1"
        }
    }
}

Config.PracticeCoords = {
    [1] = {
        {
            coordinate = vector3(227.1181, -1399.691, 30.1),
            speedLimit = 55
        },
        {
            coordinate = vector3(183.7479, -1394.595, 29.05295),
            speedLimit = 55
        },
        {
            coordinate = vector3(210.3608, -1327.127, 29.16619),
            speedLimit = 55
        },
        {
            coordinate = vector3(217.6466, -1145.248, 29.3349),
            speedLimit = 55
        },
        {
            coordinate = vector3(83.13854, -1136.699, 29.15778),
            speedLimit = 55
        },
        {
            coordinate = vector3(55.52874, -1248.127, 29.34311),
            speedLimit = 55
        },
        {
            coordinate = vector3(82.69904, -1338.678, 29.3447),
            speedLimit = 55
        },
        {
            coordinate = vector3(131.4893, -1387.581, 29.28993),
            speedLimit = 55
        },
        {
            coordinate = vector3(220.603, -1445.61, 29.24681),
            speedLimit = 55
        },
        {
            coordinate = vector3(242.2584, -1536.136, 29.24705),
            speedLimit = 55
        },
        {
            coordinate = vector3(301.6448, -1523.68, 29.34156),
            speedLimit = 55
        },
        {
            coordinate = vector3(256.1726, -1445.458, 29.24207),
            speedLimit = 55
        },
        {
            coordinate = vector3(233.427, -1397.215, 30.5071),
            speedLimit = 55
        },
    }
}

Config.Lang = {
    ['en'] = {
        ['speed_error'] = "You are going too fast, slow down!",
        ['open_dmv'] = "Press ~INPUT_CONTEXT~ to open the DMV",
        ['dmv'] = "DMV SCHOOL",
        ['point'] = "POINT",
        ['error'] = "ERROR",
        ['ok'] = "Ok",
        ['start_theory'] = "Theory Test",
        ['theory_before'] = "You need theory test",
        ['start_practice'] = "Practice Test",
        ['test_passed'] = "Test Passed!",
        ['already_done'] = "You have already done!",
        ['theory_success'] = "Congratulations, you passed the theory test, come back soon for the practical test!",
        ['theory_error'] = "We are sorry to inform you that you did not pass the theory test, do not give up, come back soon more prepared and try the test again!",
        ['practice_success'] = "Congratulations, you passed the practical test, you are now a licensed driver!",
        ['practice_error'] = "We are sorry to inform you that you did not pass the practical test, do not give up, come back soon more prepared and try the test again!",
        ['money_error'] = "You don't have enough money to do this test! You are missing %s€",
        ['target_open_dmv'] = "Driving School"
    },
    ['gr'] = {
        ['speed_error'] = "You are going too fast, slow down!",
        ['open_dmv'] = "Press ~INPUT_CONTEXT~ to open the DMV",
        ['dmv'] = "DMV SCHOOL",
        ['point'] = "POINT",
        ['error'] = "ERROR",
        ['ok'] = "Ok",
        ['start_theory'] = "Start the Theory Test",
        ['theory_before'] = "Take the theory test",
        ['start_practice'] = "Start the Practice Test",
        ['test_passed'] = "Test Passed!",
        ['already_done'] = "You have already done!",
        ['theory_success'] = "Congratulations, you passed the theory test, come back soon for the practical test!",
        ['theory_error'] = "We are sorry to inform you that you did not pass the theory test, do not give up, come back soon more prepared and try the test again!",
        ['practice_success'] = "Congratulations, you passed the practical test, you are now a licensed driver!",
        ['practice_error'] = "We are sorry to inform you that you did not pass the practical test, do not give up, come back soon more prepared and try the test again!",
        ['money_error'] = "You don't have enough money to do this test! You are missing %s€",
        ['target_open_dmv'] = "Driving School"
    },
}

-- Functions --

onCompleteTheory = function(license)
    TriggerServerEvent('ricky-dmv:givelicense', license) -- Give license to sql
end

onCompletePractice = function(license)
    TriggerServerEvent('ricky-dmv:givelicense', license) -- Give license to sql
end 
Config.workshops = Config.workshops or {}

-- This config is made to work with the Kiiya's Tuner Shop MLO
-- Check: https://kiiya.tebex.io/package/5148409

Config.workshops.tunershop = {
    enabled = true,
    label = 'Tuner Shop',
    job = 'tuner',
    blip = { enabled = true, coords = vector3(167.14, -3112.18, 5.86), color = 4, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vector3(167.14, -3112.18, 5.86),
            vector3(168.49, -2986.27, 5.89),
            vector3(115.26, -2991.56, 6.01),
            vector3(115.1, -3144.57, 6.01)
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(761.05, -1298.9, 26.25), radius = 0.5 },
    },
    stashes = {
        { coords = vec3(760.05, -1272.05, 26.8), radius = 0.9, slots = 50, weight = 100 },
    },
    crafts = {
        { coords = vec3(744.5, -1264.7, 27.0), radius = 0.6, categories = { 'performance', 'others' } },
    },
    shops = {
        { coords = vec3(735.75, -1266.3, 26.8), radius = 0.6, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(739.0, -1266.4, 27.3), radius = 0.3, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(757.0, -1293.2, 26.1), radius = 0.2, prop = 'hei_prop_hei_bank_phone_01', propHeading = 139.31+180, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(733.41, -1290.31, 25.29, 89.3+180),
            spawnCoords = vec4(726.33, -1290.74, 26.28, 89.37),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}
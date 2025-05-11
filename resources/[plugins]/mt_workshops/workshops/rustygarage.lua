Config.workshops = Config.workshops or {}

-- This config is made to work with the FM Shop Rusty Garage MLO
-- Check: https://fmshop.tebex.io/category/2175260

Config.workshops.rustygarage = {
    enabled = true,
    label = 'Import Garage',
    job = 'import',
    blip = { enabled = true, coords = vector3(973.92, -984.78, 41.91), color = 1, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vector3(971.94, -984.06, 36.1),
            vector3(899.66, -988.4, 36.09),
            vector3(899.18, -915.5, 36.09),
            vector3(953.46, -915.33, 36.09)
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(742.8, -790.5, 26.4), radius = 0.3 },
    },
    stashes = {
        { coords = vec3(733.75, -787.45, 27.0), radius = 1.0, slots = 50, weight = 100 },
    },
    crafts = {
        { coords = vec3(732.1, -781.1, 26.4), radius = 0.45, categories = { 'performance', 'others' } },
    },
    shops = {
        { coords = vec3(746.25, -792.25, 26.75), radius = 0.95, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(745.8, -788.1, 26.4), radius = 0.45, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(728.45, -777.45, 29.3), radius = 0.2, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(756.65, -766.36, 25.46, 185.46+180),
            spawnCoords = vec4(763.05, -774.22, 26.32, 177.79),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}
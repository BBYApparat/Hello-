Config.workshops = Config.workshops or {}

-- This config is made to work with the Kiiya's Los Santos Customs MLO
-- Check: https://kiiya.tebex.io/package/6126959

Config.workshops.lscustoms = {
    enabled = true,
    label = 'Los Santos Customs',
    job = 'mechanic',
    blip = { enabled = false, coords = vec3(-354.76, -124.52, 38.78), color = 3, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(-358.57, -188.13, 37.60),
            vec3(-304.96, -169.26, 37.60),
            vec3(-286.09, -98.81, 37.60),
            vec3(-399.41, -56.21, 37.60),
            vec3(-419.7, -79.0, 37.60)
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(-325.2, -130.6, 43.8), radius = 0.45 },
    },
    stashes = {
        { coords = vec3(-332.3, -134.8, 39.1), radius = 0.45, slots = 50, weight = 100 },
    },
    crafts = {
        { coords = vec3(-331.5, -131.15, 39.0), radius = 0.45, categories = { 'performance', 'others' } },
    },
    shops = {
        { coords = vec3(-332.15, -133.2, 39.0), radius = 0.3, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(-350.6, -138.95, 39.45), radius = 0.3, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(-350.75, -139.35, 39.45), radius = 0.2, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(-353.94, -114.54, 37.7, 70.38+180),
            spawnCoords = vec4(-358.3, -113.85, 38.7, 136.86),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}
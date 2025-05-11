Config.UseBilling = true
Config.BillingMenu = 167

Config.Salon = {
    {
        blip = {enable = false, name = 'Nail Salon', color = 1, sprite = 71, size = 1.0},
        boss_action = vector3(225.54, -1544.86, 29.29), -- this is also the location of the shop blip
        container = {
            {type = 'barber', title ='Barber'}, 
        },
        chairs = {
            type1 = {   -- barber sit animation
                vector4(216.94, -1543.43, 28.29, 214.16),
                vector4(215.38, -1544.52, 28.29, 221.87),
                vector4(213.8, -1545.83, 28.29, 218.96),
            },
            type2 = {   -- nail sit animation
                vector4(220.04, -1545.49, 28.29, 115.71),
                vector4(217.27, -1547.67, 28.29, 110.61),
            }
        },
        job = {nailsalon = 0}, -- job_name, minimum rank. set all = 0 if job is not required
    },
    
}

Config.Tattoos = {
    {
        blip = {enable = false, name = 'Tattoo Shop', color = 1, sprite = 75, size = 0.6},
        boss_action = vector3(319.55, 180.85, 103.59), -- this is also the location of the shop blip
        container = {
            {type = 'tattoos', title ='Tattoos'},
        },
        chairs = {
            type1 = {   -- front animation
                vector4(324.12, 181.27, 102.59, 120.0),
            },
            type2 = {   -- back animation
                vector4(325.74, 180.6, 103.21, 321.07)
            }
        },
        job = {tattoo = 0}, -- job_name, minimum rank. set all = 0 if job is not required
    },
}
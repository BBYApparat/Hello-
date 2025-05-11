local blips = {
    -- {title="", colour=, id=, x=, y=, z=},
    -- {pos = vector3(-57.38, -1099.396, 26.38), sprite = 225, color = 3, size = 0.6, radius = 0.0, name = 'PDM'},
    -- {pos = vector3(301.95, 201.05, 109.56), sprite = 121, color = 7, size = 0.6, radius = 0.0, name = 'Raul Nightclub'},
    -- {pos = vector3( -451.4737,  -33.34594, 109.56), sprite = 93, color = 7, size = 0.6, radius = 0.0, name = 'Hookah Lounge'},
    -- {pos = vector3(-818.95, -710.05, 109.56), sprite = 93, color = 7, size = 0.6, radius = 0.0, name = 'Wi Wang'},
    -- {pos = vector3(2780.44, 3457.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'Stop Car'},
    -- {pos = vector3(208.2, -192.49, 53.97), sprite = 75, color = 6, size = 0.6, radius = 0.0, name = 'Sushi Bar'},
    -- {pos = vector3(278.2, 141.49, 53.97), sprite = 75, color = 6, size = 0.6, radius = 0.0, name = 'Polar Ice'},
    -- {pos = vector3(-1086.12, -2044.18, 13.18), sprite = 72, color = 2, size = 0.6, radius = 0.0, name = 'Motors Mechanic'},
    -- {pos = vector3(-1686.57, -1079.83, 65.5), sprite = 75, color = 2, size = 0.6, radius = 0.0, name = 'Candy Shop'},
    -- {pos = vector3(895.44, -2115.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'East Customs'},
    -- {pos = vector3(965.44, -1030.4, 55.51), sprite = 72, color = 1, size = 0.6, radius = 0.0, name = 'Big Tuna'},
    --{title="Tacos", colour=1, id=75, x = 5.04, y = -1605.5, z = 15.97},

    { title = "Town Hall",         colour = 0, id = 419, x = -547.44,  y = -198.4,   z = 55.51 },
    { title = "Motel",             colour = 0, id = 475, x = 313.24,   y = -225.98,  z = 54.22 },
    { title = "Ls Customs",        colour = 1, id = 72,  x = -368.44,  y = -132.4,   z = 55.51 },
    { title = "UwU Cat Cafe",      colour = 2, id = 75,  x = -581.57,  y = -1070.83, z = 65.5 },
    { title = "Burgershot",        colour = 1, id = 75,  x = -1179.04, y = -884.5,   z = 15.97 },
    { title = "Bahamas Nightclub", colour = 7, id = 93,  x = -1388.95, y = -586.05,  z = 109.56 },
    { title = "Vanilla Nightclub", colour = 7, id = 121, x = 130.95,   y = -1300.05, z = 109.56 },
    { title = "Digital Den",       colour = 7, id = 521, x = -1278.92, y = -1413.07, z = 4.34 },
    { title = "Pearls",            colour = 7, id = 75,  x = -1816.17, y = -1193.23, z = 14.3 },
    { title = "Impound",           colour = 1, id = 50,  x = -191.3,   y = -1159.43, z = 23.24 },
    { title = "Polar Ice",         colour = 3, id = 75,  x = 279.9,    y = 145.69,   z = 104.28 },
    { title = "Tacos",             colour = 3, id = 75,  x = 8.29,    y = -1608.98,   z = 29.29 },

}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.6)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

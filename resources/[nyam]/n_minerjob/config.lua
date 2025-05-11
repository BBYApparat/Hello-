Config = {}

Config.Options = {
    devMode = false, -- helps you restarting the resource.
    checkVersion = true, -- checking latest version for updates
    lang = "en",
    framework = "esx",   -- "qb", "esx", "custom"
    inventory = "ox",   -- "qb", "qs", "lj", "ox", "mf", "core", "custom"
    target = "ox",      -- "qb", "q", "ox" | (ox supports both qb-target/q-target)
    notify = "default", -- "default", "qb", "esx", "ox", "ps-ui", "okok", "custom" | (default = will use default framework notify) (custom = you have to impliment at shared/client/custom.lua)
    minItems = 1,
    maxItems = 2,
    maxHits = 5
}

Config.Mining = {
    zones = {
        dynamic = {
            blip = {
                label = "Mining",
                coords = vec3(2953.671, 2789.29, 41.485),
                sprite = 618,
                color = 21,
                size = 0.8
            },
            center = vec3(2953.671, 2789.29, 41.485),
            maxSpawnRadius = 60, -- not used rn correctly.
            minRocks = 10, -- once rocks left (X) will spawn new till `maxRocks`
            maxRocks = 25,
            radius = 100, -- to get inside zone where it will start spawning rocks..
            object = `csx_coastsmalrock_05_`
        },
        manual = {
            blip = {
                label = "Mining Tunnel",
                coords = vec3(-596.05, 2088.56, 130.59),
                sprite = 618,
                color = 21,
                size = 0.8
            },
            center = vec3(-545.25, 1986.02, 127.20),
            maxSpawnRadius = 50,
            minRocks = 5, -- once rocks left (X) will spawn new till `maxRocks`
            maxRocks = 15, -- cannot put more than vectors at `coords`
            radius = 90, -- poly zone rad enterance
            object = `csx_coastsmalrock_05_`,
            coords = {
                vec3(-549.044495, 1990.285034, 127.069183), vec3(-546.649292, 1990.831177, 127.124763), vec3(-545.524902, 1989.691650, 127.014870), vec3(-544.734802, 1988.043579, 127.003380),
                vec3(-547.378479, 1986.550415, 127.087349), vec3(-546.893860, 1985.165771, 127.118156), vec3(-546.126892, 1983.447266, 127.073853), vec3(-545.702942, 1981.652222, 127.070808),
                vec3(-542.958740, 1979.950439, 127.059555), vec3(-542.494812, 1979.191650, 127.021759), vec3(-543.846558, 1975.682007, 127.042511), vec3(-544.158997, 1974.047729, 127.030609),
                vec3(-541.605652, 1972.662964, 127.041039), vec3(-541.389465, 1970.998047, 126.983688), vec3(-543.354980, 1969.218384, 127.013649), vec3(-543.695374, 1968.152588, 127.200775),
                vec3(-541.517822, 1965.920776, 126.854744), vec3(-540.611694, 1963.984009, 126.811584), vec3(-542.729431, 1961.702515, 126.850693), vec3(-542.396973, 1959.443604, 126.645988),
                vec3(-542.200439, 1958.222534, 126.588165), vec3(-539.738831, 1957.644653, 126.583237), vec3(-541.557800, 1953.789917, 126.520142), vec3(-539.033325, 1952.846069, 126.346565),
                vec3(-542.483765, 1978.653198, 127.099091), vec3(-542.836914, 1981.301270, 127.028900), vec3(-544.362366, 1984.690308, 127.196526), vec3(-543.994568, 1987.332764, 127.027351),
                vec3(-544.855042, 1988.579590, 126.970833), vec3(-546.258667, 1990.434692, 127.027946), vec3(-542.459778, 1985.488892, 127.095024), vec3(-539.556824, 1983.754639, 126.982468),
                vec3(-536.859192, 1982.565186, 127.152763), vec3(-534.348389, 1982.481323, 127.013939), vec3(-531.172546, 1981.689941, 126.976357), vec3(-528.189453, 1981.253906, 126.985611),
                vec3(-525.131592, 1980.897339, 126.758018), vec3(-522.666260, 1980.205811, 126.823097), vec3(-519.719604, 1980.449097, 126.668404), vec3(-517.255676, 1980.359375, 126.445877),
                vec3(-514.029175, 1980.057129, 126.468674), vec3(-512.089661, 1980.131958, 126.274826), vec3(-511.403442, 1978.993530, 126.299759), vec3(-511.795563, 1977.638184, 126.354462),
                vec3(-513.427612, 1977.577148, 127.384491), vec3(-514.209717, 1977.908691, 126.321510), vec3(-516.300598, 1977.850464, 126.463501), vec3(-518.094727, 1977.802612, 126.644112),
                vec3(-520.891541, 1978.060181, 126.621544), vec3(-522.348450, 1979.120239, 126.744186), vec3(-524.942383, 1978.581787, 126.809311), vec3(-527.919312, 1978.657227, 126.904045),
                vec3(-529.896057, 1979.596558, 126.977974), vec3(-532.311340, 1979.364868, 127.106041), vec3(-535.028015, 1979.987061, 127.034126), vec3(-536.787659, 1980.310547, 127.048714),
            }
        }
    },
    items = {
        dynamic = {
            {name = "copper_nugget", amount = {min = 2, max = 4}, chance = 15, zone = "dynamic"},
            {name = "iron_nugget", amount = {min = 2, max = 4}, chance = 15, zone = "dynamic"},
            {name = "silver_nugget", amount = {min = 2, max = 3}, chance = 15, zone = "dynamic"},
            {name = "gold_nugget", amount = {min = 1, max = 2}, chance = 15, zone = "dynamic"},
            {name = "titanium_nugget", amount = {min = 1, max = 2}, chance = 10, zone = "dynamic"},
        },
        manual = {
            {name = "carbon_piece", amount = {min = 1, max = 1}, chance = 10, zone = "manual"},
            {name = "uncut_diamond", amount = {min = 1, max = 1}, chance = 10, zone = "manual"},
            {name = "uncut_ruby", amount = {min = 1, max = 1}, chance = 10, zone = "manual"},
        }
    }
}
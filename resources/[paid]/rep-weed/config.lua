Config = {}
Config.Target = 'ox_target' -- qb-target, ox_target
Config.UseTalkNPC = false    -- means use rep-talkNPCv2
Config.QBDefault = false    -- If u want use qb-menu, qb-input
Config.Inventory = 'ox'     --qs, old-qb, new-qb
Config.Debug = true         -- debug soils. If true, plant down a plant, and see the soil hashes in the f8 console
Config.HyperData = true -- If don't want hyperdata transfer, turn off it

Config.Items = {
    ['femaleseed'] = 'femaleseed',
    ['maleseed'] = 'maleseed',
    ['wateringcan'] = 'wateringcan',
    ['fertilizer'] = 'fertilizer',
    ['wetbud'] = 'wetbud',
    ['driedbud'] = 'driedbud',
    ['weedbaggie'] = 'weedbaggie',
    ['weedpackage'] = 'weedpackage',
    ['qualityscales'] = 'qualityscales',
    ['smallscales'] = 'smallscales',
    ['emptybaggies'] = 'emptybaggies',
    ['joint'] = 'joint',
    ['rollingpaper'] = 'rollingpaper',
}

Config.Boss = { -- you can add more boss location here, he automatically switch locations every restart
    [1] = {
        ped = 'a_m_y_soucent_02',
        pos = vector4(88.58, -1434.18, 28.31, 142.83)
    },
    [2] = {
        ped = 'g_m_m_chigoon_01',
        pos = vector4(116.26, -1685.88, 32.49, 316.52)
    },
}

Config.Logger = {
    oxlog = true,
    discord = {
        link = "",
        tag = true,
        img = '',
        color = 14423100, -- https://www.spycolor.com/
    }
}

Config.Plant = {
    growthObjects = {
        { model = 'bkr_prop_weed_01_small_01b', zOffset = -0.5 },
        { model = 'bkr_prop_weed_med_01a',      zOffset = -0.5 },
        { model = 'bkr_prop_weed_med_01b',      zOffset = -0.5 },
        { model = 'bkr_prop_weed_lrg_01a',      zOffset = -0.5 },
        { model = 'bkr_prop_weed_lrg_01b',      zOffset = -0.5 },
    },
    factor = 1.3,     -- How much longer does a male plant take to grow compared to a female plant (Femela plant = 1)
    growthTime = 1,    -- Plant Growing time in minutes 240
    dry = 360,          -- 360 minutes to dry weed
    lifeTime = 1440,  -- Plant lifetime in minutes before wiped
    button = {
        plant = 38,   -- https://docs.fivem.net/docs/game-references/controls/
        cancel = 44,
    },
    minusWater = 1.25,       -- Water drained from plants per timeLoop. 1.25% per timeLoop minute on plants
    timeLoop = 5,          --minutes
    maxPersonTreeDist = 4.0, -- Max Distance from player to plant to be allowed to plant
    water = {
        wateringcan = {
            durability = 10, -- Minus 10% water in can per watering
            add = 50,        -- Add 50% to plant per water
        },
        water = {
            remove = 1, -- remove 1 item per watering
            add = 20,   -- Add 20% to plant per water
        },              -- Can add more items
    },
    can = {
        destroy = 95,       -- Plant can be destroyed after it has grown to 95%
        fertilizer = 50,    -- Plant can not be fertilized after 50%
        addMale = 25        -- Plant can not be pollinated after 25% (can't add male seed)
    },
    job = {                 -- Jobs that can destroy weed at any stage
        'police',           -- Add more job if u want
    },
    canDry = {           -- Where can you dry your plants?
        stash = true,
        player = false,
        trunk = false,
    },
    maleZone = false,       -- If true, male plants will pollinate females around it, and turn them into males, in a perimeter of maleZoneDist
    maleZoneDist = 20,
    materialHashes = {      -- soils
        [951832588] = true, ---If u want plant more soil to plant, turn on debug and add it in here
        [-461750719] = true,
        [930824497] = true,
        [581794674] = true,
        [-2041329971] = true,
        [-309121453] = true,
        [-913351839] = true,
        [-1885547121] = true,
        [-1915425863] = true,
        [-1833527165] = true,
        [2128369009] = true,
        [-124769592] = true,
        [-840216541] = true,
        [-2073312001] = true,
        [627123000] = true,
        [1333033863] = true,
        [-1286696947] = true,
        [-1942898710] = true,
        [-1595148316] = true,
        [435688960] = true,
        [223086562] = true,
        [1109728704] = true
    },
    destroyReward = {
        min = 1,
        max = 3,
    },
    -- Water rewards
    harvestReward = {
        [1] = {
            maleseed = {
                min = 1,
                max = 1,
            },
            femaleseed = {
                min = 1,
                max = 1,
            },
            wetbud = {
                min = 1,
                max = 1,
            },
        },
        [2] = {
            maleseed = {
                min = 1,
                max = 1,
            },
            femaleseed = {
                min = 1,
                max = 1,
            },
            wetbud = {
                min = 1,
                max = 1,
            },
        },
        [3] = {
            maleseed = {
                min = 1,
                max = 2,
            },
            femaleseed = {
                min = 1,
                max = 2,
            },
            wetbud = {
                min = 1,
                max = 2,
            },
        },
        [4] = {
            maleseed = {
                min = 2,
                max = 2
            },
            femaleseed = {
                min = 2,
                max = 2
            },
            wetbud = {
                min = 2,
                max = 2
            },
        },
        [5] = {
            maleseed = {
                min = 2,
                max = 2
            },
            femaleseed = {
                min = 2,
                max = 2
            },
            wetbud = {
                min = 2,
                max = 2
            },
        },
        [6] = {
            maleseed = {
                min = 2,
                max = 2
            },
            femaleseed = {
                min = 2,
                max = 2
            },
            wetbud = {
                min = 2,
                max = 2
            },
        },
        [7] = {
            maleseed = {
                min = 2,
                max = 3
            },
            femaleseed = {
                min = 2,
                max = 3
            },
            wetbud = {
                min = 2,
                max = 3
            },
        },
        [8] = {
            maleseed = {
                min = 2,
                max = 3
            },
            femaleseed = {
                min = 2,
                max = 3
            },
            wetbud = {
                min = 2,
                max = 3
            },
        },
        [9] = {
            maleseed = {
                min = 2,
                max = 4
            },
            femaleseed = {
                min = 2,
                max = 4
            },
            wetbud = {
                min = 2,
                max = 4
            },
        },  -- at 80-90% ...
        [10] = {
            maleseed = {
                min = 3,
                max = 4
            },
            femaleseed = {
                min = 3,
                max = 4
            },
            wetbud = {
                min = 3,
                max = 4
            },
        },          -- at 90-100% water, you can harvest 3-4 buds/seeds
    },
    maxHarvest = 2, -- Max harvest per plant. Once you harvested a plant, the plant will regrow for another cycle.
    strain = {
        n = {
            'Afghani Wonder',
            'Afgooey',
            'Apollo',
            'Buddha',
            'Burmaberry',
            'BushDoctor',
            'Bushmans',
            'Chem',
            'Cherry',
            'Chocolope',
            'Cinnamon',
            'Cotton',
            'Cripple',
            'Crystal',
            'Donk',
            'Ducksfoot',
            'Dutch',
            'Elvis',
            'Orange',
            'Rosado',
            'Verde',
            'Violeta',
            'Haze',
            'Urkle',
            'Emerald',
            'G',
            'Dynamite',
            'Earthquake',
            'Elephant',
            'Endless Sky',
            'Erez',
            'Euphoria',
            'Frosty',
            'Pebbles',
            'Incredible',
            'Melt',
            'Funky',
            'Cheese',
            'Firewalker',
            'Flo',
            'Fraggle',
            'Frankenberry',
            'Leonard',
            'Freeze',
            'Skydog',
            'Special',
            'Spurkle',
            'Sputnik',
            'Fuzzy',
            'George',
            'Ghost',
            'Scout',
            'Glass',
            'Gnarsty',
            'God',
            'Tora',
            'Vortex',
            'Shark',
            'Star',
            'Starry',
            'Tangerine',
        },
        p = {
            'Platinum',
            'Pineapple',
            'Papaya',
            'Lace',
            'Coconut',
            'Linen',
            'Bone',
            'Moss',
            'Shamrock',
            'Seafoam',
            'Pine',
            'Pakalolo',
            'Ivory',
            'Cream',
            'Egg shell',
            'Remus',
            'Salt',
            'Peanut',
            'Carob',
            'Hickory',
            'Salmon',
            'Pecan',
            'Walnut',
            'Caramel',
            'Gingerbread',
            'Syrup',
            'Parakeet',
            'Mint',
            'Seaweed',
            'Somantra',
            'Pistachio',
            'Basil',
            'Crocodile',
            'Brown',
            'Coffee',
            'Special',
            'Sweet',
            'Penny',
            'Cedar',
            'Grey',
            'Shadow',
            'Graphite',
            'Iron',
            'Pewter',
            'Cloud',
            'Silver',
            'Smoke',
            'Slate',
            'Anchor',
            'Ash',
            'Porpoise',
            'Dove',
            'Fog',
            'Flint',
            'Charcoal',
            'Pebble',
            'Lead',
            'Coin',
            'Fossil',
            'Black',
            'Ebony',
            'Crow',
            'Charcoal',
            'Onyx',
            'Pitch',
            'Soot',
            'Sable',
            'Coal',
            'Metal',
            'Obsidian',
            'Spider',
            'Leather',
            'Midnight',
            'Ink',
            'Raven',
            'Oil',
            'Grease',
        },
        k = {
            'Chase',
            'Cocktail',
            'Cocopuff',
            'Herb',
            'Chronic',
            'Blossom',
            'Flower',
            'Weed',
            'Pot',
            'Grass',
            'Reefer',
            'Ganja',
            'Lace',
            'Butter',
            'Geek',
            'Hash',
            'Bud',
            'Plant',
            'Bush',
        },
    },
    amount = {
        ['driedbud'] = 10,    -- 20 grams driedbud = 10 joints
        ['weedpackage'] = 14, -- 100grams weedpackge = 14 weedbaggie
        ['weedbaggie'] = 3    -- 1 weed baggie = 3 joints
    },
    jointLossRate = {
        ['qualityscales'] = 100,               -- Scale baggies at no loss
        ['smallscales'] = math.random(70, 80), -- lose 20-30% of weed if you use Small Scale
        ['none'] = math.random(40, 50)         -- lose 50-60% of weed if you don't use any scale
    },
    packageTime = 20, -- Wait 20 seconds for boss to pack weedpackages
    -- *Reputation
    repName = 40000, -- 40k rep points to be able to change names
    repString = {   -- Rep = 10 means 10 baggies need to be sold to level up
    -- Example: you can corner 300 baggies a day, your team has 5 people, it takes 605000/100 = 40 days to hit max rep on a strain.
    -- Possible to add unlimited rep stages
    -- Rep point is not capped
        [0] = { rep = 0, name = "Grass" },
        [1] = { rep = 1500, name = "Schwag" },
        [2] = { rep = 3500, name = "Burk" },
        [3] = { rep = 10000, name = "Reggie" },
        [4] = { rep = 15000, name = "Mids" },
        [5] = { rep = 20000, name = "Dank" },
        [6] = { rep = 25000, name = "Chronic" },
        [7] = { rep = 30000, name = "Admired" },
        [8] = { rep = 40000, name = "Primo" },
        [9] = { rep = 50000, name = "Respected" },
        [10] = { rep = 60000, name = "Ganja" },
    },
    jointEffect = {
        time = 3,                       -- 3 seconds per loop
        addArmorAmount = {
            [0] = { min = 2, max = 3 }, -- 0 is strain rep level 0, every loop you get 2-3 armor
            [1] = { min = 3, max = 4 },
            [2] = { min = 4, max = 5 },
            [3] = { min = 5, max = 6 },
            [4] = { min = 6, max = 7 },
            [5] = { min = 8, max = 9 },
            [6] = { min = 10, max = 11 },
            [7] = { min = 12, max = 13 },
            [8] = { min = 14, max = 16 },
            [9] = { min = 17, max = 19 },
            [10] = { min = 20, max = 25 }, -- at max rep, one loop of smoke will give you 20-25 armor.
        },
    },
    packageLocation = {
        {
            table =  vec4(1399.087890625, 3602.65380859375, 37.94190979003906, 20.0),
            ped = vec4(1398.73, 3603.5, 37.94, 202.48)
        },
        {
            table =  vec4(1399.4583740234376, 3611.179443359375, 38.00577545166015, 290.0),
            ped = vec4(1400.2, 3611.5, 38.0, 115.92)
        },
        {
            table =  vec4(1394.354248046875, 3617.89990234375, 37.92603302001953, 20.0),
            ped = vec4(1394.11, 3618.62, 37.92, 211.49)
        },
    },
}

Config.Cornerselling = {
    status = true,
    policeNeed = 0,
    populateRate = 1000 * 60 * 2,       -- default: 2 min/populate, -1 to disable
    timeBetweenAcquisition = 60 * 1000, -- default: 1 min/ped
    money = 50,
    policeAlert = 5, -- percents
    areaRep = {         -- Area rep is server wide, and will become 0 every tsunami/script restart.
        -- areaRep = (x/25)*1 -- x will +1 every sale made (not baggies sold)
        max = 120,      -- Capped at $120
        divisor = 25,   -- 25 sales (not baggies sold).
        money = 1,      -- Add 1 dollar every level reached
    },
    playerRep = 1, -- Each corner sale made, will add 1 rep to the player.
    perRep = {          -- Personal Rep will be persistent forever. +1 every cornering sales done.
        -- for every "divisor" you have + $1 in your payout
        max = 40,       -- Capped at 40 dollars
        divisor = 800,  -- 800 sales (not baggies sold).
        money = 1,      -- Add 1 dollar every level reached
    },
    strainRep = {       -- Strain Rep will be persistent forever
        max = 60,       -- Capped at $60
        divisor = 1000, -- 1000 sales (not baggies sold).
        money = 1,      -- Add 1 dollar every level reached
    },
    -- Payout = Area Rep + Personal Rep + Strain Rep + Money
    -- Example 1: You hit max rep on all factors with our default setting above. Estimated to be atleast 6 months of work? (not sure, feel free to make suggestions)
    -- Payout = 120 + 40 + 60 + 50 = $270 per baggie. Now this is capped and wont go higher.
    --
    -- Example 2: Lil Seoul currently has 1200 areaRep points. You have 25000 perRep points. Strain level 6, 25000 strainRep points.
    -- Payout = (1200/25) + (25000/800) + (25000/1000) + 50 = $154/baggie
    --
    -- Example 3: Just start selling weed for the first time, in your own shitty strain, but selling at a hot zone that everyones been selling, which means that area has max areaRep.
    -- Payout = 120(areaRep.max) + 0(No personal Rep) + 0(No Strain Rep) + 50 = 170
    whitelistedZones = {
        ['EBURO'] = true,
        ['MURRI'] = true,
        ['MIRR'] = true,
        ['EAST_V'] = true,
        ['CHAMH'] = true,
        ['DAVIS'] = true,
        ['CYPRE'] = true,
        ['HAWICK'] = true,
        ['DTVINE'] = true,
        ['BURTON'] = true,
        ['MOVIE'] = true,
        ['ROCKF'] = true,
        ['RICHM'] = true,
        ['PBLUFF'] = true,
        ['DELPE'] = true,
        ['BEACH'] = true,
        ['TERMINA'] = true,
        ['PBOX'] = true,
        ['KOREAT'] = true,
    },
    animIdle = {
        ['anim@mp_corona_idles@male_c@idle_a'] = 'idle_a',
        ['friends@fra@ig_1'] = 'base_idle',
        ['amb@world_human_hang_out_street@male_b@idle_a'] = 'idle_b',
        ['anim@heists@heist_corona@team_idles@male_a'] = 'idle',
        ['anim@mp_celebration@idles@female'] = 'celebration_idle_f_a',
        ['anim@mp_corona_idles@female_b@idle_a'] = 'idle_a',
        ['random@shop_tattoo'] = '_idle_a',
    },
}

Config.TacoShop = {
    status = true,
    policeNeed = 0,
    policeAlert = 15, -- percents
    price = 500, -- Price default per weedpackage
    maxPrice = 3500,
    strainRep = {
        divisor = 200,
        money = 10,
    },
    playerRep = {
        divisor = 800,
        money = 5,
    },
    -- payout = StrainRepMoney + PersonalRepMoney + WeedPackage.
    -- StrainRepMoney = (StrainRepPoints / weedpackage_divisor * weedpackage_bonus)
    -- PersonalRepMoney = (PerRep Points / PerRep.divisor)* money
    ped = { -- Weed run peds với chỉ số
        [1] = 'ig_money',
        [2] = 'a_m_y_beachvesp_02',
        [3] = 'a_m_y_breakdance_01',
        [4] = 'ig_car3guy1',
        [5] = 'a_m_y_business_03',
        [6] = 's_m_m_cntrybar_01',
        [7] = 'ig_devin',
        [8] = 'ig_dreyfuss',
        [9] = 'a_m_m_fatlatin_01',
        [10] = 'u_m_y_baygor',
        [11] = 'a_f_m_downtown_01',
        [12] = 'a_m_m_tourist_01',
        [13] = 'a_m_o_soucent_03',
        [14] = 'a_m_y_juggalo_01',
        [15] = 'a_m_y_soucent_02',
        [16] = 'a_m_y_vinewood_01',
        [17] = 'g_m_y_famfor_01',
        [18] = 'g_m_y_mexgang_01',
        [19] = 'g_m_m_chigoon_01',
        [20] = 'g_f_importexport_01',
    },
    points = { -- delivery ped location for weed runs
        [1] = { pos = vector4(-148.64, -1687.41, 36.17, 151.55), busy = false },
        [2] = { pos = vector4(-157.73, -1679.89, 36.97, 151.15), busy = false },
        [3] = { pos = vector4(-158.86, -1680.02, 36.97, 38.57), busy = false },
        [4] = { pos = vector4(-162.4, -1637.61, 34.03, 322.81), busy = false },
        [5] = { pos = vector4(26.43, -1815.44, 25.21, 331.3), busy = false },
        [6] = { pos = vector4(207.34, -1759.71, 29.27, 302.74), busy = false },
        [7] = { pos = vector4(420.54, -1564.77, 29.29, 51.76), busy = false },
        [8] = { pos = vector4(165.02, -1322.19, 29.29, 160.84), busy = false },
        [9] = { pos = vector4(141.48, -1059.3, 29.19, 167.76), busy = false },
        [10] = { pos = vector4(299.42, -761.64, 29.33, 295.08), busy = false },
        [11] = { pos = vector4(-3.57, -582.11, 38.83, 345.77), busy = false },
        [12] = { pos = vector4(-269.38, -587.98, 33.56, 272.09), busy = false },
        [13] = { pos = vector4(-574.35, -678.01, 32.36, 269.44), busy = false },
        [14] = { pos = vector4(-731.48, -729.87, 28.46, 76.75), busy = false },
        [15] = { pos = vector4(-753.3, -977.06, 16.13, 17.82), busy = false },
        [16] = { pos = vector4(-951.79, -901.44, 2.16, 302.86), busy = false },
        [17] = { pos = vector4(-1111.55, -902.22, 3.79, 124.29), busy = false },
        [18] = { pos = vector4(-1305.86, -929.61, 12.36, 12.7), busy = false },
        [19] = { pos = vector4(-1359.23, -710.65, 24.79, 127.05), busy = false },
        [20] = { pos = vector4(-1453.27, -653.2, 29.58, 83.48), busy = false },
        [21] = { pos = vector4(-1547.25, -524.91, 35.85, 35.97), busy = false },
        [22] = { pos = vector4(-1715.72, -446.77, 42.65, 47.7), busy = false },
        [23] = { pos = vector4(-1790.35, -368.79, 45.11, 337.98), busy = false },
        [24] = { pos = vector4(-1533.63, -326.94, 47.91, 51.61), busy = false },
        [25] = { pos = vector4(-1369.52, -169.13, 47.49, 79.62), busy = false },
        [26] = { pos = vector4(-1159.79, -219.77, 41.5, 252.27), busy = false },
        [27] = { pos = vector4(-813.33, -195.63, 37.48, 25.26), busy = false },
        [28] = { pos = vector4(-635.99, 44.07, 42.7, 84.02), busy = false },
        [29] = { pos = vector4(-520.8, 162.07, 71.08, 274.57), busy = false },
        [30] = { pos = vector4(-620.23, 208.61, 74.21, 200.95), busy = false },
        [31] = { pos = vector4(-942.9, 312.36, 71.35, 181.5), busy = false },
        [32] = { pos = vector4(-1114.9, 492.23, 82.19, 171.26), busy = false },
        [33] = { pos = vector4(-1370.26, 356.42, 64.25, 166.22), busy = false },
        [34] = { pos = vector4(-1648.91, 247.28, 62.39, 213.02), busy = false },
        [35] = { pos = vector4(-1898.71, 132.68, 81.98, 303.35), busy = false },
        [36] = { pos = vector4(-1896.2, 641.93, 130.21, 138.15), busy = false },
        [37] = { pos = vector4(1171.41, -291.82, 69.02, 318.51), busy = false },
        [38] = { pos = vector4(1221.25, -669.01, 63.49, 74.95), busy = false },
        [39] = { pos = vector4(802.08, -725.23, 27.81, 52.3), busy = false },
        [40] = { pos = vector4(857.44, -942.94, 26.28, 115.7), busy = false },
        [41] = { pos = vector4(978.15, -1500.15, 31.51, 85.26), busy = false },
        [42] = { pos = vector4(1193.49, -1622.34, 45.22, 123.56), busy = false },
        [43] = { pos = vector4(1005.17, -2128.42, 31.69, 264.73), busy = false },
    },
}

Config.Lang = {
    en = {
        bossNpc = {
            name = "Carlos Lehder",
            animScenario = "WORLD_HUMAN_AA_SMOKE",
            tag = "Dealer",
            color = "#404040",
            startMSG = "What do you want?",
            button1 = {
                [1] = "I want to deliver to you",
            },
            button2 = {
                [1] = "I think I need to rest",
            },
            button3 = {
                [1] = "I want to check my strain",
            },
            button4 = {
                [1] = "I'm just passing through here",
            },
        },
        blip = {
            sprite = 514,
            range = true,
            color = 52,
            scale = 0.7,
            label = "Drop Off Spot"
        },
        error = {
            police = {
                label = "There's a situation! Come back later!",
                type = "error",
                time = 5000
            },
            tacoshop_busy = {
                label = "Wait a minute, I will send you the address soon!",
                type = "error",
                time = 5000
            },
            plant_far = {
                label = "You can't plant too far",
                type = "error",
                time = 5000
            },
            harvest = {
                label = "Not ready for harvesting",
                type = "error",
                time = 5000
            },
            wrong_material = {
                label = "Find better ground to plant!",
                type = "error",
                time = 5000
            },
            error_zone = {
                label = "Nobody is buying around here",
                type = "error",
                time = 5000
            },
            no_customer = {
                label = "Looks like this spot has dried up",
                type = "error",
                time = 5000
            },
            out_zone =  {
                label = "No longer selling...",
                type = "error",
                time = 5000
            },
            stop_sell = {
                label = "Stopped selling drugs",
                type = "error",
                time = 5000
            },
            missing_baggies = {
                label = "You need more baggies to sell",
                type = "error",
                time = 5000
            },
            rollingpaper = {
                label = "Not enough papers",
                type = "error",
                time = 5000
            },
            scale = {
                label = "You need a scale to pack joints",
                type = "error",
                time = 5000
            },
            emptybaggies = {
                label = "You need more empty baggies",
                type = "error",
                time = 5000
            },
            package_busy = {
                label = "Someone is already preparing a package",
                type = "error",
                time = 5000
            },
            no_box = {
                label = "Where's the delivery? Is this a scam?",
                type = "error",
                time = 5000
            },
            long = {
                label = "Too long of a name",
                type = "error",
                time = 5000
            },
        },
        success = {
            start_sell = {
                label = "Started selling drugs",
                type = "success",
                time = 5000
            },
        },
        tacoshop = {
            stealveh = {
                label = "Find and steal a vehicle to use as transport",
                header = "CURRENT",
                icon = "fas fa-car-burst",
                color = "#59c5f7",
                time = "NONE"
            },
            go = {
                label = "Drive to the handoff location with the transport vehicle",
                header = "CURRENT",
                icon = "fas fa-car-burst",
                color = "#59c5f7",
                time = "NONE"
            },
        },
        textui = {
            plant = "[E] - Plant seed",
            cancel = "[Q] - Cancel",
        },
        progressbar = {
            plant = {
                label = "Planting",
                time = 5000
            },
            fillWater = {
                label = "Filling Can",
                time = 10000
            },
            addWater = {
                label = "Watering",
                time = 3000
            },
            setFertilizer = {
                label = "Adding Fertilizer",
                time = 3000
            },
            addMaleSeed = {
                label = "Adding MaleSeed",
                time = 3000
            },
            destroyPlant = {
                label = "Destroying",
                time = 3000
            },
            harvestPlant = {
                label = "Harvesting",
                time = 3000
            },
            rollJoints = {
                label = "Rolling Joints",
                time = 3000
            },
            prepareBaggies = {
                label = "Preparing",
                time = 3000
            },
            packageGood = {
                label = "Packing",
                time = 3000
            },
            weighingPackage = {
                label = "Weighing Package",
                time = 3000
            },
            countBills = {
                label = "Counting Bills",
                time = 3000
            },
        },
        input = {
            header = "Fertilizing Recipe",
            submit = "Submit",
            n = "Nitrogen (1-",
            p = "Phosphorus (1-",
            k = "Kali (1-",
        },
        input_changename = {
            header = "My Strains",
            submit = "Submit",
            desc = "Max Length : 21",
            label = "New names"
        },
        menu = {
            icon = "fas fa-cannabis",
            male = "Male",
            female = "Female",
            growth = "Growth: %s",
            gender = "Gender: %s",
            unknown = "Unknown",
            water = {
                title = "Add Water",
                label = "Water: %s",
                icon = "fas fa-tint",
            },
            fertilizer = {
                title = "Add Fertilizer",
                icon = "fas fa-seedling",
            },
            maleseed = {
                title = "Add Male Seed",
                label = "Make the plant preggies",
                icon = "fas fa-mars",
            },
            destroy = {
                title = "Destroy Plant",
                icon = "fas fa-times-circle",
            },
            checkstrain = {
                title = "My Strains",
                label = "Strain's Rep: ",
                icon = "fas fa-cannabis",
            },
        },
        target = {
            check = {
                label = "Check",
                icon = "fas fa-cannabis"
            },
            harvest = {
                label = "Harvest",
                icon = "fas fa-hand-paper"
            },
            droppack = {
                label = "Drop Package",
                icon = "fas fa-hand-paper"
            },
            cornerselling = {
                label = "Sell",
                icon = "fa-solid fa-comments-dollar"
            },
            start_cornerselling = {
                label = "Cornering weed",
                icon = "fa-solid fa-handshake"
            },
            stop_cornerselling = {
                label = "Stop cornering weed",
                icon = "fa-solid fa-handshake-slash"
            },
            signin = {
               label = "Sign In",
               icon = "fa-solid fa-user"
            },
            signout = {
                label = "Sign Out",
                icon = "fa-solid fa-user"
            },
            checkstrain = {
               label = "Check Strains",
               icon = "fas fa-cannabis"
            },
            packageGood = {
                label = "Package Goods",
                icon = "fas fa-box"
            },
            collectPackage = {
                label = "Collect Package",
                icon = "fas fa-box"
            },
        },
    }
}
local _lang = GetConvar('repscripts:locale', 'en')
Lang = Config.Lang[_lang]

Framework = {}

function Framework.ESX()
    return GetResourceState("es_extended") ~= "missing"
end

function Framework.QBCore()
    return GetResourceState("qb-core") ~= "missing"
end

function Framework.QBox()
    return GetResourceState("qbx_core") ~= "missing"
end

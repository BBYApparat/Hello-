Shared = {}

Shared.OnBuySpawnCoords = vector3(-26.33785, -1082.352, 26.441135)
Shared.OnBuySpawnHeading = 72.770057

Shared.PlateLetters = 3
Shared.PlateNumbers = 4
Shared.Ped = {
    pedModel = "cs_solomon",
    heading = 36.25,
    location = vector3(-57.03, -1098.93, 25.42)
}
Shared.QtargetOptions = {
    label = "Open Vehicle Shop",
    icon = "fas fa-car",
}
Shared.Blip = {
    ShowBlip = true, -- show car dealer blip on map true/false
    CarDealerBlipLabel = "Car Dealer", -- Label on map for this blip
    BlipCoords = vector3(-31.28239, -1098.036, 27.27441), -- Blip Coords
}
Shared.TestDrive = {
    CarSpawnLocation = vector3(-13.96, -1087.0, 26.67),
    AfterTestDriveLocation = vector4(-57.79, -1097.63, 26.42, 211.92),
    Timer = 45 -- secondds
}
function Notification(text) 
    ESX.ShowNotification(text)
end

trunk = {
    [0] = {21, 168000},		-- Compact
    [1] = {41, 328000},		-- Sedan
    [2] = {51, 408000},		-- SUV
    [3] = {31, 248000},		-- Coupe
    [4] = {41, 328000},		-- Muscle
    [5] = {31, 248000},		-- Sports Classic
    [6] = {31, 248000},		-- Sports
    [7] = {21, 168000},		-- Super
    [8] = {5, 40000},		-- Motorcycle
    [9] = {51, 408000},		-- Offroad
    [10] = {51, 408000},	-- Industrial
    [11] = {41, 328000},	-- Utility
    [12] = {61, 488000},	-- Van
    -- [14] -- Boat
    -- [15] -- Helicopter
    -- [16] -- Plane
    [17] = {41, 328000},	-- Service
    [18] = {41, 328000},	-- Emergency
    [19] = {41, 328000},	-- Military
    [20] = {61, 488000},	-- Commercial
    models = {
        [`xa21`] = {11, 10000}
    },
}

Shared.Classes = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains",
    [22] = "Open Wheel",
}

Shared.Vehicles = {
    cars = {
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rebel", --//(STRING)
            model = "rebel",
            photo = "https://example.com/images/rebel.png",-- //(STRING)
            price = 45000,	--//(INT)
            speed = 170,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 1 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Kalahari", --//(STRING)
            model = "kalahari",
            photo = "https://example.com/images/kalahari.png",-- //(STRING)
            price = 28000,	--//(INT)
            speed = 122,	--//(INT)
            stock = 10,
            trunk = 16,--	//(INT)
            id = 2 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dloader", --//(STRING)
            model = "dloader",
            photo = "https://example.com/images/dloader.png",-- //(STRING)
            price = 25000,	--//(INT)
            speed = 157,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 4 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Boor", --//(STRING)
            model = "boor",
            photo = "https://example.com/images/boor.png",-- //(STRING)
            price = 55000,	--//(INT)
            speed = 127,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 5 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bodhi2", --//(STRING)
            model = "bodhi2",
            photo = "https://example.com/images/bodhi2.png",-- //(STRING)
            price = 28000,	--//(INT)
            speed = 133,	--//(INT)
            stock = 10,
            trunk = 20,--	//(INT)
            id = 6 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blazer", --//(STRING)
            model = "blazer",
            photo = "https://example.com/images/blazer.png",-- //(STRING)
            price = 18000,	--//(INT)
            speed = 120,	--//(INT)
            stock = 10,
            trunk = 11,--	//(INT)
            id = 7 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blista2", --//(STRING)
            model = "blista2",
            photo = "https://example.com/images/blista2.png",-- //(STRING)
            price = 52000,	--//(INT)
            speed = 125,	--//(INT)
            stock = 10,
            trunk = 11,--	//(INT)
            id = 8 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Brioso2", --//(STRING)
            model = "brioso2",
            photo = "https://example.com/images/brioso2.png",-- //(STRING)
            price = 39000,	--//(INT)
            speed = 140,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 9 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Club", --//(STRING)
            model = "club",
            photo = "https://example.com/images/club.png",-- //(STRING)
            price = 48200,	--//(INT)
            speed = 146,	--//(INT)
            stock = 10,
            trunk = 21,--	//(INT)
            id = 10 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dilettante", --//(STRING)
            model = "dilettante",
            photo = "https://example.com/images/dilettante.png",-- //(STRING)
            price = 55500,	--//(INT)
            speed = 162,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 11 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Issi3", --//(STRING)
            model = "issi3",
            photo = "https://example.com/images/issi3.png",-- //(STRING)
            price = 40000,	--//(INT)
            speed = 171,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 12 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Panto", --//(STRING)
            model = "panto",
            photo = "https://example.com/images/panto.png",-- //(STRING)
            price = 45000,	--//(INT)
            speed = 169,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 13 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rhapsody", --//(STRING)
            model = "rhapsody",
            photo = "https://example.com/images/rhapsody.png",-- //(STRING)
            price = 45000,	--//(INT)
            speed = 123,	--//(INT)
            stock = 10,
            trunk = 11,--	//(INT)
            id = 14 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Weevil", --//(STRING)
            model = "weevil",
            photo = "https://example.com/images/weevil.png",-- //(STRING)
            price = 38500,	--//(INT)
            speed = 147,	--//(INT)
            stock = 10,
            trunk = 27,--	//(INT)
            id = 15 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Asea", --//(STRING)
            model = "asea",
            photo = "https://example.com/images/asea.png",-- //(STRING)
            price = 60000,	--//(INT)
            speed = 124,	--//(INT)
            stock = 10,
            trunk = 15,--	//(INT)
            id = 16 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Asterope", --//(STRING)
            model = "asterope",
            photo = "https://example.com/images/asterope.png",-- //(STRING)
            price = 82000,	--//(INT)
            speed = 163,	--//(INT)
            stock = 10,
            trunk = 10,--	//(INT)
            id = 17 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Emperor", --//(STRING)
            model = "emperor",
            photo = "https://example.com/images/emperor.png",-- //(STRING)
            price = 35600,	--//(INT)
            speed = 153,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 18 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Emperor2", --//(STRING)
            model = "emperor2",
            photo = "https://example.com/images/emperor2.png",-- //(STRING)
            price = 3730000830,	--//(INT)
            speed = 125,	--//(INT)
            stock = 10,
            trunk = 16,--	//(INT)
            id = 19 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Glendale", --//(STRING)
            model = "glendale",
            photo = "https://example.com/images/glendale.png",-- //(STRING)
            price = 62500,	--//(INT)
            speed = 139,	--//(INT)
            stock = 10,
            trunk = 15,--	//(INT)
            id = 20 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Premier", --//(STRING)
            model = "premier",
            photo = "https://example.com/images/premier.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 169,	--//(INT)
            stock = 10,
            trunk = 20,--	//(INT)
            id = 21 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Primo", --//(STRING)
            model = "primo",
            photo = "https://example.com/images/primo.png",-- //(STRING)
            price = 45800,	--//(INT)
            speed = 123,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 22 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Regina", --//(STRING)
            model = "regina",
            photo = "https://example.com/images/regina.png",-- //(STRING)
            price = 35450,	--//(INT)
            speed = 176,	--//(INT)
            stock = 10,
            trunk = 10,--	//(INT)
            id = 23 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stafford", --//(STRING)
            model = "stafford",
            photo = "https://example.com/images/stafford.png",-- //(STRING)
            price = 33000,	--//(INT)
            speed = 138,	--//(INT)
            stock = 10,
            trunk = 21,--	//(INT)
            id = 24 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stanier", --//(STRING)
            model = "stanier",
            photo = "https://example.com/images/stanier.png",-- //(STRING)
            price = 48500,	--//(INT)
            speed = 177,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 25 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Warrener", --//(STRING)
            model = "warrener",
            photo = "https://example.com/images/warrener.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 128,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 26 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller", --//(STRING)
            model = "baller",
            photo = "https://example.com/images/baller.png",-- //(STRING)
            price = 72000,	--//(INT)
            speed = 164,	--//(INT)
            stock = 10,
            trunk = 25,--	//(INT)
            id = 28 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bjxl", --//(STRING)
            model = "bjxl",
            photo = "https://example.com/images/bjxl.png",-- //(STRING)
            price = 85000,	--//(INT)
            speed = 138,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 29 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cavalcade", --//(STRING)
            model = "cavalcade",
            photo = "https://example.com/images/cavalcade.png",-- //(STRING)
            price = 79500,	--//(INT)
            speed = 153,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 30 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fq2", --//(STRING)
            model = "fq2",
            photo = "https://example.com/images/fq2.png",-- //(STRING)
            price = 92000,	--//(INT)
            speed = 170,	--//(INT)
            stock = 10,
            trunk = 16,--	//(INT)
            id = 31 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Habanero", --//(STRING)
            model = "habanero",
            photo = "https://example.com/images/habanero.png",-- //(STRING)
            price = 85500,	--//(INT)
            speed = 152,	--//(INT)
            stock = 10,
            trunk = 20,--	//(INT)
            id = 32 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Landstalker", --//(STRING)
            model = "landstalker",
            photo = "https://example.com/images/landstalker.png",-- //(STRING)
            price = 82500,	--//(INT)
            speed = 176,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 33 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Mesa", --//(STRING)
            model = "mesa",
            photo = "https://example.com/images/mesa.png",-- //(STRING)
            price = 75800,	--//(INT)
            speed = 129,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 34 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Serrano", --//(STRING)
            model = "serrano",
            photo = "https://example.com/images/serrano.png",-- //(STRING)
            price = 68500,	--//(INT)
            speed = 151,	--//(INT)
            stock = 10,
            trunk = 16,--	//(INT)
            id = 35 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Postlude", --//(STRING)
            model = "postlude",
            photo = "https://example.com/images/postlude.png",-- //(STRING)
            price = 93000,	--//(INT)
            speed = 165,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 36 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blade", --//(STRING)
            model = "blade",
            photo = "https://example.com/images/blade.png",-- //(STRING)
            price = 52000,	--//(INT)
            speed = 128,	--//(INT)
            stock = 10,
            trunk = 11,--	//(INT)
            id = 37 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Brigham", --//(STRING)
            model = "brigham",
            photo = "https://example.com/images/brigham.png",-- //(STRING)
            price = 35800,	--//(INT)
            speed = 132,	--//(INT)
            stock = 10,
            trunk = 10,--	//(INT)
            id = 38 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Broadway", --//(STRING)
            model = "broadway",
            photo = "https://example.com/images/broadway.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 164,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 39 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Buccaneer", --//(STRING)
            model = "buccaneer",
            photo = "https://example.com/images/buccaneer.png",-- //(STRING)
            price = 68000,	--//(INT)
            speed = 133,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 40 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Chino", --//(STRING)
            model = "chino",
            photo = "https://example.com/images/chino.png",-- //(STRING)
            price = 75500,	--//(INT)
            speed = 172,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 41 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Clique2", --//(STRING)
            model = "clique2",
            photo = "https://example.com/images/clique2.png",-- //(STRING)
            price = 45500,	--//(INT)
            speed = 137,	--//(INT)
            stock = 10,
            trunk = 18,--	//(INT)
            id = 42 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Eudora", --//(STRING)
            model = "eudora",
            photo = "https://example.com/images/eudora.png",-- //(STRING)
            price = 62500,	--//(INT)
            speed = 169,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 43 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faction", --//(STRING)
            model = "faction",
            photo = "https://example.com/images/faction.png",-- //(STRING)
            price = 83000,	--//(INT)
            speed = 140,	--//(INT)
            stock = 10,
            trunk = 26,--	//(INT)
            id = 44 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gauntlet3", --//(STRING)
            model = "gauntlet3",
            photo = "https://example.com/images/gauntlet3.png",-- //(STRING)
            price = 102000,	--//(INT)
            speed = 180,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 45 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Manana", --//(STRING)
            model = "manana",
            photo = "https://example.com/images/manana.png",-- //(STRING)
            price = 60000,	--//(INT)
            speed = 121,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 46 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Moonbeam", --//(STRING)
            model = "moonbeam",
            photo = "https://example.com/images/moonbeam.png",-- //(STRING)
            price = 87000,	--//(INT)
            speed = 135,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 47 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Picador", --//(STRING)
            model = "picador",
            photo = "https://example.com/images/picador.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 160,	--//(INT)
            stock = 10,
            trunk = 18,--	//(INT)
            id = 48 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sabregt", --//(STRING)
            model = "sabregt",
            photo = "https://example.com/images/sabregt.png",-- //(STRING)
            price = 75000,	--//(INT)
            speed = 135,	--//(INT)
            stock = 10,
            trunk = 10,--	//(INT)
            id = 49 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Slamvan", --//(STRING)
            model = "slamvan",
            photo = "https://example.com/images/slamvan.png",-- //(STRING)
            price = 58500,	--//(INT)
            speed = 130,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 50 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stalion", --//(STRING)
            model = "stalion",
            photo = "https://example.com/images/stalion.png",-- //(STRING)
            price = 62000,	--//(INT)
            speed = 138,	--//(INT)
            stock = 10,
            trunk = 15,--	//(INT)
            id = 51 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tahoma", --//(STRING)
            model = "tahoma",
            photo = "https://example.com/images/tahoma.png",-- //(STRING)
            price = 78000,	--//(INT)
            speed = 131,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 52 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tampa", --//(STRING)
            model = "tampa",
            photo = "https://example.com/images/tampa.png",-- //(STRING)
            price = 110000,	--//(INT)
            speed = 137,	--//(INT)
            stock = 10,
            trunk = 26,--	//(INT)
            id = 53 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vigero", --//(STRING)
            model = "vigero",
            photo = "https://example.com/images/vigero.png",-- //(STRING)
            price = 118000,	--//(INT)
            speed = 170,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 54 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Virgo", --//(STRING)
            model = "virgo",
            photo = "https://example.com/images/virgo.png",-- //(STRING)
            price = 82000,	--//(INT)
            speed = 143,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 55 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Virgo3", --//(STRING)
            model = "virgo3",
            photo = "https://example.com/images/virgo3.png",-- //(STRING)
            price = 85000,	--//(INT)
            speed = 148,	--//(INT)
            stock = 10,
            trunk = 27,--	//(INT)
            id = 56 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Voodoo2", --//(STRING)
            model = "voodoo2",
            photo = "https://example.com/images/voodoo2.png",-- //(STRING)
            price = 49000,	--//(INT)
            speed = 152,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 57 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Btype", --//(STRING)
            model = "btype",
            photo = "https://example.com/images/btype.png",-- //(STRING)
            price = 45000,	--//(INT)
            speed = 177,	--//(INT)
            stock = 10,
            trunk = 20,--	//(INT)
            id = 58 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Btype2", --//(STRING)
            model = "btype2",
            photo = "https://example.com/images/btype2.png",-- //(STRING)
            price = 48000,	--//(INT)
            speed = 123,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 59 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Btype3", --//(STRING)
            model = "btype3",
            photo = "https://example.com/images/btype3.png",-- //(STRING)
            price = 55000,	--//(INT)
            speed = 129,	--//(INT)
            stock = 10,
            trunk = 25,--	//(INT)
            id = 60 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cheburek", --//(STRING)
            model = "cheburek",
            photo = "https://example.com/images/cheburek.png",-- //(STRING)
            price = 97000,	--//(INT)
            speed = 163,	--//(INT)
            stock = 10,
            trunk = 24,--	//(INT)
            id = 61 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Casco", --//(STRING)
            model = "casco",
            photo = "https://example.com/images/casco.png",-- //(STRING)
            price = 110000,	--//(INT)
            speed = 150,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 62 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dynasty", --//(STRING)
            model = "dynasty",
            photo = "https://example.com/images/dynasty.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 121,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 63 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fagaloa", --//(STRING)
            model = "fagaloa",
            photo = "https://example.com/images/fagaloa.png",-- //(STRING)
            price = 60000,	--//(INT)
            speed = 133,	--//(INT)
            stock = 10,
            trunk = 26,--	//(INT)
            id = 64 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Michelli", --//(STRING)
            model = "michelli",
            photo = "https://example.com/images/micheli.png",-- //(STRING)
            price = 96300,	--//(INT)
            speed = 176,	--//(INT)
            stock = 10,
            trunk = 16,--	//(INT)
            id = 65 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nebula", --//(STRING)
            model = "nebula",
            photo = "https://example.com/images/nebula.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 127,	--//(INT)
            stock = 10,
            trunk = 25,--	//(INT)
            id = 66 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Peyote", --//(STRING)
            model = "peyote",
            photo = "https://example.com/images/peyote.png",-- //(STRING)
            price = 55000,	--//(INT)
            speed = 138,	--//(INT)
            stock = 10,
            trunk = 28,--	//(INT)
            id = 67 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Pigalle", --//(STRING)
            model = "pigalle",
            photo = "https://example.com/images/pigalle.png",-- //(STRING)
            price = 45000,	--//(INT)
            speed = 140,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 68 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Retinue", --//(STRING)
            model = "retinue",
            photo = "https://example.com/images/retinue.png",-- //(STRING)
            price = 98000,	--//(INT)
            speed = 173,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 69 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Savestra", --//(STRING)
            model = "savestra",
            photo = "https://example.com/images/savestra.png",-- //(STRING)
            price = 97500,	--//(INT)
            speed = 121,	--//(INT)
            stock = 10,
            trunk = 18,--	//(INT)
            id = 70 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stinger", --//(STRING)
            model = "stinger",
            photo = "https://example.com/images/stinger.png",-- //(STRING)
            price = 112000,	--//(INT)
            speed = 166,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 71 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tornado", --//(STRING)
            model = "tornado",
            photo = "https://example.com/images/tornado.png",-- //(STRING)
            price = 55000,	--//(INT)
            speed = 158,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 72 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tornado2", --//(STRING)
            model = "tornado2",
            photo = "https://example.com/images/tornado2.png",-- //(STRING)
            price = 57000,	--//(INT)
            speed = 139,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 73 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tornado3", --//(STRING)
            model = "tornado3",
            photo = "https://example.com/images/tornado3.png",-- //(STRING)
            price = 43000,	--//(INT)
            speed = 129,	--//(INT)
            stock = 10,
            trunk = 15,--	//(INT)
            id = 74 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tornado4", --//(STRING)
            model = "tornado4",
            photo = "https://example.com/images/tornado4.png",-- //(STRING)
            price = 35000,	--//(INT)
            speed = 147,	--//(INT)
            stock = 10,
            trunk = 24,--	//(INT)
            id = 75 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hexer", --//(STRING)
            model = "hexer",
            photo = "https://example.com/images/hexer.png",-- //(STRING)
            price = 58000,	--//(INT)
            speed = 157,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 76 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Pcj", --//(STRING)
            model = "pcj",
            photo = "https://example.com/images/pcj.png",-- //(STRING)
            price = 95000,	--//(INT)
            speed = 164,	--//(INT)
            stock = 10,
            trunk = 23,--	//(INT)
            id = 77 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ratbike", --//(STRING)
            model = "ratbike",
            photo = "https://example.com/images/ratbike.png",-- //(STRING)
            price = 32000,	--//(INT)
            speed = 156,	--//(INT)
            stock = 10,
            trunk = 11,--	//(INT)
            id = 78 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Enduro", --//(STRING)
            model = "enduro",
            photo = "https://example.com/images/enduro.png",-- //(STRING)
            price = 105000,	--//(INT)
            speed = 163,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 79 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vader", --//(STRING)
            model = "vader",
            photo = "https://example.com/images/vader.png",-- //(STRING)
            price = 109000,	--//(INT)
            speed = 142,	--//(INT)
            stock = 10,
            trunk = 19,--	//(INT)
            id = 80 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bagger", --//(STRING)
            model = "bagger",
            photo = "https://example.com/images/bagger.png",-- //(STRING)
            price = 83000,	--//(INT)
            speed = 148,	--//(INT)
            stock = 10,
            trunk = 20,--	//(INT)
            id = 81 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nemesis", --//(STRING)
            model = "nemesis",
            photo = "https://example.com/images/nemesis.png",-- //(STRING)
            price = 105000,	--//(INT)
            speed = 132,	--//(INT)
            stock = 10,
            trunk = 29,--	//(INT)
            id = 82 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faggio2", --//(STRING)
            model = "faggio2",
            photo = "https://example.com/images/faggio2.png",-- //(STRING)
            price = 12000,	--//(INT)
            speed = 160,	--//(INT)
            stock = 10,
            trunk = 26,--	//(INT)
            id = 83 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sovereign", --//(STRING)
            model = "sovereign2",
            photo = "https://example.com/images/sovereign.png",-- //(STRING)
            price = 85000,	--//(INT)
            speed = 176,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 84 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bfinjection", --//(STRING)
            model = "bfinjection",
            photo = "https://example.com/images/bfinjection.png",-- //(STRING)
            price = 32000,	--//(INT)
            speed = 135,	--//(INT)
            stock = 10,
            trunk = 17,--	//(INT)
            id = 85 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Winky", --//(STRING)
            model = "winky",
            photo = "https://example.com/images/winky.png",-- //(STRING)
            price = 39000            ,	--//(INT)
            speed = 138,	--//(INT)
            stock = 10,
            trunk = 10,--	//(INT)
            id = 86 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Journey", --//(STRING)
            model = "journey",
            photo = "https://example.com/images/journey.png",-- //(STRING)
            price = 15000,	--//(INT)
            speed = 141,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 87 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Minivan", --//(STRING)
            model = "minivan",
            photo = "https://example.com/images/minivan.png",-- //(STRING)
            price = 53000,	--//(INT)
            speed = 169,	--//(INT)
            stock = 10,
            trunk = 12,--	//(INT)
            id = 88 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Paradise", --//(STRING)
            model = "paradise",
            photo = "https://example.com/images/paradise.png",-- //(STRING)
            price = 78000,	--//(INT)
            speed = 139,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 89 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Speedo", --//(STRING)
            model = "speedo",
            photo = "https://example.com/images/speedo.png",-- //(STRING)
            price = 80000,	--//(INT)
            speed = 137,	--//(INT)
            stock = 10,
            trunk = 13,--	//(INT)
            id = 90 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Surfer2", --//(STRING)
            model = "surfer2",
            photo = "https://example.com/images/surfer2.png",-- //(STRING)
            price = 18000,	--//(INT)
            speed = 124,	--//(INT)
            stock = 10,
            trunk = 14,--	//(INT)
            id = 91 --//
        },
        {
            type = "C", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Youga2", --//(STRING)
            model = "youga2",
            photo = "https://example.com/images/youga2.png",-- //(STRING)
            price = 78000,	--//(INT)
            speed = 120,	--//(INT)
            stock = 10,
            trunk = 30,--	//(INT)
            id = 92 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Warrener2", --//(STRING)
            model = "warrener2",
            photo = "https://example.com/images/warrener2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 164,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 27 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dune", --//(STRING)
            model = "dune",
            photo = "https://example.com/images/dune.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 170,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 3 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Youga", --//(STRING)
            model = "youga",
            photo = "https://example.com/images/youga.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 97 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Youga3", --//(STRING)
            model = "youga3",
            photo = "https://example.com/images/youga3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 182,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 98 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Youga4", --//(STRING)
            model = "youga4",
            photo = "https://example.com/images/youga4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 215,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 99 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Surfer", --//(STRING)
            model = "surfer",
            photo = "https://example.com/images/surfer.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 169,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 100 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Surfer3", --//(STRING)
            model = "surfer3",
            photo = "https://example.com/images/surfer3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 157,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 101 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Minivan2", --//(STRING)
            model = "minivan2",
            photo = "https://example.com/images/minivan2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 174,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 102 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Journey2", --//(STRING)
            model = "journey2",
            photo = "https://example.com/images/journey2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 103 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Camper", --//(STRING)
            model = "camper",
            photo = "https://example.com/images/camper.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 201,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 104 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Yosemite1500", --//(STRING)
            model = "yosemite1500",
            photo = "https://example.com/images/yosemite1500.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 214,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 105 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Riata", --//(STRING)
            model = "riata",
            photo = "https://example.com/images/riata.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 192,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 106 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rebel2", --//(STRING)
            model = "rebel2",
            photo = "https://example.com/images/rebel2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 107 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rancherxl", --//(STRING)
            model = "rancherxl",
            photo = "https://example.com/images/rancherxl.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 169,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 108 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Mesa3", --//(STRING)
            model = "mesa3",
            photo = "https://example.com/images/mesa3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 159,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 109 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blazer3", --//(STRING)
            model = "blazer3",
            photo = "https://example.com/images/blazer3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 157,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 110 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bifta", --//(STRING)
            model = "bifta",
            photo = "https://example.com/images/bifta.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 191,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 111 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ruffian", --//(STRING)
            model = "ruffian",
            photo = "https://example.com/images/ruffian.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 162,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 112 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faggio", --//(STRING)
            model = "faggio",
            photo = "https://example.com/images/faggio.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 190,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 113 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faggio3", --//(STRING)
            model = "faggio3",
            photo = "https://example.com/images/faggio3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 195,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 114 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Esskey", --//(STRING)
            model = "esskey",
            photo = "https://example.com/images/esskey.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 209,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 115 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Akuma", --//(STRING)
            model = "akuma",
            photo = "https://example.com/images/akuma.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 171,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 116 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Carbonrs", --//(STRING)
            model = "carbonrs",
            photo = "https://example.com/images/carbonrs.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 164,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 117 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Daemon", --//(STRING)
            model = "daemon",
            photo = "https://example.com/images/daemon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 150,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 118 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Double", --//(STRING)
            model = "double",
            photo = "https://example.com/images/double.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 159,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 119 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sanchez2", --//(STRING)
            model = "sanchez2",
            photo = "https://example.com/images/sanchez2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 183,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 120 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sanchez", --//(STRING)
            model = "sanchez",
            photo = "https://example.com/images/sanchez.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 121 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blista", --//(STRING)
            model = "blista",
            photo = "https://example.com/images/blista.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 197,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 122 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Asbo", --//(STRING)
            model = "asbo",
            photo = "https://example.com/images/asbo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 176,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 123 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Brioso", --//(STRING)
            model = "brioso",
            photo = "https://example.com/images/brioso.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 190,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 124 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Issi2", --//(STRING)
            model = "issi2",
            photo = "https://example.com/images/issi2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 202,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 125 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Kanjo", --//(STRING)
            model = "kanjo",
            photo = "https://example.com/images/kanjo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 126 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Prairie", --//(STRING)
            model = "prairie",
            photo = "https://example.com/images/prairie.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 196,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 127 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Asterope2", --//(STRING)
            model = "asterope2",
            photo = "https://example.com/images/asterope2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 175,	--//(INT)
            stock = 0,
            trunk = 22,--	//(INT)
            id = 128 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fugitive", --//(STRING)
            model = "fugitive",
            photo = "https://example.com/images/fugitive.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 160,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 129 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Glendale2", --//(STRING)
            model = "glendale2",
            photo = "https://example.com/images/glendale2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 177,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 130 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Impaler5", --//(STRING)
            model = "impaler5",
            photo = "https://example.com/images/impaler5.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 159,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 131 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ingot", --//(STRING)
            model = "ingot",
            photo = "https://example.com/images/ingot.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 178,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 132 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Intruder", --//(STRING)
            model = "intruder",
            photo = "https://example.com/images/intruder.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 133 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Primo2", --//(STRING)
            model = "primo2",
            photo = "https://example.com/images/primo2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 172,	--//(INT)
            stock = 0,
            trunk = 22,--	//(INT)
            id = 134 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Superd", --//(STRING)
            model = "superd",
            photo = "https://example.com/images/superd.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 135 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Surge", --//(STRING)
            model = "surge",
            photo = "https://example.com/images/surge.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 178,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 136 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stratum", --//(STRING)
            model = "stratum",
            photo = "https://example.com/images/stratum.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 166,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 137 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tailgater", --//(STRING)
            model = "tailgater",
            photo = "https://example.com/images/tailgater.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 167,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 138 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Washington", --//(STRING)
            model = "washington",
            photo = "https://example.com/images/washington.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 166,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 139 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller2", --//(STRING)
            model = "baller2",
            photo = "https://example.com/images/baller2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 170,	--//(INT)
            stock = 0,
            trunk = 24,--	//(INT)
            id = 140 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller3", --//(STRING)
            model = "baller3",
            photo = "https://example.com/images/baller3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 195,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 141 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller4", --//(STRING)
            model = "baller4",
            photo = "https://example.com/images/baller4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 152,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 142 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cavalcade2", --//(STRING)
            model = "cavalcade2",
            photo = "https://example.com/images/cavalcade2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 194,	--//(INT)
            stock = 0,
            trunk = 22,--	//(INT)
            id = 143 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Contender", --//(STRING)
            model = "contender",
            photo = "https://example.com/images/contender.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 210,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 144 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dubsta", --//(STRING)
            model = "dubsta",
            photo = "https://example.com/images/dubsta.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 145 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Granger", --//(STRING)
            model = "granger",
            photo = "https://example.com/images/granger.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 151,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 146 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gresley", --//(STRING)
            model = "gresley",
            photo = "https://example.com/images/gresley.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 213,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 147 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Huntley", --//(STRING)
            model = "huntley",
            photo = "https://example.com/images/huntley.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 166,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 148 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Patriot", --//(STRING)
            model = "patriot",
            photo = "https://example.com/images/patriot.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 191,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 149 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Radi", --//(STRING)
            model = "radi",
            photo = "https://example.com/images/radi.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 160,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 150 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rocoto", --//(STRING)
            model = "rocoto",
            photo = "https://example.com/images/rocoto.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 156,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 151 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Seminole", --//(STRING)
            model = "seminole",
            photo = "https://example.com/images/seminole.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 162,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 152 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vivanite", --//(STRING)
            model = "vivanite",
            photo = "https://example.com/images/vivanite.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 209,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 153 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Felon", --//(STRING)
            model = "felon",
            photo = "https://example.com/images/felon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 186,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 154 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Felon2", --//(STRING)
            model = "felon2",
            photo = "https://example.com/images/felon2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 197,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 155 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jackal", --//(STRING)
            model = "jackal",
            photo = "https://example.com/images/jackal.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 156 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Oracle", --//(STRING)
            model = "oracle",
            photo = "https://example.com/images/oracle.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 219,	--//(INT)
            stock = 0,
            trunk = 24,--	//(INT)
            id = 157 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Oracle2", --//(STRING)
            model = "oracle2",
            photo = "https://example.com/images/oracle2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 158,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 158 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sentinel", --//(STRING)
            model = "sentinel",
            photo = "https://example.com/images/sentinel.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 165,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 159 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sentinel2", --//(STRING)
            model = "sentinel2",
            photo = "https://example.com/images/sentinel2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 164,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 160 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zion", --//(STRING)
            model = "zion",
            photo = "https://example.com/images/zion.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 160,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 161 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zion2", --//(STRING)
            model = "zion2",
            photo = "https://example.com/images/zion2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 189,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 162 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zion3", --//(STRING)
            model = "zion3",
            photo = "https://example.com/images/zion3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 189,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 162 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Buccaneer2", --//(STRING)
            model = "buccaneer2",
            photo = "https://example.com/images/buccaneer2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 164,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 163 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Chino2", --//(STRING)
            model = "chino2",
            photo = "https://example.com/images/chino2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 161,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 164 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Clique", --//(STRING)
            model = "clique",
            photo = "https://example.com/images/clique.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 195,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 165 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Coquette3", --//(STRING)
            model = "coquette3",
            photo = "https://example.com/images/coquette3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 189,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 166 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Deviant", --//(STRING)
            model = "deviant",
            photo = "https://example.com/images/deviant.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 209,	--//(INT)
            stock = 0,
            trunk = 24,--	//(INT)
            id = 167 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dominator", --//(STRING)
            model = "dominator",
            photo = "https://example.com/images/dominator.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 164,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 168 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dominator8", --//(STRING)
            model = "dominator8",
            photo = "https://example.com/images/dominator8.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 220,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 169 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dukes", --//(STRING)
            model = "dukes",
            photo = "https://example.com/images/dukes.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 163,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 170 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ellie", --//(STRING)
            model = "ellie",
            photo = "https://example.com/images/ellie.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 167,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 171 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faction2", --//(STRING)
            model = "faction2",
            photo = "https://example.com/images/faction2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 185,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 172 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gauntlet", --//(STRING)
            model = "gauntlet",
            photo = "https://example.com/images/gauntlet.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 173 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gauntlet5", --//(STRING)
            model = "gauntlet5",
            photo = "https://example.com/images/gauntlet5.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 179,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 174 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Greenwood", --//(STRING)
            model = "greenwood",
            photo = "https://example.com/images/greenwood.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 196,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 175 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hermes", --//(STRING)
            model = "hermes",
            photo = "https://example.com/images/hermes.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 176 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hotknife", --//(STRING)
            model = "hotknife",
            photo = "https://example.com/images/hotknife.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 173,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 177 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hustler", --//(STRING)
            model = "hustler",
            photo = "https://example.com/images/hustler.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 165,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 178 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Impaler", --//(STRING)
            model = "impaler",
            photo = "https://example.com/images/impaler.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 189,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 179 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Impaler6", --//(STRING)
            model = "impaler6",
            photo = "https://example.com/images/impaler6.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 180 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Moonbeam2", --//(STRING)
            model = "moonbeam2",
            photo = "https://example.com/images/moonbeam2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 181 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nightshade", --//(STRING)
            model = "nightshade",
            photo = "https://example.com/images/nightshade.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 182 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Phoenix", --//(STRING)
            model = "phoenix",
            photo = "https://example.com/images/phoenix.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 173,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 183 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ruiner", --//(STRING)
            model = "ruiner",
            photo = "https://example.com/images/ruiner.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 187,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 184 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sabregt2", --//(STRING)
            model = "sabregt2",
            photo = "https://example.com/images/sabregt2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 201,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 185 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Slamvan3", --//(STRING)
            model = "slamvan3",
            photo = "https://example.com/images/slamvan3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 175,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 186 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tulip", --//(STRING)
            model = "tulip",
            photo = "https://example.com/images/tulip.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 154,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 187 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vamos", --//(STRING)
            model = "vamos",
            photo = "https://example.com/images/vamos.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 209,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 188 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Virgo2", --//(STRING)
            model = "virgo2",
            photo = "https://example.com/images/virgo2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 189 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Voodoo", --//(STRING)
            model = "voodoo",
            photo = "https://example.com/images/voodoo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 174,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 190 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ardent", --//(STRING)
            model = "ardent",
            photo = "https://example.com/images/ardent.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 167,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 191 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cheetah2", --//(STRING)
            model = "cheetah2",
            photo = "https://example.com/images/cheetah2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 192 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Coquette2", --//(STRING)
            model = "coquette2",
            photo = "https://example.com/images/coquette2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 152,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 193 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Coquette5", --//(STRING)
            model = "coquette5",
            photo = "https://example.com/images/coquette5.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 202,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 194 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Feltzer3", --//(STRING)
            model = "feltzer3",
            photo = "https://example.com/images/feltzer3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 195 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gt500", --//(STRING)
            model = "gt500",
            photo = "https://example.com/images/gt500.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 196 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Manana2", --//(STRING)
            model = "manana2",
            photo = "https://example.com/images/manana2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 197 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Monroe", --//(STRING)
            model = "monroe",
            photo = "https://example.com/images/monroe.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 214,	--//(INT)
            stock = 0,
            trunk = 24,--	//(INT)
            id = 198 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Peyote3", --//(STRING)
            model = "peyote3",
            photo = "https://example.com/images/peyote3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 167,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 199 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rapidgt3", --//(STRING)
            model = "rapidgt3",
            photo = "https://example.com/images/rapidgt3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 152,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 200 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Retinue2", --//(STRING)
            model = "retinue2",
            photo = "https://example.com/images/retinue2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 201 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stingergt", --//(STRING)
            model = "stingergt",
            photo = "https://example.com/images/stingergt.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 176,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 202 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Swinger", --//(STRING)
            model = "swinger",
            photo = "https://example.com/images/swinger.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 153,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 203 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tornado5", --//(STRING)
            model = "tornado5",
            photo = "https://example.com/images/tornado5.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 204 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Turismo2", --//(STRING)
            model = "turismo2",
            photo = "https://example.com/images/turismo2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 205 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Z190", --//(STRING)
            model = "z190",
            photo = "https://example.com/images/z190.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 182,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 206 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Viseris", --//(STRING)
            model = "viseris",
            photo = "https://example.com/images/viseris.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 163,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 207 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zio3", --//(STRING)
            model = "zio3",
            photo = "https://example.com/images/zio3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 198,	--//(INT)
            stock = 0,
            trunk = 21,--	//(INT)
            id = 208 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ztype", --//(STRING)
            model = "ztype",
            photo = "https://example.com/images/ztype.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 211,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 209 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Alpha", --//(STRING)
            model = "alpha",
            photo = "https://example.com/images/alpha.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 174,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 210 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Banshee", --//(STRING)
            model = "banshee",
            photo = "https://example.com/images/banshee.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 173,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 211 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Buffalo", --//(STRING)
            model = "buffalo",
            photo = "https://example.com/images/buffalo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 206,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 212 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet2", --//(STRING)
            model = "comet2",
            photo = "https://example.com/images/comet2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 162,	--//(INT)
            stock = 0,
            trunk = 22,--	//(INT)
            id = 213 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet4", --//(STRING)
            model = "comet4",
            photo = "https://example.com/images/comet4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 170,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 214 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Drafter", --//(STRING)
            model = "drafter",
            photo = "https://example.com/images/drafter.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 193,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 215 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fusilade", --//(STRING)
            model = "fusilade",
            photo = "https://example.com/images/fusilade.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 219,	--//(INT)
            stock = 0,
            trunk = 25,--	//(INT)
            id = 216 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Futo", --//(STRING)
            model = "futo",
            photo = "https://example.com/images/futo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 208,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 217 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Penumbra", --//(STRING)
            model = "penumbra",
            photo = "https://example.com/images/penumbra.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 205,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 218 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Pariah", --//(STRING)
            model = "pariah",
            photo = "https://example.com/images/pariah.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 152,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 219 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rapidgt", --//(STRING)
            model = "rapidgt",
            photo = "https://example.com/images/rapidgt.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 211,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 220 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ruston", --//(STRING)
            model = "ruston",
            photo = "https://example.com/images/ruston.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 157,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 221 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schafter2", --//(STRING)
            model = "schafter2",
            photo = "https://example.com/images/schafter2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 198,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 222 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sentinel3", --//(STRING)
            model = "sentinel3",
            photo = "https://example.com/images/sentinel3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 189,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 223 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Specter", --//(STRING)
            model = "specter",
            photo = "https://example.com/images/specter.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 171,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 224 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sultan", --//(STRING)
            model = "sultan",
            photo = "https://example.com/images/sultan.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 180,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 225 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dubsta3", --//(STRING)
            model = "dubsta3",
            photo = "https://example.com/images/dubsta3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 173,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 226 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "L35", --//(STRING)
            model = "l35",
            photo = "https://example.com/images/l35.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 154,	--//(INT)
            stock = 0,
            trunk = 23,--	//(INT)
            id = 227 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bison", --//(STRING)
            model = "bison",
            photo = "https://example.com/images/bison.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 188,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 228 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bobcatxl", --//(STRING)
            model = "bobcatxl",
            photo = "https://example.com/images/bobcatxl.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 183,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 229 --//
        },
        {
            type = "B", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Burrito3", --//(STRING)
            model = "burrito3",
            photo = "https://example.com/images/burrito3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 230 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Speedo4", --//(STRING)
            model = "speedo4",
            photo = "https://example.com/images/speedo4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 194,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 234 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rumpo3", --//(STRING)
            model = "rumpo3",
            photo = "https://example.com/images/rumpo3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 221,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 235 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gburrito2", --//(STRING)
            model = "gburrito2",
            photo = "https://example.com/images/gburrito2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 216,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 236 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Yosemite3", --//(STRING)
            model = "yosemite3",
            photo = "https://example.com/images/yosemite3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 242,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 237 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Verus", --//(STRING)
            model = "verus",
            photo = "https://example.com/images/verus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 196,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 238 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Terminus", --//(STRING)
            model = "terminus",
            photo = "https://example.com/images/terminus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 236,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 239 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sandking", --//(STRING)
            model = "sandking",
            photo = "https://example.com/images/sandking.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 192,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 240 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sandking2", --//(STRING)
            model = "sandking2",
            photo = "https://example.com/images/sandking2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 245,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 241 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Patriot3", --//(STRING)
            model = "patriot3",
            photo = "https://example.com/images/patriot3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 242 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Outlaw", --//(STRING)
            model = "outlaw",
            photo = "https://example.com/images/outlaw.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 247,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 243 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Kamacho", --//(STRING)
            model = "kamacho",
            photo = "https://example.com/images/kamacho.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 186,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 244 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hellion", --//(STRING)
            model = "hellion",
            photo = "https://example.com/images/hellion.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 188,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 245 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Everon", --//(STRING)
            model = "everon",
            photo = "https://example.com/images/everon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 248,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 246 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Caracara2", --//(STRING)
            model = "caracara2",
            photo = "https://example.com/images/caracara2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 221,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 247 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Blazer4", --//(STRING)
            model = "blazer4",
            photo = "https://example.com/images/blazer4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 235,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 248 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vindicator", --//(STRING)
            model = "vindicator",
            photo = "https://example.com/images/vindicator.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 244,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 249 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Thrust", --//(STRING)
            model = "thrust",
            photo = "https://example.com/images/thrust.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 243,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 250 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Wolfsbane", --//(STRING)
            model = "wolfsbane",
            photo = "https://example.com/images/wolfsbane.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 218,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 251 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zombiea", --//(STRING)
            model = "zombiea",
            photo = "https://example.com/images/zombiea.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 196,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 252 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zombieb", --//(STRING)
            model = "zombieb",
            photo = "https://example.com/images/zombieb.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 187,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 253 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Avarus", --//(STRING)
            model = "avarus",
            photo = "https://example.com/images/avarus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 238,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 254 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Chimera", --//(STRING)
            model = "chimera",
            photo = "https://example.com/images/chimera.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 249,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 255 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bf400", --//(STRING)
            model = "bf400",
            photo = "https://example.com/images/bf400.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 202,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 256 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Diablous", --//(STRING)
            model = "diablous",
            photo = "https://example.com/images/diablous.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 257 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Faggio3", --//(STRING)
            model = "faggio3",
            photo = "https://example.com/images/faggio3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 254,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 258 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fcr", --//(STRING)
            model = "fcr",
            photo = "https://example.com/images/fcr.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 240,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 259 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Lectro", --//(STRING)
            model = "lectro",
            photo = "https://example.com/images/lectro.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 187,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 260 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Manchez", --//(STRING)
            model = "manchez",
            photo = "https://example.com/images/manchez.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 261 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cinquemila", --//(STRING)
            model = "cinquemila",
            photo = "https://example.com/images/cinquemila.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 247,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 262 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cog55", --//(STRING)
            model = "cog55",
            photo = "https://example.com/images/cog55.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 253,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 263 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cognoscenti", --//(STRING)
            model = "cognoscenti",
            photo = "https://example.com/images/cognoscenti.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 253,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 264 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cogcabrio", --//(STRING)
            model = "cogcabrio",
            photo = "https://example.com/images/cogcabrio.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 239,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 265 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Deity", --//(STRING)
            model = "deity",
            photo = "https://example.com/images/deity.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 239,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 266 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rhinehart", --//(STRING)
            model = "rhinehart",
            photo = "https://example.com/images/rhinehart.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 182,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 267 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schafter2", --//(STRING)
            model = "schafter2",
            photo = "https://example.com/images/schafter2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 247,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 268 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tailgater2", --//(STRING)
            model = "tailgater2",
            photo = "https://example.com/images/tailgater2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 241,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 269 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vorschlaghammer", --//(STRING)
            model = "vorschlaghammer",
            photo = "https://example.com/images/vorschlaghammer.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 229,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 270 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Aleutian", --//(STRING)
            model = "aleutian",
            photo = "https://example.com/images/aleutian.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 271 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller7", --//(STRING)
            model = "baller7",
            photo = "https://example.com/images/baller7.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 229,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 272 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dorado", --//(STRING)
            model = "dorado",
            photo = "https://example.com/images/dorado.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 237,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 273 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dubsta2", --//(STRING)
            model = "dubsta2",
            photo = "https://example.com/images/dubsta2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 235,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 274 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Granger2", --//(STRING)
            model = "granger2",
            photo = "https://example.com/images/granger2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 202,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 275 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Issi8", --//(STRING)
            model = "issi8",
            photo = "https://example.com/images/issi8.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 225,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 276 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Landstalker2", --//(STRING)
            model = "landstalker2",
            photo = "https://example.com/images/landstalker2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 191,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 277 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Novak", --//(STRING)
            model = "novak",
            photo = "https://example.com/images/novak.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 182,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 278 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rebla", --//(STRING)
            model = "rebla",
            photo = "https://example.com/images/rebla.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 256,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 279 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Seminole2", --//(STRING)
            model = "seminole2",
            photo = "https://example.com/images/seminole2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 242,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 280 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Xls", --//(STRING)
            model = "xls",
            photo = "https://example.com/images/xls.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 208,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 281 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Eurosx32", --//(STRING)
            model = "eurosx32",
            photo = "https://example.com/images/eurosx32.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 282 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Exemplar", --//(STRING)
            model = "exemplar",
            photo = "https://example.com/images/exemplar.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 283 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "F620", --//(STRING)
            model = "f620",
            photo = "https://example.com/images/f620.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 256,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 284 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fr36", --//(STRING)
            model = "fr36",
            photo = "https://example.com/images/fr36.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 211,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 285 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Kanjosj", --//(STRING)
            model = "kanjosj",
            photo = "https://example.com/images/kanjosj.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 246,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 286 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Previon", --//(STRING)
            model = "previon",
            photo = "https://example.com/images/previon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 246,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 287 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Windsor", --//(STRING)
            model = "windsor",
            photo = "https://example.com/images/windsor.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 248,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 288 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Windsor2", --//(STRING)
            model = "windsor2",
            photo = "https://example.com/images/windsor2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 198,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 289 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Buffalo4", --//(STRING)
            model = "buffalo4",
            photo = "https://example.com/images/buffalo4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 290 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dominator10", --//(STRING)
            model = "dominator10",
            photo = "https://example.com/images/dominator10.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 227,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 291 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dominator7", --//(STRING)
            model = "dominator7",
            photo = "https://example.com/images/dominator7.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 203,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 292 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gauntlet4", --//(STRING)
            model = "gauntlet4",
            photo = "https://example.com/images/gauntlet4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 221,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 293 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Peyote2", --//(STRING)
            model = "peyote2",
            photo = "https://example.com/images/peyote2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 294 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ruiner4", --//(STRING)
            model = "ruiner4",
            photo = "https://example.com/images/ruiner4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 239,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 295 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tulip2", --//(STRING)
            model = "tulip2",
            photo = "https://example.com/images/tulip2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 199,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 296 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Infernus2", --//(STRING)
            model = "infernus2",
            photo = "https://example.com/images/infernus2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 297 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jester3", --//(STRING)
            model = "jester3",
            photo = "https://example.com/images/jester3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 298 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Mamba", --//(STRING)
            model = "mamba",
            photo = "https://example.com/images/mamba.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 250,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 299 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bestiagts", --//(STRING)
            model = "bestiagts",
            photo = "https://example.com/images/bestiagts.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 191,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 300 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Buffalo2", --//(STRING)
            model = "buffalo2",
            photo = "https://example.com/images/buffalo2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 254,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 301 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Calico", --//(STRING)
            model = "calico",
            photo = "https://example.com/images/calico.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 186,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 302 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet3", --//(STRING)
            model = "comet3",
            photo = "https://example.com/images/comet3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 185,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 303 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet5", --//(STRING)
            model = "comet5",
            photo = "https://example.com/images/comet5.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 222,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 304 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Coquette", --//(STRING)
            model = "coquette",
            photo = "https://example.com/images/coquette.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 224,	--//(INT)
            stock = 0,
            trunk = 18,--	//(INT)
            id = 305 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cypher", --//(STRING)
            model = "cypher",
            photo = "https://example.com/images/cypher.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 214,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 306 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Elegy", --//(STRING)
            model = "elegy",
            photo = "https://example.com/images/elegy.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 235,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 307 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Euros", --//(STRING)
            model = "euros",
            photo = "https://example.com/images/euros.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 253,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 308 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Feltzer2", --//(STRING)
            model = "feltzer2",
            photo = "https://example.com/images/feltzer2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 257,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 309 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Furoregt", --//(STRING)
            model = "furoregt",
            photo = "https://example.com/images/furoregt.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 202,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 310 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Futo2", --//(STRING)
            model = "futo2",
            photo = "https://example.com/images/futo2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 258,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 311 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gb200", --//(STRING)
            model = "gb200",
            photo = "https://example.com/images/gb200.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 256,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 312 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jester4", --//(STRING)
            model = "jester4",
            photo = "https://example.com/images/jester4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 196,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 313 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jugular", --//(STRING)
            model = "jugular",
            photo = "https://example.com/images/jugular.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 314 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Khamelion", --//(STRING)
            model = "khamelion",
            photo = "https://example.com/images/khamelion.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 234,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 315 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Komoda", --//(STRING)
            model = "komoda",
            photo = "https://example.com/images/komoda.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 208,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 316 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Kuruma", --//(STRING)
            model = "kuruma",
            photo = "https://example.com/images/kuruma.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 193,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 317 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Lynx", --//(STRING)
            model = "lynx",
            photo = "https://example.com/images/lynx.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 216,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 318 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Massacro", --//(STRING)
            model = "massacro",
            photo = "https://example.com/images/massacro.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 251,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 319 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ninef", --//(STRING)
            model = "ninef",
            photo = "https://example.com/images/ninef.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 215,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 320 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ninef2", --//(STRING)
            model = "ninef2",
            photo = "https://example.com/images/ninef2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 321 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Penumbra2", --//(STRING)
            model = "penumbra2",
            photo = "https://example.com/images/penumbra2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 183,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 322 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "R300", --//(STRING)
            model = "r300",
            photo = "https://example.com/images/r300.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 190,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 323 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Raiden", --//(STRING)
            model = "raiden",
            photo = "https://example.com/images/raiden.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 192,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 324 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Remus", --//(STRING)
            model = "remus",
            photo = "https://example.com/images/remus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 211,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 325 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Revolter", --//(STRING)
            model = "revolter",
            photo = "https://example.com/images/revolter.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 19,--	//(INT)
            id = 326 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rt3000", --//(STRING)
            model = "rt3000",
            photo = "https://example.com/images/rt3000.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 232,	--//(INT)
            stock = 0,
            trunk = 20,--	//(INT)
            id = 327 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schafter3", --//(STRING)
            model = "schafter3",
            photo = "https://example.com/images/schafter3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 258,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 328 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schafter4", --//(STRING)
            model = "schafter4",
            photo = "https://example.com/images/schafter4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 220,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 329 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schlagen", --//(STRING)
            model = "schlagen",
            photo = "https://example.com/images/schlagen.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 193,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 330 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Schwarzer", --//(STRING)
            model = "schwarzer",
            photo = "https://example.com/images/schwarzer.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 204,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 331 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sentinel4", --//(STRING)
            model = "sentinel4",
            photo = "https://example.com/images/sentinel4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 258,	--//(INT)
            stock = 0,
            trunk = 17,--	//(INT)
            id = 332 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Seven70", --//(STRING)
            model = "seven70",
            photo = "https://example.com/images/seven70.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 235,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 333 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Specter2", --//(STRING)
            model = "specter2",
            photo = "https://example.com/images/specter2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 215,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 334 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sugoi", --//(STRING)
            model = "sugoi",
            photo = "https://example.com/images/sugoi.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 210,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 335 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sultan2", --//(STRING)
            model = "sultan2",
            photo = "https://example.com/images/sultan2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 203,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 336 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sultan3", --//(STRING)
            model = "sultan3",
            photo = "https://example.com/images/sultan3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 258,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 337 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Surano", --//(STRING)
            model = "surano",
            photo = "https://example.com/images/surano.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 338 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tenf", --//(STRING)
            model = "tenf",
            photo = "https://example.com/images/tenf.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 197,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 339 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Verlierer2", --//(STRING)
            model = "verlierer2",
            photo = "https://example.com/images/verlierer2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 203,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 340 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vectre", --//(STRING)
            model = "vectre",
            photo = "https://example.com/images/vectre.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 210,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 341 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zr350", --//(STRING)
            model = "zr350",
            photo = "https://example.com/images/zr350.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 212,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 342 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sultanrs", --//(STRING)
            model = "sultanrs",
            photo = "https://example.com/images/sultanrs.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 200,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 343 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Banshee2", --//(STRING)
            model = "banshee2",
            photo = "https://example.com/images/banshee2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 217,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 344 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bullet", --//(STRING)
            model = "bullet",
            photo = "https://example.com/images/bullet.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 198,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 345 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Italigtb", --//(STRING)
            model = "italigtb",
            photo = "https://example.com/images/italigtb.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 232,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 346 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Penetrator", --//(STRING)
            model = "penetrator",
            photo = "https://example.com/images/penetrator.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 251,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 347 --//
        },
        {
            type = "A", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Pfister811", --//(STRING)
            model = "pfister811",
            photo = "https://example.com/images/pfister811.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 236,	--//(INT)
            stock = 0,
            trunk = 16,--	//(INT)
            id = 348 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vagrant", --//(STRING)
            model = "vagrant",
            photo = "https://example.com/images/vagrant.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 233,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 351 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cliffhanger", --//(STRING)
            model = "cliffhanger",
            photo = "https://example.com/images/cliffhanger.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 259,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 352 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stryder", --//(STRING)
            model = "stryder",
            photo = "https://example.com/images/stryder.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 278,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 353 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Rrocket", --//(STRING)
            model = "rrocket",
            photo = "https://example.com/images/rrocket.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 234,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 354 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bati", --//(STRING)
            model = "bati",
            photo = "https://example.com/images/bati.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 259,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 355 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Bati2", --//(STRING)
            model = "bati2",
            photo = "https://example.com/images/bati2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 268,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 356 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Defiler", --//(STRING)
            model = "defiler",
            photo = "https://example.com/images/defiler.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 285,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 357 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fcr2", --//(STRING)
            model = "fcr2",
            photo = "https://example.com/images/fcr2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 274,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 358 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Diablous2", --//(STRING)
            model = "diablous2",
            photo = "https://example.com/images/diablous2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 257,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 359 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hakuchou", --//(STRING)
            model = "hakuchou",
            photo = "https://example.com/images/hakuchou.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 227,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 360 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Hakuchou2", --//(STRING)
            model = "hakuchou2",
            photo = "https://example.com/images/hakuchou2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 240,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 361 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Innovation", --//(STRING)
            model = "innovation",
            photo = "https://example.com/images/innovation.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 220,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 362 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Manchez2", --//(STRING)
            model = "manchez2",
            photo = "https://example.com/images/manchez2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 363 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Manchez3", --//(STRING)
            model = "manchez3",
            photo = "https://example.com/images/manchez3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 290,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 364 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nightblade", --//(STRING)
            model = "nightblade",
            photo = "https://example.com/images/nightblade.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 278,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 365 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Reever", --//(STRING)
            model = "reever",
            photo = "https://example.com/images/reever.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 250,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 366 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Powersurge", --//(STRING)
            model = "powersurge",
            photo = "https://example.com/images/powersurge.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 299,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 367 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sanctus", --//(STRING)
            model = "sanctus",
            photo = "https://example.com/images/sanctus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 273,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 368 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Shinobi", --//(STRING)
            model = "shinobi",
            photo = "https://example.com/images/shinobi.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 266,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 369 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vortex", --//(STRING)
            model = "vortex",
            photo = "https://example.com/images/vortex.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 290,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 370 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Astron", --//(STRING)
            model = "astron",
            photo = "https://example.com/images/astron.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 245,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 371 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Baller8", --//(STRING)
            model = "baller8",
            photo = "https://example.com/images/baller8.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 266,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 372 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Castigator", --//(STRING)
            model = "castigator",
            photo = "https://example.com/images/castigator.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 246,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 373 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cavalcade3", --//(STRING)
            model = "cavalcade3",
            photo = "https://example.com/images/cavalcade3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 270,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 374 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Iwagen", --//(STRING)
            model = "iwagen",
            photo = "https://example.com/images/iwagen.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 262,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 375 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jubilee", --//(STRING)
            model = "jubilee",
            photo = "https://example.com/images/jubilee.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 270,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 376 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Toros", --//(STRING)
            model = "toros",
            photo = "https://example.com/images/toros.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 281,	--//(INT)
            stock = 0,
            trunk = 5,--	//(INT)
            id = 377 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Dominator9", --//(STRING)
            model = "dominator9",
            photo = "https://example.com/images/dominator9.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 243,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 378 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vigero2", --//(STRING)
            model = "vigero2",
            photo = "https://example.com/images/vigero2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 285,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 379 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vigero3", --//(STRING)
            model = "vigero3",
            photo = "https://example.com/images/vigero3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 232,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 380 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Carbonizzare", --//(STRING)
            model = "carbonizzare",
            photo = "https://example.com/images/carbonizzare.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 249,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 381 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet6", --//(STRING)
            model = "comet6",
            photo = "https://example.com/images/comet6.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 382 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Comet7", --//(STRING)
            model = "comet7",
            photo = "https://example.com/images/comet7.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 231,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 383 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Coquette4", --//(STRING)
            model = "coquette4",
            photo = "https://example.com/images/coquette4.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 269,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 384 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Corsita", --//(STRING)
            model = "corsita",
            photo = "https://example.com/images/corsita.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 289,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 385 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Elegy2", --//(STRING)
            model = "elegy2",
            photo = "https://example.com/images/elegy2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 279,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 386 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Growler", --//(STRING)
            model = "growler",
            photo = "https://example.com/images/growler.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 291,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 387 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Italigto", --//(STRING)
            model = "italigto",
            photo = "https://example.com/images/italigto.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 235,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 388 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Italirsx", --//(STRING)
            model = "italirsx",
            photo = "https://example.com/images/italirsx.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 282,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 389 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Jester", --//(STRING)
            model = "jester",
            photo = "https://example.com/images/jester.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 257,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 390 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Locust", --//(STRING)
            model = "locust",
            photo = "https://example.com/images/locust.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 220,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 391 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Neo", --//(STRING)
            model = "neo",
            photo = "https://example.com/images/neo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 224,	--//(INT)
            stock = 0,
            trunk = 5,--	//(INT)
            id = 392 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Neon", --//(STRING)
            model = "neon",
            photo = "https://example.com/images/neon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 280,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 393 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Niobe", --//(STRING)
            model = "niobe",
            photo = "https://example.com/images/niobe.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 242,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 394 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Omnisegt", --//(STRING)
            model = "omnisegt",
            photo = "https://example.com/images/omnisegt.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 284,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 395 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Panthere", --//(STRING)
            model = "panthere",
            photo = "https://example.com/images/panthere.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 265,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 396 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Paragon", --//(STRING)
            model = "paragon",
            photo = "https://example.com/images/paragon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 281,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 397 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Paragon3", --//(STRING)
            model = "paragon3",
            photo = "https://example.com/images/paragon3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 236,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 398 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sm722", --//(STRING)
            model = "sm722",
            photo = "https://example.com/images/sm722.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 269,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 399 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Stingertt", --//(STRING)
            model = "stingertt",
            photo = "https://example.com/images/stingertt.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 400 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tenf2", --//(STRING)
            model = "tenf2",
            photo = "https://example.com/images/tenf2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 246,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 401 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vstr", --//(STRING)
            model = "vstr",
            photo = "https://example.com/images/vstr.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 237,	--//(INT)
            stock = 0,
            trunk = 5,--	//(INT)
            id = 402 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Adder", --//(STRING)
            model = "adder",
            photo = "https://example.com/images/adder.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 279,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 403 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Autarch", --//(STRING)
            model = "autarch",
            photo = "https://example.com/images/autarch.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 276,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 404 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Champion", --//(STRING)
            model = "champion",
            photo = "https://example.com/images/champion.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 240,	--//(INT)
            stock = 0,
            trunk = 14,--	//(INT)
            id = 405 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cheetah", --//(STRING)
            model = "cheetah",
            photo = "https://example.com/images/cheetah.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 298,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 406 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Cyclone", --//(STRING)
            model = "cyclone",
            photo = "https://example.com/images/cyclone.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 249,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 407 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Deveste", --//(STRING)
            model = "deveste",
            photo = "https://example.com/images/deveste.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 297,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 408 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Emerus", --//(STRING)
            model = "emerus",
            photo = "https://example.com/images/emerus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 244,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 409 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Entityxf", --//(STRING)
            model = "entityxf",
            photo = "https://example.com/images/entityxf.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 254,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 410 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Entity2", --//(STRING)
            model = "entity2",
            photo = "https://example.com/images/entity2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 295,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 411 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Entity3", --//(STRING)
            model = "entity3",
            photo = "https://example.com/images/entity3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 231,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 412 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Fmj", --//(STRING)
            model = "fmj",
            photo = "https://example.com/images/fmj.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 274,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 413 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Furia", --//(STRING)
            model = "furia",
            photo = "https://example.com/images/furia.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 275,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 414 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Gp1", --//(STRING)
            model = "gp1",
            photo = "https://example.com/images/gp1.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 259,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 415 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Ignus", --//(STRING)
            model = "ignus",
            photo = "https://example.com/images/ignus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 231,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 416 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Infernus", --//(STRING)
            model = "infernus",
            photo = "https://example.com/images/infernus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 297,	--//(INT)
            stock = 0,
            trunk = 5,--	//(INT)
            id = 417 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Italigtb2", --//(STRING)
            model = "italigtb2",
            photo = "https://example.com/images/italigtb2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 298,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 418 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Krieger", --//(STRING)
            model = "krieger",
            photo = "https://example.com/images/krieger.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 294,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 419 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nero", --//(STRING)
            model = "nero",
            photo = "https://example.com/images/nero.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 227,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 420 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Nero2", --//(STRING)
            model = "nero2",
            photo = "https://example.com/images/nero2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 220,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 421 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Osiris", --//(STRING)
            model = "osiris",
            photo = "https://example.com/images/osiris.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 285,	--//(INT)
            stock = 0,
            trunk = 5,--	//(INT)
            id = 422 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Pipistrello", --//(STRING)
            model = "pipistrello",
            photo = "https://example.com/images/pipistrello.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 266,	--//(INT)
            stock = 0,
            trunk = 12,--	//(INT)
            id = 423 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Prototipo", --//(STRING)
            model = "prototipo",
            photo = "https://example.com/images/prototipo.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 247,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 424 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Reaper", --//(STRING)
            model = "reaper",
            photo = "https://example.com/images/reaper.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 221,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 425 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Sc1", --//(STRING)
            model = "sc1",
            photo = "https://example.com/images/sc1.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 299,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 426 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "T20", --//(STRING)
            model = "t20",
            photo = "https://example.com/images/t20.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 294,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 427 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Taipan", --//(STRING)
            model = "taipan",
            photo = "https://example.com/images/taipan.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 259,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 428 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tempesta", --//(STRING)
            model = "tempesta",
            photo = "https://example.com/images/tempesta.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 279,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 429 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tezeract", --//(STRING)
            model = "tezeract",
            photo = "https://example.com/images/tezeract.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 251,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 430 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Thrax", --//(STRING)
            model = "thrax",
            photo = "https://example.com/images/thrax.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 266,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 431 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tigon", --//(STRING)
            model = "tigon",
            photo = "https://example.com/images/tigon.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 295,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 432 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Torero2", --//(STRING)
            model = "torero2",
            photo = "https://example.com/images/torero2.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 224,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 433 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Turismor", --//(STRING)
            model = "turismor",
            photo = "https://example.com/images/turismor.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 260,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 434 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Turismo3", --//(STRING)
            model = "turismo3",
            photo = "https://example.com/images/turismo3.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 259,	--//(INT)
            stock = 0,
            trunk = 9,--	//(INT)
            id = 435 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tyrant", --//(STRING)
            model = "tyrant",
            photo = "https://example.com/images/tyrant.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 222,	--//(INT)
            stock = 0,
            trunk = 15,--	//(INT)
            id = 436 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Tyrus", --//(STRING)
            model = "tyrus",
            photo = "https://example.com/images/tyrus.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 293,	--//(INT)
            stock = 0,
            trunk = 6,--	//(INT)
            id = 437 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vacca", --//(STRING)
            model = "vacca",
            photo = "https://example.com/images/vacca.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 294,	--//(INT)
            stock = 0,
            trunk = 10,--	//(INT)
            id = 438 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Vagner", --//(STRING)
            model = "vagner",
            photo = "https://example.com/images/vagner.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 254,	--//(INT)
            stock = 0,
            trunk = 11,--	//(INT)
            id = 439 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Virtue", --//(STRING)
            model = "virtue",
            photo = "https://example.com/images/virtue.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 300,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 440 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Visione", --//(STRING)
            model = "visione",
            photo = "https://example.com/images/visione.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 234,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 441 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Voltic", --//(STRING)
            model = "voltic",
            photo = "https://example.com/images/voltic.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 260,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 442 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Xa21", --//(STRING)
            model = "xa21",
            photo = "https://example.com/images/xa21.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 266,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 443 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zeno", --//(STRING)
            model = "zeno",
            photo = "https://example.com/images/zeno.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 252,	--//(INT)
            stock = 0,
            trunk = 7,--	//(INT)
            id = 444 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zentorno", --//(STRING)
            model = "zentorno",
            photo = "https://example.com/images/zentorno.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 294,	--//(INT)
            stock = 0,
            trunk = 8,--	//(INT)
            id = 445 --//
        },
        {
            type = "S", 	--//(STRING) -- CATEGORY MUST BE UPPERCASE
            label = "Zorrusso", --//(STRING)
            model = "zorrusso",
            photo = "https://example.com/images/zorrusso.png",-- //(STRING)
            price = 0,	--//(INT)
            speed = 230,	--//(INT)
            stock = 0,
            trunk = 13,--	//(INT)
            id = 446 --//
        },
    }
}

Shared.Translations = {
    onBuyMessage = "You successfully bought the vehicle",
    noStock = "The car is out of stock",
    successfullybuy = "The vehicle with plates %s now belongs to you.",
    bussyTestDrive = "Test drive is already in progress, try later",
    doneTestDrive = "Test Drive complete!",
    testDriveSeconds = "Test drive takes %s seconds",
    assetProblemMessage = "The vehicle doesn't exist in server assets! Contact Server Developer.",
    loadingAssetMessage = "~y~Loading ~Assetta Vehicles...",
}

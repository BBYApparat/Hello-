Config = {}
Config.Locale = 'en'
Config.SharedObjectName = 'esx:getSharedObject'

Config.DebugPoly = false
Config.Volume = 0.2

Config.DigTime = 10 --sec
Config.Chances = {
	common = 100, -- always 100%
	rare = 50,
	epic = 10,
}

Config.Zones = {
	[1] = {
		blip = {enable = true, name = 'Prospecting', sprite = 485, color = 3, size = 0.8},
		location = vector3(1530.48, 6615.84, 2.31),
		radius = 50.0,
		spawn_limit = 10,
		detection_distance = 1.2,
		items = {
			common = {
				{name = 'brokenglasses', minimum = 1, maximum = 1},
				{name = 'brokenpendrive', minimum = 1, maximum = 1},
				{name = 'rustedrod', minimum = 1, maximum = 1},
				{name = 'brokenphone', minimum = 1, maximum = 1},
			},
			rare = {
				{name = 'actioncam', minimum = 1, maximum = 1},
				{name = 'goldchain', minimum = 1, maximum = 1},
				{name = 'goldrolex', minimum = 1, maximum = 1},
				{name = 'rustygun', minimum = 1, maximum = 1},
				{name = 'weddingring', minimum = 1, maximum = 1},
                {name = 'usb', minimum = 1, maximum = 2},
				{name = 'white_card', minimum = 1, maximum = 1},

			},
			epic = {
				{name = 'dianecklace', minimum = 1, maximum = 1},
				{name = 'gem', minimum = 1, maximum = 1},
			}
		}
	}
}

Config.UsePawnShop = false
Config.Shops = {
    ['Pawn Shop'] = {                   -- any unique name for this config
        pos = vector3(-1254.75, -810.56, 17.31),
        blip = {enable = false, name = 'Pawn Shop', sprite = 272, color = 2, size = 0.6},
        items = {
            brokenglasses = {                       -- item name
                label = 'Broken Glasses',           -- item label
                price = math.random(200, 250),   	-- will be random between those two numbers in every server restart or you can use a fixed value
            },
            brokenpendrive = {                       
                label = 'Broken Glasses',           
                price = 250,
            },
            rustedrod = {                       
                label = 'Rusted Rod',           
                price = 350,
            },
            brokenphone = {                       
                label = 'Rusted Rod',           
                price = 550,
            },

            actioncam = {                       
                label = 'Action Cam',           
                price = 750,
            },
            goldchain = {                       
                label = 'Gold Chain',           
                price = 4500,
            },
            goldrolex = {                       
                label = 'Gold Rolex',           
                price = 4500,
            },
            rustygun = {                       
                label = 'Rusty Gun',           
                price = 1500,
            },
            weddingring = {                       
                label = 'Wedding Ring',           
                price = 2500,
            },
            dianecklace = {                       
                label = 'Dia Necklace',           
                price = 12000,
            },
            gem = {                       
                label = 'Gem',           
                price = 15000,
            },
            
        },
    },
}
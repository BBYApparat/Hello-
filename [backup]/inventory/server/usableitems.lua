local pillControl = {}
local armoryControl = {}
local controlpills = {}
local EatDrink20Times = {}
local UsersMedkit = {}
local UsedPolaroids = {}
local PolaroidHook = "DISCORD_WEBHOOK_STORAGE_FOR_POLAROID"

local AllowedLicenses = {
    ["dmv"] = "Theory Test",
    ["drive"] = "Car License",
    ["drive_bike"] = "Bike License",
    ["drive_truck"] = "Truck License"
}

local items = {
    --Standard Shops
    {name = 'water',             thirst = 100000,                event = 'onDrink',                 details = { prop_name = "bottle" },   },
	{name = 'toast',             hunger = 100000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'cocacola',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "bottle" }, },
    {name = 'greentea',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "bottle" }, },
    {name = 'passiontea',        thirst = 500000,                event = 'onDrink',                 details = { prop_name = "bottle" }, },
    {name = 'lemonade',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
    {name = 'orangeade',         thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'freshorangejuice',  thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	--Limeys
    {name = 'rambo',             thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'hulk',              thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'gymmy',             thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'borabora',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'tornado',           thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'superman',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'join',              thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'gardener',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'd_tox',             thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
	{name = 'avocado_toast',     hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'chicken_plate',     hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'highprotein_salad', hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'vegan_salad',       hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    --Mums Donuts
	{name = 'chocolate_donut',   hunger = 650000,                event = 'onEat',                   details = { prop_name = "donut"  },   },
	{name = 'rainbow_donut',     hunger = 650000,                event = 'onEat',                   details = { prop_name = "donut"  },   },
	{name = 'white_choco_donut', hunger = 650000,                event = 'onEat',                   details = { prop_name = "donut"  },   },
	{name = 'shark_donut',       hunger = 650000,                event = 'onEat',                   details = { prop_name = "donut"  },   },
	{name = 'cortado',           thirst = 650000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
	{name = 'mocha',             thirst = 650000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
	{name = 'latte',             thirst = 650000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
	{name = 'americano',         thirst = 650000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
    --Hornys
    {name = 'chickennuggets',    hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'chickenburger',     hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'nuggets_burger',    hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'hornys_cola',       thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
    {name = 'hornys_fanta',      thirst = 500000,                event = 'onDrink',                 details = { prop_name = "soda" },     },
    --Pier
    {name = 'espresso',          thirst = 500000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
    {name = 'milkshake',         thirst = 500000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
    {name = 'icecream',          hunger = 500000,                event = 'onEat',                   details = { prop_name = "donut" },    },
    {name = 'salmon_sandwich',   hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'cheese_fries',      hunger = 500000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'cooked_fish',       hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	--Pearls
    {name = 'mussels',           hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'shrimpspaghetti',   hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'fish_salad',        hunger = 500000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'fish_vegetables',   hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'fish_sauce',        hunger = 500000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    --Mere
    {name = 'corned_beef',       hunger = 500000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'stew',              hunger = 500000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'shepherd_pie',      hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'irish_cold_coffee', thirst = 500000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
    {name = 'irish_coffee',      thirst = 500000,                event = 'onDrink',                 details = { prop_name = "coffee" },   },
    --Up N Atom
    {name = 'hamburger',         hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'beefburger',        hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'spicybuffalo',      hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'hawaiianburger',    hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'bbqburger',         hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'applepie',          hunger = 450000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'deersteak',         hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'mixgrilled',        hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'tripe',             hunger = 700000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'fries',             hunger = 300000,                event = 'onEat',                   details = { prop_name = "fries" },    },
    --Park Jung
    {name = 'ramen',             hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'miso',              hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'noodlebowl',        hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
	{name = 'ricebowl',          hunger = 650000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'mosaic_maki',       hunger = 400000,                event = 'onEat',                   details = { prop_name = "burger" },   },
    {name = 'mugi_shochu',       drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'sake',              drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    --Drink Snacks
	{name = 'laysgreen',         hunger = 100000,                event = 'onEat',                   details = { prop_name = "fries" },    },
	{name = 'fritos',            hunger = 100000,                event = 'onEat',                   details = { prop_name = "fries" },    },
    --Drinks
    {name = 'beer',              drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'corona',            drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'lucky_saint',       drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'la_trappe',         drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'budweiser',         drunk = 75000,  thirst = 50000, event = 'onDrink',                 details = { prop_name = "beer" },     },
    {name = 'whiskeyglass',      drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    }, 
    {name = 'liquerglass',       drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    }, 
    {name = 'shotglass',         drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "shot" },     },
    {name = 'hotteil',           drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "shot" },     },
    {name = 'vodkaglass',        drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'brandiglass',       drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'red_wineglass',     drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'rose_wineglass',    drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'white_wineglass',   drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'sampenglass',       drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'rhumglass',         drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'tequilaglass',      drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'ginglass',          drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'jagermeisterglass', drunk = 125000, thirst = 50000, event = 'onDrink',                 details = { prop_name = "glass" },    },
    {name = 'binoculars',                                        event = "binoculars",              keep = true                           },
    {name = 'firstaidkit',                                       event = "onFirstAidKit",           keep = true                           },
    {name = 'vitamin',                                           event = "onVitamin",               keep = true                           },
    {name = 'bleedingbandage',                                   event = "onBleedingBandage",       keep = true                           },
    {name = 'coke_sniff',                                        event = "usedCokeSniff",           keep = true                           },
    -- {name = 'bacon_double_cheeseburger', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'bacon_ham_sausage', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'big_fish', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'bs_chicken_jr', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'bs_hamburger', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'double_cheeseburger', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'ham_egg_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'original_chicken_sandwich', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'rodeo_burger', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'spicy_deluxe_sandwich', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'texas_double_whopper', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'whopper_with_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'brown_scramble_bowl', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'brown_scramble_burrito', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'buttered_biscuit', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chick_n_minis', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_biscuit', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_egg_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'egg_cheese_muffin', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'egg_white_grill', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'fruit_cup', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'greek_yogurt_parfait', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'hash_browns', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'sausage_egg_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'bacon_egg_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'biscuits_gravy', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'breakfast_meal', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_and_waffles', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'hot_chicken_wrap', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'omlet', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'shrimp_and_grits', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'strawberry_banana_crepes', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'strawberry_nutella_waffles', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'salmon_caesar_salad', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chocolate_chunk_brownie', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'side_caesar_salad', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'extra_vagan_zza', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'pizza_deluxe', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cali_chicken_bacon', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'buffalo_chicken', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'ultimate_pepperoni', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'spinach_feta', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_habanero', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'philly_cheese_sandwich', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_bacon_ranch', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'italian_sausage_marinara', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_carbonara', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'pasta_primavera', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'bagel_cream_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chocolate_fudge_brownie', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'dunkin_bacon_egg_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'dunkin_croissant', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'dunkin_donuts', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'dunkin_hash_browns', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'dunkin_muffins', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'munchkins_donut_hole', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'snackin_bacon', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'sourdough_breakfast_sandwich', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'stuffed_bagel_minis', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'wake_up_wrap', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'crab_legs_meal', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'glazed_salmon', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'tilapia_fish_meal', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'shells_clam_chowder', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'shrimp_and_crab_dip', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'crab_cakes', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'upeel_shrimp', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'fried_mushrooms', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'oysters_half_shell', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'shrimp_pasta', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'baby_lobster_pasta', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'fried_scallops', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'classic_chicken_sandwich', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'homestyle_mac_cheese', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'mashed_potatoes', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'mild_tenders_box', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'red_beans_rice', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'regular_cajun_rice', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'regular_coleslaw', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'strawberry_cheesecake_pie', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'signature_chicken_box', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cajun_fries', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'carte_biscuit', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cinnamon_apple_pie', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'taco_regular', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'crunchytaco', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'tacomeet', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chalupa_supreme', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cheesy_gordita_crunch', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'soft_taco', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'beefy_nacho', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cheesy_black_bean', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_burrito', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'quesadilla', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cheese_quesadilla', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'crunchwrap_supreme', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'boneless_wings', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'buffalo_ranch_fries', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cajun_fried_corn', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'cheese_fries', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'large_thigh_bites', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'louisiana_voodoo_fries', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'seasoned_fries', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'chicken_caesar_salad', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'garlic_parm_wings', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    -- {name = 'korean_q_wings', hunger = 650000, event = 'onEat', details = { prop_name = "burger" }},
    
    -- -- Drink Items
    -- {name = 'barqs_diet_beer', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_barqs_beer', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_coca_cola', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_dr_pepper', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_fanta_orange', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_fruit_punch', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_iced_tea', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_sprite', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'bs_yello_mello', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'cookie_shake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'pink_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'strawberry_shake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'chick_fil_a_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'brewed_iced_tea', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'sweet_tea', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'chocolate_milkshake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'cookies_cream_milkshake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'frosted_coffee', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'frosted_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'peach_milkshake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'strawberry_milkshake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'vanilla_milkshake', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'icedream_cone', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'icedream_cup', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'red_wine_sangria', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'sangria_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'roseymary_gin_fizz', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'mimosa', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'pomegranate_mimosa', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'patron_margarita', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'hennessy_shot', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'md_ginger_ale', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'md_seltzer_water', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_diet_coke', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_fanta_orange', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_fanta_strawberry', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_hawaiian_punch', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_sprite', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_sweet_tea', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'medium_tropicana_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
    -- {name = 'strawberry_lemonade', drunk = 75000, thirst = 50000, event = 'onDrink', details = { prop_name = "soda" }},
}

local usesItems = {
    { name = "whisky",           item = "whiskeyglass"       },
    { name = "jagermeister",     item = "jagermeisterglass"  },
    { name = "gin",              item = "ginglass"           },
    { name = "rhum",             item = "rhumglass"          },
    { name = "vodka",            item = "vodkaglass"         },
    { name = "crystalheadvodka", item = "vodkaglass"         },
    { name = "tequila",          item = "tequilaglass"       },
    { name = "kahtequila",       item = "tequilaglass"       },
    { name = "sampen",           item = "sampenglass"        },
    { name = "brandy",           item = "brandiglass"        },
    { name = "jameson",          item = "whiskeyglass"       },
    { name = "baileys",          item = "liquerglass"        },
    { name = "white_wine",       item = "white_wineglass"    },
    { name = "red_wine",         item = "red_wineglass"      },
    { name = "rose_wine",        item = "rose_wineglass"     },
    { name = "boostingtab",        item = "boostingtab"     },

}

local TimeoutUserMedKit = function(timer, ident)
    UsersMedkit[ident] = true
    Wait(timer)
    UsersMedkit[ident] = nil
end

local bulletproof = function(source, name, value)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not value then
		value = 100
	end
    xPlayer.triggerEvent("esx_basicneeds:" .. name)
    xPlayer.triggerEvent("esx_status:set", "armor", value)
    TriggerEvent('esx:sendLog', 'vest', { color = 1422320, title = 'Vest Logs', message = GetPlayerName(source)..' ('..xPlayer.source..') ['..xPlayer.identifier.. ']\n just used vest '..name })
end


ESX.RegisterUsableItem('pizzabox', function(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local fromSlot = xPlayer.GetItemBySlot(item.slot)
	if fromSlot.name == item.name then
		xPlayer.triggerEvent('inventory:doProgressBar', "Opening Pizzabox", 2500)
        SetTimeout(2500, function()
            TriggerEvent('inventory:server:opensvInventory', source, "ministorage", item.name, { 
                slots = 5, 
                weight = 7500, 
                items = fromSlot.info.items or {}
            })
        end)
	end
end)

ESX.RegisterUsableItem('id_card', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('used:id_card', -1, {
        name = {
            first = xPlayer.firstname,
            last = xPlayer.lastname
        },
        height = xPlayer.height,
        dob = xPlayer.dateofbirth,
        sex = xPlayer.sex,
        id = xPlayer.source,
        pos = GetEntityCoords(GetPlayerPed(xPlayer.source))
    })
end)

ESX.RegisterUsableItem('polaroid', function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = item.info
    local foundItem = xPlayer.GetItemByName("polaroid_paper")
    if data.quality and data.quality > 0 and foundItem and foundItem.amount > 0 then
        UsedPolaroids[xPlayer.identifier] = item
        xPlayer.triggerEvent('inventory:client:polaroid', PolaroidHook, item)
    end
end)

ESX.RegisterUsableItem('cuff', function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('police:client:handcuff', item)
end)

ESX.RegisterUsableItem('printed_photo', function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local info = item.info
    if info and info.quality then
        if info.quality > 0 then
            local pos = GetEntityCoords(GetPlayerPed(source))
            TriggerClientEvent('inventory:client:printed_photo', -1, info, pos)
            info.quality = info.quality - 5
            xPlayer.updateItemData(item.slot, info)
        else
            xPlayer.showNotification('Photo was extremely damaged.')
            xPlayer.removeInventoryItem('printed_photo', 1, item.slot)
            xPlayer.ItemBox("printed_photo", "remove", 1)
        end
    end
end)

ESX.RegisterUsableItem('driving_license', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local licenses = xPlayer.getUserLicenses()
    local temp_licenses = {}
    for i=1,#licenses do
        local temp_ls = licenses[i]
        if temp_ls and AllowedLicenses[temp_ls] then
            table.insert(temp_licenses, AllowedLicenses[temp_ls])
        end
    end
    TriggerClientEvent('used:license', -1, {
        name = {
            first = xPlayer.firstname,
            last = xPlayer.lastname
        },
        height = xPlayer.height,
        dob = xPlayer.dateofbirth,
        sex = xPlayer.sex,
        id = xPlayer.source,
        type = "driving_license",
        licenses = temp_licenses,
        pos = GetEntityCoords(GetPlayerPed(xPlayer.source))
    })
end)

ESX.RegisterUsableItem("heavybulletproof", function(source)
	bulletproof(source, "heavybulletproof", 200)
end)

ESX.RegisterUsableItem("bulletproof", function(source)
	bulletproof(source, "bulletproof")
end)

ESX.RegisterUsableItem("bulletproof_mini", function(source)
	bulletproof(source, "bulletproof_mini")
end)

ESX.RegisterUsableItem("lockpick", function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('consumables:useLockpick', item)
end)

ESX.RegisterUsableItem("advancedlockpick", function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('consumables:useLockpick', item)
end)

ESX.RegisterUsableItem("bandage", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    if not controlpills[source] then
		controlpills[source] = 0
	end
	if controlpills[source] >= 2 or ( pillControl[source] and pillControl[source] > 2 ) then
		xPlayer.showNotification("You need to wait a small cooldown to use a bandage again", "error", 2000)
		return
	end
    controlpills[source] = controlpills[source] + 1
	xPlayer.removeInventoryItem('bandage', 1)
	xPlayer.triggerEvent("esx_basicneeds:bandage")
    SetTimeout(5 * 60000, function()
		controlpills[source] = controlpills[source] - 1
        if controlpills[source] == 0 then
            controlpills[source] = nil
        end
	end)
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.triggerEvent('esx_contract:getVehicle')
end)

ESX.RegisterUsableItem('boostingtab', function(source)
    TriggerClientEvent('boostingtab:use', source)
end)



ESX.RegisterUsableItem('walkingstick', function(source) 
    TriggerClientEvent('walkingstick:used', source)
end)

CreateThread(function()
    for k, v in pairs(Config.YogaMats) do
        ESX.RegisterUsableItem(k, function(source, item)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.triggerEvent('basicneeds:yogamat', item, v)
        end)
    end
    for k,v in pairs(usesItems) do
        ESX.RegisterUsableItem(v.name, function(source, item)
            local xPlayer = ESX.GetPlayerFromId(source)
            if item and item.slot then
                local theItem = xPlayer.GetItemBySlot(item.slot)
                local shouldDelete = false
                if theItem and theItem.info and theItem.info.uses and theItem.info.uses > 0 then
                    if xPlayer.canCarryItem(v.item, 1) then
                        theItem.info.uses = theItem.info.uses - 1
                        if theItem.info.uses == 0 then
                            shouldDelete = true
                        else
                            xPlayer.updateItemData(item.slot, theItem.info)
                        end
                        local info = ""
                        if ESX.Shared.Items[v.item].itemtype == "expiring" then
                            info = {
                                time = os.time(),
                                quality = 100
                            }
                        end
                        xPlayer.addInventoryItem(v.item, 1, nil, info)
                        xPlayer.ItemBox(v.item, "add", 1)
                        if shouldDelete then
                            xPlayer.removeInventoryItem(v.name, 1, item.slot)
                            xPlayer.ItemBox(v.name, "remove", 1)
                        end
                    else
                        xPlayer.showNotification('Not enough space', 'error', 3000)
                    end
                end
            end
        end)
    end
    for _,v in pairs(items) do
        if v.details then
            v.details.name = v.name
        end
        ESX.RegisterUsableItem(v.name, function(source, item)
            print(json.encode(item))
            local xPlayer = ESX.GetPlayerFromId(source)
            local itemData = ESX.Shared.Items[v.name]
            if itemData.itemtype == "expiring" and item.info.quality and (item.info.quality == 0 or not item.info.time) then
                xPlayer.showNotification('This item has expired', "error", 2000)
                xPlayer.removeInventoryItem(v.name, 1, item.slot)
                xPlayer.ItemBox(v.name, 'remove', 1)
                return
            end
            if v.job ~= nil then
                if xPlayer.job.name ~= v.job then
                    xPlayer.showNotification("Not the right job to use this", "error", 3000)
                    return
                end
            end
            if v.gang ~= nil then
                if xPlayer.gang.name ~= v.gang then
                    xPlayer.showNotification("Not the right criminal to use this", "error", 2000)
                    return
                end
            end
            if v.drunk and v.drunk ~= 0 then
                xPlayer.triggerEvent('esx_status:add', 'drunk', v.drunk)
            end
            if v.thirst and v.thirst ~= 0 then
                xPlayer.triggerEvent('esx_status:add', 'thirst', v.thirst)
            end
            if v.hunger and v.hunger ~= 0 then
                xPlayer.triggerEvent('esx_status:add', 'hunger', v.hunger)
            end
            if v.stress and v.stress ~= 0 then
                xPlayer.triggerEvent('esx_status:remove', 'stress', v.stress)
            end
            if not v.keep then
                xPlayer.removeInventoryItem(v.name, 1, item.slot)
            end
            if string.match(v.event, ":") then
                xPlayer.triggerEvent(v.event)
            else
                local data = item
                if v.details then
                    data.prop_name = v.details.prop_name
                    if v.details.armor then
                        data.armor = v.details.armor
                    end
                end
                xPlayer.triggerEvent('esx_basicneeds:'..v.event, data)
            end
        end)
    end
end)

RegisterServerEvent('basicneeds:pickupmat', function(entId, model)
    local foundYoga = nil
    for k,v in pairs(Config.YogaMats) do
        if model == v then
            foundYoga = k
            break
        end
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if entId then
        local entity = NetworkGetEntityFromNetworkId(entId)
        if entity and DoesEntityExist(entity) and xPlayer.canCarryItem(foundYoga, 1) then
            DeleteEntity(entity)
        else
            foundYoga = nil
        end
    else
        foundYoga = nil
    end
    if foundYoga then
        xPlayer.addInventoryItem(foundYoga, 1)
        xPlayer.ItemBox(foundYoga, "add", 1)
    end
end)

RegisterServerEvent('inventory:server:savePhoto', function(url, itemData)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and UsedPolaroids[xPlayer.identifier] then
        UsedPolaroids[xPlayer.identifier] = nil
        local slot = itemData.slot
        local info = itemData.info
        if slot and info and info.quality and info.quality > 0 then
            xPlayer.removeInventoryItem("polaroid_paper", 1)
            info.quality = info.quality - 5
            xPlayer.updateItemData(slot, info)
            xPlayer.showNotification('This might take some time for polaroid to print your photo', "inform", 3000)
            SetTimeout(math.random(10000, 15000), function()
                local info = {
                    quality = math.random(90, 100),
                    url = url
                }
                xPlayer.addInventoryItem("printed_photo", 1, nil, info)
                xPlayer.ItemBox("printed_photo", "add", 1)
            end)
        else
            xPlayer.showNotification('Polaroid just broke.', "error", 3000)
        end
    end
end)

for k,v in pairs(Config.MechanicItems) do
    ESX.RegisterUsableItem(v.name, function(source, item)
        TriggerClientEvent("onMechanic:useItem", source, item)
    end)
end
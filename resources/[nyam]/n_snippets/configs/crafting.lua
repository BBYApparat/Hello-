Config.Crafting = {
		["criminal"] = {
		label = "Smelt Ores",
		icon = "fa-solid fa-screwdriver-wrench",
		object = `prop_tablesaw_01`,
		coords = vec4(1110.63, -2008.61, 31.04, 53.84),
		distance = 2.0,-
		items = {
			{
				name = 'weapon_pistol',
				ingredients = {
					copper_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
		}
	},
	["criminal2"] = {
		label = "Smelt Ores",
		icon = "fa-solid fa-screwdriver-wrench",
		object = `prop_tablesaw_01`,
		coords = vec4(1110.63, -2008.61, 31.04, 53.84),
		distance = 2.0,
		items = {
			{
				name = 'ammo-9',
				ingredients = {
					copper_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
		}
	},
	["mining_smelter_craft_1"] = {
		blip = { label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94) },
		label = "Smelt Ores",
		icon = "fa-solid fa-screwdriver-wrench",
		-- object = `v_ilev_found_cranebucket`,
		coords = vec4(1110.63, -2008.61, 31.04, 53.84),
		distance = 2.0,
		-- jobs = {"mechanic"},
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'copper_ingot',
				ingredients = {
					copper_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'iron_ingot',
				ingredients = {
					iron_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'silver_ingot',
				ingredients = {
					silver_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'gold_ingot',
				ingredients = {
					gold_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'titanium_ingot',
				ingredients = {
					titanium_nugget = 4
				},
				duration = 5000,
				count = 1,
			},
		}
	},
	["mining_smelter_craft_2"] = {
		-- blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "Smelt Ores",
		icon = "fa-solid fa-screwdriver-wrench",
		object = `prop_tablesaw_01`,
		coords = vec4(1112.1, -1998.43, 30.98, -125.17),
		distance = 2.0,
		-- jobs = {"mechanic"},
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'carbon_kevlar',
				ingredients = {
					carbon_piece = 1
				},
				duration = 5000,
				count = 2,
			},
			{
				name = 'diamond',
				ingredients = {
					uncut_diamond = 1
				},
				duration = 5000,
				count = 2,
			},
			{
				name = 'ruby',
				ingredients = {
					uncut_ruby = 1
				},
				duration = 5000,
				count = 2,
			},
			{
				name = 'silverchain',
				ingredients = {
					silver_ingot = 1,
				},
				duration = 15000,
				count = 1,
			},
			{
				name = 'silver_ring',
				ingredients = {
					silver_ingot = 1,
				},
				duration = 15000,
				count = 1,
			},
			{
				name = 'ruby_ring_silver',
				ingredients = {
					silver_ingot = 1,
					ruby = 1
				},
				duration = 15000,
				count = 1,
			},
			{
				name = 'ruby_ring_gold',
				ingredients = {
					gold_ingot = 1,
					ruby = 1
				},
				duration = 15000,
				count = 1,
			},
			{
				name = 'diamond_ring_silver',
				ingredients = {
					silver_ingot = 1,
					diamond = 1
				},
				duration = 15000,
				count = 1,
			},
			{
				name = 'diamond_necklace_silver',
				ingredients = {
					silver_ingot = 1,
					diamond = 7
				},
				duration = 25000,
				count = 1,
			},
			{
				name = 'diamond_earring_silver',
				ingredients = {
					silver_ingot = 1,
					diamond = 4
				},
				duration = 12500,
				count = 1,
			},
		}
	},

	["burgershot_craft_1"] = {
		--	blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "Burgershot Cuisine",
		icon = "fa-solid fa-burger",
		-- object = `v_ilev_found_cranebucket`,
		coords = vec4(-1186.34, -901.27, 13.8, 38.65),
		distance = 2.0,
		jobs = { "burgershot" },
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'burger',
				ingredients = {
					burgerbun = 1,
					lettuce = 2,
					tomato = 1,
					boar_meat = 1,
					deer_meat = 1,
					mustard = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'cheeseburger',
				ingredients = {
					burgerbun = 1,
					lettuce = 2,
					tomato = 1,
					boar_meat = 1,
					deer_meat = 1,
					cheese = 1,
					mustard = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'bsfries',
				ingredients = {
					potato = 2
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'bsrings',
				ingredients = {
					onions = 2
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'bsdrink',
				ingredients = {
					ecola = 1,
					water = 1,
					ice = 3
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'bscoffee',
				ingredients = {
					raw_coffee = 1,
					sugar = 1,
					water = 1,
					milk = 1
				},
				duration = 5000,
				count = 1,
			},
		}
	},

	-- ["pearls_craft_1"] = {
	-- 	blip = {label = "pearls_craft_1", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)}, -- να παει στην σωστή τοποθεσία
	--     label = "Perls Cuisine",
	-- 	icon = "fa-solid fa-screwdriver-wrench",
	--     -- object = `v_ilev_found_cranebucket`,
	--     coords = vec4(-1846.46, -1194.17, 14.31, 66.08),
	-- 	distance = 2.0,
	--     jobs = {"pearls"},
	--     -- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
	-- 	items = {
	-- 		{
	-- 			name = 'saute_salmon',
	-- 			ingredients = {
	-- 				salmon = 2,
	-- 				lettuce = 2,
	-- 				milk = 1,
	-- 				water = 1,
	-- 				egg_crate = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'shrimp_pasta',
	-- 			ingredients = {
	-- 				shrimps = 5,
	-- 				pasta = 1,
	-- 				tomato = 2,
	-- 				onions = 1,
	-- 				water = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'lobster_pasta',
	-- 			ingredients = {
	-- 				lobster = 1,
	-- 				pasta = 1,
	-- 				tomato = 3,
	-- 				onions = 1,
	-- 				water = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'coffee',
	-- 			ingredients = {
	-- 				raw_coffee = 1,
	-- 				sugar = 1,
	-- 				water = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'capuccino',
	-- 			ingredients = {
	-- 				raw_coffee = 1,
	-- 				sugar = 1,
	-- 				milk = 1,
	-- 				water = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'espresso',
	-- 			ingredients = {
	-- 				raw_coffee = 2,
	-- 				sugar = 1,
	-- 				water = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 		{
	-- 			name = 'blueberry_cheesecake',
	-- 			ingredients = {
	-- 				blueberry = 5,
	-- 				cheese = 1,
	-- 				milk = 1,
	-- 				water = 1,
	-- 				sugar = 2,
	-- 				egg_crate = 1
	-- 			},
	-- 			duration = 5000,
	-- 			count = 1,
	-- 		},
	-- 	}
	-- },

	["uwu_craft_1"] = {
		--	blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "UwU Cuisine",
		icon = "fa-solid fa-burger",
		-- object = `v_ilev_found_cranebucket`,
		coords = vec4(-590.39, -1063.01, 22.36, 88.72),
		distance = 2.0,
		jobs = { "uwu" },
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			-- Item definitions (previously defined)
			["uwu_coffeetogo"] = {
				label = "UwU Coffee To-Go",
				description = "A refreshing coffee drink to take away.",
				weight = 25,
				stack = true,
				close = true,
			},
			["uwu_catdonut"] = {
				label = "UwU Cat Donut",
				description = "A cute cat-shaped donut.",
				weight = 15,
				stack = true,
				close = true,
			},
			["uwu_blueberrytea"] = {
				label = "UwU Blueberry Tea",
				description = "A soothing blueberry-flavored tea.",
				weight = 20,
				stack = true,
				close = true,
			},
			["uwu_cataccino"] = {
				label = "UwU Cataccino",
				description = "A cappuccino with a cute cat design on top.",
				weight = 30,
				stack = true,
				close = true,
			},
			["uwu_catlatte"] = {
				label = "UwU Cat Latte",
				description = "A creamy latte with a cat-themed design.",
				weight = 30,
				stack = true,
				close = true,
			},
			["uwu_catlolipop"] = {
				label = "UwU Cat Lolipop",
				description = "A sweet cat-shaped lollipop.",
				weight = 10,
				stack = true,
				close = true,
			},

			-- Recipe definitions
			{
				name = 'uwu_coffeetogo',
				ingredients = {
					raw_coffee = 1,
					sugar = 1,
					water = 1,
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'uwu_catdonut',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					banana = 1,
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'uwu_blueberrytea',
				ingredients = {
					blueberry = 1,
					sugar = 2,
					water = 1,
					milk = 2,
					ice = 1,
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'uwu_cataccino',
				ingredients = {
					raw_coffee = 1,
					sugar = 1,
					water = 1,
					milk = 1,
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'uwu_catlatte',
				ingredients = {
					raw_coffee = 1,
					sugar = 2,
					water = 1,
					milk = 2,
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'uwu_catlolipop',
				ingredients = {
					sugar = 7,
					water = 1,
					strawberry = 1,
				},
				duration = 5000,
				count = 1,
			},
		}
	},

	["polar_craft_1"] = {
		--	blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "Polar Cuisine",
		icon = "fa-solid fa-burger",
		-- object = `v_ilev_found_cranebucket`,
		coords = vec4(272.08, 134.8, 104.44, 202.25),
		distance = 2.0,
		jobs = { "polar" },
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'cone_strawberry',
				ingredients = {
					milk = 1,
					strawberry = 5,
					sugar = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'cone_chocolate',
				ingredients = {
					milk = 1,
					chocolate = 3,
					sugar = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'cone_cherry',
				ingredients = {
					milk = 1,
					cherry = 5,
					sugar = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'cone_banana',
				ingredients = {
					milk = 1,
					banana = 5,
					sugar = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'cone_blueberry',
				ingredients = {
					milk = 1,
					blueberry = 5,
					sugar = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'milkshake_strawberry',
				ingredients = {
					milk = 1,
					cone_strawberry = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'milkshake_chocolate',
				ingredients = {
					milk = 1,
					cone_chocolate = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'milkshake_cherry',
				ingredients = {
					milk = 1,
					cone_cherry = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'milkshake_banana',
				ingredients = {
					milk = 1,
					cone_banana = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'milkshake_blueberry',
				ingredients = {
					milk = 1,
					cone_blueberry = 2,
					ice = 3,
					water = 1
				},
				duration = 5000,
				count = 1,
			},
			{
				name = 'polarcoffee',
				ingredients = {
					raw_coffee = 1,
					sugar = 1,
					water = 1,
					milk = 1
				},
				duration = 5000,
				count = 1,
			},
		}
	},

	
	["donut_craft_1"] = {
		--	blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "Donut Cuisine",
		icon = "fa-solid fa-burger",
		-- object = `v_ilev_found_cranebucket`,
		coords = vec4(272.08, 134.8, 104.44, 202.25),
		distance = 2.0,
		jobs = { "donut" },
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'donut1',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 7
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'donut2',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					chocolate = 1
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'donut3',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					chocolate = 1,
					strawberry = 1
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'donut4',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					chocolate = 1,
					banana = 1
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'donut5',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					blueberry = 1,
					strawberry = 1
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'donut6',
				ingredients = {
					egg_crate = 1,
					corn_flour = 1,
					water = 2,
					milk = 1,
					sugar = 3,
					cherry = 1,
					strawberry = 1
				},
				duration = 10000,
				count = 1,
			},			
		}
	},

		
	["taco_craft_1"] = {
		--	blip = {label = "Ore Smelter", sprite = 436, size = 0.8, color = 21, coords = vec3(1108.27, -2006.58, 30.94)},
		label = "Taco Cuisine",
		icon = "fa-solid fa-burger",
		-- object = `v_ilev_found_cranebucket`,
		coords = vector4(11.373, -1599.32, 29.376, 41.044),
		distance = 2.0,
		jobs = { "taco" },
		-- jobGrades = {1, 5, 11}, -- You can use "all" or table of grade levels example: {1, 5, 11}
		items = {
			{
				name = 'taco_shell',
				ingredients = {
					corn_flour = 1,
					egg_crate = 1,
					water = 1
				},
				duration = 15000,
				count = 1,
			},
			
			{
				name = 'taco_soft_shell',
				ingredients = {
					corn_flour = 1,
					egg_crate = 1,
					water = 1
				},
				duration = 10000,
				count = 1,
			},
			
			{
				name = 'nachos',
				ingredients = {
					nachos_chips = 1
				},
				duration = 5000,
				count = 1,
			},
			
			{
				name = 'crunchy_taco_deer',
				ingredients = {
					taco_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					cheese = 1,
					deer_meat = 1,
					mustard = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'soft_taco_deer',
				ingredients = {
					taco_soft_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					cheese = 1,
					deer_meat = 1,
					mustard = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'crunchy_taco_boar',
				ingredients = {
					taco_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					cheese = 1,
					boar_meat = 1,
					mustard = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'soft_taco_boar',
				ingredients = {
					taco_soft_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					cheese = 1,
					boar_meat = 1,
					mustard = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'crunchy_taco_salmon',
				ingredients = {
					taco_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					lemon = 1,
					salmon = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'soft_taco_salmon',
				ingredients = {
					taco_soft_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					lemon = 1,
					salmon = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'crunchy_taco_shrimp',
				ingredients = {
					taco_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					lemon = 1,
					shrimps = 1
				},
				duration = 20000,
				count = 1,
			},
			
			{
				name = 'soft_taco_shrimp',
				ingredients = {
					taco_soft_shell = 1,
					lettuce = 2,
					tomato = 2,
					onions = 1,
					lemon = 1,
					shrimps = 1
				},
				duration = 20000,
				count = 1,
			},	
		}
	},
}



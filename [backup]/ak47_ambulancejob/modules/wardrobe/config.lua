Config.ClothingScript = 'auto' --Auto detect or ['ak47_clothing','esx_skin','raid_clothes','rcore_clothes','illenium-appearance', 'codem-apperance']

Config.Lockers = {
	{
		zone 		= vector3(300.26, -598.66, 43.28),  		--zone position
		rotation 	= 160.0,									--zone rotation
		size 		= vector3(4.0, 3.0, 2.0),					--zone size
	},
}

Config.Preset = { --only supported with ak47_clothing or esx_skin
	{
		Name = 'Outfit 1',
		JobGrades = {
			[0] = true,
			[1] = true,
			[2] = true,
			[3] = true,
			[4] = true,
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
		},
		SkinData = { -- skin value will be different in your server. You have to adjust
			male = {
				tshirt_1 = 154, arms = 19,
				torso_1 = 250, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
			},
			female = {
				tshirt_1 = 154, arms = 19,
				torso_1 = 250, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
			}
		}
	},

	{
		Name = 'Outfit 2',
		JobGrades = {
			[1] = true,
			[2] = true,
			[3] = true,
			[4] = true,
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
		},
		SkinData = { -- skin value will be different in your server. You have to adjust
			male = {
				tshirt_1 = 154, arms = 20,
				torso_1 = 348, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
				watches_1 = -1, watches_2 = 0,
				bracelets_1 = -1, bracelets_2 = 0,
			},
			female = {
				tshirt_1 = 154, arms = 20,
				torso_1 = 348, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
				watches_1 = -1, watches_2 = 0,
				bracelets_1 = -1, bracelets_2 = 0,
			}
		}
	},

	{
		Name = 'Outfit 3',
		JobGrades = {
			[2] = true,
			[3] = true,
			[4] = true,
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
		},
		SkinData = { -- skin value will be different in your server. You have to adjust
			male = {
				tshirt_1 = 154, arms = 20,
				torso_1 = 321, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
				watches_1 = -1, watches_2 = 0,
				bracelets_1 = -1, bracelets_2 = 0,
			},
			female = {
				tshirt_1 = 154, arms = 20,
				torso_1 = 321, torso_2 = 0,
				decals_1 = 58, decals_2 = 0,
				pants_1 = 28, pants_2 = 0,
				shoes_1 = 10, shoes_2 = 0,
				chain_1 = 126, chain_2 = 0,
				watches_1 = -1, watches_2 = 0,
				bracelets_1 = -1, bracelets_2 = 0,
			}
		}
	},
}
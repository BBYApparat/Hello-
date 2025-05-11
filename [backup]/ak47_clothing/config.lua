Config = {}
Config.SharedObjectName = 'esx:getSharedObject'         --Change if you Shared Object Name is different
Config.Locale = 'en'

Config.ESXVersion = 'legacy' -- 1.1 , 1.2, final, legacy (try all variation if menu is not popping up)

Config.CharacterCreationMenu = {
    {menu = "character", label = "Character", selected = false},
    {menu = "clothing", label = "Clothing", selected = false},
    {menu = "accessoires", label = "Accessories", selected = false},
    {menu = "tattoos", label = "Tattoos", selected = false},
}

--Texture slots are not supported here
Config.BlockClothingById = {
    --[[Example

    [0] = { --for male
        torso_1 = {5, 7, 9},
        pants_1 = {1, 2, 3},
    },
    [1] = { --for female
        torso_1 = {5, 7, 9},
        pants_1 = {1, 2, 3},
    }

    ]]

    [0] = { --for male
        
    },
    [1] = { --for female
        
    },
}

Config.BlockClothingByRange = {
    --[[Example

    [0] = { --for male
        torso_1 = {
            {rangeStart = 1, rangeEnd = 5},
            {rangeStart = 15, rangeEnd = 25},
        },
        pants_1 = {
            {rangeStart = 1, rangeEnd = 5},
            {rangeStart = 15, rangeEnd = 25},
        },
    },
    [1] = { --for female
        torso_1 = {
            {rangeStart = 1, rangeEnd = 5},
            {rangeStart = 15, rangeEnd = 25},
        },
        pants_1 = {
            {rangeStart = 1, rangeEnd = 5},
            {rangeStart = 15, rangeEnd = 25},
        },
    }

    ]]

    [0] = { --for male
        
    },
    [1] = { --for female
        
    },
}

--Don't touch unless you understand
Config.ResetTexture = {
    tshirt_1 = 'tshirt_2',
    torso_1 = 'torso_2',
    arms = 'arms_2',
    bproof_1 = 'bproof_2',
    decals_1 = 'decals_2',
    pants_1 = 'pants_2',
    shoes_1 = 'shoes_2',
    helmet_1 = 'helmet_2',
    glasses_1 = 'glasses_2',
    ears_1 = 'ears_2',
    mask_1 = 'mask_2',
    chain_1 = 'chain_2',
    watches_1 = 'watches_2',
    bracelets_1 = 'bracelets_2',
    bags_1 = 'bags_2',
}
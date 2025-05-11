Config = {}

Config.enableKeyMapping = false -- enables the key mapping for the commands in gta settings
Config.keyMappingDefaultKeys = { -- the empty string '' means the key mapping is empty and players can map it to any key in gta settings
    catalogue = '',
    bill = '',
    billboss = '',
    oldbill = ''
}

Config.PlayerMaxDistance = 5.0 -- acceptable transaction distance
Config.ShopMaxDistance = 30.0 -- acceptable distance for /catalogue

Config.TypeOfMoneyToUse = 3 -- the type of money customer will use to pay the bill -- 1 = use only cash | 2 = use only bank | 3 = use first cash then bank | 4 = use first bank then cash

Config.KeysToEnableWhileUIOpen = { -- this keys will be usable while the nui is open
    249, -- push to talk (INPUT_PUSH_TO_TALK)
    21, -- sprint (INPUT_SPRINT)
    22, -- jump (INPUT_JUMP)
    30, -- movement left/right (INPUT_MOVE_LR)
    31 -- movement up/down (INPUT_MOVE_UD)
}
Config.KeysToCloseUI = { -- this keys will close the nui
    25, -- right mouse button (INPUT_AIM)
    200, -- esc (INPUT_FRONTEND_PAUSE_ALTERNATE)
}

Config.enableVersionChecker = true -- enables the version checher on resource start (if enabled and the resource is out of date will print in server console)
Config.enableDebugMessages = true -- enables some prints for debug

--[[
    This jobs will have access to use this receipt system (no need to add something manualy in database)
        name : the job name in database
        label : the label (display name) of the job for the nui to draw
        position : the positions of the shop that someone can access the catalogue in the acceptable distance ('Config.ShopMaxDistance')
        bossGradeName : the job grade name in database for boss to access the /billboss
]]
Config.Jobs = {
    {
        name = 'tequila',
        label = 'Tequi-La-La',
        position = {x = -560.10, y = 287.15, z = 82.00},
        bossGradeName = 'boss'
    },
    {
        name = 'unicorn',
        label = 'Vanilla Unicorn',
        position = {x = 127.70, y = -1285.40, z = 29.00},
        bossGradeName = 'boss'
    },
    {
        name = 'bennys',
        label = 'Bahama Mamas',
        position = {x = -1386.70, y = -614.30, z = 30.80},
        bossGradeName = 'boss'
    },
    {
        name = 'aldentes',
        label = 'Al Dentes',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'ambulance',
        label = 'Ambulance',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'bahamas',
        label = 'Bahama Mamas',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'bennys',
        label = 'Bennys',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'bikerzvault',
        label = 'Bikerz Vault',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'burgershot',
        label = 'Burgershot',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'cannabiscafe',
        label = 'Cannabis Cafe',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'cardealer',
        label = 'Cardealer',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'chick-fil-a',
        label = 'Chick-fil-A',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'cluckinbell',
        label = 'Cluckin Bell',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'cookies',
        label = 'Cookies',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'craftbar',
        label = 'Craft Bar',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'dominos',
        label = 'Dominos',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'dunkin',
        label = 'Dunkin\'',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'farmer',
        label = 'Farmer',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'garbage',
        label = 'Garbage Collector',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'gotur',
        label = 'Gotur',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'gunsla',
        label = 'Guns LA',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'hookahlounge',
        label = 'Hookah Lounge',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'icebox',
        label = 'Icebox',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'japancars',
        label = 'Japan Cars',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'jet',
        label = 'Jet',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'mcdonalds',
        label = 'McDonalds',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'mechanic',
        label = 'Mechanic',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'nailbeauty',
        label = 'Nail & Beauty',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'naillashes',
        label = 'Nail & Lashes',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'off_mechanic',
        label = 'Mechanic - Off duty',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'pearls',
        label = 'Pearls',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'platinumcars',
        label = 'Platinum Cars',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'popeyes',
        label = 'Popeyes',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'taco',
        label = 'Taco',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'tattoo',
        label = 'Tattoo',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'unicorn',
        label = 'Vanilla Unicorn',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    },
    {
        name = 'wingstop',
        label = 'Wingstop',
        position = {x = 0.0, y = 0.0, z = 0.0},
        bossGradeName = 'boss'
    }
}

--[[
    This items will be accesible from boss to add in their bill
        name : the name of the item in database
        label : the label (display name) of the item to draw in nui (not nessasary if you change 'getLabelOfItem' function in server_functions.lua file yo use a external label)
]]
Config.AvailableItems = {
    {name = 'water', label = 'Water'},
    {name = 'bread', label = 'Bread'},
    {name = 'burger', label = 'Burger'}
}








------------------------------------------------
---- DO NOT CHANGE ANYTHING AFTER THAT!!!!! ----
------------------------------------------------

Config.JOBS_INITED = {}
for i = 1, #Config.Jobs, 1 do
    local job = Config.Jobs[i]

    if (Config.JOBS_INITED[job.name] == nil) then
        Config.JOBS_INITED[job.name] = {
            label = job.label,
            position = job.position,
            bossGradeName = job.bossGradeName
        }
    end
end

Config.AVAILABLE_ITEMS_INITED = {}
for i = 1, #Config.AvailableItems, 1 do
    local item = Config.AvailableItems[i]
    
    if (Config.AVAILABLE_ITEMS_INITED[item.name] == nil) then
        Config.AVAILABLE_ITEMS_INITED[item.name] = {
            label = item.label
        }
    end
end

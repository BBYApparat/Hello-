return {

    ['bandage'] = {
        label = 'Bandage',
        weight = 115,
        client = {
            anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
            prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
            disable = { move = true, car = true, combat = true },
            usetime = 2500,
        }
    },

    ['burger'] = {
        label = 'Burger',
        weight = 220,
        client = {
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            notification = 'You ate a delicious burger'
        },
    },

    ['sprunk'] = {
        label = 'Sprunk',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a sprunk'
        }
    },

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['garbage'] = {
        label = 'Garbage',
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 1,
        stack = false,
        close = false,
        consume = 0
    },

    ['id_card'] = {
        label = 'Identification',
        client = {
            image = 'card_id.png'
        }
    },

    ['driver_license'] = {
        label = 'Driver License',
        client = {
            image = 'card_id.png'
        }
    },

    ['lockpick'] = {
        label = 'Lockpick',
        weight = 160,
    },
	
    ['advancedlockpick'] = {
        label = 'Advnaced Lockpick',
        weight = 160,
    },

    ['phone'] = {
        label = 'Phone',
        weight = 190,
        stack = false,
        consume = 0,
        client = {
            add = function(total)
                if total > 0 then
                    pcall(function() return exports.npwd:setPhoneDisabled(false) end)
                end
            end,

            remove = function(total)
                if total < 1 then
                    pcall(function() return exports.npwd:setPhoneDisabled(true) end)
                end
            end
        }
    },

    ['mustard'] = {
        label = 'Mustard',
        weight = 500,
        client = {
            status = { hunger = 25000, thirst = 25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
            usetime = 2500,
            notification = 'You.. drank mustard'
        }
    },

    ['radio'] = {
        label = 'Radio',
        weight = 1000,
        stack = false,
        allowArmed = true
    },

    ['armour'] = {
        label = 'Bulletproof Vest',
        weight = 3000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
        }
    },

    ['femaleseed'] = {
        label = 'Female Marijuana Seed',
        weight = 1000,
        consume = 0,
        server = {
            export = 'rep-weed.femaleseed',
        },
        description = 'Surely I can just plant this, right?'
    },
    ['maleseed'] = {
        label = 'Male Marijuana Seed',
        weight = 1000,
        consume = 0,
        description = 'Add this to a planted female seed to make it pregnant? You are pretty sure this seed has a penis.'
    },
    ['wateringcan'] = {
        label = 'Watering Can',
        weight = 7000,
        consume = 0,
        server = {
            export = 'rep-weed.wateringcan',
        },
        description = 'Fill this at a river or lake.'
    },
    ['fertilizer'] = {
        label = 'Fertilizer',
        weight = 1000,
        consume = 0,
        description = 'Cool'
    },
    ['wetbud'] = {
        label = 'Wet Bud (100 grams)',
        weight = 3500,
        consume = 0,
        description = 'THIS CANT BE DRIED WITHOUT STRAIN... Needs to be stored somewhere dry.'
    },
    ['driedbud'] = {
        label = 'Dried Bud (100 Grams)',
        weight = 10000,
        consume = 0,
        server = {
            export = 'rep-weed.driedbud',
        },
        description = 'Pack It?'
    },
    ['weedpackage'] = {
        label = 'Suspicious Package',
        weight = 25000,
        consume = 0,
        server = {
            export = 'rep-weed.weedpackage',
        },
        description = 'Marked for Police Seizure'
    },
    ['qualityscales'] = {
        label = 'Quality Scales',
        weight = 2000,
        consume = 0,
        description = 'Weighs Baggies with no loss'
    },
    ['smallscales'] = {
        label = 'Small Scales',
        weight = 1000,
        description = 'Weighs Baggies with minimal loss'
    },
    ['joint'] = {
        label = '2g Joint',
        weight = 1000,
        consume = 0,
        server = {
            export = 'rep-weed.joint',
        },
        description = 'Its a Joint, man.'
    },
    ['emptybaggies'] = {
        label = 'Empty Baggies',
        weight = 1000,
        description = 'Empty Baggies'
    },
    ['weedbaggie'] = {
        label = 'Baggie (7g)',
        weight = 1000,
        consume = 0,
        server = {
            export = 'rep-weed.weedbaggie',
        },
        description = 'Sold on the streets'
    },
    ['rollingpaper'] = {
        label = 'Rolling Paper',
        weight = 200,
        description = 'Required to roll joints!'
    },

    ['dongle'] = {
        label = 'USB Dongle',
        weight = 1,
        stack = false,
        close = true,
        description = ''
    },

    ['vpn'] = {
        label = 'VPN',
        weight = 1,
        stack = true,
        close = false,
        description = ''
    },

    ['transponder'] = {
        label = 'Transponder',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },

    ['hacking_device'] =
    {
        label = 'Hacking Device',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },

    ['laptop'] = {
        label = 'Laptop',
        weight = 1,
        stack = false,
        close = true,
        description = ''
    },
    ['decrypter'] = {
        label = 'Decrypter',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },
    ['black_usb'] = {
        label = 'Black USB',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },
    ['pendrive'] = {
        label = 'Pendrive',
        weight = 1,
        stack = false,
        close = false,
        description = 'Can store personal data'
    },



    ['bodycam'] = {
        label = 'Body Cam',
        weight = 1,
        stack = false,
        close = false,
        description = 'PD Bodycam'
    },

    ['dashcam'] = {
        label = 'Body Cam',
        weight = 1,
        stack = false,
        close = false,
        description = 'PD dashcam'
    },


    ['e_laptop'] = {
        label = 'Hacking Laptop',
        weight = 1,
        stack = false,
        close = false,
        description = ''
    },

    ['wifi_scanner'] = {
        label = 'Wifi Scanner',
        weight = 1,
        stack = false,
        close = false,
        description = ''
    },

    ['wifi_scanner'] = {
        label = ' ',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['wifi_scanner'] = {
        label = ' ',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['apple'] = {
        label = 'apple',
        weight = 1,
        stack = true,
        close = false,
        description = ''
    },

    ['orange'] = {
        label = 'orange',
        weight = 1,
        stack = true,
        close = false,
        description = ''
    },

    ['pear'] = {
        label = 'pear',
        weight = 1,
        stack = true,
        close = false,
        description = ''
    },

    ['cherry'] = {
        label = 'cherry',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['peach'] = {
        label = 'peach',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },
    ['banana'] = {
        label = 'banana',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['strawberry'] = {
        label = 'strawberry',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['blueberry'] = {
        label = 'blueberry',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['grape'] = {
        label = 'grape',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['lemon'] = {
        label = 'lemon',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['mango'] = {
        label = 'mango',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['watermelon'] = {
        label = 'watermelon',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['finger_scanner'] = {
        label = 'Fingerprint Scanner',
        weight = 1,
        stack = true,
        close = false,
        description = ' '
    },

    ['medikit'] = { -- Make sure not already a medikit
        label = 'Medikit',
        weight = 165,
        stack = true,
        close = true,
    },
    ['medbag'] = {
        label = 'Medical Bag',
        weight = 165,
        stack = false,
        close = true,
    },

    ['tweezers'] = {
        label = 'Tweezers',
        weight = 2,
        stack = true,
        close = true,
    },

    ['suturekit'] = {
        label = 'Suture Kit',
        weight = 15,
        stack = true,
        close = true,
    },

    ['icepack'] = {
        label = 'Ice Pack',
        weight = 29,
        stack = true,
        close = true,
    },

    ['burncream'] = {
        label = 'Burn Cream',
        weight = 19,
        stack = true,
        close = true,
    },

    ['defib'] = {
        label = 'Defibrillator',
        weight = 225,
        stack = false,
        close = true,
    },

    ['sedative'] = {
        label = 'Sedative',
        weight = 15,
        stack = true,
        close = true,
    },

    ['morphine30'] = {
        label = 'Morphine 30MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['morphine15'] = {
        label = 'Morphine 15MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['perc30'] = {
        label = 'Percocet 30MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['perc10'] = {
        label = 'Percocet 10MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['perc5'] = {
        label = 'Percocet 5MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['vic10'] = {
        label = 'Vicodin 10MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['vic5'] = {
        label = 'Vicodin 5MG',
        weight = 2,
        stack = true,
        close = true,
    },

    ['recoveredbullet'] = {
        label = 'Recovered Bullet',
        weight = 1,
        stack = true,
        close = false,
    },

    ['handcuffs'] = {
        label = 'Hand Cuffs',
        weight = 2,
        stack = true,
        close = true,
    },

    ['bobby_pin'] = {
        label = 'Bobby Pin',
        weight = 2,
        stack = true,
        close = true,
    },

    ['uvlight'] = {
        label = 'UV Light',
        weight = 95,
        stack = false
    },
    ['bleachwipes'] = {
        label = 'Bleach Wipes',
        weight = 185,
        stack = true
    },


    ["engine_s"] = {
        label = "Engine S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_a"] = {
        label = "Engine A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_b"] = {
        label = "Engine B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_c"] = {
        label = "Engine C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_d"] = {
        label = "Engine D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_s"] = {
        label = "Transmission S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_a"] = {
        label = "Transmission A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_b"] = {
        label = "Transmission B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_c"] = {
        label = "Transmission C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_d"] = {
        label = "Transmission D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_s"] = {
        label = "Suspension S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_a"] = {
        label = "Suspension A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_b"] = {
        label = "Suspension B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_c"] = {
        label = "Suspension C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_d"] = {
        label = "Suspension D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_s"] = {
        label = "Brake S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_a"] = {
        label = "Brake A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_b"] = {
        label = "Brake B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_c"] = {
        label = "Brake C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_d"] = {
        label = "Brake D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_s"] = {
        label = "Turbo S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_a"] = {
        label = "Turbo A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_b"] = {
        label = "Turbo B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_c"] = {
        label = "Turbo C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_d"] = {
        label = "Turbo D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_s"] = {
        label = "Armour S",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_a"] = {
        label = "Armour A",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_b"] = {
        label = "Armour B",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_c"] = {
        label = "Armour C",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_d"] = {
        label = "Armour D",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_repair_kit"] = {
        label = "Engine repair kit",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["body_repair_kit"] = {
        label = "Body repair kit",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["cosmetics"] = {
        label = "Cosmetics",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
    },
    ["mechanic_toolbox"] = {
        label = "Mechanics toolbox",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
        client = {
            export = 'mt_workshops.openToolboxMenu'
        }
    },
    ["neons_controller"] = {
        label = "Neons controller",
        weight = 1000,
        stack = true,
        close = true,
        description = "",
        client = {
            export = 'mt_workshops.openLightsController'
        }
    },
    ["mods_list"] = {
        label = "Vehicle mods list",
        weight = 0,
        stack = true,
        close = true,
        description = "",
        client = {
            export = 'mt_workshops.openCosmeticsMenu'
        }
    },
    ["extras_controller"] = {
        label = "Vehicle extras",
        weight = 0,
        stack = true,
        close = true,
        description = "",
        client = {
            export = 'mt_workshops.openExtrasMenu'
        }
    },

    -- Add these items to your ox_inventory items list

    ['weapon_dagger'] = {
        label = 'Dagger',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A short knife with a pointed and edged blade, used as a weapon.',
        client = {
            image = 'WEAPON_DAGGER.png'
        }
    },

    ['weapon_musket'] = {
        label = 'Musket',
        weight = 3000,
        stack = false,
        close = true,
        description = 'A muzzle-loaded long gun that appeared as a smoothbore weapon in the early 16th century.',
    },

    ['pickaxe'] = {
        label = 'Pickaxe',
        weight = 2000,
        stack = false,
        close = true,
        description =
        'A tool with a hard head attached perpendicularly to the handle, used for breaking up hard ground or rock.',
    },

    ['copper_nugget'] = {
        label = 'Copper Nugget',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, rough piece of copper ore.',
    },

    ['silver_nugget'] = {
        label = 'Silver Nugget',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, rough piece of silver ore.',
    },

    ['iron_nugget'] = {
        label = 'Iron Nugget',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, rough piece of iron ore.',
    },

    ['titanium_nugget'] = {
        label = 'Titanium Nugget',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, rough piece of titanium ore.',
    },

    ['gold_nugget'] = {
        label = 'Gold Nugget',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, rough piece of gold ore.',
    },

    ['copper_ingot'] = {
        label = 'Copper Ingot',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bar of refined copper.',
    },

    ['silver_ingot'] = {
        label = 'Silver Ingot',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bar of refined silver.',
    },

    ['iron_ingot'] = {
        label = 'Iron Ingot',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bar of refined iron.',
    },

    ['titanium_ingot'] = {
        label = 'Titanium Ingot',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bar of refined titanium.',
    },

    ['gold_ingot'] = {
        label = 'Gold Ingot',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bar of refined gold.',
    },

    ['kiwi'] = {
        label = 'Kiwi',
        weight = 100,
        stack = true,
        close = true,
        description = 'A small, oval fruit with fuzzy brown skin and bright green flesh.',
    },

    ['whale'] = {
        label = 'Whale',
        weight = 15000,
        stack = false,
        close = true,
        description = 'A very large marine mammal. This is quite the catch!',
    },


    ['salmon'] = {
        label = 'Salmon',
        weight = 2000,
        stack = true,
        close = true,
        description = 'A popular fish known for its pink flesh and distinct flavor.',
    },


    ['scrap'] = {
        label = 'Scrap',
        weight = 100,
        stack = true,
        close = true,
        description = 'Discarded material that may still have some value.',
    },

    ['goldenwatch'] = {
        label = 'Golden Watch',
        weight = 200,
        stack = true,
        close = true,
        description = 'A luxury timepiece known for its precision and status.',
    },

    ['goldbar'] = {
        label = 'Gold Bar',
        weight = 1000,
        stack = true,
        close = true,
        description = 'A bar of pure gold, highly valuable.',
    },

    ['goldchain'] = {
        label = 'Gold Chain',
        weight = 200,
        stack = true,
        close = true,
        description = 'A decorative chain made of gold.',
    },

    ['diamond'] = {
        label = 'Diamond',
        weight = 100,
        stack = true,
        close = true,
        description = 'A precious gemstone known for its brilliance and hardness.',
    },

    ['ring'] = {
        label = 'Ring',
        weight = 50,
        stack = true,
        close = true,
        description = 'A circular band, typically of precious metal, worn as ornamental jewelry.',
    },

    ['tost'] = {
        label = 'Toast',
        weight = 100,
        stack = true,
        close = true,
        description = 'Sliced bread that has been browned by exposure to radiant heat.',
    },

    ['sandwich'] = {
        label = 'Sandwich',
        weight = 200,
        stack = true,
        close = true,
        description =
        'A food typically consisting of vegetables, sliced cheese or meat, placed on or between slices of bread.',
    },

    ['paperbox'] = {
        label = 'Paper Box',
        weight = 50,
        stack = true,
        close = true,
        description = 'A container made of paperboard, used for packaging.',
    },

    ['box'] = {
        label = 'Box',
        weight = 50,
        stack = true,
        close = true,
        description = 'A container made of paperboard, used for packaging. But these one seems mysterious',
    },

    ['notepad'] = {
        label = 'Notepad',
        weight = 100,
        stack = true,
        close = true,
        description = 'A pad of paper for writing notes.',
    },

    ['whiskey'] = {
        label = 'Whiskey',
        weight = 500,
        stack = true,
        close = true,
        description = 'A type of distilled alcoholic beverage made from fermented grain mash.',
    },

    ['vodka'] = {
        label = 'Vodka',
        weight = 500,
        stack = true,
        close = true,
        description = 'A clear distilled alcoholic beverage.',
    },

    ['potato'] = {
        label = 'Potato',
        weight = 100,
        stack = true,
        close = true,
        description = 'A starchy tuber of the plant Solanum tuberosum, a root vegetable.',
    },

    ['tomato'] = {
        label = 'Tomato',
        weight = 100,
        stack = true,
        close = true,
        description = 'The edible berry of the plant Solanum lycopersicum, commonly known as a tomato plant.',
    },

    ['weapon_poolcue'] = {
        label = 'Pool Cue',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A stick used to strike billiard balls in cue sports. Can also be used as a weapon.',
    },

    ['weed_nutrition'] = {
        label = 'Weed Nutrition',
        weight = 500,
        stack = true,
        close = true,
        description = 'Nutrients specifically designed for growing marijuana plants.',
    },

    ['empty_weed_bag'] = {
        label = 'Empty Weed Bag',
        weight = 10,
        stack = true,
        close = true,
        description = 'A small plastic bag used for packaging marijuana.',
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 5,
        stack = true,
        close = true,
        description = 'Thin paper used for rolling cigarettes or joints.',
    },

    ['diving_gear'] = {
        label = 'Diving Gear',
        weight = 30000,
        stack = false,
        close = true,
        description = 'Equipment used for scuba diving, including an air tank and regulator.',
    },

    ['jerry_can'] = {
        label = 'Jerry Can',
        weight = 20000,
        stack = true,
        close = true,
        description = 'A robust liquid container made from pressed steel, originally designed for military use.',
    },

    ['diving_fill'] = {
        label = 'Diving Tank Refill',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Compressed air to refill scuba tanks.',
    },

    ['weapon_knife'] = {
        label = 'Knife',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A cutting tool with a cutting edge or blade attached to a handle.',
    },

    ['weapon_bat'] = {
        label = 'Baseball Bat',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A smooth wooden or metal club used in the sport of baseball to hit the ball.',
    },

    ['weapon_hatchet'] = {
        label = 'Hatchet',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A small, light axe with a short handle for use in one hand.',
    },

    ['weapon_snspistol'] = {
        label = 'SNS Pistol',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A compact, easily concealed pistol.',
    },

    ['weapon_vintagepistol'] = {
        label = 'Vintage Pistol',
        weight = 1000,
        stack = false,
        close = true,
        description = 'An old-school pistol with a classic design.',
    },

    ['casinochips'] = {
        label = 'Casino Chips',
        weight = 0,
        stack = true,
        close = true,
        description = 'Tokens used as currency in casinos.',
    },

    ['dojbadge'] = {
        label = 'DOJ Badge',
        weight = 100,
        stack = false,
        close = true,
        description = 'Official badge of the Department of Justice.',
    },

    ['emptydocument'] = {
        label = 'Empty Document',
        weight = 10,
        stack = true,
        close = true,
        description = 'A blank document ready to be filled.',
    },

    ['portablecopier'] = {
        label = 'Portable Copier',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A small, portable device for making copies of documents.',
    },

    ['hacking_computer'] = {
        label = 'Hacking Computer',
        weight = 2000,
        stack = false,
        close = true,
        description = 'A specialized computer used for hacking purposes.',
    },

    ['trojan_usb'] = {
        label = 'Trojan USB',
        weight = 100,
        stack = true,
        close = true,
        description = 'A USB drive containing malicious software.',
    },

    ['thermite'] = {
        label = 'Thermite',
        weight = 1000,
        stack = true,
        close = true,
        description = 'A pyrotechnic composition of metal powder fuel and metal oxide.',
    },

    ['cutter'] = {
        label = 'Cutter',
        weight = 1000,
        stack = false,
        close = true,
        description = 'A tool designed for cutting through various materials.',
    },

    ['laser_drill'] = {
        label = 'Laser Drill',
        weight = 2000,
        stack = false,
        close = true,
        description = 'A high-tech drilling tool that uses a laser to cut through hard materials.',
    },

    ['weapon_switchblade'] = {
        label = 'Switchblade',
        weight = 500,
        stack = false,
        close = true,
        description = 'A knife with a folding or sliding blade contained in the handle.',
    },

    ['gas_mask'] = {
        label = 'Gas Mask',
        weight = 500,
        stack = false,
        close = true,
        description = 'A mask used to protect the wearer from inhaling airborne pollutants and toxic gases.',
    },

    ['water'] = {
        label = 'Water Bottle',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bottle filled with clean, drinkable water.',
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water'
        }
    },

    ['water_bottle'] = {
        label = 'Water Bottle',
        weight = 500,
        stack = true,
        close = true,
        description = 'A bottle filled with clean, drinkable water.',
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water'
        }
    },

    ['tirekit'] = {
        label = 'Tire Kit',
        weight = 1000,
        stack = true,
        close = true,
        description = 'A kit containing tools and materials for repairing or changing tires.',
    },

    ['bodykit'] = {
        label = 'Body Kit',
        weight = 1000,
        stack = true,
        close = true,
        description = 'A collection of exterior modifications for a vehicle.',
    },

    ['screwdriverset'] = {
        label = 'Screwdriver Set',
        weight = 1000,
        stack = true,
        close = true,
        description = 'A set of screwdrivers in various sizes and types.',
    },

    ['tequila'] = {
        label = 'Tequila',
        weight = 500,
        stack = true,
        close = true,
        description = 'A distilled beverage made from the blue agave plant, primarily in Mexico.',
    },

    ['ecola_zero'] = {
        label = 'Diet Coke',
        weight = 350,
        stack = true,
        close = true,
        description = 'A sugar-free and low-calorie soft drink.',
    },

    ['sangria_lemonade'] = {
        label = 'Sangria Lemonade',
        weight = 350,
        stack = true,
        close = true,
        description = 'A refreshing blend of sangria and lemonade.',
    },

    ['strawberry_lemonade'] = {
        label = 'Strawberry Lemonade',
        weight = 350,
        stack = true,
        close = true,
        description = 'A sweet and tangy lemonade infused with strawberry flavor.',
    },

    ['beer'] = {
        label = 'Beer',
        weight = 500,
        stack = true,
        close = true,
        description = 'An alcoholic beverage made from fermented grains.',
    },

    ['binoculars'] = {
        label = 'Binoculars',
        weight = 1000,
        stack = false,
        close = true,
        description = 'An optical instrument used to view distant objects in greater detail.',
    },

    -- Add these items to your ox_inventory items list

    ['deer_meat'] = {
        label = 'Deer Meat',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Fresh meat from a hunted deer. Can be cooked for food.',
    },

    ['deer_pelt'] = {
        label = 'Deer Pelt',
        weight = 2000,
        stack = true,
        close = true,
        description = 'The hide of a deer. Useful for crafting leather goods.',
    },

    ['deer_horn'] = {
        label = 'Deer Horn',
        weight = 500,
        stack = true,
        close = true,
        description = 'An antler from a deer. Can be used for decorative or crafting purposes.',
    },

    ['boar_meat'] = {
        label = 'Boar Meat',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Fresh meat from a hunted boar. Can be cooked for food.',
    },

    ['boar_pelt'] = {
        label = 'Boar Pelt',
        weight = 2000,
        stack = true,
        close = true,
        description = 'The hide of a boar. Tough and durable, useful for crafting.',
    },

    ['boar_tusks'] = {
        label = 'Boar Tusks',
        weight = 300,
        stack = true,
        close = true,
        description = 'The tusks of a boar. Can be used for crafting or sold as a trophy.',
    },

    ['plastic'] = {
        label = 'Plastic',
        weight = 100,
        stack = true,
        close = true,
        description = 'A piece of scavenged plastic. Useful for various crafting recipes.',
    },

    ['rubber'] = {
        label = 'Rubber',
        weight = 100,
        stack = true,
        close = true,
        description = 'A piece of scavenged rubber. Can be used in crafting or repairs.',
    },


    ['brokenglasses'] = {
        label = 'Broken Glasses',
        weight = 50,
        stack = true,
        close = true,
        description = 'A pair of broken glasses. Might be repairable or useful for parts.',
    },

    ['brokenpendrive'] = {
        label = 'Broken Pendrive',
        weight = 50,
        stack = true,
        close = true,
        description = 'A damaged USB drive. Could potentially be repaired or contain valuable data.',
    },

    ['brokenphone'] = {
        label = 'Broken Phone',
        weight = 200,
        stack = true,
        close = true,
        description = 'A non-functional phone. Might be repairable or useful for parts.',
    },

    ['glass'] = {
        label = 'Glass',
        weight = 100,
        stack = true,
        close = true,
        description = 'A piece of scavenged glass. Can be used in various crafting recipes.',
    },

    ['scrapelectronics'] = {
        label = 'Scrap Electronics',
        weight = 100,
        stack = true,
        close = true,
        description = 'Assorted electronic components. Useful for crafting or repairing electronic devices.',
    },

    ['emerald'] = {
        label = 'Emerald',
        weight = 50,
        stack = true,
        close = true,
        description = 'A precious green gemstone. Highly valuable and used in jewelry.',
    },

    ["bands"] = {
        label = "Band of Cash",
        weight = 30,
        stack = true,
        close = true,
    },

    ["oxy"] = {
        label = "Oxytocin",
        weight = 30,
        stack = true,
        close = true,
    },

    ["package"] = {
        label = "A Sealed Package",
        weight = 2500,
        stack = true,
        close = true,
    },

    ["rolls"] = {
        label = "Black Money",
        weight = 30,
        stack = true,
        close = true,
    },

    ["lobster"] = {
        label = "Lobster",
        description = "A luxurious seafood delicacy.",
        weight = 42,
        stack = true,
        close = true,
    },

    ["milk"] = {
        label = "Milk",
        description = "Nutritious dairy beverage.",
        weight = 48,
        stack = false,
        close = true,
    },

    ["uncut_diamond"] = {
        label = "Uncut Diamond",
        description = "Raw, unprocessed diamond gem.",
        weight = 18,
        stack = true,
        close = true,
    },

    ["uncut_emerald"] = {
        label = "Uncut Emerald",
        description = "Raw, unprocessed emerald gem.",
        weight = 16,
        stack = true,
        close = true,
    },

    ["uncut_ruby"] = {
        label = "Uncut Ruby",
        description = "Raw, unprocessed ruby gem.",
        weight = 12,
        stack = true,
        close = true,
    },

    ["uncut_sapphire"] = {
        label = "Uncut Sapphire",
        description = "Raw, unprocessed sapphire gem.",
        weight = 32,
        stack = true,
        close = true,
    },

    ["carbon_piece"] = {
        label = "Carbon Piece",
        description = "Raw material used in various industries.",
        weight = 19,
        stack = true,
        close = true,
    },

    ["carbon_kevlar"] = {
        label = "Carbon Kevlar",
        description = "Strong, lightweight composite material.",
        weight = 15,
        stack = true,
        close = true,
    },

    ["ruby"] = {
        label = "Ruby",
        description = "Precious red gemstone.",
        weight = 26,
        stack = true,
        close = true,
    },

    ["sapphire"] = {
        label = "Sapphire",
        description = "Precious blue gemstone.",
        weight = 34,
        stack = false,
        close = true,
    },

    ["ice"] = {
        label = "Ice",
        description = "Frozen water cubes for cooling drinks.",
        weight = 43,
        stack = true,
        close = true,
    },

    ["sugar"] = {
        label = "Sugar",
        description = "Sweet crystalline substance for food and drinks.",
        weight = 25,
        stack = true,
        close = true,
    },

    ["wine_white"] = {
        label = "Wine White",
        description = "Bottle of crisp white wine.",
        weight = 47,
        stack = false,
        close = true,
    },


    ["mysterious_white_card"] = {
        label = "Mysterious Card",
        description = "What are these chips on it.",
        weight = 47,
        stack = false,
        close = true,
    },

    ["glass_white_wine"] = {
        label = "Glass White Wine",
        description = "A serving of white wine.",
        weight = 35,
        stack = true,
        close = true,
    },

    ["wine_rose"] = {
        label = "Wine Rose",
        description = "Bottle of refreshing rosé wine.",
        weight = 12,
        stack = false,
        close = true,
    },

    ["glass_rose_wine"] = {
        label = "Glass Rose Wine",
        description = "A serving of rosé wine.",
        weight = 40,
        stack = true,
        close = true,
    },

    ["wine_red"] = {
        label = "Wine Red",
        description = "Bottle of rich red wine.",
        weight = 37,
        stack = true,
        close = true,
    },

    ["glass_red_wine"] = {
        label = "Glass Red Wine",
        description = "A serving of red wine.",
        weight = 38,
        stack = false,
        close = true,
    },

    ["cheese"] = {
        label = "Cheese",
        description = "Dairy product with various flavors and textures.",
        weight = 50,
        stack = true,
        close = true,
    },

    ["egg_crate"] = {
        label = "Egg Crate",
        description = "Container filled with fresh eggs.",
        weight = 13,
        stack = true,
        close = true,
    },

    ["blueberry_cheesecake"] = {
        label = "Blueberry Cheesecake",
        description = "Creamy cheesecake topped with blueberries.",
        weight = 44,
        stack = false,
        close = true,
    },

    ["onions"] = {
        label = "Onions",
        description = "Pungent vegetable used in many dishes.",
        weight = 36,
        stack = true,
        close = true,
    },

    ["turtle"] = {
        label = "Turtle",
        description = "Slow-moving reptile with a hard shell.",
        weight = 5000,
        stack = false,
        close = true,
    },

    ["gold_ring"] = {
        label = "Gold Ring",
        description = "Precious jewelry made of gold.",
        weight = 31,
        stack = true,
        close = true,
    },

    ["silver_ring"] = {
        label = "Silver Ring",
        description = "Elegant jewelry made of silver.",
        weight = 8,
        stack = true,
        close = true,
    },

    ["sapphire_ring_silver"] = {
        label = "Sapphire Ring Silver",
        description = "Silver ring set with a sapphire gemstone.",
        weight = 50,
        stack = false,
        close = true,
    },

    ["sapphire_ring_gold"] = {
        label = "Sapphire Ring Gold",
        description = "Gold ring set with a sapphire gemstone.",
        weight = 9,
        stack = true,
        close = true,
    },

    ["ruby_ring_silver"] = {
        label = "Ruby Ring Silver",
        description = "Silver ring set with a ruby gemstone.",
        weight = 45,
        stack = true,
        close = true,
    },

    ["ruby_ring_gold"] = {
        label = "Ruby Ring Gold",
        description = "Gold ring set with a ruby gemstone.",
        weight = 6,
        stack = true,
        close = true,
    },

    ["silverchain"] = {
        label = "Silverchain",
        description = "Decorative chain made of silver.",
        weight = 47,
        stack = true,
        close = true,
    },

    ["emerald_ring_silver"] = {
        label = "Emerald Ring Silver",
        description = "Silver ring set with an emerald gemstone.",
        weight = 19,
        stack = false,
        close = true,
    },

    ["emerald_ring_gold"] = {
        label = "Emerald Ring Gold",
        description = "Gold ring set with an emerald gemstone.",
        weight = 37,
        stack = true,
        close = true,
    },

    ["diamond_ring_silver"] = {
        label = "Diamond Ring Silver",
        description = "Silver ring set with a diamond.",
        weight = 28,
        stack = true,
        close = true,
    },

    ["diamond_necklace_silver"] = {
        label = "Diamond Necklace Silver",
        description = "Silver necklace adorned with diamonds.",
        weight = 23,
        stack = false,
        close = true,
    },

    ["diamond_earring_silver"] = {
        label = "Diamond Earring Silver",
        description = "Silver earrings set with diamonds.",
        weight = 39,
        stack = true,
        close = true,
    },

    ["chocolate"] = {
        label = "Chocolate",
        description = "Sweet treat made from cocoa.",
        weight = 34,
        stack = false,
        close = true,
    },

    ["lighter"] = {
        label = "Lighter",
        description = "Small device for producing a flame.",
        weight = 42,
        stack = true,
        close = true,
    },

	["cigarette"] = {
		label = "Cigarette",
		description = "Tobacco product for smoking.",
		weight = 32,
		stack = true,
		close = true,
		client = {
			status = { stress = 200000 },
			anim = { dict = "amb@world_human_smoking@female@enter", clip = "enter" },
			prop = { model = `prop_cs_ciggy_01`, pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) },
			usetime = 3500,
			cancel = true,
			notification = 'You smoked a cigarette'
		}
	},

    ["cigsredwood"] = {
        label = "Cigsredwood",
        description = "Pack of Redwood brand cigarettes.",
        weight = 17,
        stack = true,
        close = true,
    },

    ["fishingrod"] = {
        label = "fishingrod",
        description = "Is used for fishing.",
        weight = 31,
        stack = false,
        close = true,
    },

    ["fishingbait"] = {
        label = "Fishbait",
        description = "Lure used to attract fish when fishing.",
        weight = 5,
        stack = true,
        close = true,
    },

    ["bankcard_maze"] = {
        label = "Bankcard Maze",
        description = "Bank card for Maze Bank transactions.",
        weight = 7,
        stack = true,
        close = true,
    },

    ["bankcard_fleeca"] = {
        label = "Bankcard Fleeca",
        description = "Bank card for Fleeca Bank transactions.",
        weight = 22,
        stack = true,
        close = true,
    },

    ["vangelico_card"] = {
        label = "Vangelico Card",
        description = "Membership card for Vangelico Jewelry.",
        weight = 32,
        stack = false,
        close = true,
    },

    ["coffeetogo"] = {
        label = "Coffeetogo",
        description = "Disposable cup of hot coffee.",
        weight = 42,
        stack = true,
        close = true,
    },

    ["snack"] = {
        label = "Snack",
        description = "Small portion of food for quick consumption.",
        weight = 20,
        stack = false,
        close = true,
    },

    ['gopro'] = {
        label = 'GoPro',
        weight = 1,
        stack = true,
        close = true,
        description = 'A camera'
    },

    ['cam_jammer'] = {
        label = 'Cam Jammer',
        weight = 1,
        stack = true,
        close = true,
        description = 'Cam Jammer'
    },

    --Fagadika

    ["cone_strawberry"] = {
        label = "Strawberry Ice Cream Cone",
        description = "A delicious strawberry ice cream in a cone.",
        weight = 100,
        stack = false,
        close = true,
    },

    ["cone_chocolate"] = {
        label = "Chocolate Ice Cream Cone",
        description = "A tasty chocolate ice cream in a cone.",
        weight = 100,
        stack = false,
        close = true,
    },

    ["cone_cherry"] = {
        label = "Cherry Ice Cream Cone",
        description = "A sweet cherry ice cream in a cone.",
        weight = 100,
        stack = false,
        close = true,
    },

    ["cone_banana"] = {
        label = "Banana Ice Cream Cone",
        description = "A creamy banana ice cream in a cone.",
        weight = 100,
        stack = false,
        close = true,
    },

    ["cone_blueberry"] = {
        label = "Blueberry Ice Cream Cone",
        description = "A fruity blueberry ice cream in a cone.",
        weight = 100,
        stack = false,
        close = true,
    },

    ["milkshake_strawberry"] = {
        label = "Strawberry Milkshake",
        description = "A creamy strawberry flavored milkshake.",
        weight = 300,
        stack = false,
        close = true,
    },

    ["milkshake_chocolate"] = {
        label = "Chocolate Milkshake",
        description = "A rich chocolate flavored milkshake.",
        weight = 300,
        stack = false,
        close = true,
    },

    ["milkshake_cherry"] = {
        label = "Cherry Milkshake",
        description = "A sweet cherry flavored milkshake.",
        weight = 300,
        stack = false,
        close = true,
    },

    ["milkshake_banana"] = {
        label = "Banana Milkshake",
        description = "A creamy banana flavored milkshake.",
        weight = 300,
        stack = false,
        close = true,
    },

    ["milkshake_blueberry"] = {
        label = "Blueberry Milkshake",
        description = "A fruity blueberry flavored milkshake.",
        weight = 300,
        stack = false,
        close = true,
    },

    ["polarcoffee"] = {
        label = "Polar Coffee",
        description = "A refreshing iced coffee drink.",
        weight = 250,
        stack = false,
        close = true,
    },


    ["cheeseburger"] = {
        label = "Cheeseburger",
        description = "Classic burger topped with cheese.",
        weight = 27,
        stack = true,
        close = true,
    },

    ["bsfries"] = {
        label = "Burger Shot fries",
        description = "Crispy, golden french fries.",
        weight = 16,
        stack = false,
        close = true,
    },

    ["bsdrink"] = {
        label = "Burger Shot Drink",
        description = "Refreshing soft drink.",
        weight = 11,
        stack = true,
        close = true,
    },

    ["bsrings"] = {
        label = "Burger Shot Rings",
        description = "Crispy, breaded onion rings.",
        weight = 41,
        stack = true,
        close = true,
    },

    ["bscoffee"] = {
        label = "Burger Shot Coffee",
        description = "Hot brewed coffee.",
        weight = 49,
        stack = false,
        close = true,
    },

    ["shrimps"] = {
        label = "Shrimps",
        description = "Small, versatile seafood for various dishes.",
        weight = 5,
        stack = true,
        close = true,
    },

    ["lettuce"] = {
        label = "Lettuce",
        description = "Crisp, leafy vegetable for salads and sandwiches.",
        weight = 39,
        stack = true,
        close = true,
    },

    ["pasta"] = {
        label = "Pasta",
        description = "A staple ingredient in many recipes.",
        weight = 15,
        stack = false,
        close = true,
    },

    ["burgerbun"] = {
        label = "Burgerbun",
        description = "Soft bread roll for making burgers.",
        weight = 29,
        stack = false,
        close = true,
    },

    ["saute_salmon"] = {
        label = "Saute Salmon",
        description = "Delicately cooked salmon fillet.",
        weight = 1000,
        stack = false,
        close = true,
    },

    ["shrimp_pasta"] = {
        label = "Shrimp Pasta",
        description = "Pasta dish with succulent shrimp.",
        weight = 38,
        stack = false,
        close = true,
    },

    ["lobster_pasta"] = {
        label = "Lobster Pasta",
        description = "Luxurious pasta dish featuring lobster.",
        weight = 750,
        stack = false,
        close = true,
    },

    ["fredo_capuccino"] = {
        label = "Fredo Capuccino",
        description = "Chilled, frothy cappuccino beverage.",
        weight = 48,
        stack = false,
        close = true,
    },

    ["fredo_espresso"] = {
        label = "Fredo Espresso",
        description = "Cold, refreshing espresso drink.",
        weight = 22,
        stack = false,
        close = true,
    },

    ["capuccino"] = {
        label = "Capuccino",
        description = "Classic Italian coffee with steamed milk foam.",
        weight = 12,
        stack = true,
        close = true,
    },

    ["ecola"] = {
        label = "Ecola",
        description = "Popular carbonated cola beverage.",
        weight = 23,
        stack = false,
        close = true,
    },

    ["coffee"] = {
        label = "Coffee",
        description = "Hot, aromatic brewed beverage.",
        weight = 24,
        stack = true,
        close = true,
    },

    ["espresso"] = {
        label = "Espresso",
        description = "Concentrated shot of strong coffee.",
        weight = 33,
        stack = true,
        close = true,
    },

    ["whiskycola"] = {
        label = "Whiskycola",
        description = "Cocktail mixing whisky and cola.",
        weight = 14,
        stack = true,
        close = true,
    },

    ["vodkalemon"] = {
        label = "Vodkalemon",
        description = "Refreshing cocktail with vodka and lemon.",
        weight = 28,
        stack = false,
        close = true,
    },

    ["rhumcoca"] = {
        label = "Rhumcoca",
        description = "Cocktail combining rum and cola.",
        weight = 29,
        stack = true,
        close = true,
    },

    --uwu

    ["uwu_cafe_box"] = {
        label = "UwU Cafe Box",
        description = "A box containing UwU Cafe goodies.",
        weight = 100,
        stack = true,
        close = true,
    },
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


    ['donut1'] = {
        label = 'Glazed Donut',
        weight = 250,
        consume = 0,
        description = 'A delicious glazed donut, perfect for a quick snack!'
    },
    
    ['donut2'] = {
        label = 'Chocolate Donut',
        weight = 260,
        consume = 0,
        description = 'A donut covered in rich chocolate glaze. Great for chocolate lovers!'
    },
    
    ['donut3'] = {
        label = 'Jelly-Filled Donut',
        weight = 270,
        consume = 0,
        description = 'Filled with sweet jelly, this donut will brighten up your day.'
    },
    
    ['donut4'] = {
        label = 'Sprinkle Donut',
        weight = 250,
        consume = 0,
        description = 'A colorful donut topped with rainbow sprinkles. A fun treat!'
    },
    
    ['donut5'] = {
        label = 'Cinnamon Donut',
        weight = 240,
        consume = 0,
        description = 'Coated in cinnamon sugar, this donut is a warm and cozy delight.'
    },
    
    ['donut6'] = {
        label = 'Old-Fashioned Donut',
        weight = 230,
        consume = 0,
        description = 'A classic old-fashioned donut, simple yet irresistible.'
    },

    ['taco_bag'] = {
        label = 'Taco Bag',
        weight = 500,
        consume = 0,
        description = 'A bag filled with delicious taco ingredients.'
    },
    
    ['taco_shell'] = {
        label = 'Taco Shell',
        weight = 100,
        consume = 0,
        description = 'A crispy taco shell, ready to be filled with your favorite ingredients.'
    },
    
    ['taco_soft_shell'] = {
        label = 'Soft Taco Shell',
        weight = 120,
        consume = 0,
        description = 'A soft and warm taco shell, perfect for a soft taco.'
    },
    
    ['nachos'] = {
        label = 'Nachos',
        weight = 300,
        consume = 0,
        description = 'Crispy nachos with melted cheese and a sprinkle of spices.'
    },
    
    ['nachos_chips'] = {
        label = 'Nachos Chips',
        weight = 150,
        consume = 0,
        description = 'Crunchy nacho chips, perfect for snacking or dipping.'
    },
    
    ['crunchy_taco_deer'] = {
        label = 'Crunchy Deer Taco',
        weight = 250,
        consume = 0,
        description = 'A taco filled with seasoned deer meat and wrapped in a crunchy shell.'
    },
    
    ['soft_taco_deer'] = {
        label = 'Soft Deer Taco',
        weight = 240,
        consume = 0,
        description = 'A soft taco filled with tender, seasoned deer meat.'
    },
    
    ['crunchy_taco_boar'] = {
        label = 'Crunchy Boar Taco',
        weight = 260,
        consume = 0,
        description = 'A hearty taco with juicy boar meat wrapped in a crunchy shell.'
    },
    
    ['soft_taco_boar'] = {
        label = 'Soft Boar Taco',
        weight = 250,
        consume = 0,
        description = 'A soft taco with succulent boar meat and fresh toppings.'
    },
    
    ['crunchy_taco_salmon'] = {
        label = 'Crunchy Salmon Taco',
        weight = 230,
        consume = 0,
        description = 'A taco with flaky salmon and a crispy shell for a fresh bite.'
    },
    
    ['soft_taco_salmon'] = {
        label = 'Soft Salmon Taco',
        weight = 220,
        consume = 0,
        description = 'A soft taco with delicious salmon and a tangy sauce.'
    },
    
    ['crunchy_taco_shrimp'] = {
        label = 'Crunchy Shrimp Taco',
        weight = 240,
        consume = 0,
        description = 'A crispy taco filled with seasoned shrimp and fresh vegetables.'
    },
    
    ['soft_taco_shrimp'] = {
        label = 'Soft Shrimp Taco',
        weight = 230,
        consume = 0,
        description = 'A soft taco filled with juicy shrimp and a savory sauce.'
    },
    
    



	["2005_blueberry"] = {
		label = "2005 Blueberry Tangiers",
		weight = 1,
		stack = true,
		close = true,
	},

	["4play"] = {
		label = "4Play Fantasia",
		weight = 1,
		stack = true,
		close = true,
	},

	["50_below"] = {
		label = "50 Below Nirvana Dokha",
		weight = 1,
		stack = true,
		close = true,
	},

	["absinthe"] = {
		label = "Absinthe",
		weight = 1,
		stack = true,
		close = true,
	},

	["acamprosate"] = {
		label = "Acamprosate",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["acetone"] = {
		label = "Acetone",
		weight = 1,
		stack = true,
		close = true,
	},

	["acid"] = {
		label = "Acid",
		weight = 1,
		stack = true,
		close = true,
	},

	["acidsupply"] = {
		label = "Acid Supply",
		weight = 1,
		stack = true,
		close = true,
	},

	["acid_paper"] = {
		label = "Acid Paper",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["actioncam"] = {
		label = "Action Camera",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["adalya_love"] = {
		label = "Adalya Love 66",
		weight = 1,
		stack = true,
		close = true,
	},

	["adderall"] = {
		label = "Adderall",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["adrenashot"] = {
		label = "Adrena Shot",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["aloe"] = {
		label = "Aloe",
		weight = 1,
		stack = true,
		close = true,
	},

	["al_fakher"] = {
		label = "Al Fakher Two Apples",
		weight = 1,
		stack = true,
		close = true,
	},

	["ammo_pistol"] = {
		label = "Pistol Ammo",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["ammo_rifle"] = {
		label = "Rifle Ammo",
		weight = 0.05,
		stack = true,
		close = true,
	},

	["ammo_shotgun"] = {
		label = "Shotgun Ammo",
		weight = 0.15,
		stack = true,
		close = true,
	},

	["ammo_smg"] = {
		label = "SMG Ammo",
		weight = 0.04,
		stack = true,
		close = true,
	},

	["ammo_sniper"] = {
		label = "Sniper Ammo",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["amstress"] = {
		label = "Am Stress",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["angeldust"] = {
		label = "Angel Dust",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["anklemonitor"] = {
		label = "Ankle Monitor",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["applesauce"] = {
		label = "Applesauce",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["apple_ juice"] = {
		label = "Honest Kids Apple Juice",
		weight = 1,
		stack = true,
		close = true,
	},

	["apple_gelato"] = {
		label = "Apple Gelato",
		weight = 1,
		stack = true,
		close = true,
	},

	["apple_gelato_joint"] = {
		label = "Apple Gelato Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["apple_juice"] = {
		label = "Honest Kids Apple Juice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["apple_sauce"] = {
		label = "Apple Sauce",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["arm1"] = {
		label = "Armor Lvl. 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["arm2"] = {
		label = "Armor Lvl. 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["arm3"] = {
		label = "Armor Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["arm4"] = {
		label = "Armor Lvl. 4",
		weight = 1,
		stack = true,
		close = true,
	},

	["arm5"] = {
		label = "Armor Lvl. 5",
		weight = 1,
		stack = true,
		close = true,
	},

	["arm6"] = {
		label = "Armor Lvl. 5",
		weight = 1,
		stack = true,
		close = true,
	},

	["armbrace"] = {
		label = "Arm Brace",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["atomic_wings"] = {
		label = "Atomic Wings",
		weight = 1,
		stack = true,
		close = true,
	},

	["baby_lobster_pasta"] = {
		label = "Baby Lobster Pasta",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["backpack"] = {
		label = "Backpack",
		weight = 10,
		stack = true,
		close = true,
		description = "\"Container\""
	},

	["backwoods_grape"] = {
		label = "Backwoods Grape",
		weight = 1,
		stack = true,
		close = true,
	},

	["backwoods_honey"] = {
		label = "Backwoods Honey",
		weight = 1,
		stack = true,
		close = true,
	},

	["backwoods_russian_cream"] = {
		label = "Backwoods Russian Cream",
		weight = 1,
		stack = true,
		close = true,
	},

	["baconburger"] = {
		label = "Baconburger",
		weight = 1,
		stack = true,
		close = true,
	},

	["bacon_double_cheeseburger"] = {
		label = "Bacon Double Cheeseburger",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bacon_egg_cheese"] = {
		label = "Bacon Egg Cheese",
		weight = 1,
		stack = true,
		close = true,
	},

	["bacon_ham_sausage"] = {
		label = "Fully Loaded Bacon Ham Sausage",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bacon_king"] = {
		label = "Bacon King",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bag"] = {
		label = "Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["bagel_cream_cheese"] = {
		label = "BAGELS WITH CREAM CHEESE SPREAD",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bag_of_ice"] = {
		label = "5 lb Bag of Ice",
		weight = 1,
		stack = true,
		close = true,
	},

	["bakingsoda"] = {
		label = "Baking Soda",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["banana_backwoods"] = {
		label = "Banana Backwoods",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["barqs_diet_beer"] = {
		label = "Medium Diet Barqs Root Beer",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bathsalts"] = {
		label = "Bath Salts",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["battery"] = {
		label = "Battery",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["beefy_nacho"] = {
		label = "Beefy Nacho",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bigger_family_feast"] = {
		label = "Bigger Family Feast",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["big_fish"] = {
		label = "Big Fish",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["big_mac"] = {
		label = "Big Mac",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["big_mac_combo"] = {
		label = "Big Mac Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["biscotti"] = {
		label = "Biscotti",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["biscotti_joint"] = {
		label = "Biscotti Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["biscuits_gravy"] = {
		label = "Biscuits Gravy",
		weight = 1,
		stack = true,
		close = true,
	},

	["bites_group_pack"] = {
		label = "THIGH BITES GROUP PACK",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["blacklightning"] = {
		label = "Black Lightning",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["blacktar"] = {
		label = "Black Tar Heroin",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["black_bag"] = {
		label = "Black Bag",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["black_card"] = {
		label = "Black Market Card",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["black_glass"] = {
		label = "Black Glass",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["black_hat"] = {
		label = "Black Hat",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["black_jeans"] = {
		label = "Black Jeans",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["black_phone"] = {
		label = "Black Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["black_vest"] = {
		label = "Black Vest",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["blindfold"] = {
		label = "Blindfold",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["blueberry_cruffin"] = {
		label = "Blueberry Cruffin",
		weight = 1,
		stack = true,
		close = true,
	},

	["blueberry_cruffin_joint"] = {
		label = "Blueberry Cruffin Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["blueberry_jam_cookie"] = {
		label = "Blueberry Jam Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["blueprintar"] = {
		label = "Blueprint AR",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["blueprintpistol"] = {
		label = "Blueprint Pistol",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["blueprintsmg"] = {
		label = "Blueprint SMG",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["bluewhale"] = {
		label = "Bluewhale",
		weight = 5,
		stack = true,
		close = true,
	},

	["blue_mist"] = {
		label = "Starbuzz Blue Mist",
		weight = 1,
		stack = true,
		close = true,
	},

	["blue_phone"] = {
		label = "Blue Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["blue_stone"] = {
		label = "Blue Stone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["blue_tomyz"] = {
		label = "Blue Tomyz",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["blue_tomyz_joint"] = {
		label = "Blue Tomyz Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["bodybandage"] = {
		label = "Body Bandage",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["boltcutter"] = {
		label = "Bolt Cutter",
		weight = 1,
		stack = true,
		close = true,
	},

	["boneless_meal_deal"] = {
		label = "Boneless Meal Deal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["boneless_wings"] = {
		label = "BONELESS WINGS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bong"] = {
		label = "bong",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["boostingtab"] = {
		label = "Boosting Tablet",
		weight = 1,
		stack = true,
		close = true,
	},

	["bottle"] = {
		label = "Bottle",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["bottle_diet_coke"] = {
		label = "20oz Bottle Diet Coke",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bourbon"] = {
		label = "Bourbon",
		weight = 1,
		stack = true,
		close = true,
	},

	["bracelet"] = {
		label = "Bracelet",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["brakes1"] = {
		label = "Brakes Lvl. 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["brakes2"] = {
		label = "Brakes Lvl. 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["brakes3"] = {
		label = "Brakes Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["brakes4"] = {
		label = "Brakes Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 0.1,
		stack = true,
		close = true,
		description = "\"Fill hunger\""
	},

	["breakfast_meal"] = {
		label = "Breakfast Meal",
		weight = 1,
		stack = true,
		close = true,
	},

	["brewed_iced_tea"] = {
		label = "Brewed Iced Tea",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["brinjal"] = {
		label = "Brinjal",
		weight = 1,
		stack = true,
		close = true,
	},

	["brokenlaptop"] = {
		label = "Broken Laptop",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["bronless_meal_deal"] = {
		label = "BONELESS MEAL DEAL",
		weight = 1,
		stack = true,
		close = true,
	},

	["brown_scramble_bowl"] = {
		label = "Brown Scramble Bowl",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["brown_scramble_burrito"] = {
		label = "Brown Scramble Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_barqs_beer"] = {
		label = "Medium Barqs Root Beer",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_cafe_decaf"] = {
		label = "Medium BK Cafe Decaf",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_chicken_jr"] = {
		label = "Chicken Jr.",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_coca_cola"] = {
		label = "Medium Coca-Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_diet_coke"] = {
		label = "Medium Diet Coke",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_dr_pepper"] = {
		label = "Medium Dr. Pepper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_fanta_orange"] = {
		label = "Medium Fanta Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_fruit_punch"] = {
		label = "Medium Hi-C Fruit Punch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_hamburger"] = {
		label = "Hamburger",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_iced_tea"] = {
		label = "Medium Sweetened Iced Tea",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_mozzarella_sticks"] = {
		label = "Mozzarella Sticks",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_orange_juice"] = {
		label = "Simply Orange Juice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_sprite"] = {
		label = "Medium Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_sprite_zero"] = {
		label = "Medium Sprite Zero",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bs_yello_mello"] = {
		label = "Medium Mello Yello",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["buffalo_chicken"] = {
		label = "Buffalo Chicken",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["buffalo_chicken_strips"] = {
		label = "Buffalo Chicken Strips",
		weight = 1,
		stack = true,
		close = true,
	},

	["buffalo_ranch_fries"] = {
		label = "BUFFALO RANCH FRIES",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bugdetector"] = {
		label = "Bug Detector",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["bull"] = {
		label = "Red Bull",
		weight = 0.075,
		stack = true,
		close = true,
	},

	["bulletproof"] = {
		label = "Bulletproof Vest",
		weight = 3,
		stack = true,
		close = true,
	},

	["buttered_biscuit"] = {
		label = "Buttered Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["buttermilk_biscuit"] = {
		label = "Fully Loaded Buttermilk",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["butter_cookie"] = {
		label = "Butter Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["c4_bomb"] = {
		label = "C4 Bomb",
		weight = 0.6,
		stack = true,
		close = true,
	},

	["cachaca"] = {
		label = "Cachaca",
		weight = 1,
		stack = true,
		close = true,
	},

	["cafe_bong"] = {
		label = "Cafe Bong",
		weight = 1,
		stack = true,
		close = true,
	},

	["caipirinha"] = {
		label = "Caipirinha",
		weight = 1,
		stack = true,
		close = true,
	},

	["cajun_fried_corn"] = {
		label = "CAJUN FRIED CORN",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cajun_fries"] = {
		label = "Regular Cajun Fries",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cake_mix"] = {
		label = "Cake Mix",
		weight = 1,
		stack = true,
		close = true,
	},

	["cake_mix_joint"] = {
		label = "Cake Mix Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cali_chicken_bacon"] = {
		label = "Cali Chicken Bacon",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cane_mint"] = {
		label = "Tangiers Cane Mint",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["cappuccino"] = {
		label = "Cappuccino",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cardholder"] = {
		label = "Card Holder",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["carkey"] = {
		label = "Car Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Carokit",
		weight = 2,
		stack = true,
		close = true,
		description = "Engine Fix"
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["carte_biscuit"] = {
		label = "",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["casino_earrings"] = {
		label = "Casino Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["catfish"] = {
		label = "Catfish",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["cereal_milk"] = {
		label = "Cereal Milk",
		weight = 1,
		stack = true,
		close = true,
	},

	["cereal_milk_joint"] = {
		label = "Cereal Milk Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain"] = {
		label = "Chain",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["chain_bracelet"] = {
		label = "Chain Bracelet",
		weight = 1,
		stack = true,
		close = true,
	},

	["chain_dogtag"] = {
		label = "Chain Dogtag",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_is"] = {
		label = "Chain IS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_ls"] = {
		label = "Chain LS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_m"] = {
		label = "Chain M",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_medal"] = {
		label = "Chain Medal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_richman"] = {
		label = "Chain Richman",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chain_triangle"] = {
		label = "Chain Triangle",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chalupa_supreme"] = {
		label = "Chalupa Supreme",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["champagne"] = {
		label = "Champagne",
		weight = 1,
		stack = true,
		close = true,
	},

	["cheap_lighter"] = {
		label = "Cheap Lighter",
		weight = 1,
		stack = true,
		close = true,
	},

	["cheesebows"] = {
		label = "Cheese Bows",
		weight = 1,
		stack = true,
		close = true,
	},

	["cheeseburger_combo_meal"] = {
		label = "Cheeseburger Combo Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheeseburger_king_jr"] = {
		label = "Cheeseburger King Jr Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheese_fries"] = {
		label = "CHEESE FRIES",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheese_quesadilla"] = {
		label = "Cheese Quesadilla",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheese_sauce"] = {
		label = "CHEESE SAUCE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheesy_black_bean"] = {
		label = "Cheesy Black Bean",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheesy_gordita_crunch"] = {
		label = "Cheesy Gordita Crunch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheesy_tots"] = {
		label = "Cheesy Tots",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cheetah_piss"] = {
		label = "Cheetah Piss",
		weight = 1,
		stack = true,
		close = true,
	},

	["cheetah_piss_joint"] = {
		label = "Cheetah Piss Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chemicals"] = {
		label = "Chemicals",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["chicken_and_waffles"] = {
		label = "Chicken & Waffles",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_bacon_ranch"] = {
		label = "Chicken Bacon Ranch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_biscuit"] = {
		label = "Chicken Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_bundle"] = {
		label = "0.20.2Pc Chicken Bundle",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_burrito"] = {
		label = "Chicken Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_caesar_salad"] = {
		label = "Chicken Caesar Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_carbonara"] = {
		label = "Chicken Carbonara",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_club_sandwich"] = {
		label = "Chicken Club Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_egg_cheese"] = {
		label = "Chicken, Egg & Cheese Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_family_meal"] = {
		label = "0.26Pc Chicken Family Meal Classic",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_fries"] = {
		label = "9 pc Chicken Fries",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_habanero"] = {
		label = "Chicken Habanero",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_mcnuggets"] = {
		label = "Chicken McNuggets",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_noodle_soup"] = {
		label = "Chicken Noodle Soup",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_nuggets"] = {
		label = "Chicken Nuggets",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_parm"] = {
		label = "Chicken Parm",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chicken_sandwich"] = {
		label = "Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chick_fil_a_lemonade"] = {
		label = "Chick-fil-A Lemonade",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chick_fil_a_nuggets"] = {
		label = "Chick-fil-A Nuggets",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chick_n_minis"] = {
		label = "Chick-n-Minis",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chick_n_strips"] = {
		label = "Chick-n-Strips",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chilled_premium_lemonade"] = {
		label = "Chilled Premium Lemonade",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chips"] = {
		label = "Chips",
		weight = 1,
		stack = true,
		close = true,
	},

	["chocolate_chunk_brownie"] = {
		label = "TRIPLE CHOCOLATE CHUNK BROWNIE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_chunk_cookie"] = {
		label = "Chocolate Chunk Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_cookie_shake"] = {
		label = "Chocolate OREO Cookie Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_fudge_brownie"] = {
		label = "Chocolate Fudge Brownie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_milk"] = {
		label = "Chocolate Milk",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_milkshake"] = {
		label = "Chocolate Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chocolate_shake"] = {
		label = "Chocolate Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["chopradio"] = {
		label = "Chop Radio",
		weight = 1,
		stack = true,
		close = true,
	},

	["churros_dip"] = {
		label = "Churros Dip",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cinnamon_apple_pie"] = {
		label = "Cinnamon Apple Pie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cinnamon_twists"] = {
		label = "Cinnamon Twists",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["classic_chicken_sandwich"] = {
		label = "Classic Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["classic_phone"] = {
		label = "Classic Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["classic_signature_chicken"] = {
		label = "Classic Signature Chicken",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["classic_wings_combo"] = {
		label = "CLASSIC WINGS COMBO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["club_soda"] = {
		label = "Club soda",
		weight = 1,
		stack = true,
		close = true,
	},

	["coals"] = {
		label = "Shisha Coals",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["cobb_salad"] = {
		label = "Cobb Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cocaine"] = {
		label = "Cocaine",
		weight = 0.08,
		stack = true,
		close = true,
	},

	["coca_cola"] = {
		label = "Coca-Cola",
		weight = 1,
		stack = true,
		close = true,
	},

	["coca_leaf"] = {
		label = "Coca Leaf",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["coconut_milk"] = {
		label = "Coconut milk",
		weight = 1,
		stack = true,
		close = true,
	},

	["codeine"] = {
		label = "Codeine",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["cointreau"] = {
		label = "Cointreau",
		weight = 1,
		stack = true,
		close = true,
	},

	["cokebrick"] = {
		label = "Coke Brick",
		weight = 3,
		stack = true,
		close = true,
	},

	["coke_pooch"] = {
		label = "Coke Pooch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["coke_rail"] = {
		label = "Coke Rail",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["cold_brew"] = {
		label = "COLD BREW",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["collins_ave"] = {
		label = "Collins AVE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["collins_ave_joint"] = {
		label = "Collins AVE Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["combo_chicken_mc"] = {
		label = "Combo Chicken McNuggets",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["condom"] = {
		label = "Condom",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["cookies_cream_milkshake"] = {
		label = "Cookies & Cream Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cookies_cream_milkshake."] = {
		label = "Cookies & Cream Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cookie_craze"] = {
		label = "Cookie Craze",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cookie_shake"] = {
		label = "OREO Cookie Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cool_wrap"] = {
		label = "Cool Wrap",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 0.2,
		stack = true,
		close = true,
		description = "\"used in crafting\""
	},

	["cosmopolitan"] = {
		label = "Cosmopolitan",
		weight = 1,
		stack = true,
		close = true,
	},

	["covgari_gold"] = {
		label = "Covgari Gold",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crab"] = {
		label = "crab",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crab_cakes"] = {
		label = "Crab Cakes",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crab_legs_meal"] = {
		label = "Crab Legs Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crab_packed"] = {
		label = "crab packed",
		weight = 0.7,
		stack = true,
		close = true,
	},

	["crack"] = {
		label = "Crack",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crack_pooch"] = {
		label = "Crack Pooch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cranberry_juice"] = {
		label = "Cranberry juice",
		weight = 1,
		stack = true,
		close = true,
	},

	["crispy_chicken_sandwich"] = {
		label = "Crispy Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crispy_chicken_staco"] = {
		label = "Crispy Chicken Soft Taco",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crispy_tenders"] = {
		label = "8 PC MEAL FOR 2 CRISPY TENDERS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crispy_tender_combo"] = {
		label = "LARGE 5 PC CRISPY TENDER COMBO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["croissant"] = {
		label = "Croissant",
		weight = 1,
		stack = true,
		close = true,
	},

	["croissanwich_meal"] = {
		label = "Sausage, Egg & Cheese Small",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crowex_black"] = {
		label = "Crowex Black",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crowex_brown"] = {
		label = "Crowex Brown",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crunchwrap_supreme"] = {
		label = "Crunchwrap Supreme",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crunchwrap_supreme_meal"] = {
		label = "Crunchwrap Supreme Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crunchytaco"] = {
		label = "Crunchy Taco",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["crunchy_taco_supreme"] = {
		label = "Crunchy Taco Supreme",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["cuba_libre"] = {
		label = "Cuba Libre",
		weight = 1,
		stack = true,
		close = true,
	},

	["cucumber"] = {
		label = "Cucumber",
		weight = 1,
		stack = true,
		close = true,
	},

	["cuff"] = {
		label = "Handcuffs",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["curacao"] = {
		label = "Orange Curacao liqeur",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 5,
		stack = true,
		close = true,
	},

	["dab"] = {
		label = "DAB",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["darkplat_earrings"] = {
		label = "Darkplat Earrings",
		weight = 1,
		stack = true,
		close = true,
	},

	["dark_rum"] = {
		label = "Dark rum",
		weight = 1,
		stack = true,
		close = true,
	},

	["deluxe_chicken_sandwich"] = {
		label = "Ch King Deluxe Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["deluxe_crispy_sandwich_combo"] = {
		label = "Deluxe Crispy Sandwich Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["deluxe_sandwich"] = {
		label = "Deluxe Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["detector"] = {
		label = "Detector",
		weight = 1,
		stack = true,
		close = true,
	},

	["diagold_earrings"] = {
		label = "Diagold Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dianecklace"] = {
		label = "Dia Necklace",
		weight = 1,
		stack = true,
		close = true,
	},

	["diaplatinum_earrings"] = {
		label = "Diaplatinum Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dia_box"] = {
		label = "Diamond Box",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["diet_coke"] = {
		label = "Diet Coke",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["diet_pepsi"] = {
		label = "Diet Pepsi",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["dirty_bottle"] = {
		label = "Dirty Bottle",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["doghouse"] = {
		label = "Doghouse",
		weight = 1,
		stack = true,
		close = true,
	},

	["dom_perignon"] = {
		label = "Dom Perignon",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["donut"] = {
		label = "Donut",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["donuts"] = {
		label = "Donuts",
		weight = 1,
		stack = true,
		close = true,
	},

	["double_apple"] = {
		label = "Nakhla Double Apple",
		weight = 1,
		stack = true,
		close = true,
	},

	["double_cheeseburger"] = {
		label = "Double Cheeseburger",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["double_cup"] = {
		label = "Double cup",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["double_quarter_combo"] = {
		label = "Double Quarter Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["double_quarter_pounder"] = {
		label = "Double Quarter Pounder",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["double_sausage_biscuit"] = {
		label = "Double Sausage, Egg, & Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["double_sausage_croissanwich"] = {
		label = "Double Sausage, Egg, & Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["drill"] = {
		label = "Drill",
		weight = 6,
		stack = true,
		close = true,
	},

	["drone_flyer_1"] = {
		label = "Basic Drone 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_2"] = {
		label = "Basic Drone 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_3"] = {
		label = "Basic Drone 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_4"] = {
		label = "Advanced Drone 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_5"] = {
		label = "Advanced Drone 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_6"] = {
		label = "Advanced Drone 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["drone_flyer_7"] = {
		label = "Police Drone",
		weight = 1,
		stack = true,
		close = true,
	},

	["drpepper"] = {
		label = "Drpepper",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["dr_pepper"] = {
		label = "Dr Pepper",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["dslr"] = {
		label = "DSLR",
		weight = 1,
		stack = true,
		close = true,
		description = "\"say chesse \""
	},

	["dunkin_americano"] = {
		label = "AMERICANO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_bacon_egg_cheese"] = {
		label = "BACON, EGG & CHEESE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_coffee"] = {
		label = "COFFEE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_croissant"] = {
		label = "CROISSANT",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_donuts"] = {
		label = "DONUTS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_hash_browns"] = {
		label = "HASH BROWNS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_latte"] = {
		label = "LATTE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_macchiato"] = {
		label = "MACCHIATO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_muffins"] = {
		label = "MUFFINS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_refresher"] = {
		label = "DUNKIN REFRESHERS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dunkin_tea"] = {
		label = "TEA",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["dzikie"] = {
		label = "Dzikie",
		weight = 1,
		stack = true,
		close = true,
	},

	["d_coca_cola"] = {
		label = "Coca Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["d_dr_pepper"] = {
		label = "Dr Pepper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["d_fanta_orange"] = {
		label = "Fanta Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["d_fruit_punch"] = {
		label = "Fruit Punch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["d_sprite"] = {
		label = "Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["earring"] = {
		label = "Earring",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["earrings_sgold"] = {
		label = "Earrings SGold",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["egg_cheese_biscuit"] = {
		label = "Egg Cheese Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["egg_cheese_muffin"] = {
		label = "Egg & Cheese Muffin",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["egg_mcmuffin"] = {
		label = "Egg McMuffin",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["egg_normous_burrito"] = {
		label = "Egg Normous Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["egg_white_grill"] = {
		label = "Egg White Grill",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["el_patron"] = {
		label = "Chaos El Patron",
		weight = 1,
		stack = true,
		close = true,
	},

	["energy"] = {
		label = "Energy",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["engine1"] = {
		label = "Engine Lvl. 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["engine2"] = {
		label = "Engine Lvl. 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["engine3"] = {
		label = "Engine Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["engine4"] = {
		label = "Engine Lvl. 4",
		weight = 1,
		stack = true,
		close = true,
	},

	["engine5"] = {
		label = "Engine Lvl. 4",
		weight = 1,
		stack = true,
		close = true,
	},

	["english_muffin"] = {
		label = "English Muffin",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ergot"] = {
		label = "Ergot",
		weight = 0.12,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["ether"] = {
		label = "Ether",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ether_joint"] = {
		label = "Ether Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["evidencebox"] = {
		label = "Evidence Box",
		weight = 1,
		stack = true,
		close = true,
	},

	["extra_vagan_zza"] = {
		label = "Extra Vagan ZZa",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["family_bundle_classic"] = {
		label = "Family Bundle Classic",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fanta"] = {
		label = "Fanta",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["fentanyl_pill"] = {
		label = "Fentanyl Pill",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["fentanyl_pills"] = {
		label = "Fentanyl Pills",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["fine_china"] = {
		label = "Fine China",
		weight = 1,
		stack = true,
		close = true,
	},

	["fine_china_joint"] = {
		label = "Fine China Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["fireworks"] = {
		label = "Fireworks",
		weight = 1,
		stack = true,
		close = true,
	},

	["firstaid"] = {
		label = "First Aid",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["fishcooler"] = {
		label = "Fish Cooler",
		weight = 10,
		stack = true,
		close = true,
	},

	["fishtaco"] = {
		label = "Fish Taco",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fitbit"] = {
		label = "Fitbit",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Fix Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Fix Tool",
		weight = 1,
		stack = true,
		close = true,
		description = "\"Fix Vehicle\""
	},

	["flakka"] = {
		label = "Flakka",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["flakka_joint"] = {
		label = "Flakka Joint",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["foil"] = {
		label = "Foil Paper",
		weight = 1,
		stack = true,
		close = true,
	},

	["foil_poked"] = {
		label = "Foil Poked",
		weight = 1,
		stack = true,
		close = true,
	},

	["foil_poker"] = {
		label = "Foil Poker",
		weight = 1,
		stack = true,
		close = true,
	},

	["french_toast_sticks"] = {
		label = "3 French Toast Sticks",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fresh_baked_rolls"] = {
		label = "FRESH BAKED ROLLS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fresh_mix"] = {
		label = "Fresh sour mix",
		weight = 1,
		stack = true,
		close = true,
	},

	["fried_calamari"] = {
		label = "Fried Calamari",
		weight = 1,
		stack = true,
		close = true,
	},

	["fried_mushrooms"] = {
		label = "Fried Mushrooms",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fried_scallops"] = {
		label = "Fried Scallops",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fries"] = {
		label = "Fries",
		weight = 1,
		stack = true,
		close = true,
	},

	["fries_grande"] = {
		label = "Fries Grande",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["frisbee"] = {
		label = "Frisbee",
		weight = 1,
		stack = true,
		close = true,
	},

	["frosted_coffee"] = {
		label = "Frosted Coffee",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["frosted_lemonade"] = {
		label = "Frosted Lemonade",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["froties"] = {
		label = "Froties",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["froties_joint"] = {
		label = "Froties Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["fruit_cup"] = {
		label = "Fruit Cup",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spraycan"] = {
		label = "Gang Spray",
		weight = 1,
		stack = true,
		close = true,
	},

	["garlic_parm_wings"] = {
		label = "Garlic Parm Wings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gary_payton"] = {
		label = "Gary Payton",
		weight = 1,
		stack = true,
		close = true,
	},

	["gary_payton_joint"] = {
		label = "Gary Payton Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["gasmask"] = {
		label = "Gas Mask",
		weight = 1,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gelatti"] = {
		label = "Gelatti",
		weight = 1,
		stack = true,
		close = true,
	},

	["gelatti_joint"] = {
		label = "Gelatti Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["gem"] = {
		label = "Gem",
		weight = 1,
		stack = true,
		close = true,
	},

	["georgia_pie"] = {
		label = "Georgia Pie",
		weight = 1,
		stack = true,
		close = true,
	},

	["georgia_pie_joint"] = {
		label = "Georgia Pie Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["get_figgy"] = {
		label = "Get Figgy",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["glass_cutter"] = {
		label = "Glass Cutter",
		weight = 7,
		stack = true,
		close = true,
	},

	["glazed_salmon"] = {
		label = "Glazed Salmon",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gmo_cookies"] = {
		label = "GMO Cookies",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gmo_cookies_joint"] = {
		label = "GMO Cookies Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["goldak_earrings"] = {
		label = "GoldAK Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["goldfish"] = {
		label = "Goldfish",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["goldhex_earrings"] = {
		label = "GoldHex Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["goldrolex"] = {
		label = "Gold Rolex",
		weight = 1,
		stack = true,
		close = true,
	},

	["goldstone_earrings"] = {
		label = "Goldstone Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gold_bar"] = {
		label = "Gold Bar",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gold_lux"] = {
		label = "Gold Lux",
		weight = 1,
		stack = true,
		close = true,
	},

	["gold_phone"] = {
		label = "Gold Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["gold_rum"] = {
		label = "Gold rum",
		weight = 1,
		stack = true,
		close = true,
	},

	["gourmet_double_burger"] = {
		label = "Gourmet Double Burger",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["gpstracker"] = {
		label = "GPS Tracker",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["grabba_leaf"] = {
		label = "Grabba Leaf",
		weight = 1,
		stack = true,
		close = true,
	},

	["grabba_leaf_joint"] = {
		label = "Grabba Leaf Joint",
		weight = 0.05,
		stack = true,
		close = true,
	},

	["grand_cru"] = {
		label = "Grand Cru",
		weight = 1,
		stack = true,
		close = true,
	},

	["grapes"] = {
		label = "Grapes",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["grapplegun"] = {
		label = "Grapple Gun",
		weight = 1,
		stack = true,
		close = true,
	},

	["greek_yogurt_parfait"] = {
		label = "Greek Yogurt Parfait",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["greek_yogurt_parfait."] = {
		label = "Greek Yogurt Parfait",
		weight = 1,
		stack = true,
		close = true,
	},

	["greenlight_phone"] = {
		label = "Green Light Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["green_phone"] = {
		label = "Green Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["green_stone"] = {
		label = "Green Stone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["grilled_nuggets"] = {
		label = "Grilled Nuggets",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["group_pack"] = {
		label = "WINGS & THIGH BITES GROUP PACK",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["guidebook"] = {
		label = "Guide Book",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["gummi_bear"] = {
		label = "Fumari White Gummi Bear",
		weight = 1,
		stack = true,
		close = true,
	},

	["gunpowder"] = {
		label = "Gun Powder",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["hackingtab"] = {
		label = "Hacking Tablet",
		weight = 1,
		stack = true,
		close = true,
	},

	["hacking_laptop"] = {
		label = "Hacking Laptop",
		weight = 2.5,
		stack = true,
		close = true,
	},

	["hack_card"] = {
		label = "Hacking Card",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["hack_laptop"] = {
		label = "Hacking Laptop",
		weight = 2.5,
		stack = true,
		close = true,
	},

	["hack_phone"] = {
		label = "Hacking Phone",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["hack_usb"] = {
		label = "Hacking USB",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["hamburger"] = {
		label = "Hamburger",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["hamburger_king_jr"] = {
		label = "Hamburger King Jr. Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ham_egg_cheese"] = {
		label = "Ham, Egg, & Cheese CroissanWich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hash_browns"] = {
		label = "Hash Browns",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["heartstopper"] = {
		label = "Heartstopper",
		weight = 1,
		stack = true,
		close = true,
	},

	["hemo"] = {
		label = "Hemo",
		weight = 1,
		stack = true,
		close = true,
	},

	["hennessy_shot"] = {
		label = "Hennessy Shot",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["heroin"] = {
		label = "Heroin",
		weight = 0.08,
		stack = true,
		close = true,
	},

	["heroinbrick"] = {
		label = "Heroin Brick",
		weight = 5,
		stack = true,
		close = true,
	},

	["heroin_shot"] = {
		label = "Heroin Shot",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hex4you_earrings"] = {
		label = "Hex4You Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hexdia_earrings"] = {
		label = "HexDia Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hex_gold"] = {
		label = "Hex Gold",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["homestyle_mac_cheese"] = {
		label = "Regular Homestyle Mac & Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["honolulu_hawaiian"] = {
		label = "Honolulu Hawaiian",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hose"] = {
		label = "Shisha Hose",
		weight = 1,
		stack = true,
		close = true,
	},

	["hotdog"] = {
		label = "Hotdog",
		weight = 0.45,
		stack = true,
		close = true,
	},

	["hot_chicken_wrap"] = {
		label = "Hot Chicken Wrap",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hot_chocolate"] = {
		label = "Hot Chocolate",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hot_coals"] = {
		label = "Hot Coals",
		weight = 1,
		stack = true,
		close = true,
	},

	["hot_fudge_sundae"] = {
		label = "Hot Fudge Sundae",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["hundred_wings"] = {
		label = "0.200 WINGS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["icedream_cone"] = {
		label = "Icedream Cone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["icedream_cup"] = {
		label = "Icedream Cup",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["iced_cappuccino"] = {
		label = "ICED CAPPUCCINO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["iced_coffee"] = {
		label = "Iced Coffee",
		weight = 1,
		stack = true,
		close = true,
	},

	["iced_macchiatto"] = {
		label = "ICED MACCHIATO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["iced_matcha_latte"] = {
		label = "ICED MATCHA LATTE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["iced_signaturea_latte"] = {
		label = "ICED SIGNATURE LATTE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ice_cola"] = {
		label = "Ice Cola",
		weight = 1,
		stack = true,
		close = true,
	},

	["ice_cream"] = {
		label = "Ice Cream",
		weight = 1,
		stack = true,
		close = true,
	},

	["ice_cream_cake_pack"] = {
		label = "Ice Cream Cake Pack",
		weight = 1,
		stack = true,
		close = true,
	},

	["ice_cream_cake_pack_joint"] = {
		label = "Ice Cream Cake Pack Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["italian_sandwich"] = {
		label = "Italian Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["italian_sausage_marinara"] = {
		label = "Italian Sausage Marinara",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["jailfood"] = {
		label = "Jail food",
		weight = 1,
		stack = true,
		close = true,
	},

	["jail_acid"] = {
		label = "Acid",
		weight = 1,
		stack = true,
		close = true,
	},

	["jail_bCloth"] = {
		label = "Broken Spoon With Wet Cloth",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_bLadle"] = {
		label = "Broken Ladle",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_booze"] = {
		label = "Booze",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_bottle"] = {
		label = "Bottle",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_cleaner"] = {
		label = "Cleaner",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_cloth"] = {
		label = "Cloth",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_dLiquid"] = {
		label = "Dirty Liquid",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_file"] = {
		label = "File",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_fPacket"] = {
		label = "Flavor Packet",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_grease"] = {
		label = "Grease",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_iHeat"] = {
		label = "Immersion Heater",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_jspoon"] = {
		label = "Broken Spoon",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_ladle"] = {
		label = "Ladle",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_metal"] = {
		label = "Metal",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_miniH"] = {
		label = "Mini Hammer",
		weight = 5,
		stack = true,
		close = true,
	},

	["jail_plug"] = {
		label = "Plug",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_pPunch"] = {
		label = "Prison Punch",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_rock"] = {
		label = "Rock",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_sChange"] = {
		label = "Spare Change",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_shank"] = {
		label = "Shank",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_sMetal"] = {
		label = "Sharp Metal",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_spoon"] = {
		label = "Spoon",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jail_wCloth"] = {
		label = "Wet Cloth",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["jalapeno_cheddar_bites"] = {
		label = "Jalapeno Cheddar Bites",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["jefe"] = {
		label = "Jefe",
		weight = 1,
		stack = true,
		close = true,
	},

	["jefe_joint"] = {
		label = "Jefe Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["jolly_candy"] = {
		label = "Jolly Candy",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["jusfruit"] = {
		label = "Jusfruit",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["kale_crunch_side"] = {
		label = "Kale Crunch Side",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["karaoke_earrings"] = {
		label = "Karaoke Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ketamine"] = {
		label = "Ketamine",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["key"] = {
		label = "Key",
		weight = 0.2,
		stack = true,
		close = true,
		description = "\"free me\""
	},

	["keyholder"] = {
		label = "Key Holder",
		weight = 2,
		stack = true,
		close = true,
	},

	["key_chemicallab"] = {
		label = "Chemical Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_cokelab"] = {
		label = "Coke Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_cracklab"] = {
		label = "Crack Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_ergotlab"] = {
		label = "Ergot Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_heroinlab"] = {
		label = "Heroin Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_illegalpharmacy"] = {
		label = "Illegal Pharmacy Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_lime_cookie"] = {
		label = "Key Lime Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["key_lsdlab"] = {
		label = "LSD Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_marijuanafarm"] = {
		label = "Marijuana Farm Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_methlab"] = {
		label = "Meth Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_opiumlab"] = {
		label = "Opium Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_perclab"] = {
		label = "Perc Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_spicelab"] = {
		label = "Spice Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["key_weedlab"] = {
		label = "Weed Lab Key",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["khalifa_kush"] = {
		label = "Khalifa Kush",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["khalifa_kush_joint"] = {
		label = "Khalifa Kush Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["korean_q_wings"] = {
		label = "Korean Q Wings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["kronos_black"] = {
		label = "Kronos Black",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["kronos_gold"] = {
		label = "Kronos Gold",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["largemouthbass"] = {
		label = "Largemouth Bass",
		weight = 1,
		stack = true,
		close = true,
	},

	["large_thigh_bites"] = {
		label = "LARGE THIGH BITES",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["latte"] = {
		label = "Latte",
		weight = 1,
		stack = true,
		close = true,
	},

	["laundrycard"] = {
		label = "Laundry Card",
		weight = 1,
		stack = true,
		close = true,
	},

	["lays"] = {
		label = "Lays",
		weight = 1,
		stack = true,
		close = true,
	},

	["la_confidential"] = {
		label = "LA Confidential",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["la_confidential_joint"] = {
		label = "LA Confidential Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["lead"] = {
		label = "Lead",
		weight = 1,
		stack = true,
		close = true,
	},

	["lead_ball"] = {
		label = "Lead Ball",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["lean"] = {
		label = "Lean",
		weight = 0.35,
		stack = true,
		close = true,
	},

	["legbrace"] = {
		label = "Leg Brace",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["levonorgestrel"] = {
		label = "Levonorgestrel",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_ar"] = {
		label = "AR LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_bike"] = {
		label = "BIKE LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_car"] = {
		label = "CAR LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_pistol"] = {
		label = "PISTOL LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_shotgun"] = {
		label = "SHOTGUN LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_smg"] = {
		label = "SMG LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["license_truck"] = {
		label = "TRUCK LICENSE",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["light_rum"] = {
		label = "Light rum",
		weight = 1,
		stack = true,
		close = true,
	},

	["lime"] = {
		label = "Lime",
		weight = 1,
		stack = true,
		close = true,
	},

	["limeade"] = {
		label = "Limeadge",
		weight = 1,
		stack = true,
		close = true,
	},

	["limonade"] = {
		label = "Limonade",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["loaded_croissanwich_meal"] = {
		label = "Bacon, Sausage & Ham Meal Small",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["lobster_bisque"] = {
		label = "Lobster Bisque",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["lofexidine"] = {
		label = "Lofexidine",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["louisiana_voodoo_fries"] = {
		label = "LOUISIANA VOODOO FRIES",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["lsd"] = {
		label = "LSD",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["lucas3"] = {
		label = "Lucas 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["mac_cheese"] = {
		label = "Mac & Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mac_cheese_meal"] = {
		label = "Mac & Cheese Kids Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mai_tai"] = {
		label = "Mai Tai",
		weight = 1,
		stack = true,
		close = true,
	},

	["marathon"] = {
		label = "Marathon",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["marathon_joint"] = {
		label = "Marathon Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["margarita"] = {
		label = "Margarita",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["weed_tree"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["male_seed"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},


	["female_seed"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},


	["market_salad"] = {
		label = "Market Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["marshmallow_crisp"] = {
		label = "Marshmallow Crisp",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["marshmallow_og"] = {
		label = "Marshmallow OG",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["marshmallow_og_joint"] = {
		label = "Marshmallow OG Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["mashed_potatoes"] = {
		label = "Regular Mashed Potatoes with Cajun Gravy",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_cappuccino"] = {
		label = "Cappuccino",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_coca_cola"] = {
		label = "Coca Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_combo_chicken"] = {
		label = "Combo Chicken",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_diet_coke"] = {
		label = "Diet Coke",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_dr_pepper"] = {
		label = "Dr Pepper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_fanta_orange"] = {
		label = "Fanta Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_flurry_candies"] = {
		label = "McFlurry Candies",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_flurry_cookies"] = {
		label = "McFlurry Cookies",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_fruit_punch"] = {
		label = "Fruit Punch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_hot_chocolate"] = {
		label = "Hot Chocolate",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_iced_coffee"] = {
		label = "Iced Coffee",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_iced_tea"] = {
		label = "Iced Tea",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_nuggets_happy_meal"] = {
		label = "McNuggets Happy Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_sprite"] = {
		label = "Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_strawberry_shake"] = {
		label = "Strawberry Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mc_vanilla_shake"] = {
		label = "Vanilla Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["md_ginger_ale"] = {
		label = "MD Ginger Ale",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["md_seltzer_water"] = {
		label = "MD Seltzer Water",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["meal_for_two"] = {
		label = "0.25PC MEAL FOR 2",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["meatball"] = {
		label = "Meatball",
		weight = 1,
		stack = true,
		close = true,
	},

	["meat_zza"] = {
		label = "Meat ZZa",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medicalbag"] = {
		label = "Medical Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["medicinebox"] = {
		label = "Medicine Box",
		weight = 1,
		stack = true,
		close = true,
	},

	["mediterranean_veggie"] = {
		label = "Mediterranean Veggie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_coca_cola"] = {
		label = "Medium Coca-Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_diet_coke"] = {
		label = "Medium Diet Coke",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_fanta_orange"] = {
		label = "Medium Fanta Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_fanta_strawberry"] = {
		label = "Medium Fanta Strawberry",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_hawaiian_punch"] = {
		label = "Medium Hawaiian Punch",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_sprite"] = {
		label = "Medium Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_sweet_tea"] = {
		label = "Medium Sweet Tea",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["medium_tropicana_lemonade"] = {
		label = "Medium Tropicana Lemonade",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["melon_soda"] = {
		label = "Melon Soda",
		weight = 1,
		stack = true,
		close = true,
	},

	["memphis_bbq_chicken"] = {
		label = "Memphis BBQ Chicken",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["meth"] = {
		label = "Meth",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["methbrick"] = {
		label = "Meth Brick",
		weight = 1,
		stack = true,
		close = true,
	},

	["methlab"] = {
		label = "Methlab",
		weight = 1,
		stack = true,
		close = true,
	},

	["meth_pooch"] = {
		label = "Meth Pooch",
		weight = 1,
		stack = true,
		close = true,
	},

	["meth_raw"] = {
		label = "Meth Raw",
		weight = 0.012,
		stack = true,
		close = true,
	},

	["meth_shot"] = {
		label = "Meth Shot",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["microwave"] = {
		label = "Microwave",
		weight = 1,
		stack = true,
		close = true,
	},

	["mifepristone"] = {
		label = "Mifepristone",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["mild_tenders_box"] = {
		label = "0.20Pc Mild Tenders Box",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mild_tenders_bundle"] = {
		label = "0.20Pc Mild Tenders Bundle",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["milkshake"] = {
		label = "Milkshake",
		weight = 1,
		stack = true,
		close = true,
	},

	["mimosa"] = {
		label = "Mimosa",
		weight = 1,
		stack = true,
		close = true,
	},

	["mint"] = {
		label = "Mint",
		weight = 1,
		stack = true,
		close = true,
	},

	["mint_julep"] = {
		label = "Mint Julep",
		weight = 1,
		stack = true,
		close = true,
	},

	["mofo_fantasia"] = {
		label = "Adios Mofo Fantasia",
		weight = 1,
		stack = true,
		close = true,
	},

	["mojito"] = {
		label = "Mojito",
		weight = 1,
		stack = true,
		close = true,
	},

	["molly"] = {
		label = "Molly",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["molly_pooch"] = {
		label = "Molly Pooch",
		weight = 1,
		stack = true,
		close = true,
	},

	["molly_tablet"] = {
		label = "Molly Tablet",
		weight = 0.05,
		stack = true,
		close = true,
	},

	["moneyshot"] = {
		label = "Moneyshot",
		weight = 1,
		stack = true,
		close = true,
	},

	["monkey_mask"] = {
		label = "Monkey Mask",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["moon_rock"] = {
		label = "Moon Rock",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["moon_rock_joint"] = {
		label = "Moon Rock Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["morphine10"] = {
		label = "Morphine 10mg",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["mozzarella_sticks"] = {
		label = "Mozzarella Sticks",
		weight = 1,
		stack = true,
		close = true,
	},

	["munchkins_donut_hole"] = {
		label = "MUNCHKINS DONUT HOLE TREATS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["neckbrace"] = {
		label = "Neck Brace",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["necklace"] = {
		label = "Necklace",
		weight = 1,
		stack = true,
		close = true,
	},

	["necklace_dogtag"] = {
		label = "Necklace Dogtag",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["necklace_family"] = {
		label = "Necklace Family",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nitro"] = {
		label = "Nitro",
		weight = 30,
		stack = true,
		close = true,
	},

	["notepaper"] = {
		label = "Note Paper",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["no_99"] = {
		label = "NO 99",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nuggets_kids_meal"] = {
		label = "6Pc Nuggets Kids Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nuggets_king_jr"] = {
		label = "Chicken Nuggets King Jr Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nuggets_la_carte"] = {
		label = "48Pc Nuggets A la Carte",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nuggets_medium_combo"] = {
		label = "Nuggets Medium Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["nuts"] = {
		label = "Nuts",
		weight = 1,
		stack = true,
		close = true,
	},

	["omlet"] = {
		label = "Omlet",
		weight = 1,
		stack = true,
		close = true,
	},

	["opium"] = {
		label = "Opium",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["opium_joint"] = {
		label = "Opium Joint",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["opium_pooch"] = {
		label = "Opium Pooch",
		weight = 1,
		stack = true,
		close = true,
	},

	["orangeade"] = {
		label = "Orangeade",
		weight = 1,
		stack = true,
		close = true,
	},

	["orange_juice"] = {
		label = "Orange Juice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["oreoz"] = {
		label = "Oreoz",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["oreoz_joint"] = {
		label = "Oreoz Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["original_chicken_sandwich"] = {
		label = "Original Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["original_hot_wings"] = {
		label = "Original Hot Wings",
		weight = 1,
		stack = true,
		close = true,
	},

	["oxycodone"] = {
		label = "Oxycodone",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["oysters_half_shell"] = {
		label = "Oysters On the Half Shell",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pacific_veggie"] = {
		label = "Pacific Veggie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["packaged_coffee"] = {
		label = "PACKAGED COFFEE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_tea"] = {
		label = "PACKAGED TEA",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["paintingf"] = {
		label = "Paintin GF",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["paintingfa"] = {
		label = "Painting FA",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["paintingg"] = {
		label = "Paintin GG",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["paintingh"] = {
		label = "Painting H",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["paintingj"] = {
		label = "Painting J",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["paintingv"] = {
		label = "Painting V",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pancake_sausage_platter"] = {
		label = "Pancake & Sausage Platter",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pant"] = {
		label = "Pant",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["paracetamol"] = {
		label = "Paracetamol 500mg",
		weight = 1,
		stack = true,
		close = true,
	},

	["paris_fog"] = {
		label = "Paris Fog",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["party_pack"] = {
		label = "50PC PARTY PACK",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pasta_primavera"] = {
		label = "Pasta Primavera",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["patron_margarita"] = {
		label = "Patron Margarita",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["paxton_pearl_cigars"] = {
		label = "Paxton Pearl Cigars",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["peach_milkshake"] = {
		label = "Peach Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pearl"] = {
		label = "Pearl",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pearls_coffee"] = {
		label = "Pearls Coffee",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pendulus_platinum"] = {
		label = "Pendulus Platinum",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["peppermint_shake"] = {
		label = "Trifecta Blonde Peppermint Shake",
		weight = 1,
		stack = true,
		close = true,
	},

	["pepsi_max"] = {
		label = "Pepsi Max",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["perc"] = {
		label = "Perc",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["perc_pooch"] = {
		label = "Perc Pooch",
		weight = 0.15,
		stack = true,
		close = true,
	},

	["petfood"] = {
		label = "Petfood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 10,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 20,
		stack = true,
		close = true,
	},

	["philly_cheese_sandwich"] = {
		label = "Philly Cheese Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["philly_cheese_steak"] = {
		label = "Philly Cheese Steak",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["phone_hack"] = {
		label = "Phone Hack",
		weight = 1,
		stack = true,
		close = true,
	},

	["phone_module"] = {
		label = "Phone Module",
		weight = 1,
		stack = true,
		close = true,
	},

	["photo"] = {
		label = "Photo",
		weight = 0.01,
		stack = true,
		close = true,
		description = "\"memories\""
	},

	["pina_colada"] = {
		label = "Pina Colada",
		weight = 1,
		stack = true,
		close = true,
	},

	["pineapple_juice"] = {
		label = "Pineapple juice",
		weight = 1,
		stack = true,
		close = true,
	},

	["pink_lemonade"] = {
		label = "Medium Hi-C Pink Lemonade",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pink_phone"] = {
		label = "Pink Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["pink_sandy"] = {
		label = "Pink Sandy",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pink_sandy_joint"] = {
		label = "Pink Sandy Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pirckly_pear"] = {
		label = "Pirckly Pear",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pirckly_pear_joint"] = {
		label = "Pirckly Pear Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pistol_ammo_case"] = {
		label = "Pistol Ammo Case",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["pistol_bullet"] = {
		label = "Pistol Bullet",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["pizza_deluxe"] = {
		label = "Pizza Deluxe",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["plain_iced_coffee"] = {
		label = "Plain Iced Coffee Medium",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["plastic_wrap"] = {
		label = "Plastic Wrap",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["platbox_earrings"] = {
		label = "Platbox Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["platinum_bar"] = {
		label = "Platinum Bar",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pogo"] = {
		label = "Pogo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["police_card"] = {
		label = "POLICE CARD",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["pomegranate_mimosa"] = {
		label = "Pomegranate Mimosa",
		weight = 1,
		stack = true,
		close = true,
	},

	["pooch_bag"] = {
		label = "Pooch Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["popcorn_shrimp"] = {
		label = "0.2/4 Popcorn Shrimp Medium Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["poppy_tears"] = {
		label = "Poppy Tears",
		weight = 0.05,
		stack = true,
		close = true,
	},

	["powerbank"] = {
		label = "Power Bank",
		weight = 1,
		stack = true,
		close = true,
	},

	["pressed_grapes"] = {
		label = "Pressed Grapes",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["ps_coca_cola"] = {
		label = "Coca Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ps_dr_pepper"] = {
		label = "Dr Pepper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ps_sprite"] = {
		label = "Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["pumpkin_cookie"] = {
		label = "Pumpkin Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["p_chicken_alfredo"] = {
		label = "Chicken Alfredo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["quarter_pounder"] = {
		label = "Quarter Pounder",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["quarter_pounder_cheese"] = {
		label = "Quarter Pounder Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["quesadilla"] = {
		label = "Quesadilla",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["quesadilla_cravings"] = {
		label = "Quesadilla Cravings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ramen"] = {
		label = "Ramen",
		weight = 1,
		stack = true,
		close = true,
	},

	["raw_cone_king"] = {
		label = "Raw Cone King",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["rectdia_earrings"] = {
		label = "RectDia Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["redfish"] = {
		label = "Redfish",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["red_beans_rice"] = {
		label = "Regular Red Beans & Rice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["red_phone"] = {
		label = "Red Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["red_stone"] = {
		label = "Red Stone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["red_wine_sangria"] = {
		label = "Red Wine Sangria",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["regular_cajun_rice"] = {
		label = "Regular Cajun Rice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["regular_coleslaw"] = {
		label = "Regular Coleslaw",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["remote"] = {
		label = "remote",
		weight = 0.6,
		stack = true,
		close = true,
	},

	["repair_tool"] = {
		label = "Repair Tool",
		weight = 2,
		stack = true,
		close = true,
		description = "\"Used to repair weapon\""
	},

	["rice"] = {
		label = "Rice",
		weight = 1,
		stack = true,
		close = true,
	},

	["rifle_ammo_case"] = {
		label = "Rifle Ammo Case",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["rifle_bullet"] = {
		label = "Rifle Bullet",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["rodeo_burger"] = {
		label = "Rodeo Burger",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["rolex"] = {
		label = "Rolex",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["rope"] = {
		label = "Rope",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["roseymary_gin_fizz"] = {
		label = "Roseymary Gin Fizz",
		weight = 1,
		stack = true,
		close = true,
	},

	["rose_wine"] = {
		label = "Rose Wine",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["royal_milk_tea"] = {
		label = "Royal Milk Tea",
		weight = 1,
		stack = true,
		close = true,
	},

	["runtz_og"] = {
		label = "Runtz OG",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["runtz_og_joint"] = {
		label = "Runtz OG Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["rustedrod"] = {
		label = "Rusted Rod",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["rustygun"] = {
		label = "Rusty Gun",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["saline"] = {
		label = "Saline",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["salmon_caesar_salad"] = {
		label = "Salmon Caesar Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sausage_biscuit"] = {
		label = "Sausage Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sausage_burrito"] = {
		label = "Sausage Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sausage_croissanwich"] = {
		label = "Sausage, Egg, & Cheese CroissanWich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sausage_egg_cheese"] = {
		label = "Sausage, Egg & Cheese Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["scissors"] = {
		label = "Scissors",
		weight = 1,
		stack = true,
		close = true,
	},

	["scrape_gold"] = {
		label = "Scrape Gold",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["scrape_platinum"] = {
		label = "Scrape Platinum",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["scubagear"] = {
		label = "Scuba Gear",
		weight = 5,
		stack = true,
		close = true,
	},

	["seasoned_fries"] = {
		label = "SEASONED FRIES",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["seed_brinjal"] = {
		label = "Seed Brinjal",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["seed_cucumber"] = {
		label = "Seed Cucumber",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["seed_potato"] = {
		label = "Seed Potato",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["seed_rice"] = {
		label = "Seed Rice",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["seed_tomatoo"] = {
		label = "Seed Tomatoo",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["seed_weed"] = {
		label = "Weed Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["seven_up"] = {
		label = "7up",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["shamrock_cookie"] = {
		label = "Shamrock Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["shells_clam_chowder"] = {
		label = "Shells Clam Chowder",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["shell_case"] = {
		label = "Shell Case",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["shoes"] = {
		label = "Shoes",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["shrimp"] = {
		label = "Shrimp",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["shrimp_alfredo"] = {
		label = "Shrimp Alfredo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["shrimp_and_crab_dip"] = {
		label = "Shrimp & Crab Dip",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["shrimp_and_grits"] = {
		label = "Shrimp & Grits",
		weight = 1,
		stack = true,
		close = true,
	},

	["shrimp_packed"] = {
		label = "Shrimp Packed",
		weight = 0.7,
		stack = true,
		close = true,
	},

	["shroom"] = {
		label = "Shroom",
		weight = 0.05,
		stack = true,
		close = true,
	},

	["shroom_cut"] = {
		label = "Shroom Cut",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["shroom_pooch"] = {
		label = "Shroom Pooch",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["side_caesar_salad"] = {
		label = "Side Caesar Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["side_of_flavor"] = {
		label = "SIDE OF FLAVOR",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["side_salad"] = {
		label = "Side Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["signature_chicken_box"] = {
		label = "0.20Pc Mild Signature Chicken Box",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["signature_latte"] = {
		label = "SIGNATURE LATTE",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["simply_orange"] = {
		label = "Simply Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["skateboard"] = {
		label = "Skateboard",
		weight = 1,
		stack = true,
		close = true,
	},

	["skull_bracelet"] = {
		label = "Skull Bracelet",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["skull_earrings"] = {
		label = "Skull Earrings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["small_classic_fries"] = {
		label = "Small Classic Fries",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["small_hash_browns"] = {
		label = "Small Hash Browns",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["small_onion_rings"] = {
		label = "Small Onion Rings",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["smg_ammo_case"] = {
		label = "Smg Ammo Case",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["smg_bullet"] = {
		label = "Smg Bullet",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["snackin_bacon"] = {
		label = "SNACKIN BACON",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["snikers"] = {
		label = "Snikers",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["sniper_ammo_case"] = {
		label = "Sniper Ammo Case",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["sniper_bullet"] = {
		label = "Sniper Bullet",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["snow_man"] = {
		label = "Snow Man",
		weight = 1,
		stack = true,
		close = true,
	},

	["snow_man_joint"] = {
		label = "Snow Man Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["social_smoke"] = {
		label = "Social Smoke Absolute Zero",
		weight = 1,
		stack = true,
		close = true,
	},

	["soft_serve_cone"] = {
		label = "Soft Serve Cone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["soft_serve_cup"] = {
		label = "Soft Serve Cup",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["soft_taco"] = {
		label = "Soft Taco",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["soft_taco_supreme"] = {
		label = "Soft Taco Supreme",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sourdough_breakfast_sandwich"] = {
		label = "ICED CAPPUCCINO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sour_diesel"] = {
		label = "Sour Diesel",
		weight = 1,
		stack = true,
		close = true,
	},

	["sour_diesel_joint"] = {
		label = "Sour Diesel Joint",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["spades_fantasia"] = {
		label = "Ace of Spades Fantasia",
		weight = 1,
		stack = true,
		close = true,
	},

	["speedball"] = {
		label = "Speed Ball",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["spice_joint"] = {
		label = "Spice Joint",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["spice_leaf"] = {
		label = "Spice Leaf",
		weight = 0.08,
		stack = true,
		close = true,
	},

	["spice_pooch"] = {
		label = "Spice Pooch",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["spicy_chicken_burrito"] = {
		label = "Spicy Chicken Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spicy_chicken_sandwich_combo"] = {
		label = "Spicy Chicken Sandwich Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spicy_crispy_chicken_sandwich"] = {
		label = "Spicy Crispy Chicken Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spicy_deluxe"] = {
		label = "Spicy Deluxe Crispy Chicken Sandwich",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["spicy_deluxe_sandwich"] = {
		label = "Spicy Deluxe Sandwich",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spicy_southwest_salad"] = {
		label = "Spicy Southwest Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["spinach_feta"] = {
		label = "Spinach & Feta",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sponge"] = {
		label = "Sponge",
		weight = 1,
		stack = true,
		close = true,
	},

	["sprite"] = {
		label = "Sprite",
		weight = 1,
		stack = true,
		close = true,
	},

	["steak_and_lobster_meal"] = {
		label = "Steak & Lobster Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["steroids"] = {
		label = "Steroids",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["stingray"] = {
		label = "Stingray",
		weight = 0.6,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 10,
		stack = true,
		close = true,
	},

	["strawberry_banana_crepes"] = {
		label = "Strawberry Banana Crepes",
		weight = 1,
		stack = true,
		close = true,
	},

	["strawberry_cheesecake_pie"] = {
		label = "Strawberry Cheesecake Fried Pie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["strawberry_jam_cookie"] = {
		label = "Strawberry Jam Cookie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["strawberry_milkshake"] = {
		label = "Strawberry Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["strawberry_nutella_waffles"] = {
		label = "Strawberry Nutella Waffles",
		weight = 1,
		stack = true,
		close = true,
	},

	["strawberry_shake"] = {
		label = "Strawberry Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["strawberry_watermelon_slushie"] = {
		label = "Strawberry Watermelon Slushie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["stretcher"] = {
		label = "Stretcher",
		weight = 1,
		stack = true,
		close = true,
	},

	["stripedbass"] = {
		label = "Striped Bass",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["stuffed_bagel_minis"] = {
		label = "STUFFED BAGEL MINIS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sundae_pie"] = {
		label = "HERSHEYS Sundae Pie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sun_apple_juice"] = {
		label = "Capri Sun Apple Juice",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["surf_turf_combo"] = {
		label = "Surf & Turf Small Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["sushi"] = {
		label = "Sushi",
		weight = 1,
		stack = true,
		close = true,
	},

	["susp1"] = {
		label = "Suspension Lvl. 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["susp2"] = {
		label = "Suspension Lvl. 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["susp3"] = {
		label = "Suspension Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["susp4"] = {
		label = "Suspension Lvl. 4",
		weight = 1,
		stack = true,
		close = true,
	},

	["susp5"] = {
		label = "Suspension Lvl. 4",
		weight = 1,
		stack = true,
		close = true,
	},

	["sweat_tea_sangria"] = {
		label = "Sweat Tea Sangria",
		weight = 1,
		stack = true,
		close = true,
	},

	["sweet_tea"] = {
		label = "Sweet Tea",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["syriange"] = {
		label = "Syriange",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["syringe"] = {
		label = "Syringe",
		weight = 0.02,
		stack = true,
		close = true,
	},

	["syrup"] = {
		label = "Orgeat syrup",
		weight = 1,
		stack = true,
		close = true,
	},

	["taco"] = {
		label = "Taco",
		weight = 0.18,
		stack = true,
		close = true,
	},

	["tacomeet"] = {
		label = "Taco Meet",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["taco_regular"] = {
		label = "Taco Regular",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tahoe_og"] = {
		label = "Tahoe OG",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tahoe_og_joint"] = {
		label = "Tahoe OG Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tango_apple"] = {
		label = "Tango Apple",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["tango_orange"] = {
		label = "Tango Orange",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["telescope"] = {
		label = "Telescope",
		weight = 1,
		stack = true,
		close = true,
	},

	["tempura"] = {
		label = "Tempura",
		weight = 1,
		stack = true,
		close = true,
	},

	["tenders_family_meal"] = {
		label = "0.26Pc Tenders Family Meal Mild",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tenders_medium_combo"] = {
		label = "Tenders Medium Combo",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tenders_medium_combo."] = {
		label = "Tenders Medium Combo.",
		weight = 1,
		stack = true,
		close = true,
	},

	["tender_pack"] = {
		label = "24PC CRISPY TENDER PACK",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tennisball"] = {
		label = "Tennisball",
		weight = 1,
		stack = true,
		close = true,
	},

	["testpack"] = {
		label = "Test Pack",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["texas_double_whopper"] = {
		label = "Texas Double Whopper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["thermite_bomb"] = {
		label = "Thermite Bomb",
		weight = 1,
		stack = true,
		close = true,
	},

	["thigh_bites_combo"] = {
		label = "LARGE THIGH BITES COMBO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["thirty_crispy_tenders."] = {
		label = "30 CRISPY TENDERS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["threequarter_raglan_sleeve"] = {
		label = "Three Quarter Raglan Sleeve",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["tilapia_fish_meal"] = {
		label = "Steak & Lobster Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_army"] = {
		label = "Tint Army",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_black"] = {
		label = "Tint Black",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_gold"] = {
		label = "Tint Gold",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_green"] = {
		label = "Tint Green",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_orange"] = {
		label = "Tint Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_pink"] = {
		label = "Tint Pink",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_platinum"] = {
		label = "Tint Platinum",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tint_police"] = {
		label = "Tint Police",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tomatoo"] = {
		label = "Tomatoo",
		weight = 1,
		stack = true,
		close = true,
	},

	["toolkit"] = {
		label = "Tool Kit",
		weight = 2,
		stack = true,
		close = true,
		description = "\"used for crafting\""
	},

	["torso"] = {
		label = "Torso",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["trans1"] = {
		label = "Transmission Lvl. 1",
		weight = 1,
		stack = true,
		close = true,
	},

	["trans2"] = {
		label = "Transmission Lvl. 2",
		weight = 1,
		stack = true,
		close = true,
	},

	["trans3"] = {
		label = "Transmission Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["trans4"] = {
		label = "Transmission Lvl. 3",
		weight = 1,
		stack = true,
		close = true,
	},

	["triple_meal_deal"] = {
		label = "Chicken Biscuit",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["triple_sec"] = {
		label = "Triple sec",
		weight = 1,
		stack = true,
		close = true,
	},

	["tropical_chicken_salad"] = {
		label = "Tropical Chicken Salad",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tropical_mango_slushie"] = {
		label = "Tropical Mango Slushie",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["tuna"] = {
		label = "Tuna",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["turbo"] = {
		label = "Turbo Kit",
		weight = 1,
		stack = true,
		close = true,
	},

	["turboN"] = {
		label = "Remove Turbo Kit",
		weight = 1,
		stack = true,
		close = true,
	},

	["tv"] = {
		label = "TV",
		weight = 1,
		stack = true,
		close = true,
	},

	["two_taco_supreme"] = {
		label = "Two Taco Supreme",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["t_diet_pepsi"] = {
		label = "Diet Pepsi",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["t_pepsi_max"] = {
		label = "Pepsi Max",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["t_seven_up"] = {
		label = "Seven Up",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["t_tango_apple"] = {
		label = "Tango Apple",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["t_tango_orange"] = {
		label = "Tango Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["ultimate_pepperoni"] = {
		label = "Ultimate Pepperoni",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["upeel_shrimp"] = {
		label = "U-Peel Shrimp",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["vanBottle"] = {
		label = "Van Bottle",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanDiamond"] = {
		label = "Van Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanilla_milkshake"] = {
		label = "Vanilla Milkshake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["vanilla_shake"] = {
		label = "Vanilla Shake",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["vanNecklace"] = {
		label = "Van Necklace",
		weight = 1,
		stack = true,
		close = true,
	},

	["vanPanther"] = {
		label = "Van Panther",
		weight = 3,
		stack = true,
		close = true,
	},

	["vanPogo"] = {
		label = "Van Pogo",
		weight = 2.5,
		stack = true,
		close = true,
	},

	["vape"] = {
		label = "Vape",
		weight = 1,
		stack = true,
		close = true,
	},

	["veggie_sticks"] = {
		label = "VEGGIE STICKS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["viagra"] = {
		label = "Viagra",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["vine"] = {
		label = "Vine",
		weight = 1,
		stack = true,
		close = true,
	},

	["vodka_lemon"] = {
		label = "Vodka Lemon",
		weight = 1,
		stack = true,
		close = true,
	},

	["vodka_tonic"] = {
		label = "Vodka Tonic",
		weight = 1,
		stack = true,
		close = true,
	},

	["volcano_burrito"] = {
		label = "Volcano Burrito",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["volcano_burrito_meal"] = {
		label = "Volcano Burrito Meal",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["waffle_potato_chips"] = {
		label = "Waffle Potato Chips",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["waffle_potato_fries"] = {
		label = "Waffle Potato Fries",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["wake_up_wrap"] = {
		label = "WAKE-UP WRAP",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 8,
		stack = true,
		close = true,
	},

	["watch"] = {
		label = "Watch",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["watch_bracelet"] = {
		label = "Watch Bracelet",
		weight = 1,
		stack = true,
		close = true,
	},

	["watch_material"] = {
		label = "Watch Material",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["WEAPON_DIGISCANNER"] = {
		label = "Digiscanner",
		weight = 1,
		stack = true,
		close = true,
	},

	["WEAPON_GARBAGEBAG"] = {
		label = "Garbage Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["WEAPON_GRENADELAUNCHER_SMOKE"] = {
		label = "SMOKE LAUNCHER",
		weight = 5,
		stack = true,
		close = true,
	},

	["WEAPON_HANDCUFFS"] = {
		label = "Handcuffs",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["WEAPON_STINGER"] = {
		label = "Stinger",
		weight = 10,
		stack = true,
		close = true,
	},

	["weddingring"] = {
		label = "Wedding Ring",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["weedbrick"] = {
		label = "Weed Brick",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_fertilizer"] = {
		label = "Weed Fertilizer",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_joint"] = {
		label = "Weed Joint",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["weed_leaf"] = {
		label = "Weed Leaf",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_pooch"] = {
		label = "Weed Pooch",
		weight = 0.8,
		stack = true,
		close = true,
	},

	["weed_pot"] = {
		label = "Weed Pot",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_spray"] = {
		label = "Weed Spray",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_black_phone"] = {
		label = "Wet Black Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_blue_phone"] = {
		label = "Wet Blue Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_classic_phone"] = {
		label = "Wet Classic Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_gold_phone"] = {
		label = "Wet Gold Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_greenlight_phone"] = {
		label = "Wet Green Light Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_green_phone"] = {
		label = "Wet Green Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_phone"] = {
		label = "Wet Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_pink_phone"] = {
		label = "Wet Pink Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_red_phone"] = {
		label = "Wet Red Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_white_phone"] = {
		label = "Wet White Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wheelchair"] = {
		label = "Wheelchair",
		weight = 1,
		stack = true,
		close = true,
	},

	["whiskey_cola"] = {
		label = "Whiskey Cola",
		weight = 1,
		stack = true,
		close = true,
	},

	["whisky"] = {
		label = "Wisky",
		weight = 0.75,
		stack = true,
		close = true,
	},

	["whitecherry_gelato"] = {
		label = "Whitecherry Gelato",
		weight = 1,
		stack = true,
		close = true,
	},

	["whitecherry_gelato_joint"] = {
		label = "Whitecherry Gelato Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["white_grapes"] = {
		label = "White Grapes",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["white_phone"] = {
		label = "White Phone",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_pressed_grapes"] = {
		label = "White Pressed Grapes",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["white_rum"] = {
		label = "White rum",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_runtz"] = {
		label = "White Runtz",
		weight = 1,
		stack = true,
		close = true,
	},

	["white_runtz_joint"] = {
		label = "White Runtz Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["white_stone"] = {
		label = "White Stone",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["white_wine"] = {
		label = "White Wine",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["whopper_with_cheese"] = {
		label = "Triple Whopper with Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["win1"] = {
		label = "Light Smoke Window Tint",
		weight = 1,
		stack = true,
		close = true,
	},

	["win2"] = {
		label = "Dark Smoke Window Tint",
		weight = 1,
		stack = true,
		close = true,
	},

	["win3"] = {
		label = "Limo Window Tint",
		weight = 1,
		stack = true,
		close = true,
	},

	["win4"] = {
		label = "Limo Window Tint",
		weight = 1,
		stack = true,
		close = true,
	},

	["wine"] = {
		label = "Wine",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["wingstop_dips"] = {
		label = "DIPS",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["wing_combo"] = {
		label = "LARGE 0.20 PC WING COMBO",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["wirecutter"] = {
		label = "Wire Cutter",
		weight = 0.4,
		stack = true,
		close = true,
	},

	["wisconsin_cheese"] = {
		label = "Wisconsin 6 Cheese",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 5,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},

	["workpermit"] = {
		label = "Work Permit (Auto Repairs Mirror Park)",
		weight = 0.1,
		stack = true,
		close = true,
	},

	["world_famous_fries"] = {
		label = "World Famous Fries",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_diet_coke"] = {
		label = "Diet Coke",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_diet_pepsi"] = {
		label = "Det Pepsi",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_dr_pepper"] = {
		label = "Dr Pepper",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_ice_cola"] = {
		label = "Ice Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_medium_fanta_orange"] = {
		label = "Ice Cola",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_medium_fanta_strawberry"] = {
		label = "Medium Fanta Strawberry",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_medium_sprite"] = {
		label = "Medium Sprite",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_tango_apple"] = {
		label = "Tango Apple",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["w_tango_orange"] = {
		label = "Tango Orange",
		weight = 0.2,
		stack = true,
		close = true,
	},

	["xanax"] = {
		label = "Xanax",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["xanax_box"] = {
		label = "Xanax Box",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsblacklight"] = {
		label = "Blacklight Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsbleu"] = {
		label = "Blue Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsbleuelect"] = {
		label = "Electric Blue Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsdefault"] = {
		label = "White Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsgold"] = {
		label = "Gold Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsjaune"] = {
		label = "Yellow Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsmauve"] = {
		label = "Purple Xenone",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsmenthe"] = {
		label = "Mint Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsorange"] = {
		label = "Orange Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsrose"] = {
		label = "Pink Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsrose2"] = {
		label = "Hot Pink Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsrouge"] = {
		label = "Red Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xenonsvert"] = {
		label = "Green Xenons",
		weight = 1,
		stack = true,
		close = true,
	},

	["xpill"] = {
		label = "X-Pill",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["xpills"] = {
		label = "X-Pills",
		weight = 0.01,
		stack = true,
		close = true,
	},

	["xray"] = {
		label = "X-Ray Scanner",
		weight = 1,
		stack = true,
		close = true,
	},

	["yellow_shoes"] = {
		label = "Yellow Shoes",
		weight = 0.3,
		stack = true,
		close = true,
	},

	["zetony"] = {
		label = "Casino Chips",
		weight = 0.002,
		stack = true,
		close = true,
	},

	["zomo_cream"] = {
		label = "Acai Cream Zomo",
		weight = 1,
		stack = true,
		close = true,
	},

	["zomo_lemon"] = {
		label = "Zomo Lemon Mint",
		weight = 1,
		stack = true,
		close = true,
	},

	["zushi"] = {
		label = "Zushi",
		weight = 0.2,
		stack = true,
		close = true,
	},

-- Add to your items.lua

-- Equipment
['bbq_stove'] = {
    label = 'BBQ Stove',
    weight = 1,
    stack = false,
    close = true,
},
['tent'] = {
    label = 'tent',
    weight = 1,
    stack = false,
    close = true,
},
['spatula'] = {
    label = 'Spatula',
    weight = 100,
    stack = true,
},
['table'] = {
    label = 'BBQ Table',
    weight = 1000,
    stack = false,
    close = true,
},
['chair'] = {
    label = 'BBQ Chair',
    weight = 500,
    stack = false,
    close = true,
},
['soda_machine'] = {
    label = 'Soda Machine',
    weight = 1000,
    stack = false,
    close = true,
},

-- Raw Meat
['steak'] = {
    label = 'Raw Steak',
    weight = 200,
    stack = true,
},
['pork_chops'] = {
    label = 'Raw Pork Chops',
    weight = 200,
    stack = true,
},
['sausages'] = {
    label = 'Raw Sausages',
    weight = 200,
    stack = true,
},
['chicken_wings'] = {
    label = 'Raw Chicken Wings',
    weight = 200,
    stack = true,
},

-- Cooked Items
['steak_cooked'] = {
    label = 'Cooked Steak',
    weight = 200,
    stack = true,
},
['pork_chops_cooked'] = {
    label = 'Cooked Pork Chops',
    weight = 200,
    stack = true,
},
['sausages_cooked'] = {
    label = 'Cooked Sausages',
    weight = 200,
    stack = true,
},
['chicken_wings_cooked'] = {
    label = 'Cooked Chicken Wings',
    weight = 200,
    stack = true,
},

-- Burnt Items
['steak_burnt'] = {
    label = 'Burnt Steak',
    weight = 200,
    stack = true,
},
['pork_chops_burnt'] = {
    label = 'Burnt Pork Chops',
    weight = 200,
    stack = true,
},
['sausages_burnt'] = {
    label = 'Burnt Sausages',
    weight = 200,
    stack = true,
},
['chicken_wings_burnt'] = {
    label = 'Burnt Chicken Wings',
    weight = 200,
    stack = true,
},

-- Add to your items.lua

-- Seasoned versions of cooked items
['seasonings'] = {
    label = 'seasonings',
    weight = 200,
    stack = true,
},
['seasoned_steak'] = {
    label = 'Seasoned Steak',
    weight = 200,
    stack = true,
},
['seasoned_pork_chops'] = {
    label = 'Seasoned Pork Chops',
    weight = 200,
    stack = true,
},
['seasoned_chicken_wings'] = {
    label = 'Seasoned Chicken Wings',
    weight = 200,
    stack = true,
},

-- Hot dog ingredients and results
['bun'] = {
    label = 'Hot Dog Bun',
    weight = 50,
    stack = true,
},
['mustard'] = {
    label = 'Mustard',
    weight = 100,
    stack = true,
},
['ketchup'] = {
    label = 'Ketchup',
    weight = 100,
    stack = true,
},
['mayonnaise'] = {
    label = 'Mayonnaise',
    weight = 100,
    stack = true,
},
['mustard_hotdog'] = {
    label = 'Mustard Hot Dog',
    weight = 250,
    stack = true,
},
['ketchup_hotdog'] = {
    label = 'Ketchup Hot Dog',
    weight = 250,
    stack = true,
},
['mayonnaise_hotdog'] = {
    label = 'Mayonnaise Hot Dog',
    weight = 250,
    stack = true,
},

-- Soda Items
['cup'] = {
    label = 'Empty Cup',
    weight = 50,
    stack = true,
},
['cola_syrup'] = {
    label = 'Cola Syrup',
    weight = 100,
    stack = true,
},
['lemon_lime_syrup'] = {
    label = 'Lemon-Lime Syrup',
    weight = 100,
    stack = true,
},
['orange_syrup'] = {
    label = 'Orange Syrup',
    weight = 100,
    stack = true,
},
['cola_soda'] = {
    label = 'Cola',
    weight = 150,
    stack = true,
},
['lemon_lime_soda'] = {
    label = 'Lemon-Lime Soda',
    weight = 150,
    stack = true,
},
['orange_soda'] = {
    label = 'Orange Soda',
    weight = 150,
    stack = true,
},

	["zushi_joint"] = {
		label = "Zushi Joint",
		weight = 0.2,
		stack = true,
		close = true,
	},

	-- Add to your ox_inventory/data/items.lua

-- Equipment
['pizza_oven'] = {
    label = 'Pizza Oven',
    weight = 5000,
    stack = false,
    close = true,
},
['pizza_table'] = {
    label = 'Pizza Table',
    weight = 2000,
    stack = false,
    close = true,
},
['cutting_board'] = {
    label = 'Cutting Board',
    weight = 500,
    stack = false,
    close = true,
},
['pizza_roller'] = {
    label = 'Pizza Roller',
    weight = 200,
    stack = true,
    close = true,
},

-- Raw Ingredients
['pizza_dough'] = {
    label = 'Pizza Dough',
    weight = 250,
    stack = true,
    close = true,
},
['tomato_sauce'] = {
    label = 'Tomato Sauce',
    weight = 100,
    stack = true,
    close = true,
},
['cheese'] = {
    label = 'Mozzarella Cheese',
    weight = 100,
    stack = true,
    close = true,
},
['pepperoni'] = {
    label = 'Pepperoni',
    weight = 100,
    stack = true,
    close = true,
},
['mushrooms'] = {
    label = 'Mushrooms',
    weight = 50,
    stack = true,
    close = true,
},
['olives'] = {
    label = 'Olives',
    weight = 50,
    stack = true,
    close = true,
},

-- Status Effects for Consumption (Optional)
['margherita_pizza'] = {
    label = 'Margherita Pizza',
    weight = 500,
    stack = true,
    close = true,
    client = {
        status = { hunger = 200000 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'v_res_fa_pizza01', 
                 pos = vec3(0.020000, 0.020000, -0.020000),
                 rot = vec3(0.0, 0.0, 0.0) },
        usetime = 2500,
    },
},

-- Repeat similar status effects for other pizza types
['pepperoni_pizza'] = {
    label = 'Pepperoni Pizza',
    weight = 600,
    stack = true,
    close = true,
    client = {
        status = { hunger = 250000 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'v_res_fa_pizza01',
                 pos = vec3(0.020000, 0.020000, -0.020000),
                 rot = vec3(0.0, 0.0, 0.0) },
        usetime = 2500,
    },
},

['pizza_slice'] = {
    label = 'Pizza Slice',
    weight = 100,
    stack = true,
    close = true,
    client = {
        status = { hunger = 50000 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'v_res_fa_pizza01',
                 pos = vec3(0.020000, 0.020000, -0.020000),
                 rot = vec3(0.0, 0.0, 0.0) },
        usetime = 2000,
    },
},


['tomatoes'] = {
    label = 'Tomatoes',
    weight = 100,
    stack = true,
    description = 'Fresh tomatoes',
},

['onions'] = {
    label = 'Onions',
    weight = 100,
    stack = true,
    description = 'Fresh onions',
},

['lettuce'] = {
    label = 'Lettuce',
    weight = 100,
    stack = true,
    description = 'Fresh lettuce',
},

-- Snacks and Candy
['bzzz_cgreen'] = {
    label = 'Green Snack',
    weight = 100,
    stack = true,
    close = true,
    description = 'A tasty green snack',
    client = {
        status = { hunger = 15, stress = -5 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_cgreen', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_cred'] = {
    label = 'Red Snack',
    weight = 100,
    stack = true,
    close = true,
    description = 'A tasty red snack',
    client = {
        status = { hunger = 15, stress = -5 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_cred', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_cyellow'] = {
    label = 'Yellow Snack',
    weight = 100,
    stack = true,
    close = true,
    description = 'A tasty yellow snack',
    client = {
        status = { hunger = 15, stress = -5 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_cbyellow', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

-- Chips varieties
['bzzz_chips_a'] = {
    label = 'Chips A',
    weight = 100,
    stack = true,
    close = true,
    description = 'Crispy potato chips',
    client = {
        status = { hunger = 15 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_chips_a', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

-- [Add similar entries for chips_b through chips_f]

['bzzz_meteorite'] = {
    label = 'Meteorite Bar',
    weight = 100,
    stack = true,
    close = true,
    description = 'Chocolate and caramel bar',
    client = {
        status = { hunger = 10, stress = -10 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_meteorite', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_nothings'] = {
    label = 'Nothings Bar',
    weight = 100,
    stack = true,
    close = true,
    description = 'Light and crispy wafer bar',
    client = {
        status = { hunger = 10, stress = -5 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_nothings', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

-- Relief candies
['bzzz_relblue'] = {
    label = 'Blue Relief',
    weight = 50,
    stack = true,
    close = true,
    description = 'Refreshing mint candy',
    client = {
        status = { stress = -15 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_relblue', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_relgreen'] = {
    label = 'Green Relief',
    weight = 50,
    stack = true,
    close = true,
    description = 'Soothing herbal candy',
    client = {
        status = { stress = -15 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_relgreen', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_relpink'] = {
    label = 'Pink Relief',
    weight = 50,
    stack = true,
    close = true,
    description = 'Sweet fruity candy',
    client = {
        status = { stress = -15 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_relpink', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_zebrabar'] = {
    label = 'Zebra Bar',
    weight = 100,
    stack = true,
    close = true,
    description = 'Black and white chocolate bar',
    client = {
        status = { hunger = 10, stress = -10 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_zebrabar', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},

['bzzz_candybox'] = {
    label = 'Candy Box',
    weight = 300,
    stack = true,
    close = true,
    description = 'Box full of assorted candies',
    client = {
        status = { hunger = 25, stress = -20 },
        anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
        prop = { model = 'bzzz_vending_prop_candybox', pos = vec3(0.01, 0.01, 0.02), rot = vec3(5.0, 5.0, -1.5) },
        usetime = 2500,
    }
},


["cash_roll"] = {
	label = "Roll of Cash",
	weight = 0.1,
	stack = true,
	close = true,
},

["meth_bag"] = {
	label = "Meth Bag",
	weight = 0.3,
	stack = true,
	close = true,
},

['washed_money'] = {
    label = 'Dirty Money',
    weight = 0,
    stack = true,
    close = true,
    description = 'Money that needs to be laundered',
},

['black_money'] = {
    label = 'Black Money',
    weight = 0,
    stack = true,
    close = true,
    description = 'Illegally obtained money',
},


	["spray_remover"] = {
		label = "Spray Remover",
		weight = 0.25,
		stack = true,
		close = true,
	},

	["money"] = {
		label = "Cash",
		weight = 0,
		stack = true,
		close = true,
	},

	["spray"] = {
		label = "Spray",
		weight = 0.5,
		stack = true,
		close = true,
	},

	["gang_spray"] = {
		label = "Gang Spray",
		weight = 1,
		stack = true,
		close = true,
	},

	["sprayremover"] = {
		label = "Spray Remover",
		weight = 1,
		stack = true,
		close = true,
	},

	["raw_coffee"] = {
		label = "Raw Coffee",
		weight = 1,
		stack = true,
		close = true,
		description = "Raw Coffee for making delicious coffee"
	},

	['pokemon_card'] = {
		label = 'Pokemon card',
		weight = 10,
		consume = 0,
	},

	['pokemon_packet'] = {
		label = 'Pokemon Card Pack',
		weight = 50,
		consume = 1,
	},

	["bankconfidential"] = {
		label = "Bank Confidential Docs",
		weight = 1,
		stack = true,
		close = true,
		description = "\"Contains bank transactions and credit card informations\""
	},
}
Config = {}
Config.Locale = "en"

--You can set admin in alternative ways-------------------
--Ace Permission
Config.AdminWithAce = true
--Or group
Config.AdminWithGroup = {
    ['admin'] = true,
    ['superadmin'] = true,
    ['god'] = true,
}
--Or license
Config.AdminWithLicense = {
    ['license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = true,
}
--Or character id
Config.AdminWithIdentifier = {
    ['xxxxxxxx'] = true,
}
----------------------------------------------------------
Config.MaxLeaderboardData = 50
Config.ResetLeaderboard = 180 --180 days

Config.BoostingTabItem = 'boostingtab' -- Config.BoostingTabItem = nil to remove required item
Config.BoostingTabCommand = 'boosting' -- Config.BoostingTabCommand = nil to remove the command

Config.CustomDispatch = false -- if enabled, set your dispatch export in client/customizable.lua
Config.Cops = {
    ['police'] = true,
    ['sheriff'] = true,
}

Config.OwnedVehiclesTable = 'owned_vehicles' --in database
Config.SpecialCoin = {
    tablename           = 'ak47_carboosting', --adjust this if needed [I don't know what coin script you are using or not, so don't open ticket for this]
    identifiercolumname = 'identifier',       --adjust this if needed [I don't know what coin script you are using or not, so don't open ticket for this]
    coincolumname       = 'coin',             --adjust this if needed [I don't know what coin script you are using or not, so don't open ticket for this]
}

Config.TargetScript = 'qtarget' -- don't change if you are using ox_target
Config.HackItem = 'hackingtab'
Config.RemoveChance = {
    onFailOf = {
        GarageHack  = 70, -- %
        VehicleHack = 50, -- %
        GpsHack     = 30, -- %
    },
    onSuccessOf = {
        GarageHack  = 30, -- %
        VehicleHack = 20, -- %
        GpsHack     = 10, -- %
    }
}

-- Don't add or change class names
Config.Class = {
	{
		name = "D",
		xp = 300,
        xpgain = {owner = 50, member = 25},
		maxcontract = 4,
		mingroupmember = 0, -- not more than 3
		maxgroupmember = 0, -- not more than 3
		spin = {times = 5, chance = 70, interval = 1}, -- spin 5 times in every 30 minutes. If match (70% chance), new contract will be added
		expiretime = 30, -- 30 minutes
	},
	{
		name = "C", 
		xp = 600,
        xpgain = {owner = 100, member = 50},
		maxcontract = 2,
		mingroupmember = 0, -- not more than 3
		maxgroupmember = 1, -- not more than 3
		spin = {times = 4, chance = 70, interval = 30}, -- spin 4 times in every 30 minutes. If match (70% chance), new contract will be added
		expiretime = 45, -- 45 minutes
	},

	{
		name = "B", 
		xp = 1200,
        xpgain = {owner = 300, member = 150},
		maxcontract = 2,
		mingroupmember = 1, -- not more than 3
		maxgroupmember = 2, -- not more than 3
		spin = {times = 3, chance = 70, interval = 30}, -- spin 3 times in every 30 minutes. If match (70% chance), new contract will be added
		expiretime = 60, -- 60 minutes
	},

	{
		name = "A", 
		xp = 2400,
        xpgain = {owner = 600, member = 300},
		maxcontract = 1, 
		mingroupmember = 2, -- not more than 3
		maxgroupmember = 3, -- not more than 3
		spin = {times = 2, chance = 70, interval = 30}, -- spin 2 times in every 30 minutes. If match (70% chance), new contract will be added
		expiretime = 90, -- 90 minutes
	},

	{
		name = "S", 
		xp = 4800,
		maxcontract = 1,
        xpgain = {owner = 800, member = 400},
		mingroupmember = 3, -- not more than 3
		maxgroupmember = 3, -- not more than 3
		spin = {times = 1, chance = 70, interval = 30}, -- spin 1 time in every 30 minutes. If match (70% chance), new contract will be added
		expiretime = 120, -- 120 minutes
	},
}

Config.RewardByClass = {
	['D'] = {
		money = {
        	minimum = 25000,
        	maximum = 35000,
        },
        specialcoin = {
        	minimum = 0,
        	maximum = 0,
        }
	},
	['C'] = {
		money = {
        	minimum = 35000,
        	maximum = 45000,
        },
        specialcoin = {
        	minimum = 3,
        	maximum = 4,
        }
	},
	['B'] = {
		money = {
        	minimum = 45000,
        	maximum = 55000,
        },
        specialcoin = {
        	minimum = 4,
        	maximum = 5,
        }
	},
	['A'] = {
		money = {
        	minimum = 55000,
        	maximum = 65000,
        },
        specialcoin = {
        	minimum = 5,
        	maximum = 6,
        }
	},
	['S'] = {
		money = {
        	minimum = 65000,
        	maximum = 75000,
        },
        specialcoin = {
        	minimum = 6,
        	maximum = 7,
        }
	},
}

Config.VehiclesByClass = {
	['D'] = {
		{model = 'rebla', name = 'Rebla', vinScratchChance = 0},
        {model = 'sultan', name = 'Subaru Impreza WRX', vinScratchChance = 0},
        {model = 'dilettante', name = 'Toyota Prius', vinScratchChance = 0},
        {model = 'fugitive', name = 'Chevrolet Impala', vinScratchChance = 0},
        {model = 'primo', name = 'Cadillac DeVille', vinScratchChance = 0},
	},
	['C'] = {
		{model = 'fusilade', name = 'Chrysler Crossfire', vinScratchChance = 0},
        {model = 'penumbra', name = 'Mitsubishi Eclipse', vinScratchChance = 0},
        {model = 'baller', name = 'Range Rover Sport', vinScratchChance = 0},
        {model = 'dubsta', name = 'Mercedes-Benz G-Class', vinScratchChance = 0},
        {model = 'mesa', name = 'Jeep Wrangler', vinScratchChance = 0},
	},
	['B'] = {
		{model = 'comet3', name = 'Comet Safari', vinScratchChance = 0},
        {model = 'oracle', name = 'BMW M6', vinScratchChance = 0},
        {model = 'feltzer2', name = 'Mercedes-Benz SL65 AMG', vinScratchChance = 0},
        {model = 'gauntlet', name = 'Dodge Challenger', vinScratchChance = 0},
        {model = 'dominator', name = 'Ford Mustang', vinScratchChance = 0},
	},
	['A'] = {
		{model = 'voltic', name = 'Tesla Roadster', vinScratchChance = 70}, -- 70% chance
        {model = 'ninef2', name = 'Audi R8 Spyder', vinScratchChance = 70}, -- 70% chance
        {model = 'turismor', name = 'McLaren P1', vinScratchChance = 70}, -- 70% chance
        {model = 'massacro', name = 'Aston Martin Vanquish', vinScratchChance = 70}, -- 70% chance
	},
	['S'] = {
		{model = 'adder', name = 'Bugatti EB16.4', vinScratchChance = 80}, -- 80% chance
        {model = 'infernus', name = 'Lamborghini Murcielago', vinScratchChance = 80}, -- 80% chance
        {model = 'entityxf', name = 'Koenigsegg CCx', vinScratchChance = 80}, -- 80% chance
        {model = 'cheetah', name = 'SSC Tuatara', vinScratchChance = 80}, -- 80% chance
	},
}

Config.LocationByClass = {
	['D'] = {
    	{
            car = vector4(-935.29, -1080.13, 2.08, 300.5),
            searchzone = 200.0,
        },
        {
            car = vector4(-1077.23, -1143.85, 2.14, 209.74),
            searchzone = 200.0,
        },
        {
            car = vector4(-1516.81, -884.33, 10.09, 49.79),
            searchzone = 200.0,
        },
        {
            car = vector4(-1142.08, -740.75, 20.0, 288.65),
            searchzone = 200.0,
        },
        {
            car = vector4(-727.32, -1061.34, 12.33, 31.6),
            searchzone = 200.0,
        },
        {
            car = vector4(-523.9, -882.46, 25.16, 171.29),
            searchzone = 200.0,
        },
        {
            car = vector4(-446.27, -767.56, 30.54, 270.22),
            searchzone = 200.0,
        },
        {
            car = vector4(-175.38, -156.49, 43.6, 67.55),
            searchzone = 200.0,
        },
    },
    ['C'] = {
    	{
            car = vector4(2.41, -1524.67, 29.34, 140.98),
            searchzone = 220.0,
            npc = {
                vector4(0.13, -1502.9, 29.96, 141.07),
                vector4(12.48, -1533.12, 29.29, 322.65),
            }
        },
        {
            car = vector4(-1658.91, -205.13, 55.26, 70.84),
            searchzone = 220.0,
            npc = {
                vector4(-1675.77, -197.79, 57.71, 214.03),
                vector4(-1666.96, -186.01, 57.63, 165.92),
            }
        },
        {
            car = vector4(-59.79, -1842.56, 26.56, 139.48),
            searchzone = 220.0,
            npc = {
                vector4(-38.17, -1834.6, 26.06, 48.21),
                vector4(-54.23, -1821.26, 26.78, 225.77),
            }
        },
        {
            car = vector4(-1977.46, 259.95, 87.2, 289.04),
            searchzone = 220.0,
            npc = {
                vector4(-1970.5, 245.99, 87.81, 289.36),
                vector4(-1981.2, 249.1, 87.61, 21.31),
            }
        },
        {
            car = vector4(-1198.83, 348.86, 71.12, 286.12),
            searchzone = 220.0,
            npc = {
                vector4(-1209.39, 354.27, 71.22, 232.4),
                vector4(-1211.68, 322.27, 71.04, 290.64),
            }
        },
        {
            car = vector4(237.79, 382.14, 106.14, 68.93),
            searchzone = 220.0,
            npc = {
                vector4(223.21, 380.19, 106.5, 339.06),
                vector4(259.28, 370.69, 105.61, 16.83),
            }
        },
        {
            car = vector4(216.36, 758.02, 204.64, 58.22),
            searchzone = 220.0,
            npc = {
                vector4(231.85, 771.88, 204.78, 55.37),
                vector4(200.94, 775.53, 205.71, 271.1),
            },
        },
        {
            car = vector4(152.12, 163.18, 104.82, 68.93),
            searchzone = 220.0,
            npc = {
                vector4(157.53, 153.29, 105.16, 67.25),
                vector4(141.43, 179.05, 105.49, 244.35),
            }
        },
    },
    ['B'] = {
       {
            car = vector4(147.51, 321.05, 112.12, 113.94),
            searchzone = 230.0,
            npc = {
                vector4(154.09, 305.3, 112.13, 91.62),
                vector4(154.09, 305.3, 112.13, 91.62),
                vector4(135.05, 323.4, 116.63, 199.31),
                vector4(135.05, 323.4, 116.63, 199.31),
            },
        },
        {
            car = vector4(-1359.32, -757.08, 22.28, 127.66),
            searchzone = 230.0,
            npc = {
                vector4(-1349.03, -766.21, 20.51, 309.69),
                vector4(-1349.03, -766.21, 20.51, 309.69),
                vector4(-1350.83, -738.68, 22.42, 218.88),
                vector4(-1350.83, -738.68, 22.42, 218.88)
            },
        },
        {
            car = vector4(-969.59, 103.23, 55.64, 149.28),
            searchzone = 230.0,
            npc = {
                vector4(-974.16, 99.25, 55.94, 306.27),
                vector4(-974.16, 99.25, 55.94, 306.27),
                vector4(-971.39, 122.33, 57.05, 304.09),
                vector4(-971.39, 122.33, 57.05, 304.09),
            },
        },
        {
            car = vector4(135.74, -1050.16, 29.13, 340.31),
            searchzone = 230.0,
            npc = {
                vector4(126.79, -1047.12, 29.21, 161.14),
                vector4(126.79, -1047.12, 29.21, 161.14),
                vector4(151.79, -1055.16, 29.22, 159.56),
                vector4(151.79, -1055.16, 29.22, 159.56),
            },
        },
        {
            car = vector4(202.83, -149.8, 57.15, 341.36),
            searchzone = 230.0,
            npc = {
                vector4(187.24, -162.41, 56.32, 347.08),
                vector4(187.24, -162.41, 56.32, 347.08),
                vector4(213.39, -148.92, 58.81, 158.68),
                vector4(213.39, -148.92, 58.81, 158.68),
            },
        },
        {
            car = vector4(1149.06, -1642.74, 36.32, 27.44),
            searchzone = 230.0,
            npc = {
                vector4(1154.33, -1635.11, 37.06, 116.37),
                vector4(1154.33, -1635.11, 37.06, 116.37),
                vector4(1140.78, -1661.28, 36.43, 29.16),
                vector4(1140.78, -1661.28, 36.43, 29.16),
            },
        },
        {
            car = vector4(985.96, -138.64, 73.07, 239.05),
            searchzone = 230.0,
            npc = {
                vector4(986.85, -115.6, 73.87, 71.99),
                vector4(948.99, -111.34, 74.36, 169.69),
                vector4(990.61, -148.3, 74.24, 104.84),
                vector4(963.11, -143.75, 74.49, 44.89),
            },
        },
        {
            car = vector4(518.46, 169.43, 99.35, 93.52),
            searchzone = 230.0,
            npc = {
                vector4(522.72, 154.5, 98.8, 289.04),
                vector4(535.5, 176.39, 100.17, 153.8),
                vector4(545.99, 139.02, 98.49, 33.59),
                vector4(523.11, 141.08, 98.04, 345.48),
            },
        },
        {
            car = vector4(-676.97, 902.96, 230.56, 163.66),
            searchzone = 230.0,
            npc = {
                vector4(-660.48, 894.93, 229.25, 337.53),
                vector4(-698.44, 919.82, 232.66, 340.36),
                vector4(-638.88, 943.69, 240.66, 119.29),
                vector4(-657.4, 893.69, 229.25, 23.25),
            },
        },
        {
            car = vector4(947.51, -1697.8, 30.06, 84.25),
            searchzone = 230.0,
            npc = {
                vector4(951.4, -1719.36, 30.67, 313.81),
                vector4(977.47, -1703.96, 29.88, 86.63),
                vector4(962.44, -1674.72, 30.06, 241.67),
                vector4(952.81, -1677.7, 30.06, 235.42),
            },
        },
        {
            car = vector4(147.17, 320.64, 112.12, 293.18),
            searchzone = 230.0,
            npc = {
                vector4(138.68, 324.12, 112.14, 115.1),
                vector4(155.74, 304.65, 112.12, 88.75),
                vector4(120.3, 316.18, 112.14, 242.71),
                vector4(120.3, 316.18, 112.14, 242.71),
            },
        },
        {
            car = vector4(-401.88, 510.14, 120.18, 159.44),
            searchzone = 230.0,
            npc = {
                vector4(-410.15, 508.02, 121.61, 322.53),
                vector4(-385.6, 505.21, 120.41, 1.48),
                vector4(-385.6, 505.21, 120.41, 1.48),
                vector4(-388.98, 519.72, 121.34, 82.43)
            },
        },
    },
    ['A'] = {
        {
            car = vector4(147.51, 321.05, 112.12, 113.94),
            searchzone = 250.0,
            npc = {
                vector4(154.09, 305.3, 112.13, 91.62),
                vector4(154.09, 305.3, 112.13, 91.62),
                vector4(154.09, 305.3, 112.13, 91.62),
                vector4(135.05, 323.4, 116.63, 199.31),
                vector4(135.05, 323.4, 116.63, 199.31),
                vector4(135.05, 323.4, 116.63, 199.31),
            },
            doorlock = {
                doorhash = -915091986,
                position = vector3(143.11, 318.99, 112.14),
            }
        },
        {
            car = vector4(-1359.32, -757.08, 22.28, 127.66),
            searchzone = 250.0,
            npc = {
                vector4(-1349.03, -766.21, 20.51, 309.69),
                vector4(-1349.03, -766.21, 20.51, 309.69),
                vector4(-1349.03, -766.21, 20.51, 309.69),
                vector4(-1350.83, -738.68, 22.42, 218.88),
                vector4(-1350.83, -738.68, 22.42, 218.88),
                vector4(-1350.83, -738.68, 22.42, 218.88)
            },
            doorlock = {
                doorhash = -1212275031,
                position = vector3(-1355.12, -753.69, 22.31),
            }
        },
        {
            car = vector4(-969.59, 103.23, 55.64, 149.28),
            searchzone = 250.0,
            npc = {
                vector4(-974.16, 99.25, 55.94, 306.27),
                vector4(-974.16, 99.25, 55.94, 306.27),
                vector4(-974.16, 99.25, 55.94, 306.27),
                vector4(-971.39, 122.33, 57.05, 304.09),
                vector4(-971.39, 122.33, 57.05, 304.09),
                vector4(-971.39, 122.33, 57.05, 304.09),
            },
            doorlock = {
                doorhash = 30769481,
                position = vector3(-966.36, 106.61, 55.67),
            }
        },
        {
            car = vector4(135.74, -1050.16, 29.13, 340.31),
            searchzone = 250.0,
            npc = {
                vector4(126.79, -1047.12, 29.21, 161.14),
                vector4(126.79, -1047.12, 29.21, 161.14),
                vector4(126.79, -1047.12, 29.21, 161.14),
                vector4(151.79, -1055.16, 29.22, 159.56),
                vector4(151.79, -1055.16, 29.22, 159.56),
                vector4(151.79, -1055.16, 29.22, 159.56),
            },
            doorlock = {
                doorhash = -982531572,
                position = vector3(133.99, -1054.66, 29.19),
            }
        },
        {
            car = vector4(202.83, -149.8, 57.15, 341.36),
            searchzone = 250.0,
            npc = {
                vector4(187.24, -162.41, 56.32, 347.08),
                vector4(187.24, -162.41, 56.32, 347.08),
                vector4(187.24, -162.41, 56.32, 347.08),
                vector4(213.39, -148.92, 58.81, 158.68),
                vector4(213.39, -148.92, 58.81, 158.68),
                vector4(213.39, -148.92, 58.81, 158.68),
            },
            doorlock = {
                doorhash = -728539053,
                position = vector3(201.08, -153.72, 57.14),
            }
        },
        {
            car = vector4(1149.06, -1642.74, 36.32, 27.44),
            searchzone = 250.0,
            npc = {
                vector4(1154.33, -1635.11, 37.06, 116.37),
                vector4(1154.33, -1635.11, 37.06, 116.37),
                vector4(1154.33, -1635.11, 37.06, 116.37),
                vector4(1140.78, -1661.28, 36.43, 29.16),
                vector4(1140.78, -1661.28, 36.43, 29.16),
                vector4(1140.78, -1661.28, 36.43, 29.16),
            },
            doorlock = {
                doorhash = 889818406,
                position = vector3(1151.25, -1646.69, 36.33),
            }
        },
        {
            car = vector4(985.96, -138.64, 73.07, 239.05),
            searchzone = 250.0,
            npc = {
                vector4(986.85, -115.6, 73.87, 71.99),
                vector4(948.99, -111.34, 74.36, 169.69),
                vector4(996.26, -103.5, 74.14, 56.25),
                vector4(993.69, -92.0, 74.35, 196.75),
                vector4(990.61, -148.3, 74.24, 104.84),
                vector4(963.11, -143.75, 74.49, 44.89),
            },
            doorlock = {
                doorhash = -190780785,
                position = vector3(982.01, -135.59, 73.1),
            }
        },
        {
            car = vector4(518.46, 169.43, 99.35, 93.52),
            searchzone = 250.0,
            npc = {
                vector4(522.72, 154.5, 98.8, 289.04),
                vector4(535.5, 176.39, 100.17, 153.8),
                vector4(531.32, 182.09, 102.64, 180.41),
                vector4(569.4, 171.94, 100.43, 75.58),
                vector4(545.99, 139.02, 98.49, 33.59),
                vector4(523.11, 141.08, 98.04, 345.48),
            },
            doorlock = {
                doorhash = 1991494706,
                position = vector3(524.16, 167.48, 99.39),
            }
        },
        {
            car = vector4(-676.97, 902.96, 230.56, 163.66),
            searchzone = 250.0,
            npc = {
                vector4(-660.48, 894.93, 229.25, 337.53),
                vector4(-698.44, 919.82, 232.66, 340.36),
                vector4(-665.45, 954.89, 239.48, 172.28),
                vector4(-651.11, 951.15, 240.58, 138.03),
                vector4(-638.88, 943.69, 240.66, 119.29),
                vector4(-657.4, 893.69, 229.25, 23.25),
            },
            doorlock = {
                doorhash = -915091986,
                position = vector3(-674.14, 907.48, 230.53),
            }
        },
        {
            car = vector4(947.51, -1697.8, 30.06, 84.25),
            searchzone = 250.0,
            npc = {
                vector4(951.4, -1719.36, 30.67, 313.81),
                vector4(977.47, -1703.96, 29.88, 86.63),
                vector4(975.98, -1694.1, 29.4, 160.91),
                vector4(965.04, -1677.54, 29.12, 174.32),
                vector4(962.44, -1674.72, 30.06, 241.67),
                vector4(952.81, -1677.7, 30.06, 235.42),
            },
            doorlock = {
                doorhash = -982531572,
                position = vector3(951.27, -1698.23, 30.09),
            }
        },
        {
            car = vector4(147.17, 320.64, 112.12, 293.18),
            searchzone = 250.0,
            npc = {
                vector4(138.68, 324.12, 112.14, 115.1),
                vector4(155.74, 304.65, 112.12, 88.75),
                vector4(134.07, 322.61, 116.63, 203.92),
                vector4(120.3, 316.18, 112.14, 242.71),
                vector4(120.3, 316.18, 112.14, 242.71),
                vector4(120.3, 316.18, 112.14, 242.71),
            },
            doorlock = {
                doorhash = -915091986,
                position = vector3(143.03, 319.12, 112.14),
            }
        },
        {
            car = vector4(-401.88, 510.14, 120.18, 159.44),
            searchzone = 250.0,
            npc = {
                vector4(-410.15, 508.02, 121.61, 322.53),
                vector4(-410.15, 508.02, 121.61, 322.53),
                vector4(-385.6, 505.21, 120.41, 1.48),
                vector4(-385.6, 505.21, 120.41, 1.48),
                vector4(-388.98, 519.72, 121.34, 82.43),
                vector4(-388.98, 519.72, 121.34, 82.43),
            },
            doorlock = {
                doorhash = -264464292,
                position = vector3(-400.26, 513.73, 120.2),
            }
        },
    },
    ['S'] = {
        {
            car = vector4(-1155.68, -2007.55, 13.16, 351.16),
            searchzone = 250.0,
            npc = {
                vector4(-1165.54, -2014.33, 13.23, 357.72),
                vector4(-1169.83, -2013.48, 13.23, 292.38),
                vector4(-1165.82, -2018.49, 13.18, 320.04),
                vector4(-1155.05, -2022.31, 13.17, 11.35),
                vector4(-1148.25, -2013.25, 13.18, 11.64),
                vector4(-1140.75, -2006.95, 13.18, 77.25),
                vector4(-1149.31, -2001.72, 13.18, 49.99),
                vector4(-1153.51, -2003.93, 13.18, 333.64)
            },
            doorlock = {
                doorhash = -550347177,
                position = vector3(-1145.68, -1990.93, 13.16),
            }
        },
        {
            car = vector4(729.82, -1088.55, 22.15, 123.28),
            searchzone = 250.0,
            npc = {
                vector4(734.27, -1073.0, 22.23, 203.9),
                vector4(737.37, -1069.89, 22.23, 175.4),
                vector4(730.96, -1074.63, 28.19, 174.6),
                vector4(725.35, -1081.15, 26.17, 235.03),
                vector4(726.98, -1068.75, 22.17, 177.96),
                vector4(727.2, -1077.25, 22.17, 209.64)
            },
            doorlock = {
                doorhash = 270330101,
                position = vector3(722.67, -1088.65, 22.19),
            }
        }
    },
}

Config.NpcSettingByClass = {
    ['D'] = {
        pedArmor = 0,
        pedNoRagdoll = false,
        pedCombatMovement = 2, -- 0 : Stationary, 1 : Defensive, 2 : Offensive, 3 : Suicidal Offensive
        models = { --random list of npc
            `s_m_m_prisguard_01`,
            `mp_m_securoguard_01`,
        },
        weapons = { --random list of weapons
            'weapon_combatpistol',
        }
    },
    ['C'] = {
        pedArmor = 0,
        pedNoRagdoll = false,
        pedCombatMovement = 2, -- 0 : Stationary, 1 : Defensive, 2 : Offensive, 3 : Suicidal Offensive
        models = { --random list of npc
            `s_m_m_prisguard_01`,
            `mp_m_securoguard_01`,
        },
        weapons = { --random list of weapons
            'weapon_combatpistol',
        }
    },
    ['B'] = {
        pedArmor = 50,
        pedNoRagdoll = false,
        pedCombatMovement = 2, -- 0 : Stationary, 1 : Defensive, 2 : Offensive, 3 : Suicidal Offensive
        models = { --random list of npc
            `s_m_m_prisguard_01`,
            `mp_m_securoguard_01`,
        },
        weapons = { --random list of weapons
            'weapon_pistol',
            'weapon_combatpistol',
        }
    },
    ['A'] = {
        pedArmor = 100,
        pedNoRagdoll = true,
        pedCombatMovement = 3, -- 0 : Stationary, 1 : Defensive, 2 : Offensive, 3 : Suicidal Offensive
        models = { --random list of npc
            `s_m_m_prisguard_01`,
            `mp_m_securoguard_01`,
        },
        weapons = { --random list of weapons
            'weapon_pistol',
            'weapon_appistol',
            'weapon_pumpshotgun',
        }
    },
    ['S'] = {
        pedArmor = 200,
        pedNoRagdoll = true,
        pedCombatMovement = 3, -- 0 : Stationary, 1 : Defensive, 2 : Offensive, 3 : Suicidal Offensive
        models = { --random list of npc
            `mp_m_waremech_01`,
            `s_m_y_armymech_01`,
            `s_m_y_xmech_01`,
            `s_m_y_xmech_02`,
            `u_m_y_smugmech_01`,
        },
        weapons = { --random list of weapons
            'weapon_heavypistol',
            'weapon_bullpupshotgun',
            'weapon_assaultrifle',
        }
    },
}

Config.DeliveryLocations = {
    vector3(496.87, -2190.75, 5.92),
    vector3(1216.25, -2947.09, 5.87),
    vector3(861.66, -2911.77, 5.9),
    vector3(33.37, -2671.43, 6.01), 
}

Config.ScratchingDelay = 60 --seconds
Config.ScratchingLocations = {
    vector3(1430.56, 6332.89, 23.99),
    vector3(1637.43, 4850.97, 42.02)        
}
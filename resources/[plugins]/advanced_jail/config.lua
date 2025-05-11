Config = {}
Config.MenuLoc = 'center' --Where all esx mneus will shows up in this script
Config.Notifications = 'esx' --This either can be {esx, mythic, tnotify}
Config.SyncInterval = 2 --How often the server updates the database for times left on players
Config.MaxPerCell = 4 --How many are allowed per cell! Would recommend leaving high
Config.MinJail = 5 --Min amount someone can be intially jailed for
Config.MaxJail = 600 --Max amount someone can be intially jailed for


Config.ServerName = '' --Server name to show up on 2D text! If you want it to be blank leave it blank!

Config.PoliceNotifyTime = 5 --How long for police to know that someone escaped (in mins)
Config.PoliceRoles = { --All police roles so that they have access to search and use menu
    police = true,
    sheriff = true,
}
Config.PoliceRanks = { --All ranks for being able to use certain things on menu
    Jailing = {
        {Job = 'police', Grade = 0},
        {Job = 'sheriff', Grade = 0},
    },
    UnJail = {
        {Job = 'police', Grade = 1},
        {Job = 'sheriff', Grade = 1},
    },
    AddTime = {
        {Job = 'police', Grade = 0},
        {Job = 'sheriff', Grade = 0},
    },
    RemoveTime = {
        {Job = 'police', Grade = 1},
        {Job = 'sheriff', Grade = 1},
    },
    Send2Solitary = {
        {Job = 'police', Grade = 0},
        {Job = 'sheriff', Grade = 0},
    },
    RemoveFromSolitary = {
        {Job = 'police', Grade = 1},
        {Job = 'sheriff', Grade = 1},
    },
    Lockdown = {
        {Job = 'police', Grade = 1},
        {Job = 'sheriff', Grade = 1},
    },
    Message = {
        {Job = 'police', Grade = 0},
        {Job = 'sheriff', Grade = 0},
    }
}

Config.DefaultSetJob = {Name = 'unemployed', Grade = 0} --This is the default job that it will set if not saved somehow in database
Config.SimpleTime = true --This is if you wan the time to just be seconds, recommend leaving this to false

--General Configs
Config.SeeDist = 5 --How close you have to be to see 3D markers
Config.TextDist = 1 --How close you have to be to see 3D text
Config.TextLift = 0.3 --How much the 3D text is lifted over marker

Config.JailBlip = {Spawn = true, Sprite = 188, Color = 1, Size = 0.6} --All blip related things for the Prison Blip
Config.JailLoc = vector3(1702.8293457031, 2584.7778320312, 45.524826049805) --Location of the prison (usually center so that it doesn read wrong for checking location)
Config.TpBack = true --If players get tp'd back when they walk out of the jail without using script breakout (suggest to keep true)
Config.MaxTpDist = 250 --How far until it will tp you back
Config.MaxSolTpDist = 5 --How far you get from solitary before it tp's you back
Config.MaxMenuDist = 2 --How far you can walk before it auto closes your esx menu

Config.RanMessage = false --If it gives random notifactions for prisoners
Config.RanMessageTime = 5 --How often it sends a message (in mins)
--LockDown Configs
Config.StartLockCount = 60 --Starting time for lockdown (in seconds)
Config.WarnLockNums = {45, 30, 15, 10, 5, 4, 3, 2, 1} --All warning notifications for time on lockdown, make sure its within the number above

Config.LockDownDist = 4 --How far you can get from cell before it tp's you back or sends you to solitary

--Police Search Configs
Config.PoliceCanSearchInv = true --If police can search the inventories

Config.SeePoliceDist = 5 --How close you have to be to see 3D markers
Config.UsePoliceDist = 1 --How close you have to be to see 3D text
Config.PMarkNum = 22 --Marker Number
Config.PMarkColor = {r = 235, g = 116, b = 52} --Marker Colors
Config.PMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size

--Usable Item Configs
Config.ShankWeapon = 'weapon_knife' --Weapon name for shank (don't change)
Config.ShankItem = true --If the shank/weapon is used in hotbar inventory
Config.ShankAllowed = true --If you can use the shank

Config.BoozeAllowed = true --If you can use the booze item
Config.BoozeEffect = true --If taking booze has an effect
Config.BoozeGive = 80000 --How much thirst gives for drinking booze (out of 1,000,000)
Config.BoozeProp = nil --Prop to be spawned while using item (leave nil if you want default cup)
Config.BoozeEffectTime = 30 --How long the effect lasts

Config.PunchAllowed = true --If you can use the punch item
Config.PunchGive = 100000 --How much thirst gives for drinking punch (out of 1,000,000)
Config.PunchProp = nil --Prop to be spawned while using item (leave nil if you want default cup)

--Entering Guide
Config.HaveGuide = true --If there is a guide of the prison when they are first sent
Config.TimePer = 5 --How long per cam for guide (in seconds)

Config.PrisonCam = vector3(1845.1083984375, 2521.7490234375, 98.70295715332) --Position of the camera view 
Config.PrisonCamRot = {x = -35.0, y = 0.0, z = 90.0} --Rotation of the camera view 

Config.JobCam = vector3(1781.7301025391, 2578.5322265625, 45.797801971436) --Position of the camera view 
Config.JobCamRot = {x = 0.0, y = 0.0, z = 180.0} --Rotation of the camera view 

Config.SolCam = vector3(1763.8837890625, 2599.3374023438, 50.949644470215) --Position of the camera view (Only Will Show If Solitary Is On)
Config.SolCamRot = {x = -10.0, y = 0.0, z = 180.0} --Rotation of the camera view (Only Will Show If Solitary Is On)

Config.WorkOutCam = vector3(1772.5382080078, 2590.3508300781, 47.437080383301) --Position of the camera view (Only Will Show If WorkOut Is On)
Config.WorkOutCamRot = {x = -25.0, y = 0.0, z = 45.0} --Rotation of the camera view (Only Will Show If WorkOut Is On)

Config.ShowerCam = vector3(1760.6461181641, 2584.5795898438, 47.435832977295) --Position of the camera view (Only Will Show If Shower Is On)
Config.ShowerCamRot = {x = -20.0, y = 0.0, z = -160.0} --Rotation of the camera view (Only Will Show If Shower Is On)

Config.FoodCam = vector3(1779.5001220703, 2584.7756347656, 46.616794586182) --Position of the camera view 
Config.FoodCamRot = {x = 0.0, y = 0.0, z = 0.0} --Rotation of the camera view 

Config.HospitalCam = vector3(1777.0610351562, 2554.6008300781, 47.603786468506) --Position of the camera view (Only Will Show If Hospital Is On)
Config.HospitalCamRot = {x = -25.0, y = 0.0, z = -45.0} --Rotation of the camera view (Only Will Show If Hospital Is On)

Config.ItemCam = vector3(1827.9506835938, 2586.8864746094, 46.939308166504) --Position of the camera view (Only Will Show If There Is Items To Keep)
Config.ItemCamRot = {x = -10.0, y = 0.0, z = -110.0} --Rotation of the camera view (Only Will Show If There Is Items To Keep)

--Entering Prison Cutscene Configs (Don't touch this unless you know what you're doing!)
Config.GuardPed = 'csb_cop' --The ped that carries you in
Config.GuardSpawn = {Loc = vector3(405.60272216797, -1000.9990844727, -99.004028320312), Heading = 2.9} --Where the guard spawns
Config.HandCuffLoc = vector3(405.94161987305, -999.58270263672, -99.004028320312) --Where it spawns you
Config.ClothesLoc = {Loc = vector3(402.74792480469, -1000.0263671875, -99.004043579102), Heading = 183.02} --Where the gaurd carries you to
Config.ClothesProp = 'prop_cs_t_shirt_pile' --Prop that is in hands and on table
Config.ClothPropLoc = {Loc = vector3(402.36535644531, -1001.2421264648, -98.086471557617), Heading = 356.48} --Location of the prop spawn
Config.ComputerLoc = {Loc = vector3(401.48217773438, -1001.8327026367, -99.004035949707), Heading = 1.97} --Where the gaurd looks at his computer
Config.PointLoc = {Loc = vector3(402.08111572266, -1001.8852539062, -99.004035949707), Heading = 357.9} --Where the gaurd comes and points
Config.GrabLoc = {Loc = vector3(403.19427490234, -997.42065429688, -99.001533508301), Heading = 12.43} --Where the gaurd goes to grab the player after
Config.GrabTurnHead = 258.46 --Heading which faces the exit
Config.PedGrabHeading = 24.44 --Which heading you face when grabbed
Config.StopnLook = {Loc = vector3(403.37203979492, -1002.0308837891, -99.004119873047), Heading = 359.19} --Stop and go point for gaurd so they don't have issues
Config.StopnLook2 = 85.28 --Heading for second stop n go
Config.StopnTurn = {Loc = vector3(405.93243408203, -997.45745849609, -99.004119873047), Heading = 97.76} --Another stop n go poi
Config.Undressed = { --Undressed Player Outfit
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 21,
        ['pants_2']  = 0,   ['shoes_1']  = 34,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 14,   ['tshirt_2'] = 1,
        ['torso_1']  = 142,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 14,   ['pants_1']  = 194,
        ['pants_2']  = 5,  ['shoes_1']  = 35,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 5,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}
Config.EnterLoc = vector3(402.86895751953, -996.55413818359, -99.00025177002) --Sign Location
Config.EnterHeadings = {Front = 178.32, Side = 264.63} --Both Sign Headings
Config.WalkLoc = vector3(406.04782104492, -997.09332275391, -99.004028320312) --Final walk to desination in the hallway

Config.Cam = vector3(402.91775512695, -1002.5331420898, -99.004035949707) --Position of the camera view
Config.CamRot = {x = 0.0, y = 0.0, z = 0.0} --Rotation of the camera view

Config.DontTakeGunUponEntry = { --All weapons that arn't taken upon entering jail

}
Config.DontTakeItemsUponEntry = { --These are all the items that don't get taken upon entering the jail (whitelisting items)
    bread = true,
    water = true,
}
Config.DontGiveBackItems = { --These are all the items that it won't give back upon grabbing items when leaving (black listing items)
    coke_pooch = true,
    meth_pooch = true,
    molly_pooch = true,
    opium_pooch = true,
    perc_pooch = true,
    shroom_pooch = true,
    spice_pooch = true,
    weed_pooch = true,
    meth_raw = true,
    molly_tablet = true,
    opium = true,
    perc = true,
    shroom = true,
    spice_leaf = true,
    weed_leaf = true,
}

Config.AlertServerUponJail = true --Whether a chat message is sent when jailed

--Leave Configs
Config.LeaveLoc = {Loc = vector3(1830.3531494141, 2585.8728027344, 45.954323913574), Heading = 266.75} --Leave spawn location with heading

Config.LMarkNum = 22 --Marker Num for picking up items
Config.LMarkColor = {r = 235, g = 116, b = 52} --Marker Color for picking up items
Config.LMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size for picking up items
Config.ItemLoc = {Loc = vector3(1832.1635742188, 2584.6281738281, 45.952304840088), Heading = 185.68} --Location on where to pick up items
Config.ItemBlip = {Spawn = true, Sprite = 475, Color = 1, Size = 0.7} --Blip for picking up items
Config.ShowItemDist = 7 --Showing the 3d marker distance 
Config.ItemTextDist = 1 --Distance for showing 3dtext above marker
Config.RetreiveTime = 5 --How long it takes to grab items back (in seconds)

--Food Configs
Config.GetFoodLoc = {Loc = vector3(1779.6617431641, 2589.7705078125, 45.797813415527), Heading = 4.93} --Where you grab food in prison
Config.FoodBlip = {Spawn = true, Sprite = 272, Color = 2, Size = 0.7} --Blip on map for grabbing food in prison
Config.GrabFoodTime = 5 --How long it takes to grab the food (in seconds)
Config.EatTime = 7 --How long it takes to eat the food (in seconds)

Config.FoodAmt = 100000 --How much Hunger is added to esx_status (out of 1,000,000)
Config.DrinkAmt = 100000 --How much Thirst is added to esx_status (out of 1,000,000)

Config.FoMarkNum = 29 --Marker Num for food
Config.FoMarkColor = {r = 46, g = 166, b = 25} --Marker Color for food
Config.FoMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Marker Size for food

--Break Configs
Config.BrMarkNum = 32 --Marker Num for breaking out in cell location
Config.BrMarkColor = {r = 227, g = 122, b = 16} --Marker Color for breaking out in cell location
Config.BrMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Marker Size for breaking out in cell location

--Inventory Configs
Config.InvBlip = {Spawn = true, Sprite = 587, Color = 29, Size = 0.7} --Blip for the under the bed inventory

Config.OpenCloseTime = 5 --How long it takes to open or close the inventory (in seconds)
Config.ChMarkNum = 21 --Marker Num for bed inventory
Config.ChMarkColor = {r = 16, g = 83, b = 227} --Marker Color for bed inventory
Config.ChMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size for bed inventory


--Crafting Configs
Config.Crafts = { --All things that can be crafted with Old Man
    [1] = {
        Name = "Shank", --Name in menu of item
        Time = 20, --How long it takes to craft
        MakeItem = 'jail_shank', --The item name in DB of what is given
        Descripe = "You can use this for self defense!", --The description of this item
        Needed = { --These are all the needed items to make the item above
            [1] = {
                Name = "Broken Spoon", --Name of needed item
                Amount = 1, --How many needed
                Item = 'jail_jspoon' --Name in db of item thats needed
            },
            [2] = {
                Name = "Change",
                Amount = 2,
                Item = 'jail_sChange'
            }
        }
    },
    [2] = {
        Name = "Broken Spoon",
        Time = 8,
        MakeItem = 'jail_jspoon',
        Descripe = "You can use this for breaking out or for more crafting!",
        Needed = {
            [1] = {
                Name = "Spoon",
                Amount = 1,
                Item = 'jail_spoon'
            }
        }
    },
    [3] = {
        Name = "Broken Spoon With Wet Cloth",
        Time = 5,
        MakeItem = 'jail_bCloth',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Broken Spoon",
                Amount = 1,
                Item = 'jail_jspoon'
            },
            [2] = {
                Name = "Wet Cloth",
                Amount = 1,
                Item = 'jail_wCloth'
            }
        }
    },
    [4] = {
        Name = "Wet Cloth",
        Time = 10,
        MakeItem = 'jail_wCloth',
        Descripe = "You can use this for more crafting!",
        Needed = {
            [1] = {
                Name = "Cleaner",
                Amount = 1,
                Item = 'jail_cleaner'
            },
            [2] = {
                Name = "Cloth",
                Amount = 1,
                Item = 'jail_cloth'
            }
        }
    },
    [5] = {
        Name = "File",
        Time = 20,
        MakeItem = 'jail_file',
        Descripe = "You can use this for breaking out or more crafting!",
        Needed = {
            [1] = {
                Name = "Rock",
                Amount = 2,
                Item = 'jail_rock'
            },
            [2] = {
                Name = "Broken Ladle",
                Amount = 1,
                Item = 'jail_bLadle'
            }
        }
    },
    [6] = {
        Name = "Broken Ladle",
        Time = 5,
        MakeItem = 'jail_bLadle',
        Descripe = "You can use this for more crafting!",
        Needed = {
            [1] = {
                Name = "Ladle",
                Amount = 1,
                Item = 'jail_ladle'
            }
        }
    },
    [7] = {
        Name = "Sharp Metal",
        Time = 20,
        MakeItem = 'jail_sMetal',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Metal",
                Amount = 1,
                Item = 'jail_metal'
            },
            [2] = {
                Name = "Rock",
                Amount = 2,
                Item = 'jail_rock'
            },
            [3] = {
                Name = "File",
                Amount = 1,
                Item = 'jail_file'
            }
        }
    },
    [8] = {
        Name = "Acid",
        Time = 30,
        MakeItem = 'jail_acid',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Bottle",
                Amount = 1,
                Item = 'jail_bottle'
            },
            [2] = {
                Name = "Grease",
                Amount = 3,
                Item = 'jail_grease'
            },
            [3] = {
                Name = "Dirty Liquid",
                Amount = 1,
                Item = 'jail_dLiquid'
            },
            [4] = {
                Name = "Cleaner",
                Amount = 1,
                Item = 'jail_cleaner'
            },
            [5] = {
                Name = "Spoon",
                Amount = 1,
                Item = 'jail_spoon'
            }
        }
    },
    [9] = {
        Name = "Mini Hammer",
        Time = 25,
        MakeItem = 'jail_miniH',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Metal",
                Amount = 1,
                Item = 'jail_metal'
            },
            [2] = {
                Name = "Rock",
                Amount = 1,
                Item = 'jail_rock'
            },
            [3] = {
                Name = "Ladle",
                Amount = 1,
                Item = 'jail_ladle'
            },
            [4] = {
                Name = "Cloth",
                Amount = 1,
                Item = 'jail_cloth'
            }
        }
    },
    [10] = {
        Name = "Prison Punch",
        Time = 10,
        MakeItem = 'jail_pPunch',
        Descripe = "You can use this to tend to your thirst!",
        Needed = {
            [1] = {
                Name = "Dirty Liquid",
                Amount = 1,
                Item = 'jail_dLiquid'
            },
            [2] = {
                Name = "Flavor Packet",
                Amount = 3,
                Item = 'jail_fPacket'
            },
            [3] = {
                Name = "Bottle",
                Amount = 1,
                Item = 'jail_bottle'
            }
        }
    },
    [11] = {
        Name = "Immersion Heater",
        Time = 25,
        MakeItem = 'jail_iHeat',
        Descripe = "You can use this to distil alcohol!",
        Needed = {
            [1] = {
                Name = "Plug",
                Amount = 1,
                Item = 'jail_plug'
            },
            [2] = {
                Name = "Spare Change",
                Amount = 2,
                Item = 'jail_sChange'
            }
        }
    },
    [12] = {
        Name = "Booze",
        Time = 15,
        MakeItem = 'jail_booze',
        Descripe = "You can use this to get drunk!",
        Needed = {
            [1] = {
                Name = "Immersion Heater",
                Amount = 1,
                Item = 'jail_iHeat'
            },
            [2] = {
                Name = "Prison Punch",
                Amount = 1,
                Item = 'jail_pPunch'
            }
        }
    }
}

--Information Configs (Old Man Configs)
Config.InfoPed = 'csb_rashcosvki' --Model of the Old Man ped
Config.InfoPedChangeTime = 3 -- How long until the old man changes locations (in mins)
Config.InfoPedLoc = { --All the locations that the ped could be
    [1] = {Loc = vector3(1766.1560058594, 2578.0202636719, 50.549648284912), Heading = 72.44},
    [2] = {Loc = vector3(1761.7474365234, 2590.4455566406, 45.797859191895), Heading = 274.97},
    [3] = {Loc = vector3(1751.2590332031, 2500.419921875, 45.564975738525), Heading = 13.09},
    [4] = {Loc = vector3(1656.9559326172, 2548.5568847656, 45.564849853516), Heading = 320.8}
}
Config.InfoPedBlip = {Spawn = true, Sprite = 66, Color = 5, Size = 0.7} --All blip configs for the old man

Config.IMarkNum = 27 --Old man 3d marker num
Config.IMarkColor = {r = 227, g = 223, b = 16} --Old man 3d marker color
Config.IMarkSize = {x = 1.0, y = 1.0, z = 0.5} --Old man 3d marker size

--Job Manager Configs
Config.JobManLoc = {Loc = vector3(1779.51, 2572.5, 45.8), Heading = 1.98} --Job manager ped location
Config.JobManBlip = {Spawn = true, Sprite = 468, Color = 50, Size = 0.7} --Job manager blip
Config.JobManPed = 's_m_m_prisguard_01' --Job manager ped

Config.JMMarkNum = 27 --Job manager 3d marker num
Config.JMMarkColor = {r = 255, g = 0, b = 255} --Job manager 3d marker color
Config.JMMarkSize = {x = 1.0, y = 1.0, z = 0.5} --Job manager 3d marker size

Config.SeeTaskMark = 5 --How close you have to be to see the 3d marker
Config.SeeTaskText = 0.8 --How close you have to be to do the task
Config.JobOptions = {
    [1] = {
        Name = "Shower Cleaner",--Name of the job
        TimeRemove = 20, --How much time is removed for completing all the tasks (in seconds)
        StealChance = 3, --How likely it is to steal an item after completing task (3 = 30%, 5 = 50%, out of 100)
        StealItems = { --Items that can be stealing
            [1] = {Name = "Cleaner", Item = 'jail_cleaner', Chance = 5}, -- (Name = Name of the item, Item = DB Name of item, Chance = the chance out of 10 or in relation to percentage, 5 = 50%)
            [2] = {Name = "Dirty Liquid", Item = 'jail_dLiquid', Chance = 5} -- (Name = Name of the item, Item = DB Name of item, Chance = the chance out of 10 or in relation to percentage, 5 = 50%)
        },
        Tasks = { --All tasks in the job
            [1] = {
                TaskName = "Grab Cleaner", --Name of the task
                TaskLoc = {Loc = vector3(1778.0837402344, 2617.8605957031, 50.549789428711), Heading = 297.33}, --Location of the task
                Anim = {Dict = 'anim@amb@business@coc@coc_unpack_cut_left@', AnimName = 'coke_cut_v5_coccutter'}, --Anim that is played at the task (Dict = Dictionary Name, AnimName = Animation)
                Time = 7, --How long the animation is for (in seconds)
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7}, --All the blip configs for this task
                MarkNum = 20, --Marker Num for this task
                MarkColor = {r = 235, g = 116, b = 52}, --Marker Color for this task
                MarkSize = {x = 0.5, y = 0.5, z = 0.3}, --Marker Size for this task
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}, --If an item is attached for the animation (Attach = If it spawns something, Prop = Prop name, Offests = All offsets)
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}} --If an item is attached for walk in between tasks (Attach = If it spawns something, Prop = Prop name, Offests = All offsets)
            },
            [2] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1760.6225585938, 2585.6005859375, 45.797798156738), Heading = 92.04},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1762.6657714844, 2583.5739746094, 45.797824859619), Heading = 270.7},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1762.5876464844, 2581.4169921875, 45.797824859619), Heading = 268.69},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1762.8630371094, 2580.3664550781, 45.797824859619), Heading = 269.43},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1761.7651367188, 2577.5932617188, 45.797824859619), Heading = 179.22},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1765.2237548828, 2577.4904785156, 45.797824859619), Heading = 179.23},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1764.0091552734, 2580.4790039062, 45.797824859619), Heading = 90.25},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [9] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1764.0646972656, 2581.5734863281, 45.797824859619), Heading = 88.47},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [10] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1763.9431152344, 2582.6276855469, 45.797824859619), Heading = 87.7},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [11] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1764.1796875, 2583.6643066406, 45.797824859619), Heading = 88.88},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [12] = {
                TaskName = "Return Cleaner",
                TaskLoc = {Loc = vector3(1778.0551757812, 2617.8527832031, 50.549800872803), Heading = 293.78},
                Anim = {Dict = 'anim@amb@business@coc@coc_unpack_cut_left@', AnimName = 'coke_cut_v5_coccutter'},
                Time = 7,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [2] = {
        Name = "Cleaning Clothes",
        TimeRemove = 25,
        StealChance = 3,
        StealItems = {
            [1] = {Name = "Cleaner", Item = 'jail_cleaner', Chance = 5},
            [2] = {Name = "Cloth", Item = 'jail_cloth', Chance = 3},
            [3] = {Name = "Dirty Liquid", Item = 'jail_dLiquid', Chance = 7}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Dirty Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'anim@amb@business@coc@coc_unpack_cut_left@', AnimName = 'coke_cut_v5_coccutter'},
                Time = 15,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 15,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Put Clothes in Washer",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Put Clothes in Washer",
                TaskLoc = {Loc = vector3(1772.158203125, 2616.2888183594, 50.549766540527), Heading = 178.31},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Put Clothes in Washer",
                TaskLoc = {Loc = vector3(1770.8294677734, 2616.2634277344, 50.549770355225), Heading = 178.59},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Put Clothes in Washer",
                TaskLoc = {Loc = vector3(1769.4437255859, 2616.3513183594, 50.549770355225), Heading = 179.15},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Grab Wet Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Put Wet Clothes In Dryer",
                TaskLoc = {Loc = vector3(1773.6488037109, 2612.642578125, 50.549781799316), Heading = 358.21},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Grab Wet Clothes",
                TaskLoc = {Loc = vector3(1772.158203125, 2616.2888183594, 50.549766540527), Heading = 178.31},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [9] = {
                TaskName = "Put Wet Clothes In Dryer",
                TaskLoc = {Loc = vector3(1772.3046875, 2612.6450195312, 50.549781799316), Heading = 358.47},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [10] = {
                TaskName = "Grab Wet Clothes",
                TaskLoc = {Loc = vector3(1770.8294677734, 2616.2634277344, 50.549770355225), Heading = 178.59},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [11] = {
                TaskName = "Put Wet Clothes In Dryer",
                TaskLoc = {Loc = vector3(1770.9346923828, 2612.7666015625, 50.549781799316), Heading = 357.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second = 0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [12] = {
                TaskName = "Grab Wet Clothes",
                TaskLoc = {Loc = vector3(1769.4437255859, 2616.3513183594, 50.549770355225), Heading = 179.15},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [13] = {
                TaskName = "Put Wet Clothes In Dryer",
                TaskLoc = {Loc = vector3(1769.5684814453, 2612.8989257812, 50.549781799316), Heading = 355.68},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [14] = {
                TaskName = "Grab Dry Clothes",
                TaskLoc = {Loc = vector3(1773.6488037109, 2612.642578125, 50.549781799316), Heading = 358.21},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [15] = {
                TaskName = "Grab Dry Clothes",
                TaskLoc = {Loc = vector3(1772.3046875, 2612.6450195312, 50.549781799316), Heading = 358.47},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [16] = {
                TaskName = "Grab Dry Clothes",
                TaskLoc = {Loc = vector3(1770.9346923828, 2612.7666015625, 50.549781799316), Heading = 357.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [17] = {
                TaskName = "Grab Dry Clothes",
                TaskLoc = {Loc = vector3(1769.5684814453, 2612.8989257812, 50.549781799316), Heading = 355.68},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [18] = {
                TaskName = "Put Away Clothes",
                TaskLoc = {Loc = vector3(1776.8321533203, 2619.0104980469, 50.549781799316), Heading = 358.91},
                Anim = {Dict = 'anim@amb@business@coc@coc_unpack_cut_left@', AnimName = 'coke_cut_v5_coccutter'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 3, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [3] = {
        Name = "Laundry Runner",
        TimeRemove = 10,
        StealChance = 2,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'jail_bottle', Chance = 1},
            [2] = {Name = "Cloth", Item = 'jail_cloth', Chance = 6},
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Dirty Clothes",
                TaskLoc = {Loc = vector3(1765.7221679688, 2589.353515625, 45.797821044922), Heading = 225.55},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 235, b = 82},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Drop Off Dirty Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Dirty Clothes",
                TaskLoc = {Loc = vector3(1762.8428955078, 2591.8645019531, 45.797821044922), Heading = 86.71},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 235, b = 82},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Drop Off Dirty Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Dirty Clothes",
                TaskLoc = {Loc = vector3(1780.9899902344, 2616.197265625, 50.549968719482), Heading = 14.72},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 235, b = 82},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Drop Off Dirty Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Grab Dirty Clothes",
                TaskLoc = {Loc = vector3(1783.6166992188, 2610.7373046875, 50.550022125244), Heading = 264.04},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 235, b = 82},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_ld_tshirt_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Drop Off Dirty Clothes",
                TaskLoc = {Loc = vector3(1766.3508300781, 2612.4096679688, 50.549800872803), Heading = 173.91},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 2, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 52, g = 155, b = 235},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [4] = {
        Name = "Cook",
        TimeRemove = 25,
        StealChance = 4,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'jail_bottle', Chance = 2},
            [2] = {Name = "Grease", Item = 'jail_grease', Chance = 5},
            [3] = {Name = "Dirty Liquid", Item = 'jail_dLiquid', Chance = 5},
            [4] = {Name = "Spoon", Item = 'jail_spoon', Chance = 8},
            [5] = {Name = "Ladle", Item = 'jail_ladle', Chance = 7},
            [6] = {Name = "Flavor Packet", Item = 'jail_fPacket', Chance = 10}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Pan",
                TaskLoc = {Loc = vector3(1778.3149414062, 2593.6015625, 45.797836303711), Heading = 202.38},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_copper_pan', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Start Cooker",
                TaskLoc = {Loc = vector3(1777.9334716797, 2597.5095214844, 45.797836303711), Heading = 273.88},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Food",
                TaskLoc = {Loc = vector3(1776.4860839844, 2599.3669433594, 45.797836303711), Heading = 355.15},
                Anim = {Dict = 'mp_arresting', AnimName = 'a_uncuff'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'ng_proc_food_ornge1a', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Cook Food",
                TaskLoc = {Loc = vector3(1777.9334716797, 2597.5095214844, 45.797836303711), Heading = 273.88},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 20,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Boxes",
                TaskLoc = {Loc = vector3(1782.3448486328, 2594.396484375, 45.797836303711), Heading = 273.6},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'ng_proc_food_burg02a', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Set Boxes Down",
                TaskLoc = {Loc = vector3(1779.2886962891, 2593.552734375, 45.797836303711), Heading = 180.42},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Grab Cooked Food",
                TaskLoc = {Loc = vector3(1777.8962402344, 2597.3732910156, 45.797821044922), Heading = 267.45},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_copper_pan', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Set Cooked Food Down",
                TaskLoc = {Loc = vector3(1778.5102539062, 2592.2087402344, 45.797821044922), Heading = 359.12},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [9] = {
                TaskName = "Box Food",
                TaskLoc = {Loc = vector3(1779.1472167969, 2593.5998535156, 45.797821044922), Heading = 184.67},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'ng_proc_food_burg02a', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [10] = {
                TaskName = "Plate Food",
                TaskLoc = {Loc = vector3(1779.4445800781, 2592.0959472656, 45.797821044922), Heading = 355.66},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_food_bs_tray_02', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [11] = {
                TaskName = "Hand Food Out",
                TaskLoc = {Loc = vector3(1779.4532470703, 2591.4274902344, 45.797821044922), Heading = 176.83},
                Anim = {Dict = 'anim@amb@clubhouse@bar@drink@idle_a', AnimName = 'idle_a_bartender'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [5] = {
        Name = "Trash Cleaner",
        TimeRemove = 25,
        StealChance = 3,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'jail_bottle', Chance = 2},
            [2] = {Name = "Rock", Item = 'jail_rock', Chance = 5},
            [3] = {Name = "Broken Ladle", Item = 'jail_bLadle', Chance = 3},
            [4] = {Name = "Metal", Item = 'jail_metal', Chance = 4},
            [5] = {Name = "Broken Spoon", Item = 'jail_jspoon', Chance = 6},
            [6] = {Name = "Spare Change", Item = 'jail_sChange', Chance = 6},
            [7] = {Name = "Plug", Item = 'jail_plug', Chance = 4}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1704.4982910156, 2551.7905273438, 45.564895629883), Heading = 91.44},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1700.7912597656, 2555.5249023438, 45.56489944458), Heading = 188.0},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1719.0423583984, 2501.5693359375, 45.564853668213), Heading = 275.89},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1719.6976318359, 2503.8447265625, 45.564853668213), Heading = 274.05},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [9] = {
                TaskName = "Grab Empty Bags",
                TaskLoc = {Loc = vector3(1778.1514892578, 2617.6296386719, 50.549797058105), Heading = 299.56},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [10] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1704.4982910156, 2551.7905273438, 45.564895629883), Heading = 91.44},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [11] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1700.7912597656, 2555.5249023438, 45.56489944458), Heading = 188.0},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [12] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1719.0423583984, 2501.5693359375, 45.564853668213), Heading = 275.89},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [13] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1719.6976318359, 2503.8447265625, 45.564853668213), Heading = 274.05},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    }
}

--Uniform Configs
Config.Uniforms = { --The outfit for the uniforms
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 146, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 0,   ['pants_1']  = 5,
        ['pants_2']  = 7,   ['shoes_1']  = 6,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 118,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 4,   ['pants_1']  = 4,
        ['pants_2']  = 5,  ['shoes_1']  = 16,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}

--Cell Configs
Config.Cells = { --All cells in the prison
    [1] = {
        SpawnLoc = {Loc = vector3(1789.7060546875, 2586.0852050781, 45.997824859619), Heading = 86.1}, --Spawning in location (usually the middle of cell)
        InvLoc = {Loc = vector3(1789.7662353516, 2585.2568359375, 45.797847747803), Heading = 177.59}, --Inventory location or Bed location
        BreakLoc = {Loc = vector3(1791.3540039062, 2584.5427246094, 45.797824859619), Heading = 254.95}, --Breaking out location 
        ExitLoc = {Loc = vector3(1792.7447509766, 2586.0417480469, 45.665006256104), Heading = 277.17} --Exit after crawling throug for breakout (usually on outside of building)
    },
    [2] = {
        SpawnLoc = {Loc = vector3(1789.3695068359, 2582.1096191406, 45.997824859619), Heading = 87.1},
        InvLoc = {Loc = vector3(1789.7458496094, 2581.2800292969, 45.797847747803), Heading = 181.38},
        BreakLoc = {Loc = vector3(1791.2578125, 2582.8991699219, 45.797824859619), Heading = 268.85},
        ExitLoc = {Loc = vector3(1792.7575683594, 2582.9362792969, 45.669316864014), Heading = 270.17}
    },
    [3] = {
        SpawnLoc = {Loc = vector3(1789.5477294922, 2578.2443847656, 45.997824859619), Heading = 89.74},
        InvLoc = {Loc = vector3(1789.6511230469, 2577.4191894531, 45.797840118408), Heading = 181.67},
        BreakLoc = {Loc = vector3(1791.3548583984, 2577.4995117188, 45.797824859619), Heading = 265.34},
        ExitLoc = {Loc = vector3(1792.9602050781, 2576.8312988281, 45.664994812012), Heading = 271.07}
    },
    [4] = {
        SpawnLoc = {Loc = vector3(1789.6387939453, 2574.2951660156, 45.997824859619), Heading = 88.14},
        InvLoc = {Loc = vector3(1789.7381591797, 2573.4255371094, 45.797836303711), Heading = 179.11},
        BreakLoc = {Loc = vector3(1791.3410644531, 2574.7377929688, 45.797824859619), Heading = 267.31},
        ExitLoc = {Loc = vector3(1792.7788085938, 2574.1337890625, 45.67181930542), Heading = 272.06}
    },
    [5] = {
        SpawnLoc = {Loc = vector3(1769.3889160156, 2573.8337402344, 45.997824859619), Heading = 271.53},
        InvLoc = {Loc = vector3(1769.1588134766, 2574.6359863281, 45.797836303711), Heading = 359.83},
        BreakLoc = {Loc = vector3(1767.5228271484, 2572.84765625, 45.797824859619), Heading = 89.97},
        ExitLoc = {Loc = vector3(1758.7697753906, 2568.9208984375, 45.670770263672), Heading = 179.05}
    },
    [6] = {
        SpawnLoc = {Loc = vector3(1769.2884521484, 2577.7653808594, 45.997798156738), Heading = 271.51},
        InvLoc = {Loc = vector3(1769.1553955078, 2578.4772949219, 45.797836303711), Heading = 359.88},
        BreakLoc = {Loc = vector3(1767.4603271484, 2579.1987304688, 45.79780960083), Heading = 87.33},
        ExitLoc = {Loc = vector3(1753.0543212891, 2566.626953125, 45.665174102783), Heading = 219.48}
    },
    [7] = {
        SpawnLoc = {Loc = vector3(1769.2357177734, 2581.5166015625, 45.99780960083), Heading = 269.83},
        InvLoc = {Loc = vector3(1769.1595458984, 2582.5224609375, 45.797836303711), Heading = 1.58},
        BreakLoc = {Loc = vector3(1767.5593261719, 2581.09765625, 45.79780960083), Heading = 89.33},
        ExitLoc = {Loc = vector3(1722.1971435547, 2598.5705566406, 45.664910888672), Heading = 85.51}
    },
    [8] = {
        SpawnLoc = {Loc = vector3(1769.2230224609, 2585.5700683594, 45.99780960083), Heading = 277.97},
        InvLoc = {Loc = vector3(1769.1461181641, 2586.4357910156, 45.797836303711), Heading = 1.67},
        BreakLoc = {Loc = vector3(1767.5482177734, 2586.337890625, 45.79780960083), Heading = 79.03},
        ExitLoc = {Loc = vector3(1758.4462890625, 2589.9626464844, 45.672082519531), Heading = 82.03}
    },
    [9] = {
        SpawnLoc = {Loc = vector3(1785.5012207031, 2601.5302734375, 50.749713134766), Heading = 170.6},
        InvLoc = {Loc = vector3(1786.3489990234, 2601.681640625, 50.549682617188), Heading = 170.94},
        BreakLoc = {Loc = vector3(1787.0032958984, 2603.1701660156, 50.549674987793), Heading = 300.04},
        ExitLoc = {Loc = vector3(1787.9368896484, 2621.6682128906, 55.568738555908), Heading = 353.32}
    },
    [10] = {
        SpawnLoc = {Loc = vector3(1789.3742675781, 2597.7961425781, 50.749686431885), Heading = 85.54},
        InvLoc = {Loc = vector3(1789.505859375, 2597.0419921875, 50.549674987793), Heading = 182.1},
        BreakLoc = {Loc = vector3(1791.0850830078, 2598.8977050781, 50.549648284912), Heading = 312.08},
        ExitLoc = {Loc = vector3(1793.4119873047, 2597.4797363281, 50.549686431885), Heading = 271.54}
    },
    [11] = {
        SpawnLoc = {Loc = vector3(1789.5588378906, 2593.9780273438, 50.749682617188), Heading = 95.18},
        InvLoc = {Loc = vector3(1789.4688720703, 2593.1052246094, 50.549674987793), Heading = 180.26},
        BreakLoc = {Loc = vector3(1791.0808105469, 2592.4436035156, 50.549674987793), Heading = 266.7},
        ExitLoc = {Loc = vector3(1792.5063476562, 2590.3471679688, 50.549644470215), Heading = 259.79}
    },
    [12] = {
        SpawnLoc = {Loc = vector3(1789.5648193359, 2589.9360351562, 50.749682617188), Heading = 90.52},
        InvLoc = {Loc = vector3(1789.5354003906, 2589.1411132812, 50.549674987793), Heading = 181.37},
        BreakLoc = {Loc = vector3(1791.0660400391, 2589.3720703125, 50.549682617188), Heading = 265.44},
        ExitLoc = {Loc = vector3(1792.3619384766, 2589.2690429688, 50.549682617188), Heading = 280.44}
    },
    [13] = {
        SpawnLoc = {Loc = vector3(1789.7143554688, 2586.0202636719, 50.74967880249), Heading = 86.06},
        InvLoc = {Loc = vector3(1789.5093994141, 2585.2253417969, 50.549674987793), Heading = 180.85},
        BreakLoc = {Loc = vector3(1791.0834960938, 2586.611328125, 50.54967880249), Heading = 272.62},
        ExitLoc = {Loc = vector3(1792.3813476562, 2586.5346679688, 50.54967880249), Heading = 266.62}
    },
    [14] = {
        SpawnLoc = {Loc = vector3(1789.5427246094, 2582.0017089844, 50.74967880249), Heading = 84.61},
        InvLoc = {Loc = vector3(1789.4792480469, 2581.4289550781, 50.549667358398), Heading = 181.04},
        BreakLoc = {Loc = vector3(1791.0854492188, 2583.099609375, 50.549682617188), Heading = 299.56},
        ExitLoc = {Loc = vector3(1792.3929443359, 2582.7661132812, 50.549682617188), Heading = 267.4}
    },
    [15] = {
        SpawnLoc = {Loc = vector3(1789.6608886719, 2578.1564941406, 50.749682617188), Heading = 92.28},
        InvLoc = {Loc = vector3(1789.5045166016, 2577.3391113281, 50.549667358398), Heading = 181.04},
        BreakLoc = {Loc = vector3(1791.0764160156, 2577.482421875, 50.54967880249), Heading = 299.78},
        ExitLoc = {Loc = vector3(1792.3698730469, 2577.6137695312, 50.54967880249), Heading = 248.78}
    },
    [16] = {
        SpawnLoc = {Loc = vector3(1789.6860351562, 2574.1623535156, 50.74967880249), Heading = 85.52},
        InvLoc = {Loc = vector3(1789.5131835938, 2573.2880859375, 50.549663543701), Heading = 181.66},
        BreakLoc = {Loc = vector3(1791.0576171875, 2572.830078125, 50.54967880249), Heading = 252.54},
        ExitLoc = {Loc = vector3(1792.3802490234, 2573.1860351562, 50.549674987793), Heading = 267.48}
    },
    [17] = {
        SpawnLoc = {Loc = vector3(1785.9571533203, 2568.546875, 50.749640655518), Heading = 354.54},
        InvLoc = {Loc = vector3(1785.1077880859, 2568.3430175781, 50.549663543701), Heading = 94.24},
        BreakLoc = {Loc = vector3(1786.5700683594, 2567.3422851562, 50.549648284912), Heading = 170.67},
        ExitLoc = {Loc = vector3(1786.3596191406, 2566.0595703125, 50.655014038086), Heading = 170.67}
    },
    [18] = {
        SpawnLoc = {Loc = vector3(1781.9460449219, 2568.5207519531, 50.749648284912), Heading = 354.54},
        InvLoc = {Loc = vector3(1781.3151855469, 2568.31640625, 50.549663543701), Heading = 90.14},
        BreakLoc = {Loc = vector3(1781.2250976562, 2567.3444824219, 50.549633026123), Heading = 170.54},
        ExitLoc = {Loc = vector3(1781.01171875, 2566.0622558594, 50.653945922852), Heading = 170.54}
    },
    [19] = {
        SpawnLoc = {Loc = vector3(1777.9897460938, 2568.4787597656, 50.749674987793), Heading = 353.39},
        InvLoc = {Loc = vector3(1777.3060302734, 2568.3034667969, 50.549674987793), Heading = 94.3},
        BreakLoc = {Loc = vector3(1778.8114013672, 2567.2932128906, 50.549686431885), Heading = 182.02},
        ExitLoc = {Loc = vector3(1778.8533935547, 2566.0939941406, 50.654499053955), Heading = 182.02}
    },
    [20] = {
        SpawnLoc = {Loc = vector3(1774.1789550781, 2568.4877929688, 50.749644470215), Heading = 359.2},
        InvLoc = {Loc = vector3(1773.4216308594, 2568.2927246094, 50.549652099609), Heading = 94.1},
        BreakLoc = {Loc = vector3(1773.6292724609, 2567.3210449219, 50.549644470215), Heading = 176.38},
        ExitLoc = {Loc = vector3(1773.5793457031, 2566.2719726562, 50.549644470215), Heading = 173.38}
    },
    [21] = {
        SpawnLoc = {Loc = vector3(1769.3565673828, 2573.7731933594, 50.749644470215), Heading = 269.33},
        InvLoc = {Loc = vector3(1769.6387939453, 2574.7053222656, 50.549652099609), Heading = 0.56},
        BreakLoc = {Loc = vector3(1768.052734375, 2572.8659667969, 50.549644470215), Heading = 95.46},
        ExitLoc = {Loc = vector3(1762.2921142578, 2568.4255371094, 55.439956665039), Heading = 96.7}
    },
    [22] = {
        SpawnLoc = {Loc = vector3(1769.8432617188, 2577.8327636719, 50.749644470215), Heading = 268.72},
        InvLoc = {Loc = vector3(1769.6157226562, 2578.6518554688, 50.549652099609), Heading = 3.09},
        BreakLoc = {Loc = vector3(1768.0277099609, 2579.1931152344, 50.549644470215), Heading = 90.71},
        ExitLoc = {Loc = vector3(1759.328125, 2579.0798339844, 55.447151184082), Heading = 90.71}
    },
    [23] = {
        SpawnLoc = {Loc = vector3(1769.6654052734, 2581.6948242188, 50.749640655518), Heading = 267.45},
        InvLoc = {Loc = vector3(1769.5592041016, 2582.5307617188, 50.549652099609), Heading = 3.62},
        BreakLoc = {Loc = vector3(1767.9350585938, 2581.25, 50.549640655518), Heading = 66.72},
        ExitLoc = {Loc = vector3(1759.5678710938, 2580.3923339844, 55.437309265137), Heading = 96.67}
    },
    [24] = {
        SpawnLoc = {Loc = vector3(1769.5938720703, 2585.609375, 50.749644470215), Heading = 268.73},
        InvLoc = {Loc = vector3(1769.5998535156, 2586.4814453125, 50.549652099609), Heading = 359.06},
        BreakLoc = {Loc = vector3(1767.9349365234, 2584.5981445312, 50.549644470215), Heading = 92.05},
        ExitLoc = {Loc = vector3(1759.5157470703, 2585.5126953125, 55.452182769775), Heading = 98.75}
    },
    [25] = {
        SpawnLoc = {Loc = vector3(1769.5305175781, 2589.7097167969, 50.749686431885), Heading = 267.88},
        InvLoc = {Loc = vector3(1769.5876464844, 2590.4455566406, 50.549652099609), Heading = 359.67},
        BreakLoc = {Loc = vector3(1768.0327148438, 2589.103515625, 50.549686431885), Heading = 88.46},
        ExitLoc = {Loc = vector3(1759.3814697266, 2589.8505859375, 55.438919067383), Heading = 92.57}
    },
    [26] = {
        SpawnLoc = {Loc = vector3(1769.7008056641, 2593.5534667969, 50.749644470215), Heading = 269.47},
        InvLoc = {Loc = vector3(1769.5700683594, 2594.3120117188, 50.549652099609), Heading = 0.81},
        BreakLoc = {Loc = vector3(1768.0305175781, 2594.9470214844, 50.549644470215), Heading = 83.24},
        ExitLoc = {Loc = vector3(1759.5305175781, 2594.8474121094, 55.43803024292), Heading = 98.24}
    },
    [27] = {
        SpawnLoc = {Loc = vector3(1769.7208251953, 2597.4226074219, 50.749644470215), Heading = 266.67},
        InvLoc = {Loc = vector3(1769.6168212891, 2598.3002929688, 50.549652099609), Heading = 359.83},
        BreakLoc = {Loc = vector3(1768.0040283203, 2598.1389160156, 50.549644470215), Heading = 89.31},
        ExitLoc = {Loc = vector3(1759.4516601562, 2598.236328125, 55.44762802124), Heading = 89.31}
    },
    [28] = {
        SpawnLoc = {Loc = vector3(1773.2811279297, 2601.6760253906, 50.749663543701), Heading = 177.11},
        InvLoc = {Loc = vector3(1774.2319335938, 2601.6437988281, 50.549652099609), Heading = 271.94},
        BreakLoc = {Loc = vector3(1772.8643798828, 2603.2199707031, 50.549663543701), Heading = 89.31},
        ExitLoc = {Loc = vector3(1771.9135742188, 2621.5512695312, 55.45592880249), Heading = 345.73}
    }
}

--Solitary Configs
Config.Solitary = true --If you want there to be solitary

Config.Sol4Run = true --If you want solitary for when they run away without using the jail script (ex. Using emotes to get through fences and other stuff)
Config.SolRunTime = 1 --Time in mins for the one above

Config.FailBreakToSol = true --If you want solitary for when they fail to breakout in time
Config.SolBreakTime = 1 --Time in mins for the one above

Config.Sol4Lock = false --If you want solitary for when they try to leave their cell on lockdown
Config.SolLockTime = 1 --Time in mins for the one above

Config.Sol4Kill = true --IF you want solitary for when you kill someone
Config.SolKillTime = 1 --Time in mins for the one above

Config.SolCells = { --All of the solitary locations
    [1] = {Loc = vector3(1765.9615478516, 2597.2072753906, 50.549640655518), Heading = 89.81},
    [2] = {Loc = vector3(1765.9827880859, 2594.2705078125, 50.54963684082), Heading = 93.12},
    [3] = {Loc = vector3(1765.9401855469, 2591.3493652344, 50.549640655518), Heading = 89.13},
    [4] = {Loc = vector3(1765.7937011719, 2588.3737792969, 50.549644470215), Heading = 93.71},
    [5] = {Loc = vector3(1762.1220703125, 2588.2312011719, 50.549640655518), Heading = 271.49},
    [6] = {Loc = vector3(1762.0230712891, 2591.0876464844, 50.549640655518), Heading = 269.32},
    [7] = {Loc = vector3(1762.1560058594, 2594.0744628906, 50.549644470215), Heading = 268.63},
    [8] = {Loc = vector3(1761.8892822266, 2597.021484375, 50.549640655518), Heading = 278.27}
}

--Revive Configs
Config.Hospital = true --If you want the hospital
Config.DoctorPed = 's_m_m_doctor_01' --Doctor ped for the hospital
Config.CheckUpTime = 10 --How long it takes to checkup a prisoner (in secs)
Config.BedLocs = {
    [1] = {
        SpawnLoc = {Loc = vector3(1777.4617919922, 2565.4919433594, 46.722312927246), Heading = 268.2}, --Ped Spawn location
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93}, --Doctor spawn location
        DocCheck = {Loc = vector3(1779.1821289062, 2564.9467773438, 45.797836303711), Heading = 65.82}, --Where the doctor walks to, to check up
        DocWalkTime = 7 --How long it should take the doctor to walk there (in secs)
    },
    [2] = {
        SpawnLoc = {Loc = vector3(1777.5457763672, 2563.3625488281, 46.722332000732), Heading = 267.57},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1779.0882568359, 2563.4348144531, 45.797836303711), Heading = 89.79},
        DocWalkTime = 6
    },
    [3] = {
        SpawnLoc = {Loc = vector3(1777.6226806641, 2561.3317871094, 46.722328186035), Heading = 269.24},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1779.2280273438, 2561.4267578125, 45.797836303711), Heading = 90.0},
        DocWalkTime = 5
    },
    [4] = {
        SpawnLoc = {Loc = vector3(1777.57421875, 2558.9553222656, 46.722305297852), Heading = 267.91},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1779.1295166016, 2559.0458984375, 45.797824859619), Heading = 87.48},
        DocWalkTime = 5
    },
    [5] = {
        SpawnLoc = {Loc = vector3(1781.6727294922, 2565.5573730469, 46.722312927246), Heading = 84.24},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1780.111328125, 2564.7570800781, 45.797824859619), Heading = 292.52},
        DocWalkTime = 7
    },
    [6] = {
        SpawnLoc = {Loc = vector3(1781.6551513672, 2563.4787597656, 46.722332000732), Heading = 88.82},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1780.013671875, 2563.4584960938, 45.797824859619), Heading = 270.36},
        DocWalkTime = 6
    },
    [7] = {
        SpawnLoc = {Loc = vector3(1781.6934814453, 2561.5017089844, 46.722312927246), Heading = 90.87},
        DoctorSpawn = {Loc = vector3(1777.5787353516, 2555.0952148438, 45.797794342041), Heading = 189.93},
        DocCheck = {Loc = vector3(1780.1590576172, 2561.4636230469, 45.797824859619), Heading = 268.96},
        DocWalkTime = 6
    }
}

--All Breaking Out Configs
Config.Breakout = true --If prisoners can breakout of the prison
Config.BreakHole = 2 --How many successful digs they need

Config.CrawlTime = 15 --How long it takes to crawl through the wall (in secs)
Config.BreakoutTime = 120  --How long they are able to breakout before being caught (in seconds)

Config.BreakMarkNum = 22 --Breakout marker num
Config.BreakMarkColor = {r = 255, g = 255, b = 255} --Breakout marker color
Config.BreakMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Breakout marker size

Config.SeeBreakDist = 15 --How close you have to be to see the markers
Config.BreakTextDist = 1 --How close you have to be to use
Config.BreakBlips = {Spawn = true, Sprite = 186, Color = 49, Size = 0.5} --Blips for all breakout / cutting locations

Config.BreakLocs = { --All cutting / digging locations when breaking out (StartLoc is the location to do the anim and the marker, ExitLoc is where they are tp'd, ExitFence is only true if its the last exit before they are completely out of the prison)
    [1] = {StartLoc = {Loc = vector3(1806.3610839844, 2531.4916992188, 45.506214141846), Heading = 288.92}, ExitLoc = {Loc = vector3(1807.9256591797, 2531.9982910156, 45.506652832031), Heading = 285.75}, ExitFence = false}, 
    [2] = {StartLoc = {Loc = vector3(1809.7244873047, 2508.5112304688, 45.457614898682), Heading = 283.54}, ExitLoc = {Loc = vector3(1811.3291015625, 2508.8952636719, 45.457614898682), Heading = 283.48}, ExitFence = false},
    [3] = {StartLoc = {Loc = vector3(1790.8776855469, 2457.107421875, 45.479621887207), Heading = 234.54}, ExitLoc = {Loc = vector3(1792.2528076172, 2456.1962890625, 45.479621887207), Heading = 287.84}, ExitFence = false},
    [4] = {StartLoc = {Loc = vector3(1775.9188232422, 2441.3542480469, 45.439235687256), Heading = 233.33}, ExitLoc = {Loc = vector3(1777.6038818359, 2440.0998535156, 45.439235687256), Heading = 283.33}, ExitFence = false},
    [5] = {StartLoc = {Loc = vector3(1724.5666503906, 2417.2282714844, 45.438968658447), Heading = 190.83}, ExitLoc = {Loc = vector3(1724.9614257812, 2415.1672363281, 45.438968658447), Heading = 190.83}, ExitFence = false},
    [6] = {StartLoc = {Loc = vector3(1691.9315185547, 2412.2934570312, 45.428443908691), Heading = 186.27}, ExitLoc = {Loc = vector3(1692.1114501953, 2410.6525878906, 45.428447723389), Heading = 186.27}, ExitFence = false},
    [7] = {StartLoc = {Loc = vector3(1624.4016113281, 2428.8767089844, 45.434959411621), Heading = 155.76}, ExitLoc = {Loc = vector3(1623.6633300781, 2427.2360839844, 45.433925628662), Heading = 155.76}, ExitFence = false},
    [8] = {StartLoc = {Loc = vector3(1580.7204589844, 2456.4575195312, 45.453197479248), Heading = 150.39}, ExitLoc = {Loc = vector3(1579.8312988281, 2454.8930664062, 45.451251983643), Heading = 150.39}, ExitFence = false},
    [9] = {StartLoc = {Loc = vector3(1551.0321044922, 2507.4912109375, 45.442741394043), Heading = 102.38}, ExitLoc = {Loc = vector3(1548.9813232422, 2507.0400390625, 45.442741394043), Heading = 102.38}, ExitFence = false},
    [10] = {StartLoc = {Loc = vector3(1549.2059326172, 2553.435546875, 45.448348999023), Heading = 94.47}, ExitLoc = {Loc = vector3(1547.4114990234, 2553.294921875, 45.448348999023), Heading = 94.47}, ExitFence = false},
    [11] = {StartLoc = {Loc = vector3(1555.7008056641, 2609.8635253906, 45.43217086792), Heading = 66.16}, ExitLoc = {Loc = vector3(1553.7633056641, 2610.4404296875, 45.431995391846), Heading = 74.34}, ExitFence = false},
    [12] = {StartLoc = {Loc = vector3(1570.4975585938, 2649.8615722656, 45.430034637451), Heading = 77.84}, ExitLoc = {Loc = vector3(1568.4450683594, 2650.3024902344, 45.430034637451), Heading = 77.84}, ExitFence = false},
    [13] = {StartLoc = {Loc = vector3(1598.7795410156, 2692.2275390625, 45.414165496826), Heading = 54.58}, ExitLoc = {Loc = vector3(1597.4354248047, 2693.18359375, 45.414165496826), Heading = 54.58}, ExitFence = false},
    [14] = {StartLoc = {Loc = vector3(1635.0993652344, 2727.2709960938, 45.431541442871), Heading = 57.41}, ExitLoc = {Loc = vector3(1633.7095947266, 2728.1599121094, 45.431541442871), Heading = 57.41}, ExitFence = false},
    [15] = {StartLoc = {Loc = vector3(1680.9978027344, 2748.4436035156, 45.513088226318), Heading = 14.11}, ExitLoc = {Loc = vector3(1680.5450439453, 2750.4870605469, 45.543704986572), Heading = 355.39}, ExitFence = false},
    [16] = {StartLoc = {Loc = vector3(1745.5191650391, 2750.9538574219, 45.542251586914), Heading = 2.11}, ExitLoc = {Loc = vector3(1745.4588623047, 2752.6025390625, 45.542247772217), Heading = 2.11}, ExitFence = false},
    [17] = {StartLoc = {Loc = vector3(1791.0699462891, 2734.2351074219, 45.404987335205), Heading = 322.09}, ExitLoc = {Loc = vector3(1792.2680664062, 2735.7744140625, 45.404987335205), Heading = 322.09}, ExitFence = false},
    [18] = {StartLoc = {Loc = vector3(1817.7440185547, 2712.5649414062, 45.476692199707), Heading = 324.15}, ExitLoc = {Loc = vector3(1819.060546875, 2714.388671875, 45.476692199707), Heading = 324.15}, ExitFence = false},
    [19] = {StartLoc = {Loc = vector3(1828.8676757812, 2674.0642089844, 45.486404418945), Heading = 256.23}, ExitLoc = {Loc = vector3(1831.4047851562, 2674.646484375, 45.354648590088), Heading = 258.15}, ExitFence = false},
    [20] = {StartLoc = {Loc = vector3(1818.7711181641, 2645.3774414062, 45.348693847656), Heading = 260.1}, ExitLoc = {Loc = vector3(1820.6928710938, 2645.041015625, 45.348693847656), Heading = 260.1}, ExitFence = false},
    [21] = {StartLoc = {Loc = vector3(1772.18359375, 2535.2783203125, 45.564914703369), Heading = 242.16}, ExitLoc = {Loc = vector3(1773.2451171875, 2534.7177734375, 45.564914703369), Heading = 242.16}, ExitFence = false},
    [22] = {StartLoc = {Loc = vector3(1723.4884033203, 2489.8776855469, 45.564838409424), Heading = 186.26}, ExitLoc = {Loc = vector3(1723.6029052734, 2488.8334960938, 45.564838409424), Heading = 186.26}, ExitFence = false},
    [23] = {StartLoc = {Loc = vector3(1662.0093994141, 2487.1945800781, 45.564903259277), Heading = 142.98}, ExitLoc = {Loc = vector3(1661.3770751953, 2486.35546875, 45.564903259277), Heading = 142.98}, ExitFence = false},
    [24] = {StartLoc = {Loc = vector3(1682.1802978516, 2679.4465332031, 45.564884185791), Heading = 18.41}, ExitLoc = {Loc = vector3(1681.7540283203, 2680.7275390625, 45.564884185791), Heading = 18.41}, ExitFence = false},
    [25] = {StartLoc = {Loc = vector3(1739.771484375, 2678.1396484375, 45.564884185791), Heading = 6.5}, ExitLoc = {Loc = vector3(1739.6357421875, 2679.3310546875, 45.564884185791), Heading = 6.5}, ExitFence = false},
    [26] = {StartLoc = {Loc = vector3(1816.478515625, 2527.4321289062, 43.414501190186), Heading = 285.83}, ExitLoc = {Loc = vector3(1817.9105224609, 2527.8410644531, 45.671981811523), Heading = 285.83}, ExitFence = true},
    [27] = {StartLoc = {Loc = vector3(1791.41796875, 2442.8901367188, 43.414661407471), Heading = 237.53}, ExitLoc = {Loc = vector3(1793.2797851562, 2442.3059082031, 45.378692626953), Heading = 234.75}, ExitFence = true},
    [28] = {StartLoc = {Loc = vector3(1706.1419677734, 2404.3161621094, 43.414566040039), Heading = 193.26}, ExitLoc = {Loc = vector3(1706.5561523438, 2402.623046875, 45.418384552002), Heading = 195.3}, ExitFence = true},
    [29] = {StartLoc = {Loc = vector3(1601.6594238281, 2431.8190917969, 43.414520263672), Heading = 151.75}, ExitLoc = {Loc = vector3(1600.7275390625, 2429.994140625, 45.46654510498), Heading = 154.19}, ExitFence = true},
    [30] = {StartLoc = {Loc = vector3(1539.9753417969, 2535.681640625, 43.411609649658), Heading = 94.72}, ExitLoc = {Loc = vector3(1537.3840332031, 2535.4677734375, 45.400444030762), Heading = 94.72}, ExitFence = true},
    [31] = {StartLoc = {Loc = vector3(1555.5706787109, 2638.220703125, 43.40873336792), Heading = 80.13}, ExitLoc = {Loc = vector3(1553.6495361328, 2638.5546875, 45.380565643311), Heading = 80.13}, ExitFence = true},
    [32] = {StartLoc = {Loc = vector3(1612.7268066406, 2719.677734375, 43.389865875244), Heading = 48.96}, ExitLoc = {Loc = vector3(1610.7020263672, 2721.3942871094, 45.390205383301), Heading = 49.79}, ExitFence = true},
    [33] = {StartLoc = {Loc = vector3(1722.103515625, 2759.9365234375, 43.389808654785), Heading = 5.83}, ExitLoc = {Loc = vector3(1721.8388671875, 2762.5234375, 45.469844818115), Heading = 5.83}, ExitFence = true},
    [34] = {StartLoc = {Loc = vector3(1811.4265136719, 2730.2138671875, 43.389869689941), Heading = 325.4}, ExitLoc = {Loc = vector3(1812.5876464844, 2731.9035644531, 45.41854095459), Heading = 324.84}, ExitFence = true},
    [35] = {StartLoc = {Loc = vector3(1832.2895507812, 2654.2846679688, 43.200504302979), Heading = 257.19}, ExitLoc = {Loc = vector3(11834.8247070312, 2653.7084960938, 45.467952728271), Heading = 257.19}, ExitFence = true}
}


Config.RoomTools = { --All the tools for cell and exit locations
    [1] = {
        Name = "Broken Spoon", --Name of the tool
        Item = 'jail_jspoon', --DB item name of the tool
        Time = 10, --How long it takes to use
        Percent = 2 --Percentage chance of it working (ex. 2 = 20%)
    },
    [2] = {
        Name = "Broken Spoon With Wet Cloth",
        Item = 'jail_bCloth',
        Time = 7,
        Percent = 5
    },
    [3] = {
        Name = "Sharp Metal",
        Item = 'jail_sMetal',
        Time = 5,
        Percent = 8
    },
    [4] = {
        Name = "Acid",
        Item = 'jail_acid',
        Time = 20,
        Percent = 8
    },
    [5] = {
        Name = "Mini Hammer",
        Item = 'jail_miniH',
        Time = 25,
        Percent = 9
    }
}

Config.FenceTool = { --Tools for fences that are not exit locations
    [1] = {
        Name = "File", --Name of the tool
        Item = 'jail_file', --DB name of the tool
        Time = 10, --How long it takes
        Percent = 4 --Percentage of it working (ex. 4 = 40%)
    },
    [2] = {
        Name = "Sharp Metal",
        Item = 'jail_sMetal',
        Time = 4,
        Percent = 7
    },
    [3] = {
        Name = "Acid",
        Item = 'jail_acid',
        Time = 20,
        Percent = 9
    },
    [4] = {
        Name = "Mini Hammer",
        Item = 'jail_miniH',
        Time = 15,
        Percent = 7
    },
    [5] = {
        Name = "Immersion Heater",
        Item = 'jail_iHeat',
        Time = 20,
        Percent = 9
    }
}


Config.WatchMarkNum = 1 --Watch tower marker num
Config.WatchMarkColor = {r = 255, g = 0, b = 0} --Color of watch tower marker

Config.WatchBlip = {Spawn = true, Sprite = 181, Color = 1, Size = 0.7} --Watch tower blip configs
Config.WatchDist = 20.0 --How big the circle is or how close you have to be
Config.MaxWatchDist = 150 --How far you have to get to fully escape
Config.SeeWatchDist = 75 --How close you have to be to see the 3d circle
Config.WatchTowers = { --All watch tower locations
    [1] = vector3(1823.9467773438, 2621.1137695312, 45.8014793396),
    [2] = vector3(1848.8317871094, 2699.4509277344, 45.8014793396),
    [3] = vector3(1773.2802734375, 2762.8894042969, 45.8014793396),
    [4] = vector3(1649.5051269531, 2758.0935058594, 45.8014793396),
    [5] = vector3(1569.8160400391, 2680.447265625, 45.8014793396),
    [6] = vector3(1534.6882324219, 2585.3349609375, 45.550983428955),
    [7] = vector3(1540.5181884766, 2469.6254882812, 45.550983428955),
    [8] = vector3(1658.923828125, 2394.5964355469, 45.550983428955),
    [9] = vector3(1761.4342041016, 2410.2609863281, 45.550983428955),
    [10] = vector3(1824.2727050781, 2475.5314941406, 45.550983428955),
    [11] = vector3(1822.5385742188, 2574.7231445312, 45.67200088501)
}

--Showering Configs
Config.Showers = true --If you want there to be showers in the prison
Config.ShowerLoc = {Loc = vector3(1762.8851318359, 2585.8771972656, 45.7978515625), Heading = 182.28} --Change location for the showers
Config.ShowerBlip = {Spawn = true, Sprite = 365, Color = 29, Size = 0.7} -- Blip configs for the shower

Config.ShowMarkNum = 21 --Shower 3d marker num
Config.ShowMarkColor = {r = 50, g = 109, b = 168} --Shower 3d marker color
Config.ShowMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Shower 3d marker size

Config.GetReadyTime = 5 --How long it takes to change
Config.ShowerFullDist = 7 --How close you have to be to see the 3d marker
Config.ShowerMarkerDist = 10 --How close you have to see intial marker
Config.ShowerDist = 1 --How close you have to be to use the shower
Config.MaxDistShower = 20 --How far you can get before it cancels the shower

Config.ShowerLocs = { --All shower locations
    [1] = vector3(1762.7790527344, 2584.0666503906, 45.797847747803),
    [2] = vector3(1762.7525634766, 2583.0002441406, 45.797847747803),
    [3] = vector3(1762.7590332031, 2581.9731445312, 45.797847747803),
    [4] = vector3(1762.6904296875, 2580.8610839844, 45.797847747803),
    [5] = vector3(1762.4088134766, 2579.8779296875, 45.797847747803),
    [6] = vector3(1764.2062988281, 2579.9309082031, 45.797847747803),
    [7] = vector3(1764.3111572266, 2581.0004882812, 45.797847747803),
    [8] = vector3(1764.3537597656, 2582.1296386719, 45.797847747803),
    [9] = vector3(1764.1920166016, 2583.0842285156, 45.797847747803),
    [10] = vector3(1764.1859130859, 2584.1840820312, 45.797847747803)
}

Config.ShowerFit = { --Shower outfit (should be a naked ped or ped with trousers on)
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 21,
        ['pants_2']  = 0,   ['shoes_1']  = 34,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 15,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 15,
        ['pants_2']  = 0,  ['shoes_1']  = 35,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}

--Working Out
Config.WorkingOut = true --If you can workout in prison

Config.WorkOutBlip = {Spawn = true, Sprite = 354, Color = 1, Size = 0.7} --All blip configs for workout areas

Config.WoutMarkNum = 21 --Workout 3d Marker Nums
Config.WoutMarkColor = {r = 255, g = 0, b = 0} --Workout 3d Marker Colors
Config.WoutMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Workout 3d Marker Size

Config.WorkoutLocs = { --All diffrent workout areas
    [1] = {
        StartLoc = {Loc = vector3(1768.513671875, 2589.7006835938, 45.797824859619), Heading = 184.95}, --Starting location for changing in this area
        Locs = { --All workout locations in area (Label = Name of task, Loc = location of marker, Heading = direction you are facing, Anim.Dict = Animation Dictionary / Scenario, Anim.Aim = Animation thats played within that Dictionary(leave nil if scenario), Time = How long it plays anim (in secs))
            [1] = {Label = "Punching Bag", Loc = vector3(1769.8293457031, 2593.0849609375, 45.797824859619), Heading = 90.53, Anim = {Dict = 'anim@mp_player_intcelebrationmale@shadow_boxing', Aim = 'shadow_boxing'}, Time = 10},
            [2] = {Label = "Punching Bag", Loc = vector3(1766.4663085938, 2593.1018066406, 45.797824859619), Heading = 90.56, Anim = {Dict = 'anim@mp_player_intcelebrationmale@shadow_boxing', Aim = 'shadow_boxing'}, Time = 10},
            [3] = {Label = "Pullups", Loc = vector3(1773.2098388672, 2594.9787597656, 45.797824859619), Heading = 273.08, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [4] = {Label = "Pullups", Loc = vector3(1773.1776123047, 2596.8159179688, 45.797824859619), Heading = 268.73, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [5] = {Label = "Pushups", Loc = vector3(1769.6988525391, 2594.8115234375, 45.797824859619), Heading = 92.1, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [6] = {Label = "Pushups", Loc = vector3(1766.0317382812, 2594.7741699219, 45.797824859619), Heading = 92.1, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [7] = {Label = "Yoga", Loc = vector3(1767.1796875, 2597.2023925781, 45.797824859619), Heading = 357.68, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [8] = {Label = "Yoga", Loc = vector3(1770.4311523438, 2597.5068359375, 45.797824859619), Heading = 269.02, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10}
        }
    },
    [2] = {
        StartLoc = {Loc = vector3(1645.4556884766, 2536.8881835938, 45.56489944458), Heading = 224.19},
        Locs = {
            [1] = {Label = "Pullups", Loc = vector3(1648.861328125, 2529.6850585938, 45.56489944458), Heading = 232.36, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [2] = {Label = "Pullups", Loc = vector3(1643.1571044922, 2527.9553222656, 45.56489944458), Heading = 230.56, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [3] = {Label = "Pushups", Loc = vector3(1645.3740234375, 2525.0317382812, 45.56489944458), Heading = 229.27, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [4] = {Label = "Pushups", Loc = vector3(1647.0649414062, 2527.0151367188, 45.56489944458), Heading = 229.75, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [5] = {Label = "Yoga", Loc = vector3(1639.0922851562, 2531.6369628906, 45.56489944458), Heading = 50.31, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [6] = {Label = "Yoga", Loc = vector3(1636.4968261719, 2528.7780761719, 45.56489944458), Heading = 50.95, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [7] = {Label = "Yoga", Loc = vector3(1641.2993164062, 2534.5576171875, 45.564907073975), Heading = 50.68, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [8] = {Label = "Situps", Loc = vector3(1635.4010009766, 2524.4096679688, 45.564907073975), Heading = 140.72, Anim = {Dict = 'amb@world_human_sit_ups@male@idle_a', Aim = 'idle_a'}, Time = 10},
            [9] = {Label = "Situps", Loc = vector3(1637.3043212891, 2522.7822265625, 45.564907073975), Heading = 140.01, Anim = {Dict = 'amb@world_human_sit_ups@male@idle_a', Aim = 'idle_a'}, Time = 10}
        }
    }
}

Config.SeeWorkDist = 7 --How close you have to be to see 3D marker
Config.WorkReadyTime = 5 --How long it takes to get ready for a workout (in secs)
Config.MaxDistWorkout = 10 --How far you have to be for it to auto cancel workout
Config.WorkText = 1 --How close you have to be to see work text
Config.WorkoutFit = { --Workout fit for female and male
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 42,
        ['pants_2']  = 2,   ['shoes_1']  = 6,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 15,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 2,
        ['pants_2']  = 0,  ['shoes_1']  = 16,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}


--All Sayings
Config.RanMessages = {
    [1] = "You smell! Go take a shower!",
    [2] = "You're lookin weak! Go workout!",
    [3] = "You're being lazy! Go do your job!"
}

Config.Sayings = { --All sayings in the whole script
    [1] = "Prison",
    [2] = "Doing Task",
    [3] = " ~y~Jail~w~ | Time Left:~r~ ",
    [4] = "(s) ~w~| Job =~o~ ",
    [5] = "You Are Being Sent To Jail",
    [6] = "None",
    [7] = " ",
    [8] = "  ",
    [9] = "Jail Job Manager",
    [10] = "Old Man",
    [11] = "Jail Item Retreival",
	[12] = "[~p~E~w~] Retreive Items",
    [13] = "Grabbing Belongings",
    [14] = "[~p~E~w~] Job Manager",
    [15] = "Available Jobs",
    [16] = "No Job",
    [17] = "Tasks: ",
    [18] = "Time Deduction: ",
    [19] = "Start Job",
    [20] = "You chose a job! Go do the tasks!",
    [21] = "",
    [22] = "[~y~E~w~] ",
    [23] = "Doing Task",
    [24] = "You completed a task! Go to the next task!",
    [25] = "You completed all the tasks! Your time was reduced and tasks reset!",
    [26] = "Task: ",
    [27] = "[~y~E~w~] Old Man",
    [28] = "[~o~E~w~] Start Digging",
    [29] = "[~b~E~w~] Lift Bed",
    [30] = "[~g~E~w~] Get Food",
    [31] = "Inventory",
    [32] = "Food Court",
    [33] = "No Items",
    [34] = "Under the Bed",
    [35] = "Lifting Bed",
    [36] = "Lowering Bed",
    [37] = "How many do you want to pull out?",
    [38] = "Invalid Amount/Message",
    [39] = "Amount is too much",
    [40] = "Remove Items",
    [41] = "Add Items",
    [42] = "How many would you like to add?",
    [43] = "Grabbing tray of food",
    [44] = "[~y~E~w~] Eat Food [~g~G~w~] Throw Away",
    [45] = "What would you like to talk about?",
    [46] = "Breaking out of here",
    [47] = "Making Items",
    [48] = "What were you looking to make?",
    [49] = "What about breaking out?",
    [50] = "What I need",
    [51] = "Make it",
    [52] = "Needed",
    [53] = " ~r~Solitary ~w~| Time Left: ~y~",
    [54] = "~w~(~r~s~w~)",
    [55] = "Jailing Info",
    [56] = "ID: ",
    [57] = "Time: ",
    [58] = "Time: None",
    [59] = "Reason",
    [60] = "Confirm",
    [61] = "Change ID For Jailing",
    [62] = "Jail Time is too long, above max Jail Time!",
    [63] = "Change Time Amount",
    [64] = "Reason For Jailing",
    [65] = "Edit Reason",
    [66] = "Confirm Reason",
    [67] = "See Reason",
    [68] = "Reason For Jail",
    [69] = "None",
    [70] = "The Doctor Is Checking You Up",
    [71] = "What would you like to know?",
    [72] = "Breaking Out Of Cell",
    [73] = "Breaking Through Fence 1",
    [74] = "Breaking Through Fence 2",
    [75] = "Description",
    [76] = "Tools that can be used",
    [77] = "You need a tool to dig through the wall! Once you make a hole you can climb through!",
    [78] = "You need a tool to cut through the fence! Once you cut through you can climb through!",
    [79] = "You need a tool to dig through the ground and wall! Once you make a hole you can crawl out!",
    [80] = "Time: ",
    [81] = "~w~(~y~s~w~)",
    [82] = "Success Percentage: ",
    [83] = "Missing Items To Craft",
    [84] = "Action Not Possible",
    [85] = "Crafting",
    [86] = "You stole a ",
    [87] = "What would you like to dig with?",
    [88] = "You do not have this item!",
    [89] = "[~o~E~w~] Break Out",
    [90] = "You your dig was successful",
    [91] = "Your tool broke",
    [92] = "You Are ~b~Breaking Out~w~! | Time Until Gaurds Notice:~o~ ",
    [93] = "[~g~E~w~] Cut Fence",
    [94] = "What would you like to cut with?",
    [95] = "You don't have this item!",
    [96] = "Digging",
    [97] = "Cutting",
    [98] = "Dig / Cut",
    [99] = "Watch Tower",
    [100] = "You have to successfully dig ",
    [101] = " times to go through the wall!",
    [102] = "You finished digging! Crawl through the hole to start your escape!",
    [103] = "That ID is not in jail!",
    [104] = "(s) was added to your sentence!",
    [105] = "Your reason is invalid",
    [106] = "Your ID is invalid",
    [107] = "Your time is invalid",
    [108] = "Failed To Break Out In Time",
    [109] = "Got To Far From Prison",
    [110] = "Killed Someone In Prison",
    [111] = "You walked too far away and the Menu Closed!",
    [112] = "Showers",
    [113] = "[~b~E~w~] Get Ready For Shower",
    [114] = "Changing Clothes",
    [115] = "Go to one of the showers",
    [116] = "[~b~G~w~] Shower",
    [117] = "Shower Cancelled! You walked to far away!",
    [118] = "Showering",
    [119] = "Working Out",
    [120] = "[~r~E~w~] Start Working Out",
    [121] = "You are working out! Go and use one of the machines or use the ground!",
    [122] = "[~r~G~w~] ",
    [123] = "Working Out",
    [124] = "Workout Cancelled! You walked to far away!",
    [125] = "Workout Ended",
    [126] = "[~r~E~w~] End Working Out",
    [127] = "Invalid ID",
    [128] = "Jail Someone",
    [129] = "UnJail Someone",
    [130] = "Add Time to Someone",
    [131] = "Remove Time from Someone",
    [132] = "Send Someone to Solitary",
    [133] = "Jail Options",
    [134] = "Enter ID of Player",
    [135] = "No Players Nearby",
    [136] = "Solitary Is Not Allowed",

    [137] = " ~y~Jail~w~ | Time:~r~ ",
    [138] = " | Job =~o~ ",
    [139] = "Eating",
    [140] = " was added to your sentence!",
    [141] = "Time is too much to remove!",
    [142] = " was removed from your sentence!",
    [143] = "(s) was removed from your sentence!",
    [144] = "Remove Someone From Solitary",
    [145] = "Lockdown: ",
    [146] = "On",
    [147] = "Off",
    [148] = "Can't Turn On/Off Lockdown, Currently Counting Down!",
    [149] = "(s) Until Lockdown! Get to Your Cell!",
    [150] = "Left Cell During Lockdown",
    [151] = "No Longer in LockDown",
    [152] = "You are now in LockDown!",
    [153] = "LockDown Started, Will be in Effect in ",
    [154] = "(s)!",
    [155] = "All Players In This Cell",
    [156] = " | ID: ",
    [157] = "'s Bed",
    [158] = "[~o~E~w~] Lift Bed",
    [159] = "Action Not Allowed",
    [160] = "Prison",
    [161] = "Crawling Through Hole",
    [162] = "Cant use!",
    [163] = "You drank some booze!",
    [164] = "You drank some punch!",
    [165] = "Notify All Prisoners",
    [166] = "What would you like to tell them?",
    [167] = "Can't confirm! Invalid reason!",
    [168] = "[Prison Intercom] : ",

    [169] = "In This Prison You Can",
    [170] = "~y~Work A Job To Get Time Removed",
    [171] = "~g~Grab Food To Eat",
    [172] = "~r~Get Sent To Solitary",
    [173] = "~o~Workout To Get Strong",
    [174] = "~b~Take Showers To Stay Clean",
    [175] = "~r~Get Help From A Doctor",
    [176] = "~y~Retrive Items Upon Release",
    [177] = "~g~Much More Hidden Things",
    [178] = " Is Not In Their Cell! They Escaped The Jail!",
    [179] = "Jail Time is too short, below min Jail Time!",
}
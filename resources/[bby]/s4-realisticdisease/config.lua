Config = {}

Config.DebugMode = false -- if true will enable debug mode  

Config.RemoveInjuresWhenRevive = true -- if true when player revive will remove all injures else doctor will need to heal player

Config.UseTarget = true -- if true will use target else will use closest player

Config.OnlyWithAim = false -- if true player will need to aim to damage player else will damage player without aim

Config.Jobs = { "ambulance", "police" } -- job name that can heal players

Config.ItemSelfTreatment = "bandage" -- item name for self treatment

Config.UsingQbLastStand = false -- if true will use laststand anim else will use default laststand

Config.StopBleedingTime = 1 -- minutes

Config.Key = 'o' -- key to open menu

-- Config.AlwaysOpenHudKey = '' -- key to open hud

Config.ReverseHud = true -- if true will reverse hud else will not reverse hud

Config.GetNameFromSQL = true -- if true will get name from sql else will get name from server (ESX)
 
Config.EnableBleeding = false -- if true will enable bleeding

Config.BleedingHitDamage = 1 -- how many times player can bleed 

Config.BleedingPerMillisecond = 2500 -- how many seconds player will bleed

Config.BleedingMultiplier = 1 -- how many times player will bleed

Config.DisableSetPlayerHealthRecharge = false -- if true will disable recharge player health

Config.EnableRevive = true -- if true will enable revive you need to change revive function urs ambulancejob  (config.lua line 132.)
-- for adaptation we not give support for this

Config.ExperimentalFeatures = false -- activating fall damage and traffic accident damage

Config.Theme = 'cyan' -- cyan, red
 
Config.Functions = {} -- dont touch this
 
 
Config.Functions.PlayAnim = function(lib, anim)
    RequestAnimDict(lib)
    while not HasAnimDictLoaded(lib) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    Citizen.SetTimeout(2500, function()
        ClearPedTasksImmediately(PlayerPedId())
    end)
end
 
Config.Anims = {  -- you can change animations here
    ["check"] = {
        lib = 'amb@medic@standing@timeofdeath@enter',
        anim = 'enter',
    },
    ["heal"] = {
        lib = 'anim@mp_player_intcelebrationfemale@knuckle_crunch',
        anim = 'knuckle_crunch',
    },
    ["treat"] = {
        lib = 'anim@mp_player_intcelebrationfemale@knuckle_crunch',
        anim = 'knuckle_crunch',
    },
    ["fail"] = {
        lib = 'move_m@_idles@shake_off',
        anim = 'shakeoff_1',
    },
    ["revive"] = {
        lib = 'anim@mp_player_intcelebrationfemale@knuckle_crunch',
        anim = 'knuckle_crunch',
    },
}
 
Config.ItemsForHeal = {
    ["head"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["body"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["chest"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["lleg"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["rleg"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["rarm"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["larm"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["rfoot"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    },
    ["lfoot"] = {
        "gauze", "pill", "surgical_gloves", "surgical_staple", "forceps", "syringe", "tape", "iodine", "bandageg", "surgical_tray" 
    }
}

Config.Framework = ''

if GetResourceState('es_extended') ~= 'missing' then
    ESX = exports['es_extended']:getSharedObject()
    Config.Framework = 'ESX'
else
    QBCore = exports['qb-core']:GetCoreObject()
    Config.Framework = 'QBCore'
end


Notify = function(type, msg, title)
    if GetResourceState('es_extended') ~= 'missing' then
        ESX.ShowNotification(msg)
    else
        QBCore.Functions.Notify(msg, type)
    end
end



Revive = function(playerId)
    n = false
    for i = 0, GetNumResources(), 1 do
        local resource_name = GetResourceByFindIndex(i)
        if resource_name == "esx_ambulancejob" and GetResourceState(resource_name) == "started" then
            TriggerServerEvent('esx_ambulancejob:revive', playerId)
            n = true
            break
        end
        if resource_name == "qb-ambulancejob" and GetResourceState(resource_name) == "started" then
            TriggerServerEvent("s4-realisticdisease:qbrev", playerId) 
            TriggerServerEvent('hospital:server:RevivePlayer', playerId) 
            n = true
            break
        end
        if resource_name == "wasabi_ambulance" and GetResourceState(resource_name) == "started" then
            exports.wasabi_ambulance:RevivePlayer(playerId)
            n = true
            break
        end
        if resource_name == "ak47_ambulancejob" and GetResourceState(resource_name) == "started" then
            TriggerServerEvent('ak47_ambulancejob:revive', playerId)
            n = true
            break
        end
        if resource_name == "ak47_qb_ambulancejob" and GetResourceState(resource_name) == "started" then
            TriggerServerEvent('ak47_qb_ambulancejob:revive', playerId)
            n = true
            break
        end
        if resource_name == "brutal_ambulancejob" and GetResourceState(resource_name) == "started" then
            TriggerServerEvent("s4-realisticdisease:brutalrev", playerId) 
            n = true
            break
        end
    end

    if n == false then 
        TriggerServerEvent('txAdmin:events:healedPlayer', {id = playerId})
    end

    Config.Functions.PlayAnim(Config.Anims["revive"].lib, Config.Anims["revive"].anim)
    TriggerServerEvent('s4-realisticdisease:stopBlooding', playerId)
end

Config.Lang = "en"

Config.Langs = {
    ["en"] = {
        ["succeed_treat"] = "You succeed to treat the patient",
        ["failed_treat"] = "You failed to treat the patient",
        ["no_money"] = "You don't have enough money to treat the patient!",
        ["no_skill"] = "We're sorry, but you're not skilled enough to perform this surgery!",
        ["no_item"] = "We're sorry, but you're not skilled enough to perform this surgery!",
        ["wrong"] = "We're sorry, but you're not skilled enough to perform this surgery!",
        ["start_bleeding"] = "Your bleeding has been stopped.",
        ["stop_bleeding"] = "The medicine wore off and you started bleeding again.",
        ["fail_bleed"] = "You're wounded again and you're bleeding!",
        ["traffic"] = "Traffic Accident",
        ["knifed"] = "Stabbed with knife",
        ["fdm"] = "Fall Damage",
        ["bullets"] = "Bullets",
        ["fist"] = "Fist attack",
        ["notdc"] = "Not detected!"
    }
}
 
Config.PlayerBones = {
    ['RFoot'] = 52301,
    ['LFoot'] = 14201,
    ['RKnee'] = 36864,
    ['LKnee'] = 63931,
    ['Head'] = 31086,
    ['RArm'] = 28252,
    ['LArm'] = 61163,
    ['Chest'] = 24818,
}

Config.BoneLabelText = {
    [52301] = { name = "RFoot", Label = "Right Foot", unity = 'RFoot' },
    [14201] = { name = "LFoot", Label = "Left Foot", unity = 'LFoot' },
    [36864] = { name = "RKnee", Label = "Right Leg", unity = 'RKnee' },
    [63931] = { name = "LKnee", Label = "Left Leg", unity = 'LKnee' },
    [31086] = { name = "Head", Label = "Head" , unity = 'Head' },
    [28252] = { name = "RArm", Label = "Right Arm", unity = 'RArm' },
    [61163] = { name = "LArm", Label = "Left Arm", unity = 'LArm' },
    [24818] = { name = "Chest", Label = "Body", unity = 'Chest' },
}
 
Config.items = {
    ["forceps"] = "forceps.png",
    ["gauze"] = "gauze.png",
    ["iodine"] = "iodine.png",
    ["pill"] = "pill.png",
    ["surgical_gloves"] = "surgical_gloves.png",
    ["surgical_staple"] = "surgical_staple.png",
    ["surgical_tray"] = "surgical_tray.png",
    ["syringe"] = "syringe.png",
    ["tape"] = "tape.png",
} -- import items your server database
 


Config.WeaponsLabel = { -- edit here for weapon labels
    [-1075685676] = "WEAPON_PISTOL_MK2",
    [126349499] = "WEAPON_SNOWBALL",
    [-270015777] = "WEAPON_ASSAULTSMG",
    [615608432] = "WEAPON_MOLOTOV",
    [2024373456] = "WEAPON_SMG_MK2",
    [-1810795771] = "WEAPON_POOLCUE",
    [-1813897027] = "WEAPON_GRENADE",
    [-598887786] = "WEAPON_MARKSMANPISTOL",
    [-1654528753] = "WEAPON_BULLPUPSHOTGUN",
    [-72657034] = "GADGET_PARACHUTE",
    [-102323637] = "WEAPON_BOTTLE",
    [2144741730] = "WEAPON_COMBATMG",
    [-1121678507] = "WEAPON_MINISMG",
    [-1652067232] = "WEAPON_SWEEPERSHOTGUN",
    [961495388] = "WEAPON_ASSAULTRIFLE_MK2",
    [-86904375] = "WEAPON_CARBINERIFLE_MK2",
    [-1786099057] = "WEAPON_BAT",
    [177293209] = "WEAPON_HEAVYSNIPER_MK2",
    [600439132] = "WEAPON_BALL",
    [1432025498] = "WEAPON_PUMPSHOTGUN_MK2",
    [-1951375401] = "WEAPON_FLASHLIGHT",
    [171789620] = "WEAPON_COMBATPDW",
    [1593441988] = "WEAPON_COMBATPISTOL",
    [-2009644972] = "WEAPON_SNSPISTOL_MK2",
    [2138347493] = "WEAPON_FIREWORK",
    [1649403952] = "WEAPON_COMPACTRIFLE",
    [-619010992] = "WEAPON_MACHINEPISTOL",
    [-952879014] = "WEAPON_MARKSMANRIFLE",
    [317205821] = "WEAPON_AUTOSHOTGUN",
    [-1420407917] = "WEAPON_PROXMINE",
    [-1045183535] = "WEAPON_REVOLVER",
    [94989220] = "WEAPON_COMBATSHOTGUN",
    [-1658906650] = "WEAPON_MILITARYRIFLE",
    [1198256469] = "WEAPON_RAYCARBINE",
    [2132975508] = "WEAPON_BULLPUPRIFLE",
    [1627465347] = "WEAPON_GUSENBERG",
    [984333226] = "WEAPON_HEAVYSHOTGUN",
    [1233104067] = "WEAPON_FLARE",
    [-1716189206] = "WEAPON_KNIFE",
    [940833800] = "WEAPON_STONE_HATCHET",
    [1305664598] = "WEAPON_GRENADELAUNCHER_SMOKE",
    [727643628] = "WEAPON_CERAMICPISTOL",
    [-1074790547] = "WEAPON_ASSAULTRIFLE",
    [-1169823560] = "WEAPON_PIPEBOMB",
    [324215364] = "WEAPON_MICROSMG",
    [-1834847097] = "WEAPON_DAGGER",
    [-1466123874] = "WEAPON_MUSKET",
    [-1238556825] = "WEAPON_RAYMINIGUN",
    [-1063057011] = "WEAPON_SPECIALCARBINE",
    [1470379660] = "WEAPON_GADGETPISTOL",
    [584646201] = "Ap Pistol",
    [-494615257] = "WEAPON_ASSAULTSHOTGUN",
    [-771403250] = "WEAPON_HEAVYPISTOL",
    [1672152130] = "WEAPON_HOMINGLAUNCHER",
    [338557568] = "WEAPON_PIPEWRENCH",
    [1785463520] = "WEAPON_MARKSMANRIFLE_MK2",
    [-1355376991] = "WEAPON_RAYPISTOL",
    [101631238] = "WEAPON_FIREEXTINGUISHER",
    [1119849093] = "WEAPON_MINIGUN",
    [883325847] = "WEAPON_PETROLCAN",
    [-102973651] = "WEAPON_HATCHET",
    [-275439685] = "WEAPON_DBSHOTGUN",
    [-1746263880] = "WEAPON_DOUBLEACTION",
    [-879347409] = "WEAPON_REVOLVER_MK2",
    [125959754] = "WEAPON_COMPACTLAUNCHER",
    [911657153] = "WEAPON_STUNGUN",
    [-2066285827] = "WEAPON_BULLPUPRIFLE_MK2",
    [-538741184] = "WEAPON_SWITCHBLADE",
    [100416529] = "WEAPON_SNIPERRIFLE",
    [-656458692] = "WEAPON_KNUCKLE",
    [-1768145561] = "WEAPON_SPECIALCARBINE_MK2",
    [1737195953] = "WEAPON_NIGHTSTICK",
    [2017895192] = "WEAPON_SAWNOFFSHOTGUN",
    [-2067956739] = "WEAPON_CROWBAR",
    [-1312131151] = "WEAPON_RPG",
    [-1568386805] = "WEAPON_GRENADELAUNCHER",
    [205991906] = "WEAPON_HEAVYSNIPER",
    [1834241177] = "WEAPON_RAILGUN",
    [-1716589765] = "WEAPON_PISTOL50",
    [736523883] = "WEAPON_SMG",
    [1317494643] = "WEAPON_HAMMER",
    [453432689] = "Pistol",
    [1141786504] = "WEAPON_GOLFCLUB",
    [-1076751822] = "WEAPON_SNSPISTOL",
    [-2084633992] = "WEAPON_CARBINERIFLE",
    [487013001] = "WEAPON_PUMPSHOTGUN",
    [-1168940174] = "WEAPON_HAZARDCAN",
    [-38085395] = "WEAPON_DIGISCANNER",
    [-1853920116] = "WEAPON_NAVYREVOLVER",
    [-37975472] = "WEAPON_SMOKEGRENADE",
    [-1600701090] = "WEAPON_BZGAS",
    [-1357824103] = "WEAPON_ADVANCEDRIFLE",
    [-581044007] = "WEAPON_MACHETE",
    [741814745] = "WEAPON_STICKYBOMB",
    [-608341376] = "WEAPON_COMBATMG_MK2",
    [137902532] = "WEAPON_VINTAGEPISTOL",
    [-1660422300] = "WEAPON_MG",
    [1198879012] = "WEAPON_FLAREGUN"
}


Config.Weapons = { -- do not edit here 
    [-1075685676] = "WEAPON_PISTOL_MK2",
    [126349499] = "WEAPON_SNOWBALL",
    [-270015777] = "WEAPON_ASSAULTSMG",
    [615608432] = "WEAPON_MOLOTOV",
    [2024373456] = "WEAPON_SMG_MK2",
    [-1810795771] = "WEAPON_POOLCUE",
    [-1813897027] = "WEAPON_GRENADE",
    [-598887786] = "WEAPON_MARKSMANPISTOL",
    [-1654528753] = "WEAPON_BULLPUPSHOTGUN",
    [-72657034] = "GADGET_PARACHUTE",
    [-102323637] = "WEAPON_BOTTLE",
    [2144741730] = "WEAPON_COMBATMG",
    [-1121678507] = "WEAPON_MINISMG",
    [-1652067232] = "WEAPON_SWEEPERSHOTGUN",
    [961495388] = "WEAPON_ASSAULTRIFLE_MK2",
    [-86904375] = "WEAPON_CARBINERIFLE_MK2",
    [-1786099057] = "WEAPON_BAT",
    [177293209] = "WEAPON_HEAVYSNIPER_MK2",
    [600439132] = "WEAPON_BALL",
    [1432025498] = "WEAPON_PUMPSHOTGUN_MK2",
    [-1951375401] = "WEAPON_FLASHLIGHT",
    [171789620] = "WEAPON_COMBATPDW",
    [1593441988] = "WEAPON_COMBATPISTOL",
    [-2009644972] = "WEAPON_SNSPISTOL_MK2",
    [2138347493] = "WEAPON_FIREWORK",
    [1649403952] = "WEAPON_COMPACTRIFLE",
    [-619010992] = "WEAPON_MACHINEPISTOL",
    [-952879014] = "WEAPON_MARKSMANRIFLE",
    [317205821] = "WEAPON_AUTOSHOTGUN",
    [-1420407917] = "WEAPON_PROXMINE",
    [-1045183535] = "WEAPON_REVOLVER",
    [94989220] = "WEAPON_COMBATSHOTGUN",
    [-1658906650] = "WEAPON_MILITARYRIFLE",
    [1198256469] = "WEAPON_RAYCARBINE",
    [2132975508] = "WEAPON_BULLPUPRIFLE",
    [1627465347] = "WEAPON_GUSENBERG",
    [984333226] = "WEAPON_HEAVYSHOTGUN",
    [1233104067] = "WEAPON_FLARE",
    [-1716189206] = "WEAPON_KNIFE",
    [940833800] = "WEAPON_STONE_HATCHET",
    [1305664598] = "WEAPON_GRENADELAUNCHER_SMOKE",
    [727643628] = "WEAPON_CERAMICPISTOL",
    [-1074790547] = "WEAPON_ASSAULTRIFLE",
    [-1169823560] = "WEAPON_PIPEBOMB",
    [324215364] = "WEAPON_MICROSMG",
    [-1834847097] = "WEAPON_DAGGER",
    [-1466123874] = "WEAPON_MUSKET",
    [-1238556825] = "WEAPON_RAYMINIGUN",
    [-1063057011] = "WEAPON_SPECIALCARBINE",
    [1470379660] = "WEAPON_GADGETPISTOL",
    [584646201] = "WEAPON_APPISTOL",
    [-494615257] = "WEAPON_ASSAULTSHOTGUN",
    [-771403250] = "WEAPON_HEAVYPISTOL",
    [1672152130] = "WEAPON_HOMINGLAUNCHER",
    [338557568] = "WEAPON_PIPEWRENCH",
    [1785463520] = "WEAPON_MARKSMANRIFLE_MK2",
    [-1355376991] = "WEAPON_RAYPISTOL",
    [101631238] = "WEAPON_FIREEXTINGUISHER",
    [1119849093] = "WEAPON_MINIGUN",
    [883325847] = "WEAPON_PETROLCAN",
    [-102973651] = "WEAPON_HATCHET",
    [-275439685] = "WEAPON_DBSHOTGUN",
    [-1746263880] = "WEAPON_DOUBLEACTION",
    [-879347409] = "WEAPON_REVOLVER_MK2",
    [125959754] = "WEAPON_COMPACTLAUNCHER",
    [911657153] = "WEAPON_STUNGUN",
    [-2066285827] = "WEAPON_BULLPUPRIFLE_MK2",
    [-538741184] = "WEAPON_SWITCHBLADE",
    [100416529] = "WEAPON_SNIPERRIFLE",
    [-656458692] = "WEAPON_KNUCKLE",
    [-1768145561] = "WEAPON_SPECIALCARBINE_MK2",
    [1737195953] = "WEAPON_NIGHTSTICK",
    [2017895192] = "WEAPON_SAWNOFFSHOTGUN",
    [-2067956739] = "WEAPON_CROWBAR",
    [-1312131151] = "WEAPON_RPG",
    [-1568386805] = "WEAPON_GRENADELAUNCHER",
    [205991906] = "WEAPON_HEAVYSNIPER",
    [1834241177] = "WEAPON_RAILGUN",
    [-1716589765] = "WEAPON_PISTOL50",
    [736523883] = "WEAPON_SMG",
    [1317494643] = "WEAPON_HAMMER",
    [453432689] = "WEAPON_PISTOL",
    [1141786504] = "WEAPON_GOLFCLUB",
    [-1076751822] = "WEAPON_SNSPISTOL",
    [-2084633992] = "WEAPON_CARBINERIFLE",
    [487013001] = "WEAPON_PUMPSHOTGUN",
    [-1168940174] = "WEAPON_HAZARDCAN",
    [-38085395] = "WEAPON_DIGISCANNER",
    [-1853920116] = "WEAPON_NAVYREVOLVER",
    [-37975472] = "WEAPON_SMOKEGRENADE",
    [-1600701090] = "WEAPON_BZGAS",
    [-1357824103] = "WEAPON_ADVANCEDRIFLE",
    [-581044007] = "WEAPON_MACHETE",
    [741814745] = "WEAPON_STICKYBOMB",
    [-608341376] = "WEAPON_COMBATMG_MK2",
    [137902532] = "WEAPON_VINTAGEPISTOL",
    [-1660422300] = "WEAPON_MG",
    [1198879012] = "WEAPON_FLAREGUN",
}

-- github: qb-core - weapons.lua
Config.WeaponsExtra = {
	-- // WEAPONS
	-- Melee
	[`weapon_unarmed`]               = { name = 'weapon_unarmed', label = 'Fists', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_dagger`]                = { name = 'weapon_dagger', label = 'Dagger', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_bat`]                   = { name = 'weapon_bat', label = 'Bat', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_bottle`]                = { name = 'weapon_bottle', label = 'Broken Bottle', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_crowbar`]               = { name = 'weapon_crowbar', label = 'Crowbar', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_flashlight`]            = { name = 'weapon_flashlight', label = 'Flashlight', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_golfclub`]              = { name = 'weapon_golfclub', label = 'Golfclub', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_hammer`]                = { name = 'weapon_hammer', label = 'Hammer', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_hatchet`]               = { name = 'weapon_hatchet', label = 'Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_knuckle`]               = { name = 'weapon_knuckle', label = 'Knuckle', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_knife`]                 = { name = 'weapon_knife', label = 'Knife', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_machete`]               = { name = 'weapon_machete', label = 'Machete', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_switchblade`]           = { name = 'weapon_switchblade', label = 'Switchblade', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_nightstick`]            = { name = 'weapon_nightstick', label = 'Nightstick', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_wrench`]                = { name = 'weapon_wrench', label = 'Wrench', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_battleaxe`]             = { name = 'weapon_battleaxe', label = 'Battle Axe', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_poolcue`]               = { name = 'weapon_poolcue', label = 'Poolcue', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_briefcase`]             = { name = 'weapon_briefcase', label = 'Briefcase', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_briefcase_02`]          = { name = 'weapon_briefcase_02', label = 'Briefcase', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_garbagebag`]            = { name = 'weapon_garbagebag', label = 'Garbage Bag', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_handcuffs`]             = { name = 'weapon_handcuffs', label = 'Handcuffs', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_bread`]                 = { name = 'weapon_bread', label = 'Baquette', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered' },
	[`weapon_stone_hatchet`]         = { name = 'weapon_stone_hatchet', label = 'Stone Hatchet', weapontype = 'Melee', ammotype = nil, damagereason = 'Knifed / Stabbed / Eviscerated' },
	[`weapon_candycane`]             = { name = 'weapon_candycane', label = 'Candy Cane', weapontype = 'Melee', ammotype = nil, damagereason = 'Melee Killed / Whacked / Executed / Beat down / Musrdered / Battered / Candy Caned' },

	-- Handguns
	[`weapon_pistol`]                = { name = 'weapon_pistol', label = 'Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_pistol_mk2`]            = { name = 'weapon_pistol_mk2', label = 'Pistol Mk2', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_combatpistol`]          = { name = 'weapon_combatpistol', label = 'Combat Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_appistol`]              = { name = 'weapon_appistol', label = 'AP Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_stungun`]               = { name = 'weapon_stungun', label = 'Taser', weapontype = 'Pistol', ammotype = 'AMMO_STUNGUN', damagereason = 'Died' },
	[`weapon_pistol50`]              = { name = 'weapon_pistol50', label = 'Pistol .50 Cal', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_snspistol`]             = { name = 'weapon_snspistol', label = 'SNS Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_snspistol_mk2`]         = { name = 'weapon_snspistol_mk2', label = 'SNS Pistol MK2', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_heavypistol`]           = { name = 'weapon_heavypistol', label = 'Heavy Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_vintagepistol`]         = { name = 'weapon_vintagepistol', label = 'Vintage Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_flaregun`]              = { name = 'weapon_flaregun', label = 'Flare Gun', weapontype = 'Pistol', ammotype = 'AMMO_FLARE', damagereason = 'Died' },
	[`weapon_marksmanpistol`]        = { name = 'weapon_marksmanpistol', label = 'Marksman Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_revolver`]              = { name = 'weapon_revolver', label = 'Revolver', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_revolver_mk2`]          = { name = 'weapon_revolver_mk2', label = 'Revolver MK2', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_doubleaction`]          = { name = 'weapon_doubleaction', label = 'Double Action Revolver', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_raypistol`]             = { name = 'weapon_raypistol', label = 'Ray Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_ceramicpistol`]         = { name = 'weapon_ceramicpistol', label = 'Ceramic Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_navyrevolver`]          = { name = 'weapon_navyrevolver', label = 'Navy Revolver', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_gadgetpistol`]          = { name = 'weapon_gadgetpistol', label = 'Gadget Pistol', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plugged / Bust a cap in' },
	[`weapon_stungun_mp`]            = { name = 'weapon_stungun_mp', label = 'Taser', weapontype = 'Pistol', ammotype = 'AMMO_STUNGUN', damagereason = 'Died' },
	[`weapon_pistolxm3`]             = { name = 'weapon_pistolxm3', label = 'Pistol XM3', weapontype = 'Pistol', ammotype = 'AMMO_PISTOL', damagereason = 'Pistoled / Blasted / Plaugged / Bust a cap in' },

	-- Submachine Guns
	[`weapon_microsmg`]              = { name = 'weapon_microsmg', label = 'Micro SMG', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_smg`]                   = { name = 'weapon_smg', label = 'SMG', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_smg_mk2`]               = { name = 'weapon_smg_mk2', label = 'SMG MK2', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_assaultsmg`]            = { name = 'weapon_assaultsmg', label = 'Assault SMG', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_combatpdw`]             = { name = 'weapon_combatpdw', label = 'Combat PDW', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_machinepistol`]         = { name = 'weapon_machinepistol', label = 'Tec-9', weapontype = 'Submachine Gun', ammotype = 'AMMO_PISTOL', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_minismg`]               = { name = 'weapon_minismg', label = 'Mini SMG', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },
	[`weapon_raycarbine`]            = { name = 'weapon_raycarbine', label = 'Raycarbine', weapontype = 'Submachine Gun', ammotype = 'AMMO_SMG', damagereason = 'Riddled / Drilled / Finished / Submachine Gunned' },

	-- Shotguns
	[`weapon_pumpshotgun`]           = { name = 'weapon_pumpshotgun', label = 'Pump Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_pumpshotgun_mk2`]       = { name = 'weapon_pumpshotgun_mk2', label = 'Pump Shotgun MK2', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_sawnoffshotgun`]        = { name = 'weapon_sawnoffshotgun', label = 'Sawn-off Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_assaultshotgun`]        = { name = 'weapon_assaultshotgun', label = 'Assault Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_bullpupshotgun`]        = { name = 'weapon_bullpupshotgun', label = 'Bullpup Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_musket`]                = { name = 'weapon_musket', label = 'Musket', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_heavyshotgun`]          = { name = 'weapon_heavyshotgun', label = 'Heavy Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_dbshotgun`]             = { name = 'weapon_dbshotgun', label = 'Double-barrel Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_autoshotgun`]           = { name = 'weapon_autoshotgun', label = 'Auto Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },
	[`weapon_combatshotgun`]         = { name = 'weapon_combatshotgun', label = 'Combat Shotgun', weapontype = 'Shotgun', ammotype = 'AMMO_SHOTGUN', damagereason = 'Devastated / Pulverized / Shotgunned' },

	-- Assault Rifles
	[`weapon_assaultrifle`]          = { name = 'weapon_assaultrifle', label = 'Assault Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_assaultrifle_mk2`]      = { name = 'weapon_assaultrifle_mk2', label = 'Assault Rifle MK2', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_carbinerifle`]          = { name = 'weapon_carbinerifle', label = 'Carbine Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_carbinerifle_mk2`]      = { name = 'weapon_carbinerifle_mk2', label = 'Carbine Rifle MK2', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_advancedrifle`]         = { name = 'weapon_advancedrifle', label = 'Advanced Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_specialcarbine`]        = { name = 'weapon_specialcarbine', label = 'Special Carbine', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_specialcarbine_mk2`]    = { name = 'weapon_specialcarbine_mk2', label = 'Specialcarbine MK2', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_bullpuprifle`]          = { name = 'weapon_bullpuprifle', label = 'Bullpup Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_bullpuprifle_mk2`]      = { name = 'weapon_bullpuprifle_mk2', label = 'Bull Puprifle MK2', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_compactrifle`]          = { name = 'weapon_compactrifle', label = 'Compact Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_militaryrifle`]         = { name = 'weapon_militaryrifle', label = 'Military Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },
	[`weapon_heavyrifle`]            = { name = 'weapon_heavyrifle', label = 'Heavy Rifle', weapontype = 'Assault Rifle', ammotype = 'AMMO_RIFLE', damagereason = 'Ended / Rifled / Shot down / Floored' },

	-- Light Machine Guns
	[`weapon_mg`]                    = { name = 'weapon_mg', label = 'Machinegun', weapontype = 'Light Machine Gun', ammotype = 'AMMO_MG', damagereason = 'Machine gunned / Sprayed / Ruined' },
	[`weapon_combatmg`]              = { name = 'weapon_combatmg', label = 'Combat MG', weapontype = 'Light Machine Gun', ammotype = 'AMMO_MG', damagereason = 'Machine gunned / Sprayed / Ruined' },
	[`weapon_combatmg_mk2`]          = { name = 'weapon_combatmg_mk2', label = 'Combat MG MK2', weapontype = 'Light Machine Gun', ammotype = 'AMMO_MG', damagereason = 'Machine gunned / Sprayed / Ruined' },
	[`weapon_gusenberg`]             = { name = 'weapon_gusenberg', label = 'Thompson SMG', weapontype = 'Light Machine Gun', ammotype = 'AMMO_MG', damagereason = 'Machine gunned / Sprayed / Ruined' },

	-- Sniper Rifles
	[`weapon_sniperrifle`]           = { name = 'weapon_sniperrifle', label = 'Sniper Rifle', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER', damagereason = 'Sniped / Picked off / Scoped' },
	[`weapon_heavysniper`]           = { name = 'weapon_heavysniper', label = 'Heavy Sniper', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER', damagereason = 'Sniped / Picked off / Scoped' },
	[`weapon_heavysniper_mk2`]       = { name = 'weapon_heavysniper_mk2', label = 'Heavysniper MK2', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER', damagereason = 'Sniped / Picked off / Scoped' },
	[`weapon_marksmanrifle`]         = { name = 'weapon_marksmanrifle', label = 'Marksman Rifle', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER', damagereason = 'Sniped / Picked off / Scoped' },
	[`weapon_marksmanrifle_mk2`]     = { name = 'weapon_marksmanrifle_mk2', label = 'Marksman Rifle MK2', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER', damagereason = 'Sniped / Picked off / Scoped' },
	[`weapon_remotesniper`]          = { name = 'weapon_remotesniper', label = 'Remote Sniper', weapontype = 'Sniper Rifle', ammotype = 'AMMO_SNIPER_REMOTE', damagereason = 'Sniped / Picked off / Scoped' },

	-- Heavy Weapons
	[`weapon_rpg`]                   = { name = 'weapon_rpg', label = 'RPG', weapontype = 'Heavy Weapons', ammotype = 'AMMO_RPG', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_grenadelauncher`]       = { name = 'weapon_grenadelauncher', label = 'Grenade Launcher', weapontype = 'Heavy Weapons', ammotype = 'AMMO_GRENADELAUNCHER', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_grenadelauncher_smoke`] = { name = 'weapon_grenadelauncher_smoke', label = 'Smoke Grenade Launcher', weapontype = 'Heavy Weapons', ammotype = 'AMMO_GRENADELAUNCHER', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_minigun`]               = { name = 'weapon_minigun', label = 'Minigun', weapontype = 'Heavy Weapons', ammotype = 'AMMO_MINIGUN', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_firework`]              = { name = 'weapon_firework', label = 'Firework Launcher', weapontype = 'Heavy Weapons', ammotype = nil, damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_railgun`]               = { name = 'weapon_railgun', label = 'Railgun', weapontype = 'Heavy Weapons', ammotype = nil, damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_railgunxm3`]            = { name = 'weapon_railgunxm3', label = 'Railgun XM3', weapontype = 'Heavy Weapons', ammotype = nil, damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_hominglauncher`]        = { name = 'weapon_hominglauncher', label = 'Homing Launcher', weapontype = 'Heavy Weapons', ammotype = 'AMMO_STINGER', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_compactlauncher`]       = { name = 'weapon_compactlauncher', label = 'Compact Launcher', weapontype = 'Heavy Weapons', ammotype = nil, damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_rayminigun`]            = { name = 'weapon_rayminigun', label = 'Ray Minigun', weapontype = 'Heavy Weapons', ammotype = 'AMMO_MINIGUN', damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_emplauncher`]           = { name = 'weapon_emplauncher', label = 'EMP Launcher', weapontype = 'Heavy Weapons', ammotype = 'AMMO_EMPLAUNCHER', damagereason = 'Died' },

	-- Throwables
	[`weapon_grenade`]               = { name = 'weapon_grenade', label = 'Grenade', weapontype = 'Throwable', ammotype = nil, damagereason = 'Bombed / Exploded / Detonated / Blew up' },
	[`weapon_bzgas`]                 = { name = 'weapon_bzgas', label = 'BZ Gas', weapontype = 'Throwable', ammotype = nil, damagereason = 'Died' },
	[`weapon_molotov`]               = { name = 'weapon_molotov', label = 'Molotov', weapontype = 'Throwable', ammotype = nil, damagereason = 'Torched / Flambeed / Barbecued' },
	[`weapon_stickybomb`]            = { name = 'weapon_stickybomb', label = 'C4', weapontype = 'Throwable', ammotype = nil, damagereason = 'Bombed / Exploded / Detonated / Blew up' },
	[`weapon_proxmine`]              = { name = 'weapon_proxmine', label = 'Proxmine Grenade', weapontype = 'Throwable', ammotype = nil, damagereason = 'Bombed / Exploded / Detonated / Blew up' },
	[`weapon_snowball`]              = { name = 'weapon_snowball', label = 'Snowball', weapontype = 'Throwable', ammotype = nil, damagereason = 'Died' },
	[`weapon_pipebomb`]              = { name = 'weapon_pipebomb', label = 'Pipe Bomb', weapontype = 'Throwable', ammotype = nil, damagereason = 'Bombed / Exploded / Detonated / Blew up' },
	[`weapon_ball`]                  = { name = 'weapon_ball', label = 'Ball', weapontype = 'Throwable', ammotype = 'AMMO_BALL', damagereason = 'Died' },
	[`weapon_smokegrenade`]          = { name = 'weapon_smokegrenade', label = 'Smoke Grenade', weapontype = 'Throwable', ammotype = nil, damagereason = 'Died' },
	[`weapon_flare`]                 = { name = 'weapon_flare', label = 'Flare pistol', weapontype = 'Throwable', ammotype = 'AMMO_FLARE', damagereason = 'Died' },

	-- Miscellaneous
	[`weapon_petrolcan`]             = { name = 'weapon_petrolcan', label = 'Petrol Can', weapontype = 'Miscellaneous', ammotype = 'AMMO_PETROLCAN', damagereason = 'Died' },
	[`gadget_parachute`]             = { name = 'gadget_parachute', label = 'Parachute', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_fireextinguisher`]      = { name = 'weapon_fireextinguisher', label = 'Fire Extinguisher', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_hazardcan`]             = { name = 'weapon_hazardcan', label = 'Hazardcan', weapontype = 'Miscellaneous', ammotype = 'AMMO_PETROLCAN', damagereason = 'Died' },
	[`weapon_fertilizercan`]         = { name = 'weapon_fertilizercan', label = 'Fertilizer Can', weapontype = 'Miscellaneous', ammotype = 'AMMO_FERTILIZERCAN', damagereason = 'Died' },
	[`weapon_barbed_wire`]           = { name = 'weapon_barbed_wire', label = 'Barbed Wire', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Prodded' },
	[`weapon_drowning`]              = { name = 'weapon_drowning', label = 'Drowning', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_drowning_in_vehicle`]   = { name = 'weapon_drowning_in_vehicle', label = 'Drowning in a Vehicle', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_bleeding`]              = { name = 'weapon_bleeding', label = 'Bleeding', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Bled out' },
	[`weapon_electric_fence`]        = { name = 'weapon_electric_fence', label = 'Electric Fence', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Fried' },
	[`weapon_explosion`]             = { name = 'weapon_explosion', label = 'Explosion', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated' },
	[`weapon_fall`]                  = { name = 'weapon_fall', label = 'Fall', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Committed suicide' },
	[`weapon_exhaustion`]            = { name = 'weapon_exhaustion', label = 'Exhaustion', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_hit_by_water_cannon`]   = { name = 'weapon_hit_by_water_cannon', label = 'Water Cannon', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Died' },
	[`weapon_rammed_by_car`]         = { name = 'weapon_rammed_by_car', label = 'Rammed - Vehicle', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Flattened / Ran over / Ran down' },
	[`weapon_run_over_by_car`]       = { name = 'weapon_run_over_by_car', label = 'Run Over - Vehicle', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Flattened / Ran over / Ran down' },
	[`weapon_heli_crash`]            = { name = 'weapon_heli_crash', label = 'Heli Crash', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Helicopter Crash' },
	[`weapon_fire`]                  = { name = 'weapon_fire', label = 'Fire', weapontype = 'Miscellaneous', ammotype = nil, damagereason = 'Torched / Flambeed / Barbecued' },

	-- Animals
	[`weapon_animal`]                = { name = 'weapon_animal', label = 'Animal', weapontype = 'Animals', ammotype = nil, damagereason = 'Mauled' },
	[`weapon_cougar`]                = { name = 'weapon_cougar', label = 'Cougar', weapontype = 'Animals', ammotype = nil, damagereason = 'Mauled' },
}
 



Config.BoneGroups = {
    [52301] = {  -- RFoot
         20781,24806,52301
    },
    [14201] = {  -- LFoot
        2108,14201,35502,57717,65245
    },
    [36864] = {  -- RKnee
        16335,36864,51826
    },
    [63931] = {  -- LKnee
        23639,46078,58271,63931
    },
    [31086] = {  -- Head
        1356, 10706, 11174,12844,17188,17719,19336,20178,20279,20623,21550,25260,27474,29868,31086,35731,
        37193,39317,43536,45750,46240,47419,47495,49979,58331,61839,64729,65068
    },
    [28252] = {  -- RArm
        2992,6286,6442,26610,26611,26612,26613,26614,28252,28422,37119,
        40269,43810,57005, 
        58866,58867,58868,58869,58870,
        64016,64017,64064,64065,64080,64081,64096,64097,64112,64113
    },
    [61163] = {  -- LArm
        4089,4090,4137,4138,4153,4154,4169,4170,4185,4186,
        5232,18905,22711,36029,45509,60309,61007,61163
    },
    [24818] = {  -- Chest
        0, 11816,23553,24816,24817,24818,56604,57597
    }
}

Config.GetAlternativeBone = function(bone) 

--    if Config.OnlyAllowChestDamageForExperimental == true then 
--        return 24818
--    end

   for k,v in pairs(Config.PlayerBones) do 
       if v == bone then 
           return v
       end
   end

   for k,v in pairs(Config.BoneGroups) do
        for kk,vv in pairs(v) do
            if vv == bone then
                return k
            end
        end
   end

--    if bone == 18905 then return 61163 end
--    if bone == 57005 then return 28252 end
--    if bone == 39317 then return 24818 end
--    if bone == 11816 then return 24818 end
--    if bone == 40269 then return 28252 end
--    if bone == 45509 then return 61163 end
--    if bone == 28422 then return 28252 end
--    if bone == 60309 then return 61163 end

--    if bone == 51826 or bone == 52301 then -- right foot
--          return 52301
--     end

--     if bone == 64113 or bone == 64112 or bone == 64097 or bone == 64096 or bone == 64081 or bone == 64080 or bone == 64065 or bone == 64064 or bone == 64017 or bone == 64016 then  -- right hand then 
--         return 61163
--     end

--    -- SPINE
--     if bone == 24816 then 
--         return 24818
--     end 

--     if bone == 23553 then 
--         return 24818
--     end 

--     if bone == 24817 then 
--         return 24818
--     end 

--     if bone == 57597 then 
--         return 24818
--     end 
 
   return false
end

CheckAmbulanceJobScripts = function()
    if Config.EnableRevive == false then return end
    n = false
    for i = 0, GetNumResources(), 1 do
        local resource_name = GetResourceByFindIndex(i)
        if resource_name == "esx_ambulancejob" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
        if resource_name == "qb-ambulancejob" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
        if resource_name == "wasabi_ambulance" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
        if resource_name == "ak47_ambulancejob" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
        if resource_name == "ak47_qb_ambulancejob" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
        if resource_name == "brutal_ambulancejob" and GetResourceState(resource_name) == "started" then
            n = true
            break
        end
    end
    Config.EnableRevive = n
end

Citizen.CreateThread(CheckAmbulanceJobScripts)




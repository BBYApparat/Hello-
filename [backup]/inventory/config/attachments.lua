Config.MaximumAmmoValues = {
    ["pistol"] = 250,
    ["smg"] = 500,
    ["shotgun"] = 200,
    ["rifle"] = 750,
}

Config.ReloadTime = math.random(2000, 4000)

Config.AmmoItems = {
    { name = "pistol_ammo",     event = "weapon:client:AddAmmo",    ammo_type = "AMMO_PISTOL",      ammo_count = 12 },
    { name = "smg_ammo",        event = "weapon:client:AddAmmo",    ammo_type = "AMMO_SMG",         ammo_count = 20 },
    { name = "rifle_ammo",      event = "weapon:client:AddAmmo",    ammo_type = "AMMO_RIFLE",       ammo_count = 30 },
    { name = "shotgun_ammo",    event = "weapon:client:AddAmmo",    ammo_type = "AMMO_SHOTGUN",     ammo_count = 10 },
    { name = "mg_ammo",         event = "weapon:client:AddAmmo",    ammo_type = "AMMO_MG",          ammo_count = 30 },
    { name = "snp_ammo",        event = "weapon:client:AddAmmo",    ammo_type = "AMMO_SNIPER",      ammo_count = 10 },
    { name = "emp_ammo",        event = "weapon:client:AddAmmo",    ammo_type = "AMMO_EMPLAUNCHER", ammo_count = 10 },
}

Config.WeaponTints = {
    { name = "weapontint_black",    event = "weapons:client:EquipTint",      value = 0 },
    { name = "weapontint_green",    event = "weapons:client:EquipTint",      value = 1 },
    { name = "weapontint_gold",     event = "weapons:client:EquipTint",      value = 2 },
    { name = "weapontint_pink",     event = "weapons:client:EquipTint",      value = 3 },
    { name = "weapontint_army",     event = "weapons:client:EquipTint",      value = 4 },
    { name = "weapontint_lspd",     event = "weapons:client:EquipTint",      value = 5 },
    { name = "weapontint_orange",   event = "weapons:client:EquipTint",      value = 6 },
    { name = "weapontint_plat",     event = "weapons:client:EquipTint",      value = 7 },
}

Config.WeaponAttachments = {
    --Pistol
    { name = "pistol_extendedclip",             event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "pistol_flashlight",               event = "weapons:client:EquipAttachment", value = 'flashlight'   },
    { name = "pistol_suppressor",               event = "weapons:client:EquipAttachment", value = 'suppressor'   },
    { name = "pistol_luxuryfinish",             event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "combatpistol_extendedclip",       event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "combatpistol_luxuryfinish",       event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "appistol_extendedclip",           event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "appistol_luxuryfinish",           event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "pistol50_extendedclip",           event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "pistol50_luxuryfinish",           event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "revolver_vipvariant",             event = "weapons:client:EquipAttachment", value = 'vipvariant'   },
    { name = "snspistol_extendedclip",          event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "snspistol_grip",                  event = "weapons:client:EquipAttachment", value = 'grip'         },
    { name = "snspistol_luxuryfinish",          event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "heavypistol_extendedclip",        event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "heavypistol_grip",                event = "weapons:client:EquipAttachment", value = 'grip'         },
    { name = "heavypistol_luxuryfinish",        event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "vintagepistol_extendedclip",      event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    --SMG
    { name = "microsmg_extendedclip",           event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "microsmg_scope",                  event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "microsmg_luxuryfinish",           event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "smg_extendedclip",                event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "smg_drum",                        event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "smg_luxuryfinish",                event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "smg_scope",                       event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "assaultsmg_extendedclip",         event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "assaultsmg_luxuryfinish",         event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "minismg_extendedclip",            event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "machinepistol_extendedclip",      event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "machinepistol_drum",              event = "weapons:client:EquipAttachment", value = 'drum'         },
    --PDW
    { name = "combatpdw_extendedclip",          event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "combatpdw_drum",                  event = "weapons:client:EquipAttachment", value = 'drum'         },
    { name = "combatpdw_grip",                  event = "weapons:client:EquipAttachment", value = 'grip'         },
    { name = "combatpdw_scope",                 event = "weapons:client:EquipAttachment", value = 'scope'        },
    --Shotgun
    { name = "shotgun_suppressor",              event = "weapons:client:EquipAttachment", value = 'suppressor'   },
    { name = "pumpshotgun_luxuryfinish",        event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "sawnoffshotgun_luxuryfinish",     event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "assaultshotgun_extendedclip",     event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "heavyshotgun_extendedclip",       event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "heavyshotgun_drum",               event = "weapons:client:EquipAttachment", value = 'drum'         },
    --Sniper
    { name = "sniper_scope",                    event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "snipermax_scope",                 event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "sniper_grip",                     event = "weapons:client:EquipAttachment", value = 'grip'         },
    { name = "sniperrifle_suppressor",          event = "weapons:client:EquipAttachment", value = 'suppressor'   },
    { name = "heavysniper_extendedclip",        event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "sniper_luxuryfinish",             event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    --Rifles
    { name = "rifle_extendedclip",              event = "weapons:client:EquipAttachment", value = 'extendedclip' },
    { name = "rifle_drummag",                   event = "weapons:client:EquipAttachment", value = 'drum'         },
    { name = "rifle_flashlight",                event = "weapons:client:EquipAttachment", value = 'flashlight'   },
    { name = "rifle_grip",                      event = "weapons:client:EquipAttachment", value = 'grip'         },
    { name = "rifle_scope",                     event = "weapons:client:EquipAttachment", value = 'scope'        },
    { name = "rifle_suppressor",                event = "weapons:client:EquipAttachment", value = 'suppressor'   },
    { name = "assaultrifle_luxuryfinish",       event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "carbinerifle_luxuryfinish",       event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "advancedrifle_luxuryfinish",      event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "specialcarbine_luxuryfinish",     event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "bullpuprifle_luxuryfinish",       event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
    { name = "marksmanrifle_luxuryfinish",      event = "weapons:client:EquipAttachment", value = 'luxuryfinish' },
}
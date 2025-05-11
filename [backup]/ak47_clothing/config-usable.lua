Config.EnableClothingItem = false
Config.Webhook = ' webhooks/1239240572053487746/IWsgol_q-2ECMiuwd7Gn6VppPdzBCB_AoO2bpmoikd1fMsUlwSKkzR6KwE7YsEo95SzZ'

Config.EnableItems = {
    torso       = true,
    pant        = true,
    shoes       = true,
    watch       = false,
    bracelet    = false,
    glass       = false,
    earring     = false,
    chain       = false,
    hat         = false,
    mask        = false,
    vest        = false,
}

Config.Animations = {
    torso = {
        on  = {dir = 'clothingtie', anim = 'try_tie_negative_a', delay = 1500},
        off = {dir = 'clothingtie', anim = 'try_tie_negative_a', delay = 1500},
    },
    pant = {
        on = {dir = 're@construction', anim = 'out_of_breath', delay = 1300},
        off = {dir = 're@construction', anim = 'out_of_breath', delay = 1300},
    },
    shoes = {
        on = {dir = 'random@domestic', anim = 'pickup_low', delay = 1200},
        off = {dir = 'random@domestic', anim = 'pickup_low', delay = 1200},
    },
    watch = {
        on = {dir = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', delay = 1000},
        off = {dir = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', delay = 1200},
    },
    bracelet = {
        on = {dir = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', delay = 1000},
        off = {dir = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', delay = 1200},
    },
    glass = {
        on = {dir = 'clothingspecs', anim = 'take_off', delay = 1400},
        off = {dir = 'clothingspecs', anim = 'take_off', delay = 1400},
    },
    earring = {
        on = {dir = 'mp_cp_stolen_tut', anim = 'b_think', delay = 900},
        off = {dir = 'mp_cp_stolen_tut', anim = 'b_think', delay = 900},
    },
    chain = {
       on = {dir = 'clothingtie', anim = 'try_tie_positive_a', delay = 3400},
        off = {dir = 'clothingtie', anim = 'try_tie_positive_a', delay = 2800},
    },
    mask = {
       on = {dir = 'missheist_agency2ahelmet', anim = 'take_off_helmet_stand', delay = 1200},
       off = {dir = 'mp_masks@standard_car@ds@', anim = 'put_on_mask', delay = 1000},
    },
    hat = {
       on = {dir = 'mp_masks@standard_car@ds@', anim = 'put_on_mask', delay = 1000},
       off = {dir = 'missheist_agency2ahelmet', anim = 'take_off_helmet_stand', delay = 1200},
    },
    vest = {
        on  = {dir = 'clothingtie', anim = 'try_tie_negative_a', delay = 1500},
        off = {dir = 'clothingtie', anim = 'try_tie_negative_a', delay = 1500},
    },
}
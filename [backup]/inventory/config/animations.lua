Config.Animations = {
    closeInv = { dict = "amb@prop_human_bum_bin@idle_b", anim = "idle_b" },
    openInv = { dict = "gestures@f@standing@casual", anim = "gesture_hand_down" },
    give = { dict = "mp_common", anim = "givetake1_b" },
    crafting = { -- Crafting detects the type of crafting usage by crafting table label. Example if finds in label the word cook it does the cooking anim. if drink the drink anim.
        general = { dict = "mini@repair", anim = "fixing_a_player" },
        food = { dict = nil, anim = nil, scenario = "PROP_HUMAN_BBQ" },
        drinks = { dict = "anim@amb@casino@mini@drinking@bar@drink@heels@base", anim = "intro_bartender" },
    },
    rob = {
        entering = { dict = "missminuteman_1ig_2", anim = "handsup_enter" },
        base = { dict = "missminuteman_1ig_2", anim = "handsup_base" }
    }
}
Config.Dumpsters = {
    enableDiving = true, -- This enables dumpster diving (opening inventory near dumpster may finds items inside)
    objects = {
        218085040,
        666561306,
        -58485588,
        -206690185,
        1511880420,
        682791951
    },
    items = { -- Those are the chances for dumpster diving. each list is a chance. and also there is a chance to find nothing inside.
        {
            { name = "scrap", amount = 1, slot = 1},
            { name = "iron", amount = 1, slot = 2},
            { name = "plastic", amount = 1, slot = 3}
        },
        {
            { name = "scrap", amount = 1, slot = 1},
            { name = "iron", amount = 1, slot = 2},
        },
        {
            { name = "scrap", amount = 1, slot = 1},
            { name = "plastic", amount = 1, slot = 2}
        },
        {
            { name = "iron", amount = 1, slot = 1},
            { name = "plastic", amount = 1, slot = 2}
        },
        {
            { name = "iron", amount = 1, slot = 1},
        },
        {
            { name = "plastic", amount = 1, slot = 1},
        },
        {
            { name = "scrap", amount = 1, slot = 1},
        },
    }
}
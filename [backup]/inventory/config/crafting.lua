Config.CraftingItems = {}

Config.Crafting = {
    ["general_crafting"] = {
        label = "General Crafting",
        blipData = {
            enabled = false,
            sprite = 643,
            color = 26,
            scale = 0.5,
            short = true,
            text = "Crafting Bench",
        },
        settings = {
            requiredJob = nil, -- can be a table ex. { ["bennys"] = 0, ["lscustoms"] = 4} where 0 or 4 (intigers) are the minimum grades
        },
        locations = {
            { x = 472.08,   y = -1312.26, z = 29.22, h = 120.12 },
            { x = 549.51,   y = -188.66,  z = 54.39, h = 202.23 },
            { x = -1155.83, y = -1999.23, z = 13.43, h = 309.89 },
            { x = 100.59,   y = 6615.72,  z = 32.50, h = 228.05 },
            { x = 273.07,   y = 134.41,  z = 104.43, h = 228.05 },
        },
        items = {
            {
                slot = 1,
                name = "lockpick",
                costs = {
                    { name = "scrap",   count = 35 },
                    { name = "plastic", count = 15 },
                },
            },
            {
                slot = 2,
                name = "bulletproof",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "rubber", count = 10 },
                    { name = "leather", count = 8 },
                }
            },
            {
                slot = 3,
                name = "heavybulletproof",
                costs = {
                    { name = "plastic", count = 25 },
                    { name = "rubber", count = 15 },
                    { name = "leather", count = 10 },
                }
            },
            {
                slot = 4,
                name = "markedbills",
                costs = {
                    { name = "rolledbill", count = 25 },
                    { name = "plasticbag", count = 1  }
                }
            },
        }
    },
    -- This is an example. to open it just use: exports.inventory:OpenCrafting("bennys_crafting")
    ["bennys_crafting"] = {
        label = "Tool Creator",
        settings = {
            requiredJob = {["bennys"] = 0}, -- can be a table ex. { ["bennys"] = 0, ["lscustoms"] = 4} where 0 or 4 (intigers) are the minimum grades
        },
        items = {
            {
                slot = 1,
                name = "bulletproof",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
        }
    },
    ["mechanic_crafting"] = {
        label = "Mechanic Crafting",
        settings = {
            requiredJob = {["mechanic"] = 0}, -- can be a table ex. { ["bennys"] = 0, ["lscustoms"] = 4} where 0 or 4 (integers) are the minimum grades
        },
        items = {
            {
                slot = 1,
                name = "repairkit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 2,
                name = "lockpick",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 3,
                name = "contract",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 4,
                name = "tirekit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 5,
                name = "bodykit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 6,
                name = "cosmetics",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
        }
    },
    ["mechanic2_crafting"] = {
        label = "Mechanic Crafting",
        settings = {
            requiredJob = {["mechanic2"] = 0}, -- can be a table ex. { ["bennys"] = 0, ["lscustoms"] = 4} where 0 or 4 (integers) are the minimum grades
        },
        items = {
            {
                slot = 1,
                name = "repairkit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 2,
                name = "lockpick",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 3,
                name = "contract",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 4,
                name = "tirekit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 5,
                name = "bodykit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
        }
    },
    ["mechanic3_crafting"] = {
        label = "Mechanic Crafting",
        settings = {
            requiredJob = {["mechanic3"] = 0}, -- can be a table ex. { ["bennys"] = 0, ["lscustoms"] = 4} where 0 or 4 (integers) are the minimum grades
        },
        items = {
            {
                slot = 1,
                name = "repairkit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 2,
                name = "lockpick",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 3,
                name = "contract",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 4,
                name = "tirekit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
            {
                slot = 5,
                name = "bodykit",
                costs = {
                    { name = "plastic", count = 15 },
                    { name = "scrap", count = 10 },
                }
            },
        }
    },
}
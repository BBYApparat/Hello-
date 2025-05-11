Config.VendingMachine = {
    enabled = true,
    distance = 1.0, -- Max distance for eye target
    inventoryName = "Vending Machine", -- Inventory Label
    objects = { -- Vending Objects
        "prop_vend_soda_01",
        "prop_vend_soda_02",
        "prop_vend_water_01"
    },
    settings = { -- Eye Target Settings
        icon = "fas fa-bottle-water",
        label = "Open Vending Machine"
    },
    items = {
        [1] = {
            name = "water",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
    }
}
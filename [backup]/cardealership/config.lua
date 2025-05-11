Config = {}

Config.PlateUseSpace = false
Config.PlateLetters  = 3
Config.PlateNumbers  = 3

Config.Classes = {
    ["s"] = "S Class",
    ["a"] = "A Class",
    ["b"] = "B Class",
    ["c"] = "C Class",
    ["d"] = "D Class",
    ["drift"] = "Drift Class"
}

Config.Toggles = {
    useJobDuty = false, -- Enable it if you have job duty system into your server
    useGangs = false, -- Enable it if you have a gang system into your server
    useDefaultDealershipInterior = true, -- Enable it if you want the script to load the default IPL of the vehicleshop
    useTestDrive = false, -- Enable it if you want to use the Test Drive function for any car (in stock only)!
    useTarget = true, -- Enable it if you want to use the target functionality
}

Config.Events = {
    toggleDuty = "esx:toggleDuty",
    setGang = "esx:setGang" 
}

Config.Resources = {
    target = "qb-target",
    mysql = "oxmysql",
}

Config.Vehicleshops = {
    -- Example with target boxzone
    ["premium_deluxe_motorsport"] = {
        label = "Premium Deluxe Motorsport",
        blip = {
            enabled = true,
            sprite = 326,
            color = 0,
            scale = 0.6,
            short = true,
        },
        preview = {
            coords = { x = -55.38, y = -1096.88, z = 26.33 },
            heading = 213.0,
            type = "target",
            distance = 2.0,
            targetData = { type = "boxzone", icon = "fas fa-car" },
        },
        test_drive = { -- Leave it as **test_drive = {}** if you have Config.Toggles.useTestDrive set to false
            coords = { x = -28.28, y = -1081.49, z = 26.64 },
            heading = 68.87,
            timer = 30 -- 30 = 30 seconds
        },
        buy_spawn = {
            coords = { x = -28.28, y = -1081.49, z = 26.64 },
            heading = 68.87,
        },
    },
    -- Example with target entityzone
    -- ["premium_deluxe_motorsport_2"] = {
    --     label = "Premium Deluxe Motorsport",
    --     blip = {
    --         enabled = true,
    --         sprite = 300,
    --         color = 0,
    --         scale = 0.6,
    --         short = true,
    --     },
    --     preview = {
    --         coords = { x = -55.38, y = -1096.88, z = 26.33 },
    --         heading = 213.0,
    --         type = "target",
    --         distance = 2.0,
    --         targetData = { type = "entityzone", icon = "fas fa-car", model = "a_m_y_business_02"},
    --     },
    --     test_drive = { -- Leave it as **test_drive = {}** if you have Config.Toggles.useTestDrive set to false
    --         coords = { x = -28.28, y = -1081.49, z = 26.64 },
    --         heading = 68.87,
    --         timer = 30 -- 30 = 30 seconds
    --     },
    --     buy_spawn = {
    --         coords = { x = -28.28, y = -1081.49, z = 26.64 },
    --         heading = 68.87,
    --     },
    -- },
    -- Example with marker
    -- ["premium_deluxe_motorsport_3"] = {
    --     label = "Premium Deluxe Motorsport",
    --     blip = {
    --         enabled = true,
    --         sprite = 300,
    --         color = 0,
    --         scale = 0.6,
    --         short = true,
    --     },
    --     preview = {
    --         coords = { x = -55.38, y = -1096.88, z = 26.33 },
    --         heading = 213.0,
    --         type = "marker",
    --         distance = 2.0,
    --         markerData = { type = 2, scaleX = 0.5, scaleY = 0.5, scaleZ = 0.5, colorR = 0, colorG = 0, colorB = 0, colorA = 255 },
    --     },
    --     test_drive = { -- Leave it as **test_drive = {}** if you have Config.Toggles.useTestDrive set to false
    --         coords = { x = -28.28, y = -1081.49, z = 26.64 },
    --         heading = 68.87,
    --         timer = 30 -- 30 = 30 seconds
    --     },
    --     buy_spawn = {
    --         coords = { x = -28.28, y = -1081.49, z = 26.64 },
    --         heading = 68.87,
    --     },
    -- },
}

-- Do nothing on the next functions if your Config.Toggles.useJobDuty & Config.Toggles.useGangs are set to false

---@param gang table
setGangData = function (gang)
    if IsDuplicityVersion() then return end
    PlayerData.gang = gang
end

---@param duty boolean
togglePlayerDuty = function(duty)
    if IsDuplicityVersion() then return end
    PlayerData.job.duty = duty
end
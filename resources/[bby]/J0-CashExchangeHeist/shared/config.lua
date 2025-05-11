J0 = {}

-- NPC Information
J0.npcInfo = {
    model = "s_m_m_security_01", -- Security guard model
    location = vector3(143.74, -1341.56, 28.20), -- Near exchange building entrance
    heading = 230.0
}

J0.heistCoords = {
    StartLoc = {
        vec = vec3(137.64, -1334.10, 29.20),
        zname = "StartLoc"
    },
    Hack1Lock = {
        vec = vec3(127.989, -1340.056, 29.292), -- Updated to new hack panel location
        zname = "Hack1Lock"
    },
    ThermiteAnim = {
        vec = vec3(137.62, -1334.08, 29.20),
        heading = 129.72
    },
}

J0.trollysInfo = {
    [1] = {coords = vec4(132.04, -1340.37, 29.71, 329.05), type = 'cash'},
    [2] = {coords = vec4(133.83, -1339.79, 29.71, 170.17), type = 'gold'},
    [3] = {coords = vec4(133.70, -1341.37, 29.71, 200.41), type = 'cash'},
}

J0.rewardTable = {
    cash = { min = 100, max = 200 },
    gold = { min = 1, max = 2, itemname = "goldbar" }
}

-- Heist cooldown in seconds (30 minutes = 1800 seconds)
J0.heistCooldown = 1800

J0.cashExchangeDoors = {
    [1] = {coords = vec3(139.8177, -1338.359, 29.3555), heading = 125.84364318848, hash = 1163942983},
    [2] = {coords = vec3(132.1166, -1340.825, 29.65155), heading = 45.795970916748, hash = 1138434540},
    [3] = {coords = vec3(133.7509, -1347.67, 29.45731), heading = 316.00125122207, hash = GetHashKey("v_ilev_arm_secdoor")},
}

J0.dispatchInfo = {
    displayCode = "10-09A",
    title = 'Cash Exchange Heist',
    description = "Cash Exchange heist in progress",
    message = "Suspects reported at the LS Cash Exchange",
    sprite = 278,
    scale = 1.0,
    colour = 11,
    blipText = "Cash Exchange Heist",
    dispatchcodename = "j0_cashex"
}

J0.discordLogs = false
J0.discordWebHook = 'https://discord.com/api/webhooks/1249694100664619081/Z26abRL5nf8-jRgME9Seotrq3BwPdt2Qd35Fbm4qqDcst9tfqmP2NerAGAFw5ZMLFB7b'
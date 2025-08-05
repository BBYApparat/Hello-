Config = {}

-- Business Directory Configuration
Config.Jobs = {
    {
        name = "police",
        label = "Police Department",
        description = "Emergency law enforcement services",
        icon = "👮",
        color = "#3b82f6", -- Blue
        rating = 5,
        category = "Emergency Services",
        emergency = true
    },
    {
        name = "ambulance",
        label = "Emergency Medical Services",
        description = "Medical emergency response and hospital services", 
        icon = "🚑",
        color = "#ef4444", -- Red
        rating = 5,
        category = "Emergency Services",
        emergency = true
    },
    {
        name = "mechanic",
        label = "Auto Repair Services",
        description = "Vehicle repair and maintenance services",
        icon = "🔧",
        color = "#f59e0b", -- Orange
        rating = 4,
        category = "Automotive"
    },
    {
        name = "taxi",
        label = "Taxi Services",
        description = "Transportation services around the city",
        icon = "🚕",
        color = "#eab308", -- Yellow
        rating = 4,
        category = "Transportation"
    },
    {
        name = "realtor",
        label = "Real Estate Agency",
        description = "Property sales and rental services",
        icon = "🏠",
        color = "#10b981", -- Green
        rating = 4,
        category = "Real Estate"
    },
    {
        name = "lawyer",
        label = "Legal Services",
        description = "Legal consultation and court representation",
        icon = "⚖️",
        color = "#8b5cf6", -- Purple
        rating = 4,
        category = "Professional Services"
    },
    {
        name = "reporter",
        label = "News & Media",
        description = "News reporting and media coverage services",
        icon = "📰",
        color = "#6366f1", -- Indigo
        rating = 3,
        category = "Media"
    },
    {
        name = "delivery",
        label = "Delivery Services",
        description = "Package and food delivery services",
        icon = "📦",
        color = "#ec4899", -- Pink
        rating = 4,
        category = "Delivery"
    }
}

-- Categories for organizing jobs
Config.Categories = {
    "All",
    "Emergency Services",
    "Automotive", 
    "Transportation",
    "Real Estate",
    "Professional Services",
    "Media",
    "Delivery"
}

-- Phone integration settings
Config.Phone = {
    -- Default message when contacting a business
    defaultMessage = "Hello, I would like to request your services.",
    -- Show offline players (will show as unavailable)
    showOfflinePlayers = false
}
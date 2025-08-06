Config = {}

-- Business Directory Configuration
Config.Jobs = {
    -- Emergency Services
    {
        name = "police",
        label = "Police Department",
        description = "Emergency law enforcement services",
        icon = "👮",
        color = "#3b82f6", -- Blue
        rating = 5,
        category = "Emergency Services",
        emergency = true,
        image = "https://images.unsplash.com/photo-1593104547489-5cfb3839a3b5?w=800&h=400&fit=crop&auto=format"
    },
    {
        name = "ambulance",
        label = "Emergency Medical Services",
        description = "Medical emergency response and hospital services", 
        icon = "🚑",
        color = "#ef4444", -- Red
        rating = 5,
        category = "Emergency Services",
        emergency = true,
        image = "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=800&h=400&fit=crop&auto=format"
    },
    
    -- Transportation
    {
        name = "taxi",
        label = "Taxi",
        description = "Professional taxi services around the city",
        icon = "🚖",
        color = "#eab308", -- Yellow
        rating = 3,
        category = "Transportation"
    },
    
    -- Automotive
    {
        name = "mechanic",
        label = "Ls Customs",
        description = "Auto Shop - Vehicle repair and customization",
        icon = "🔧",
        color = "#f59e0b", -- Orange
        rating = 4,
        category = "Automotive",
        image = "https://images.unsplash.com/photo-1632823469883-d8582773c6a7?w=800&h=400&fit=crop&auto=format"
    },
    
    -- Food & Dining
    {
        name = "bakery",
        label = "Sprinkle Cake",
        description = "Fresh baked goods and custom cakes",
        icon = "🧁",
        color = "#f97316", -- Orange
        rating = 4,
        category = "Food",
        image = "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&h=400&fit=crop"
    },
    {
        name = "fastfood",
        label = "Burgershot", 
        description = "Fast Food - Quick meals and snacks",
        icon = "🍔",
        color = "#dc2626", -- Red
        rating = 5,
        category = "Food",
        image = "https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=800&h=400&fit=crop&auto=format"
    },
    {
        name = "restaurant",
        label = "Pipeline",
        description = "Dine In - Quality restaurant experience",
        icon = "🍽️",
        color = "#059669", -- Green
        rating = 4,
        category = "Food"
    },
    {
        name = "bar",
        label = "Bonsai Roof Bar",
        description = "Bar - Drinks and nightlife entertainment",
        icon = "🍺",
        color = "#7c2d12", -- Brown
        rating = 5,
        category = "Entertainment",
        image = "https://images.unsplash.com/photo-1572116469696-31de0f17cc34?w=800&h=400&fit=crop&auto=format"
    },
    
    -- Professional Services
    {
        name = "realtor",
        label = "Dynasty Real Estate",
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
        name = "banker",
        label = "Maze Bank",
        description = "Banking and financial services",
        icon = "🏦",
        color = "#1f2937", -- Gray
        rating = 4,
        category = "Professional Services"
    },
    
    -- Entertainment
    {
        name = "casino",
        label = "Diamond Casino",
        description = "Gaming and entertainment venue",
        icon = "🎰",
        color = "#fbbf24", -- Yellow
        rating = 4,
        category = "Entertainment"
    },
    
    -- Delivery & Transport
    {
        name = "delivery",
        label = "GoPostal",
        description = "Package and mail delivery services",
        icon = "📦",
        color = "#ec4899", -- Pink
        rating = 4,
        category = "Delivery"
    },
    {
        name = "trucking",
        label = "Ron Oil",
        description = "Fuel delivery and trucking services",
        icon = "🚛",
        color = "#374151", -- Gray
        rating = 3,
        category = "Delivery"
    },
    
    -- Media
    {
        name = "reporter",
        label = "Weazel News",
        description = "News reporting and media coverage",
        icon = "📰",
        color = "#6366f1", -- Indigo
        rating = 3,
        category = "Media"
    }
}

-- Categories for organizing jobs
Config.Categories = {
    "All",
    "Emergency Services",
    "Transportation",
    "Automotive", 
    "Food",
    "Entertainment",
    "Real Estate",
    "Professional Services",
    "Delivery",
    "Media"
}

-- Phone integration settings
Config.Phone = {
    -- Default message when contacting a business
    defaultMessage = "Hello, I would like to request your services.",
    -- Show offline players (will show as unavailable)
    showOfflinePlayers = false
}
Config = {}

-- ESX settings
Config.ESX = {
    enabled = true,
    resourceName = 'es_extended'
}

-- Database settings
Config.Database = {
    tableName = 'phone_documents'
}

-- Document settings
Config.Documents = {
    maxTitleLength = 50,
    maxContentLength = 4000,
    maxDocumentsPerPlayer = 100
}

-- Sharing settings
Config.Sharing = {
    localShareDistance = 2.5, -- Distance in meters for local sharing
    allowPermanentSharing = true,
    cooldownTime = 1000 -- Milliseconds between shares
}

-- Notification settings
Config.Notifications = {
    duration = 3000,
    position = 'top-right'
}

-- Document types configuration
Config.DocumentTypes = {
    ['license'] = {
        name = 'Driving License',
        icon = 'fa-id-card',
        color = '#3498db'
    },
    ['id'] = {
        name = 'ID Card',
        icon = 'fa-address-card',
        color = '#2ecc71'
    },
    ['registration'] = {
        name = 'Vehicle Registration',
        icon = 'fa-car',
        color = '#e74c3c'
    },
    ['permit'] = {
        name = 'Permit',
        icon = 'fa-certificate',
        color = '#f39c12'
    },
    ['certificate'] = {
        name = 'Certificate',
        icon = 'fa-award',
        color = '#9b59b6'
    },
    ['other'] = {
        name = 'Other',
        icon = 'fa-file-alt',
        color = '#95a5a6'
    }
}

-- Debug settings
Config.Debug = false
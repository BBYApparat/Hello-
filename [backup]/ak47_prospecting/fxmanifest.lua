fx_version 'cerulean'
game 'gta5'
version '1.1'
lua54 'yes'


ui_page 'html/main.html'

files {
    "html/*"
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
} 

client_scripts {
    'client/utils.lua',
    'client/main.lua',
    'client/sell.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',

    "locales/locale.lua",
    "locales/en.lua",
}

server_scripts {
    'server/utils.lua',
    'server/main.lua',
    'server/sell.lua',

    "locales/locale.lua",
    "locales/en.lua",
} 

dependencies {
    '/onesync',
    'es_extended',
}

escrow_ignore {
    "config.lua",
    "locales/*.lua",
    "server/utils.lua",
    "server/sell.lua",
    "client/utils.lua",
    "client/sell.lua",
}



dependency '/assetpacks'
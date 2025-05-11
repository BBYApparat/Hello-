fx_version 'adamant'
game 'gta5'
description 'Ak47 Ambulance Job'
author 'MenanAk47'
version '5.4'

shared_script '@es_extended/imports.lua'

ui_page 'nui/main.html'

files {
    "nui/**/*",
    'stream/*.ydr',
    'stream/*.ytd',
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop_lucas3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_medbag.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_medbox.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_saline.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_stretcher.ytyp'

client_scripts {
    "@ox_lib/init.lua",
    
    "config.lua",
    "modules/**/config.lua",

    "locales/locale.lua",
    "locales/en.lua",

    "utils/client.lua",
    "modules/**/client/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "modules/**/config.lua",

    "locales/locale.lua",
    "locales/en.lua",

    "utils/server.lua",
    "modules/**/server/*.lua",
    "webhooks.lua",
}

escrow_ignore {
    "INSTALL ME FIRST/**/*",
    "locales/*",
    "config.lua",
    "modules/**/config.lua",
    "modules/**/customizable.lua",
    "webhooks.lua",
    "utils/*.lua",
}

lua54 'yes'

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'screenshot-basic',
    '/onesync', --don't remove. enable onesync with infinity from txAdmin setting
}

dependency '/assetpacks'
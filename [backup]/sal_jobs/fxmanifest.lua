fx_version 'adamant'
game 'gta5'
lua54 "yes"


shared_scripts {
    "@es_extended/imports.lua",
    "config.lua"
}

client_scripts {
    '@ox_lib/init.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    "client/editable.lua",
    "client/main.lua",
    "client/jobsellers.lua",
    "client/fishing.lua",
    "client/hunting.lua",
}

server_scripts {
    "server/main.lua",
    "server/editable.lua",
    "server/jobsellers.lua",
    "server/fishing.lua",
    "server/hunting.lua",
}

escrow_ignore {
    "u/*.lua",
    "u/server/*.lua",
    "u/client/*.lua",
    "config.lua",
    "server/editable.lua",
    "client/editable.lua"
}

dependencies {
    "ox_lib",
    "PolyZone",
    "es_extended",
    "progressbar",
    -- "inventory",
    "ps-ui",
}

dependency '/assetpacks'
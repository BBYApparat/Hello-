fx_version 'adamant'
game 'gta5'
lua54 "yes"

shared_scripts {
    "@es_extended/imports.lua",
	'locale.lua',
	'locales/en.lua',
    'config/config.lua',
    'config/status.lua',
    'config/vehicle_failure.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    "server/classes/*.lua",
    "server/main.lua",
    "server/licenses.lua",
    "server/addonaccount.lua",
    "server/service.lua",
    "server/status.lua",
}

client_scripts {
    "client/classes/*.lua",
    "client/main.lua",
    "client/service.lua",
    "client/status.lua",
    "client/vehicle_failure.lua",
}
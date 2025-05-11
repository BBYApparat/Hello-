fx_version 'adamant'
game 'gta5'
description 'Ak47 Carboosting'
author 'MenanAk47'
version '1.3'

ui_page 'web/build/index.html'
files {
	'web/build/index.html',
	'web/build/**/*',
}

client_scripts {
	"@ox_lib/init.lua",
	"config.lua",
	"config-hacking.lua",
	"config-shop.lua",
	"config-useable.lua",

	"locales/locale.lua",
	"locales/en.lua",

	"framework/client/*.lua",
	"utils/client.lua",

	"client/functions.lua",
	"client/main.lua",
	"client/mission.lua",
	"client/customizable.lua",
	"client/useable.lua",
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"@ox_lib/init.lua",
	"config.lua",
	"config-hacking.lua",
	"config-shop.lua",
	"config-useable.lua",

	"locales/locale.lua",
	"locales/en.lua",

	"framework/server/*.lua",
	"utils/server.lua",

	"server/main.lua",
	"server/functions.lua",
	"server/useable.lua",

	"webhooks.lua",
}

escrow_ignore {
	"INSTALL ME FIRST/**/*",
    "config*.lua",
    "locales/*.lua",
    "client/customizable.lua",
    "utils/*",
    "framework/**/*",
    "webhooks.lua",
}

lua54 'yes'

dependencies {
    'es_extended',
    'ox_lib',
    'ps-ui',
}
dependency '/assetpacks'
fx_version 'adamant'
game 'gta5'
description 'ak47 clothing'
author "MenanAk47 (MenanAk47#3129)"
version "4.7"

provide 'esx_skin'

shared_script '@es_extended/imports.lua'

files {
	'html/index.html',
	'html/style.css',
	'html/screen.css',
	'html/reset.css',
	'html/script.js',
	'html/icons/*.png'
}

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'config-*.lua',
	'server/utils.lua',
	'server/skin.lua',
	'server/job.lua',
	'server/main.lua',

	'locales/locale.lua',
    'locales/en.lua',
}

client_scripts {
	'config.lua',
	'config-*.lua',
	'client/utils.lua',
	'client/skin.lua',
	'client/billing.lua',
	'client/job.lua',
	'client/core.lua',
	'client/menu.lua',
	'client/datastore.lua',
	'client/cam.lua',

	'locales/locale.lua',
    'locales/en.lua',
}

escrow_ignore {
	'INSTALL ME FIRST/**/*',
	'locales/*.lua',
    'config.lua',
    'config-*.lua',
    'server/utils.lua',
    'server/skin.lua',
    'client/utils.lua',
    'client/skin.lua',
}

dependencies {
	'es_extended',
	'esx_internals',
}

lua54 'yes'
dependency '/assetpacks'
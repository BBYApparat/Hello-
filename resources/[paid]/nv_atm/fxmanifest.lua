fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Nevera Development'
description '[ESX] Realistic ATM'
version '1.1.0'

shared_script {
	'@es_extended/imports.lua',
	'@sleepless_interact/init.lua',
}

server_scripts {
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'events.lua',
	'client/client.lua'
}
files {
    'html/index.html',
    'html/assets/js/**',
    'html/assets/css/**',
    'html/assets/img/**'
}
ui_page 'html/index.html'


escrow_ignore{
	'config.lua',
	'events.lua',
	--'server/*',
	--'client/*'
}
dependency '/assetpacks'
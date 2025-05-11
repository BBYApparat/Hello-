fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Nyambura'
description 'Allows players to collect garbage for money'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
	'translations/*.lua',
	'config.lua',
	'core.lua'
}

client_script {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua'
}

server_script 'server/main.lua'

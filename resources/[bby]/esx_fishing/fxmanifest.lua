client_script '@ak47/client/native.lua'
server_script '@ak47/server/native.lua'
fx_version 'cerulean'
game 'gta5'

description 'esx_fishing'
version '1.0.0'

dependencies {
    'PolyZone',
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

lua54 'yes'
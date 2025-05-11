fx_version 'adamant'
game 'gta5'
author 'nyambura'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua',
    'zone.lua',
	'translations/*.lua',
	'core.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

lua54 "yes"

escrow_ignore {
	'config.lua',
	'translations/**.**',
	'shared/**.**'
}

dependency "/assetpacks"
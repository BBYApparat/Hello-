fx_version 'adamant'
game 'gta5'
author 'nyambura'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua',
	'translations/*.lua',
	'core.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

lua54 "yes"

dependency "/assetpacks"
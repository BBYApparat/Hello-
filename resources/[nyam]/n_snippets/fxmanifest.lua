fx_version 'cerulean'
game 'gta5'

version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'configs/*.lua',
	'translations/*.lua',
    'core.lua'
}

client_scripts {
    'client/main.lua',
    'client/rnd/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/rnd/*.lua',
}

dependency 'oxmysql'

lua54 'yes'
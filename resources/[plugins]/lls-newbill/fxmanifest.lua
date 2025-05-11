--client_script '@ak47/client/native.lua'
--server_script '@ak47/server/native.lua'
fx_version 'cerulean'
games { 'gta5' }

author 'DiVouz'
description 'Receipt system for shops based on Roleplay'
version '1.0.2'

lua54 'on'
is_cfxv2 'yes'
use_fxv2_oal 'true'

ui_page 'client/ui/index.html'
files {
	'client/ui/index.html',
	'client/ui/js/**/*.js',
    'client/ui/css/**/*.css',
    'client/ui/img/**/*.png'
}

client_scripts {
    'config/client_functions.lua',

    'client/core.lua',
    'client/commands.lua',
    'client/api.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    
    'config/server_functions.lua',
    
    'server/version.lua',
    'server/core.lua'
}

shared_scripts {
    'config/core.lua'
}

escrow_ignore {
	'client/**/*.lua',
	'config/**/*.lua',
	'server/**/*.lua'
}

dependencies {
    'es_extended'
}

dependency '/assetpacks'
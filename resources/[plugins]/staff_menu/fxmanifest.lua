fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Server Staff Menu'
description 'Advanced Staff Menu with Role-Based Permissions'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'shared/config.lua'
}

client_scripts {
    'NativeUI.lua',
    'client/main.lua',
    'client/blips.lua',
    'client/menu.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/callbacks.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
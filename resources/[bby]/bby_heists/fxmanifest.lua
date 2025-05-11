fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'BBQ and Pizza System'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

lua54 'yes'

dependencies {
    'es_extended',
    'ox_lib',
    'ox_inventory'
}
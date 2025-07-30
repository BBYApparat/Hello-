fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'BBY Server'
description 'BBY Jobs System - Duty management with dynamic blip'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'shared/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
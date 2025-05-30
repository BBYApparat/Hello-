fx_version 'cerulean'
game 'gta5'

name 'cow-milking'
description 'Cow Milking Script with ox_target and ps-minigames'
author 'YourName'
version '1.0.0'

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

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'ps-minigames'
}

-- Add item to ox_inventory

lua54 'yes'
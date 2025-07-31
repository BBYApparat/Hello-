fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Simple Housing System with Routing Buckets'
version '1.0.0'

shared_script '@es_extended/imports.lua'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'oxmysql',
    'ox_target',
    'ox_inventory',
    'es_extended'
}
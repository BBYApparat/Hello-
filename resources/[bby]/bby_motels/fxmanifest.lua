fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Motel Room Script with ox_target Integration'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'drop_s.lua'
}

client_scripts {
    'client.lua',
    'drop_c.lua'
}

dependencies {
    'oxmysql',
    'ox_target',
    'es_extended'
}

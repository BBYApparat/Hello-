fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'bby_carsuitcase'
description 'Suitcase spawning and theft system for parked cars'
author 'BBY'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
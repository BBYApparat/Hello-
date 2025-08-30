fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'bby_criminal'
description 'Criminal activities - car looting and postbox theft system'
author 'BBY'
version '2.0.0'

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
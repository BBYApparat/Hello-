fx_version 'cerulean'
game "gta5"

description 'MajesticDev + Skeleton Network'
version '1.0.0'
lua54 'yes'

ui_page 'build/index.html'
-- ui_page 'test.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

client_script 'client.lua'

files {
    'frameworks/*.lua',
    'frameworks/server/*.lua',
    'build/*',
    'test.html',
}

dependency '/assetpacks'

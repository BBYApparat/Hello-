fx_version 'bodacious'
game 'gta5'

name "Rep Scripts - Weed"
author "Q4D#1905"
version "3.1.0"

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/framework/*.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework/*.lua',
    'server/*.lua',
    'server/hyperdata.js'
}

escrow_ignore {
    'client/cl_function.lua',  -- Only ignore one file
    'client/framework/*.lua',  -- Only ignore one file
    'server/sv_function.lua',  -- Only ignore one file
    'server/framework/*.lua',  -- Only ignore one file
    'stream/anim@vx_watercan@garden.ycd',
    'stream/firesans.gfx',
    'config.lua',
    'README.MD',
    'INSTALL.md'
}
ui_page 'html/index.html'
files { 'html/index.html', 'html/app.js' }

lua54 'yes'
dependency 'ox_lib'
dependency '/assetpacks'
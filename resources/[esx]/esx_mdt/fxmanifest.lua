fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'ESX Mobile Data Terminal - Converted from Mythic Framework'
author 'Claude Code Assistant'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*.lua'
}

client_scripts {
    'client/**/*.lua'
}

ui_page 'ui/dist/index.html'

files {
    'ui/dist/index.html',
    'ui/dist/main.js'
}

dependencies {
    'es_extended',
    'oxmysql'
}
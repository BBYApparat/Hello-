fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Nyambura'
description 'Simple crosshair.'
version '1.0'

client_scripts {
    '@ox_lib/init.lua',
    'client/*.lua'
}

ui_page 'ui/index.html'

files {
    'ui/crosshair.png',
    'ui/index.html',
    'ui/script.js',
    'ui/style.css'
}
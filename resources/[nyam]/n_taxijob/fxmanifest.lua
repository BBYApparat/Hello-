fx_version 'cerulean'
game 'gta5'

description 'N Taxi Job'
version '1.1.0'

ui_page 'html/meter.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'translations/en.lua',
}

dependencies {
    'PolyZone',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_script 'server/main.lua'

files {
    'html/meter.css',
    'html/meter.html',
    'html/meter.js',
    'html/reset.css',
    'html/g5-meter.png'
}

lua54 'yes'

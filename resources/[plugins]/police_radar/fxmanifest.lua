fx_version 'cerulean'
game 'gta5'

description 'Police Helicopter Radar System'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/map.png'
}

dependencies {
    'es_extended',
    'ox_target'
}
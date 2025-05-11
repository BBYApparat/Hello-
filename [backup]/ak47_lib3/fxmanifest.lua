fx_version 'cerulean'
game 'gta5'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    
    '**/server/*'
} 

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    
    '**/client/*'
}

lua54 'yes'

dependencies {
    'es_extended',
    '/server:5181', -- requires at least server build 5181
}
dependency '/assetpacks'
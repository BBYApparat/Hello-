lua54 'yes'
game 'gta5'
fx_version 'cerulean'

server_scripts {
    'config/webhooks.lua',
    'server/server.lua',
    'server/functions.lua',
    'server/explotions.lua',
    'server/needsteam.lua',
    'config/notifications.lua',
}

client_scripts {
    'client/client.lua',
    'client/functions.lua',
    'client/weapons.lua'
}

files {
    'config/*.json',
    'locals/*.json',
    'json/*.json'
}
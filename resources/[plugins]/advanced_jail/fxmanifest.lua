fx_version 'bodacious' 
game 'gta5'

client_scripts {
    'config.lua',
    'client/client.lua',
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    'config.lua',
    'server/server.lua',
    'server/items.lua',
    'server/sync.lua',
}
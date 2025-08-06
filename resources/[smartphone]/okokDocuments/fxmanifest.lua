lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'okokDocuments - ESX Document System'
description 'Document management system for okokPhone and ESX'

shared_scripts {
      "init.lua",
      "config.lua"
}

client_scripts {
      'client/utils.lua', -- This contains utility functions, so it should start first
      'client/client.lua'
}

server_scripts {
      '@oxmysql/lib/MySQL.lua',
      'server/utils.lua', -- This contains utility functions, so it should start first
      'server/server.lua'
}

ui_page 'web/app.html'

files {
      'web/**/*'
}

dependencies {
      'es_extended',
      'okokPhone',
      'oxmysql'
}
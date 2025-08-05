lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'luxu.gg'
description 'okokPhone Info App - View state ID, bank balance, cash, job, and gang info'

dependencies {
    'es_extended',
    'okokPhone'
}

shared_scripts {
      "init.lua"
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
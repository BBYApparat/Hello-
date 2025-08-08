lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'luxu.gg'
description 'Job Manager App for okokPhone - Complete employee management system for job bosses'
version '1.0.0'

dependencies {
    'ox_lib',
    'oxmysql'
}

shared_scripts {
      "init.lua",
      '@ox_lib/init.lua'
}

client_scripts {
      'client/utils.lua', -- This contains utility functions, so it should start first
      'client/client.lua'
}

server_scripts {
      'server/utils.lua', -- This contains utility functions, so it should start first
      'server/server.lua'
}

ui_page 'web/app.html'

files {
      'web/**/*'
}

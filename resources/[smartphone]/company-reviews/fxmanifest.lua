lua54 'yes'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'luxu.gg'
description 'Company Reviews App for okokPhone - Google Reviews style app for rating and reviewing local businesses'
version '1.0.0'

dependencies {
    'ox_lib',
    'oxmysql'
}

shared_scripts {
      "init.lua"
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

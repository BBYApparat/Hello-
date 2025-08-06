lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'luxu.gg'
description 'okokPhone Business Directory - Find and contact service providers'

dependencies {
    'es_extended',
    'okokPhone'
}

-- Optional dependency for mugshots (recommended)
optional_dependencies {
    'MugShotBase64'
}

shared_scripts {
      "config.lua",
      "init.lua"
}

client_scripts {
      'client/utils.lua',
      'client/client.lua'
}

server_scripts {
      '@oxmysql/lib/MySQL.lua',
      'server/utils.lua',
      'server/server.lua'
}

ui_page 'web/app.html'

files {
      'web/**/*'
}
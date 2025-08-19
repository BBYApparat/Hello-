fx_version 'cerulean'
game 'gta5'
author 'atiysu'
description 'Script made by atiysu'
version '1.0.0'
lua54 'yes'

dependencies {
    'ox_target'
}

shared_scripts {
    'shared/*.lua',
}

client_scripts {
    'client/utils.lua',
    'client/nui.lua',
    'client/main.lua',
    'client/events.lua',
    'client/catalog.lua',
}

server_scripts {
    'server/utils.lua',
    'server/callbacks.lua',
    'server/events.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/**/*',
}

escrow_ignore {
  "shared/*.lua",
  "client/**/*",
  "server/**/*",
}
dependency '/assetpacks'
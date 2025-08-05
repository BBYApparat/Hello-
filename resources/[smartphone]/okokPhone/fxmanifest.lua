fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'


name 'okokPhone'
author 'Luxu <luxu@luxu.gg>'
version '0.4.2'

dependencies { '/server:7290', '/onesync', 'okokPhone_props' }

shared_scripts { 'shared/abranete.lua', 'shared/utils.lua', 'shared/init.lua', --[[ 'shared/test_init.lua' ]] }

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/checker.lua',
  'server/modules/*',
  'server/apps/*',
  'server/os/*',
  'server/server.lua',
  'server/server.js',
}

client_scripts { 'client/modules/*', 'client/apps/*', 'client/client.lua' }

ui_page 'web/index.html'

files {
  'locales/*.json',
  'shared/framework.lua',
  'client/open/*',
  'config/apps/*.lua',
  'config/config.lua',
  'config/apps.json',
  'web/**/*',
  'bridge/client/*.lua',
}

escrow_ignore {
  'client/open/*',
  'client/import/*',
  'server/open/*',
  'shared/framework.lua',
  'server/apps/garage.lua',
  'bridge/**/*',
  'config/**/*',
}

dependency '/assetpacks'
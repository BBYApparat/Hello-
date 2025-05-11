fx_version 'adamant'
version '1.3'
game 'gta5'
author 'CodeStudio'
description 'Fingerprint Scanner'

ui_page 'ui/index.html'

shared_scripts {'@ox_lib/init.lua', 'config/config.lua'}
client_scripts {'main/client.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua', 'main/server.lua', 'config/open.lua'}

files {'ui/**'}

escrow_ignore {'config/**'}

dependencies {'oxmysql', 'ox_lib'}

lua54 'yes'

dependency '/assetpacks'
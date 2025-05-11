fx_version 'cerulean'
game 'gta5'

ui_page "html/index.html"
lua54 'yes'

shared_scripts {
  '@es_extended/imports.lua',
  '@ox_lib/init.lua',
  'shared.lua',
}

files {
  "html/index.html",
  "html/config.js",
  "html/js/script.js",
  "html/css/style.css",
  'html/images/*.jpg'
}

client_scripts {
  'client.lua',
}
 server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'shared.lua',
  'server.lua',
 }

 escrow_ignore {
  "shared.lua",
  "server.lua",
  "client.lua",
 }
dependency '/assetpacks'
dependency '/assetpacks'
dependency '/assetpacks'
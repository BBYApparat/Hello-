fx_version "cerulean"

description "A boilerplate is being made for solving recursive actions while scripting in FiveM"
author "GFX Development"
version '1.0.0'
repository 'https://github.com/GFX-Fivem/fivem-script-boilerplate'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page "html/input.html"

files {
	'html/input.html',
	'html/screen.html',
	'html/*.jpg',
	'html/*.png'
}

client_scripts {
  "client/utils.lua",
  "client/cl_*.lua",
}
server_script {
  "server/utils.lua",
  "server/sv_*.lua",
}
shared_script {
  "shared/sh_*.lua",
}

escrow_ignore {
  "client/utils.lua",
  "server/utils.lua",
  "shared/sh_*.lua",
}
dependency '/assetpacks'
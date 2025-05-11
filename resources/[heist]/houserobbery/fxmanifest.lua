--client_script '@ak47/client/native.lua'
--server_script '@ak47/server/native.lua'
fx_version 'adamant'
games { 'rdr3', 'gta5' }
this_is_a_map 'yes'
lua54 'yes'

shared_script '@ox_lib/init.lua'

ui_page 'html/index.html'

client_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'client/main.lua',
    'client/ped_spawn.lua',
}

server_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'server/main.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_shop.ytyp'

files {
	"html/index.html",
	"html/scripts.js",
	"html/css/style.css",
	"stream/v_int_shop.ytyp"
}

fx_version 'adamant'

game 'gta5'

lua54 "yes"

client_only "yes"

description 'ESX Menu Default Redesign'

client_scripts {
	'@es_extended/client/wrapper.lua',
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
}

dependencies {
	'es_extended'
}
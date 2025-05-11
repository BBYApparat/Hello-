fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependencies {
	'ox_lib',
	'MugShotBase64'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

client_script 'client/main.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

ui_page 'web/index.html'

files {
	'web/index.html',
	'web/css/style.css',
	'web/flags/*.png',
	'lang/global.js',
	'web/js/*.js',
	'web/badges/*.png',
}

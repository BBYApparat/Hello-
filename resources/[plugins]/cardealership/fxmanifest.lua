fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    '@ox_lib/init.lua',
    'client/staffmenu.lua',
    'client/main.lua',
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
    'html/images/*.jpg'
}

dependencies {
    'es_extended',
    'oxmysql',
    'esx_menu_dialog'
}
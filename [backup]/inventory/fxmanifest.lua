fx_version 'cerulean'
games { 'gta5' }

lua54 "yes"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'@es_extended/imports.lua',
	'config.lua',
	'config/*.lua',
	'locales/en.lua',
	'shared/*.lua',
	'server/functions/*.lua',
	'server/main.lua',
    'server/crafting.lua',
    'server/handsup.lua',
    'server/interaction.lua',
    'server/save.lua',
	'server/shops.lua',
    'server/usableitems.lua',
    'server/smoking.lua',
	'server/editable.lua',
    'server/weapons.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'@es_extended/imports.lua',
	'config.lua',
	'config/*.lua',
	'locales/en.lua',
	'shared/*.lua',
	'client/commands.lua',
	'client/interaction.lua',
	'client/functions.lua',
    'client/main.lua',
	'client/drops.lua',
	'client/crafting.lua',
	'client/drawanims.lua',
    'client/handsup.lua',
	'client/shops.lua',
	'client/smoking.lua',
    'client/usableitems.lua',
	'client/utils.lua',
	'client/weaponback.lua',
    'client/weapons.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/*.svg',
	'html/images/*.png',
	'html/idcard/*.png',
	'html/images/*.jpg',
	'html/buttons/*.jpg',
	'html/buttons/*.png',
	'html/ammo_images/*.png',
	'html/attachment_images/*.png',
	'html/*.ttf',
}

dependencies {
    'ox_target',
	'progressbar',
	'es_extended'
}

escrow_ignore {
	'config.lua',
    'locales/*.lua',
	'config/*.lua',
	'shared/*.lua',
	'client/u/*.lua',
	'client/crafting.lua',
	'client/drawanims.lua',
	'client/drops.lua',
	'client/functions.lua',
	'client/handsup.lua',
	'client/interaction.lua',
	'client/shops.lua',
	'client/smoking.lua',
	'client/usableitems.lua',
	'client/utils.lua',
	'client/weapons.lua',
	'client/weaponback.lua',
	'server/editable.lua',
	'server/usableitems.lua',
	'server/smoking.lua',
	'server/weapons.lua',
	'server/shops.lua',
	'server/interaction.lua',
	'server/handsup.lua',
	'server/crafting.lua',
	'server/functions/*.lua',
	'server/u/*.lua',
}

dependencies {
    '/server:4752',
    '/onesync',
}

dependency '/assetpacks'
dependency '/assetpacks'
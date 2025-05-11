fx_version 'adamant'
game 'gta5'
description 'Ak47 Vehicle Extra'
version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/utils.lua',
	'client/main.lua',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
    'client/utils.lua',
}

lua54 'yes'
dependency '/assetpacks'
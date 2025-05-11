fx_version 'bodacious'
game 'gta5'

lua54 'yes'


shared_script '@es_extended/imports.lua'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/*.lua',
}

client_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'client/*.lua',
}

escrow_ignore {
    'config.lua',
}

lua54 'yes'
dependency '/assetpacks'
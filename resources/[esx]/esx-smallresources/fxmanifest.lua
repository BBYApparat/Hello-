fx_version 'cerulean'
game 'gta5'

description 'ESX-SmallResources'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'config_mdt.lua'
}

server_scripts {
    'server/*.lua',
    'server/*.js'
}

client_scripts {
    'client/*.lua'
}

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
    'events.meta',
    'popgroups.ymt',
    'relationships.dat'
}

exports {
    'HasHarness'
}

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'es_extended'
}
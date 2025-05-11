fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
}

client_scripts {
  'client/*.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua'
}

files {
  'config/*.lua',
}

escrow_ignore {
  'config/*.lua',
  'client/cl_main.lua',
  'client/madrazo.lua',
  'client/vehicle_robbery.lua',
  'server/sv_main.lua',
  'stream/*.ytyp',
  'stream/*.ydr',
}

data_file 'DLC_ITYP_REQUEST' 'stream/spray_propsfw.ytyp'
dependency '/assetpacks'
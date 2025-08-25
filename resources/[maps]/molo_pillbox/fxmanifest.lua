fx_version 'bodacious'
games { 'gta5' }

this_is_a_map "yes"
lua54 'yes'

client_scripts {
    'npc.lua'
}

data_file 'AUDIO_GAMEDATA' 'audio/molo_pillbox_game.dat'
data_file 'AUDIO_GAMEDATA' 'audio/molo_pillbox_down_game.dat'
data_file 'AUDIO_GAMEDATA''audio/molo_pillbox_up_game.dat' 
data_file 'AUDIO_GAMEDATA''audio/molo_pillbox_door_game.dat.rel'


files {
   'audio/molo_pillbox_down_game.dat151.rel',
  'audio/molo_pillbox_game.dat151.rel',
  'audio/molo_pillbox_up_game.dat151.rel',
  'audio/molo_pillbox_door_game.dat151.rel'
}
escrow_ignore {
  'stream/unlockfiles/*',
  'client',
  'server',
  'shared',
  'src'

  
  }
  
client_scripts{
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "client/cl_ascenceur.lua"
}

server_scripts{
    "server/sv_ascenceur.lua"
}

shared_scripts{
    "shared/config.lua"
}

dependency '/assetpacks'
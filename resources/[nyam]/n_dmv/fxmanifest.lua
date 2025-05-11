fx_version 'bodacious'
lua54 'yes' 
game 'gta5' 

author 'Nyambura'
description 'DMV School - N DevelopmentS'
version '1.0'

shared_scripts {
    'translations/*.lua',
    'configs/config.lua',
    'configs/questions.lua',
    'core.lua',
}

client_scripts {
    'client/main.lua'
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
   'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.otf',
    'web/img/*.png',
}

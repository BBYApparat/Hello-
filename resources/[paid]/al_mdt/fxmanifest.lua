fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.2'

files {
    'ui/dist/index.html',
    'ui/dist/js/*.js',
    'ui/dist/css/*.css',
    'ui/media/*.ogg',
}

ui_page 'ui/dist/index.html'

client_scripts {
    -- Config & utilities
    'config/config.lua',
    'config/mdt_config.lua',
    'config/criminalcode.lua',
    'client/framework.lua',
    'client/utils.lua',

    -- Nui related
    'client/nui/nui.lua',
    'client/nui/modules/*.lua',

    -- Core
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', -- If you're NOT using mysql-async, you can comment this line out

    'config/server_config.lua',
    'server/key.lua',
    'server/main.lua',
    'server/framework.lua',
    'server/modules/*.lua',
    'server/logging.lua',
}

escrow_ignore {
    -- Configs
    'config/*.lua',

    -- Client
    'client/*.lua',
    'client/nui/nui.lua',
    'client/nui/modules/*.lua',

    -- Server
    'server/main.lua',
    'server/framework.lua',
    'server/modules/*.lua',
    'server/logging.lua',
}

export 'TriggerPanicButton' -- Client export
--[[
    Usage (Only client sided):

    exports['al_mdt']:TriggerPanicButton()
]]

--[[
    Net Events

    (This event is triggered when a player has clocked in -- this can be used to trigger certain actions after a player has clocked in)
    RegisterNetEvent('al_mdt:ClockedIn', function()
        print('HAS CLOCKED IN!')
    end)

    (This event is triggered when a player has clocked out -- this can be used to trigger certain actions after a player has clocked out)
    RegisterNetEvent('al_mdt:ClockedOut', function()
        print('HAS CLOCKED OUT!')
    end)
]]
dependency '/assetpacks'
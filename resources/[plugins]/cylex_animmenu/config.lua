Config = {
    Debug = false,

    EnableWalkInMenu = true,
    -- Keybinds
    AllowedInCars = false,
    DisarmPlayer = true,
    CancelEmoteKey = "X",

    Notification = function(msg)
        -- default
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(0, 1)
        ------------
        -- Change this if you want to use another notification system. 
        -- TriggerEvent('notification', msg)
    end,

    WalkingStyles = true,
    PersistentWalk = true,
    AdultEmotesDisabled = false,

    SharedEmotes = true,
    animations = {
        ["Walks"] = {
            {
                name = "reset",
                dict = "reset",
                label = "Reset",
                categ = "Walks",
            },
        },
        ["Expressions"] = {
            {
                name = "reset",
                dict = "reset",
                label = "Reset",
                categ = "Expressions",
            },
            
        }
    }
}

CreateThread(function()
    if IsDuplicityVersion() then return end
    RegisterCommand('walk', function(source, args) 
        TriggerEvent('cylex_animmenu:client:walk', args[1]) 
    end)
    RegisterCommand('emotecancel', function() 
        TriggerEvent('cylex_animmenu:client:cancelAnim')
    end, false)
    RegisterKeyMapping("emotecancel", "Cancel current emote", "keyboard", Config.CancelEmoteKey)

    RegisterCommand('e', function(source, args, raw) TriggerEvent('cylex_animmenu:client:playAnim', args) end, false)

    
    RegisterCommand('emotemenu', function()
        TriggerEvent('cylex_animmenu:client:openMenu')
    end)
    
    RegisterKeyMapping('emotemenu', 'Animasyon menüsünü açar', 'keyboard', 'F4')
end)

Config.Language = 'en'
Config.Languages = {
    ['en'] = {
        ['header_1'] = 'CYLEX DEV',
        ['header_2'] = 'Emote Menu',
        ['search'] = 'Animation name...',
        ['all'] = 'All',
        ['favorites'] = 'Favorites',

        ['not_a_valid_emote'] = "is not a valid emote!",
        ['not_playing_any_emote'] = "You don't do any emote to cancel!",
        ['invalid_texture_var'] = "Invalid texture variation. Valid selections are: %s",
        ['doyouwanna'] = "~y~Y~w~ to accept, ~r~L~w~ to refuse",
        ['request_sent'] = "Sent request to ",
        ['no_player_found'] = "Nobody close to you!",
    },
    ['tr'] = {
        ['header_1'] = 'CYLEX DEV',
        ['header_2'] = 'Emote menu',
        ['search'] = 'Animasyon adı...',
        ['all'] = 'Tümü',
        ['favorites'] = 'Favoriler',

        ['not_a_valid_emote'] = "geçerli bir emote değil!",
        ['not_playing_any_emote'] = "İptal edebileceğin bir emote yok!",
        ['invalid_texture_var'] = "Invalid texture variation. Valid selections are: %s",
        ['doyouwanna'] = "Onaylamak için~y~Y~w~, iptal etmek için ~r~L~w~ bas.",
        ['request_sent'] = "Animasyon isteği gönderildi. ",
        ['no_player_found'] = "Yakında kimse yok!.",
    }
}

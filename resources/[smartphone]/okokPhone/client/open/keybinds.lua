if not Config.Keybindings then return end

if Config.Keybindings.answer.enabled then
    Ok.addKeybind({
        name        = "AcceptIncomingCall",
        defaultKey  = Config.Keybindings.answer.key,
        description = Config.Keybindings.answer.description,
        onPressed   = function()
            fetchNUI("acceptCall")
        end,
    })
end

if Config.Keybindings.hangup.enabled then
    Ok.addKeybind({
        name        = "RejectIncomingCall",
        defaultKey  = Config.Keybindings.hangup.key,
        description = Config.Keybindings.hangup.description,
        onPressed   = function()
            fetchNUI("rejectCall")
        end,
    })
end

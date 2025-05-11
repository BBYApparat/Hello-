CreateThread(function()
    local keybind = lib.addKeybind({
        name = 'crosshai_mouse_right_1',
        description = 'press F to pay respects',
        defaultKey = 'MOUSE_RIGHT',
        defaultMapper = 'mouse_button',
        onPressed = function(self)
            if cache.weapon then
                SendNUIMessage({display = "crosshairShow"})
            end
        end,
        onReleased = function(self)
            SendNUIMessage({display = "crosshairHide"})
        end
    })
end)
---@class TextUI
local textui = {}

local position = 'right'
local playSound = true

---@param message string
function textui.show(key, message)
    local text = string.format('[%s] %s', key, message)
    if GetResourceState('okokTextUI') == 'started' then
        exports['okokTextUI']:Open(text, "lightblue", position, playSound)
    elseif GetResourceState("ps-ui") == 'started' then
        exports['ps-ui']:DisplayText(text, "green")
    else
        exports.ox_lib:showTextUI(text)
    end
end

function textui.hide()
    if GetResourceState('okokTextUI') == 'started' then
        exports['okokTextUI']:Close()
    elseif GetResourceState("ps-ui") == 'started' then
        exports['ps-ui']:HideText()
    else
        exports.ox_lib:hideTextUI()
    end
end

return textui

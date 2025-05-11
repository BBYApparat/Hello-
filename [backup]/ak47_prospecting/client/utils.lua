ESX = ESX or nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.SharedObjectName, function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end
    CreateBlip()
end)

RegisterNetEvent('ak47_prospecting:notify', function(msg)
    ESX.ShowNotification(msg)
end)

RegisterNetEvent('ak47_prospecting:progress', function(msg, time)
    TriggerEvent('inventory:progress', time, msg)
end)

function CreateBlip()
    for i, v in ipairs(Config.Zones) do
        if v.blip.enable then
            local blip = AddBlipForCoord(v.location)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipHighDetail(blip, false)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, v.blip.color)
            SetBlipScale(blip, v.blip.size)
            SetBlipDisplay(blip, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.name)
            EndTextCommandSetBlipName(blip)

            local blip2 = AddBlipForRadius(v.location, v.radius)
            SetBlipHighDetail(blip2, false)
            SetBlipAsShortRange(blip2, true)
            SetBlipAlpha(blip2, 50)
            SetBlipColour(blip2, v.blip.color)
            SetBlipDisplay(blip2, 8)
        end
    end
end

DrawTxt3D = function(coords, text)
    local str = text
    AddTextEntry(GetCurrentResourceName(), str)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

Scaleforms = {}

Scaleforms.LoadMovie = function(name)
    local scaleform = RequestScaleformMovie(name)
    while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
    return scaleform
end

Scaleforms.LoadInteractive = function(name)
    local scaleform = RequestScaleformMovieInteractive(name)
    while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
    return scaleform
end

Scaleforms.UnloadMovie = function(scaleform)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

Scaleforms.LoadAdditionalText = function(gxt, count)
    for i = 0, count, 1 do
        if not HasThisAdditionalTextLoaded(gxt, i) then
            ClearAdditionalText(i, true)
            RequestAdditionalText(gxt, i)
            while not HasThisAdditionalTextLoaded(gxt, i) do Wait(0); end
        end
    end
end

Scaleforms.SetLabels = function(scaleform, labels)
    PushScaleformMovieFunction(scaleform, "SET_LABELS")
    for i = 1, #labels, 1 do
        local txt = labels[i]
        BeginTextCommandScaleformString(txt)
        EndTextCommandScaleformString()
    end
    PopScaleformMovieFunctionVoid()
end

Scaleforms.PopMulti = function(scaleform, method, ...)
    PushScaleformMovieFunction(scaleform, method)
    for _, v in pairs({...}) do
        local trueType = Scaleforms.TrueType(v)
        if trueType == "string" then
            PushScaleformMovieFunctionParameterString(v)
        elseif trueType == "boolean" then
            PushScaleformMovieFunctionParameterBool(v)
        elseif trueType == "int" then
            PushScaleformMovieFunctionParameterInt(v)
        elseif trueType == "float" then
            PushScaleformMovieFunctionParameterFloat(v)
        end
    end
    PopScaleformMovieFunctionVoid()
end

Scaleforms.PopFloat = function(scaleform, method, val)
    PushScaleformMovieFunction(scaleform, method)
    PushScaleformMovieFunctionParameterFloat(val)
    PopScaleformMovieFunctionVoid()
end

Scaleforms.PopInt = function(scaleform, method, val)
    PushScaleformMovieFunction(scaleform, method)
    PushScaleformMovieFunctionParameterInt(val)
    PopScaleformMovieFunctionVoid()
end

Scaleforms.PopBool = function(scaleform, method, val)
    PushScaleformMovieFunction(scaleform, method)
    PushScaleformMovieFunctionParameterBool(val)
    PopScaleformMovieFunctionVoid()
end

Scaleforms.PopRet = function(scaleform, method)
    PushScaleformMovieFunction(scaleform, method)
    return PopScaleformMovieFunction()
end

Scaleforms.PopVoid = function(scaleform, method)
    PushScaleformMovieFunction(scaleform, method)
    PopScaleformMovieFunctionVoid()
end

Scaleforms.RetBool = function(ret)
    return GetScaleformMovieFunctionReturnBool(ret)
end

Scaleforms.RetInt = function(ret)
    return GetScaleformMovieFunctionReturnInt(ret)
end

Scaleforms.TrueType = function(val)
    if type(val) ~= "number" then return type(val); end
    local s = tostring(val)
    if string.find(s, '.') then
        return "float"
    else
        return "int"
    end
end

createInstructionalScaleform = function(controls)
    local scaleform = Scaleforms.LoadMovie('INSTRUCTIONAL_BUTTONS')
    Scaleforms.PopVoid(scaleform, 'CLEAR_ALL')
    Scaleforms.PopInt(scaleform, 'SET_CLEAR_SPACE', 200)
    for i = 1, #controls, 1 do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(i - 1)
        for k = 1, #controls[i].codes, 1 do
            ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].codes[k], true))
        end
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(controls[i].label)
        EndTextCommandScaleformString()
        PopScaleformMovieFunctionVoid()
    end
    Scaleforms.PopVoid(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    return scaleform
end
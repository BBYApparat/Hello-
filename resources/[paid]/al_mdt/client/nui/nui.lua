mdt = {}
mdt.focus = false

-- General --
function mdt:OpenMDT()
    if not mdt.focus then
        StartTabletAnim()
        SendNUIMessage({
            type = 'OpenMDT'
        })

        mdt.focus = true
        SetNuiFocus(true, true)
    end
end

function mdt:OpenFinesMenu()
    if not mdt.focus then
        StartTabletAnim()
        SendNUIMessage({
            type = 'OpenFines',
            identifier = GetIdentifier()
        })

        mdt.focus = true
        SetNuiFocus(true, true)
    end
end

function TriggerPanicButton()
    SendNUIMessage({
        type = 'PanicButton'
    })
end

RegisterNUICallback('closeMDT', function(data, cb)
    if mdt.focus then
        SetNuiFocus(false, false)
        StopTabletAnim()

        mdt.focus = false
        cb({})
    end
end)

RegisterNUICallback('getLanguage', function(data, cb)
    cb(Config.MDT.Language)
end)

RegisterNUICallback('getConfig', function(data, cb)
    local configSettings = Config.MDT
    local keybinds = {}
    for i,v in pairs(Config.Keybinds) do
        table.insert(keybinds, i)
    end
    configSettings.Keybinds = {
        list = keybinds,
        default = Config.DefaultKeybind
    }

    cb(configSettings)
end)

RegisterNUICallback('updateSettings', function(settings, cb)
    if settings.keybind then
        mdt.keybind = settings.keybind
    end
    TriggerServerEvent('al_mdt:UpdateUserSettings', mdt.k, GetIdentifier(), settings)
    cb({})
end)

RegisterNUICallback('logout', function(data, cb)
    TriggerServerEvent('al_mdt:LogOut', mdt.k, GetIdentifier())
    cb({})
end)
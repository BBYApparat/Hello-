RegisterNUICallback('takePhoto', function(data, cb)
    local cameraOpen = true
    local usingFrontCamera = false
    local showHelp = true
    SetNuiFocus(false, false)
    CreatePhone()

    while cameraOpen do
        if IsControlJustPressed(0, 176) then -- Take photo
            showHelp = false
            Citizen.CreateThread(function()
                Citizen.Wait(100)

                Config.TakePhoto(function(url)
                    DestroyPhone()
                    cb(url)
                    cameraOpen = false
                end)
            end)
        elseif IsControlJustPressed(0, 38) then -- Switch between front and rear camera
            usingFrontCamera = not usingFrontCamera
            CellFrontCamActivate(usingFrontCamera)
        elseif IsControlJustPressed(0, 177) then -- Exit
            DestroyPhone()
            cb(false)
            cameraOpen = false
        end

        HideUi()
        if showHelp then CameraHelpNotification() end
        Citizen.Wait(0)
    end

    mdt.focus = true
    SetNuiFocus(true, true)
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

function CreatePhone()
    CreateMobilePhone(1)
    CellCamActivate(true, true)
end

function DestroyPhone()
    DestroyMobilePhone()
    CellCamActivate(false, false)
end

function HideUi()
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
end

Citizen.CreateThread(function()
    AddTextEntry(
        'MDT_CAMERA_HELP',
        'Press ~INPUT_PICKUP~ to switch back/front camera~n~Press ~INPUT_CELLPHONE_SELECT~ to take photo~n~Press ~INPUT_CELLPHONE_CANCEL~ to exit'
    )
end)

function CameraHelpNotification()
    BeginTextCommandDisplayHelp('MDT_CAMERA_HELP')
    EndTextCommandDisplayHelp(0, false, false, -1)
end
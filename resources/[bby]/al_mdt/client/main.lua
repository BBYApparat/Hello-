function Init()
    TriggerServerCallback('al_mdt:Init', function(result)
        if result then
            mdt.k = result

            if Config.Command then
                RegisterCommand(Config.Command, function(source, args, raw)
                    if CanAccess() then
                        mdt:OpenMDT()
                    end
                end, false)
            end

            if Config.DefaultKeybind then
                KeybindThread()
            end
        end
    end)

    MarkersThread()

    if Config.Fines.Command then
        RegisterCommand(Config.Fines.Command, function(source, args, raw)
            mdt:OpenFinesMenu()
        end, false)
    end

    if Config.Fines.AutopayOverdueFines then
        Citizen.CreateThread(function()
            Citizen.Wait(30000) -- A buffer before it checks for overdue fines
            CheckOverdueFines()
        end)
    end

    if Config.KeybindBeforeLogin then
        local identifier = nil

        while not identifier do
            Citizen.Wait(1000)
            identifier = GetIdentifier()
        end

        GetCustomKeybind()
    end
end

function CanAccess()
    local hasAccess = false
    for i=1, #Config.JobAccess do
        local job = Config.JobAccess[i]

        if GetJob().name == job then
            hasAccess = true
            break
        end
    end

    return hasAccess
end

function GetCustomKeybind()
    TriggerServerCallback('al_mdt:FetchUser', function(userData)
        if userData then
            userData.settings = json.decode(userData.settings)
            mdt.keybind = userData.settings.keybind or false
            print('Setting custom mdt keybind: ', mdt.keybind)
        else
            mdt.keybind = false
        end
    end, mdt.k, GetIdentifier())
end

function KeybindThread()
    Citizen.CreateThread(function()
        while true do
            if mdt.keybind and Config.Keybinds[mdt.keybind] then
                if IsControlJustPressed(0, Config.Keybinds[mdt.keybind]) then
                    if CanAccess() then
                        mdt:OpenMDT()
                        Citizen.Wait(750) -- 0.75 sec cooldown to prevent nui getting stuck
                    end
                end
            else
                if IsControlJustPressed(0, Config.Keybinds[Config.DefaultKeybind]) then
                    if CanAccess() then
                        mdt:OpenMDT()
                        Citizen.Wait(750) -- 0.75 sec cooldown to prevent nui getting stuck
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end

function MarkersThread()
    if #Config.Fines.Locations > 0 then
        Citizen.CreateThread(function()
            local sleep = 1000
            while true do Citizen.Wait(sleep)
                for i=1, #Config.Fines.Locations do
                    local location = Config.Fines.Locations[i]
                    local playerDistance = #(GetEntityCoords(PlayerPedId()) - location)

                    if playerDistance <= 10 then
                        if sleep ~= 0 then sleep = 0 end
                        DrawMarker(23, location.x, location.y, location.z - 0.95, 0, 0, 0, 0, 0, 0, Config.Markers.Size.x, Config.Markers.Size.y, Config.Markers.Size.z, Config.Markers.Color.r, Config.Markers.Color.g, Config.Markers.Color.b, 80, false, true, 0, 0)

                        if playerDistance <= 1 then
                            HelpNotification('Press ~INPUT_PICKUP~ to open fines menu')

                            if IsControlJustReleased(0, 38) then
                                mdt:OpenFinesMenu()
                            end
                        end
                    elseif sleep == 0 then
                        sleep = 1000
                    end
                end
            end
        end)
    end
end

local attatchedEntity = false
function StartTabletAnim()
    if attatchedEntity then
        return
    end

    local animDict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a'
    local anim = 'idle_a'
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, anim, 4.0, 4.0, -1, 51)

    local modelHash = GetHashKey('prop_cs_tablet');
    RequestModel(modelHash);
    while not HasModelLoaded(modelHash) do Citizen.Wait(0) end

    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local object = CreateObject(modelHash, playerPos.x, playerPos.y, playerPos.z, true, false, false)
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, true, 1, true)
    attatchedEntity = object
end

function StopTabletAnim()
    DetachEntity(attatchedEntity)
    DeleteEntity(attatchedEntity)
    ClearPedTasks(PlayerPedId())
    attatchedEntity = nil;
end
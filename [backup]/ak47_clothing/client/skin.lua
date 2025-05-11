lastSkin = nil
firstSpawn = true
callback = nil
other = nil
firstRegister = false

function OpenSaveableMenu()
    openMenu(Config.CharacterCreationMenu)
end

AddEventHandler('esx_skin:resetFirstSpawn', function()
    firstSpawn = true
    ESX.PlayerLoaded = false
end)

if Config.ESXVersion == '1.1' then
    AddEventHandler('playerSpawned', function()
        Citizen.CreateThread(function()
            while not ESX.PlayerLoaded do
                Citizen.Wait(100)
            end
            if firstSpawn then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    if skin == nil then
                        firstRegister = true
                        TriggerEvent('skinchanger:resetskin')
                        Citizen.Wait(100)
                        TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
                    else
                        Citizen.Wait(1000)
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                            Citizen.Wait(1000)
                            TriggerEvent('esx:restoreLoadout')
                        end)
                        Citizen.Wait(1000)
                        while exports['skinchanger']:getModelById(skin) ~= GetEntityModel(PlayerPedId()) do
                            Wait(2000)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                        Citizen.Wait(1000)
                        TriggerEvent('esx:restoreLoadout')
                    end
                end)
                firstSpawn = false
            end
        end)
    end)
else
    AddEventHandler('esx_skin:playerRegistered', function()
        Citizen.CreateThread(function()
            while not ESX.PlayerLoaded do
                Citizen.Wait(100)
            end
            if firstSpawn then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    if skin == nil then
                        firstRegister = true
                        TriggerEvent('skinchanger:resetskin')
                        Citizen.Wait(100)
                        TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
                    else
                        Citizen.Wait(1000)
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                            Citizen.Wait(1000)
                            TriggerEvent('esx:restoreLoadout')
                        end)
                        Citizen.Wait(1000)
                        while exports['skinchanger']:getModelById(skin) ~= GetEntityModel(PlayerPedId()) do
                            Wait(2000)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                        Citizen.Wait(1000)
                        TriggerEvent('esx:restoreLoadout')
                    end
                end)
                firstSpawn = false
            end
        end)
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
    cb(lastSkin) 
end)

AddEventHandler('esx_skin:setLastSkin', function(skin) 
    lastSkin = skin 
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
    callback = submitCb
    Citizen.Wait(1000)
    OpenSaveableMenu()
end)

RegisterCommand('reloadskin', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        if skin == nil then
            TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
        else
            TriggerEvent('skinchanger:loadSkin', skin)
        end
    end)
end)

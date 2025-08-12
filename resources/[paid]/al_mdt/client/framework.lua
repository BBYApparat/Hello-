if Config.UsingESX then -- ESX Method
    ESX = nil;

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        Citizen.Wait(1000)
        Init()
    end)
elseif Config.UsingQBCore then -- QBCore Method
    QBCore = exports['qb-core']:GetCoreObject()

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        Init()
    end)
else
    -- Setup your own system that reflects your framework
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        Init()
    end)
end

function GetIdentifier()
    if Config.UsingESX then -- ESX Method
        local xPlayer = ESX.GetPlayerData()

        return xPlayer.identifier or false
    elseif Config.UsingQBCore then -- QBCore Method
        local xPlayer = QBCore.Functions.GetPlayerData()

        return xPlayer.citizenid or false
    else
        -- Setup your own system that reflects your framework
    end
end

function GetJob()
    if Config.UsingESX then -- ESX Method
        local xPlayer = ESX.GetPlayerData()

        return xPlayer.job
    elseif Config.UsingQBCore then -- QBCore Method
        local xPlayer = QBCore.Functions.GetPlayerData()

        return xPlayer.job
    else
        -- Setup your own system that reflects your framework
        -- Although you may need to alter every place this function is used
    end
end

function GetName()
    if Config.UsingESX then -- ESX Method
        local xPlayer = ESX.GetPlayerData()
        local resp = nil
        
        TriggerServerCallback('al_mdt:FetchCharName', function(data)
            resp = data
        end, mdt.k, GetIdentifier())

        while resp == nil do Citizen.Wait(0) end
        return resp
    elseif Config.UsingQBCore then -- QBCore Method
        local xPlayer = QBCore.Functions.GetPlayerData()

        return ('%s %s'):format(xPlayer.charinfo.firstname, xPlayer.charinfo.lastname)
    else
        -- Setup your own system that reflects your framework
    end
end

function ShowNotification(text, type, time)
    if Config.UsingESX then -- ESX Method
        ESX.ShowNotification(text, false, true, 180)
    elseif Config.UsingQBCore then -- QBCore Method
        QBCore.Functions.Notify(text, type, time)
    else
        -- Setup your own system that reflects your framework
    end
end
ESX = exports["es_extended"]:getSharedObject()

local isShowingBadge = false
local badgeProp = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function LoadPropModel(propModel)
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(10)
    end
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function IsPoliceOfficer()
    if not ESX.PlayerData.job then return false end
    
    for i = 1, #Config.PoliceBadge.PoliceJobs do
        if ESX.PlayerData.job.name == Config.PoliceBadge.PoliceJobs[i] then
            return true
        end
    end
    return false
end

local function ShowBadge(badgeData)
    if isShowingBadge then return end
    
    local playerPed = PlayerPedId()
    
    if IsPedInAnyVehicle(playerPed, false) or 
       IsPedSwimming(playerPed) or 
       IsPedClimbing(playerPed) or 
       IsPedRagdoll(playerPed) or
       IsEntityDead(playerPed) then
        ESX.ShowNotification(Config.PoliceBadge.Messages.CannotShowBadge, 'error')
        return
    end
    
    LoadPropModel(Config.PoliceBadge.PropModel)
    LoadAnimDict(Config.PoliceBadge.AnimDict)
    
    isShowingBadge = true
    
    badgeProp = CreateObject(GetHashKey(Config.PoliceBadge.PropModel), 0, 0, 0, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 28422)
    
    AttachEntityToEntity(badgeProp, playerPed, boneIndex, 
        0.065, 0.029, 0.038, 
        80.0, -20.0, 175.0, 
        true, true, false, true, 1, true)
    
    TaskPlayAnim(playerPed, Config.PoliceBadge.AnimDict, Config.PoliceBadge.AnimName, 8.0, -8.0, Config.PoliceBadge.ShowDuration, 49, 0, false, false, false)
    
    TriggerServerEvent('police_badge:server:showBadge', badgeData)
    
    SetTimeout(Config.PoliceBadge.ShowDuration, function()
        HideBadge()
    end)
end

local function HideBadge()
    if not isShowingBadge then return end
    
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    
    if badgeProp then
        DeleteObject(badgeProp)
        badgeProp = nil
    end
    
    isShowingBadge = false
    TriggerServerEvent('police_badge:server:hideBadge')
end

RegisterNetEvent('police_badge:client:showBadgeToNearby')
AddEventHandler('police_badge:client:showBadgeToNearby', function(badgeData, sourcePlayerId)
    local playerPed = PlayerPedId()
    local sourcePlayerPed = GetPlayerPed(GetPlayerFromServerId(sourcePlayerId))
    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(sourcePlayerPed))
    
    if distance <= Config.PoliceBadge.ShowDistance then
        local badgeInfo = string.format(
            Config.PoliceBadge.Messages.BadgeShow,
            badgeData.firstname,
            badgeData.lastname,
            badgeData.rank,
            badgeData.department,
            badgeData.badgeNumber
        )
        ESX.ShowNotification(badgeInfo, 'info', Config.PoliceBadge.NotificationDuration)
    end
end)

exports('showPoliceBadge', function()
    if not IsPoliceOfficer() then
        ESX.ShowNotification(Config.PoliceBadge.Messages.NotPolice, 'error')
        return
    end
    
    ESX.TriggerServerCallback('police_badge:getBadgeData', function(badgeData)
        if badgeData then
            ShowBadge(badgeData)
        else
            ESX.ShowNotification(Config.PoliceBadge.Messages.NoBadge, 'error')
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(0)
        
        if IsControlJustReleased(0, Config.PoliceBadge.ShowKey) then
            if IsPoliceOfficer() then
                exports[GetCurrentResourceName()]:showPoliceBadge()
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if isShowingBadge then
            HideBadge()
        end
    end
end)
ESX = exports["es_extended"]:getSharedObject()

local function GetPoliceRank(job)
    local ranks = {
        [0] = "Recruit",
        [1] = "Officer", 
        [2] = "Senior Officer",
        [3] = "Corporal",
        [4] = "Sergeant",
        [5] = "Lieutenant",
        [6] = "Captain",
        [7] = "Deputy Chief",
        [8] = "Assistant Chief",
        [9] = "Chief of Police"
    }
    
    return ranks[job.grade] or job.grade_label or "Officer"
end

local function GetDepartment(jobName)
    local departments = {
        ['police'] = "Los Santos Police Department",
        ['sheriff'] = "Blaine County Sheriff's Office", 
        ['leo'] = "Law Enforcement Officer",
        ['trooper'] = "San Andreas State Police"
    }
    
    return departments[jobName] or "Law Enforcement"
end

local function GenerateBadgeNumber(identifier)
    local hash = GetHashKey(identifier)
    if hash < 0 then hash = hash * -1 end
    return string.format("%06d", hash % 999999 + 1)
end

ESX.RegisterServerCallback('police_badge:getBadgeData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(nil)
        return
    end
    
    local isPolice = false
    for i = 1, #Config.PoliceBadge.PoliceJobs do
        if xPlayer.job.name == Config.PoliceBadge.PoliceJobs[i] then
            isPolice = true
            break
        end
    end
    
    if not isPolice then
        cb(nil)
        return
    end
    
    local hasItem = false
    if Config.PoliceBadge.RequireItem then
        local items = exports.ox_inventory:GetInventoryItems(source)
        for slot, item in pairs(items) do
            if item.name == 'police_badge' then
                hasItem = true
                break
            end
        end
        
        if not hasItem then
            cb(nil)
            return
        end
    end
    
    local badgeData = {
        firstname = xPlayer.variables.firstName or xPlayer.getName():match("(%S+)"),
        lastname = xPlayer.variables.lastName or xPlayer.getName():match("%S+%s+(%S+)") or "",
        rank = GetPoliceRank(xPlayer.job),
        department = GetDepartment(xPlayer.job.name),
        badgeNumber = GenerateBadgeNumber(xPlayer.identifier),
        playerId = source
    }
    
    cb(badgeData)
end)

RegisterNetEvent('police_badge:server:showBadge')
AddEventHandler('police_badge:server:showBadge', function(badgeData)
    local source = source
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    
    for _, playerId in ipairs(ESX.GetPlayers()) do
        if playerId ~= source then
            local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
            local distance = #(playerCoords - targetCoords)
            
            if distance <= Config.PoliceBadge.ShowDistance then
                TriggerClientEvent('police_badge:client:showBadgeToNearby', playerId, badgeData, source)
            end
        end
    end
    
    print(string.format("^2[Police Badge]^7 %s %s (%s) showed their badge", 
          badgeData.firstname, badgeData.lastname, badgeData.rank))
end)

RegisterNetEvent('police_badge:server:hideBadge')
AddEventHandler('police_badge:server:hideBadge', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        print(string.format("^3[Police Badge]^7 %s put away their badge", xPlayer.getName()))
    end
end)

CreateThread(function()
    if Config.PoliceBadge.RequireItem then
        ESX.RegisterUsableItem('police_badge', function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            
            local isPolice = false
            for i = 1, #Config.PoliceBadge.PoliceJobs do
                if xPlayer.job.name == Config.PoliceBadge.PoliceJobs[i] then
                    isPolice = true
                    break
                end
            end
            
            if isPolice then
                TriggerClientEvent('police_badge:client:useBadge', source)
            else
                xPlayer.showNotification(Config.PoliceBadge.Messages.NotPolice, 'error')
            end
        end)
    end
end)

RegisterNetEvent('police_badge:client:useBadge')
AddEventHandler('police_badge:client:useBadge', function()
    exports[GetCurrentResourceName()]:showPoliceBadge()
end)
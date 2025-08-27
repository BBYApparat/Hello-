local isLoggedIn = false
local PlayerData = {}
local mdtOpen = false

-- ESX Ready
CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
    isLoggedIn = true
end)

-- Update player data when job changes
RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Toggle MDT
RegisterNetEvent('esx_mdt:client:toggle', function()
    print('[ESX_MDT CLIENT] Toggle MDT called')
    print('[ESX_MDT CLIENT] isLoggedIn:', isLoggedIn)
    
    if not isLoggedIn then 
        print('[ESX_MDT CLIENT] Player not logged in, returning')
        return 
    end
    
    print('[ESX_MDT CLIENT] Calling server callback: esx_mdt:getPlayerData')
    ESX.TriggerServerCallback('esx_mdt:getPlayerData', function(playerData)
        print('[ESX_MDT CLIENT] Server callback response:', json.encode(playerData))
        
        if not playerData then
            print('[ESX_MDT CLIENT] No player data received - access denied')
            ESX.ShowNotification('You do not have access to the MDT')
            return
        end
        
        print('[ESX_MDT CLIENT] Player data received successfully')
        print('[ESX_MDT CLIENT] mdtOpen state:', mdtOpen)
        
        if mdtOpen then
            print('[ESX_MDT CLIENT] Closing MDT')
            CloseMDT()
        else
            print('[ESX_MDT CLIENT] Opening MDT with data:', json.encode(playerData))
            OpenMDT(playerData)
        end
    end)
end)

-- Open MDT
function OpenMDT(playerData)
    print('[ESX_MDT CLIENT] OpenMDT function called')
    print('[ESX_MDT CLIENT] mdtOpen state:', mdtOpen)
    
    if mdtOpen then 
        print('[ESX_MDT CLIENT] MDT already open, returning')
        return 
    end
    
    print('[ESX_MDT CLIENT] Setting MDT open state and NUI focus')
    mdtOpen = true
    SetNuiFocus(true, true)
    
    local messageData = {
        type = 'APP_SHOW',
        data = {
            playerData = playerData,
            config = {
                departments = Config.PoliceDepartments,
                permissions = playerData.permissions
            }
        }
    }
    
    print('[ESX_MDT CLIENT] Sending NUI message:', json.encode(messageData))
    SendNUIMessage(messageData)
    
    -- Disable controls while MDT is open
    CreateThread(function()
        while mdtOpen do
            Wait(0)
            DisableControlAction(0, 1, true) -- Mouse look
            DisableControlAction(0, 2, true) -- Mouse look
            DisableControlAction(0, 3, true) -- Mouse look
            DisableControlAction(0, 4, true) -- Mouse look
            DisableControlAction(0, 5, true) -- Mouse look
            DisableControlAction(0, 6, true) -- Mouse look
            DisableControlAction(0, 263, true) -- Input look
            DisableControlAction(0, 264, true) -- Input look
            DisableControlAction(0, 265, true) -- Input look
            DisableControlAction(0, 266, true) -- Input look
        end
    end)
end

-- Close MDT
function CloseMDT()
    print('[ESX_MDT CLIENT] CloseMDT function called')
    
    if not mdtOpen then 
        print('[ESX_MDT CLIENT] MDT not open, returning')
        return 
    end
    
    print('[ESX_MDT CLIENT] Closing MDT - setting focus and sending message')
    mdtOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'APP_HIDE'
    })
end

-- Clear emergency blips
RegisterNetEvent('esx_mdt:client:clearBlips', function()
    -- Clear all emergency blips
    local blips = {}
    for i = 0, 500 do
        local blip = GetFirstBlipInfoId(i)
        if DoesBlipExist(blip) then
            local blipType = GetBlipInfoIdType(blip)
            if blipType == 1 or blipType == 2 or blipType == 5 then -- Emergency blip types
                table.insert(blips, blip)
            end
        end
    end
    
    for _, blip in ipairs(blips) do
        RemoveBlip(blip)
    end
end)

-- NUI Callbacks
RegisterNUICallback('closeMDT', function(data, cb)
    CloseMDT()
    cb('ok')
end)

RegisterNUICallback('searchPeople', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:searchPeople', function(results)
        cb(results)
    end, data.search)
end)

RegisterNUICallback('getPersonDetails', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:getPersonDetails', function(result)
        cb(result)
    end, data.identifier)
end)

RegisterNUICallback('searchVehicles', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:searchVehicles', function(results)
        cb(results)
    end, data.search)
end)

RegisterNUICallback('searchReports', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:searchReports', function(results)
        cb(results)
    end, data)
end)

RegisterNUICallback('createReport', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:createReport', function(success)
        if success then
            ESX.ShowNotification('Report created successfully')
            cb({success = true, reportId = success})
        else
            ESX.ShowNotification('Failed to create report')
            cb({success = false})
        end
    end, data)
end)

RegisterNUICallback('getReport', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:getReport', function(report)
        cb(report)
    end, data.reportId)
end)

RegisterNUICallback('updateReport', function(data, cb)
    ESX.TriggerServerCallback('esx_mdt:updateReport', function(success)
        if success then
            ESX.ShowNotification('Report updated successfully')
        else
            ESX.ShowNotification('Failed to update report')
        end
        cb({success = success})
    end, data.reportId, data.reportData)
end)

-- Key mapping
RegisterKeyMapping('mdt', 'Open Mobile Data Terminal', 'keyboard', 'F5')

-- Command handlers
RegisterCommand('mdt', function()
    TriggerEvent('esx_mdt:client:toggle')
end)

RegisterCommand('tablet', function()
    TriggerEvent('esx_mdt:client:toggle')
end)

-- Utility functions
function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetCoords = GetEntityCoords(target, 0)
            local distance = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

-- Export functions
exports('IsOpen', function()
    return mdtOpen
end)

exports('CloseMDT', CloseMDT)
exports('OpenMDT', OpenMDT)
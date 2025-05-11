--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

ESX = nil
local uiOpened = false
local uiOpenType = nil

local pedHeadshotsCache = {}

local playerJobData = nil

CreateThread(function()

        ESX = exports["es_extended"]:getSharedObject()
  
    

    while (not ESX.IsPlayerLoaded()) do 
        Wait(250)
    end

    while (not ESX.GetPlayerData().job) do 
        Wait(250)
    end

    playerJobData = ESX.GetPlayerData().job
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    playerJobData = job
end)

function onNuiFocus()
    CreateThread(function()
        while (uiOpened) do
            DisableAllControlActions(0)

            if (Config.KeysToEnableWhileUIOpen and #Config.KeysToEnableWhileUIOpen > 0) then
                for i = 1, #Config.KeysToEnableWhileUIOpen, 1 do
                    EnableControlAction(0, Config.KeysToEnableWhileUIOpen[i], true)
                end
            end

            if (Config.KeysToCloseUI and #Config.KeysToCloseUI > 0) then
                for i = 1, #Config.KeysToCloseUI, 1 do
                    if (IsControlJustReleased(0, Config.KeysToCloseUI[i]) or IsDisabledControlJustReleased(0, Config.KeysToCloseUI[i])) then
                        TriggerServerEvent('lls-newbill:cancelOrder_server')

                        sendNUIClose()
                        break
                    end
                end
            end

            Wait(0)
        end
    end)

    CreateThread(function()
        local playerPed

        local sellerPlayerPed

        while (uiOpened) do
            playerPed = PlayerPedId()

            if (IsPedDeadOrDying(playerPed) or IsPedRagdoll(playerPed)) then
                TriggerServerEvent('lls-newbill:cancelOrder_server')

                sendNUIClose()
                break
            end

            if (uiOpenType == 'customer') then
                sellerPlayerPed = GetPlayerPed(GetPlayerFromServerId(otherPlayerId))
                if (otherPlayerId == nil or (not DoesEntityExist(sellerPlayerPed)) or (IsPedDeadOrDying(sellerPlayerPed) or IsPedRagdoll(sellerPlayerPed)) or (#(GetEntityCoords(playerPed) - GetEntityCoords(sellerPlayerPed)) > (Config.PlayerMaxDistance + 1.0))) then
                    TriggerServerEvent('lls-newbill:cancelOrder_server')

                    sendNUIClose()
                    break
                end
            end
            
            Wait(250)    
        end
    end)
end

-- FUNCTIONS
function sendNUIClose()
    uiOpened = false
    SetNuiFocus(uiOpened, uiOpened)
    SetNuiFocusKeepInput(uiOpened)

    uiOpenType = nil
    otherPlayerId = nil
    
    SendNUIMessage({
        action = 'close'
    })

    TriggerEvent('lls-newbill:cl:onUiClose')
end

-- CATALOGUE
function requestToOpenCatalogueMenu()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)

    local shopData = nil
    for i = 1, #Config.Jobs, 1 do
        local job = Config.Jobs[i]

        if (GetDistanceBetweenCoords(playerPos, job.position.x, job.position.y, job.position.z, true) <= Config.ShopMaxDistance) then
            shopData = {name = job.name, label = job.label}
            break
        end
    end

    if (shopData == nil) then return end

    TriggerServerEvent('lls-newbill:requestToOpenCatalogueMenu_server', shopData)
end

RegisterNetEvent('lls-newbill:openCatalogueMenu_client')
AddEventHandler('lls-newbill:openCatalogueMenu_client', function(shopData, itemsData)
    if (shopData == nil or itemsData == nil) then
        return
    end
    
    local job = Config.JOBS_INITED[shopData.name]

    if (job == nil) then return end

    sendNUICatalogueOpen(shopData, itemsData)
end)

function sendNUICatalogueOpen(shopData, itemsData)
    if (shopData == nil and itemsData ~= nil) then
        return
    end

    uiOpened = true
    SetNuiFocus(uiOpened, uiOpened)
    SetNuiFocusKeepInput(uiOpened)
    
    uiOpenType = 'catalogue'

    onNuiFocus()

    SendNUIMessage({
        action = 'open',
        type = 'catalogue',
        shopData = shopData,
        itemsData = itemsData
	})
end

-- SELLER
function requestToOpenSellerMenu()
    TriggerServerEvent('lls-newbill:requestToOpenSellerMenu_server')
end

RegisterNetEvent('lls-newbill:openSellerMenu_client')
AddEventHandler('lls-newbill:openSellerMenu_client', function(shopData, itemsData)    
    if (shopData == nil or itemsData == nil) then
        return
    end

    local job = Config.JOBS_INITED[shopData.name]
    
    if (playerJobData.name ~= shopData.name or job == nil) then
        return
    end
        
    sendNUISellerOpen(shopData, itemsData)
end)

function sendNUISellerOpen(shopData, itemsData)
    if (shopData == nil and itemsData ~= nil and nearbyPlayers ~= nil) then
        return
    end

    uiOpened = true
    SetNuiFocus(uiOpened, uiOpened)
    SetNuiFocusKeepInput(uiOpened)

    uiOpenType = 'seller'
    
    onNuiFocus()

    SendNUIMessage({
        action = 'open',
        type = 'seller',
        shopData = shopData,
        itemsData = itemsData
	})
end

-- CUSTOMER
function requestToOpenCustomerMenu()
    TriggerServerEvent('lls-newbill:requestToOpenCustomerMenu_server')
end

RegisterNetEvent('lls-newbill:openCustomerMenu_client')
AddEventHandler('lls-newbill:openCustomerMenu_client', function(sellerServerId, shopData, itemsData)
    if (shopData == nil or itemsData == nil) then
        return
    end
    
    local job = Config.JOBS_INITED[shopData.name]

    if (job == nil) then
        return
    end

    sendNUICustomerOpen(sellerServerId, shopData, itemsData)
end)

function sendNUICustomerOpen(sellerServerId, shopData, itemsData)
    uiOpened = true
    SetNuiFocus(uiOpened, uiOpened)
    SetNuiFocusKeepInput(uiOpened)

    uiOpenType = 'customer'
    otherPlayerId = sellerServerId
    
    onNuiFocus()

    SendNUIMessage({
        action = 'open',
        type = 'customer',
        shopData = shopData,
        itemsData = itemsData
	})
end

-- BOSS
function requestToOpenBossMenu()
    TriggerServerEvent('lls-newbill:requestToOpenBossMenu_server')
end

RegisterNetEvent('lls-newbill:openBossMenu_client')
AddEventHandler('lls-newbill:openBossMenu_client', function(shopData, itemsData, bossBankMoney)
    if (shopData == nil or itemsData == nil) then
        return
    end
    if (playerJobData.name ~= shopData.name or Config.JOBS_INITED[shopData.name] == nil or (playerJobData.grade_name ~= Config.JOBS_INITED[shopData.name].bossGradeName)) then
        return
    end

    local possibleItemsData = nil
    for i = 1, #Config.AvailableItems, 1 do
        local item = Config.AvailableItems[i]

        if (possibleItemsData == nil) then possibleItemsData = {} end

        table.insert(possibleItemsData, {name = item.name, label = getLabelOfItem(item.name)})
    end
        
    if (possibleItemsData == nil) then return end
    
    sendNUIBossOpen(shopData, itemsData, possibleItemsData, bossBankMoney)
end)

function sendNUIBossOpen(shopData, itemsData, possibleItemsData, bossBankMoney)
    if (shopData == nil or itemsData == nil or possibleItemsData == nil or bossBankMoney == nil) then
        return
    end
    
    uiOpened = true
    SetNuiFocus(uiOpened, uiOpened)
    SetNuiFocusKeepInput(uiOpened)
    
    uiOpenType = 'boss'

    onNuiFocus()

    SendNUIMessage({
        action = 'open',
        type = 'boss',
        shopData = shopData,
        itemsData = itemsData,
        possibleItemsData = possibleItemsData,
        bossBankMoney = bossBankMoney
	})
end

RegisterNUICallback('getResult', function(data)
    if (data.type == 'cancel') then
        sendNUIClose()
        TriggerServerEvent('lls-newbill:cancelOrder_server')
        ClearPedHeadshots()
    elseif (data.type == 'bill') then
        sendNUIClose()
        TriggerServerEvent('lls-newbill:requestToBill_server', data.playerId, data.itemsData)
        ClearPedHeadshots()
    elseif (data.type == 'pay') then
        sendNUIClose()
        TriggerServerEvent('lls-newbill:payOrder_server', data.tips)
    elseif (data.type == 'save') then
        sendNUIClose()
        TriggerServerEvent('lls-newbill:saveBossData_server', data.itemsData)
    elseif (data.type == 'withdraw') then
        sendNUIClose()
        TriggerServerEvent('lls-newbill:withdrawBoss_server')
    end
end)

RegisterNUICallback('requestNearbyPlayers', function(data, cb)
    cb(GetNearbyPlayersHeadshot())
end)

RegisterNUICallback('inputBlur', function()
	if (uiOpened) then
        SetNuiFocusKeepInput(true)
	end
end)

RegisterNUICallback('inputFocus', function()
    Wait(250)
    SetNuiFocusKeepInput(false)
end)

-- HELPERS
function GetNearbyPlayersHeadshot()
    ClearPedHeadshots()

    local playerPos = GetEntityCoords(PlayerPedId())
    local player = PlayerId()

    local nearbyPlayers = {}
	for _, tempPlayer in ipairs(GetActivePlayers()) do
        if (tempPlayer ~= player) then
            local tempPed = GetPlayerPed(tempPlayer)
            
            if (DoesEntityExist(tempPed) and IsEntityVisible(tempPed)) then
                local tempPos = GetEntityCoords(tempPed)
                local tempDist = #(playerPos - tempPos)

                if (tempDist <= Config.PlayerMaxDistance) then
                    local tempHandle = RegisterPedheadshot(tempPed)
    
                    local timer = 2000
                    while ((not tempHandle or not IsPedheadshotReady(tempHandle) or not IsPedheadshotValid(tempHandle)) and timer > 0) do
                        Wait(10)
                        timer = timer - 10
                    end

                    local headshotTxd = 'none'
                    if (IsPedheadshotReady(tempHandle) and IsPedheadshotValid(tempHandle)) then
                        table.insert(pedHeadshotsCache, tempHandle)
                        headshotTxd = GetPedheadshotTxdString(tempHandle)
                    end

                    table.insert(nearbyPlayers, {
                        pId = GetPlayerServerId(tempPlayer),
                        pHeadshotTxd = headshotTxd,
                        distance = tempDist
                    })
                end
            end
        end
	end

    if (#nearbyPlayers > 0) then
        table.sort(nearbyPlayers, function(a, b)
            return b.distance > a.distance
        end)
    end

	return nearbyPlayers
end

function ClearPedHeadshots()
    for i = 0, #pedHeadshotsCache, 1 do
        UnregisterPedheadshot(pedHeadshotsCache[i])
    end

    pedHeadshotsCache = {}
end

RegisterNetEvent('lls-newbill:cl:showNotification')
AddEventHandler('lls-newbill:cl:showNotification', function(msg)
    showNotification(msg)
end)

-- 
AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentServerEndpoint() == nil) then
        return
    end

    if (resource == GetCurrentResourceName()) then
        if (uiOpened) then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        ClearPedHeadshots()
    end
end)

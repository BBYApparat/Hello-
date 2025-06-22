-- NPC Wallet Drop Script
-- Client-side script (client.lua)

local spawnedWallets = {}
local walletTimeout = 300000 -- 5 minutes in milliseconds

-- Function to spawn wallet prop
function SpawnWallet(coords)
    local walletHash = GetHashKey('prop_ld_wallet_pickup')
    
    RequestModel(walletHash)
    while not HasModelLoaded(walletHash) do
        Wait(1)
    end
    
    local wallet = CreateObject(walletHash, coords.x, coords.y, coords.z - 0.5, true, true, false)
    SetEntityAsMissionEntity(wallet, true, true)
    PlaceObjectOnGroundProperly(wallet)
    FreezeEntityPosition(wallet, true)
    
    -- Generate random money amount
    local moneyAmount = math.random(1, 90)
    
    -- Add to ox_target
    exports.ox_target:addLocalEntity(wallet, {
        {
            name = 'pickup_wallet',
            icon = 'fas fa-wallet',
            label = 'Pick up wallet',
            onSelect = function()
                PickupWallet(wallet, moneyAmount)
            end,
            distance = 2.0
        }
    })
    
    -- Store wallet data
    spawnedWallets[wallet] = {
        entity = wallet,
        money = moneyAmount,
        spawnTime = GetGameTimer()
    }
    
    -- Set timeout for wallet deletion
    SetTimeout(walletTimeout, function()
        if DoesEntityExist(wallet) then
            DeleteWallet(wallet)
        end
    end)
    
    SetModelAsNoLongerNeeded(walletHash)
    return wallet
end

-- Function to pickup wallet
function PickupWallet(wallet, money)
    if not DoesEntityExist(wallet) then
        return
    end
    
    -- Add money to player (using your framework's function)
    -- ESX example:
    -- ESX.TriggerServerCallback('npc_wallet:addMoney', function() end, money)
    
    -- QBCore example:
    -- TriggerServerEvent('npc_wallet:addMoney', money)
    
    -- Generic example using ox_inventory:
    TriggerServerEvent('npc_wallet:addMoney', money)
    
    -- Show notification
    lib.notify({
        title = 'Wallet Found',
        description = 'You found $' .. money .. ' in the wallet',
        type = 'success',
        duration = 3000
    })
    
    DeleteWallet(wallet)
end

-- Function to delete wallet
function DeleteWallet(wallet)
    if DoesEntityExist(wallet) then
        exports.ox_target:removeLocalEntity(wallet, 'pickup_wallet')
        DeleteEntity(wallet)
        spawnedWallets[wallet] = nil
    end
end

-- Main event handler for NPC death
CreateThread(function()
    while true do
        Wait(500) -- Check every 500ms
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Get all peds in area
        local peds = GetGamePool('CPed')
        
        for _, ped in ipairs(peds) do
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) and IsPedDeadOrDying(ped, 1) then
                -- Check if this ped already dropped a wallet
                local pedCoords = GetEntityCoords(ped)
                local alreadyDropped = false
                
                for wallet, data in pairs(spawnedWallets) do
                    local walletCoords = GetEntityCoords(data.entity)
                    if #(pedCoords - walletCoords) < 2.0 then
                        alreadyDropped = true
                        break
                    end
                end
                
                if not alreadyDropped then
                    -- Random chance to drop wallet (70% chance)
                    if math.random(1, 100) <= 70 then
                        SpawnWallet(pedCoords)
                    end
                end
            end
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for wallet, data in pairs(spawnedWallets) do
            DeleteWallet(wallet)
        end
    end
end)


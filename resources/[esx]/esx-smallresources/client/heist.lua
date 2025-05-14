-- client.lua

-- Local variables
local isActiveHeistPlayer = false
local npc = nil
local targetCreated = false
local drillTarget = nil
local lockpickTarget = nil
local drillCompleted = false
local lockpickCompleted = false

-- Get framework
local ESX = nil
local QBCore = nil
local framework = nil

-- Framework detection
Citizen.CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        framework = 'ESX'
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        framework = 'QBCore'
    end
end)

-- Check if player is the active heist player
RegisterNetEvent('simple_heist:setActivePlayer')
AddEventHandler('simple_heist:setActivePlayer', function(isActive)
    isActiveHeistPlayer = isActive
end)

-- NPC creation
Citizen.CreateThread(function()
    local pedHash = GetHashKey(Config.StartNPC.model)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Citizen.Wait(1)
    end
    
    npc = CreatePed(4, pedHash, Config.StartNPC.coords.x, Config.StartNPC.coords.y, Config.StartNPC.coords.z, Config.StartNPC.heading, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    
    if Config.StartNPC.scenario then
        TaskStartScenarioInPlace(npc, Config.StartNPC.scenario, 0, true)
    end
    
    -- Create ox_target for NPC
    if DoesEntityExist(npc) then
        exports.ox_target:addLocalEntity(npc, {
            {
                name = 'start_heist',
                icon = 'fas fa-gem',
                label = 'Talk to Start Heist',
                onSelect = function()
                    -- Check with server if player can start heist
                    if framework == 'ESX' then
                        ESX.TriggerServerCallback('simple_heist:canStartHeist', function(canStart, message)
                            if canStart then
                                StartHeist()
                            else
                                ESX.ShowNotification(message)
                            end
                        end)
                    elseif framework == 'QBCore' then
                        QBCore.Functions.TriggerCallback('simple_heist:canStartHeist', function(canStart, message)
                            if canStart then
                                StartHeist()
                            else
                                QBCore.Functions.Notify(message, 'error')
                            end
                        end)
                    end
                end
            }
        })
    end
end)

-- Start the heist
function StartHeist()
    -- Request to check if this player is the active heist player
    TriggerServerEvent('simple_heist:checkActivePlayer')
    
    -- Create target zones at heist location
    Citizen.SetTimeout(500, function() -- Give time for server to respond
        if isActiveHeistPlayer then
            CreateHeistTargets()
            
            -- Notify player
            if framework == 'ESX' then
                ESX.ShowNotification("Heist started! Head to the location and use your tools.")
            elseif framework == 'QBCore' then
                QBCore.Functions.Notify("Heist started! Head to the location and use your tools.", "success")
            end
            
            -- Set waypoint to heist location
            SetNewWaypoint(Config.HeistLocation.x, Config.HeistLocation.y)
        end
    end)
end

-- Create target zones at heist location
function CreateHeistTargets()
    if not targetCreated and isActiveHeistPlayer then
        -- Create drill target
        drillTarget = exports.ox_target:addSphereZone({
            coords = vector3(Config.HeistLocation.x, Config.HeistLocation.y, Config.HeistLocation.z),
            radius = 0.5,
            debug = false,
            options = {
                {
                    name = 'use_drill',
                    icon = 'fas fa-tools',
                    label = 'Use Drill',
                    canInteract = function()
                        -- Check if player has drill and is the active heist player
                        if framework == 'ESX' then
                            local hasItem = ESX.SearchInventory('drill', 1)
                            return hasItem and isActiveHeistPlayer
                        elseif framework == 'QBCore' then
                            local hasItem = QBCore.Functions.HasItem('drill')
                            return hasItem and isActiveHeistPlayer
                        end
                        return false
                    end,
                    onSelect = function()
                        -- Start drilling minigame
                        exports['ps-ui']:Circle(function(success)
                            if success then
                                TriggerServerEvent('simple_heist:drillAttempt', true)
                            else
                                TriggerServerEvent('simple_heist:drillAttempt', false)
                            end
                        end, 5, 20) -- difficulty, number of circles
                    end
                }
            }
        })
        
        -- Create lockpick target
        lockpickTarget = exports.ox_target:addSphereZone({
            coords = vector3(Config.HeistLocation.x + 0.5, Config.HeistLocation.y, Config.HeistLocation.z),
            radius = 0.5,
            debug = false,
            options = {
                {
                    name = 'use_lockpick',
                    icon = 'fas fa-unlock',
                    label = 'Use Lockpick',
                    canInteract = function()
                        -- Check if player has lockpick, drill is completed, and is the active heist player
                        if not drillCompleted then return false end
                        
                        if framework == 'ESX' then
                            local hasItem = ESX.SearchInventory('lockpick', 1)
                            return hasItem and isActiveHeistPlayer
                        elseif framework == 'QBCore' then
                            local hasItem = QBCore.Functions.HasItem('lockpick')
                            return hasItem and isActiveHeistPlayer
                        end
                        return false
                    end,
                    onSelect = function()
                        -- Start lockpicking minigame
                        exports['ps-ui']:Scrambler(function(success)
                            if success then
                                TriggerServerEvent('simple_heist:lockpickAttempt', true)
                            else
                                TriggerServerEvent('simple_heist:lockpickAttempt', false)
                            end
                        end, "numeric", 30, 0) -- type, time, rounds
                    end
                }
            }
        })
        
        targetCreated = true
    end
end

-- Update drill status
RegisterNetEvent('simple_heist:updateDrillStatus')
AddEventHandler('simple_heist:updateDrillStatus', function(success, attempts)
    if success then
        drillCompleted = true
        if framework == 'ESX' then
            ESX.ShowNotification("Drilling completed! Now use the lockpick.")
        elseif framework == 'QBCore' then
            QBCore.Functions.Notify("Drilling completed! Now use the lockpick.", "success")
        end
    else
        local attemptsLeft = 3 - attempts
        if framework == 'ESX' then
            ESX.ShowNotification("Drilling failed! " .. attemptsLeft .. " attempts left.")
        elseif framework == 'QBCore' then
            QBCore.Functions.Notify("Drilling failed! " .. attemptsLeft .. " attempts left.", "error")
        end
    end
end)

-- Drill failed completely
RegisterNetEvent('simple_heist:drillFailed')
AddEventHandler('simple_heist:drillFailed', function()
    if framework == 'ESX' then
        ESX.ShowNotification("You've failed drilling too many times. Heist aborted.")
    elseif framework == 'QBCore' then
        QBCore.Functions.Notify("You've failed drilling too many times. Heist aborted.", "error")
    end
end)

-- Update lockpick status
RegisterNetEvent('simple_heist:updateLockpickStatus')
AddEventHandler('simple_heist:updateLockpickStatus', function(success, attempts)
    if success then
        lockpickCompleted = true
    else
        local attemptsLeft = 3 - attempts
        if framework == 'ESX' then
            ESX.ShowNotification("Lockpicking failed! " .. attemptsLeft .. " attempts left.")
        elseif framework == 'QBCore' then
            QBCore.Functions.Notify("Lockpicking failed! " .. attemptsLeft .. " attempts left.", "error")
        end
    end
end)

-- Lockpick failed completely
RegisterNetEvent('simple_heist:lockpickFailed')
AddEventHandler('simple_heist:lockpickFailed', function()
    if framework == 'ESX' then
        ESX.ShowNotification("You've failed lockpicking too many times. Heist aborted.")
    elseif framework == 'QBCore' then
        QBCore.Functions.Notify("You've failed lockpicking too many times. Heist aborted.", "error")
    end
end)

-- Heist completed
RegisterNetEvent('simple_heist:heistCompleted')
AddEventHandler('simple_heist:heistCompleted', function(reward, item)
    if framework == 'ESX' then
        ESX.ShowNotification("Heist completed! You got $" .. reward .. " and a " .. item)
    elseif framework == 'QBCore' then
        QBCore.Functions.Notify("Heist completed! You got $" .. reward .. " and a " .. item, "success")
    end
end)

-- Heist started notification for all players
RegisterNetEvent('simple_heist:heistStarted')
AddEventHandler('simple_heist:heistStarted', function(playerServerId)
    local playerId = GetPlayerFromServerId(playerServerId)
    local playerName = GetPlayerName(playerId)
    
    if framework == 'ESX' then
        ESX.ShowNotification(playerName .. " has started a heist!")
    elseif framework == 'QBCore' then
        QBCore.Functions.Notify(playerName .. " has started a heist!", "primary")
    end
end)

-- Heist ended, clean up
RegisterNetEvent('simple_heist:heistEnded')
AddEventHandler('simple_heist:heistEnded', function()
    if targetCreated then
        -- Remove target zones
        if drillTarget then
            exports.ox_target:removeZone(drillTarget)
            drillTarget = nil
        end
        
        if lockpickTarget then
            exports.ox_target:removeZone(lockpickTarget)
            lockpickTarget = nil
        end
        
        targetCreated = false
        isActiveHeistPlayer = false
        drillCompleted = false
        lockpickCompleted = false
    end
end)

-- Notification helper
RegisterNetEvent('simple_heist:notify')
AddEventHandler('simple_heist:notify', function(message)
    if framework == 'ESX' then
        ESX.ShowNotification(message)
    elseif framework == 'QBCore' then
        QBCore.Functions.Notify(message, "error")
    end
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Delete NPC
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
        
        -- Remove target zones
        if drillTarget then
            exports.ox_target:removeZone(drillTarget)
        end
        
        if lockpickTarget then
            exports.ox_target:removeZone(lockpickTarget)
        end
    end
end)
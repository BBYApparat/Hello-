ESX = exports['es_extended']:getSharedObject()

-- Config variables directly in client script
Config = {}

Config.StartNPC = {
    model = "g_m_y_mexgoon_01", -- NPC model
    coords = vector3(1275.64, -1710.52, 53.77), -- Location
    heading = 320.0,
    scenario = "WORLD_HUMAN_SMOKING"
}

-- Required items to start heist
Config.RequiredItems = {
    "phone",
    "radio",
    "binoculars",
    "keycard",
    "bulletproof_vest"
}

-- Heist location
Config.HeistLocation = vector3(1290.84, -1710.52, 54.47)

-- Tools needed at heist location
Config.RequiredTools = {
    "drill",
    "lockpick"
}

-- Cooldown in minutes
Config.Cooldown = 60

-- Rewards
Config.Rewards = {
    money = {min = 5000, max = 10000},
    items = {"gold_bar", "jewelry", "cash_stack"}
}

-- Local variables
local isActiveHeistPlayer = false
local npc = nil
local npcBlip = nil
local targetCreated = false
local drillTarget = nil
local lockpickTarget = nil
local drillCompleted = false
local lockpickCompleted = false

-- Clean up existing entities and targets - called on script start
function CleanupResources()
    print("[HEIST] Cleaning up resources")
    
    -- Clean up any existing NPCs from previous script instances
    local oldNpcs = GetGamePool('CPed')
    for _, entity in ipairs(oldNpcs) do
        if DoesEntityExist(entity) and not IsPedAPlayer(entity) then
            local entityCoords = GetEntityCoords(entity)
            local distance = #(entityCoords - Config.StartNPC.coords)
            
            if distance < 2.0 then
                DeleteEntity(entity)
                print("[HEIST] Deleted old NPC at heist location")
            end
        end
    end
    
    -- Remove our own blip if it exists
    if npcBlip and DoesBlipExist(npcBlip) then
        RemoveBlip(npcBlip)
        npcBlip = nil
        print("[HEIST] Removed existing blip")
    end
    
    -- Try to remove any existing target zones - these might fail if targets don't exist
    pcall(function()
        if exports and exports.ox_target then
            -- Try to remove specific zone IDs if we have them stored
            if drillTarget then
                exports.ox_target:removeZone(drillTarget)
                print("[HEIST] Removed old drill target zone")
            end
            
            if lockpickTarget then
                exports.ox_target:removeZone(lockpickTarget)
                print("[HEIST] Removed old lockpick target zone")
            end
            
            -- Also try removing targets from entity types
            exports.ox_target:removeModel(GetHashKey(Config.StartNPC.model))
            print("[HEIST] Removed any targets from NPC model")
        end
    end)
    
    -- Reset local variables
    npc = nil
    targetCreated = false
    drillTarget = nil
    lockpickTarget = nil
    drillCompleted = false
    lockpickCompleted = false
    isActiveHeistPlayer = false
    
    print("[HEIST] Cleanup completed")
end

-- Perform cleanup on resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("[HEIST] Resource started - performing cleanup")
        CleanupResources()
    end
end)

-- Check if player is the active heist player
RegisterNetEvent('simple_heist:setActivePlayer')
AddEventHandler('simple_heist:setActivePlayer', function(isActive)
    isActiveHeistPlayer = isActive
end)

-- NPC creation
Citizen.CreateThread(function()
    -- Wait a moment for everything to load and cleanup to complete
    Citizen.Wait(2000)
    
    -- Perform cleanup before creating new resources
    CleanupResources()
    
    local pedHash = GetHashKey(Config.StartNPC.model)
    RequestModel(pedHash)
    
    -- Wait for model to load with a timeout
    local timeout = 0
    while not HasModelLoaded(pedHash) and timeout < 30 do
        Citizen.Wait(100)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(pedHash) then
        print("[HEIST ERROR] Failed to load ped model!")
        return
    end
    
    npc = CreatePed(4, pedHash, Config.StartNPC.coords.x, Config.StartNPC.coords.y, Config.StartNPC.coords.z, Config.StartNPC.heading, false, true)
    
    if not DoesEntityExist(npc) then
        print("[HEIST ERROR] Failed to create NPC!")
        return
    end
    
    print("[HEIST] NPC created successfully with handle: " .. npc)
    
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    
    if Config.StartNPC.scenario then
        TaskStartScenarioInPlace(npc, Config.StartNPC.scenario, 0, true)
    end
    
    -- Create blip for NPC
    npcBlip = AddBlipForCoord(Config.StartNPC.coords.x, Config.StartNPC.coords.y, Config.StartNPC.coords.z)
    SetBlipSprite(npcBlip, 280)
    SetBlipDisplay(npcBlip, 4)
    SetBlipScale(npcBlip, 0.8)
    SetBlipColour(npcBlip, 2)
    SetBlipAsShortRange(npcBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Heist NPC")
    EndTextCommandSetBlipName(npcBlip)
    
    -- Create ox_target for NPC
    if DoesEntityExist(npc) then
        pcall(function()
            exports.ox_target:addLocalEntity(npc, {
                {
                    name = 'start_heist',
                    icon = 'fas fa-gem',
                    label = 'Talk to Start Heist',
                    onSelect = function()
                        -- Check with server if player can start heist
                        ESX.TriggerServerCallback('simple_heist:canStartHeist', function(canStart, message)
                            if canStart then
                                StartHeist()
                            else
                                ESX.ShowNotification(message)
                            end
                        end)
                    end
                }
            })
        end)
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
            ESX.ShowNotification("Heist started! Head to the location and use your tools.")
            
            -- Set waypoint to heist location
            SetNewWaypoint(Config.HeistLocation.x, Config.HeistLocation.y)
        end
    end)
end

-- Create target zones at heist location
function CreateHeistTargets()
    if not targetCreated and isActiveHeistPlayer then
        -- Clean up any existing targets first
        if drillTarget then
            pcall(function() exports.ox_target:removeZone(drillTarget) end)
            drillTarget = nil
        end
        
        if lockpickTarget then
            pcall(function() exports.ox_target:removeZone(lockpickTarget) end)
            lockpickTarget = nil
        end
        
        -- Create drill target
        pcall(function()
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
                            local hasItem = ESX.SearchInventory('drill', 1)
                            return hasItem and isActiveHeistPlayer
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
        end)
        
        -- Create lockpick target
        pcall(function()
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
                            
                            local hasItem = ESX.SearchInventory('lockpick', 1)
                            return hasItem and isActiveHeistPlayer
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
        end)
        
        targetCreated = true
    end
end

-- Update drill status
RegisterNetEvent('simple_heist:updateDrillStatus')
AddEventHandler('simple_heist:updateDrillStatus', function(success, attempts)
    if success then
        drillCompleted = true
        ESX.ShowNotification("Drilling completed! Now use the lockpick.")
    else
        local attemptsLeft = 3 - attempts
        ESX.ShowNotification("Drilling failed! " .. attemptsLeft .. " attempts left.")
    end
end)

-- Drill failed completely
RegisterNetEvent('simple_heist:drillFailed')
AddEventHandler('simple_heist:drillFailed', function()
    ESX.ShowNotification("You've failed drilling too many times. Heist aborted.")
end)

-- Update lockpick status
RegisterNetEvent('simple_heist:updateLockpickStatus')
AddEventHandler('simple_heist:updateLockpickStatus', function(success, attempts)
    if success then
        lockpickCompleted = true
    else
        local attemptsLeft = 3 - attempts
        ESX.ShowNotification("Lockpicking failed! " .. attemptsLeft .. " attempts left.")
    end
end)

-- Lockpick failed completely
RegisterNetEvent('simple_heist:lockpickFailed')
AddEventHandler('simple_heist:lockpickFailed', function()
    ESX.ShowNotification("You've failed lockpicking too many times. Heist aborted.")
end)

-- Heist completed
RegisterNetEvent('simple_heist:heistCompleted')
AddEventHandler('simple_heist:heistCompleted', function(reward, item)
    ESX.ShowNotification("Heist completed! You got $" .. reward .. " and a " .. item)
end)

-- Heist started notification for all players
RegisterNetEvent('simple_heist:heistStarted')
AddEventHandler('simple_heist:heistStarted', function(playerServerId)
    local playerId = GetPlayerFromServerId(playerServerId)
    local playerName = GetPlayerName(playerId)
    
    ESX.ShowNotification(playerName .. " has started a heist!")
end)

-- Heist ended, clean up
RegisterNetEvent('simple_heist:heistEnded')
AddEventHandler('simple_heist:heistEnded', function()
    if targetCreated then
        -- Remove target zones
        if drillTarget then
            pcall(function() exports.ox_target:removeZone(drillTarget) end)
            drillTarget = nil
        end
        
        if lockpickTarget then
            pcall(function() exports.ox_target:removeZone(lockpickTarget) end)
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
    ESX.ShowNotification(message)
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Delete NPC
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
        
        -- Remove blip
        if npcBlip and DoesBlipExist(npcBlip) then
            RemoveBlip(npcBlip)
        end
        
        -- Remove target zones
        if drillTarget then
            pcall(function() exports.ox_target:removeZone(drillTarget) end)
        end
        
        if lockpickTarget then
            pcall(function() exports.ox_target:removeZone(lockpickTarget) end)
        end
        
        -- Try to remove targets from entity types
        pcall(function()
            if exports and exports.ox_target then
                exports.ox_target:removeModel(GetHashKey(Config.StartNPC.model))
            end
        end)
        
        print("[HEIST] Resource stopped - cleanup completed")
    end
end)
ESX = exports['es_extended']:getSharedObject()

-- Global state variables
local heistNPC = nil
local heistMissionActive = false
local hasPlayerTalkedToNPC = false

-- Hack attempts tracking
local hackAttempts = {
    thermite = 0,
    securityPanel = 0,
    doors = {
        [1] = 0,
        [2] = 0,
        [3] = 0
    }
}

-- Track which doors are permanently disabled (either hacked or max attempts reached)
local doorsPermanentlyDisabled = {
    [1] = false,
    [2] = false,
    [3] = false
}

-- Track which doors are currently being hacked
local doorsBeingHacked = {
    [1] = false,
    [2] = false,
    [3] = false
}

-- Track created objects
local createdObjects = {}

-- Admin commands
RegisterCommand('heist_reset_cooldown', function(source, args, rawCommand)
    -- Check if player has admin permission
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            TriggerServerEvent('J0-CashExchangeHeist:sv:resetCooldown')
            print("Admin: Cooldown has been reset")
        else
            print("Error: You don't have permission for this command")
        end
    end)
end, false)

RegisterCommand('heist_delete_objects', function(source, args, rawCommand)
    -- Check if player has admin permission
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            DeleteAllHeistObjects()
            print("Admin: All heist objects have been deleted")
        else
            print("Error: You don't have permission for this command")
        end
    end)
end, false)

RegisterCommand('heist_lock_doors', function(source, args, rawCommand)
    -- Check if player has admin permission
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            InitializeDoors()
            print("Admin: All doors have been locked")
        else
            print("Error: You don't have permission for this command")
        end
    end)
end, false)

RegisterCommand('heist_reset', function(source, args, rawCommand)
    -- Check if player has admin permission
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            -- Reset all door states
            for doorId=1, 3 do
                doorsPermanentlyDisabled[doorId] = false
                doorsBeingHacked[doorId] = false
                hackAttempts.doors[doorId] = 0
            end
            
            -- Reset hack attempts
            hackAttempts.thermite = 0
            hackAttempts.securityPanel = 0
            
            -- Reset heist state
            heistMissionActive = false
            hasPlayerTalkedToNPC = false
            
            -- Delete objects and lock doors
            DeleteAllHeistObjects()
            InitializeDoors()
            
            -- Reset cooldown on server
            TriggerServerEvent('J0-CashExchangeHeist:sv:resetCooldown')
            
            print("Admin: Heist has been completely reset")
        else
            print("Error: You don't have permission for this command")
        end
    end)
end, false)

-- Register the doors being hacked with the server
RegisterNetEvent('J0-cashExchange:cl:registerDoorHack')
AddEventHandler('J0-cashExchange:cl:registerDoorHack', function(doorId, state)
    doorsBeingHacked[doorId] = state
    -- Update all clients so they can't target this door
    TriggerServerEvent('J0-CashExchangeHeist:sv:updateDoorHackState', doorId, state)
end)

-- Receive door hack state updates from server
RegisterNetEvent('J0-cashExchange:cl:updateDoorHackState')
AddEventHandler('J0-cashExchange:cl:updateDoorHackState', function(doorId, state)
    doorsBeingHacked[doorId] = state
end)

-- Permanently disable a door's interaction
RegisterNetEvent('J0-cashExchange:cl:permanentlyDisableDoor')
AddEventHandler('J0-cashExchange:cl:permanentlyDisableDoor', function(doorId, disabled)
    doorsPermanentlyDisabled[doorId] = disabled
    -- Broadcast to all clients
    TriggerServerEvent('J0-CashExchangeHeist:sv:updateDoorDisabledState', doorId, disabled)
end)

-- Receive door disabled state updates from server
RegisterNetEvent('J0-cashExchange:cl:updateDoorDisabledState')
AddEventHandler('J0-cashExchange:cl:updateDoorDisabledState', function(doorId, disabled)
    doorsPermanentlyDisabled[doorId] = disabled
end)

-- Basic Laser implementation
Laser = {}
Laser.__index = Laser

function Laser.new(startPoint, endPoints, settings)
    local self = setmetatable({}, Laser)
    self.startPoint = startPoint
    self.endPoints = endPoints
    self.settings = settings or {}
    self.active = false
    self.moving = false
    self.hitCallbacks = {}
    
    return self
end

function Laser:setActive(active)
    self.active = active
end

function Laser:setMoving(moving)
    self.moving = moving
end

function Laser:onPlayerHit(callback)
    table.insert(self.hitCallbacks, callback)
end

-- Helper function to check if point is on line
function IsPointOnLine(lineStart, lineEnd, point, threshold)
    local lineVec = vector3(lineEnd.x - lineStart.x, lineEnd.y - lineStart.y, lineEnd.z - lineStart.z)
    local pointVec = vector3(point.x - lineStart.x, point.y - lineStart.y, point.z - lineStart.z)
    
    local lineLength = #lineVec
    local lineDir = vector3(lineVec.x / lineLength, lineVec.y / lineLength, lineVec.z / lineLength)
    
    local dotProduct = pointVec.x * lineDir.x + pointVec.y * lineDir.y + pointVec.z * lineDir.z
    
    if dotProduct < 0 or dotProduct > lineLength then
        return false
    end
    
    local closestPoint = vector3(
        lineStart.x + lineDir.x * dotProduct,
        lineStart.y + lineDir.y * dotProduct,
        lineStart.z + lineDir.z * dotProduct
    )
    
    local distance = #vector3(point.x - closestPoint.x, point.y - closestPoint.y, point.z - closestPoint.z)
    return distance <= threshold
end

local lasers = {
    -- Original lasers
    Laser.new(
        vector3(137.465, -1335.689, 29.661),
        {vector3(135.056, -1338.066, 29.651)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser01"}
    ),  
    Laser.new(
        vector3(137.5, -1335.724, 30.911),
        {vector3(135.108, -1338.116, 30.993)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser02"}
    ),
    Laser.new(
        vector3(133.381, -1331.719, 30.239),
        {vector3(132.993, -1336.093, 30.181)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser03"}
    ),
    Laser.new(
        vector3(133.367, -1331.732, 31.301),
        {vector3(132.99, -1336.096, 30.94)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser04"}
    ),
    Laser.new(
        vector3(130.045, -1334.913, 30.289),
        {vector3(126.5, -1342.825, 30.058)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser05"}
    ),
    Laser.new(
        vector3(132.85, -1336.437, 30.124),
        {vector3(124.507, -1340.9, 30.133)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "exchangelaser06"}
    ),
    
    -- New lasers at vector4(136.446, -1338.824, 29.292, 40.454) - 4 lasers with spacing in Y direction
    Laser.new(
        vector3(136.446, -1338.824, 29.292),
        {vector3(134.446, -1336.824, 29.292)}, -- Heading 40.454 degrees, ending point calculated
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser01"}
    ),
    Laser.new(
        vector3(136.446, -1337.824, 29.292), -- Y+1
        {vector3(134.446, -1335.824, 29.292)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser02"}
    ),
    Laser.new(
        vector3(136.446, -1336.824, 29.292), -- Y+2
        {vector3(134.446, -1334.824, 29.292)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser03"}
    ),
    Laser.new(
        vector3(136.446, -1335.824, 29.292), -- Y+3
        {vector3(134.446, -1333.824, 29.292)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser04"}
    ),
    
    -- New lasers at vector4(130.77, -1341.542, 29.292, 45.91) - 3 lasers with spacing in Y direction
    Laser.new(
        vector3(130.77, -1341.542, 29.292),
        {vector3(128.77, -1339.542, 29.292)}, -- Heading 45.91 degrees, ending point calculated
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser05"}
    ),
    Laser.new(
        vector3(130.77, -1340.542, 29.292), -- Y+1
        {vector3(128.77, -1338.542, 29.292)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser06"}
    ),
    Laser.new(
        vector3(130.77, -1339.542, 29.292), -- Y+2
        {vector3(128.77, -1337.542, 29.292)},
        {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "newlaser07"}
    )
}

-- Render lasers in a separate thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, laser in ipairs(lasers) do
            if laser.active then
                for _, endPoint in ipairs(laser.endPoints) do
                    -- Draw laser beam
                    DrawLine(
                        laser.startPoint.x, laser.startPoint.y, laser.startPoint.z,
                        endPoint.x, endPoint.y, endPoint.z,
                        255, 0, 0, 255 -- Red color
                    )
                    
                    -- Check collision
                    if IsPointOnLine(laser.startPoint, endPoint, playerCoords, 0.25) then
                        for _, callback in ipairs(laser.hitCallbacks) do
                            callback(true, playerCoords)
                        end
                    end
                end
            end
        end
    end
end)

StopLasers = function()
    for _, laser in ipairs(lasers) do
        laser:setActive(false)
    end
end

HitByLaser = function()
    TriggerEvent('J0-cashExchange:hitbylaser')
end

RegisterNetEvent("J0-cashExchange:hitbylaser")
AddEventHandler("J0-cashExchange:hitbylaser", function()
    local playerPed = PlayerPedId()
    local newHealth = math.max(GetEntityHealth(playerPed) - 50, 0)
    SetEntityHealth(playerPed, newHealth)
end)

StartLasers = function()
    for _, laser in ipairs(lasers) do
        laser:setActive(true)
        laser:setMoving(false)
        laser:onPlayerHit(function(playerBeingHit, hitPos)
            if playerBeingHit then HitByLaser() end
        end)
    end
end

-- Helper function to display help text
function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Helper function for thermite animation
function ThermiteAnimation(heading, position)
    local playerPed = PlayerPedId()
    local animDict = "anim@heists@ornate_bank@thermal_charge"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    
    local bagModel = GetHashKey("hei_p_m_bag_var22_arm_s")
    local thermiteModel = GetHashKey("hei_prop_heist_thermite")
    
    RequestModel(bagModel)
    RequestModel(thermiteModel)
    while not HasModelLoaded(bagModel) or not HasModelLoaded(thermiteModel) do
        Citizen.Wait(10)
    end
    
    local bag = CreateObject(bagModel, position.x, position.y, position.z, true, false, true)
    local thermite = CreateObject(thermiteModel, position.x, position.y, position.z, true, false, true)
    
    -- Track created objects
    table.insert(createdObjects, bag)
    table.insert(createdObjects, thermite)
    
    SetEntityHeading(playerPed, heading)
    TaskPlayAnim(playerPed, animDict, "thermal_charge", 8.0, -8.0, -1, 0, 0, false, false, false)
    
    Citizen.Wait(5000)
    
    DeleteObject(bag)
    DeleteObject(thermite)
    ClearPedTasks(playerPed)
end

-- Function to create the heist NPC
function CreateHeistNPC()
    local model = GetHashKey(J0.npcInfo.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    
    heistNPC = CreatePed(4, model, J0.npcInfo.location.x, J0.npcInfo.location.y, J0.npcInfo.location.z, J0.npcInfo.heading, false, true)
    FreezeEntityPosition(heistNPC, true)
    SetEntityInvincible(heistNPC, true)
    SetBlockingOfNonTemporaryEvents(heistNPC, true)
    SetModelAsNoLongerNeeded(model)
    
    -- Add ox_target interaction to NPC
    exports.ox_target:addLocalEntity(heistNPC, {
        {
            name = 'heist_npc',
            icon = 'fas fa-comments',
            label = 'Talk to Exchange Security',
            onSelect = function()
                if not hasPlayerTalkedToNPC then
                    ESX.TriggerServerCallback('J0-CashExchangeHeist:checkCooldown', function(canStart)
                        if canStart then
                            print("NPC: The exchange is ready for a hit. Find the thermite point and get started.")
                            hasPlayerTalkedToNPC = true
                        else
                            print("NPC: Not now, come back later. Someone else hit it recently.")
                        end
                    end)
                else
                    print("NPC: You've already talked to me. Get to work!")
                end
            end,
            canInteract = function()
                return true
            end
        }
    })
end

-- Function to start the heist after talking to NPC
function StartHeistAfterNPC()
    -- Add ox_target to thermite point
    exports.ox_target:addBoxZone({
        coords = vec3(J0.heistCoords.StartLoc.vec.x, J0.heistCoords.StartLoc.vec.y, J0.heistCoords.StartLoc.vec.z),
        size = vec3(1.0, 1.0, 2.0),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'heist_thermite',
                icon = 'fas fa-fire',
                label = 'Plant Thermite',
                onSelect = function()
                    if hasPlayerTalkedToNPC and not heistMissionActive then
                        print("Action: Planting thermite...")
                        Citizen.Wait(1000)
                        
                        local options = {
                            difficulty = 5,
                            time = 3000
                        }
                        
                        local result = exports["j0-minigame"]:StartMinigame("arrowClicker", options)
                        
                        -- Increment attempt counter
                        hackAttempts.thermite = hackAttempts.thermite + 1
                        
                        if result then
                            print("Success: Thermite planted successfully!")
                            TriggerServerEvent('J0-CashExchangeHeist:sv:startCooldown')
                            ThermiteAnimation(J0.heistCoords.ThermiteAnim.heading, J0.heistCoords.ThermiteAnim.vec)
                            TriggerEvent('J0-cashExchange:cl:starterInteraction')
                            heistMissionActive = true
                            StartLasers()
                            
                            -- Reset attempt counter on success
                            hackAttempts.thermite = 0
                        else
                            -- Check if this is the third failed attempt
                            if hackAttempts.thermite >= 3 then
                                print("Failure: Thermite failed too many times. Security alerted!")
                                
                                -- Alert police or trigger some negative event
                                TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'Failed thermite attempt at Cash Exchange', J0.heistCoords.StartLoc.vec)
                                
                                -- Reset attempt counter
                                hackAttempts.thermite = 0
                            else
                                print("Failure: Thermite failed. Attempts left: " .. (3 - hackAttempts.thermite))
                            end
                        end
                    else
                        if not hasPlayerTalkedToNPC then
                            print("Error: Talk to the security guard first!")
                        else
                            print("Error: Heist already in progress")
                        end
                    end
                end,
                canInteract = function()
                    return hasPlayerTalkedToNPC and not heistMissionActive
                end
            }
        }
    })
end

-- Handling laser security system
RegisterNetEvent('J0-cashExchange:cl:starterInteraction')
AddEventHandler('J0-cashExchange:cl:starterInteraction', function()
    -- Add ox_target to laser security panel
    exports.ox_target:addBoxZone({
        coords = vec3(127.989, -1340.056, 29.292), -- New hack panel location
        size = vec3(1.0, 1.0, 2.0),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'laser_panel',
                icon = 'fas fa-shield-alt',
                label = 'Hack Security Panel',
                onSelect = function()
                    print("Action: Hacking security panel...")
                    Citizen.Wait(1000)
                    
                    local options = {
                        difficulty = 6,
                        time = 4500
                    }
                    
                    local result = exports["j0-minigame"]:StartMinigame("arrowClicker", options)
                    
                    -- Increment attempt counter
                    hackAttempts.securityPanel = hackAttempts.securityPanel + 1
                    
                    if result then
                        StopLasers()
                        print("Success: Laser security disabled")
                        SetupDoorTargets() -- Setup door targets after disabling lasers
                        
                        -- Reset attempt counter on success
                        hackAttempts.securityPanel = 0
                    else
                        -- Check if this is the third failed attempt
                        if hackAttempts.securityPanel >= 3 then
                            print("Failure: Security panel hack failed too many times. System lockdown!")
                            
                            -- Make lasers more dangerous or add more security
                            for _, laser in ipairs(lasers) do
                                laser:setMoving(true) -- Make lasers move (if this feature exists)
                            end
                            
                            -- Reset attempt counter
                            hackAttempts.securityPanel = 0
                        else
                            print("Failure: Hack failed. Attempts left: " .. (3 - hackAttempts.securityPanel))
                        end
                    end
                end,
                canInteract = function()
                    return heistMissionActive
                end
            }
        }
    })
    
    -- Setup trolleys
    CreateTrolleys()
    
    -- Alert police
    TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'Cash Exchange heist in progress', J0.heistCoords.StartLoc.vec)
end)

-- Door unlock event handler - SIMPLIFIED
RegisterNetEvent('J0-cashExchange:cl:unlockdoor')
AddEventHandler('J0-cashExchange:cl:unlockdoor', function(doorId)
    print("DEBUG: Unlocking door " .. doorId)
    DoorSystemSetDoorState(doorId, 0) -- Unlocked (0 = unlocked, 1 = locked)
    print("DEBUG: Door " .. doorId .. " unlocked")
end)

-- Setup door interactions using ox_target - SIMPLIFIED
function SetupDoorTargets()
    print("DEBUG: Setting up door targets")
    
    for doorId, door in pairs(J0.cashExchangeDoors) do
        -- Make sure door is in the system and locked
        AddDoorToSystem(doorId, door.hash, door.coords)
        DoorSystemSetDoorState(doorId, 1) -- Locked (1 = locked, 0 = unlocked)
        print("DEBUG: Door " .. doorId .. " set up and locked")
        
        -- Using the specific coordinates for precise targeting with larger target zone
        exports.ox_target:addBoxZone({
            coords = vec3(door.coords.x, door.coords.y, door.coords.z),
            size = vec3(2.0, 2.0, 3.0), -- Increased size for easier targeting
            rotation = door.heading,
            debug = false, -- Set to true to see the target zone
            options = {
                {
                    name = 'door_hack_' .. doorId,
                    icon = 'fas fa-key',
                    label = 'Hack Door ' .. doorId,
                    onSelect = function()
                        -- Check if player has advanced lockpick
                        ESX.TriggerServerCallback('J0-CashExchangeHeist:checkItem', function(hasItem)
                            if hasItem then
                                -- Register this door as being hacked
                                TriggerEvent('J0-cashExchange:cl:registerDoorHack', doorId, true)
                                
                                print("Action: Hacking door " .. doorId .. "...")
                                Citizen.Wait(1000)
                                
                                local options = {
                                    difficulty = 4,
                                    time = 2500
                                }
                                
                                local result = exports["j0-minigame"]:StartMinigame("arrowClicker", options)
                                
                                -- Increment attempt counter
                                hackAttempts.doors[doorId] = hackAttempts.doors[doorId] + 1
                                
                                if result then
                                    -- Success - unlock door
                                    print("Success: Door " .. doorId .. " hack successful, unlocking...")
                                    TriggerEvent('J0-cashExchange:cl:unlockdoor', doorId)
                                    
                                    -- Remove advanced lockpick on success
                                    TriggerServerEvent('J0-CashExchangeHeist:sv:removeItem', 'advancedlockpick', 1)
                                    
                                    -- Reset attempt counter on success
                                    hackAttempts.doors[doorId] = 0
                                    
                                    -- Permanently disable door interaction
                                    TriggerEvent('J0-cashExchange:cl:permanentlyDisableDoor', doorId, true)
                                else
                                    -- Check if this is the third failed attempt
                                    if hackAttempts.doors[doorId] >= 3 then
                                        -- Too many failures - lockout
                                        print("Failure: Door " .. doorId .. " hack failed too many times. Security lockout activated!")
                                        
                                        -- Remove advanced lockpick on third failure
                                        TriggerServerEvent('J0-CashExchangeHeist:sv:removeItem', 'advancedlockpick', 1)
                                        
                                        -- Reset attempt counter
                                        hackAttempts.doors[doorId] = 0
                                        
                                        -- Permanently disable door interaction
                                        TriggerEvent('J0-cashExchange:cl:permanentlyDisableDoor', doorId, true)
                                    else
                                        -- Still have attempts left
                                        print("Failure: Door " .. doorId .. " hack failed. Attempts left: " .. (3 - hackAttempts.doors[doorId]))
                                    end
                                end
                                
                                -- Release the door so others can hack it (although it might be permanently disabled)
                                Citizen.Wait(1000) -- Small delay before release
                                TriggerEvent('J0-cashExchange:cl:registerDoorHack', doorId, false)
                            else
                                print("Error: You need an advanced lockpick to hack this door")
                            end
                        end, 'advancedlockpick')
                    end,
                    canInteract = function()
                        -- Can only interact if:
                        -- 1. Heist is active
                        -- 2. Door is locked
                        -- 3. Door is not currently being hacked by someone else
                        -- 4. Door has not been permanently disabled
                        return heistMissionActive and 
                               DoorSystemGetDoorState(doorId) == 1 and 
                               not doorsBeingHacked[doorId] and
                               not doorsPermanentlyDisabled[doorId]
                    end
                }
            }
        })
    end
end

-- Create trolleys
function CreateTrolleys()
    for index, trolly in pairs(J0.trollysInfo) do
        local model = GetHashKey("hei_prop_hei_cash_trolly_01")
        if trolly.type == "gold" then
            model = GetHashKey("hei_prop_hei_gold_trolly_01")
        end
        
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end
        
        local trollyObj = CreateObject(model, trolly.coords.x, trolly.coords.y, trolly.coords.z, true, false, false)
        PlaceObjectOnGroundProperly(trollyObj)
        SetEntityHeading(trollyObj, trolly.coords.w)
        FreezeEntityPosition(trollyObj, true)
        SetEntityAsMissionEntity(trollyObj, true, true)
        
        -- Track created objects
        table.insert(createdObjects, trollyObj)
        
        -- Setup interaction for this trolley using ox_target
        SetupTrolleyInteraction(index, trolly, trollyObj)
    end
end

-- Setup trolley interactions
function SetupTrolleyInteraction(index, trolly, trollyObj)
    exports.ox_target:addLocalEntity(trollyObj, {
        {
            name = 'trolley_loot_' .. index,
            icon = 'fas fa-hand-holding-usd',
            label = 'Loot ' .. trolly.type:gsub("^%l", string.upper),
            onSelect = function()
                LootTrolley(trolly, trollyObj)
            end,
            canInteract = function()
                return heistMissionActive
            end
        }
    })
end

-- Loot trolley function
function LootTrolley(trolly, trollyObj)
    local playerPed = PlayerPedId()
    local animDict = "anim@heists@ornate_bank@grab_cash"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    
    local bagModel = GetHashKey("hei_p_m_bag_var22_arm_s")
    RequestModel(bagModel)
    while not HasModelLoaded(bagModel) do
        Citizen.Wait(10)
    end
    
    local bagObj = CreateObject(bagModel, GetEntityCoords(playerPed), true, false, false)
    
    -- Track created object
    table.insert(createdObjects, bagObj)
    
    TaskPlayAnim(playerPed, animDict, "intro", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(1500)
    TaskPlayAnim(playerPed, animDict, "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(5000)
    DeleteObject(bagObj)
    
    -- Replace trolly with empty model
    local emptyTrollyModel = GetHashKey("hei_prop_hei_cash_trolly_03")
    if trolly.type == "gold" then
        emptyTrollyModel = GetHashKey("hei_prop_hei_gold_trolly_03")
    end
    
    RequestModel(emptyTrollyModel)
    while not HasModelLoaded(emptyTrollyModel) do
        Citizen.Wait(10)
    end
    
    local emptyTrolly = CreateObject(emptyTrollyModel, GetEntityCoords(trollyObj), true, false, false)
    SetEntityHeading(emptyTrolly, GetEntityHeading(trollyObj))
    PlaceObjectOnGroundProperly(emptyTrolly)
    SetEntityAsMissionEntity(emptyTrolly, true, true)
    FreezeEntityPosition(emptyTrolly, true)
    
    -- Track created object
    table.insert(createdObjects, emptyTrolly)
    
    -- Remove trolley from target system
    exports.ox_target:removeLocalEntity(trollyObj)
    
    DeleteObject(trollyObj)
    
    ClearPedTasks(playerPed)
    
    -- Give reward
    if trolly.type == "cash" then
        TriggerServerEvent('J0-CashExchangeHeist:sv:reward', 'cash')
    else
        TriggerServerEvent('J0-CashExchangeHeist:sv:reward', 'gold')
    end
    
    -- Cleanup after 10 minutes
    Citizen.SetTimeout(600000, function()
        if DoesEntityExist(emptyTrolly) then
            DeleteObject(emptyTrolly)
        end
    end)
end

-- Function to initialize and lock all doors
function InitializeDoors()
    print("DEBUG: Initializing all doors")
    for doorId, door in pairs(J0.cashExchangeDoors) do
        AddDoorToSystem(doorId, door.hash, door.coords)
        DoorSystemSetDoorState(doorId, 1) -- Lock door (1 = locked, 0 = unlocked)
        print("DEBUG: Door " .. doorId .. " initialized and locked")
    end
end

-- Improved function to delete all heist objects
function DeleteAllHeistObjects()
    print("DEBUG: Deleting all heist objects")
    -- First delete any objects we've tracked
    for i, obj in ipairs(createdObjects) do
        if DoesEntityExist(obj) then
            -- If it has target, remove it
            exports.ox_target:removeLocalEntity(obj)
            -- Delete the object
            DeleteObject(obj)
        end
    end
    
    -- Reset the table
    createdObjects = {}
    
    -- Find and delete any trolleys in the area that might not be tracked
    local cashTrolleyModel = GetHashKey("hei_prop_hei_cash_trolly_01")
    local goldTrolleyModel = GetHashKey("hei_prop_hei_gold_trolly_01")
    local emptyCashTrolleyModel = GetHashKey("hei_prop_hei_cash_trolly_03")
    local emptyGoldTrolleyModel = GetHashKey("hei_prop_hei_gold_trolly_03")
    
    -- Detect all objects in range and delete trolleys
    local objects = GetGamePool('CObject')
    local count = 0
    for _, object in ipairs(objects) do
        local model = GetEntityModel(object)
        -- Check if object is any type of trolley
        if model == cashTrolleyModel or model == goldTrolleyModel or 
           model == emptyCashTrolleyModel or model == emptyGoldTrolleyModel then
            -- If it has target, remove it
            exports.ox_target:removeLocalEntity(object)
            -- Delete the object
            DeleteObject(object)
            count = count + 1
        end
    end
    
    print("DEBUG: Deleted " .. count .. " trolleys")
    
    -- Also stop the lasers
    StopLasers()
end

-- Command to manually set up door targets (for testing)
RegisterCommand('setup_door_targets', function()
    print('Setting up door targets...')
    SetupDoorTargets()
end, false)

-- Command to give advancedlockpick (for testing)
RegisterCommand('give_lockpick', function()
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            TriggerServerEvent('J0-CashExchangeHeist:sv:giveItem', 'advancedlockpick', 5)
            print('Added 5 advanced lockpicks to your inventory')
        else
            print('You do not have permission to use this command')
        end
    end)
end, false)

-- Test command to run the minigame directly
RegisterCommand('testminigame', function()
    print('Testing minigame...')
    local options = {
        difficulty = 5,
        time = 3000
    }
    local result = exports["j0-minigame"]:StartMinigame("arrowClicker", options)
    if result then
        print('Minigame Success!')
    else
        print('Minigame Failed!')
    end
end, false)

-- Specific command to delete trolleys only
RegisterCommand('delete_trolleys', function(source, args, rawCommand)
    -- Check if player has admin permission
    ESX.TriggerServerCallback('J0-CashExchangeHeist:isPlayerAdmin', function(isAdmin)
        if isAdmin then
            -- Find and delete any trolleys in the area
            local cashTrolleyModel = GetHashKey("hei_prop_hei_cash_trolly_01")
            local goldTrolleyModel = GetHashKey("hei_prop_hei_gold_trolly_01")
            local emptyCashTrolleyModel = GetHashKey("hei_prop_hei_cash_trolly_03")
            local emptyGoldTrolleyModel = GetHashKey("hei_prop_hei_gold_trolly_03")
            
            -- Detect all objects in range and delete trolleys
            local objects = GetGamePool('CObject')
            local count = 0
            for _, object in ipairs(objects) do
                local model = GetEntityModel(object)
                -- Check if object is any type of trolley
                if model == cashTrolleyModel or model == goldTrolleyModel or 
                   model == emptyCashTrolleyModel or model == emptyGoldTrolleyModel then
                    -- If it has target, remove it
                    exports.ox_target:removeLocalEntity(object)
                    -- Delete the object
                    DeleteObject(object)
                    count = count + 1
                end
            end
            
            print("Deleted " .. count .. " trolleys")
        else
            print("You do not have permission to use this command")
        end
    end)
end, false)

-- Initialize the heist
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Small delay for resources to load
    
    -- Lock all doors when script starts
    InitializeDoors()
    
    -- Setup door targets right away instead of waiting for the heist to start
    SetupDoorTargets()
    
    -- Create NPC and start interactions
    CreateHeistNPC()
    StartHeistAfterNPC()
end)
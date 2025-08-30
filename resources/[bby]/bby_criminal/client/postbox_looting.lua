local ESX = exports['es_extended']:getSharedObject()
local lootedPostboxes = {}
local isLooting = false
local isHandStuck = false
local currentPostbox = nil
local currentPostboxAttempts = 0

-- Utility functions
local function DebugPrint(msg)
    if Config.Debug then
        print('^3[bby_criminal:postbox] ^7' .. msg)
    end
end

-- Find all postboxes in the world
local function GetAllPostboxes()
    local postboxes = {}
    local objects = GetGamePool('CObject')
    
    for _, obj in pairs(objects) do
        if GetEntityModel(obj) == GetHashKey('prop_postbox_01a') then
            table.insert(postboxes, obj)
        end
    end
    
    return postboxes
end

-- Get postbox ID (using coordinates as unique identifier)
local function GetPostboxId(postbox)
    local coords = GetEntityCoords(postbox)
    return string.format("%.2f_%.2f_%.2f", coords.x, coords.y, coords.z)
end

-- Check if postbox has been looted
local function IsPostboxLooted(postbox)
    local id = GetPostboxId(postbox)
    return lootedPostboxes[id] ~= nil
end

-- Lockpick postbox
local function LockpickPostbox(postbox)
    if isLooting then return end
    
    -- Check for lockpick
    if Config.PostboxRequireLockpick then
        local hasLockpick = exports.ox_inventory:Search('count', 'lockpick') > 0
        if not hasLockpick then
            lib.notify({
                title = 'Error',
                description = 'You need a lockpick!',
                type = 'error'
            })
            return
        end
    end
    
    isLooting = true
    local playerPed = PlayerPedId()
    currentPostbox = postbox
    
    -- Face the postbox
    local postboxCoords = GetEntityCoords(postbox)
    TaskTurnPedToFaceCoord(playerPed, postboxCoords.x, postboxCoords.y, postboxCoords.z, 1000)
    Wait(1000)
    
    -- Play lockpicking animation
    lib.requestAnimDict(Config.PostboxAnimations.lockpick.dict)
    TaskPlayAnim(playerPed, Config.PostboxAnimations.lockpick.dict, Config.PostboxAnimations.lockpick.anim,
        8.0, -8.0, Config.PostboxLockpickTime, Config.PostboxAnimations.lockpick.flag, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = Config.PostboxLockpickTime,
        label = 'Lockpicking postbox...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Success - unlock postbox
        ClearPedTasks(playerPed)
        local id = GetPostboxId(postbox)
        lootedPostboxes[id] = {
            unlocked = true,
            looted = false,
            timestamp = GetGameTimer()
        }
        
        lib.notify({
            title = 'Success',
            description = 'Postbox unlocked!',
            type = 'success'
        })
        
        -- Refresh ox_target
        exports.ox_target:removeLocalEntity(postbox, {'lockpick_postbox', 'loot_postbox'})
        AddPostboxTarget(postbox)
    else
        -- Cancelled
        ClearPedTasks(playerPed)
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped lockpicking',
            type = 'error'
        })
    end
    
    isLooting = false
    currentPostbox = nil
end

-- Hand stuck mechanic (now gives reward when freed)
local function HandleHandStuck()
    isHandStuck = true
    local playerPed = PlayerPedId()
    
    -- Freeze player
    FreezeEntityPosition(playerPed, true)
    
    -- Show help text
    local unstuckAttempts = 0
    local requiredPresses = math.random(2, 3)
    
    CreateThread(function()
        while isHandStuck do
            ESX.ShowHelpNotification(('Your hand is stuck! Press ~INPUT_CONTEXT~ to pull it out (%d/%d)'):format(unstuckAttempts, requiredPresses))
            
            if IsControlJustPressed(0, 38) then -- E key
                unstuckAttempts = unstuckAttempts + 1
                
                -- Play struggle animation
                lib.requestAnimDict('mini@repair')
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8.0, 1000, 0, 0, false, false, false)
                
                if unstuckAttempts >= requiredPresses then
                    -- Free the hand
                    isHandStuck = false
                    FreezeEntityPosition(playerPed, false)
                    ClearPedTasks(playerPed)
                    
                    lib.notify({
                        title = 'Success',
                        description = 'You freed your hand!',
                        type = 'success'
                    })
                    
                    -- Increment attempts and give reward
                    currentPostboxAttempts = currentPostboxAttempts + 1
                    TriggerServerEvent('bby_criminal:rewardPostboxSingle') -- Single envelope reward
                    
                    local id = GetPostboxId(currentPostbox)
                    
                    -- Check if we've reached max attempts (3 envelopes)
                    if currentPostboxAttempts >= 3 then
                        -- Mark as fully looted
                        if lootedPostboxes[id] then
                            lootedPostboxes[id].looted = true
                            lootedPostboxes[id].cooldownTime = math.random(Config.PostboxResetTimeMin, Config.PostboxResetTimeMax)
                            DebugPrint(('Postbox %s fully looted (3 envelopes), will reset in %d minutes'):format(id, lootedPostboxes[id].cooldownTime / 60000))
                        end
                        
                        lib.notify({
                            title = 'Postbox Empty',
                            description = 'You got all 3 envelopes!',
                            type = 'info'
                        })
                        
                        -- Reset attempts counter
                        currentPostboxAttempts = 0
                        
                        -- Refresh target to remove interactions
                        exports.ox_target:removeLocalEntity(currentPostbox, {'lockpick_postbox', 'loot_postbox'})
                        AddPostboxTarget(currentPostbox)
                    else
                        lib.notify({
                            title = 'Envelope Found',
                            description = ('Got envelope %d/3, you can try again!'):format(currentPostboxAttempts),
                            type = 'success'
                        })
                        
                        -- Keep postbox available for more attempts
                        if lootedPostboxes[id] then
                            lootedPostboxes[id].attempts = currentPostboxAttempts
                        end
                    end
                    
                    break
                end
            end
            
            Wait(0)
        end
        
        isLooting = false
    end)
end

-- Loot postbox
local function LootPostbox(postbox)
    if isLooting or isHandStuck then return end
    
    isLooting = true
    currentPostbox = postbox
    local playerPed = PlayerPedId()
    
    -- Get or initialize attempts for this postbox
    local id = GetPostboxId(postbox)
    if lootedPostboxes[id] and lootedPostboxes[id].attempts then
        currentPostboxAttempts = lootedPostboxes[id].attempts
    else
        currentPostboxAttempts = 0
    end
    
    -- Face the postbox
    local postboxCoords = GetEntityCoords(postbox)
    TaskTurnPedToFaceCoord(playerPed, postboxCoords.x, postboxCoords.y, postboxCoords.z, 1000)
    Wait(1000)
    
    -- Play reaching animation
    lib.requestAnimDict(Config.PostboxAnimations.reach.dict)
    TaskPlayAnim(playerPed, Config.PostboxAnimations.reach.dict, Config.PostboxAnimations.reach.anim,
        8.0, -8.0, -1, Config.PostboxAnimations.reach.flag, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = Config.PostboxStealTime,
        label = 'Reaching inside...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Always get hand stuck when reaching in
        lib.notify({
            title = 'Oh no!',
            description = 'Your hand is stuck in the postbox!',
            type = 'error'
        })
        HandleHandStuck()
        -- Note: HandleHandStuck now manages the rewards and looting status
    else
        -- Cancelled
        ClearPedTasks(playerPed)
        lib.notify({
            title = 'Cancelled',
            description = 'You stopped searching',
            type = 'error'
        })
    end
    
    if not isHandStuck then
        isLooting = false
        currentPostbox = nil
    end
end

-- Add ox_target to postbox
function AddPostboxTarget(postbox)
    local id = GetPostboxId(postbox)
    local postboxData = lootedPostboxes[id]
    
    local options = {}
    
    if not postboxData or not postboxData.unlocked then
        -- Postbox is locked, show lockpick option
        table.insert(options, {
            name = 'lockpick_postbox',
            icon = 'fas fa-lock',
            label = 'Lockpick Postbox',
            distance = 1.5,
            canInteract = function(entity, distance, coords, name, bone)
                return not isLooting and not isHandStuck
            end,
            onSelect = function(data)
                LockpickPostbox(data.entity)
            end
        })
    elseif postboxData.unlocked and not postboxData.looted then
        -- Postbox is unlocked but not looted
        table.insert(options, {
            name = 'loot_postbox',
            icon = 'fas fa-hand-paper',
            label = 'Search Postbox',
            distance = 1.5,
            canInteract = function(entity, distance, coords, name, bone)
                return not isLooting and not isHandStuck
            end,
            onSelect = function(data)
                LootPostbox(data.entity)
            end
        })
    end
    
    -- Only add options if there are any
    if #options > 0 then
        exports.ox_target:addLocalEntity(postbox, options)
    end
end

-- Initialize postboxes
local function InitializePostboxes()
    local postboxes = GetAllPostboxes()
    DebugPrint('Found ' .. #postboxes .. ' postboxes in the world')
    
    for _, postbox in pairs(postboxes) do
        AddPostboxTarget(postbox)
    end
end

-- Reset looted postboxes individually based on their own cooldown
CreateThread(function()
    while true do
        Wait(60000) -- Check every minute
        
        local currentTime = GetGameTimer()
        local resetCount = 0
        local postboxesToReset = {}
        
        for id, data in pairs(lootedPostboxes) do
            if data.looted then
                -- Each postbox has its own cooldown time
                local cooldownTime = data.cooldownTime or Config.PostboxResetTime
                if (currentTime - data.timestamp) > cooldownTime then
                    postboxesToReset[id] = true
                    resetCount = resetCount + 1
                end
            end
        end
        
        -- Reset the postboxes that have cooled down
        for id, _ in pairs(postboxesToReset) do
            lootedPostboxes[id] = nil
        end
        
        if resetCount > 0 then
            DebugPrint('Reset ' .. resetCount .. ' looted postboxes')
            
            -- Reinitialize targets for reset postboxes
            local postboxes = GetAllPostboxes()
            for _, postbox in pairs(postboxes) do
                local postboxId = GetPostboxId(postbox)
                if postboxesToReset[postboxId] then
                    exports.ox_target:removeLocalEntity(postbox, {'lockpick_postbox', 'loot_postbox'})
                    AddPostboxTarget(postbox)
                end
            end
        end
    end
end)

-- Scan for new postboxes periodically
CreateThread(function()
    Wait(5000) -- Initial wait
    InitializePostboxes()
    
    while true do
        Wait(30000) -- Check every 30 seconds for new postboxes
        
        local postboxes = GetAllPostboxes()
        for _, postbox in pairs(postboxes) do
            -- Check if this postbox already has targets
            local id = GetPostboxId(postbox)
            if not lootedPostboxes[id] or not lootedPostboxes[id].targeted then
                AddPostboxTarget(postbox)
                if lootedPostboxes[id] then
                    lootedPostboxes[id].targeted = true
                end
            end
        end
    end
end)

-- Debug commands
if Config.Debug then
    RegisterCommand('resetpostboxes', function()
        lootedPostboxes = {}
        InitializePostboxes()
        print('^2[DEBUG] All postboxes have been reset')
    end, false)
    
    RegisterCommand('checkpostboxes', function()
        local postboxes = GetAllPostboxes()
        local lootedCount = 0
        for id, data in pairs(lootedPostboxes) do
            if data.looted then
                lootedCount = lootedCount + 1
            end
        end
        print('^2[DEBUG] Total postboxes: ' .. #postboxes .. ', Looted: ' .. lootedCount)
    end, false)
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Remove all postbox targets
    local postboxes = GetAllPostboxes()
    for _, postbox in pairs(postboxes) do
        exports.ox_target:removeLocalEntity(postbox, {'lockpick_postbox', 'loot_postbox'})
    end
end)
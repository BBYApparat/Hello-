-- client/main.lua
local ESX = exports['es_extended']:getSharedObject()
local spawnedCows = {}
local cowCooldowns = {}
local isMilking = false

-- Spawn all cows when resource starts
local function spawnCows()
    for i, cowData in ipairs(Config.CowLocations) do
        local model = GetHashKey(Config.CowModel)
        
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        
        local cow = CreatePed(28, model, cowData.coords.x, cowData.coords.y, cowData.coords.z, cowData.heading, false, true)
        
        -- Make cow stationary and realistic
        SetEntityInvincible(cow, true)
        SetPedCanRagdoll(cow, false)
        SetBlockingOfNonTemporaryEvents(cow, true)
        SetEntityCanBeDamaged(cow, false)
        SetPedRelationshipGroupHash(cow, GetHashKey("AMBIENT_GANG_LOST"))
        
        -- Add to spawned cows table
        spawnedCows[i] = {
            entity = cow,
            id = i,
            coords = cowData.coords,
            cooldown = 0
        }
        
        -- Add ox_target interaction
        exports.ox_target:addLocalEntity(cow, {
            {
                name = 'milk_cow_' .. i,
                label = '🥛 Milk Cow',
                icon = 'fas fa-hand-paper',
                distance = 2.0,
                canInteract = function()
                    return not isMilking and (cowCooldowns[i] or 0) < GetGameTimer()
                end,
                onSelect = function()
                    startMilkingProcess(i)
                end
            }
        })
        
        SetModelAsNoLongerNeeded(model)
    end
    
    print(string.format("^2[Cow Milking]^7 Spawned %d cows successfully!", #Config.CowLocations))
end

-- Remove all cows when resource stops
local function removeCows()
    for i, cowData in pairs(spawnedCows) do
        if DoesEntityExist(cowData.entity) then
            exports.ox_target:removeLocalEntity(cowData.entity)
            DeleteEntity(cowData.entity)
        end
    end
    spawnedCows = {}
    cowCooldowns = {}
end

-- Start the milking process
function startMilkingProcess(cowId)
    if isMilking then return end
    if (cowCooldowns[cowId] or 0) > GetGameTimer() then
        lib.notify({
            title = 'Cow Milking',
            description = 'This cow was recently milked. Please wait.',
            type = 'error'
        })
        return
    end
    
    isMilking = true
    local cow = spawnedCows[cowId]
    if not cow or not DoesEntityExist(cow.entity) then
        isMilking = false
        return
    end
    
    -- Move player to cow
    local playerPed = PlayerPedId()
    local cowCoords = GetEntityCoords(cow.entity)
    local cowHeading = GetEntityHeading(cow.entity)
    
    -- Position player next to cow
    local offsetCoords = GetOffsetFromEntityInWorldCoords(cow.entity, -1.2, 0.0, 0.0)
    SetEntityCoords(playerPed, offsetCoords.x, offsetCoords.y, offsetCoords.z)
    SetEntityHeading(playerPed, cowHeading + 90.0)
    
    -- Start milking animation
    playMilkingAnimation()
    
    -- Wait a moment then start minigame
    Wait(2000)
    
    startMilkingMinigame(cowId)
end

-- Play milking animation
function playMilkingAnimation()
    local playerPed = PlayerPedId()
    
    lib.requestAnimDict("amb@medic@standing@kneel@base", 500)
    TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Milking minigame using ps-minigames
function startMilkingMinigame(cowId)
    lib.notify({
        title = 'Cow Milking',
        description = '🥛 Milking started! Complete the skill checks!',
        type = 'info'
    })
    
    -- Use ps-minigames skillcheck
    local success = exports['ps-minigames']:Skillcheck({
        {
            area = {20, 30}, -- Smaller area = harder
            speed = {700, 1200} -- Speed range in ms
        },
        {
            area = {25, 35},
            speed = {600, 1000}
        },
        {
            area = {20, 25},
            speed = {800, 1400}
        },
        {
            area = {30, 40},
            speed = {500, 900}
        },
        {
            area = {15, 25},
            speed = {900, 1500}
        }
    })
    
    -- Stop animation
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    
    -- Handle result
    finishMilking(cowId, success)
    isMilking = false
end

-- Finish milking process
function finishMilking(cowId, success)
    if success then
        lib.notify({
            title = 'Cow Milking',
            description = '🥛 Successfully milked the cow!',
            type = 'success'
        })
        
        -- Trigger server event to give milk
        TriggerServerEvent('cow-milking:giveMilk', cowId)
        
        -- Set cooldown for this cow
        local cooldownTime = GetGameTimer() + (Config.CowCooldowns[cowId] * 60 * 1000) -- Convert minutes to ms
        cowCooldowns[cowId] = cooldownTime
        
        lib.notify({
            title = 'Cow Milking',
            description = string.format('This cow needs %d minutes to recover.', Config.CowCooldowns[cowId]),
            type = 'info'
        })
    else
        lib.notify({
            title = 'Cow Milking',
            description = '😞 Milking failed! The cow got scared.',
            type = 'error'
        })
        
        -- Set short cooldown even on failure
        local cooldownTime = GetGameTimer() + (2 * 60 * 1000) -- 2 minutes cooldown on failure
        cowCooldowns[cowId] = cooldownTime
    end
end

-- Event handlers
RegisterNetEvent('cow-milking:syncCooldowns')
AddEventHandler('cow-milking:syncCooldowns', function(serverCooldowns)
    cowCooldowns = serverCooldowns
end)

-- Drink milk effect
RegisterNetEvent('cow-milking:drinkMilk')
AddEventHandler('cow-milking:drinkMilk', function()
    local playerPed = PlayerPedId()
    
    -- Add small health boost
    local currentHealth = GetEntityHealth(playerPed)
    local newHealth = math.min(currentHealth + 20, 200) -- Max health 200
    SetEntityHealth(playerPed, newHealth)
    
    -- Play drinking animation
    lib.requestAnimDict("mp_player_intdrink", 500)
    TaskPlayAnim(playerPed, "mp_player_intdrink", "loop_bottle", 1.0, -1.0, 2000, 0, 1, true, true, true)
    
    lib.notify({
        title = 'Health',
        description = 'You feel refreshed!',
        type = 'success'
    })
end)

-- Resource events
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Wait(2000) -- Wait for everything to load
    spawnCows()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    removeCows()
end)

-- Debug commands (remove in production)
RegisterCommand('respawn_cows', function()
    removeCows()
    Wait(1000)
    spawnCows()
    lib.notify({
        title = 'Debug',
        description = 'Cows respawned!',
        type = 'success'
    })
end, false)

RegisterCommand('check_cooldowns', function()
    local currentTime = GetGameTimer()
    for cowId, cooldownTime in pairs(cowCooldowns) do
        local timeLeft = math.max(0, cooldownTime - currentTime)
        local minutesLeft = math.ceil(timeLeft / 60000)
        print(string.format("Cow %d: %d minutes left", cowId, minutesLeft))
    end
end, false)
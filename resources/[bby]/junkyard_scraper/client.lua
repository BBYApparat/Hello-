local ox_inventory = exports.ox_inventory
local isInJunkyard = false
local scrapProgress = {} -- Global tracker for all scraped vehicles
local currentJobVehicles = {} -- Vehicles scraped in current job only
local junkyardBotPed = nil
local hasActiveJob = false
local vehiclesScraped = 0
local currentJobXP = 0 -- XP earned in current job
local totalXP = 0 -- Total XP (will be loaded from server)

-- Check if player is in junkyard zone
local function isPlayerInJunkyard()
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    -- Simple distance check from center of junkyard
    local center = vector3(2382.0, 3094.0, 47.5) -- Approximate center of your zone
    local distance = #(playerCoords - center)
    
    return distance <= 150.0 -- 150m radius should cover your junkyard area
end

-- Initialize ox_target for scrapable objects
local function setupTargets()
    if Config.Debug then
        print('[Junkyard Scraper] Setting up ox_target for models:', json.encode(Config.ScrapableModels))
    end
    
    exports.ox_target:addModel(Config.ScrapableModels, {
        {
            icon = 'fas fa-tools',
            label = 'Scrap Object',
            onSelect = function(data)
                if not hasActiveJob then
                    lib.notify({
                        title = 'Junkyard Scraper',
                        description = 'You need to talk to the Junkyard Boss first to get a job!',
                        type = 'error'
                    })
                    return
                end
                
                if isPlayerInJunkyard() then
                    startScrapProcess(data.entity)
                else
                    lib.notify({
                        title = 'Junkyard Scraper',
                        description = 'You need to be in the junkyard to scrap objects!',
                        type = 'error'
                    })
                end
            end,
            canInteract = function(entity, distance)
                return distance < 3.0 and isPlayerInJunkyard() and hasActiveJob
            end
        }
    })
end

-- Start scrap process
function startScrapProcess(entity)
    local entityId = NetworkGetNetworkIdFromEntity(entity)
    
    -- Check if vehicle already scraped by THIS player in current job
    if currentJobVehicles[entityId] then
        lib.notify({
            title = 'Junkyard Scraper',
            description = 'You already scraped this vehicle in your current job!',
            type = 'error'
        })
        return
    end
    
    -- Get max vehicles for current XP level
    local maxVehicles = totalXP >= Config.XPFor5Vehicles and Config.MaxVehiclesWithBonus or Config.MaxVehiclesPerJob
    
    -- Check if player has reached vehicle limit for current job
    if vehiclesScraped >= maxVehicles then
        lib.notify({
            title = 'Junkyard Scraper',
            description = string.format('Job complete! You\'ve scraped %d vehicles. Return to the boss for your next job.', maxVehicles),
            type = 'error'
        })
        return
    end
    
    -- Start animation
    lib.requestAnimDict(Config.ScrapAnimation.dict)
    TaskPlayAnim(PlayerPedId(), Config.ScrapAnimation.dict, Config.ScrapAnimation.anim, 8.0, -8.0, -1, Config.ScrapAnimation.flag, 0, false, false, false)
    
    -- Show progress bar
    if lib.progressBar({
        duration = Config.ProgressTime,
        label = Config.ScrapRewards.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
    }) then
        -- Progress completed successfully
        ClearPedTasksImmediately(PlayerPedId())
        
        -- Mark vehicle as scraped in current job
        currentJobVehicles[entityId] = true
        vehiclesScraped = vehiclesScraped + 1
        currentJobXP = currentJobXP + Config.XPPerVehicle
        
        -- Give rewards to server
        TriggerServerEvent('junkyard_scraper:giveRewards', Config.ScrapRewards.items, 1)
        
        -- Get max vehicles for current XP level
        local maxVehicles = totalXP >= Config.XPFor5Vehicles and Config.MaxVehiclesWithBonus or Config.MaxVehiclesPerJob
        
        -- Notify player with XP
        local remainingVehicles = maxVehicles - vehiclesScraped
        lib.notify({
            title = 'Junkyard Scraper',
            description = string.format('Vehicle scraped! +%d XP | Vehicles remaining: %d', Config.XPPerVehicle, remainingVehicles),
            type = 'success'
        })
        
        -- Check if job is complete
        if vehiclesScraped >= maxVehicles then
            lib.notify({
                title = 'Junkyard Scraper',
                description = string.format('Job complete! +%d XP earned this job. Return to the boss!', currentJobXP),
                type = 'inform'
            })
        end
        
        if Config.Debug then
            print(string.format('[Junkyard Scraper] Entity %d scraped, Vehicles scraped: %d', entityId, vehiclesScraped))
        end
    else
        -- Progress cancelled
        ClearPedTasksImmediately(PlayerPedId())
        lib.notify({
            title = 'Junkyard Scraper',
            description = 'Scrapping cancelled!',
            type = 'error'
        })
    end
end

-- Spawn junkyard bot NPC
local function spawnJunkyardBot()
    lib.requestModel(Config.BotModel, 10000)
    
    junkyardBotPed = CreatePed(4, Config.BotModel, Config.BotPosition.x, Config.BotPosition.y, Config.BotPosition.z - 1.0, Config.BotHeading, false, false)
    
    SetEntityInvincible(junkyardBotPed, true)
    FreezeEntityPosition(junkyardBotPed, true)
    SetBlockingOfNonTemporaryEvents(junkyardBotPed, true)
    
    -- Add ox_target interaction for the bot
    exports.ox_target:addLocalEntity(junkyardBotPed, {
        {
            icon = 'fas fa-tools',
            label = 'Talk to Junkyard Boss',
            onSelect = function()
                -- Simple test - direct menu show
                totalXP = 0
                showBossMenu()
            end,
            distance = 3.0
        }
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] Bot spawned at', Config.BotPosition)
    end
end

-- Open boss menu
function openBossMenu()
    if Config.Debug then
        print('[Junkyard Scraper] Opening boss menu, requesting XP data')
    end
    
    -- Load player XP from server first
    TriggerServerEvent('junkyard_scraper:getPlayerXP')
    
    -- Fallback timeout in case server doesn't respond
    SetTimeout(3000, function()
        if not totalXP then
            if Config.Debug then
                print('[Junkyard Scraper] Server timeout, using default XP (0)')
            end
            totalXP = 0
            showBossMenu()
        end
    end)
end

-- Handle XP data from server
RegisterNetEvent('junkyard_scraper:receivePlayerXP')
AddEventHandler('junkyard_scraper:receivePlayerXP', function(xp)
    if Config.Debug then
        print('[Junkyard Scraper] Received XP data:', xp)
    end
    
    totalXP = xp
    showBossMenu()
end)

-- Show boss menu
function showBossMenu()
    local maxVehicles = totalXP >= Config.XPFor5Vehicles and Config.MaxVehiclesWithBonus or Config.MaxVehiclesPerJob
    local xpToNext = totalXP >= Config.XPFor5Vehicles and "MAX LEVEL" or string.format("%d/%d XP", totalXP, Config.XPFor5Vehicles)
    
    if Config.Debug then
        print('[Junkyard Scraper] Showing boss menu - Total XP:', totalXP, 'Has Active Job:', hasActiveJob)
    end
    
    local options = {}
    
    if not hasActiveJob then
        -- No active job
        table.insert(options, {
            title = 'Start New Job',
            description = string.format('Start scrapping %d vehicles (+%d XP each)', maxVehicles, Config.XPPerVehicle),
            onSelect = startJunkyardJob
        })
    else
        -- Has active job
        local remainingVehicles = maxVehicles - vehiclesScraped
        if remainingVehicles > 0 then
            table.insert(options, {
                title = 'Continue Current Job',
                description = string.format('You have %d vehicles left to scrap', remainingVehicles),
                disabled = true
            })
            table.insert(options, {
                title = 'Cancel Current Job',
                description = string.format('⚠️ You will lose %d XP from this job!', currentJobXP),
                onSelect = cancelCurrentJob
            })
        else
            table.insert(options, {
                title = 'Complete Job',
                description = string.format('Finish your job to earn %d XP!', currentJobXP),
                onSelect = completeJob
            })
        end
    end
    
    table.insert(options, {
        title = 'Check Stats',
        description = string.format('Total XP: %d | Progress: %s', totalXP, xpToNext),
        disabled = true
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] Menu options:', json.encode(options))
    end

    lib.registerMenu({
        id = 'junkyard_boss_menu',
        title = 'Junkyard Boss',
        position = 'top-right',
        options = options
    })
    
    lib.showMenu('junkyard_boss_menu')
    
    if Config.Debug then
        print('[Junkyard Scraper] Menu should be displayed now')
    end
end

-- Start junkyard job
function startJunkyardJob()
    local maxVehicles = totalXP >= Config.XPFor5Vehicles and Config.MaxVehiclesWithBonus or Config.MaxVehiclesPerJob
    
    -- Reset job variables
    hasActiveJob = true
    vehiclesScraped = 0
    currentJobXP = 0
    currentJobVehicles = {} -- Reset only current job vehicles
    
    lib.notify({
        title = 'Junkyard Boss',
        description = string.format('Job started! Scrap %d vehicles (+%d XP each)', maxVehicles, Config.XPPerVehicle),
        type = 'success'
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] New job started')
    end
end

-- Cancel current job
function cancelCurrentJob()
    hasActiveJob = false
    vehiclesScraped = 0
    currentJobXP = 0
    currentJobVehicles = {}
    
    lib.notify({
        title = 'Junkyard Boss',
        description = 'Job cancelled! You lost the XP from this run.',
        type = 'error'
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] Job cancelled')
    end
end

-- Complete job
function completeJob()
    if currentJobXP > 0 then
        TriggerServerEvent('junkyard_scraper:completeJob', currentJobXP)
    end
    
    hasActiveJob = false
    vehiclesScraped = 0
    currentJobXP = 0
    currentJobVehicles = {}
    
    lib.notify({
        title = 'Junkyard Boss',
        description = 'Job completed! XP has been saved.',
        type = 'success'
    })
end

-- Initialize when resource starts
CreateThread(function()
    Wait(1000) -- Wait for dependencies to load
    setupTargets()
    spawnJunkyardBot()
    
    if Config.Debug then
        print('[Junkyard Scraper] Client initialized')
    end
end)

-- Zone detection
CreateThread(function()
    while true do
        local wasInJunkyard = isInJunkyard
        isInJunkyard = isPlayerInJunkyard()
        
        if isInJunkyard and not wasInJunkyard then
            lib.notify({
                title = 'Junkyard Scraper',
                description = 'Entered junkyard - You can now scrap objects!',
                type = 'inform'
            })
        elseif not isInJunkyard and wasInJunkyard then
            lib.notify({
                title = 'Junkyard Scraper',
                description = 'Left junkyard area',
                type = 'inform'
            })
        end
        
        Wait(2000)
    end
end)
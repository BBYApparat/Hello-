local ox_inventory = exports.ox_inventory
local isInJunkyard = false
local scrapProgress = {}
local junkyardBotPed = nil
local hasActiveJob = false
local vehiclesScraped = 0
local scrapedVehicles = {}

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
    
    -- Check if vehicle already scraped
    if scrapProgress[entityId] then
        lib.notify({
            title = 'Junkyard Scraper',
            description = 'This vehicle has already been scraped!',
            type = 'error'
        })
        return
    end
    
    -- Check if player has reached vehicle limit for current job
    if vehiclesScraped >= Config.MaxVehiclesPerJob then
        lib.notify({
            title = 'Junkyard Scraper',
            description = string.format('Job complete! You\'ve scraped %d vehicles. Return to the boss for your next job.', Config.MaxVehiclesPerJob),
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
        
        -- Mark vehicle as scraped
        scrapProgress[entityId] = true
        vehiclesScraped = vehiclesScraped + 1
        
        -- Give rewards to server
        TriggerServerEvent('junkyard_scraper:giveRewards', Config.ScrapRewards.items, 1)
        
        -- Notify player
        local remainingVehicles = Config.MaxVehiclesPerJob - vehiclesScraped
        lib.notify({
            title = 'Junkyard Scraper',
            description = string.format('Vehicle scraped! Vehicles remaining: %d', remainingVehicles),
            type = 'success'
        })
        
        -- Check if job is complete
        if vehiclesScraped >= Config.MaxVehiclesPerJob then
            lib.notify({
                title = 'Junkyard Scraper',
                description = 'Job complete! Return to the boss for your next job.',
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
                startJunkyardJob()
            end,
            distance = 3.0
        }
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] Bot spawned at', Config.BotPosition)
    end
end

-- Start junkyard job dialogue
function startJunkyardJob()
    if hasActiveJob and vehiclesScraped < Config.MaxVehiclesPerJob then
        local remainingVehicles = Config.MaxVehiclesPerJob - vehiclesScraped
        lib.notify({
            title = 'Junkyard Boss',
            description = string.format('You still have %d vehicles left to scrap in your current job!', remainingVehicles),
            type = 'inform'
        })
        return
    end
    
    local dialogContent
    local buttonLabel
    
    if not hasActiveJob then
        -- First time talking or no active job
        dialogContent = 'Hey there! I run this junkyard operation. You can scrap the old cars and machinery around here for materials.\n\nEach vehicle can be scraped ONCE and you\'ll get good materials from it. I\'ll give you 3 vehicles to work on at a time.\n\nReady to start?'
        buttonLabel = 'Start Job'
    else
        -- Job completed, offering new job
        dialogContent = 'Good work! You completed your last batch of 3 vehicles. Ready for another round?'
        buttonLabel = 'Start New Job'
    end
    
    local alert = lib.alertDialog({
        header = 'Junkyard Boss',
        content = dialogContent,
        centered = true,
        cancel = false,
        labels = {
            confirm = buttonLabel
        }
    })
    
    -- Reset job variables
    hasActiveJob = true
    vehiclesScraped = 0
    scrapProgress = {} -- Reset all scraped vehicles
    
    lib.notify({
        title = 'Junkyard Boss',
        description = string.format('Job started! You can now scrap %d vehicles around the yard.', Config.MaxVehiclesPerJob),
        type = 'success'
    })
    
    if Config.Debug then
        print('[Junkyard Scraper] New job started')
    end
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
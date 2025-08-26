local ox_inventory = exports.ox_inventory
local isInJunkyard = false
local scrapProgress = {}

-- Check if player is in junkyard zone
local function isPlayerInJunkyard()
    local playerCoords = GetEntityCoords(PlayerPedId())
    return lib.zones.poly({
        points = Config.JunkyardZone,
        thickness = 50.0
    }):contains(playerCoords)
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
                return distance < 3.0 and isPlayerInJunkyard()
            end
        }
    })
end

-- Start scrap process
function startScrapProcess(entity)
    local entityId = NetworkGetNetworkIdFromEntity(entity)
    local currentStage = scrapProgress[entityId] or 0
    
    if currentStage >= 3 then
        lib.notify({
            title = 'Junkyard Scraper',
            description = 'This object has been fully scraped!',
            type = 'error'
        })
        return
    end
    
    local nextStage = currentStage + 1
    local stageConfig = Config.ScrapStages[nextStage]
    
    if not stageConfig then
        lib.notify({
            title = 'Junkyard Scraper',
            description = 'No more stages available!',
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
        label = stageConfig.label,
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
        
        -- Update progress
        scrapProgress[entityId] = nextStage
        
        -- Give rewards to server
        TriggerServerEvent('junkyard_scraper:giveRewards', stageConfig.items, nextStage)
        
        -- Notify player
        lib.notify({
            title = 'Junkyard Scraper',
            description = string.format('Completed %s! Progress: %d/3', stageConfig.label, nextStage),
            type = 'success'
        })
        
        if Config.Debug then
            print(string.format('[Junkyard Scraper] Entity %d progress: %d/3', entityId, nextStage))
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

-- Initialize when resource starts
CreateThread(function()
    Wait(1000) -- Wait for dependencies to load
    setupTargets()
    
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
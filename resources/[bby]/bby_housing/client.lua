local isInHouse = false
local isInGarage = false
local currentHouseId = nil
local currentHouseType = nil
local houseOwnership = {}
local isRaidActive = false
local pendingDoorbellData = nil

-- Decoration System Variables
local isPlacingDecoration = false
local placementPreview = nil
local currentDecorations = {}
local decorationRotation = 0.0

-- Get house ownership data on resource start
CreateThread(function()
    ESX.TriggerServerCallback('housing:getHouseData', function(data)
        houseOwnership = data
        setupHouseZones()
    end)
end)

-- Update house ownership data
RegisterNetEvent('housing:updateHouseData', function(data)
    houseOwnership = data
    setupHouseZones() -- Refresh zones with updated data
end)

-- Setup interaction zones for all houses
function setupHouseZones()
    -- Clear existing zones first (if any)
    for i = 1, 15 do
        pcall(function()
            exports.ox_target:removeZone('house_entrance_' .. i)
            exports.ox_target:removeZone('house_garage_' .. i)
        end)
    end
    
    -- Create zones for each house
    for houseId, houseData in pairs(Config.Houses) do
        local isOwned = houseOwnership[houseId] ~= nil
        local isOwnedByPlayer = houseOwnership[houseId] == ESX.GetPlayerData().identifier
        local houseType = Config.HouseTypes[houseData.type]
        local actualPrice = math.floor(houseData.base_price * houseType.interior.price_multiplier)
        
        -- House entrance options
        local houseOptions = {}
        
        if not isOwned then
            table.insert(houseOptions, {
                name = 'purchase_house_' .. houseId,
                serverEvent = 'housing:purchaseHouse',
                serverEventData = houseId,
                icon = 'fas fa-home',
                label = 'Purchase ' .. houseType.label .. ' ($' .. actualPrice .. ')',
                canInteract = function()
                    return not isInHouse and not isInGarage
                end
            })
        elseif isOwnedByPlayer then
            table.insert(houseOptions, {
                name = 'enter_house_' .. houseId,
                serverEvent = 'housing:enterHouse',
                serverEventData = houseId,
                icon = 'fas fa-door-open',
                label = 'Enter ' .. houseType.label,
                canInteract = function()
                    return not isInHouse and not isInGarage
                end
            })
            
            table.insert(houseOptions, {
                name = 'sell_house_' .. houseId,
                serverEvent = 'housing:sellHouse',
                serverEventData = houseId,
                icon = 'fas fa-dollar-sign',
                label = 'Sell House (70% refund)',
                canInteract = function()
                    return not isInHouse and not isInGarage
                end
            })
            
            -- Doorbell history for owner
            table.insert(houseOptions, {
                name = 'doorbell_history_' .. houseId,
                event = 'housing:viewDoorbellHistory',
                eventData = houseId,
                icon = 'fas fa-bell',
                label = 'View Doorbell History',
                canInteract = function()
                    return not isInHouse and not isInGarage
                end
            })
        else
            -- Doorbell for visitors
            table.insert(houseOptions, {
                name = 'ring_doorbell_' .. houseId,
                serverEvent = 'housing:ringDoorbell',
                serverEventData = houseId,
                icon = 'fas fa-bell',
                label = 'Ring Doorbell',
                canInteract = function()
                    return not isInHouse and not isInGarage
                end
            })
        end
        
        -- Police raid option (always available for police)
        table.insert(houseOptions, {
            name = 'police_raid_' .. houseId,
            serverEvent = 'housing:initiateRaid',
            serverEventData = houseId,
            icon = 'fas fa-shield-alt',
            label = '🚨 Initiate Raid',
            canInteract = function()
                local playerData = ESX.GetPlayerData()
                local isPolice = false
                
                for _, job in ipairs(Config.PoliceJobs) do
                    if playerData.job and playerData.job.name == job then
                        isPolice = true
                        break
                    end
                end
                
                return isPolice and not isInHouse and not isInGarage and isOwned
            end
        })
        
        -- Join ongoing raid option
        table.insert(houseOptions, {
            name = 'join_raid_' .. houseId,
            serverEvent = 'housing:joinRaid',
            serverEventData = houseId,
            icon = 'fas fa-shield-alt',
            label = '🚨 Join Raid',
            canInteract = function()
                local playerData = ESX.GetPlayerData()
                local isPolice = false
                
                for _, job in ipairs(Config.PoliceJobs) do
                    if playerData.job and playerData.job.name == job then
                        isPolice = true
                        break
                    end
                end
                
                return isPolice and not isInHouse and not isInGarage and isRaidActive
            end
        })
        
        -- Create house entrance zone
        exports.ox_target:addBoxZone({
            coords = houseData.coords,
            size = vec3(2, 2, 2),
            rotation = 0,
            debug = false,
            options = houseOptions
        })
        
        -- Garage entrance zone (only for owned houses)
        if isOwnedByPlayer then
            local garageOptions = {
                {
                    name = 'enter_garage_' .. houseId,
                    icon = 'fas fa-warehouse',
                    label = 'Enter Garage',
                    canInteract = function()
                        return not isInHouse and not isInGarage
                    end,
                    onSelect = function()
                        local ped = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        
                        if vehicle ~= 0 then
                            -- Player is in vehicle, teleport with vehicle
                            TriggerServerEvent('housing:enterGarage', houseId)
                        else
                            -- Player on foot, just enter garage
                            TriggerServerEvent('housing:enterGarage', houseId)
                        end
                    end
                }
            }
            
            exports.ox_target:addBoxZone({
                coords = houseData.garage_coords,
                size = vec3(3, 3, 2),
                rotation = 0,
                debug = false,
                options = garageOptions
            })
        end
    end
end

-- Enter house event
RegisterNetEvent('housing:enterHouse', function(houseId, houseType)
    local playerPed = PlayerPedId()
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    local interior = Config.HouseTypes[houseType].interior
    SetEntityCoords(playerPed, interior.coords.x, interior.coords.y, interior.coords.z)
    SetEntityHeading(playerPed, interior.coords.w)
    
    DoScreenFadeIn(1000)
    
    isInHouse = true
    currentHouseId = houseId
    currentHouseType = houseType
    
    setupInteriorZones()
end)

-- Exit house event
RegisterNetEvent('housing:exitHouse', function()
    local playerPed = PlayerPedId()
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    -- Return to house entrance
    if currentHouseId and Config.Houses[currentHouseId] then
        local houseCoords = Config.Houses[currentHouseId].coords
        SetEntityCoords(playerPed, houseCoords.x, houseCoords.y, houseCoords.z)
    end
    
    DoScreenFadeIn(1000)
    
    isInHouse = false
    currentHouseId = nil
    currentHouseType = nil
    
    removeInteriorZones()
end)

-- Enter garage event
RegisterNetEvent('housing:enterGarage', function(houseId, houseType)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    local garage = Config.HouseTypes[houseType].garage
    
    if vehicle ~= 0 then
        -- Teleport with vehicle
        SetEntityCoords(vehicle, garage.interior.x, garage.interior.y, garage.interior.z)
        SetEntityHeading(vehicle, garage.interior.w)
    else
        -- Teleport player only
        SetEntityCoords(playerPed, garage.interior.x, garage.interior.y, garage.interior.z)
        SetEntityHeading(playerPed, garage.interior.w)
    end
    
    DoScreenFadeIn(1000)
    
    isInGarage = true
    currentHouseId = houseId
    currentHouseType = houseType
    
    setupGarageZones()
end)

-- Exit garage event
RegisterNetEvent('housing:exitGarage', function()
    local playerPed = PlayerPedId()
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    -- Return to garage entrance
    if currentHouseId and Config.Houses[currentHouseId] then
        local garageCoords = Config.Houses[currentHouseId].garage_coords
        SetEntityCoords(playerPed, garageCoords.x, garageCoords.y, garageCoords.z)
    end
    
    DoScreenFadeIn(1000)
    
    isInGarage = false
    currentHouseId = nil
    currentHouseType = nil
    
    removeGarageZones()
end)

-- Setup interior interaction zones
function setupInteriorZones()
    if not currentHouseType then return end
    
    local interior = Config.HouseTypes[currentHouseType].interior
    
    -- Exit zone
    exports.ox_target:addBoxZone({
        coords = interior.exit,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'exit_house',
                serverEvent = 'housing:exitHouse',
                icon = 'fas fa-door-closed',
                label = 'Exit House',
                canInteract = function()
                    return isInHouse
                end
            }
        }
    })
    
    -- Stash zone
    exports.ox_target:addBoxZone({
        coords = interior.stash,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'open_house_stash',
                event = 'housing:openStash',
                icon = 'fas fa-box',
                label = 'Open Storage',
                canInteract = function()
                    return isInHouse and currentHouseId ~= nil
                end
            }
        }
    })
    
    -- Garage entry zone (from inside house)
    exports.ox_target:addBoxZone({
        coords = interior.garage_entry,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'enter_garage_from_house',
                serverEvent = 'housing:enterGarage',
                serverEventData = currentHouseId,
                icon = 'fas fa-warehouse',
                label = 'Enter Garage',
                canInteract = function()
                    return isInHouse
                end
            }
        }
    })
end

-- Setup garage interaction zones
function setupGarageZones()
    if not currentHouseType then return end
    
    local garage = Config.HouseTypes[currentHouseType].garage
    
    -- Exit zone
    exports.ox_target:addBoxZone({
        coords = garage.exit,
        size = vec3(2, 2, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'exit_garage',
                serverEvent = 'housing:exitGarage',
                icon = 'fas fa-door-closed',
                label = 'Exit Garage',
                canInteract = function()
                    return isInGarage
                end
            }
        }
    })
    
    -- Vehicle management zone
    exports.ox_target:addBoxZone({
        coords = vector3(garage.interior.x + 5, garage.interior.y, garage.interior.z),
        size = vec3(2, 2, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'store_vehicle',
                serverEvent = 'housing:storeVehicle',
                serverEventData = currentHouseId,
                icon = 'fas fa-parking',
                label = 'Store Vehicle',
                canInteract = function()
                    local ped = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    return isInGarage and vehicle ~= 0
                end
            },
            {
                name = 'manage_vehicles',
                event = 'housing:openGarageMenu',
                icon = 'fas fa-car',
                label = 'Manage Vehicles',
                canInteract = function()
                    return isInGarage
                end
            }
        }
    })
end

-- Remove interior zones
function removeInteriorZones()
    pcall(function()
        exports.ox_target:removeZone('exit_house')
        exports.ox_target:removeZone('open_house_stash')
        exports.ox_target:removeZone('enter_garage_from_house')
    end)
end

-- Remove garage zones
function removeGarageZones()
    pcall(function()
        exports.ox_target:removeZone('exit_garage')
        exports.ox_target:removeZone('store_vehicle')
        exports.ox_target:removeZone('manage_vehicles')
    end)
end

-- Open house stash
RegisterNetEvent('housing:openStash', function()
    if currentHouseId then
        exports.ox_inventory:openInventory('stash', {id = 'house_' .. currentHouseId})
    end
end)

-- Store vehicle event
RegisterNetEvent('housing:storeVehicle', function(houseId)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        ESX.ShowNotification('You must be in a vehicle to store it!')
        return
    end
    
    -- Get vehicle data
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    local props = ESX.Game.GetVehicleProperties(vehicle)
    
    -- Delete the vehicle
    TaskLeaveVehicle(ped, vehicle, 0)
    Wait(2000)
    ESX.Game.DeleteVehicle(vehicle)
    
    -- Send data to server
    TriggerServerEvent('housing:saveVehicleToGarage', houseId, {
        plate = plate,
        model = model,
        props = props
    })
end)

-- Open garage management menu
RegisterNetEvent('housing:openGarageMenu', function()
    if not currentHouseId then return end
    
    ESX.TriggerServerCallback('housing:getGarageVehicles', function(vehicles)
        local elements = {}
        
        if #vehicles == 0 then
            table.insert(elements, {
                title = 'No vehicles stored',
                icon = 'fas fa-info-circle'
            })
        else
            for _, vehicle in ipairs(vehicles) do
                local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))
                if vehicleName == 'NULL' then
                    vehicleName = GetDisplayNameFromVehicleModel(vehicle.model)
                end
                
                table.insert(elements, {
                    title = vehicleName .. ' (' .. vehicle.plate .. ')',
                    description = 'Slot ' .. vehicle.slot,
                    icon = 'fas fa-car',
                    onSelect = function()
                        TriggerServerEvent('housing:getVehicle', currentHouseId, vehicle.id)
                    end
                })
            end
        end
        
        lib.registerContext({
            id = 'garage_menu',
            title = 'Garage Management',
            options = elements
        })
        lib.showContext('garage_menu')
    end, currentHouseId)
end)

-- Spawn vehicle event
RegisterNetEvent('housing:spawnVehicle', function(model, props, plate)
    if not isInGarage or not currentHouseType then return end
    
    local garage = Config.HouseTypes[currentHouseType].garage
    local spawnCoords = garage.spawn_slots[1] -- Use first slot for spawning
    
    ESX.Game.SpawnVehicle(model, spawnCoords, spawnCoords.w, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, props)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end)

-- Police Raid Events
RegisterNetEvent('housing:raidStarted', function(houseId)
    isRaidActive = true
    ESX.ShowNotification('🚨 RAID ACTIVE: House ' .. houseId .. ' - Evidence collection enabled')
    
    -- Show raid timer
    CreateThread(function()
        local raidTime = Config.RaidSettings.RaidDuration
        while isRaidActive and raidTime > 0 do
            Wait(1000)
            raidTime = raidTime - 1
            
            -- Show countdown every 30 seconds
            if raidTime % 30 == 0 then
                ESX.ShowNotification('🚨 Raid time remaining: ' .. math.floor(raidTime/60) .. ' minutes')
            end
        end
    end)
end)

RegisterNetEvent('housing:raidEnded', function(houseId)
    isRaidActive = false
    ESX.ShowNotification('🚨 Raid completed on House ' .. houseId)
end)

RegisterNetEvent('housing:houseRaided', function(houseId)
    ESX.ShowNotification('🚨 ALERT: Your house is being raided by police!')
    
    -- Flash screen red to indicate raid
    CreateThread(function()
        for i = 1, 3 do
            SetTimecycleModifier('REDMIST_blend')
            Wait(500)
            ClearTimecycleModifier()
            Wait(500)
        end
    end)
end)

-- Doorbell Events
RegisterNetEvent('housing:doorbellRang', function(data)
    pendingDoorbellData = data
    
    -- Show doorbell notification with response options
    lib.registerContext({
        id = 'doorbell_response',
        title = '🔔 Someone\'s at the door!',
        options = {
            {
                title = data.visitorName .. ' is at your door',
                description = 'Choose your response',
                icon = 'fas fa-user'
            },
            {
                title = 'Invite Inside',
                description = 'Allow visitor to enter your house',
                icon = 'fas fa-door-open',
                onSelect = function()
                    TriggerServerEvent('housing:answerDoorbell', data.houseId, data.visitorId, 'invite')
                    pendingDoorbellData = nil
                end
            },
            {
                title = 'Decline Visit',
                description = 'Politely decline the visit',
                icon = 'fas fa-times',
                onSelect = function()
                    TriggerServerEvent('housing:answerDoorbell', data.houseId, data.visitorId, 'decline')
                    pendingDoorbellData = nil
                end
            },
            {
                title = 'Ignore',
                description = 'Don\'t respond to the doorbell',
                icon = 'fas fa-volume-mute',
                onSelect = function()
                    pendingDoorbellData = nil
                end
            }
        }
    })
    lib.showContext('doorbell_response')
end)

RegisterNetEvent('housing:playDoorbellSound', function(houseId)
    -- Play doorbell sound effect
    PlaySoundFrontend(-1, 'DOOR_BUZZ', 'MP_PLAYER_APARTMENT', 1)
end)

RegisterNetEvent('housing:invitedInside', function(houseId)
    ESX.ShowNotification('You\'ve been invited inside! You can now enter the house.')
    
    -- Temporarily allow entry for 30 seconds
    CreateThread(function()
        local canEnter = true
        SetTimeout(30000, function()
            canEnter = false
            ESX.ShowNotification('House invitation expired')
        end)
        
        -- Update house zones to allow temporary entry
        -- This would require modifying the house entrance zone dynamically
    end)
end)

-- View Doorbell History
RegisterNetEvent('housing:viewDoorbellHistory', function(houseId)
    ESX.TriggerServerCallback('housing:getDoorbellHistory', function(history)
        local elements = {}
        
        if #history == 0 then
            table.insert(elements, {
                title = 'No doorbell history',
                description = 'Nobody has rung your doorbell yet',
                icon = 'fas fa-info-circle'
            })
        else
            for _, entry in ipairs(history) do
                local timeStr = os.date('%m/%d %H:%M', entry.time)
                local statusIcon = 'fas fa-clock'
                local statusText = 'No response'
                
                if entry.answered then
                    if entry.response == 'invite' then
                        statusIcon = 'fas fa-check-circle'
                        statusText = 'Invited inside'
                    elseif entry.response == 'decline' then
                        statusIcon = 'fas fa-times-circle'
                        statusText = 'Declined'
                    end
                elseif entry.response == 'offline' then
                    statusIcon = 'fas fa-moon'
                    statusText = 'You were offline'
                end
                
                table.insert(elements, {
                    title = entry.visitor_name,
                    description = timeStr .. ' - ' .. statusText,
                    icon = statusIcon
                })
            end
        end
        
        lib.registerContext({
            id = 'doorbell_history',
            title = '🔔 Doorbell History - House ' .. houseId,
            options = elements
        })
        lib.showContext('doorbell_history')
    end, houseId)
end)

-- Evidence confiscation during raids (for police)
RegisterNetEvent('housing:confiscateEvidence', function()
    if not isRaidActive then
        ESX.ShowNotification('No active raid!')
        return
    end
    
    local playerData = ESX.GetPlayerData()
    local isPolice = false
    
    for _, job in ipairs(Config.PoliceJobs) do
        if playerData.job and playerData.job.name == job then
            isPolice = true
            break
        end
    end
    
    if not isPolice then
        ESX.ShowNotification('Access denied!')
        return
    end
    
    -- Open inventory to confiscate items
    -- This would integrate with your stash system to show contraband
    ESX.ShowNotification('Search for evidence in the house storage')
end)

-- Enhanced interior zones with raid detection
function setupInteriorZones()
    if not currentHouseType then return end
    
    local interior = Config.HouseTypes[currentHouseType].interior
    
    -- Exit zone
    exports.ox_target:addBoxZone({
        coords = interior.exit,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'exit_house',
                serverEvent = 'housing:exitHouse',
                icon = 'fas fa-door-closed',
                label = 'Exit House',
                canInteract = function()
                    return isInHouse
                end
            }
        }
    })
    
    -- Stash zone with raid protection
    exports.ox_target:addBoxZone({
        coords = interior.stash,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'open_house_stash',
                event = 'housing:openStash',
                icon = 'fas fa-box',
                label = 'Open Storage',
                canInteract = function()
                    return isInHouse and currentHouseId ~= nil
                end
            },
            {
                name = 'confiscate_evidence',
                event = 'housing:confiscateEvidence',
                icon = 'fas fa-search',
                label = '🚨 Search for Evidence',
                canInteract = function()
                    local playerData = ESX.GetPlayerData()
                    local isPolice = false
                    
                    for _, job in ipairs(Config.PoliceJobs) do
                        if playerData.job and playerData.job.name == job then
                            isPolice = true
                            break
                        end
                    end
                    
                    return isPolice and isRaidActive and isInHouse
                end
            }
        }
    })
    
    -- Garage entry zone (from inside house)
    exports.ox_target:addBoxZone({
        coords = interior.garage_entry,
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'enter_garage_from_house',
                serverEvent = 'housing:enterGarage',
                serverEventData = currentHouseId,
                icon = 'fas fa-warehouse',
                label = 'Enter Garage',
                canInteract = function()
                    return isInHouse
                end
            }
        }
    })
    
    -- Decoration shop zone (near stash)
    exports.ox_target:addBoxZone({
        coords = vector3(interior.stash.x + 2, interior.stash.y, interior.stash.z),
        size = vec3(1.5, 1.5, 1),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'decoration_shop',
                event = 'housing:openDecorationShop',
                icon = 'fas fa-shopping-cart',
                label = '🛒 Decoration Shop',
                canInteract = function()
                    return isInHouse and currentHouseId ~= nil and not isPlacingDecoration
                end
            },
            {
                name = 'decoration_manager',
                event = 'housing:openDecorationManager',
                icon = 'fas fa-cog',
                label = '🔧 Manage Decorations',
                canInteract = function()
                    return isInHouse and currentHouseId ~= nil and not isPlacingDecoration
                end
            }
        }
    })
    
    -- Load house decorations when entering
    loadHouseDecorations()
end

-- Decoration System Functions

-- Load house decorations
function loadHouseDecorations()
    if not currentHouseId then return end
    
    -- Clear existing decorations
    for _, decoration in pairs(currentDecorations) do
        if DoesEntityExist(decoration.entity) then
            DeleteEntity(decoration.entity)
        end
    end
    currentDecorations = {}
    
    -- Load decorations from server
    ESX.TriggerServerCallback('housing:getHouseDecorations', function(decorations)
        for _, decoration in ipairs(decorations) do
            spawnDecoration(decoration)
        end
    end, currentHouseId)
end

-- Spawn decoration entity
function spawnDecoration(decorationData)
    local model = GetHashKey(decorationData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    
    local entity = CreateObject(model, decorationData.coords.x, decorationData.coords.y, decorationData.coords.z, false, false, false)
    SetEntityRotation(entity, decorationData.rotation.x, decorationData.rotation.y, decorationData.rotation.z, 2, true)
    FreezeEntityPosition(entity, true)
    
    -- Add to current decorations
    currentDecorations[decorationData.id] = {
        entity = entity,
        data = decorationData
    }
    
    -- Add interaction for decoration management
    exports.ox_target:addLocalEntity(entity, {
        {
            name = 'manage_decoration_' .. decorationData.id,
            icon = 'fas fa-cog',
            label = 'Manage Decoration',
            canInteract = function()
                return isInHouse and not isPlacingDecoration
            end,
            onSelect = function()
                openDecorationMenu(decorationData)
            end
        }
    })
    
    SetModelAsNoLongerNeeded(model)
end

-- Open decoration shop
RegisterNetEvent('housing:openDecorationShop', function()
    ESX.TriggerServerCallback('housing:getDecorationShop', function(shop)
        local elements = {}
        
        for _, category in ipairs(shop) do
            table.insert(elements, {
                title = '📂 ' .. category.category,
                description = 'Browse ' .. category.category:lower() .. ' items',
                icon = 'fas fa-folder',
                arrow = true,
                onSelect = function()
                    openCategoryMenu(category)
                end
            })
        end
        
        lib.registerContext({
            id = 'decoration_shop',
            title = '🛒 Decoration Shop',
            options = elements
        })
        lib.showContext('decoration_shop')
    end)
end)

-- Open category menu
function openCategoryMenu(category)
    local elements = {}
    
    for _, item in ipairs(category.items) do
        table.insert(elements, {
            title = item.name,
            description = item.description .. ' - $' .. item.price,
            icon = 'fas fa-shopping-cart',
            onSelect = function()
                -- Start placement mode
                startDecorationPlacement(item)
            end
        })
    end
    
    lib.registerContext({
        id = 'decoration_category',
        title = '📂 ' .. category.category,
        menu = 'decoration_shop',
        options = elements
    })
    lib.showContext('decoration_category')
end

-- Start decoration placement with gizmo
function startDecorationPlacement(itemData)
    if isPlacingDecoration then return end
    
    isPlacingDecoration = true
    decorationRotation = 0.0
    
    -- Load model
    local model = GetHashKey(itemData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    
    -- Create preview entity
    local playerCoords = GetEntityCoords(PlayerPedId())
    placementPreview = CreateObject(model, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false)
    SetEntityAlpha(placementPreview, 150, false)
    SetEntityCollision(placementPreview, false, false)
    
    -- Show placement instructions
    ESX.ShowNotification('Decoration Placement:\n• Mouse: Move position\n• Q/E: Rotate\n• Enter: Place\n• X: Cancel')
    
    -- Start placement thread
    CreateThread(function()
        while isPlacingDecoration do
            Wait(0)
            
            -- Get raycast hit
            local hit, coords, normal = screenToWorld()
            
            if hit then
                -- Update preview position
                if Config.DecorationSettings.SnapToGround then
                    coords = vector3(coords.x, coords.y, coords.z)
                end
                
                SetEntityCoords(placementPreview, coords.x, coords.y, coords.z, false, false, false, false)
                SetEntityRotation(placementPreview, 0.0, 0.0, decorationRotation, 2, true)
                
                -- Draw placement info
                DrawText3D(coords.x, coords.y, coords.z + 1.0, 'Press ~g~ENTER~w~ to place\nPress ~r~X~w~ to cancel')
            end
            
            -- Handle input
            if IsControlJustPressed(0, 191) then -- ENTER
                finalizePlacement(itemData, coords)
                break
            elseif IsControlJustPressed(0, 73) then -- X
                cancelPlacement()
                break
            elseif IsControlPressed(0, 44) then -- Q
                decorationRotation = decorationRotation - 2.0
                if decorationRotation < 0 then decorationRotation = 360.0 end
            elseif IsControlPressed(0, 38) then -- E
                decorationRotation = decorationRotation + 2.0
                if decorationRotation > 360 then decorationRotation = 0.0 end
            end
        end
    end)
end

-- Finalize decoration placement
function finalizePlacement(itemData, coords)
    if not coords then
        ESX.ShowNotification('Invalid placement location!')
        cancelPlacement()
        return
    end
    
    -- Check distance from player
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - coords)
    
    if distance > Config.DecorationSettings.PlacementRange then
        ESX.ShowNotification('Too far from placement location!')
        cancelPlacement()
        return
    end
    
    local decorationData = {
        model = itemData.model,
        name = itemData.name,
        coords = coords,
        rotation = vector3(0.0, 0.0, decorationRotation)
    }
    
    -- Send to server for purchase and placement
    TriggerServerEvent('housing:placeDecoration', currentHouseId, decorationData)
    
    -- Clean up
    cancelPlacement()
end

-- Cancel decoration placement
function cancelPlacement()
    isPlacingDecoration = false
    
    if placementPreview and DoesEntityExist(placementPreview) then
        DeleteEntity(placementPreview)
        placementPreview = nil
    end
    
    ESX.ShowNotification('Placement cancelled')
end

-- Screen to world raycast
function screenToWorld()
    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(0)
    local camForward = RotationToDirection(camRot)
    local destination = camCoord + (camForward * 10.0)
    
    local ray = StartExpensiveSynchronousShapeTestLosProbe(camCoord, destination, -1, PlayerPedId(), 0)
    local _, hit, coords, _, entity = GetShapeTestResult(ray)
    
    return hit == 1, coords, entity
end

-- Convert rotation to direction
function RotationToDirection(rotation)
    local adjustedRotation = vector3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    local direction = vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

-- Draw 3D text
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Open decoration manager
RegisterNetEvent('housing:openDecorationManager', function()
    ESX.TriggerServerCallback('housing:getHouseDecorations', function(decorations)
        local elements = {}
        
        if #decorations == 0 then
            table.insert(elements, {
                title = 'No decorations placed',
                description = 'Visit the decoration shop to buy items',
                icon = 'fas fa-info-circle'
            })
        else
            for _, decoration in ipairs(decorations) do
                table.insert(elements, {
                    title = decoration.name,
                    description = 'Model: ' .. decoration.model,
                    icon = 'fas fa-cube',
                    onSelect = function()
                        openDecorationMenu(decoration)
                    end
                })
            end
        end
        
        lib.registerContext({
            id = 'decoration_manager',
            title = '🔧 Decoration Manager',
            options = elements
        })
        lib.showContext('decoration_manager')
    end, currentHouseId)
end)

-- Open individual decoration menu
function openDecorationMenu(decoration)
    lib.registerContext({
        id = 'decoration_menu',
        title = decoration.name,
        menu = 'decoration_manager',
        options = {
            {
                title = 'Remove Decoration',
                description = 'Permanently delete this decoration',
                icon = 'fas fa-trash',
                onSelect = function()
                    TriggerServerEvent('housing:removeDecoration', currentHouseId, decoration.id)
                end
            }
        }
    })
    lib.showContext('decoration_menu')
end

-- Server events for decoration management
RegisterNetEvent('housing:spawnDecoration', function(houseId, decorationData)
    if currentHouseId == houseId and isInHouse then
        spawnDecoration(decorationData)
    end
end)

RegisterNetEvent('housing:removeDecorationObject', function(houseId, decorationId)
    if currentHouseId == houseId then
        if currentDecorations[decorationId] then
            if DoesEntityExist(currentDecorations[decorationId].entity) then
                DeleteEntity(currentDecorations[decorationId].entity)
            end
            currentDecorations[decorationId] = nil
        end
    end
end)

-- Clean up decorations when leaving house
RegisterNetEvent('housing:exitHouse', function()
    local playerPed = PlayerPedId()
    
    DoScreenFadeOut(1000)
    Wait(1000)
    
    -- Clean up decorations
    for _, decoration in pairs(currentDecorations) do
        if DoesEntityExist(decoration.entity) then
            DeleteEntity(decoration.entity)
        end
    end
    currentDecorations = {}
    
    -- Cancel any active placement
    if isPlacingDecoration then
        cancelPlacement()
    end
    
    -- Return to house entrance
    if currentHouseId and Config.Houses[currentHouseId] then
        local houseCoords = Config.Houses[currentHouseId].coords
        SetEntityCoords(playerPed, houseCoords.x, houseCoords.y, houseCoords.z)
    end
    
    DoScreenFadeIn(1000)
    
    isInHouse = false
    currentHouseId = nil
    currentHouseType = nil
    
    removeInteriorZones()
end)

-- Refresh zones when player loads
AddEventHandler('esx:playerLoaded', function()
    CreateThread(function()
        Wait(2000)
        ESX.TriggerServerCallback('housing:getHouseData', function(data)
            houseOwnership = data
            setupHouseZones()
        end)
    end)
end)
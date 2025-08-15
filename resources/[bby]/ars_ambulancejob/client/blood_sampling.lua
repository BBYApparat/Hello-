local function hasRequiredItems()
    local syringe = exports.ox_inventory:Search("count", "syringe")
    local tube = exports.ox_inventory:Search("count", "test_tube")
    
    return syringe > 0 and tube > 0
end

local function getPlayerBloodType(playerId)
    -- Generate random blood type or get from player data
    local bloodTypes = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"}
    return bloodTypes[math.random(1, #bloodTypes)]
end

local function sampleBlood(targetId)
    local targetPed = GetPlayerPed(targetId)
    local playerPed = cache.ped or PlayerPedId()
    local targetCoords = GetEntityCoords(targetPed)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - targetCoords)
    
    if distance > 3.0 then
        utils.showNotification("target_too_far")
        return
    end
    
    if not hasRequiredItems() then
        utils.showNotification("need_syringe_tube")
        return
    end
    
    -- Check cooldown
    local canSample, remainingTime = lib.callback.await('ars_ambulancejob:checkBloodSamplingCooldown', false, targetId)
    if not canSample then
        local minutes = math.floor(remainingTime / 60)
        local seconds = remainingTime % 60
        utils.showNotification("blood_sampling_cooldown", { minutes = minutes, seconds = seconds })
        return
    end
    
    -- Get target player name
    local targetName = GetPlayerName(targetId)
    local bloodType = getPlayerBloodType(targetId)
    
    -- Start animation
    local dict = "anim@amb@medic@standing@timeofdeath@base"
    lib.requestAnimDict(dict)
    TaskPlayAnim(playerPed, dict, "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Progress bar
    if lib.progressBar({
        duration = 8000,
        label = locale("sampling_blood"),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = dict,
            clip = "base"
        }
    }) then
        -- 50% chance to fail finding a vein
        local veinFound = math.random(1, 100) <= 50
        
        if not veinFound then
            -- Failed to find vein - no items consumed, no cooldown, no effects
            utils.showNotification("vein_not_found")
            ClearPedTasks(playerPed)
            return -- Allow retry
        end
        
        -- Success! Set cooldown for target
        lib.callback.await('ars_ambulancejob:setBloodSamplingCooldown', false, targetId)
        
        -- Remove required items only on success
        utils.addRemoveItem("remove", "syringe", 1)
        utils.addRemoveItem("remove", "test_tube", 1)
        
        -- Add blood sample with metadata
        local metadata = {
            patient_name = targetName,
            blood_type = bloodType,
            sample_date = os.date("%Y-%m-%d %H:%M:%S"),
            sampled_by = GetPlayerName(PlayerId())
        }
        
        utils.addRemoveItem("add", "blood_sample", 1, metadata)
        
        utils.showNotification("blood_sample_taken", { name = targetName, type = bloodType })
        
        -- Apply effects to target only on successful sampling
        TriggerServerEvent('ars_ambulancejob:applyBloodSamplingEffects', targetId)
    else
        utils.showNotification("blood_sampling_cancelled")
    end
    
    ClearPedTasks(playerPed)
end

local function initBloodSampling()
    addGlobalPlayer({
        {
            label = locale("sample_blood"),
            icon = "fa-solid fa-syringe",
            groups = Config.EmsJobs,
            cn = function(entity, distance, coords, name, bone)
                return hasRequiredItems()
            end,
            fn = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                if targetId and targetId ~= GetPlayerServerId(PlayerId()) then
                    sampleBlood(targetId)
                end
            end
        }
    })
end

-- Handle fainting from blood sampling
RegisterNetEvent('ars_ambulancejob:faintFromBloodSampling', function()
    local playerPed = cache.ped or PlayerPedId()
    
    utils.showNotification("blood_sampling_faint")
    
    -- Screen effect
    DoScreenFadeOut(1000)
    Wait(1000)
    
    -- Apply unconsciousness animation
    local dict = "missarmenian2"
    local anim = "drunk_loop"
    lib.requestAnimDict(dict)
    
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 15000, 1, 0, false, false, false)
    
    DoScreenFadeIn(2000)
    
    -- Reduce health significantly
    local currentHealth = GetEntityHealth(playerPed)
    local newHealth = math.max(currentHealth - 50, 50) -- Don't kill them
    SetEntityHealth(playerPed, newHealth)
    
    Wait(15000) -- Faint for 15 seconds
    ClearPedTasks(playerPed)
    utils.showNotification("blood_sampling_recover")
end)

-- Handle health reduction from blood sampling
RegisterNetEvent('ars_ambulancejob:reduceHealthFromBloodSampling', function()
    local playerPed = cache.ped or PlayerPedId()
    local currentHealth = GetEntityHealth(playerPed)
    local newHealth = math.max(currentHealth - 15, 100) -- Small health reduction
    SetEntityHealth(playerPed, newHealth)
    
    utils.showNotification("blood_sampling_weakness")
end)

CreateThread(function()
    Wait(1000) -- Wait for other systems to initialize
    initBloodSampling()
end)
-- -- Config for large items and their associated props
-- local largeItems = {
--     -- Format: ["item_name"] = {prop = "prop_model", bone = boneIndex, offset = {x, y, z}, rotation = {x, y, z}, anim = {dict = "animDict", name = "animName"}}
--     ["tv"] = {
--         prop = "prop_tv_flat_01", 
--         bone = 57005, -- right hand
--         offset = {0.2, 0.0, 0.0}, 
--         rotation = {0.0, 0.0, 0.0},
--         anim = {dict = "anim@heists@box_carry@", name = "idle"}
--     },
--     ["microwave"] = {
--         prop = "prop_microwave_1", 
--         bone = 57005,
--         offset = {0.1, 0.0, 0.0}, 
--         rotation = {0.0, 0.0, 0.0},
--         anim = {dict = "anim@heists@box_carry@", name = "idle"}
--     },
--     ["speaker"] = {
--         prop = "prop_speaker_01", 
--         bone = 57005,
--         offset = {0.1, 0.0, 0.0}, 
--         rotation = {0.0, 0.0, 0.0},
--         anim = {dict = "anim@heists@box_carry@", name = "idle"}
--     },
--     ["safe"] = {
--         prop = "prop_ld_int_safe_01", 
--         bone = 57005,
--         offset = {0.1, 0.0, -0.1}, 
--         rotation = {0.0, 180.0, 0.0},
--         anim = {dict = "anim@heists@box_carry@", name = "idle"}
--     },
--     ["painting"] = {
--         prop = "hei_prop_heist_painting_franklin", 
--         bone = 57005,
--         offset = {0.1, 0.0, 0.0}, 
--         rotation = {0.0, 0.0, 0.0},
--         anim = {dict = "anim@heists@box_carry@", name = "idle"}
--     }
--     -- Add more items as needed
-- }

-- -- Variables to track the current state
-- local isCarryingProp = false
-- local currentProp = nil
-- local currentItem = nil
-- local lastInventory = {}
-- local normalWalkSpeed = 1.0
-- local normalRunSpeed = 1.0

-- -- Function to load animation dictionary
-- local function loadAnimDict(dict)
--     RequestAnimDict(dict)
--     while not HasAnimDictLoaded(dict) do
--         Wait(100)
--     end
-- end

-- -- Function to load model
-- local function loadModel(model)
--     if type(model) == 'string' then model = GetHashKey(model) end
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--         Wait(100)
--     end
-- end

-- -- Function to restrict player movement
-- local function restrictPlayerMovement(enable)
--     local playerPed = PlayerPedId()
    
--     if enable then
--         -- Store normal speeds
--         normalWalkSpeed = GetPedDesiredMoveBlendRatio(playerPed)
--         normalRunSpeed = GetPedDesiredMoveBlendRatio(playerPed)
        
--         -- Restrict movement speed (slow walk)
--         SetPedMoveRateOverride(playerPed, 0.6)
--         SetPedMaxMoveBlendRatio(playerPed, 0.6) -- Slow movement speed
--     else
--         -- Restore normal speeds
--         SetPedMoveRateOverride(playerPed, 1.0)
--         SetPedMaxMoveBlendRatio(playerPed, normalRunSpeed)
--     end
-- end

-- -- Function to attach a prop to the player
-- local function startCarryingProp(itemName)
--     if isCarryingProp then return end
    
--     local itemData = largeItems[itemName]
--     if not itemData then return end
    
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)
    
--     -- Load the model
--     loadModel(itemData.prop)
    
--     -- Create the prop
--     local propObject = CreateObject(GetHashKey(itemData.prop), playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
--     if not DoesEntityExist(propObject) then return end
    
--     -- Set collision and networking properties
--     SetEntityCollision(propObject, false, true)
--     NetworkRegisterEntityAsNetworked(propObject)
--     SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(propObject), true)
--     SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(propObject), true)
    
--     -- Attach the prop to the player
--     AttachEntityToEntity(
--         propObject, 
--         playerPed, 
--         GetPedBoneIndex(playerPed, itemData.bone), 
--         itemData.offset[1], itemData.offset[2], itemData.offset[3], 
--         itemData.rotation[1], itemData.rotation[2], itemData.rotation[3], 
--         true, true, false, true, 1, true
--     )
    
--     -- Play the carrying animation
--     loadAnimDict(itemData.anim.dict)
--     TaskPlayAnim(playerPed, itemData.anim.dict, itemData.anim.name, 8.0, 8.0, -1, 51, 0, false, false, false)
    
--     -- Restrict movement
--     restrictPlayerMovement(true)
    
--     -- Update state
--     isCarryingProp = true
--     currentProp = propObject
--     currentItem = itemName
    
--     print("Started carrying prop for item: " .. itemName)
-- end

-- -- Function to remove the prop from the player
-- local function stopCarryingProp()
--     if not isCarryingProp then return end
    
--     -- Delete the prop
--     if DoesEntityExist(currentProp) then
--         DeleteEntity(currentProp)
--     end
    
--     -- Clear animation
--     local playerPed = PlayerPedId()
--     ClearPedTasks(playerPed)
    
--     -- Restore movement
--     restrictPlayerMovement(false)
    
--     -- Update state
--     isCarryingProp = false
--     currentProp = nil
--     currentItem = nil
    
--     print("Stopped carrying prop")
-- end

-- -- Function to check inventory for large items
-- local function checkInventoryForLargeItems()
--     -- Get player inventory
--     local inventory = exports.ox_inventory:GetPlayerItems()
--     if not inventory then return end
    
--     -- Track what items we had before
--     local newInventory = {}
--     local foundLargeItem = false
--     local itemToCarry = nil
    
--     -- Check each item in inventory
--     for _, item in pairs(inventory) do
--         newInventory[item.name] = (newInventory[item.name] or 0) + item.count
        
--         -- Check if it's a large item
--         if largeItems[item.name] and not foundLargeItem then
--             foundLargeItem = true
--             itemToCarry = item.name
--         end
--     end
    
--     -- Update carrying state based on inventory
--     if foundLargeItem and not isCarryingProp then
--         startCarryingProp(itemToCarry)
--     elseif not foundLargeItem and isCarryingProp then
--         stopCarryingProp()
--     elseif foundLargeItem and isCarryingProp and currentItem ~= itemToCarry then
--         -- If carrying the wrong item, switch props
--         stopCarryingProp()
--         startCarryingProp(itemToCarry)
--     end
    
--     -- Update last inventory
--     lastInventory = newInventory
-- end

-- -- Check inventory on resource start
-- AddEventHandler('onClientResourceStart', function(resourceName)
--     if GetCurrentResourceName() ~= resourceName then return end
    
--     Wait(1000) -- Wait for inventory to be ready
--     checkInventoryForLargeItems()
-- end)

-- -- Register inventory state change event
-- RegisterNetEvent('ox_inventory:inventoryChanged', function()
--     checkInventoryForLargeItems()
-- end)

-- -- Main thread to handle forced carry and movement restrictions
-- CreateThread(function()
--     while true do
--         Wait(0)
        
--         if isCarryingProp then
--             local playerPed = PlayerPedId()
            
--             -- Force player to keep carrying animation
--             if not IsEntityPlayingAnim(playerPed, largeItems[currentItem].anim.dict, largeItems[currentItem].anim.name, 3) then
--                 TaskPlayAnim(playerPed, largeItems[currentItem].anim.dict, largeItems[currentItem].anim.name, 8.0, 8.0, -1, 51, 0, false, false, false)
--             end
            
--             -- Disable jumping
--             DisableControlAction(0, 22, true) -- Jump
--             DisableControlAction(0, 36, true) -- Input Crouch
            
--             -- Limit speed
--             if IsPedSprinting(playerPed) or IsPedRunning(playerPed) then
--                 SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
--           --      ESX.ShowNotification("You can't run while carrying a heavy item!")
--             end
--         end
--     end
-- end)

-- -- Periodically check inventory status
-- CreateThread(function()
--     while true do
--         Wait(5000)
--         checkInventoryForLargeItems()
--     end
-- end)

-- -- Handle resource stop
-- AddEventHandler('onResourceStop', function(resourceName)
--     if GetCurrentResourceName() ~= resourceName then return end
    
--     if isCarryingProp then
--         stopCarryingProp()
--     end
-- end)

-- print("Large item carrying system initialized")
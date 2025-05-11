-- local dropItems = {
--     -- Food & Drinks (no changes needed)
--     burger = `prop_cs_burger_01`,
--     water = `prop_ld_flow_bottle`,
--     bread = `prop_sandwich_01`,
--     apple = `ng_proc_food_aple1a`,
--     banana = `prop_fruit_basket`,
--     beer = `prop_beer_bottle`,
--     coffee = `p_amb_coffeecup_01`,
--     donut = `prop_donut_01`,
--     whiskey = `p_whiskey_bottle_s`,
--     taco = `prop_taco_01`,
--     soda = `prop_ecola_can`,
--     pizza = `prop_pizza_box_01`,
--     chocolate = `prop_choc_ego`,
--     energydrink = `prop_energy_drink`,
--     wine = `prop_wine_bot_01`,
    
--     -- Medical
--     medkit = `prop_ld_health_pack`,
--     bandage = `prop_rolled_sock_01`,
--     firstaid = `xm_prop_x17_bag_med_01a`,
--     painkillers = `prop_cs_pills`,
--     adrenaline = `prop_syringe_01`,
    
--     -- Valuables & Electronics
--     phone = `prop_npc_phone`,
--     money = `prop_cash_pile_01`,
--     radio = `prop_cs_hand_radio`,
--     watch = `p_watch_01`,
--     laptop = `prop_laptop_01a`,
--     camera = `prop_pap_camera_01`,
--     tablet = `prop_cs_tablet`,
--     goldbar = `prop_gold_bar`,
--     jewelry = `p_jewel_necklace_02`,
--     diamond = `prop_cs_beer_box`,
--     rolex = `p_watch_01_s`,
    
--     -- Tools
--     lockpick = `prop_tool_screwdvr01`,
--     crowbar = `prop_tool_crowbar`,
--     drill = `prop_tool_drill`,
--     hammer = `prop_tool_hammer`,
--     wrench = `prop_tool_adjspanner`,
--     toolbox = `prop_toolchest_01`,
--     weldingkit = `prop_weld_torch`,
--     binoculars = `prop_binoc_01`,
--     fishingrod = `prop_fishing_rod_01`,
    
--     -- Drugs
--     weed = `prop_weed_01`,
--     cigarette = `prop_cs_ciggy_01`,
--     cocaine = `prop_coke_block_01`,
--     meth = `prop_meth_bag_01`,
--     joint = `p_cs_joint_02`,
--     heroin = `prop_syringe_01`,
    
--     -- Pistols (changed to uppercase)
--     WEAPON_PISTOL = `w_pi_pistol`,
--     WEAPON_COMBATPISTOL = `w_pi_combatpistol`,
--     WEAPON_APPISTOL = `w_pi_appistol`,
--     WEAPON_PISTOL50 = `w_pi_pistol50`,
--     WEAPON_SNSPISTOL = `w_pi_sns_pistol`,
--     WEAPON_HEAVYPISTOL = `w_pi_heavypistol`,
--     WEAPON_VINTAGEPISTOL = `w_pi_vintage_pistol`,
--     WEAPON_REVOLVER = `w_pi_revolver`,
--     WEAPON_DOUBLEACTION = `w_pi_doubleaction`,
--     WEAPON_CERAMICPISTOL = `w_pi_ceramic_pistol`,
--     WEAPON_NAVYREVOLVER = `w_pi_revolver_naval`,
--     WEAPON_GADGETPISTOL = `w_pi_singleshot`,
--     WEAPON_STUNGUN = `w_pi_stungun`,
--     WEAPON_FLAREGUN = `w_pi_flaregun`,
    
--     -- SMGs (changed to uppercase)
--     WEAPON_MICROSMG = `w_sb_microsmg`,
--     WEAPON_SMG = `w_sb_smg`,
--     WEAPON_ASSAULTSMG = `w_sb_assaultsmg`,
--     WEAPON_COMBATPDW = `w_sb_pdw`,
--     WEAPON_MACHINEPISTOL = `w_sb_compactsmg`,
--     WEAPON_MINISMG = `w_sb_minismg`,
    
--     -- Shotguns (changed to uppercase)
--     WEAPON_PUMPSHOTGUN = `w_sg_pumpshotgun`,
--     WEAPON_SAWNOFFSHOTGUN = `w_sg_sawnoff`,
--     WEAPON_ASSAULTSHOTGUN = `w_sg_assaultshotgun`,
--     WEAPON_BULLPUPSHOTGUN = `w_sg_bullpupshotgun`,
--     WEAPON_MUSKET = `w_ar_musket`,
--     WEAPON_HEAVYSHOTGUN = `w_sg_heavyshotgun`,
--     WEAPON_DBSHOTGUN = `w_sg_doublebarrel`,
--     WEAPON_AUTOSHOTGUN = `w_sg_sweeper`,
    
--     -- Rifles (changed to uppercase)
--     WEAPON_ASSAULTRIFLE = `w_ar_assaultrifle`,
--     WEAPON_CARBINERIFLE = `w_ar_carbinerifle`,
--     WEAPON_ADVANCEDRIFLE = `w_ar_advancedrifle`,
--     WEAPON_SPECIALCARBINE = `w_ar_specialcarbine`,
--     WEAPON_BULLPUPRIFLE = `w_ar_bullpuprifle`,
--     WEAPON_COMPACTRIFLE = `w_ar_assaultrifle_smg`,
--     WEAPON_MILITARYRIFLE = `w_ar_heavyrifleh`,
    
--     -- Sniper Rifles (changed to uppercase)
--     WEAPON_SNIPERRIFLE = `w_sr_sniperrifle`,
--     WEAPON_HEAVYSNIPER = `w_sr_heavysniper`,
--     WEAPON_MARKSMANRIFLE = `w_sr_marksmanrifle`,
    
--     -- Heavy Weapons (changed to uppercase)
--     WEAPON_GRENADELAUNCHER = `w_lr_grenadelauncher`,
--     WEAPON_RPG = `w_lr_rpg`,
--     WEAPON_MINIGUN = `w_mg_minigun`,
--     WEAPON_FIREWORK = `w_lr_firework`,
--     WEAPON_RAILGUN = `w_ar_railgun`,
--     WEAPON_HOMINGLAUNCHER = `w_lr_homing`,
--     WEAPON_COMPACTLAUNCHER = `w_lr_compactgl`,
    
--     -- Melee Weapons (changed to uppercase)
--     WEAPON_KNIFE = `w_me_knife_01`,
--     WEAPON_NIGHTSTICK = `w_me_nightstick`,
--     WEAPON_HAMMER = `w_me_hammer`,
--     WEAPON_BAT = `w_me_bat`,
--     WEAPON_CROWBAR = `w_me_crowbar`,
--     WEAPON_GOLFCLUB = `w_me_golfclub`,
--     WEAPON_BOTTLE = `w_me_bottle`,
--     WEAPON_DAGGER = `w_me_dagger`,
--     WEAPON_HATCHET = `w_me_hatchet`,
--     WEAPON_KNUCKLE = `w_me_knuckle`,
--     WEAPON_MACHETE = `w_me_machete`,
--     WEAPON_FLASHLIGHT = `w_me_flashlight`,
--     WEAPON_SWITCHBLADE = `w_me_switchblade`,
--     WEAPON_POOLCUE = `w_me_poolcue`,
--     WEAPON_WRENCH = `w_me_wrench`,
--     WEAPON_BATTLEAXE = `w_me_battleaxe`,
    
--     -- Throwables (changed to uppercase)
--     WEAPON_GRENADE = `w_ex_grenade`,
--     WEAPON_BZGAS = `w_ex_grenadesmoke`,
--     WEAPON_MOLOTOV = `w_ex_molotov`,
--     WEAPON_STICKYBOMB = `w_ex_pe`,
--     WEAPON_PROXMINE = `w_ex_apmine`,
--     WEAPON_SNOWBALL = `w_ex_snowball`,
--     WEAPON_PIPEBOMB = `w_ex_pipebomb`,
--     WEAPON_BALL = `w_am_baseball`,
--     WEAPON_SMOKEGRENADE = `w_ex_grenadesmokeap`,
--     WEAPON_FLARE = `w_am_flare`,
-- }
-- -- Helper function to safely print tables
-- local function safePrint(label, obj)
--     if type(obj) ~= 'table' then
--         print(label .. ": " .. tostring(obj))
--         return
--     end
    
--     print(label .. " (table contents):")
--     for k, v in pairs(obj) do
--         if type(v) ~= 'table' then
--             print("  - " .. tostring(k) .. ": " .. tostring(v))
--         else
--             print("  - " .. tostring(k) .. ": [TABLE]")
--         end
--     end
-- end

-- -- Variables for auto-cleanup system
-- local cleanupInterval = 30000 -- 30 seconds
-- local lastCleanupTime = 0
-- local activeDrops = {}

-- -- Function to perform cleanup of all drops
-- local function cleanupAllDrops()
--     local currentTime = GetGameTimer()
    
--     -- Only run cleanup if enough time has passed
--     if currentTime - lastCleanupTime < cleanupInterval then
--         return
--     end
    
--     print("[CLEANUP] Starting automatic cleanup of all dropped items...")
    
--     -- Get all drop inventories
--     local dropInventories = exports.ox_inventory:GetInventoriesForType('drop')
--     local count = 0
    
--     if dropInventories then
--         for _, inventory in pairs(dropInventories) do
--             print("[CLEANUP] Removing drop: " .. inventory.id)
--             exports.ox_inventory:RemoveInventory('drop', inventory.id)
--             count = count + 1
--         end
--     end
    
--     print("[CLEANUP] Removed " .. count .. " drops from the ground")
--     lastCleanupTime = currentTime
--     activeDrops = {} -- Reset tracking of active drops
-- end

-- -- Thread to handle periodic cleanup
-- CreateThread(function()
--     while true do
--         Wait(5000) -- Check every 5 seconds
--         cleanupAllDrops()
--     end
-- end)

-- -- First hook to intercept regular drops
-- exports.ox_inventory:registerHook('swapItems', function(payload)
--     print("[DEBUG] swapItems hook triggered for source: " .. tostring(payload.source))
--     safePrint("[DEBUG] Payload fromInventory", payload.fromInventory)
--     safePrint("[DEBUG] Payload toInventory", payload.toInventory)
    
--     -- Check for both 'drop' and 'newdrop' to catch all drop actions
--     if payload.toInventory ~= 'drop' and payload.toInventory ~= 'newdrop' then
--         print("[DEBUG] Not a drop action, returning")
--         return
--     end
    
--     print("[DEBUG] Drop action detected!")
    
--     local item = payload.fromSlot
--     safePrint("[DEBUG] Item being dropped", item)
    
--     if not item then
--         print("[DEBUG] No item found in fromSlot")
--         return
--     end
    
--     print("[DEBUG] Item being dropped: " .. tostring(item.name) .. " x" .. tostring(payload.count))
    
--     -- Check if this is a supported item from our dropItems table
--     local prop = dropItems[item.name]
--     if not prop then
--         print("[DEBUG] Item not in dropItems list, returning")
--         return
--     end
    
--     local items = { { item.name, payload.count, item.metadata } }
    
--     -- Get player coords
--     local coords = GetEntityCoords(GetPlayerPed(payload.source))
--     print("[DEBUG] Drop coords: " .. tostring(coords))
    
--     -- Create custom drop
--     local dropId = exports.ox_inventory:CustomDrop(item.label, items, coords, 1, item.weight, nil, prop)
    
--     print("[DEBUG] Drop created with ID: " .. tostring(dropId))
--     if not dropId then 
--         print("[DEBUG] Failed to create drop")
--         return 
--     end
    
--     -- Track this drop for cleanup
--     table.insert(activeDrops, {
--         id = dropId,
--         createdAt = GetGameTimer()
--     })

--     -- Remove the item and open inventory
--     CreateThread(function()
--         print("[DEBUG] Removing item from player inventory")
--         local success = exports.ox_inventory:RemoveItem(payload.source, item.name, payload.count, nil, item.slot)
--         print("[DEBUG] RemoveItem success: " .. tostring(success))
        
--         Wait(100) -- Slightly longer wait to ensure removal completes
        
--         print("[DEBUG] Opening drop inventory for player")
--         exports.ox_inventory:forceOpenInventory(payload.source, 'drop', dropId)
--     end)

--     print("[DEBUG] Hook returning false to prevent default behavior")
--     return false
-- end)

-- -- Second hook to capture and override the createDrop function (to remove arrow)
-- exports.ox_inventory:registerHook('createDrop', function(payload)
--     print("[DEBUG] createDrop hook triggered")
--     safePrint("[DEBUG] createDrop payload", payload)
    
--     -- For items in our custom list, return false to prevent default arrow
--     local items = payload.items
--     if items and #items > 0 then
--         local firstItem = items[1]
--         if firstItem and dropItems[firstItem[1]] then
--             print("[DEBUG] Preventing default drop for item: " .. tostring(firstItem[1]))
--             return false
--         end
--     end
-- end)

-- -- Add command to manually trigger cleanup (optional)
-- RegisterCommand('cleandrops', function(source, args, rawCommand)
--     -- Only allow this command from the server console or admins
--     if source == 0 then -- Server console
--         cleanupAllDrops()
--     else
--         -- Check if player has admin permissions
--         -- This depends on your permission system
--         -- Example: if IsPlayerAceAllowed(source, "command.cleandrops") then
--         --     cleanupAllDrops()
--         -- end
--     end
-- end, false)

-- print("[SCRIPT] Custom drop system with 30-second auto-cleanup initialized!")
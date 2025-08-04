local selectedPlayer = nil
local playersData = {}

-- NativeUI Setup
local MenuPosition = {x = 1400, y = 400}
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Staff Menu", "~h~~b~Advanced Staff Management System", MenuPosition.x, MenuPosition.y)
_menuPool:Add(mainMenu)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function OpenStaffMenu()
    isMenuOpen = true
    
    -- Clear existing menu items
    mainMenu:Clear()
    
    ESX.TriggerServerCallback('staff_menu:getOnlinePlayers', function(players)
        playersData = players
        CreateMainMenuItems()
        mainMenu:Visible(true)
    end)
end

function CreateMainMenuItems()
    -- Player Management Submenu
    local playerMgmtSubmenu = _menuPool:AddSubMenu(mainMenu, "👤 Player Management", "Manage online players", MenuPosition.x, MenuPosition.y)
    CreatePlayerManagementMenu(playerMgmtSubmenu)
    
    -- Vehicle Management Submenu
    local vehicleMgmtSubmenu = _menuPool:AddSubMenu(mainMenu, "🚗 Vehicle Management", "Manage vehicles", MenuPosition.x, MenuPosition.y)
    CreateVehicleManagementMenu(vehicleMgmtSubmenu)
    
    -- Server Management Submenu (if has permission)
    if HasPermission('weather') then
        local serverMgmtSubmenu = _menuPool:AddSubMenu(mainMenu, "🌍 Server Management", "Server controls", MenuPosition.x, MenuPosition.y)
        CreateServerManagementMenu(serverMgmtSubmenu)
    end
    
    -- Utilities Submenu
    local utilitiesSubmenu = _menuPool:AddSubMenu(mainMenu, "⚙️ Utilities", "Staff utilities", MenuPosition.x, MenuPosition.y)
    CreateUtilitiesMenu(utilitiesSubmenu)
    
    -- Player Blips Toggle
    local blipsToggle = NativeUI.CreateItem("🗺️ Toggle Player Blips", blipsEnabled and "Currently ON" or "Currently OFF")
    blipsToggle.Activated = function(sender, item, index)
        TogglePlayerBlips()
        item:SetRightLabel(blipsEnabled and "Currently ON" or "Currently OFF")
        notify(blipsEnabled and "~g~Player blips enabled" or "~r~Player blips disabled")
    end
    mainMenu:AddItem(blipsToggle)
    
    _menuPool:RefreshIndex()
end

function CreatePlayerManagementMenu(submenu)
    for _, player in pairs(playersData) do
        local canSeePlayer = true
        
        -- Hide admin details from non-admins
        if not HasPermission('changegroup') and player.group and Config.StaffGroups[player.group] and Config.StaffGroups[player.group].level >= 3 then
            canSeePlayer = false
        end
        
        if canSeePlayer then
            local healthPercent = math.floor(((player.health or 200) / 200) * 100)
            local armorPercent = player.armor or 0
            
            local playerItem = NativeUI.CreateItem(
                player.name .. " | ID: " .. player.id,
                string.format("Health: %d%% | Armor: %d%% | Steam: %s", 
                    healthPercent, armorPercent, player.steamName or 'Unknown')
            )
            
            playerItem.Activated = function(sender, item, index)
                selectedPlayer = player
                OpenPlayerActionsMenu()
            end
            
            submenu:AddItem(playerItem)
        end
    end
end

function OpenPlayerActionsMenu()
    if not selectedPlayer then return end
    
    local actionsMenu = NativeUI.CreateMenu("Player Actions", "Actions for: " .. selectedPlayer.name, MenuPosition.x, MenuPosition.y)
    _menuPool:Add(actionsMenu)
    
    -- Basic actions
    if HasPermission('goto') then
        local gotoItem = NativeUI.CreateItem("📍 Teleport to Player", "")
        gotoItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:teleportToPlayer', selectedPlayer.id)
            actionsMenu:Visible(false)
            isMenuOpen = false
            notify("~g~Teleporting to player...")
        end
        actionsMenu:AddItem(gotoItem)
    end
    
    if HasPermission('bring') then
        local bringItem = NativeUI.CreateItem("📥 Bring Player", "")
        bringItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:bringPlayer', selectedPlayer.id)
            actionsMenu:Visible(false)
            isMenuOpen = false
            notify("~g~Bringing player...")
        end
        actionsMenu:AddItem(bringItem)
    end
    
    if HasPermission('spectate') then
        local spectateItem = NativeUI.CreateItem("👁️ Spectate Player", "")
        spectateItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:spectatePlayer', selectedPlayer.id)
            actionsMenu:Visible(false)
            isMenuOpen = false
            notify("~b~Spectating player...")
        end
        actionsMenu:AddItem(spectateItem)
    end
    
    -- Moderator+ actions
    if HasPermission('heal') then
        local healItem = NativeUI.CreateItem("❤️ Heal Player", "")
        healItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:healPlayer', selectedPlayer.id)
            notify("~g~Player healed!")
        end
        actionsMenu:AddItem(healItem)
    end
    
    if HasPermission('armor') then
        local armorItem = NativeUI.CreateItem("🛡️ Give Armor", "")
        armorItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:armorPlayer', selectedPlayer.id)
            notify("~b~Armor given!")
        end
        actionsMenu:AddItem(armorItem)
    end
    
    if HasPermission('revive') then
        local reviveItem = NativeUI.CreateItem("💊 Revive Player", "")
        reviveItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:revivePlayer', selectedPlayer.id)
            notify("~g~Player revived!")
        end
        actionsMenu:AddItem(reviveItem)
    end
    
    if HasPermission('freeze') then
        local freezeItem = NativeUI.CreateItem("🧊 Freeze/Unfreeze", "")
        freezeItem.Activated = function(sender, item, index)
            TriggerServerEvent('staff_menu:freezePlayer', selectedPlayer.id)
            notify("~y~Player freeze toggled!")
        end
        actionsMenu:AddItem(freezeItem)
    end
    
    if HasPermission('kick') then
        local kickItem = NativeUI.CreateItem("⚠️ Kick Player", "")
        kickItem.Activated = function(sender, item, index)
            local reason = KeyboardInput("Kick Reason", "Rule violation", 50)
            if reason then
                TriggerServerEvent('staff_menu:kickPlayer', selectedPlayer.id, reason)
                actionsMenu:Visible(false)
                isMenuOpen = false
                notify("~r~Player kicked!")
            end
        end
        actionsMenu:AddItem(kickItem)
    end
    
    if HasPermission('ban') then
        local banItem = NativeUI.CreateItem("🔨 Ban Player", "")
        banItem.Activated = function(sender, item, index)
            OpenBanMenu()
        end
        actionsMenu:AddItem(banItem)
    end
    
    if HasPermission('changegroup') then
        local changeGroupItem = NativeUI.CreateItem("🔧 Change Group", "")
        changeGroupItem.Activated = function(sender, item, index)
            OpenGroupChangeMenu()
        end
        actionsMenu:AddItem(changeGroupItem)
    end
    
    actionsMenu:Visible(true)
    _menuPool:RefreshIndex()
end

function CreateVehicleManagementMenu(submenu)
    if HasPermission('spawncar') then
        local spawnVehicleItem = NativeUI.CreateItem("🚗 Spawn Vehicle", "")
        spawnVehicleItem.Activated = function(sender, item, index)
            local model = KeyboardInput("Vehicle Model", "adder", 20)
            if model then
                TriggerServerEvent('staff_menu:spawnVehicle', model)
                notify("~g~Spawning vehicle: " .. model)
            end
        end
        submenu:AddItem(spawnVehicleItem)
    end
    
    local adminCarItem = NativeUI.CreateItem("🚗 Admin Car", "Give/Spawn admin vehicle")
    adminCarItem.Activated = function(sender, item, index)
        TriggerServerEvent('staff_menu:adminCar')
        notify("~b~Admin car spawned!")
    end
    submenu:AddItem(adminCarItem)
    
    if HasPermission('fixgarage') then
        local fixGarageItem = NativeUI.CreateItem("🔧 Fix Garage", "")
        fixGarageItem.Activated = function(sender, item, index)
            local plate = KeyboardInput("Vehicle Plate", "", 8)
            if plate then
                TriggerServerEvent('staff_menu:fixGarage', plate)
                notify("~g~Garage fixed for plate: " .. plate)
            end
        end
        submenu:AddItem(fixGarageItem)
    end
    
    local deleteVehicleItem = NativeUI.CreateItem("🗑️ Delete Vehicle", "Delete current vehicle")
    deleteVehicleItem.Activated = function(sender, item, index)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle and vehicle ~= 0 then
            TriggerServerEvent('staff_menu:deleteVehicle', VehToNet(vehicle))
            notify("~r~Vehicle deleted!")
        else
            notify("~r~You need to be in a vehicle!")
        end
    end
    submenu:AddItem(deleteVehicleItem)
end

function CreateServerManagementMenu(submenu)
    if HasPermission('weather') then
        local weatherSubmenu = _menuPool:AddSubMenu(submenu, "🌤️ Change Weather", "Weather options", MenuPosition.x, MenuPosition.y)
        
        for _, weather in pairs(Config.WeatherTypes) do
            local weatherItem = NativeUI.CreateItem(weather.label, "")
            weatherItem.Activated = function(sender, item, index)
                TriggerServerEvent('staff_menu:setWeather', weather.value)
                notify("~b~Weather changed to: " .. weather.label)
            end
            weatherSubmenu:AddItem(weatherItem)
        end
    end
    
    local timeItem = NativeUI.CreateItem("🕐 Set Time", "")
    timeItem.Activated = function(sender, item, index)
        local time = KeyboardInput("Set Time (0-23)", "12", 2)
        local hour = tonumber(time)
        if hour and hour >= 0 and hour <= 23 then
            TriggerServerEvent('staff_menu:setTime', hour)
            notify("~b~Time set to: " .. hour .. ":00")
        else
            notify("~r~Invalid time! Use 0-23")
        end
    end
    submenu:AddItem(timeItem)
end

function CreateUtilitiesMenu(submenu)
    local noclipItem = NativeUI.CreateItem("✈️ NoClip", noclipEnabled and "Currently ON" or "Currently OFF")
    noclipItem.Activated = function(sender, item, index)
        exports['staff_menu']:ToggleNoClip()
        item:SetRightLabel(noclipEnabled and "Currently ON" or "Currently OFF")
    end
    submenu:AddItem(noclipItem)
    
    if noclipEnabled then
        local disableNoclipItem = NativeUI.CreateItem("🚫 Force Disable NoClip", "")
        disableNoclipItem.Activated = function(sender, item, index)
            local ped = PlayerPedId()
            SetEntityInvincible(ped, false)
            SetEntityVisible(ped, true, false)
            SetEntityCollision(ped, true, true)
            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(PlayerId(), false)
            SetPedCanRagdoll(ped, true)
            SetEntityProofs(ped, false, false, false, false, false, false, false, false)
            noclipEnabled = false
            notify("~g~NoClip force disabled!")
        end
        submenu:AddItem(disableNoclipItem)
    end
    
    local healSelfItem = NativeUI.CreateItem("💊 Heal Self", "")
    healSelfItem.Activated = function(sender, item, index)
        SetEntityHealth(PlayerPedId(), 200)
        notify("~g~You have been healed!")
    end
    submenu:AddItem(healSelfItem)
    
    local armorSelfItem = NativeUI.CreateItem("🛡️ Armor Self", "")
    armorSelfItem.Activated = function(sender, item, index)
        SetPedArmour(PlayerPedId(), 100)
        notify("~b~Armor restored!")
    end
    submenu:AddItem(armorSelfItem)
    
    local invisibleItem = NativeUI.CreateItem("👻 Invisible", GetEntityAlpha(PlayerPedId()) < 255 and "Currently ON" or "Currently OFF")
    invisibleItem.Activated = function(sender, item, index)
        local ped = PlayerPedId()
        local alpha = GetEntityAlpha(ped)
        if alpha < 255 then
            SetEntityAlpha(ped, 255, false)
            notify("~g~Visibility restored!")
            item:SetRightLabel("Currently OFF")
        else
            SetEntityAlpha(ped, 0, false)
            notify("~r~You are now invisible!")
            item:SetRightLabel("Currently ON")
        end
    end
    submenu:AddItem(invisibleItem)
end

function OpenBanMenu()
    local banMenu = NativeUI.CreateMenu("Ban Player", "Select ban duration", MenuPosition.x, MenuPosition.y)
    _menuPool:Add(banMenu)
    
    local durations = {
        {label = '1 Hour', value = 1/24},
        {label = '6 Hours', value = 6/24},
        {label = '1 Day', value = 1},
        {label = '3 Days', value = 3},
        {label = '7 Days', value = 7},
        {label = '30 Days', value = 30}
    }
    
    if HasPermission('unban') then
        table.insert(durations, {label = 'Permanent', value = 0})
    end
    
    for _, duration in pairs(durations) do
        local durationItem = NativeUI.CreateItem(duration.label, "")
        durationItem.Activated = function(sender, item, index)
            local reason = KeyboardInput("Ban Reason", "Rule violation", 100)
            if reason then
                ESX.TriggerServerCallback('staff_menu:banPlayer', function(success, message)
                    if success then
                        notify('~g~' .. message)
                    else
                        notify('~r~' .. message)
                    end
                end, selectedPlayer.id, reason, duration.value)
                
                banMenu:Visible(false)
                isMenuOpen = false
            end
        end
        banMenu:AddItem(durationItem)
    end
    
    banMenu:Visible(true)
    _menuPool:RefreshIndex()
end

function OpenGroupChangeMenu()
    ESX.TriggerServerCallback('staff_menu:getStaffGroups', function(groups)
        local groupMenu = NativeUI.CreateMenu("Change Group", "Select new group", MenuPosition.x, MenuPosition.y)
        _menuPool:Add(groupMenu)
        
        for _, group in pairs(groups) do
            local groupItem = NativeUI.CreateItem(group.label .. ' (Level ' .. group.level .. ')', "")
            groupItem.Activated = function(sender, item, index)
                ESX.TriggerServerCallback('staff_menu:changePlayerGroup', function(success, message)
                    if success then
                        notify('~g~' .. message)
                    else
                        notify('~r~' .. message)
                    end
                end, selectedPlayer.id, group.value)
                
                groupMenu:Visible(false)
                isMenuOpen = false
            end
            groupMenu:AddItem(groupItem)
        end
        
        groupMenu:Visible(true)
        _menuPool:RefreshIndex()
    end)
end

-- Main menu processing thread
CreateThread(function()
    while true do
        Wait(0)
        _menuPool:ProcessMenus()
        
        if IsControlJustPressed(1, 167) and isStaff and not isMenuOpen then -- F6 key
            OpenStaffMenu()
        end
        
        -- Close menu with ESC or when not visible
        if isMenuOpen and (not mainMenu:Visible() or IsControlJustPressed(1, 177)) then
            isMenuOpen = false
            selectedPlayer = nil
        end
    end
end)

-- Refresh player data periodically
CreateThread(function()
    while true do
        Wait(5000) -- Update every 5 seconds
        if isMenuOpen then
            ESX.TriggerServerCallback('staff_menu:getOnlinePlayers', function(players)
                playersData = players
            end)
        end
    end
end)

_menuPool:RefreshIndex()
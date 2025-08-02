local selectedPlayer = nil
local playersData = {}

function OpenStaffMenu()
    isMenuOpen = true
    
    ESX.TriggerServerCallback('staff_menu:getOnlinePlayers', function(players)
        playersData = players
        CreateMainMenu()
    end)
end

function CreateMainMenu()
    local elements = {}
    
    -- Player Management
    table.insert(elements, {
        label = '👤 Player Management',
        value = 'player_management'
    })
    
    -- Vehicle Management  
    table.insert(elements, {
        label = '🚗 Vehicle Management',
        value = 'vehicle_management'
    })
    
    -- Server Management
    if HasPermission('weather') then
        table.insert(elements, {
            label = '🌍 Server Management', 
            value = 'server_management'
        })
    end
    
    -- Utilities
    table.insert(elements, {
        label = '⚙️ Utilities',
        value = 'utilities'
    })
    
    -- Player Blips Toggle
    table.insert(elements, {
        label = '🗺️ Toggle Player Blips (' .. (blipsEnabled and '~g~ON' or '~r~OFF') .. '~s~)',
        value = 'toggle_blips'
    })
    
    local groupLabel = Config.StaffGroups[playerGroup] and Config.StaffGroups[playerGroup].label or 'Staff'
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'staff_main_menu', {
        title = '🛡️ Staff Menu - ' .. groupLabel,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        
        if action == 'player_management' then
            OpenPlayerManagement()
        elseif action == 'vehicle_management' then
            OpenVehicleManagement()
        elseif action == 'server_management' then
            OpenServerManagement()
        elseif action == 'utilities' then
            OpenUtilities()
        elseif action == 'toggle_blips' then
            TogglePlayerBlips()
            menu.close()
            OpenStaffMenu() -- Refresh menu
        end
    end, function(data, menu)
        menu.close()
        isMenuOpen = false
    end)
end

function OpenPlayerManagement()
    local elements = {}
    
    for _, player in pairs(playersData) do
        local canSeePlayer = true
        
        -- Hide admin details from non-admins
        if not HasPermission('changegroup') and player.group and Config.StaffGroups[player.group] and Config.StaffGroups[player.group].level >= 3 then
            canSeePlayer = false
        end
        
        if canSeePlayer then
            local healthBar = CreateHealthBar(player.health or 200)
            local armorBar = CreateArmorBar(player.armor or 0)
            
            local label = string.format(
                '%s | ID: %s\n%s %s\nSteam: %s\nFood: %d%% | Water: %d%%',
                player.name,
                player.id,
                healthBar,
                armorBar,
                player.steamName or 'Unknown',
                player.food or 0,
                player.water or 0
            )
            
            table.insert(elements, {
                label = label,
                value = player.id,
                player = player
            })
        end
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_management', {
        title = '👤 Player Management',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        selectedPlayer = data.current.player
        OpenPlayerActions()
    end, function(data, menu)
        menu.close()
        OpenStaffMenu()
    end)
end

function OpenPlayerActions()
    if not selectedPlayer then return end
    
    local elements = {}
    
    -- Basic actions available to all staff
    if HasPermission('goto') then
        table.insert(elements, {
            label = '📍 Teleport to Player',
            value = 'goto'
        })
    end
    
    if HasPermission('bring') then
        table.insert(elements, {
            label = '📥 Bring Player',
            value = 'bring'
        })
    end
    
    -- Moderator+ actions
    if HasPermission('spectate') then
        table.insert(elements, {
            label = '👁️ Spectate Player',
            value = 'spectate'
        })
    end
    
    if HasPermission('heal') then
        table.insert(elements, {
            label = '❤️ Heal Player',
            value = 'heal'
        })
    end
    
    if HasPermission('armor') then
        table.insert(elements, {
            label = '🛡️ Give Armor',
            value = 'armor'
        })
    end
    
    if HasPermission('revive') then
        table.insert(elements, {
            label = '💊 Revive Player',
            value = 'revive'
        })
    end
    
    if HasPermission('freeze') then
        table.insert(elements, {
            label = '🧊 Freeze/Unfreeze',
            value = 'freeze'
        })
    end
    
    if HasPermission('kick') then
        table.insert(elements, {
            label = '⚠️ Kick Player',
            value = 'kick'
        })
    end
    
    if HasPermission('ban') then
        table.insert(elements, {
            label = '🔨 Ban Player',
            value = 'ban'
        })
    end
    
    if HasPermission('changegroup') then
        table.insert(elements, {
            label = '🔧 Change Group',
            value = 'changegroup'
        })
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_actions', {
        title = '👤 Actions: ' .. selectedPlayer.name,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        
        if action == 'goto' then
            TriggerServerEvent('staff_menu:teleportToPlayer', selectedPlayer.id)
            menu.close()
            isMenuOpen = false
        elseif action == 'bring' then
            TriggerServerEvent('staff_menu:bringPlayer', selectedPlayer.id)
            menu.close()
            isMenuOpen = false
        elseif action == 'heal' then
            TriggerServerEvent('staff_menu:healPlayer', selectedPlayer.id)
            ESX.ShowNotification('~g~Player healed!')
        elseif action == 'armor' then
            TriggerServerEvent('staff_menu:armorPlayer', selectedPlayer.id)
            ESX.ShowNotification('~b~Armor given!')
        elseif action == 'revive' then
            TriggerServerEvent('staff_menu:revivePlayer', selectedPlayer.id)
            ESX.ShowNotification('~g~Player revived!')
        elseif action == 'freeze' then
            TriggerServerEvent('staff_menu:freezePlayer', selectedPlayer.id)
            ESX.ShowNotification('~y~Player freeze toggled!')
        elseif action == 'spectate' then
            TriggerServerEvent('staff_menu:spectatePlayer', selectedPlayer.id)
            menu.close()
            isMenuOpen = false
        elseif action == 'kick' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kick_reason', {
                title = 'Kick Reason'
            }, function(data2, menu2)
                if data2.value then
                    TriggerServerEvent('staff_menu:kickPlayer', selectedPlayer.id, data2.value)
                    menu2.close()
                    menu.close()
                    isMenuOpen = false
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif action == 'ban' then
            OpenBanMenu()
        elseif action == 'changegroup' then
            OpenGroupChangeMenu()
        end
    end, function(data, menu)
        menu.close()
        OpenPlayerManagement()
    end)
end

function OpenVehicleManagement()
    local elements = {}
    
    if HasPermission('spawncar') then
        table.insert(elements, {
            label = '🚗 Spawn Vehicle',
            value = 'spawn_vehicle'
        })
    end
    
    table.insert(elements, {
        label = '🚗 Admin Car (Give Current/Spawn)',
        value = 'admin_car'
    })
    
    if HasPermission('fixgarage') then
        table.insert(elements, {
            label = '🔧 Fix Garage',
            value = 'fix_garage'
        })
    end
    
    table.insert(elements, {
        label = '🗑️ Delete Vehicle',
        value = 'delete_vehicle'
    })
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_management', {
        title = '🚗 Vehicle Management',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        
        if action == 'spawn_vehicle' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'spawn_vehicle', {
                title = 'Vehicle Model'
            }, function(data2, menu2)
                if data2.value then
                    TriggerServerEvent('staff_menu:spawnVehicle', data2.value)
                    menu2.close()
                    menu.close()
                    isMenuOpen = false
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif action == 'admin_car' then
            if selectedPlayer then
                TriggerServerEvent('staff_menu:adminCar', selectedPlayer.id)
            else
                TriggerServerEvent('staff_menu:adminCar')
            end
            menu.close()
            isMenuOpen = false
        elseif action == 'fix_garage' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fix_garage', {
                title = 'Vehicle Plate'
            }, function(data2, menu2)
                if data2.value then
                    TriggerServerEvent('staff_menu:fixGarage', data2.value)
                    menu2.close()
                    menu.close()
                    isMenuOpen = false
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif action == 'delete_vehicle' then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                TriggerServerEvent('staff_menu:deleteVehicle', VehToNet(vehicle))
                ESX.ShowNotification('~r~Vehicle deleted!')
            else
                ESX.ShowNotification('~r~You need to be in a vehicle!')
            end
        end
    end, function(data, menu)
        menu.close()
        OpenStaffMenu()
    end)
end

function OpenServerManagement()
    local elements = {}
    
    if HasPermission('weather') then
        table.insert(elements, {
            label = '🌤️ Change Weather',
            value = 'weather'
        })
    end
    
    table.insert(elements, {
        label = '🕐 Set Time',
        value = 'time'
    })
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'server_management', {
        title = '🌍 Server Management',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        
        if action == 'weather' then
            OpenWeatherMenu()
        elseif action == 'time' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_time', {
                title = 'Set Time (0-23)'
            }, function(data2, menu2)
                local hour = tonumber(data2.value)
                if hour and hour >= 0 and hour <= 23 then
                    TriggerServerEvent('staff_menu:setTime', hour)
                    menu2.close()
                    menu.close()
                    isMenuOpen = false
                else
                    ESX.ShowNotification('~r~Invalid time! Use 0-23')
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
        OpenStaffMenu()
    end)
end

function OpenWeatherMenu()
    local elements = {}
    
    for _, weather in pairs(Config.WeatherTypes) do
        table.insert(elements, {
            label = weather.label,
            value = weather.value
        })
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weather_menu', {
        title = '🌤️ Weather Options',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('staff_menu:setWeather', data.current.value)
        menu.close()
        OpenServerManagement()
    end, function(data, menu)
        menu.close()
        OpenServerManagement()
    end)
end

function OpenUtilities()
    local elements = {}
    
    table.insert(elements, {
        label = '✈️ NoClip (' .. (noclipEnabled and '~g~ON' or '~r~OFF') .. '~s~)',
        value = 'noclip'
    })
    
    if noclipEnabled then
        table.insert(elements, {
            label = '🚫 Force Disable NoClip',
            value = 'disable_noclip'
        })
    end
    
    table.insert(elements, {
        label = '💊 Heal Self',
        value = 'heal_self'
    })
    
    table.insert(elements, {
        label = '🛡️ Armor Self',
        value = 'armor_self'
    })
    
    table.insert(elements, {
        label = '👻 Invisible (' .. (GetEntityAlpha(PlayerPedId()) < 255 and '~g~ON' or '~r~OFF') .. '~s~)',
        value = 'invisible'
    })
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'utilities', {
        title = '⚙️ Utilities',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        
        if action == 'noclip' then
            exports['staff_menu']:ToggleNoClip()
            menu.close()
            OpenUtilities()
        elseif action == 'disable_noclip' then
            -- Force disable noclip
            local ped = PlayerPedId()
            SetEntityInvincible(ped, false)
            SetEntityVisible(ped, true, false)
            SetEntityCollision(ped, true, true)
            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(PlayerId(), false)
            SetPedCanRagdoll(ped, true)
            SetEntityProofs(ped, false, false, false, false, false, false, false, false)
            noclipEnabled = false
            ESX.ShowNotification('~g~NoClip force disabled!')
            menu.close()
            OpenUtilities()
        elseif action == 'heal_self' then
            SetEntityHealth(PlayerPedId(), 200)
            ESX.ShowNotification('~g~You have been healed!')
        elseif action == 'armor_self' then
            SetPedArmour(PlayerPedId(), 100)
            ESX.ShowNotification('~b~Armor restored!')
        elseif action == 'invisible' then
            local ped = PlayerPedId()
            local alpha = GetEntityAlpha(ped)
            if alpha < 255 then
                SetEntityAlpha(ped, 255, false)
                ESX.ShowNotification('~g~Visibility restored!')
            else
                SetEntityAlpha(ped, 0, false)
                ESX.ShowNotification('~r~You are now invisible!')
            end
            menu.close()
            OpenUtilities()
        end
    end, function(data, menu)
        menu.close()
        OpenStaffMenu()
    end)
end

function CreateHealthBar(health)
    local maxHealth = 200
    local percentage = math.floor((health / maxHealth) * 100)
    local bars = math.floor(percentage / 10)
    
    local healthBar = '❤️['
    for i = 1, 10 do
        if i <= bars then
            healthBar = healthBar .. '█'
        else
            healthBar = healthBar .. '░'
        end
    end
    healthBar = healthBar .. '] ' .. percentage .. '%'
    
    if percentage > 70 then
        return '~g~' .. healthBar .. '~s~'
    elseif percentage > 30 then
        return '~y~' .. healthBar .. '~s~'
    else
        return '~r~' .. healthBar .. '~s~'
    end
end

function CreateArmorBar(armor)
    local percentage = math.floor(armor)
    local bars = math.floor(percentage / 10)
    
    local armorBar = '🛡️['
    for i = 1, 10 do
        if i <= bars then
            armorBar = armorBar .. '█'
        else
            armorBar = armorBar .. '░'
        end
    end
    armorBar = armorBar .. '] ' .. percentage .. '%'
    
    if percentage > 70 then
        return '~b~' .. armorBar .. '~s~'
    elseif percentage > 30 then
        return '~y~' .. armorBar .. '~s~'
    else
        return '~r~' .. armorBar .. '~s~'
    end
end

function OpenBanMenu()
    local elements = {}
    
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
        table.insert(elements, duration)
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ban_duration', {
        title = '🔨 Ban Duration',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ban_reason', {
            title = 'Ban Reason'
        }, function(data2, menu2)
            if data2.value then
                ESX.TriggerServerCallback('staff_menu:banPlayer', function(success, message)
                    if success then
                        ESX.ShowNotification('~g~' .. message)
                    else
                        ESX.ShowNotification('~r~' .. message)
                    end
                end, selectedPlayer.id, data2.value, data.current.value)
                
                menu2.close()
                menu.close()
                isMenuOpen = false
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
        OpenPlayerActions()
    end)
end

function OpenGroupChangeMenu()
    ESX.TriggerServerCallback('staff_menu:getStaffGroups', function(groups)
        local elements = {}
        
        for _, group in pairs(groups) do
            table.insert(elements, {
                label = group.label .. ' (Level ' .. group.level .. ')',
                value = group.value
            })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'change_group', {
            title = '🔧 Change Group',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            ESX.TriggerServerCallback('staff_menu:changePlayerGroup', function(success, message)
                if success then
                    ESX.ShowNotification('~g~' .. message)
                else
                    ESX.ShowNotification('~r~' .. message)
                end
            end, selectedPlayer.id, data.current.value)
            
            menu.close()
            isMenuOpen = false
        end, function(data, menu)
            menu.close()
            OpenPlayerActions()
        end)
    end)
end

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
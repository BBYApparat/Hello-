local playerBlips = {}
local blipsThread = nil

function TogglePlayerBlips()
    blipsEnabled = not blipsEnabled
    
    if blipsEnabled then
        ESX.ShowNotification('~g~Player blips enabled')
        StartBlipsThread()
    else
        ESX.ShowNotification('~r~Player blips disabled')
        StopBlipsThread()
    end
end

function StartBlipsThread()
    if blipsThread then return end
    
    blipsThread = CreateThread(function()
        while blipsEnabled do
            ESX.TriggerServerCallback('staff_menu:getOnlinePlayers', function(players)
                UpdatePlayerBlips(players)
            end)
            Wait(Config.Blips.updateInterval)
        end
    end)
end

function StopBlipsThread()
    if blipsThread then
        blipsThread = nil
    end
    
    -- Remove all existing blips
    for playerId, blipData in pairs(playerBlips) do
        if DoesBlipExist(blipData.blip) then
            RemoveBlip(blipData.blip)
        end
    end
    playerBlips = {}
end

function UpdatePlayerBlips(players)
    local myServerId = GetPlayerServerId(PlayerId())
    
    -- Remove blips for players who are no longer online
    for playerId, blipData in pairs(playerBlips) do
        local found = false
        for _, player in pairs(players) do
            if tonumber(player.id) == tonumber(playerId) then
                found = true
                break
            end
        end
        
        if not found then
            if DoesBlipExist(blipData.blip) then
                RemoveBlip(blipData.blip)
            end
            playerBlips[playerId] = nil
        end
    end
    
    -- Update or create blips for current players
    for _, player in pairs(players) do
        local playerId = tonumber(player.id)
        
        -- Skip self
        if playerId ~= myServerId then
            -- Check if we can see this player (hide admin details from non-admins)
            local canSeePlayer = true
            if not HasPermission('changegroup') and player.group and Config.StaffGroups[player.group] and Config.StaffGroups[player.group].level >= 3 then
                canSeePlayer = false
            end
            
            if canSeePlayer then
                local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
                
                if playerPed and playerPed ~= 0 then
                    local coords = GetEntityCoords(playerPed)
                    
                    -- Create or update blip
                    if not playerBlips[playerId] then
                        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        SetBlipSprite(blip, 1) -- Default player blip
                        SetBlipScale(blip, 0.8)
                        SetBlipAsShortRange(blip, true)
                        
                        playerBlips[playerId] = {
                            blip = blip,
                            lastUpdate = GetGameTimer()
                        }
                    end
                    
                    local blipData = playerBlips[playerId]
                    
                    -- Update blip position
                    SetBlipCoords(blipData.blip, coords.x, coords.y, coords.z)
                    
                    -- Set blip color based on group
                    local group = player.group or 'user'
                    local color = Config.Blips.colors[group] or Config.Blips.colors['user']
                    SetBlipColour(blipData.blip, GetBlipColorFromRGB(color.r, color.g, color.b))
                    
                    -- Create display name with health/armor info
                    local displayName = player.name
                    
                    if Config.Blips.showHealth and player.health then
                        local healthPercent = math.floor((player.health / 200) * 100)
                        displayName = displayName .. ' ❤️' .. healthPercent .. '%'
                    end
                    
                    if Config.Blips.showArmor and player.armor and player.armor > 0 then
                        displayName = displayName .. ' 🛡️' .. player.armor .. '%'
                    end
                    
                    -- Add ID
                    displayName = displayName .. ' [' .. playerId .. ']'
                    
                    -- Add Steam name below
                    if player.steamName then
                        displayName = displayName .. '\n' .. player.steamName
                    end
                    
                    -- Add food/water info
                    if Config.Blips.showFood and player.food then
                        displayName = displayName .. '\n🍖' .. player.food .. '%'
                    end
                    
                    if Config.Blips.showWater and player.water then
                        displayName = displayName .. ' 💧' .. player.water .. '%'
                    end
                    
                    SetBlipDisplay(blipData.blip, 2)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringPlayerName(displayName)
                    EndTextCommandSetBlipName(blipData.blip)
                end
            else
                -- Remove blip if we can't see this player
                if playerBlips[playerId] then
                    if DoesBlipExist(playerBlips[playerId].blip) then
                        RemoveBlip(playerBlips[playerId].blip)
                    end
                    playerBlips[playerId] = nil
                end
            end
        end
    end
end

function GetBlipColorFromRGB(r, g, b)
    -- Convert RGB to closest GTA blip color
    -- This is a simplified mapping
    if r > 200 and g < 100 and b < 100 then
        return 1 -- Red
    elseif r > 200 and g > 150 and b < 100 then
        return 17 -- Orange
    elseif r < 100 and g > 200 and b < 100 then
        return 2 -- Green  
    elseif r < 100 and g < 100 and b > 200 then
        return 3 -- Blue
    elseif r > 200 and g < 100 and b > 200 then
        return 7 -- Purple
    else
        return 0 -- White
    end
end

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        StopBlipsThread()
    end
end)
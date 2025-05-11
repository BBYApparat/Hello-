local zoneCoords = vector3(-333.195, -131.627, 39.846)
local zoneRadius = 4.0
local checkInterval = 1000 -- Default check every 1 second when far away
local isNearZone = false
local keyPressed = false

Citizen.CreateThread(function()
    local playerPed = PlayerPedId() -- Cache this value
    
    while true do
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - zoneCoords)
        
        -- Dynamically adjust the check interval based on distance
        if distance < 50.0 then
            checkInterval = 250 -- Every 250ms when within 50 units
            
            -- Only update ped reference periodically to save resources
            if not isNearZone then
                playerPed = PlayerPedId() -- Update ped reference when entering check zone
                isNearZone = true
            end
            
            -- Only do expensive checks when close to the zone
            if distance <= zoneRadius then
                if IsPedInAnyVehicle(playerPed, false) then
                    checkInterval = 0 -- Every frame when in interaction range
                    
                    -- Draw marker instead of text for better performance
                    DrawMarker(1, zoneCoords.x, zoneCoords.y, zoneCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 
                        zoneRadius * 2.0, zoneRadius * 2.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                    
                    -- Only draw text when extremely close
                    if distance <= zoneRadius * 0.7 then
                        DrawText3D(zoneCoords.x, zoneCoords.y, zoneCoords.z, "Press ~g~E~w~ to open the mechanic menu")
                        
                        -- Handle key press with debounce
                        if IsControlJustReleased(0, 38) and not keyPressed then
                            keyPressed = true
                            TriggerEvent('mt_workshops:client:openPreviewMenu')
                            -- Reset key press status after a short delay
                            Citizen.SetTimeout(500, function() keyPressed = false end)
                        end
                    end
                end
            end
        else
            isNearZone = false
            checkInterval = 1000 -- Every second when far away
        end
        
        Citizen.Wait(checkInterval)
    end
end)

-- Optimized DrawText3D function
function DrawText3D(x, y, z, text)
    -- Only calculate if it's on screen
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    
    -- Set up the text once
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    
    -- Display the text
    EndTextCommandDisplayText(_x, _y)
    
    -- Calculate background size
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
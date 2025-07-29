-- Client-side Vehicle Persistence Module
-- Handles waypoint creation and vehicle proximity detection

-- Set waypoint to coordinates
RegisterNetEvent('esx:setWaypoint')
AddEventHandler('esx:setWaypoint', function(x, y)
    SetNewWaypoint(x, y)
    ESX.ShowNotification('Waypoint set to vehicle location')
end)

-- Function to check if player is near a vehicle location
function IsPlayerNearLocation(coords, maxDistance)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - coords)
    return distance <= maxDistance, distance
end

-- Export for other resources
exports('isPlayerNearLocation', IsPlayerNearLocation)

print('[ESX] Vehicle Persistence Client Module loaded')
local stashCoords = {x = 151.2605, y = -1004.471, z = -98.99999}
local entranceCoords = {x = 313.01, y = -225.20, z = 54.21}
local exitCoords = {x = 151.43, y = -1007.76, z = -99.01}
local wardarobeRealLol = vector4(151.7, -1001.42, -99.0, 271.13)
local isInMotel = false
local PropertyId = "motelRoom"  
local MyCurrentRoomid = nil  -- Fixed typo: 'MyCorrentRoomid' to 'MyCurrentRoomid'

RegisterNetEvent('motel:enterRoom', function(roomId)
    print(1)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(playerPed, exitCoords.x, exitCoords.y, exitCoords.z)
    DoScreenFadeIn(1000)
    isInMotel = true
    MyCurrentRoomid = roomId
end)

-- Event to leave the room (teleport to entranceCoords)
RegisterNetEvent('motel:leaveRoom', function()
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(playerPed, entranceCoords.x, entranceCoords.y, entranceCoords.z)
    DoScreenFadeIn(1000)
    isInMotel = false
    MyCurrentRoomid = nil
end)

exports.ox_target:addBoxZone({
    coords = entranceCoords,  
    size = vec3(1.5, 1.5, 1),  -- Size of the box zone at the entrance
    rotation = 0,
    debug = false,
    options = {
        {
            name = 'enter_motel',
            serverEvent = 'motel:enterRoom',
            icon = 'fas fa-door-open',
            label = 'Enter Motel',
            canInteract = function()
                return not isInMotel  -- Only show the option if the player is not already inside the motel
            end
        }
    }
})

exports.ox_target:addBoxZone({
    coords = exitCoords,  
    size = vec3(1.5, 1.5, 1),  -- Size of the box zone at the exit
    rotation = 0,
    debug = false,
    options = {
        {
            name = 'leave_motel',
            event = 'motel:leaveRoom',
            icon = 'fas fa-door-closed',
            label = 'Leave Motel',
            canInteract = function()
                return isInMotel  -- Only show the option if the player is inside the motel
            end
        }
    }
})

exports.ox_target:addBoxZone({
    coords = stashCoords,  -- Wardrobe coordinates
    size = vec3(1.5, 1.5, 1),  -- Define the interaction box size around the wardrobe
    rotation = 0,
    debug = false,  -- Set to true to visualize the box in the game for debugging
    options = {
        {
            name = 'open_stash',  -- Unique name for the interaction
            event = 'motel:openStash',  -- Trigger the event to open the wardrobe
            icon = 'fas fa-closet',  -- Icon for the interaction
            label = 'Open Stash',  -- Label shown to the player
            canInteract = function(entity, distance, coords, name)
                return isInMotel  -- Only allow interaction if the player is inside the motel
            end
        }
    }
})

exports.ox_target:addBoxZone({
    coords = wardarobeRealLol,  -- Wardrobe coordinates
    size = vec3(1.5, 1.5, 1),  -- Define the interaction box size around the wardrobe
    rotation = 0,
    debug = false,  -- Set to true to visualize the box in the game for debugging
    options = {
        {
            name = 'open_wardrobeClothes',  -- Unique name for the interaction
            event = 'illenium-appearance:client:openOutfitMenu',  -- Trigger the event to open the wardrobe
            icon = 'fas fa-closet',  -- Icon for the interaction
            label = 'Open Wardrobe',  -- Label shown to the player
            canInteract = function(entity, distance, coords, name)
                return isInMotel  -- Only allow interaction if the player is inside the motel
            end
        }
    }
})
-- Event to open the wardrobe (stash)
RegisterNetEvent('motel:openStash', function()
    PlayerData = ESX.GetPlayerData()
    -- Open the stash using ox_inventory for the property and current room
    print(MyCurrentRoomid)
    exports.ox_inventory:openInventory('stash', {id = MyCurrentRoomid})
end)
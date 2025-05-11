local Drops = {}
local DropsNear = {}

RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local plyIndex = GetPlayerFromServerId(player)
    local plyPed = GetPlayerPed(plyIndex)
    local forward = GetEntityForwardVector(plyPed)
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:LoadDrops', function(data)
    Drops = data
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    DropsNear[dropId] = nil
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    SendNUIMessage({action = "close"})
    Wait(200)
    local dict, anim = "pickup_object" ,"pickup_low"
    loadAnim(dict)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(2000)
    ClearPedTasks(ped)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if DropsNear then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] then
                    sleep = 0
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if Drops and next(Drops) then
            for k, v in pairs(Drops) do
                if Drops[k] then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < 2.5 then
                        DropsNear[k] = v
                        if dist <= 1.8 then
                            CurrentDrop = k
                        else
                            if CurrentDrop and inInventory then
                                closeInventory()
                                CurrentDrop = nil
                            end
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(300)
    end
end)

isNearToDrop = function(id)
    if not Drops[id] or not DropsNear[id] then
        return false
    else
        if #(vector2(pos.x, pos.y) - vector2(Drops[id].coords.x, Drops[id].coords.y)) <= 1.8 then
            return true
        end
    end
    return false
end
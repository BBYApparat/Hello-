-- Just left those open if you want to build the weight system /w vip system etc.
getPlayerInventoryWeight = function(playerId)
    local xPlayer
    if IsDuplicityVersion() then
        xPlayer = ESX.GetPlayerFromId(playerId)
    else
        if not playerId then
            xPlayer = GetPlayerServerId(PlayerId())
        else
            xPlayer = GetPlayerServerId(playerId)
        end
    end

    return ESX.Config.MaxWeight
end

exports("getPlayerInventoryWeight", getPlayerInventoryWeight)

getPlayerInventorySlots = function(playerId)
    local xPlayer
    if IsDuplicityVersion() then
        xPlayer = ESX.GetPlayerFromId(playerId)
    else
        if not playerId then
            xPlayer = GetPlayerServerId(PlayerId())
        else
            xPlayer = GetPlayerServerId(playerId)
        end
    end

    return ESX.Config.MaxInvSlots
end

exports("getPlayerInventorySlots", getPlayerInventorySlots)

getTrunkCapacity = function()
    return Config.VehicleCapacity
end

exports("getTrunkCapacity", getTrunkCapacity)
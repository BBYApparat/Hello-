local pedModel = `s_m_m_security_01` -- Example ped model
local pedPositions = {
    vector3(0.77, -0.99, 0.69),
    vector3(0.0, -0.0, 0.0),
    vector3(0.0, -0.0, 0.0)
}
local housesRequested = 0
local lastReset = GetGameTimer()

CreateThread(function()
    loadModel(pedModel)
    local pedCoords = pedPositions[math.random(#pedPositions)]
    local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, 0.0, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, false)
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'ped_interact',
            label = 'Get Robbery Location',
            icon = 'fa-solid fa-house',
            onSelect = function()
                local hours = GetClockHours()
                if hours >= 20 or hours < 6 then
                    -- Rate limiting
                    local currentTime = GetGameTimer()
                    if currentTime - lastReset > 600000 then -- 10 minutes in milliseconds
                        housesRequested = 0
                        lastReset = currentTime
                    end
                    if housesRequested < 40 then
                        local randomHouse = Config.Houses[math.random(#Config.Houses)]
                        SetNewWaypoint(randomHouse.x, randomHouse.y)
                        housesRequested = housesRequested + 1
                        TriggerServerEvent('houseRobbery:notify', "waypoint_set", randomHouse.info)
                    else
                        TriggerServerEvent('houseRobbery:notify', "limit_reached")
                    end
                else
                    TriggerServerEvent('houseRobbery:notify', "wrong_time")
                end
            end
        }
    })
end)

-- Export function to retrieve the ped entity
exports("RobberyPed", function()
    return ped
end)

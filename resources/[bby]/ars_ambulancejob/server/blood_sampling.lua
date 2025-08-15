local bloodSamplingCooldowns = {}
local COOLDOWN_TIME = 300000 -- 5 minutes in milliseconds

lib.callback.register('ars_ambulancejob:checkBloodSamplingCooldown', function(source, targetId)
    local currentTime = GetGameTimer()
    local cooldownEnd = bloodSamplingCooldowns[targetId]
    
    if cooldownEnd and currentTime < cooldownEnd then
        local remainingTime = math.ceil((cooldownEnd - currentTime) / 1000)
        return false, remainingTime
    end
    
    return true, 0
end)

lib.callback.register('ars_ambulancejob:setBloodSamplingCooldown', function(source, targetId)
    local currentTime = GetGameTimer()
    bloodSamplingCooldowns[targetId] = currentTime + COOLDOWN_TIME
    
    -- Clean up old cooldowns
    for playerId, cooldownEnd in pairs(bloodSamplingCooldowns) do
        if currentTime > cooldownEnd then
            bloodSamplingCooldowns[playerId] = nil
        end
    end
    
    return true
end)

RegisterNetEvent('ars_ambulancejob:applyBloodSamplingEffects', function(targetId)
    local src = source
    local targetSrc = targetId
    
    -- Validate the request
    if not targetSrc or targetSrc == src then
        return
    end
    
    -- 12% chance to faint (10-15% range)
    local faintChance = math.random(1, 100)
    if faintChance <= 12 then
        TriggerClientEvent('ars_ambulancejob:faintFromBloodSampling', targetSrc)
    end
    
    -- Apply slight health reduction
    TriggerClientEvent('ars_ambulancejob:reduceHealthFromBloodSampling', targetSrc)
end)
AddEventHandler('ak47_ambulancejob:onPlayerRevive', function()
    -- your code here
    if GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:setInventoryDisabled(false)
    end
    
    if GetResourceState('inventory') == 'started' then
        TriggerEvent("inventory:setPlayerDead", false)
    end

    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:ToggleDisabled(false)
    end
end)

AddEventHandler('ak47_ambulancejob:onPlayerDown', function()
    -- your code here
    if GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:setInventoryDisabled(true)
    end

    if GetResourceState('inventory') == 'started' then
        TriggerEvent("inventory:setPlayerDead", true)
    end

    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:ToggleDisabled(true)
    end
end)

AddEventHandler('ak47_ambulancejob:onPlayerDeath', function()
    -- your code here
    -- if GetResourceState('qs-inventory') == 'started' then
    --     exports['qs-inventory']:setInventoryDisabled(true)
    -- end

    if GetResourceState('inventory') == 'started' then
        TriggerEvent("inventory:setPlayerDead", true)
    end

    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:ToggleDisabled(true)
    end
end)

AddEventHandler('ak47_ambulancejob:onForceRespawn', function()
    -- your code here
    if GetResourceState('inventory') == 'started' then
        TriggerEvent("inventory:setPlayerDead", false)
    end

    if GetResourceState('lb-phone') == 'started' then
        exports["lb-phone"]:ToggleDisabled(true)
    end
end)

RegisterNetEvent('esx_ambulancejob_Revive_gangwar', function()
    revivePlayer()
end)

function CanPlayerDie(attacker, weapon)
    if GetResourceState('wise_fraction') == 'started' then
        return not exports['wise_fraction']:inFight()
    elseif GetResourceState('ws_ffa-v2') == 'started' then
        return not exports["ws_ffa-v2"]:isInZone()
    else
        return true
    end
end
lib.onCache('weapon', function(value)
    if value then
        
        if Config.BlockAttack[value] then AimBlock() end
        if Config.Modifier.Weapons[value] then N_0x4757f00bc6323cfe(value, Config.Modifier.Weapons[value].modifier) end
    end
end)

function AimBlock()
    CreateThread(function()
        while cache.weapon do
            Wait(0)

            if Config.BlockAttack[cache.weapon] then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(cache.ped, true)
            end

            if Config.Modifier.Weapons[cache.weapon] then
                N_0x4757f00bc6323cfe(cache.weapon, Config.Modifier.Weapons[cache.weapon].modifier)
                Wait(1000)
            end
        end
    end)
end

RegisterCommand("weaponHash", function()
    print(cache.weapon)
end)

CreateThread(function()
    for weapon , data in pairs(Config.Modifier.Weapons) do
        N_0x4757f00bc6323cfe(data.model, data.modifier)
    end
end)
CreateThread(function()
    while true do
        local sleep = 300
        local playerPed = PlayerPedId()
        local playerHealth = GetEntityHealth(playerPed)
        if playerHealth <= 100 then
            sleep = 3
            DisableControlAction(0, 288, true) -- Disable F1
            DisableControlAction(0, 217, true) -- Disable Caps Lock
        end
        Wait(sleep)
    end
end)

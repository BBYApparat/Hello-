Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 288) then  -- 288 = F1
            ExecuteCommand('phone')
        end
    end
end)

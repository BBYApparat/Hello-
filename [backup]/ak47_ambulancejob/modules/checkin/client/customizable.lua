AddEventHandler('ak47_ambulancejob:onFinishCheckin', function()
    -- your code here
    if Config.SetCrutchAfterCheckin then
        TriggerServerEvent('ak47_crutch:set', GetPlayerServerId(PlayerId()), Config.CrutchTimer) -- 5 minutes
    end
end)
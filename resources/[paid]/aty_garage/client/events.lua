-- ### Resource stop handler ### --
AddEventHandler("onResourceStop", function(e)
    if e == GetCurrentResourceName() then
        if Blips and next(Blips) then
            for k, v in pairs(Blips) do
                if DoesBlipExist(v) then
                    RemoveBlip(v)
                end
            end
        end

        if Peds and next(Peds) then
            for k, v in pairs(Peds) do
                if DoesEntityExist(v) then
                    DeleteEntity(v)
                end
            end
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    Job = JobInfo.name
end)

RegisterNetEvent("esx:setJob", function(JobInfo)
    Job = JobInfo.name
end)
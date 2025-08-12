RegisterNUICallback('getLoginInfo', function(data, cb)
    local identifier = GetIdentifier()
    TriggerServerCallback('al_mdt:FetchUser', function(userData)
        local job = GetJob().name
        cb(userData and userData or {
            register = {
                name = GetName(),
                job = GetJobKey(job),
            }
        })

        if userData and userData.job ~= job then
            TriggerServerEvent('al_mdt:SetUserCallsign', mdt.k, identifier, '') -- Reset callsgin
            TriggerServerEvent('al_mdt:SetUserJob', mdt.k, identifier, GetJobKey(job)) -- Set job to new job
        end
    end, mdt.k, identifier)
end)

RegisterNUICallback('loginUser', function(data, cb)
    TriggerServerCallback('al_mdt:FetchUser', function(userData) -- Check user vailidity with server
        if userData then
            userData.settings = json.decode(userData.settings)
            mdt.keybind = userData.settings.keybind or false

            TriggerServerCallback('al_mdt:InitWebApp', function(resp)
                cb({
                    resp = resp,
                    user = userData
                })
            end, mdt.k, GetIdentifier())
        else
            cb(false)
        end
    end, mdt.k, GetIdentifier())
end)

RegisterNUICallback('registerUser', function(data, cb)
    TriggerServerCallback('al_mdt:RegisterUser', function(success)
        if success then
            Citizen.Wait(1000)
            TriggerServerCallback('al_mdt:InitWebApp', function(resp)
                cb(resp)
            end, mdt.k, GetIdentifier())
        else
            cb(false)
        end
    end, mdt.k, GetIdentifier(), GetName(), '', GetJobKey(GetJob().name))
end)
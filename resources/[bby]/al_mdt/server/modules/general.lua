RegisterCallback('al_mdt:Init', function(source, ...)
    TriggerProtFunction('Init', source, function(src, cb)
        cb(CreateKey(src))
    end, ...)
end)

function InitWebApp(src, identifier) -- Fetch required data after login
    if identifier then
        identifier = tostring(identifier)
        local response = {
            bolos = {
                persons = DbQueries.bolos.person.FetchAll(),
                vehicles = DbQueries.bolos.vehicle.FetchAll(),
                warrants = DbQueries.warrants.FetchAll()
            },
            users = DbQueries.users.FetchAll()
        }

        for i=1, #response.users do
            local user = response.users[i]

            if user.identifier == identifier then
                user.self = true -- Set this var to true so web app can recognize user (self)
            else
                user.totalHours = nil -- Clear from table because user (self) wont need other users' info
                user.settings = nil
            end

            if onlineUsers[user.identifier] then
                local onlineUser = onlineUsers[user.identifier]

                user.onDuty = onlineUser.onDuty
                user.status = onlineUser.status
            else
                user.onDuty = false
                user.status = 0
            end
        end

        onlineUsers[identifier] = {
            id = src,
            onDuty = false,
            status = 0
        }

        return response
    else
        return false
    end
end
RegisterCallback('al_mdt:InitWebApp', function(source, ...)
    TriggerProtFunction('InitWebApp', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(InitWebApp(src, ...))
        end
    end, ...)
end)

AddEventHandler('playerDropped', function()
    local src = source

    for i,v in pairs(onlineUsers) do
        if v.id == src then

            if v.onDuty then -- Track hours
                local currentShift = onlineUsers[i].shift
                if currentShift then
                    currentShift.ending = currentShift.start + (os.time() * 1000 - currentShift.start)

                    DbQueries.dutyTracker.Add(i, currentShift.job, currentShift.start, currentShift.ending)
                    DutyEntryAlert(src, i, currentShift.job, currentShift.start, currentShift.ending)
                end
            end

            onlineUsers[i] = nil
            SyncUsers()
            break
        end
    end
end)
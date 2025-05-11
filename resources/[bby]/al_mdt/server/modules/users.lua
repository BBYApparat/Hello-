-- Units/Users --
function RegisterUser(src, identifier, name, callsign, job) -- Register new user
    if identifier ~= nil and name ~= nil and callsign ~= nil and job ~= nil then
        if not FetchUser(identifier) then -- If user does not already exist in the db
            DbQueries.users.Register(identifier, name, callsign, job)
            UserRegisteredAlert(src, identifier, job)
            SyncUsers()
            return true
        end
    end
    return false
end
RegisterCallback('al_mdt:RegisterUser', function(source, ...)
    TriggerProtFunction('RegisterUser', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(RegisterUser(src, ...))
        end
    end, ...)
end)

function SetUserCallsign(identifier, callsign) -- Set user callsign
    if identifier ~= nil and callsign ~= nil then
        DbQueries.users.SetCallsign(identifier, callsign)
    end
end
RegisterNetEvent('al_mdt:SetUserCallsign', function(...)
    TriggerProtFunction('SetUserCallsign', source, function(src, key, ...)
        if VerifyKey(src, key) then
            SetUserCallsign(...)
        end
    end, ...)
end)

function SetUserJob(identifier, job) -- Set user job
    if identifier ~= nil and job ~= nil then
        DbQueries.users.SetJob(identifier, job)
        SyncUsers()
    end
end
RegisterNetEvent('al_mdt:SetUserJob', function(...)
    TriggerProtFunction('SetUserJob', source, function(src, key, ...)
        if VerifyKey(src, key) then
            SetUserJob(...)
        end
    end, ...)
end)

function UpdateUserSettings(identifier, settings) -- Update user settings
    if identifier and settings then
        DbQueries.users.UpdateSettings(identifier, settings)
    end
end
RegisterNetEvent('al_mdt:UpdateUserSettings', function(...)
    TriggerProtFunction('UpdateUserSettings', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateUserSettings(...)
        end
    end, ...)
end)

function FetchUser(identifier) -- User fetch
    return DbQueries.users.Fetch(identifier)
end
RegisterCallback('al_mdt:FetchUser', function(source, ...)
    TriggerProtFunction('FetchUser', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchUser(...))
        end
    end, ...)
end)

function FetchUsers() -- Users fetch
    return DbQueries.users.FetchAll()
end
RegisterCallback('al_mdt:FetchUsers', function(source, ...)
    TriggerProtFunction('FetchUsers', source, function(src, cb, key)
        if VerifyKey(src, key) then
            cb(FetchUsers())
        end
    end, ...)
end)

function SetStatus(identifier, status) -- Update user status
    if onlineUsers[identifier] and onlineUsers[identifier].onDuty then
        onlineUsers[identifier].status = status

        if status == 5 then
            SyncUsers({
                type = 'panic',
                player = identifier,
            })
        else
            SyncUsers()
        end
    end
end
RegisterNetEvent('al_mdt:SetStatus', function(...)
    TriggerProtFunction('SetStatus', source, function(src, key, ...)
        if VerifyKey(src, key) then
            SetStatus(...)
        end
    end, ...)
end)

function GoOnDuty(src, identifier, job, time)
    if onlineUsers[identifier] then
        onlineUsers[identifier].onDuty = true
        onlineUsers[identifier].status = 1
        onlineUsers[identifier].shift = {
            job = job,
            start = time
        }

        SyncUsers({
            type = 'onduty',
            player = identifier,
        })
        DutyAlert(src, true, identifier, job)
    end
end
RegisterNetEvent('al_mdt:GoOnDuty', function(...)
    TriggerProtFunction('GoOnDuty', source, function(src, key, ...)
        if VerifyKey(src, key) then
            GoOnDuty(src, ...)
        end
    end, ...)
end)

function GoOffDuty(src, identifier, time)
    if onlineUsers[identifier] then
        onlineUsers[identifier].onDuty = false
        onlineUsers[identifier].status = 0

        local currentShift = onlineUsers[identifier].shift
        currentShift.ending = time
        DbQueries.dutyTracker.Add(identifier, currentShift.job, currentShift.start, currentShift.ending)
        SyncUsers({
            type = 'offduty',
            player = identifier,
        })
        DutyAlert(src, false, identifier, currentShift.job)
        DutyEntryAlert(src, identifier, currentShift.job, currentShift.start, currentShift.ending)
    end
end
RegisterNetEvent('al_mdt:GoOffDuty', function(...)
    TriggerProtFunction('GoOffDuty', source, function(src, key, ...)
        if VerifyKey(src, key) then
            GoOffDuty(src, ...)
        end
    end, ...)
end)

function LogOut(identifier)
    if identifier and onlineUsers[identifier] then
        onlineUsers[identifier] = nil
        SyncUsers()
    end
end
RegisterNetEvent('al_mdt:LogOut', function(...)
    TriggerProtFunction('LogOut', source, function(src, key, ...)
        if VerifyKey(src, key) then
            LogOut(...)
        end
    end, ...)
end)

function GetActivityLog(identifier, job, page, getTotalPages)
    if identifier and job and page then
        return DbQueries.dutyTracker.Fetch(identifier, job, page, getTotalPages)
    else
        return false
    end
end
RegisterCallback('al_mdt:GetActivityLog', function(source, ...)
    TriggerProtFunction('GetActivityLog', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(GetActivityLog(...))
        end
    end, ...)
end)

function GetActivityStatistics(identifier, job)
    if identifier and job then
        return DbQueries.dutyTracker.FetchStatistics(identifier, job)
    else
        return false
    end
end
RegisterCallback('al_mdt:GetActivityStatistics', function(source, ...)
    TriggerProtFunction('GetActivityStatistics', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(GetActivityStatistics(...))
        end
    end, ...)
end)

function GetJobActivity(job, page, getTotalUsers, date)
    if job and date then
        local resp = DbQueries.users.FetchFromJob(job, page, getTotalUsers)

        for i=1, #resp.users do
            local user = resp.users[i]
            user.log = DbQueries.dutyTracker.FetchJobStatistics(user.identifier, job, date)
        end

        return resp
    else
        return false
    end
end
RegisterCallback('al_mdt:GetJobActivity', function(source, ...)
    TriggerProtFunction('GetJobActivity', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(GetJobActivity(...))
        end
    end, ...)
end)

function SetGPS(identifier)
    if identifier and onlineUsers[identifier] then
        local target = onlineUsers[identifier]
        local coords = nil
        local start = os.time()
        TriggerClientEvent('al_mdt:GetCoords', target.id)

        while not onlineUsers[identifier].coords and not coords and os.time() - start < 5 do
            Citizen.Wait(1000)
        end

        if onlineUsers[identifier].coords then
            coords = onlineUsers[identifier].coords
            onlineUsers[identifier].coords = nil
        end

        return coords
    else
        return
    end
end
RegisterCallback('al_mdt:SetGPS', function(source, ...)
    TriggerProtFunction('SetGPS', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(SetGPS(...))
        end
    end, ...)
end)

function SendCoords(identifier, coords)
    if identifier and onlineUsers[identifier] then
        onlineUsers[identifier].coords = coords
    end
end
RegisterNetEvent('al_mdt:SendCoords', function(...)
    TriggerProtFunction('SendCoords', source, function(src, key, ...)
        if VerifyKey(src, key) then
            SendCoords(...)
        end
    end, ...)
end)

-- Syncing with clients
function SyncUsers(update)
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local usersResp = DbQueries.users.FetchAll()
        usersResp = json.encode(usersResp)
        update = json.encode(update)

        for identifier,v in pairs(onlineUsers) do
            local users = json.decode(usersResp)
            local userUpdate = json.decode(update)
            local updateUserFound = false

            for i=1, #users do
                local user = users[i]

                if user.identifier == identifier then
                    user.self = true -- Set this var to true so web app can recognize user (self)
                    user.settings = json.decode(user.settings)
                else
                    user.totalHours = nil -- Clear from table because user (self) wont need other users' info
                    user.settings = nil
                end

                if onlineUsers[user.identifier] then -- If online, set their duty and patrol status
                    local onlineUser = onlineUsers[user.identifier]

                    user.onDuty = onlineUser.onDuty
                    user.status = onlineUser.status
                else
                    user.onDuty = false
                    user.status = 0
                end

                if userUpdate then
                    if userUpdate.player ~= identifier then
                        if userUpdate and not updateUserFound then
                            if userUpdate.player == user.identifier then
                                updateUserFound = true
                                userUpdate.player = user
                            end
                        end
                    end
                end
            end

            --[[
                Returns the following for every user:
                - identifier (str)
                - name (str)
                - callsign (str)
                - job (str)
                - onDuty (bool)
                - status (int)
                - self (bool & only if self)
            ]]
            local resp = { users = users }
            if update and userUpdate and updateUserFound then -- Targets everyone but the player who triggered the sync
                userUpdate.playerJob = userUpdate.player.job
                userUpdate.player = ('%s %s'):format(userUpdate.player.callsign, userUpdate.player.name)
                resp.update = userUpdate
            end
            TriggerClientEvent('al_mdt:SyncUsers', v.id, resp)
        end
    end)
end
local Callbacks = {}
SQL = {}
DbQueries = {
    bolos = {
        vehicle = {
            FetchAll = function()
                return SQL.SyncFetch('SELECT * FROM `mdt_veh_bolos`', {})
            end,
            Add = function(cb, creator, plate, model, lastSeen, color, description, reason, notes, date)
                SQL.AsyncExecute('INSERT INTO `mdt_veh_bolos` (creator, plate, model, lastSeen, color, description, reason, notes, date) VALUES (@creator, @plate, @model, @lastSeen, @color, @description, @reason, @notes, @date)',
                {
                    ['creator']     = creator,
                    ['plate']       = plate,
                    ['model']       = model,
                    ['lastSeen']    = lastSeen,
                    ['color']       = color,
                    ['description'] = description,
                    ['reason']      = reason,
                    ['notes']       = notes,
                    ['date']        = date,
                },
                function(affectedRows)
                    cb(creator, plate)
                end)
            end,
            Update = function(id, plate, model, lastSeen, color, description, reason, notes, date)
                SQL.AsyncExecute('UPDATE `mdt_veh_bolos` SET plate = @plate, model = @model, lastSeen = @lastSeen, color = @color, description = @description, reason = @reason, notes = @notes, date = @date WHERE id = @id',
                {
                    ['id']          = id,
                    ['plate']       = plate,
                    ['model']       = model,
                    ['lastSeen']    = lastSeen,
                    ['color']       = color,
                    ['description'] = description,
                    ['reason']      = reason,
                    ['notes']       = notes,
                    ['date']        = date,
                },
                function(affectedRows)
                    SyncBolos()
                end)
            end,
            Remove = function(id)
                SQL.AsyncExecute('DELETE FROM `mdt_veh_bolos` WHERE `id` = @id',
                {
                    ['id'] = id,
                },
                function(affectedRows)
                    SyncBolos()
                end)
            end,
        },
        person = {
            FetchAll = function()
                return SQL.SyncFetch('SELECT * FROM `mdt_person_bolos`', {})
            end,
            Add = function(cb, creator, name, lastSeen, reason, description, notes, date, targetIdentifier)
                SQL.AsyncExecute('INSERT INTO `mdt_person_bolos` (creator, name, lastSeen, reason, description, notes, date, targetIdentifier) VALUES (@creator, @name, @lastSeen, @reason, @description, @notes, @date, @targetIdentifier)',
                {
                    ['creator']          = creator,
                    ['name']             = name,
                    ['lastSeen']         = lastSeen,
                    ['reason']           = reason,
                    ['description']      = description,
                    ['notes']            = notes,
                    ['date']             = date,
                    ['targetIdentifier'] = targetIdentifier,
                },
                function(affectedRows)
                    cb(creator, name)
                end)
            end,
            Update = function(id, name, lastSeen, reason, description, notes, date, targetIdentifier)
                SQL.AsyncExecute('UPDATE `mdt_person_bolos` SET name = @name, lastSeen = @lastSeen, reason = @reason, description = @description, notes = @notes, date =  @date, targetIdentifier = @targetIdentifier WHERE id = @id',
                {
                    ['id']               = id,
                    ['name']             = name,
                    ['lastSeen']         = lastSeen,
                    ['reason']           = reason,
                    ['description']      = description,
                    ['notes']            = notes,
                    ['date']             = date,
                    ['targetIdentifier'] = targetIdentifier,
                },
                function(affectedRows)
                    SyncBolos()
                end)
            end,
            Remove = function(id)
                SQL.AsyncExecute('DELETE FROM `mdt_person_bolos` WHERE `id` = @id',
                {
                    ['id'] = id,
                },
                function(affectedRows)
                    SyncBolos()
                end)
            end,
        },
    },

    warrants = {
        FetchAll = function()
            return SQL.SyncFetch('SELECT * FROM `mdt_warrants`', {})
        end,
        Add = function(cb, creator, name, lastSeen, reason, description, notes, date, targetIdentifier)
            SQL.AsyncExecute('INSERT INTO `mdt_warrants` (creator, name, lastSeen, reason, description, notes, date, targetIdentifier) VALUES (@creator, @name, @lastSeen, @reason, @description, @notes, @date, @targetIdentifier)',
            {
                ['creator']          = creator,
                ['name']             = name,
                ['lastSeen']         = lastSeen,
                ['reason']           = reason,
                ['description']      = description,
                ['notes']            = notes,
                ['date']             = date,
                ['targetIdentifier'] = targetIdentifier,
            },
            function(affectedRows)
                cb(creator, name)
            end)
        end,
        Update = function(id, name, lastSeen, reason, description, notes, date, targetIdentifier)
            SQL.AsyncExecute('UPDATE `mdt_warrants` SET name = @name, lastSeen = @lastSeen, reason = @reason, description = @description, notes = @notes, date =  @date, targetIdentifier = @targetIdentifier WHERE id = @id',
            {
                ['id']               = id,
                ['name']             = name,
                ['lastSeen']         = lastSeen,
                ['reason']           = reason,
                ['description']      = description,
                ['notes']            = notes,
                ['date']             = date,
                ['targetIdentifier'] = targetIdentifier,
            },
            function(affectedRows)
                SyncBolos()
            end)
        end,
        Remove = function(id)
            SQL.AsyncExecute('DELETE FROM `mdt_warrants` WHERE `id` = @id',
            {
                ['id'] = id,
            },
            function(affectedRows)
                SyncBolos()
            end)
        end,
    },

    users = {
        Register = function(identifier, name, callsign, job)
            SQL.AsyncExecute('INSERT INTO `mdt_users` (identifier, name, callsign, job, settings) VALUES (@identifier, @name, @callsign, @job, @settings)',
            {
                ['identifier']  = identifier,
                ['name']        = name,
                ['callsign']    = callsign,
                ['job']         = job,
                ['settings']    = '{}'
            },
            function(affectedRows)
            end)
        end,
        SetCallsign = function(identifier, callsign)
            SQL.AsyncExecute('UPDATE `mdt_users` SET callsign = @callsign WHERE identifier = @identifier',
            {
                ['identifier']  = identifier,
                ['callsign']    = callsign,
            },
            function(affectedRows)
            end)
        end,
        SetJob = function(identifier, job)
            SQL.AsyncExecute('UPDATE `mdt_users` SET job = @job WHERE identifier = @identifier',
            {
                ['identifier']  = identifier,
                ['job']         = job,
            },
            function(affectedRows)
            end)
        end,
        UpdateSettings = function(identifier, settings)
            SQL.AsyncExecute('UPDATE `mdt_users` SET settings = @settings WHERE identifier = @identifier',
            {
                ['identifier']  = identifier,
                ['settings']    = json.encode(settings),
            },
            function(affectedRows)
            end)
        end,
        Fetch = function(identifier)
            return SQL.SyncFetch('SELECT * FROM `mdt_users` WHERE identifier = @identifier', {['identifier'] = identifier})[1]
        end,
        FetchAll = function()
            return SQL.SyncFetch('SELECT * FROM `mdt_users`', {})
        end,
        FetchFromJob = function(job, page, getTotalUsers)
            local entriesPerPage = 15
            local offset = entriesPerPage * (page - 1)
            local users = SQL.SyncFetch('SELECT identifier, name, callsign FROM `mdt_users` WHERE job = @job LIMIT @offset, @entries', {
                ['job'] = job,
                ['offset'] = offset,
                ['entries'] = entriesPerPage,
            })

            if getTotalUsers then
                local totalPages = SQL.SyncFetch('SELECT COUNT(*) FROM `mdt_users` WHERE job = @job', { ['job'] = job })
                totalPages = totalPages[1] ~= nil and totalPages[1]['COUNT(*)'] or 0
                totalPages = math.ceil(totalPages / entriesPerPage)
                return {
                    totalPages = totalPages,
                    users = users
                }
            else
                return {
                    users = users
                }
            end

            return SQL.SyncFetch('SELECT identifier, name, callsign FROM `mdt_users` WHERE job = @job', { ['job'] = job })
        end,
    },

    dutyTracker = {
        Add = function(identifier, job, startShift, endShift)
            local duration = endShift - startShift
            SQL.AsyncExecute('INSERT INTO `mdt_duty_tracker` (identifier, start, end, duration, job) VALUES (@identifier, @start, @end, @duration, @job)',
            {
                ['identifier']  = identifier,
                ['start']       = startShift,
                ['end']         = endShift,
                ['duration']    = duration,
                ['job']         = job,
            },
            function(affectedRows)
            end)
        end,
        Fetch = function(identifier, job, page, getTotalPages)
            local entriesPerPage = 15
            local offset = entriesPerPage * (page - 1)
            local pageData = SQL.SyncFetch('SELECT id, start, end, duration FROM `mdt_duty_tracker` WHERE identifier = @identifier AND job = @job ORDER BY `id` DESC LIMIT @offset, @entries', {
                ['identifier'] = identifier,
                ['offset'] = offset,
                ['entries'] = entriesPerPage,
                ['job'] = job
            })

            if getTotalPages then
                local totalPages = SQL.SyncFetch('SELECT COUNT(*) FROM `mdt_duty_tracker` WHERE identifier = @identifier AND job = @job', { ['identifier'] = identifier, ['job'] = job })
                totalPages = totalPages[1] ~= nil and totalPages[1]['COUNT(*)'] or 0
                totalPages = math.ceil(totalPages / entriesPerPage)
                return {
                    totalPages = totalPages,
                    pageData = pageData
                }
            else
                return {
                    pageData = pageData
                }
            end
        end,
        FetchStatistics = function(identifier, job)
            return SQL.SyncFetch('SELECT start, duration FROM `mdt_duty_tracker` WHERE identifier = @identifier AND job = @job', {
                ['identifier'] = identifier,
                ['job'] = job
            })
        end,
        FetchJobStatistics = function(identifier, job, date)
            return SQL.SyncFetch('SELECT start, duration FROM `mdt_duty_tracker` WHERE identifier = @identifier AND job = @job AND start > @date ORDER BY `id` DESC', {
                ['identifier'] = identifier,
                ['date'] = date,
                ['job'] = job
            })
        end,
    },

    profiles = {
        Register = function(identifier, firstName, lastName, dob, sex, photoId, contact, notes)
            SQL.AsyncExecute('INSERT INTO `mdt_char_profiles` (identifier, firstName, lastName, dob, sex, photoId, contact, notes) VALUES (@identifier, @firstName, @lastName, @dob, @sex, @photoId, @contact, @notes)',
            {
                ['identifier']  = identifier,
                ['firstName']   = firstName,
                ['lastName']    = lastName,
                ['dob']         = dob,
                ['sex']         = sex,
                ['photoId']     = photoId,
                ['contact']     = contact,
                ['notes']       = notes,
            },
            function(affectedRows)
            end)
        end,
        Update = function(identifier, photoId, contact, notes)
            local query = false

            if photoId and contact and notes then
                query = 'UPDATE `mdt_char_profiles` SET photoId = @photoId, contact = @contact, notes = @notes WHERE identifier = @identifier'
            elseif photoId then
                query = 'UPDATE `mdt_char_profiles` SET photoId = @photoId WHERE identifier = @identifier'
            elseif contact then
                query = 'UPDATE `mdt_char_profiles` SET contact = @contact WHERE identifier = @identifier'
            elseif notes then
                query = 'UPDATE `mdt_char_profiles` SET notes = @notes WHERE identifier = @identifier'
            end

            if query then
                SQL.AsyncExecute(query,
                {
                    ['identifier'] = identifier,
                    ['photoId']     = photoId,
                    ['contact']     = contact,
                    ['notes']       = notes,
                },
                function(affectedRows)
                end)
            end
        end,
        FetchByIdentifier = function(identifier)
            local resp = SQL.SyncFetch('SELECT * FROM `mdt_char_profiles` WHERE identifier = @identifier', {['identifier'] = identifier})[1]
            if resp then
                resp.contact = json.decode(resp.contact)
            end

            return resp
        end,
        FetchByName = function(firstName, lastName, gender)
            local firstNameMatches; local lastNameMatches
            firstName = string.lower(firstName); lastName = string.lower(lastName)

            if gender then
                firstNameMatches = SQL.SyncFetch('SELECT * FROM `mdt_char_profiles` WHERE firstName LIKE @firstName AND sex = @gender', {
                    ['firstName'] = '%'..firstName..'%',
                    ['gender'] = gender,
                })
                lastNameMatches = SQL.SyncFetch('SELECT * FROM `mdt_char_profiles` WHERE lastName LIKE @lastName AND sex = @gender', {
                    ['lastName'] = '%'..lastName..'%',
                    ['gender'] = gender,
                })
            else
                firstNameMatches = SQL.SyncFetch('SELECT * FROM `mdt_char_profiles` WHERE firstName LIKE @firstName', {
                    ['firstName'] = '%'..firstName..'%',
                })
                lastNameMatches = SQL.SyncFetch('SELECT * FROM `mdt_char_profiles` WHERE lastName LIKE @lastName', {
                    ['lastName'] = '%'..lastName..'%',
                })
            end

            local finalResults = {}

            for i=1, #firstNameMatches do
                table.insert(finalResults, firstNameMatches[i])
            end

            for i=1, #lastNameMatches do
                local duplicateFound = false
                for index=1, #finalResults do
                    if lastNameMatches[i].identifier == finalResults[index].identifier then
                        duplicateFound = true
                        break
                    end
                end

                if not duplicateFound then
                    table.insert(finalResults, lastNameMatches[i])
                end
            end

            return finalResults
        end,
    },

    fines = {
        Add = function(identifier, fine, reference, date, dueDate)
            SQL.AsyncExecute('INSERT INTO `mdt_fines` (identifier, fine, reference, date, due_date) VALUES (@identifier, @fine, @reference, @date, @dueDate)',
            {
                ['identifier']  = identifier,
                ['fine']        = fine,
                ['reference']   = reference,
                ['date']        = date,
                ['dueDate']     = dueDate,
            },
            function(affectedRows)
            end)
        end,
        Update = function(id, fine, dueDate, paid)
            local query = false

            if fine then
                query = 'UPDATE `mdt_fines` SET fine = @fine WHERE id = @id'
            elseif dueDate then
                query = 'UPDATE `mdt_fines` SET due_date = @dueDate WHERE id = @id'
            elseif paid then
                query = 'UPDATE `mdt_fines` SET paid = @paid WHERE id = @id'
                paid = 1
            end

            if query then
                SQL.AsyncExecute(query,
                {
                    ['id']   = id,
                    ['fine'] = fine,
                    ['dueDate'] = dueDate,
                    ['paid'] = paid,
                },
                function(affectedRows)
                end)
            end
        end,
        FetchAll = function(identifier)
            return SQL.SyncFetch('SELECT * FROM `mdt_fines` WHERE identifier = @identifier', {['identifier'] = identifier})
        end,
        FetchAllUnpaid = function(identifier, onlyOverdue)
            if onlyOverdue then
                local currentDate = os.time() * 1000

                return SQL.SyncFetch('SELECT id, fine FROM `mdt_fines` WHERE identifier = @identifier and paid = 0 and (due_date - @currentDate) <= 0', {
                    ['identifier'] = identifier,
                    ['currentDate'] = currentDate,
                })
            else
                return SQL.SyncFetch('SELECT id, fine FROM `mdt_fines` WHERE identifier = @identifier and paid = 0', {['identifier'] = identifier})
            end
        end,
        Fetch = function(id)
            return SQL.SyncFetch('SELECT * FROM `mdt_fines` WHERE id = @id', {['id'] = id})[1]
        end,
    },

    crimRecord = {
        Add = function(identifier, type, submittedBy, description, input, data, date, cb)
            SQL.AsyncInsert('INSERT INTO `mdt_criminal_record` (identifier, type, description, input, data, date, submittedBy) VALUES (@identifier, @type, @description, @input, @data, @date, @submittedBy)',
            {
                ['identifier']   = identifier,
                ['type']         = type,
                ['description']  = description,
                ['input']        = input,
                ['data']         = json.encode(data),
                ['date']         = date,
                ['submittedBy']  = submittedBy,
            },
            function(insertId)
                cb(insertId)
            end)
        end,
        Update = function(id, type, description, input, data, date)
            SQL.AsyncExecute('UPDATE `mdt_criminal_record` SET type = @type, description = @description, input = @input, data = @data, date = @date WHERE id = @id',
            {
                ['id']          = id,
                ['type']        = type,
                ['description'] = description,
                ['input']       = input,
                ['data']        = data,
                ['date']        = date,
            },
            function(affectedRows)
            end)
        end,
        Delete = function(id)
            SQL.AsyncExecute('DELETE FROM `mdt_criminal_record` WHERE `id` = @id', { ['id'] = id }, function(affectedRows) end)
        end,
        FetchAll = function(identifier)
            return SQL.SyncFetch('SELECT id, type, description, date FROM `mdt_criminal_record` WHERE identifier = @identifier', {['identifier'] = identifier})
        end,
        Fetch = function(id)
            local resp = SQL.SyncFetch('SELECT id, identifier, type, input, data, date FROM `mdt_criminal_record` WHERE id = @id', {['id'] = id})[1]
            resp.input = json.decode(resp.input)
            resp.data = json.decode(resp.data)
            return resp
        end,
        FetchRecentReports = function(identifier)
            return SQL.SyncFetch('SELECT id, type, description FROM `mdt_criminal_record` WHERE submittedBy = @submittedBy ORDER BY `id` DESC LIMIT 10', {['submittedBy'] = identifier})
        end,
        FetchAllWithFilter = function(page, getTotalPages, search)
            local entriesPerPage = 15
            local offset = entriesPerPage * (page - 1)

            local query = 'SELECT id, type, description, input, date FROM `mdt_criminal_record` ORDER BY `id` DESC LIMIT @offset, @entries'
            local totalPagesQuery = 'SELECT COUNT(*) FROM `mdt_criminal_record`'

            if search then
                query = 'SELECT id, type, description, input, date FROM `mdt_criminal_record` WHERE'
                totalPagesQuery = 'SELECT COUNT(*) FROM `mdt_criminal_record` WHERE'

                if search.id then
                    local queryAddition = ' id = @id'
                    query = query .. queryAddition
                    totalPagesQuery = totalPagesQuery .. queryAddition
                end

                if search.submittedBy then
                    if search.id then
                        local queryAddition = ' AND'
                        query = query .. queryAddition
                        totalPagesQuery = totalPagesQuery .. queryAddition
                    end

                    local queryAddition = ' submittedBy = @submittedBy'
                    query = query .. queryAddition
                    totalPagesQuery = totalPagesQuery .. queryAddition
                end

                if search.type then
                    if search.id or search.submittedBy then
                        local queryAddition = ' AND'
                        query = query .. queryAddition
                        totalPagesQuery = totalPagesQuery .. queryAddition
                    end

                    local queryAddition = ' type = @type'
                    query = query .. queryAddition
                    totalPagesQuery = totalPagesQuery .. queryAddition
                end

                query = query .. ' ORDER BY `id` DESC LIMIT @offset, @entries'
            end

            local pageData = {}
            pageData = SQL.SyncFetch(query, {
                ['id']          = search and search.id or false,
                ['submittedBy'] = search and search.submittedBy or false,
                ['type']        = search and search.type or false,

                ['offset'] = offset,
                ['entries'] = entriesPerPage,
            })

            if getTotalPages then
                local totalPages = SQL.SyncFetch(totalPagesQuery, {
                    ['id']          = search and search.id or false,
                    ['submittedBy'] = search and search.submittedBy or false,
                    ['type']        = search and search.type or false,
                })
                totalPages = totalPages[1] and totalPages[1]['COUNT(*)'] or 0
                totalPages = math.ceil(totalPages / entriesPerPage)
                return {
                    totalPages = totalPages,
                    pageData = pageData
                }
            else
                return {
                    pageData = pageData
                }
            end
        end,
    },

    vehProfiles = {
        Register = function(plate, color, photoId, notes)
            SQL.AsyncExecute('INSERT INTO `mdt_veh_profiles` (plate, model, color, photoId, notes) VALUES (@plate, @model, @color, @photoId, @notes)',
            {
                ['plate']       = plate,
                ['model']       = '',
                ['color']       = color,
                ['photoId']     = photoId,
                ['notes']       = notes,
            },
            function(affectedRows)
            end)
        end,
        Update = function(plate, model, color, photoId, notes)
            local query = false

            if model and color then
                query = 'UPDATE `mdt_veh_profiles` SET model = @model, color = @color WHERE plate = @plate'
            elseif photoId then
                query = 'UPDATE `mdt_veh_profiles` SET photoId = @photoId WHERE plate = @plate'
            elseif notes then
                query = 'UPDATE `mdt_veh_profiles` SET notes = @notes WHERE plate = @plate'
            end

            if query then
                SQL.AsyncExecute(query,
                {
                    ['plate']       = plate,
                    ['model']       = model,
                    ['color']       = color,
                    ['photoId']     = photoId,
                    ['notes']       = notes,
                },
                function(affectedRows)
                end)
            end
        end,
        Fetch = function(plate)
            return SQL.SyncFetch('SELECT * FROM `mdt_veh_profiles` WHERE plate = @plate', {['plate'] = plate})[1]
        end,
    },
}
onlineUsers = {}

function TriggerProtFunction(name, source, func, ...)
    local status, error = pcall(func, source, ...)

    if not status then
        --[[
        print(('^3[al_mdt] ERROR: An error occured while executing "%s" (server)^7'):format(name))
        TriggerClientEvent('al_mdt:Print', source, ('There was an error while executing "%s"'):format(name))
        ]]
        print(error)
    end
end

function RegisterCallback(name, cb)
    Callbacks[name] = cb
end

function DeepPrint (e)
    if type(e) == "table" then
        for k,v in pairs(e) do
            print("-> "..k)
            DeepPrint(v)
        end
    else
        print(e)
    end
end

function TriggerCallback(name, requestId, source, cb, ...)
	if Callbacks[name] then
		TriggerProtFunction(name, source, Callbacks[name], cb, ...)
	else
        print(('^3[al_mdt] Server callback "%s" does not exist^7'):format(name))
	end
end

RegisterNetEvent('al_mdt:TriggerServerCallback', function(name, requestId, ...)
    local playerId = source

	TriggerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('al_mdt:ServerCallback', playerId, requestId, ...)
	end, ...)
end)
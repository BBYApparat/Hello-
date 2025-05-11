-- Profiles (People) --
function RegisterProfile(identifier, firstName, lastName, dob, sex, photoId, contact, notes) -- Register new civ profile
    if identifier ~= nil and firstName ~= nil and lastName ~= nil and dob ~= nil and sex ~= nil then
        DbQueries.profiles.Register(identifier, firstName, lastName, dob, sex, photoId, contact, notes)
    end
end
RegisterNetEvent('al_mdt:RegisterProfile', function(...)
    TriggerProtFunction('RegisterProfile', source, function(src, key, ...)
        if VerifyKey(src, key) then
            RegisterProfile(...)
        end
    end, ...)
end)

function UpdateProfile(src, identifier, photoId, contact, notes) -- Update profile
    if identifier ~= nil then
        DbQueries.profiles.Update(identifier, photoId, contact and json.encode(contact) or false, notes)
        ProfileUpdatedAlert(src, 'civ', identifier)
    end
end
RegisterNetEvent('al_mdt:UpdateProfile', function(...)
    TriggerProtFunction('UpdateProfile', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateProfile(src, ...)
        end
    end, ...)
end)

function FetchDetailedProfile(identifier) -- Fetch detailed profile by identifier
    if identifier ~= nil then
        local profile = DbQueries.profiles.FetchByIdentifier(identifier)

        if profile then
            profile.licenses = FetchCharacterLicenses(identifier)
            profile.record = FetchRecord(identifier)
            profile.fines = FetchFines(identifier)
            profile.vehicles = DbQueries.characters.FetchOwnedVehicles(identifier)

            return profile
        else
            local char = FetchCharacter(identifier)

            if char then
                -- Register profile
                RegisterProfile(
                    char.identifier,
                    char.firstName,
                    char.lastName,
                    char.dob,
                    char.sex,
                    char.photoId,
                    json.encode(char.contact),
                    char.notes
                )

                char.licenses = FetchCharacterLicenses(identifier)
                char.record = FetchRecord(identifier)
                char.fines = FetchFines(identifier)
                char.vehicles = DbQueries.characters.FetchOwnedVehicles(identifier)

                return char
            else
                return false
            end
        end
    else
        return false
    end
end
RegisterCallback('al_mdt:FetchDetailedProfile', function(source, ...)
    TriggerProtFunction('FetchDetailedProfile', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchDetailedProfile(...))
        end
    end, ...)
end)

function FetchProfilesByName(firstName, lastName, gender) -- Fetch profile by name and gender filter
    if firstName ~= nil and lastName ~= nil then
        local profiles = DbQueries.profiles.FetchByName(firstName, lastName, gender) -- Profile search
        local chars = FetchCharactersByName(firstName, lastName, gender) -- Character search
        local finalResult = {}

        for i=1, #chars do
            local char = chars[i]
            local profileFound = false

            for index =1, #profiles do
                local profile = profiles[index]

                if profile.identifier == char.identifier then -- If profile found, insert profile data
                    table.insert(finalResult, profile)
                    profileFound = true
                    break
                end
            end

            if not profileFound then -- If no profile found, insert char data
                table.insert(finalResult, char)
            end
        end

        return finalResult
    else
        return false
    end
end
RegisterCallback('al_mdt:FetchProfilesByName', function(source, ...)
    TriggerProtFunction('FetchProfilesByName', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchProfilesByName(...))
        end
    end, ...)
end)

-- Profiles (Vehicles) --
function RegisterVehProfile(plate, color, photoId, notes) -- Register new veh profile
    if plate and color and photoId and notes then
        DbQueries.vehProfiles.Register(plate, color, photoId, notes)
    end
end
RegisterNetEvent('al_mdt:RegisterVehProfile', function(...)
    TriggerProtFunction('RegisterVehProfile', source, function(src, key, ...)
        if VerifyKey(src, key) then
            RegisterVehProfile(...)
        end
    end, ...)
end)

function UpdateVehProfile(src, plate, model, color, photoId, notes) -- Update veh profile
    if plate then
        DbQueries.vehProfiles.Update(plate, model, color, photoId, notes)
        ProfileUpdatedAlert(src, 'veh', plate)
    end
end
RegisterNetEvent('al_mdt:UpdateVehProfile', function(...)
    TriggerProtFunction('UpdateVehProfile', source, function(src, key, ...)
        if VerifyKey(src, key) then
            UpdateVehProfile(src, ...)
        end
    end, ...)
end)

function FetchVehProfile(plate) -- Fetch veh profile by plate
    if plate then
        local profile = DbQueries.vehProfiles.Fetch(plate)
        local vehOwner = DbQueries.characters.FetchVehicleOwnerByPlate(plate)

        if profile and vehOwner then -- Profile found
            profile.ownerIdentifier = vehOwner

            if profile.ownerIdentifier then
                profile.owner = DbQueries.characters.FetchByIdentifier(profile.ownerIdentifier)
                return profile
            end
        elseif not profile and vehOwner then -- Profile not found
            DbQueries.vehProfiles.Register(plate, '', '', '')
            Citizen.Wait(100)
            profile = DbQueries.vehProfiles.Fetch(plate) or {plate = plate, model = '', color = '', photoId = '', notes = ''}
            profile.ownerIdentifier = vehOwner

            if profile.ownerIdentifier then
                profile.owner = DbQueries.characters.FetchByIdentifier(profile.ownerIdentifier)
                return profile
            end
        end
    end

    return false
end
RegisterCallback('al_mdt:FetchVehProfile', function(source, ...)
    TriggerProtFunction('FetchVehProfile', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchVehProfile(...))
        end
    end, ...)
end)

function FetchVehiclePlates(plate) -- Fetch vehicles by plate match
    if plate then
        return DbQueries.vehProfiles.FetchVehicles(plate)
    end

    return false
end
RegisterCallback('al_mdt:FetchVehiclePlates', function(source, ...)
    TriggerProtFunction('FetchVehiclePlates', source, function(src, cb, key, ...)
        if VerifyKey(src, key) then
            cb(FetchVehiclePlates(...))
        end
    end, ...)
end)
function SendToDiscord(src, name, message, color, webhook, footer)
    if not Config.DiscordLogs.enabled then return end
    local embeds = {{
        title = message,
        type = "rich",
        color = color,
        footer = {},
    }}

    if footer then
        local playerName = GetPlayerName(src)
        if playerName then
            footer = footer..('\nPlayer name: %s [ID: %s]'):format(playerName, src)
        end

        embeds[1].footer.text = footer
    else
        local playerName = GetPlayerName(src)
        if playerName then
            footer = ('Player name: %s [ID: %s]'):format(playerName, src)
            embeds[1].footer.text = footer
        end
    end
    if message == nil or message == '' then return false end 

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

-- Alerts --
function BoloAddedAlert(src, type, creator, name)
    if type == 'warrant' then
        SendToDiscord(src, 'Warrant created', ('Warrant placed on %s'):format(name), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('Creator: [%s]'):format(creator))
    elseif type == 'vehicle' then
        local plate = name
        SendToDiscord(src, 'Bolo created [Vehicle]', ('Bolo placed on plate [%s]'):format(plate), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('Creator: [%s]'):format(creator))
    elseif type == 'person' then
        SendToDiscord(src, 'Bolo created [Person]', ('Bolo placed on %s'):format(name), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('Creator: [%s]'):format(creator))
    end
end

function BoloUpdatedAlert(src, type, id, name)
    if type == 'warrant' then
        SendToDiscord(src, 'Warrant updated', ('Warrant with ID [%s] has been updated'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('Warrant for: [%s]'):format(name))
    elseif type == 'vehicle' then
        local plate = name
        SendToDiscord(src, 'Bolo updated [Vehicle]', ('Bolo with ID [%s] has been updated'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('BOLO for: [%s]'):format(plate))
    elseif type == 'person' then
        SendToDiscord(src, 'Bolo updated [Person]', ('Bolo with ID [%s] has been updated'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos, ('BOLO for: [%s]'):format(name))
    end
end

function BoloDeletedAlert(src, type, id)
    if type == 'warrant' then
        SendToDiscord(src, 'Warrant deleted', ('Warrant with ID [%s] has been deleted'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos)
    elseif type == 'vehicle' then
        SendToDiscord(src, 'Bolo deleted [Vehicle]', ('Vehicle bolo with ID [%s] has been deleted'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos)
    elseif type == 'person' then
        SendToDiscord(src, 'Bolo deleted [Person]', ('Bolo with ID [%s] has been deleted'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.bolos)
    end
end

function RevokedLicenseAlert(src, identifier, license)
    SendToDiscord(src, 'License revoked', ('License [%s] has been revoked from ID [%s]'):format(license, identifier), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.licenses)
end

function GrantedLicenseAlert(src, id, license)
    SendToDiscord(src, 'License granted', ('License [%s] has been granted to ID [%s]'):format(license, id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.licenses)
end

function FinePayedAlert(src, id, fine)
    SendToDiscord(src, 'Fine payed', ('A $%s fine was payed'):format(fine), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.fines, ('Fine ID: %s'):format(id))
end

function FineExemptedAlert(src, id)
    SendToDiscord(src, 'Fine exempted', ('Fine ID [%s] has been exempted'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.fines)
end

function ProfileUpdatedAlert(src, type, name)
    if type == 'veh' then
        local plate = name
        SendToDiscord(src, 'Vehicle profile updated', ('Vehicle profile [%s] has been updated'):format(plate), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.profiles)
    elseif type == 'civ' then
        SendToDiscord(src, 'Profile updated', ('Profile [%s] has been updated'):format(name), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.profiles)
    end
end

function ReportAddedAlert(src, type, reportId, identifier, fines)
    if type == 'Incident' then
        SendToDiscord(src, 'Incident report added', ('Incident report ID [%s] has been submitted'):format(reportId), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.reports, ('Recipient: %s\nFines: %s'):format(identifier, fines))
    else
        SendToDiscord(src, 'Arrest report added', ('Arrest report ID [%s] has been submitted'):format(reportId), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.reports, ('Recipient: %s\nFines: %s'):format(identifier, fines))
    end
end

function ReportUpdatedAlert(src, type, id)
    if type == 'Incident' then
        SendToDiscord(src, 'Incident report updated', ('Incident report with ID [%s] has been updated'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.reports)
    else
        SendToDiscord(src, 'Arrest report updated', ('Arrest report with ID [%s] has been updated'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.reports)
    end
end

function ReportDeletedAlert(src, id)
    SendToDiscord(src, 'Report deleted', ('Report with ID [%s] has been deleted'):format(id), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.reports)
end

function UserRegisteredAlert(src, identifier, job)
    SendToDiscord(src, 'New user registered', ('User [%s] has been registered with [%s] permissions'):format(identifier, job), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.users)
end

function DutyAlert(src, state, identifier, job)
    if state then
        SendToDiscord(src, 'Clocked in', ('User [%s] as [%s] has clocked in'):format(identifier, job), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.users)
    else
        SendToDiscord(src, 'Clocked out', ('User [%s] as [%s] has clocked out'):format(identifier, job), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.users)
    end
    
end

function DutyEntryAlert(src, identifier, job, startShift, endShift)
    local shiftDuration = (endShift - startShift) / 1000
    local hours = math.floor((shiftDuration%86400)/3600)
    local minutes = math.floor((shiftDuration%3600)/60)
    local seconds = math.floor(shiftDuration%60)
    shiftDuration = string.format("Hours: %02d Minutes: %02d Seconds: %02d", hours, minutes, seconds)

    SendToDiscord(src, 'New duty entry', ('User [%s] as [%s] has completed a shift'):format(identifier, job), Config.DiscordLogs.colors.orange, Config.DiscordLogs.webhooks.users, ('Duration: %s'):format(shiftDuration))
end
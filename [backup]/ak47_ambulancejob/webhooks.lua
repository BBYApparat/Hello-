ScreenshotWebhook   = ' webhooks/1263550582438760468/kj3KnFrdrBVT371VvFOQjRI39akBifEw-Nq-fXP29frWi8gA14WOckHgCc0CwvwQa1-z' --Discord webhook link
DownLogWebhook      = ' webhooks/1263550582438760468/kj3KnFrdrBVT371VvFOQjRI39akBifEw-Nq-fXP29frWi8gA14WOckHgCc0CwvwQa1-z' --Discord webhook link
DeathLogWebhook     = ' webhooks/1263550582438760468/kj3KnFrdrBVT371VvFOQjRI39akBifEw-Nq-fXP29frWi8gA14WOckHgCc0CwvwQa1-z' --Discord webhook link

function CreateLog(source, data, type)
    message = {
        embeds = {{
            ["color"] = Config.Color,
            ["title"] = Config.Title,
            ["description"] = data.reason,
            ["footer"] = {
                ["text"] = Config.FooterText.." • "..os.date("%x %X %p"),
                ["icon_url"] = Config.ServerIconUrl,
            },
        }},
        avatar_url = Config.AvatarUrl
    }

    if source then
        Player_Details = GetPlayerDetails(source)
        if GetPlayerName(source) then
            message['embeds'][1].fields = {
                {
                    ["name"] = "Player Name: "..GetPlayerName(source),
                    ["value"] = Player_Details,
                    ["inline"] = true,
                }
            }
        else
            message['embeds'][1].fields = {
                {
                    ["name"] = "Player Name: N/A",
                    ["value"] = "N/A - Could not get the player's info.",
                    ["inline"] = true
                }
            }
        end
        message['embeds'][1].fields[2]  = {
            ["name"] = "Timestamp:",
            ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
            ["inline"] = false
        }
    end
    if data.killer then
        Player_2_Details = GetPlayerDetails(data.killer)
        message['embeds'][1].fields[2]  = {
            ["name"] = "Player Name: "..GetPlayerName(data.killer),
            ["value"] = Player_2_Details,
            ["inline"] = true,
        }
        message['embeds'][1].fields[3]  = {
            ["name"] = "Timestamp:",
            ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
            ["inline"] = false
        }
    end

    if not message['embeds'][1].fields then
        message['embeds'][1].fields = {
            {
                ["name"] = "Timestamp:",
                ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
                ["inline"] = false
            }
        }
    end

    if not data.killerimg then
        if data.myimg then
            message['embeds'][1].image = {
                ["url"] = data.myimg
            }
        end
    else
        if data.killerimg then
            message['embeds'][1].image = {
                ["url"] = data.killerimg
            }
        end
        if data.myimg then
            message['embeds'][1].thumbnail = {
                ["url"] = data.myimg
            }
        end
    end

    local webhook = type == 'down' and DownLogWebhook or DeathLogWebhook
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode(message), {
        ['Content-Type'] = 'application/json'
    })
end

function GetPlayerDetails(src)
    local ids = ExtractIdentifiers(src)

    if Config.LogData.discordId then
        if ids.discord then
            _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "").."> ("..ids.discord:gsub("discord:", "")..")"
        else
            _discordID = "\n**Discord ID:** N/A"
        end
    else
        _discordID = ""
    end

    if GetConvar("steam_webApiKey", "false") ~= 'false' then
        if Config.LogData.steamId then
            if ids.steam then
                _steamID ="\n**Steam ID:** " ..ids.steam..""
            else
                _steamID = "\n**Steam ID:** N/A"
            end
        else
            _steamID = ""
        end

        if Config.LogData.steamUrl then
            if ids.steam then
                _steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""
            else
                _steamURL = "\n**Steam URL:** N/A"
            end
        else
            _steamURL = ""
        end
    else
        _steamID = ""
        _steamURL = ""
    end

    if Config.LogData.license then
        if ids.license then
            _license ="\n**License:** " ..ids.license
        else
            _license = "\n**License:** N/A"
        end
    else
        _license = ""
    end

    if Config.LogData.license2 then
        if ids.license2 then
            _license2 ="\n**License 2:** " ..ids.license2
        else
            _license2 = "\n**License 2:** N/A"
        end
    else
        _license2 = ""
    end

    if Config.LogData.ip then
        if ids.ip then
            _ip ="\n**IP:** " ..ids.ip:gsub("ip:", "")
        else
            _ip = "\n**IP:** N/A"
        end
    else
        _ip = ""
    end

    _playerID ="\n**Player ID:** " ..src..""

    return _playerID.._discordID.._steamID.._steamURL.._license.._license2.._ip
end

function ExtractIdentifiers(src)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "ip:") then
            identifiers['ip'] = id
        elseif string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "license:") then
            identifiers['license'] = id
        elseif string.find(id, "license2:") then
            identifiers['license2'] = id
        elseif string.find(id, "xbl:") then
            identifiers['xbl'] = id
        elseif string.find(id, "live:") then
            identifiers['live'] = id
        elseif string.find(id, "fivem:") then
            identifiers['fivem'] = id
        end
    end
    return identifiers
end
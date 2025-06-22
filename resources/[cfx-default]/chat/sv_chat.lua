RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

local OOC_RANGE = 20.0 -- Range in meters for local OOC messages
local ENABLE_DISCORD_LOGGING = true -- Set to false to disable Discord logging
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1386254857907867680/Wi35ilenpKLunWF5tFqXHwxNxALryhmhppFR-FqTrzf0tv4CKPY5YfnY9jROTURThlzx"

-- Discord logging function
local function sendToDiscord(messageType, playerName, playerId, message, recipients)
    if not ENABLE_DISCORD_LOGGING then return end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local recipientInfo = ""
    local color = 0x00ff00 -- Default green
    
    if messageType == "OOC" and recipients then
        recipientInfo = string.format("Recipients: %d nearby players", #recipients)
        color = 0x3498db -- Blue for local OOC
    elseif messageType == "GOOC" then
        recipientInfo = "Global OOC message"
        color = 0xe74c3c -- Red for global OOC
    elseif messageType == "CHAT" then
        recipientInfo = "Regular chat message"
        color = 0x95a5a6 -- Gray for regular chat
    end
    
    local embed = {
        {
            title = string.format("%s Message", messageType),
            description = string.format("**Player:** %s (ID: %s)\n**Message:** %s\n**Info:** %s", 
                playerName, playerId, message, recipientInfo),
            color = color,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {
                text = "FiveM Chat System"
            }
        }
    }
    
    local payload = {
        username = "Chat Logger",
        embeds = embed
    }
    
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers)
        if err ~= 200 then
            print("Failed to send Discord webhook: " .. tostring(err))
        end
    end, 'POST', json.encode(payload), {['Content-Type'] = 'application/json'})
end

-- Function to get nearby players
local function getNearbyPlayers(sourcePlayer, range)
    local sourcePed = GetPlayerPed(sourcePlayer)
    local sourceCoords = GetEntityCoords(sourcePed)
    local nearbyPlayers = {}
    
    for _, playerId in ipairs(GetPlayers()) do
        if playerId ~= tostring(sourcePlayer) then
            local targetPed = GetPlayerPed(tonumber(playerId))
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(sourceCoords - targetCoords)
            
            if distance <= range then
                table.insert(nearbyPlayers, tonumber(playerId))
            end
        end
    end
    
    -- Always include the sender
    table.insert(nearbyPlayers, sourcePlayer)
    return nearbyPlayers
end

-- Register OOC command (Local Out of Character)
RegisterCommand('ooc', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    local playerName = GetPlayerName(source)
    
    if not message or message == '' then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message system"><div class="chat-message-body"><strong>System:</strong> Usage: /ooc [message]</div></div>',
            args = {}
        })
        return
    end
    
    -- Get nearby players
    local nearbyPlayers = getNearbyPlayers(source, OOC_RANGE)
    
    -- Send message to nearby players
    for _, playerId in ipairs(nearbyPlayers) do
        TriggerClientEvent('chat:addMessage', playerId, {
            template = '<div class="chat-message ooc"><div class="chat-message-body"><strong>[Local OOC] {0}:</strong> {1}</div></div>',
            args = {playerName, message}
        })
    end
    
    -- Log to Discord
    sendToDiscord("OOC", playerName, source, message, nearbyPlayers)
    
end, false)

-- Register GOOC command (Global Out of Character)
RegisterCommand('gooc', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    local playerName = GetPlayerName(source)
    
    if not message or message == '' then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message system"><div class="chat-message-body"><strong>System:</strong> Usage: /gooc [message]</div></div>',
            args = {}
        })
        return
    end
    
    -- Send message to all players
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message gooc"><div class="chat-message-body"><strong>[Global OOC] {0}:</strong> {1}</div></div>',
        args = {playerName, message}
    })
    
    -- Log to Discord
    sendToDiscord("GOOC", playerName, source, message, nil)
    
end, false)

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        --TriggerClientEvent('chatMessage', -1, 'OOC | '..author,  false, message)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, false, '/' .. command) 
    end

    CancelEvent()
end)

-- player join messages
AddEventHandler('chat:init', function()
    local playerName = GetPlayerName(source)
    
    -- Add command suggestions for new players
    TriggerClientEvent('chat:addSuggestion', source, '/ooc', 'Send a local out of character message', {
        { name = "message", help = "Your OOC message" }
    })
    TriggerClientEvent('chat:addSuggestion', source, '/gooc', 'Send a global out of character message', {
        { name = "message", help = "Your global OOC message" }
    })
    
    -- Log player join to Discord
    sendToDiscord("SYSTEM", "Server", "SYSTEM", playerName .. " joined the server", nil)
end)


AddEventHandler('playerDropped', function(reason)
    local playerName = GetPlayerName(source)
    
    -- Log player leave to Discord
    sendToDiscord("SYSTEM", "Server", "SYSTEM", playerName .. " left the server (" .. reason .. ")", nil)
end)
-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    if resName == GetCurrentResourceName() then
        Wait(500)
        
        -- Add command suggestions for all players
        for _, player in ipairs(GetPlayers()) do
            TriggerClientEvent('chat:addSuggestion', player, '/ooc', 'Send a local out of character message', {
                { name = "message", help = "Your OOC message" }
            })
            TriggerClientEvent('chat:addSuggestion', player, '/gooc', 'Send a global out of character message', {
                { name = "message", help = "Your global OOC message" }
            })
        end
    end
end)

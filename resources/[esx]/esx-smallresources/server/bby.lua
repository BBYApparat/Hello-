-- -- server.lua - Place this in your FiveM resource folder
-- local Config = {
--     MaxPlayers = 64,             -- Maximum server slots
--     WebhookURL = "YOUR_WEBHOOK", -- For notifications/logging (optional)
--     QueueRefreshRate = 5000,     -- How often to refresh queue status (ms)
--     ServerName = "Your Server",  -- Your server name
--     ApiKey = "d8e7f45a9c3b2e16d0f9a8b7c6e5d4c3", -- Secret API key for website communication
--     Debug = true                 -- Enable debug logging
-- }

-- -- Queue State
-- local Queue = {}
-- local QueueCounts = {
--     connecting = 0,
--     waiting = 0,
--     total = 0
-- }
-- local ConnectedIdentifiers = {}
-- local WebQueueTokens = {}

-- -- Debug logging function
-- local function DebugLog(message)
--     if Config.Debug then
--         print("^3[QUEUE] ^7" .. tostring(message))
--     end
-- end

-- -- Format queue position message
-- local function FormatQueueMessage(position)
--     return string.format("You are in queue position %s\nServer: %s\nPlayers: %s/%s", 
--         position, Config.ServerName, GetNumPlayerIndices(), Config.MaxPlayers)
-- end

-- -- Utility function to get player identifiers
-- local function GetPlayerIdentifiers(source)
--     local identifiers = {}
--     for i = 0, GetNumPlayerIdentifiers(source) - 1 do
--         local id = GetPlayerIdentifier(source, i)
--         if id then
--             local split = string.match(id, "([^:]+):(.+)")
--             if split then
--                 local idType, idValue = string.match(id, "([^:]+):(.+)")
--                 identifiers[idType] = idValue
--             else
--                 -- Handle non-standard identifier format
--                 identifiers["raw_" .. i] = id
--             end
--         end
--     end
--     return identifiers
-- end

-- -- Get token from connection
-- local function GetConnectionToken(source)
--     -- Try to get token from regular identifiers
--     local identifiers = GetPlayerIdentifiers(source)
--     local token = nil
    
--     -- Look for token in identifiers
--     for k, v in pairs(identifiers) do
--         if k == "token" or k == "fivem" then
--             token = v
--             break
--         end
--     end
    
--     -- If no token found, try to get it from the connect string
--     if not token then
--         -- Try direct token access if available
--         for i = 0, 1 do -- Try first two tokens
--             local playerToken = GetPlayerToken(source, i)
--             if playerToken then
--                 token = playerToken
--                 break
--             end
--         end
        
--         -- Fallback: try to extract from endpoint if it's in the connection URL
--         if not token then
--             local endpoint = GetPlayerEndpoint(source)
--             if endpoint and string.find(endpoint, "token=") then
--                 token = string.match(endpoint, "token=([^&]+)")
--             end
--         end
--     end
    
--     return token
-- end

-- -- Remove player from queue
-- local function RemoveFromQueue(source)
--     for i, data in ipairs(Queue) do
--         if data.source == source then
--             table.remove(Queue, i)
--             UpdateQueueCount()
--             return true
--         end
--     end
--     return false
-- end

-- -- Update queue count
-- local function UpdateQueueCount()
--     local count = {
--         connecting = 0,
--         waiting = 0
--     }
    
--     for _, data in ipairs(Queue) do
--         if data.loading then
--             count.connecting = count.connecting + 1
--         else
--             count.waiting = count.waiting + 1
--         end
--     end
    
--     count.total = count.connecting + count.waiting
--     QueueCounts = count

--     -- Emit to client for UI updates
--     TriggerClientEvent("queue:updateClientCount", -1, QueueCounts)
-- end

-- -- Check if player is allowed to connect
-- AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
--     local source = source
--     local identifiers = GetPlayerIdentifiers(source)
    
--     DebugLog("Player connecting: " .. name)
--     DebugLog("Identifiers: " .. json.encode(identifiers))
    
--     -- Get token from connection
--     local token = GetConnectionToken(source)
--     DebugLog("Token found: " .. (token or "none"))
    
--     -- Check if player has a valid token from the website
--     if not token or not WebQueueTokens[token] then
--         DebugLog("Invalid token, rejecting connection")
--         deferrals.done("You must connect through our website at https://yourserver.com")
--         return
--     end
    
--     DebugLog("Valid token found, continuing connection")
    
--     -- Remove token to prevent reuse
--     local tokenData = WebQueueTokens[token]
--     WebQueueTokens[token] = nil
    
--     deferrals.defer()
--     deferrals.update("Checking queue status...")
    
--     Wait(500)
    
--     local position = #Queue + 1
--     local data = {
--         name = name,
--         source = source,
--         identifiers = identifiers,
--         priority = 0,
--         timestamp = os.time(),
--         loading = false,
--         deferrals = deferrals,
--         token = token,
--         tokenData = tokenData
--     }
    
--     table.insert(Queue, position, data)
--     UpdateQueueCount()
    
--     DebugLog("Player added to queue at position " .. position)
    
--     Citizen.CreateThread(function()
--         while true do
--             Citizen.Wait(Config.QueueRefreshRate)
            
--             local player = Queue[1]
--             if player and player.source == source then
--                 DebugLog("Player " .. name .. " is ready to connect")
--                 deferrals.update("Loading into server...")
--                 player.loading = true
--                 UpdateQueueCount()
                
--                 Wait(1000)
--                 deferrals.done()
--                 ConnectedIdentifiers[identifiers.license] = true
--                 Wait(2000)
--                 RemoveFromQueue(source)
--                 return
--             else
--                 for i, queuedPlayer in ipairs(Queue) do
--                     if queuedPlayer.source == source then
--                         queuedPlayer.position = i
--                         deferrals.update(FormatQueueMessage(i))
--                         break
--                     end
--                 end
--             end
--         end
--     end)
-- end)

-- -- Handle disconnects
-- AddEventHandler('playerDropped', function(reason)
--     local source = source
--     RemoveFromQueue(source)
    
--     local identifiers = GetPlayerIdentifiers(source)
--     if identifiers.license then
--         ConnectedIdentifiers[identifiers.license] = nil
--     end
    
--     -- Emit updated player count
--     TriggerClientEvent("queue:updateClientCount", -1, {
--         players = GetNumPlayerIndices(),
--         maxPlayers = Config.MaxPlayers
--     })
-- end)

-- -- API endpoint for website integration
-- RegisterNetEvent('queue:generateWebToken')
-- AddEventHandler('queue:generateWebToken', function(apiKey, identifier)
--     -- Verify API key
--     if apiKey ~= Config.ApiKey then
--         DebugLog("Invalid API key in generateWebToken request")
--         return
--     end
    
--     -- Generate a random token
--     local token = string.format("%x%x%x%x", 
--         math.random(0, 0xffff), math.random(0, 0xffff),
--         math.random(0, 0xffff), math.random(0, 0xffff))
    
--     -- Store token with associated identifier
--     WebQueueTokens[token] = {
--         identifier = identifier,
--         timestamp = os.time()
--     }
    
--     DebugLog("Generated token for " .. identifier .. ": " .. token)
--     return token
-- end)

-- -- API endpoint to get server stats
-- RegisterNetEvent('queue:getServerStats')
-- AddEventHandler('queue:getServerStats', function(apiKey)
--     -- Verify API key
--     if apiKey ~= Config.ApiKey then
--         DebugLog("Invalid API key in getServerStats request")
--         return
--     end
    
--     return {
--         players = GetNumPlayerIndices(),
--         maxPlayers = Config.MaxPlayers,
--         queue = QueueCounts
--     }
-- end)

-- -- Clean up expired tokens
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(60000) -- Every minute
--         local currentTime = os.time()
--         local expiredCount = 0
        
--         -- Remove tokens older than 30 minutes
--         for token, data in pairs(WebQueueTokens) do
--             if currentTime - data.timestamp > 1800 then
--                 WebQueueTokens[token] = nil
--                 expiredCount = expiredCount + 1
--             end
--         end
        
--         if expiredCount > 0 then
--             DebugLog("Cleaned up " .. expiredCount .. " expired tokens")
--         end
--     end
-- end)

-- -- Initialize
-- Citizen.CreateThread(function()
--     SetGameType('Your Game Type')
--     SetMapName('Los Santos')
--     print("^2Queue system initialized^7")
--     DebugLog("Queue system started with API key: " .. Config.ApiKey)
-- end)
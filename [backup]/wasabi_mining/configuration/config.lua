-----------------For support, scripts, and more----------------
---------------  /wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.checkForUpdates = true -- Check for Updates?
Config.oldESX = false -- Does not apply to qb users (If set to true, won't check if player can carry item)

Config.axe = {
    prop = `prop_tool_pickaxe`,
    breakChance = 0
}

Config.rocks = { -- Items obtained from mining
    { item = 'copper', label = 'copper', price = {100, 100}, difficulty = {'medium', 'medium'}, chance = 15 },  -- Adjusted chance
    { item = 'silver', label = 'silver', price = {120, 120}, difficulty = {'medium'}, chance = 15 },            -- Adjusted chance
    { item = 'steel', label = 'steel', price = {130, 130}, difficulty = {'medium'}, chance = 15 },              -- New item added
    { item = 'aluminium', label = 'aluminium', price = {110, 110}, difficulty = {'medium', 'medium'}, chance = 10 },  -- New item added
    { item = 'scrap', label = 'scrap', price = {90, 90}, difficulty = {'medium'}, chance = 10 },                -- New item added
    { item = 'rubber', label = 'rubber', price = {95, 95}, difficulty = {'medium'}, chance = 10 },              -- New item added
    { item = 'glass', label = 'glass', price = {70, 70}, difficulty = {'easy'}, chance = 10 },                  -- New item added
    { item = 'plastic', label = 'plastic', price = {75, 75}, difficulty = {'easy'}, chance = 10 },              -- New item added
    { item = 'gold', label = 'gold', price = {150, 150}, difficulty = {'medium', 'easy'}, chance = 5 },         -- Unchanged chance
    { item = 'emerald', label = 'emerald', price = {200, 200}, difficulty = {'easy', 'easy'}, chance = 5 },     -- Unchanged chance
    { item = 'diamond', label = 'diamond', price = {500, 500}, difficulty = {'easy', 'easy'}, chance = 5 },    -- Unchanged chance
}

Config.miningAreas = {
    vec3(2977.45, 2741.62, 44.62), -- vec3 of locations for mining stones
    vec3(2982.64, 2750.89, 42.99),
    vec3(2994.92, 2750.43, 44.04),
    vec3(2958.21, 2725.44, 50.16),
    vec3(2946.3, 2725.36, 47.94),
    vec3(3004.01, 2763.27, 43.56),
    vec3(3001.79, 2791.01, 44.82)
}

Config.sellShop = {
    enabled = false, -- Enable spot to sell the things mined?
    coords = vec3(122.1, 6405.69, 31.36-0.9), -- Location of buyer
    heading = 314.65, -- Heading of ped
    ped = 'cs_joeminuteman' -- Ped name here
}

RegisterNetEvent('wasabi_mining:notify')
AddEventHandler('wasabi_mining:notify', function(title, message, msgType)	
    -- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    if not msgType then
        lib.notify({
            title = title,
            description = message,
            type = 'inform'
        })
    else
        lib.notify({
            title = title,
            description = message,
            type = msgType
        })
    end
end)

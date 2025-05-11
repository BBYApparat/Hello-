return {
    debug = false,
    core_name = "es_extended", -- Changed to ESX core name
    inventory = "ox", --or "default" for ESX default inventory
    target = "ox", --or "qtarget" for ESX
    policeNeededToSell = 0,
    lang = {
        ["blacklistzone"] = 'Blacklisted location!',
        ["tooclose"] = 'Too close to other graffiti!',
        ["options"] = '[BACKSPACE] - Cancel  \n [ENTER] - Confirm',
        ["nogang"] = 'You dont belong to any gang!',
        ["nograffiti"] = 'No graffiti nearby!',
        ["notifygang"] = 'One of your graffiti is being cleaned!',
        ["notifygangnpc"] = 'One of your locals are beeing robbed!',
        ["startselling"] = 'Start Selling',
        ["stopselling"] = 'Stop Selling',
        ["cantsellhere"] = 'You stopped selling!',
        ["startsellhere"] = 'You started selling!',
        ["selldrugs"] = 'Sell Drugs',
        ["nodrugs"] = 'You dont have what the buyer wants!',
        ["toomuchtime"] = 'The buyer got angry and left!',
        ["nocops"] = 'No cops!',
        ["checkrep"] = 'Talk to madrazo',
        ["robnpc"] = 'Rob',
        ["noweapon"] = 'You need a weapon in your hand!',
    },

    --amount of bags that you can sell in each ped
    sellDrugAmount = {min = 1, max = 7},

    --drug prices
    drugsPrices = {
        {name = "cokebaggy", min = 100, max = 150},
        {name = "meth", min = 100, max = 150},
        {name = "weed_ak47", min = 100, max = 150},
    },

    AlertPolice = function()
        --here you put your dispatch
        print("cops called")
        -- For ESX, you might want to use this:
        -- TriggerServerEvent('esx_phone:send', 'police', 'Suspicious activity spotted!', {x = coords.x, y = coords.y, z = coords.z})
    end,
}
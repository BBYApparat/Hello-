
local VIP = {}
local ESX = exports.es_extended:getSharedObject()
local defaultWeight, defaultSlots = GetConvar("inventory:weight", "25000"), GetConvar("inventory:slots", "25")

CreateThread(function()
    -- MySQL.query("DELETE FROM n_vip WHERE date < (NOW() - INTERVAL " .. Config.Options.daysBeforeExpire .. " DAY)", {})
    local delQuery = [[
        DELETE FROM n_vip
        WHERE (
            (expirePeriod = 'MONTH' AND date < DATE_SUB(NOW(), INTERVAL 1 MONTH))
            OR
            (expirePeriod = 'HALFMONTH' AND date < DATE_SUB(NOW(), INTERVAL 15 DAY))
        )
    ]]
    exports.oxmysql:execute(delQuery, {}, function(result)
        print(result.affectedRows .. " VIP records have been deleted.")
    end)
end)

function VIP.ImportPlayer(identifier, period)
    MySQL.insert('INSERT INTO n_vip (identifier, expirePeriod) VALUES (?, ?) ON DUPLICATE KEY UPDATE date = (NOW())', {identifier, period})
end

function VIP.RemovePlayer(identifier)
    MySQL.query("DELETE FROM n_vip WHERE `identifier` = ?", {identifier})
end

function VIP.IsVIP(identifier)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isVip = MySQL.Sync.fetchAll('SELECT `identifier` FROM n_vip WHERE `identifier` = ?', {xPlayer.identifier})
end

exports("VIP", function() return VIP end)

RegisterNetEvent('esx:playerLoaded', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local isVip = MySQL.Sync.fetchAll('SELECT `identifier` FROM n_vip WHERE `identifier` = ?', {xPlayer.identifier})
        if isVip[1] then
            xPlayer.setMeta('vip', 1)
            exports.ox_inventory:SetMaxWeight(xPlayer.source, tonumber(defaultWeight)+(Config.VIP.inventory.weight*1000))
            exports.ox_inventory:SetSlotCount(xPlayer.source, tonumber(defaultSlots)+Config.VIP.inventory.slots or 0)
        else
            xPlayer.setMeta('vip', 0)
        end
    end
end)

ESX.RegisterCommand('setvip', "admin", function(xPlayer, args)
    local _source = source
	local xTarget = args.playerId
    local xPlayer = xPlayer

    if xTarget then        
        local boolean = args.boolean:lower()

        if boolean == 'true' then
            if args.expirePeriod:upper() == "MONTH" or args.expirePeriod:upper() == "HALFMONTH" then
                VIP.ImportPlayer(xTarget.identifier, args.expirePeriod:upper() )
                xPlayer.showNotification(Lang("vip.enabled", {name = xTarget.name}), 'info', 5000)
                
                Wait(2500)
                
                local isVip, daysLeft, hoursLeft = CalculateVipDate(xPlayer.identifier)
                
                TriggerClientEvent('ox_lib:alertDialog', tonumber(args.playerId.source), {
                    header = Lang("vip.inform.title", {days = daysLeft, hours = hoursLeft}),
                    content = Lang("vip.inform.message", {salary = Config.VIP.salary.amount, slots = Config.VIP.inventory.slots or 0, weight = Config.VIP.inventory.weight}),
                    centered = true,
                    cancel = false,
                    labels = {
                        confirm = "AWESOME✔️"
                    }
                })

                xTarget.setMeta('vip', 1)
                exports.ox_inventory:SetMaxWeight(xTarget.source, tonumber(defaultWeight)+(Config.VIP.inventory.weight*1000))
                exports.ox_inventory:SetSlotCount(xTarget.source, tonumber(defaultSlots)+(Config.VIP.inventory.slots or 0))
            else
                xPlayer.showNotification(Lang("vip.wrong_month", {used = args.expirePeriod}), 'error', 5000)
            end
        elseif boolean == 'false' then
            VIP.RemovePlayer(xTarget.identifier)
            xPlayer.showNotification(Lang("vip.removed", {name = xTarget.name}), 'info', 5000)

            xTarget.setMeta('vip', 0)
            exports.ox_inventory:SetMaxWeight(xTarget.source, tonumber(defaultWeight))
            exports.ox_inventory:SetSlotCount(xTarget.source, tonumber(defaultSlots))
        else
            xPlayer.showNotification(Lang("vip.wrong_boolean", {used = args.boolean}), 'error', 5000)
        end
    else
        xPlayer.showNotification(Lang("error.target_not_online", {target = args.playerId}), 'error', 5000)
    end
end, true, {
    help = "Set a person vip true or false",
    validate = false,
    arguments = {
        { name = "playerId", help = Lang("commands.player_target"), type = "player" },
        { name = "boolean", help = "true/false", type = "string"},
        { name = "expirePeriod", help = "MONTH/HALFMONTH", type = "string"},
    }
})

ESX.RegisterCommand('vip', "superadmin", function(xPlayer, args)
    local _source = source
    
    if xPlayer then
        if xPlayer.getMeta("vip") == 1 then
            local isVip, daysLeft, hoursLeft = CalculateVipDate(xPlayer.identifier)
            
            TriggerClientEvent('ox_lib:alertDialog', xPlayer.source, {
                header = Lang("vip.inform.title", {days = daysLeft, hours = hoursLeft}),
                content = Lang("vip.inform.message", {salary = Config.VIP.salary.amount, slots = Config.VIP.inventory.slots or 0, weight = Config.VIP.inventory.weight}),
                centered = true,
                cancel = false,
                labels = {
                    confirm = "AWESOME✔️"
                }
            })
        else
            xPlayer.showNotification(Lang("vip.not_vip"), "error", 3500)
        end
    end
end, true, {
    help = "Check your VIP Status",
    validate = true
})

function CalculateVipDate(identifier)
    local isVip, daysLeft, hoursLeft;
    
    MySQL.Async.fetchAll('SELECT * FROM n_vip WHERE `identifier` = ?', {identifier}, function(vipdata)
        if vipdata[1] then
            local vipdata = MySQL.Sync.fetchAll('SELECT * FROM n_vip WHERE `identifier` = ?', {identifier})[1]
            local seconds = math.floor(vipdata.date / 1000) -- Convert milliseconds to seconds
            local dt = os.date("*t", seconds) -- Get the stored date as a table

            -- print("Stored VIP Date:", os.date("%Y-%m-%d %H:%M:%S", seconds)) -- Print the stored VIP date

            -- Function to get the last day of a given month
            -- local function getLastDayOfMonth(year, month)
            --     return os.date("*t", os.time({year = year, month = month + 1, day = 0})).day
            -- end

            -- Add time based on expirePeriod
            if vipdata.expirePeriod == 'MONTH' then
                dt.month = dt.month + 1 -- Add one full month

                -- Adjust for month overflow (December to January)
                if dt.month > 12 then
                    dt.month = 1
                    dt.year = dt.year + 1
                end

                -- Adjust the day if it's greater than the new month's last day
                local last_day_of_new_month = exports.n_snippets:getLastDayOfMonth(dt.year, dt.month)
                if dt.day > last_day_of_new_month then
                    dt.day = last_day_of_new_month
                end

            elseif vipdata.expirePeriod == 'HALFMONTH' then
                -- Add half a month (15 days)
                local days_to_add = 15
                local future_time = os.time(dt) + (days_to_add * 24 * 60 * 60) -- Add 15 days worth of seconds
                dt = os.date("*t", future_time) -- Convert the new time back to a date table
            end

            local future_seconds = os.time(dt) -- Convert the adjusted date back to seconds
            -- print("Future Expiration Date:", os.date("%Y-%m-%d %H:%M:%S", future_seconds)) -- Print the future expiration date

            local current_seconds = os.time() -- Get the current time in seconds
            -- print("Current Server Time:", os.date("%Y-%m-%d %H:%M:%S", current_seconds)) -- Print the current server time

            -- Calculate the time difference in seconds
            local diff_seconds = future_seconds - current_seconds

            -- Ensure time difference is positive
            if diff_seconds < 0 then
                -- print("VIP HAS ALREADY EXPIRED")
                isVip, daysLeft, hoursLeft = false, 0, 0
            else
                -- Calculate the difference in days and hours
                local days_left = math.floor(diff_seconds / (24 * 60 * 60)) -- Full days left
                local hours_left = math.floor((diff_seconds % (24 * 60 * 60)) / (60 * 60)) -- Remaining hours

                -- Print the result
                -- print("VIP WILL EXPIRE IN: ", string.format("%d days and %d hours", days_left, hours_left))
                isVip, daysLeft, hoursLeft = true, days_left, hours_left
            end
        else
            isVip, daysLeft, hoursLeft = false, 0, 0
        end
    end)

    while isVip == nil do
        Wait(0)
    end

    return isVip, daysLeft, hoursLeft
end
local ESX = exports.es_extended:getSharedObject()
local Routes = {}

local function CanPay(Player)
    local MyMoney = Core.GetMoney(Player.source, "bank")

    return MyMoney >= Config.TruckPrice
end

ESX.RegisterServerCallback('n_garbagejob:server:NewShift', function(source, cb, continue)
    local Player = Core.GetPlayer(source)
    local Identifier = Player.identifier
    local shouldContinue = false
    local nextStop = 0
    local totalNumberOfStops = 0
    local bagNum = 0

    if CanPay(Player) or continue then
        math.randomseed(os.time())
        local MaxStops = math.random(Config.MinStops, Config.MaxxStops)
        local allStops = {}

        for _ = 1, MaxStops do
            local stop = math.random(#Config.Locations['trashcan'])
            local newBagAmount = math.random(Config.MinBagsPerStop, Config.MaxBagsPerStop)
            allStops[#allStops + 1] = { stop = stop, bags = newBagAmount }
        end

        Routes[Identifier] = {
            stops = allStops,
            currentStop = 1,
            started = true,
            currentDistance = 0,
            depositPay = Config.TruckPrice,
            actualPay = 0,
            stopsCompleted = 0,
            totalNumberOfStops = #allStops
        }

        nextStop = allStops[1].stop
        shouldContinue = true
        totalNumberOfStops = #allStops
        bagNum = allStops[1].bags
    else
        Core.Notify(source, Lang('error.not_enough', { value = Config.TruckPrice }), 'error')
    end
    cb(shouldContinue, nextStop, bagNum, totalNumberOfStops)
end)

RegisterNetEvent('n_garbagejob:server:payDeposit', function()
    local Player = Core.GetPlayer(source)
    Core.RemoveMoney(source, 'bank', Config.TruckPrice, 'Garbage Truck Deposit')
end)

ESX.RegisterServerCallback('n_garbagejob:server:NextStop', function(source, cb, currentStop, currentStopNum, currLocation)
    local Player = Core.GetPlayer(source)
    local Identifier = Player.identifier
    local currStopCoords = Config.Locations['trashcan'][currentStop].coords
    currStopCoords = vector3(currStopCoords.x, currStopCoords.y, currStopCoords.z)
    local distance = #(currLocation - currStopCoords)
    local newStop = 0
    local shouldContinue = false
    local newBagAmount = 0

    -- if (math.random(100) >= Config.CryptoStickChance) and Config.GiveCryptoStick then
    --     Core.AddItem(source, 'cryptostick', 1, false, false, 'n_garbagejob:server:NextStop')
    --     Core.Notify(source, Lang('info.found_crypto'))
    -- end
    if Config.Items.onCompleteDumpster then
        local randomTotalItems = math.random(1, Config.Items.onCompleteDumpsterMaxItems)

        for i = 1, randomTotalItems do
            local myItem = Config.Items.rewards[math.random(1, #Config.Items.rewards)]
            Core.AddItem(Player.source, myItem.name, math.random(myItem.amount.min, myItem.amount.max))
        end
    end

    if distance <= 20 then
        if currentStopNum >= #Routes[Identifier].stops then
            Routes[Identifier].stopsCompleted = tonumber(Routes[Identifier].stopsCompleted) + 1
            newStop = currentStop
        else
            newStop = Routes[Identifier].stops[currentStopNum + 1].stop
            newBagAmount = Routes[Identifier].stops[currentStopNum + 1].bags
            shouldContinue = true
            local bagAmount = Routes[Identifier].stops[currentStopNum].bags
            local totalNewPay = 0

            for _ = 1, bagAmount do
                totalNewPay = totalNewPay + math.random(Config.BagLowerWorth, Config.BagUpperWorth)
            end

            Routes[Identifier].actualPay = math.ceil(Routes[Identifier].actualPay + totalNewPay)
            Routes[Identifier].stopsCompleted = tonumber(Routes[Identifier].stopsCompleted) + 1
        end
    else
        Core.Notify(source, Lang('error.too_far'), 'error')
    end
    cb(shouldContinue, newStop, newBagAmount, Routes[Identifier].totalNumberOfStops)
end)

ESX.RegisterServerCallback('n_garbagejob:server:EndShift', function(source, cb)
    local Player = Core.GetPlayer(source)
    local Identifier = Player.identifier
    local status = false
    if Routes[Identifier] ~= nil then status = true end
    cb(status)
end)

RegisterNetEvent('n_garbagejob:server:PayShift', function(continue)
    local src = source
    local Player = Core.GetPlayer(src)
    local Identifier = Player.identifier
    if Routes[Identifier] ~= nil then
        local depositPay = Routes[Identifier].depositPay
        if tonumber(Routes[Identifier].stopsCompleted) < tonumber(Routes[Identifier].totalNumberOfStops) then
            depositPay = 0
            Core.Notify(source, Lang('error.early_finish', { completed = Routes[Identifier].stopsCompleted, total = Routes[Identifier].totalNumberOfStops }), 'error')
        end
        if continue then
            depositPay = 0
        end
        local totalToPay = depositPay + Routes[Identifier].actualPay
        local payoutDeposit = Lang('info.payout_deposit', { value = depositPay })
        if depositPay == 0 then
            payoutDeposit = ''
        end
        
        if Config.Items.onCompleteRoute then        
            local randomTotalItems = math.random(1, Config.Items.onCompleteRouteMaxItems)
        
            for i = 1, randomTotalItems do
                local myItem = Config.Items.rewards[math.random(1, #Config.Items.rewards)]
                Core.AddItem(Player.source, myItem.name, math.random(myItem.amount.min, myItem.amount.max))
            end
        end -- Add this closing brace

        Core.AddMoney(src, 'bank', totalToPay, 'Garbage Job - Payslip')
        Core.Notify(source, Lang('success.pay_slip', { total = totalToPay, deposit = payoutDeposit }), 'success')
        Routes[Identifier] = nil
    else
        Core.Notify(source, Lang('error.never_clocked_on'), 'error')
    end
end)

ESX.RegisterCommand("cleargarbroutes", "admin", function(xPlayer, args)
    local Identifier = args.playerId.identifier
    local count = 0
    for k, _ in pairs(Routes) do
        if k == Identifier then
            count = count + 1
        end
    end

    Core.Notify(source, Lang('success.clear_routes', { value = count }), 'success')
    Routes[Identifier] = nil
end, false, {
        help = "Removes garbo routes for user (admin only)",
        validate = true,
        arguments = {
            { name = "playerId", help = "Player ID (may be empty)", type = "player" },
        },
    }
)
ESX = exports["es_extended"]:getSharedObject()
local rentals = {}

RegisterNetEvent('rental:rentVehicle')
AddEventHandler('rental:rentVehicle', function(model)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if rentals[source] then
        lib.notify(source, {
            title = 'Error',
            description = 'You already have a rented vehicle',
            type = 'error'
        })
        return
    end

    local vehicleConfig = nil
    for _, vehicle in pairs(Config.Vehicles) do
        if vehicle.name == model then
            vehicleConfig = vehicle
            break
        end
    end

    if not vehicleConfig then
        lib.notify(source, {
            title = 'Error',
            description = 'Invalid vehicle model',
            type = 'error'
        })
        return
    end

    if xPlayer.getMoney() >= vehicleConfig.price then
        xPlayer.removeMoney(vehicleConfig.price)

        rentals[source] = {
            vehicle = model,
            startTime = os.time(),
            price = vehicleConfig.price
        }

        TriggerClientEvent('rental:spawnVehicle', source, model)
    else
        lib.notify(source, {
            title = 'Error',
            description = 'Not enough money',
            type = 'error'
        })
    end
end)

RegisterNetEvent('rental:cancelRental')
AddEventHandler('rental:cancelRental', function()
    local source = source
    local rental = rentals[source]
    
    if rental then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(rental.price) -- Refund the full amount
        rentals[source] = nil
        
        lib.notify(source, {
            title = 'Info',
            description = 'Rental cancelled and money refunded',
            type = 'info'
        })
    end
end)

RegisterNetEvent('rental:checkTimeLeft')
AddEventHandler('rental:checkTimeLeft', function()
    local source = source
    local rental = rentals[source]

    if not rental then
        lib.notify(source, {
            title = 'Error',
            description = 'No active rentals',
            type = 'error'
        })
        return
    end

    local timeLeft = Config.RentalTime - (os.time() - rental.startTime)
    if timeLeft < 0 then timeLeft = 0 end

    lib.notify(source, {
        title = 'Rental Time',
        description = ('Time remaining: %d minutes'):format(math.floor(timeLeft / 60)),
        type = 'info'
    })
end)

RegisterNetEvent('rental:returnVehicle')
AddEventHandler('rental:returnVehicle', function(vehicleNetId)
    local source = source
    local rental = rentals[source]

    if not rental then
        lib.notify(source, {
            title = 'Error',
            description = 'No active rentals',
            type = 'error'
        })
        return
    end

    local timeLeft = Config.RentalTime - (os.time() - rental.startTime)
    if timeLeft < 0 then timeLeft = 0 end


    local refundAmount = math.floor((timeLeft / Config.RentalTime) * rental.price)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if refundAmount > 0 then
        xPlayer.addMoney(refundAmount)
    end
    TriggerClientEvent('rental:deleteVehicle', -1, vehicleNetId)
    
    rentals[source] = nil

    lib.notify(source, {
        title = 'Vehicle Returned',
        description = ('Refunded amount: $%d'):format(refundAmount),
        type = 'success'
    })
end)
AddEventHandler('playerDropped', function(reason)
    rentals[source] = nil
end)
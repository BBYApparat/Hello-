local ESX = exports.es_extended:getSharedObject()
local RentedVehicles = {}

function NearTaxi(_source)
    local ped = GetPlayerPed(_source)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.DeliverLocations) do
        local dist = #(coords - vector3(v.x,v.y,v.z))
        if dist < 20 then
            return true
        end
    end
end

RegisterNetEvent('n_taxijob:NpcPay', function(Payment)
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    if Player.metadata.isTaxiDriver then
        if NearTaxi(_source) then
            local randomAmount = math.random(1, 5)
            local r1, r2 = math.random(1, 5), math.random(1, 5)
            if randomAmount == r1 or randomAmount == r2 then Payment = Payment + math.random(10, 20) end
            Player.addMoney(Payment, "Taxi Job")
            -- local chance = math.random(1, 100)
            -- if chance < 26 then
            --     Player.addMoney(100, "Taxi Job")
            -- end
        else
            DropPlayer(_source, 'Attempting To Exploit')
        end
    else
        DropPlayer(_source, 'Attempting To Exploit')
    end
end)

RegisterNetEvent('n_taxijob:rentCab', function(plate)
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    if not Player then return end
    if not RentedVehicles[Player.citizenid] then RentedVehicles[Player.citizenid] = plate end
end)

RegisterNetEvent('n_taxijob:returnCab', function(plate)
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    if not Player then return end
    if RentedVehicles[Player.citizenid] then RentedVehicles[Player.citizenid] = nil end
end)

RegisterNetEvent("n_taxijob:becomeTaxiDriver", function()
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    if not Player then return end
    Player.setMeta('isTaxiDriver', 1)
end)

RegisterNetEvent("n_taxijob:retrieveTaxiDriver", function()
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    if not Player then return end
    Player.setMeta('isTaxiDriver', -1)
end)

ESX.RegisterServerCallback('n_taxijob:checkRented', function(source, cb)
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    
    if not Player then return end
    cb(RentedVehicles[Player.citizenid])
end)

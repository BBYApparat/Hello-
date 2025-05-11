ESX = exports['es_extended']:getSharedObject()
local RegisterLocations = {}

-- Helper function to round numbers
local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Initialize register locations
CreateThread(function()
    local registers = GetGamePool('CObject')
    local locations = {}
    
    for _, register in ipairs(registers) do
        if GetEntityModel(register) == GetHashKey(Config.Client.RegisterProps) then
            local coords = GetEntityCoords(register)
            table.insert(locations, coords)
            table.insert(RegisterLocations, coords)
        end
    end
    
    -- Send locations to server
    TriggerServerEvent('minimarket:registerLocationsToServer', locations)
end)

-- Police alert
RegisterNetEvent('minimarket:policeAlert')
AddEventHandler('minimarket:policeAlert', function(coords)
    local streetName, crossing = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    
    TriggerServerEvent('dispatch:server:senddispatch', {
        road = streetName,
        label = "Store Robbery",
        code = "10-69",
        priority = "3",
        coords = coords,
        jobs = { Config.Server.PoliceJobName }
    })
end)

-- Robbery process
RegisterNetEvent('minimarket:startRobberyProcess')
AddEventHandler('minimarket:startRobberyProcess', function(registerId)
    if lib.progressBar({
        duration = Config.Client.ProgressBarTime * 1000,
        label = 'Robbing register...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = Config.Client.Animations.dict,
            clip = Config.Client.Animations.clip
        }
    }) then
        TriggerServerEvent('minimarket:finishRobbery', registerId)
    else
        ESX.ShowNotification('Robbery cancelled!')
        TriggerServerEvent('minimarket:failedAttempt', registerId)
    end
end)

-- Add target interaction
CreateThread(function()
    Wait(1000)
    
    if exports.ox_target then
        exports.ox_target:addModel(Config.Client.RegisterProps, {{
            name = 'rob_register',
            label = 'Rob Register',
            icon = 'fas fa-money-bill',
            onSelect = function(data)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local targetCoords = GetEntityCoords(data.entity)
                
                local distance = #(playerCoords - targetCoords)
                
                if distance <= Config.Client.MaxDistance then
                    local closestDistance = math.huge
                    local closestRegister = nil
                    
                    for i, coords in ipairs(RegisterLocations) do
                        local dist = #(targetCoords - coords)
                        if dist < closestDistance then
                            closestDistance = dist
                            closestRegister = i
                        end
                    end
                    
                    if closestRegister then
                        ESX.ShowNotification('Attempting to start robbery...')
                        TriggerServerEvent('minimarket:startRobbery', closestRegister)
                    else
                        ESX.ShowNotification('Could not find a valid register!')
                    end
                else
                    ESX.ShowNotification('You are too far from the register!')
                end
            end,
            canInteract = function(entity)
                return not IsPedInAnyVehicle(PlayerPedId(), false)
            end
        }})
    end
end)
local Config = require 'config.client'
local Shared = require 'config.shared'
ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    lib.requestModel(`cs_martinmadrazo`)
    madrazoPed = CreatePed(2, `cs_martinmadrazo`, Config.madrazoCoords.x, Config.madrazoCoords.y, Config.madrazoCoords.z - 1, Config.madrazoCoords.w, false, false) -- change here the coords for the ped 
    SetPedFleeAttributes(madrazoPed, 0, 0)
    SetPedDiesWhenInjured(madrazoPed, false)
    TaskStartScenarioInPlace(madrazoPed, "WORLD_HUMAN_AA_SMOKE", 0, true)
    SetPedKeepTask(madrazoPed, true)
    SetBlockingOfNonTemporaryEvents(madrazoPed, true)
    SetEntityInvincible(madrazoPed, true)
    FreezeEntityPosition(madrazoPed, true)

    Wait(100)
    if Shared.target == "ox" then
        exports.ox_target:addLocalEntity(madrazoPed, {{
            name = 'madrazo_shit',
            icon = 'fa-solid fa-user-secret',
            label = Shared.lang["checkrep"],
            distance = 2,
            onSelect = function()
                checkRep()   
            end
        }})
    else
        exports['qb-target']:AddTargetEntity(madrazoPed, {
            options = {
                { 
                    icon = "fas fa-user-secret",
                    label = Shared.lang["checkrep"],
                    action = function()
                        checkRep()
                    end,
                },
            },
            distance = 2.0 
        })
    end
end)

function checkRep()
    -- Get player's gang from server callback
    local PlayerGang = lib.callback.await('mad-territories:server:getPlayerGang')
    
    if PlayerGang == "none" then 
        ESX.ShowNotification("You don't belong to a gang!")
        return 
    end
    
    local rep = lib.callback.await('mad-territories:server:getGangReputation')
    
    lib.registerContext({
        id = 'madrazo_menu',
        title = 'Gang: ' .. PlayerGang,
        canClose = true,
        options = {
            {
                title = "Reputation: " .. rep,
                readOnly = true,
                icon = 'book-skull',
            },
            {
                title = 'Multiplier: ' .. (math.floor((rep / 1000) * 100 + 0.5) / 100) .. "x",
                icon = 'money-bill-trend-up',
                readOnly = true,
            },
            {
                title = "Side Missions",
                icon = 'user-secret',
                menu = "side-missionmenu",
                disabled = true,
            },
        }
    })

    lib.registerContext({
        id = 'side-missionmenu',
        title = 'Side Missions',
        canClose = true,
        menu = 'madrazo_menu',
        options = {
            {
                title = "Car Heist",
                icon = 'car',
                onSelect = function()
                    -- Car heist functionality would go here
                end,
            },
        }
    })

    lib.showContext('madrazo_menu')
end
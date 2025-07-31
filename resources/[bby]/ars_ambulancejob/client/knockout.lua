local knockedOutPlayers = {}
local isKnockedOut = false
local knockoutTimer = 0

-- Knockout mechanics for fist fights
AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end

    local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
    
    if not IsPedAPlayer(victim) then return end
    if victimDied then return end -- Don't handle knockouts for actual deaths
    
    -- Check if damage was from fists (unarmed)
    if weapon == GetHashKey("WEAPON_UNARMED") then
        local victimPlayer = NetworkGetPlayerIndexFromPed(victim)
        local attackerPlayer = attacker and IsPedAPlayer(attacker) and NetworkGetPlayerIndexFromPed(attacker) or nil
        
        local victimHealth = GetEntityHealth(victim)
        local victimMaxHealth = GetEntityMaxHealth(victim)
        
        -- Check if victim's health is very low (knockout threshold)
        if victimHealth <= (victimMaxHealth * 0.2) and victimPlayer == PlayerId() then
            initiateKnockout()
        end
    end
end)

function initiateKnockout()
    if isKnockedOut or player.isDead then return end
    
    isKnockedOut = true
    knockoutTimer = GetGameTimer()
    
    local playerPed = cache.ped or PlayerPedId()
    
    -- Set player state
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed) * 0.15) -- Keep at very low health
    SetPedToRagdoll(playerPed, 10000, 10000, 0, true, true, false)
    
    -- Play knockout animation after ragdoll
    CreateThread(function()
        Wait(2000)
        if isKnockedOut then
            lib.requestAnimDict("missfinale_c2mcs_1")
            TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, -1, 1, 0, false, false, false)
        end
    end)
    
    -- Add ox_target options for other players to revive
    setupKnockoutTargeting()
    
    -- Show UI notification
    utils.showNotification("knockout_message")
    
    -- Auto-recovery after 30 seconds if not helped
    CreateThread(function()
        Wait(30000)
        if isKnockedOut then
            recoverFromKnockout()
        end
    end)
    
    -- Prevent player from moving/acting
    CreateThread(function()
        while isKnockedOut do
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Camera look
            EnableControlAction(0, 2, true) -- Camera look
            EnableControlAction(0, 245, true) -- Chat
            Wait(0)
        end
    end)
end

function setupKnockoutTargeting()
    if not isKnockedOut then return end
    
    local playerPed = cache.ped or PlayerPedId()
    
    -- Use ox_target to allow other players to help
    exports.ox_target:addLocalEntity(playerPed, {
        {
            name = 'help_knocked_player',
            label = 'Help Up',
            icon = 'fas fa-hand-holding-medical',
            distance = 2.0,
            onSelect = function(data)
                local helperPlayer = PlayerId()
                local helperPed = GetPlayerPed(helperPlayer)
                
                -- Play helping animation
                lib.requestAnimDict("mini@cpr@char_a@cpr_str")
                TaskPlayAnim(helperPed, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, -8.0, 3000, 0, 0, false, false, false)
                
                -- Progress bar
                if lib.progressBar({
                    duration = 3000,
                    label = 'Helping player up...',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                }) then
                    -- Success - help the player up
                    TriggerServerEvent('ars_ambulancejob:helpKnockedPlayer', GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed)))
                else
                    -- Cancelled
                    ClearPedTasks(helperPed)
                end
            end,
            canInteract = function(entity, distance, coords, name)
                return isKnockedOut and entity == playerPed
            end
        }
    })
end

function recoverFromKnockout()
    if not isKnockedOut then return end
    
    isKnockedOut = false
    knockoutTimer = 0
    
    local playerPed = cache.ped or PlayerPedId()
    
    -- Remove ox_target options
    exports.ox_target:removeLocalEntity(playerPed, 'help_knocked_player')
    
    -- Restore player state
    ClearPedTasks(playerPed)
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed) * 0.5) -- Partial health recovery
    
    -- Play recovery animation
    lib.requestAnimDict("get_up@directional@transition@prone_to_seated@crawl")
    TaskPlayAnim(playerPed, "get_up@directional@transition@prone_to_seated@crawl", "front", 8.0, -8.0, -1, 0, 0, false, false, false)
    
    utils.showNotification("recovered_knockout")
end

-- Server event handler for when another player helps
RegisterNetEvent('ars_ambulancejob:knockoutHelped', function()
    if isKnockedOut then
        recoverFromKnockout()
    end
end)

-- Export for other scripts
exports('isKnockedOut', function()
    return isKnockedOut
end)

exports('getKnockoutTimer', function()
    return knockoutTimer
end)
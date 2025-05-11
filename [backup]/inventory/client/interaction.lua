RegisterNetEvent('inventory:client:RobPlayer', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > Config.MaxDistance.rob then
        return
    end
    local id = GetPlayerServerId(closestPlayer)
    local tarPed = GetPlayerPed(closestPlayer)
    if not canRobTarget(id) then return end
    local animations = Config.Animations.rob
    local dict = animations.entering.dict
    local anim = animations.entering.anim
    local dict2 = animations.base.dict
    local anim2 = animations.base.anim
    if IsEntityPlayingAnim(tarPed, dict, anim, 3) or IsEntityPlayingAnim(tarPed, dict2, anim2, 3) then
        StartThiefAnim()
        Wait(math.random(1000, 1100))
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", id)
        currentVictim = GetPlayerPed(closestPlayer)
    else
        ESX.TriggerServerCallback("inventory:isOtherPlayerDead", function(isDead)
            if isDead then
                StartThiefAnim()
                Wait(math.random(1000, 1100))
                TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", id)
                currentVictim = GetPlayerPed(closestPlayer)
            else
                ESX.ShowNotification('The target has not hands Up!', 'error', 6000)
            end
        end, id)
    end
end)

RegisterNUICallback('RobMoney', function(data)
    local player, distance = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if not data.money or data.money <= 0 then
        ESX.ShowNotification("Invalid amount!", "error", 2000)
        return
    end
    if player ~= -1 and distance < Config.MaxDistance.rob then
        if (data.inventory == 'player') then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent('inventory:robTargetMoney', playerId, data.money)
        end
    else
        ESX.ShowNotification("No one nearby!", "error", 2000)
    end
end)

RegisterNUICallback('GiveMoney', function(data, cb)
    local target_src, target_id, target_ped, target_coords, player_ped, player_coords, distance
    target_src = data.target
    target_id = GetPlayerFromServerId(target_src)
    if not target_id or target_id == -1 then
        ESX.ShowNotification("Player not found!", "error", 2000)
        return
    end
    if not data or not data.money or data.money <= 0 then
        ESX.ShowNotification("Invalid Amount!", "error", 2000)
        return
    end
    player_ped = ped
    player_coords = GetEntityCoords(player_ped)
    target_ped = GetPlayerPed(target_id)
    target_coords = GetEntityCoords(target_ped)
    distance = #(target_coords - player_coords);
    if distance > Config.MaxDistance.give then
        ESX.ShowNotification("Player not found!", "error", 2000)
        return
    end
    StartGiveAnim()
    TriggerServerEvent('inventory:giveMoney', target_src, data.money)
    cb("ok")
end)

RegisterNetEvent('inventory:client:giveAnim', function()
    StartGiveAnim()
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local itemData = data.data
    local target = data.target
    local target_src, target_id, target_ped, target_coords, player_ped, player_coords, distance
    target_src = target
    data = itemData
    target_id = GetPlayerFromServerId(target_src)
    if target_id == -1 then
        ESX.ShowNotification("Player not found!", "error", 2000)
        return
    end
    player_ped = PlayerPedId()
    player_coords = GetEntityCoords(player_ped)
    target_ped = GetPlayerPed(target_id)
    target_coords = GetEntityCoords(target_ped)
    distance = #(target_coords - player_coords);
    if distance > Config.MaxDistance.give then
        ESX.ShowNotification("Player not found!", "error", 2000)
        return
    end
    TriggerServerEvent("inventory:server:GiveItem", target_src, data.name, data.amount, data.slot)
    StartGiveAnim()
    cb("ok")
end)
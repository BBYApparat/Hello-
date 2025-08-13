ESX = exports["es_extended"]:getSharedObject()

local prevPos, time = nil, nil
local isPlayingIdleAnim = false
local currentIdleAnim = nil
local idleTimer = 0
local lastMovementTime = 0

local idleAnimations = {
    {
        dict = "mp_player_inteat@pnq",
        anim = "loop",
        name = "Eating",
        duration = 15000,
        flag = 49
    },
    {
        dict = "mp_player_int_uppersmoke",
        anim = "mp_player_int_smoke",
        name = "Smoking",
        duration = 20000,
        flag = 49
    },
    {
        dict = "cellphone@",
        anim = "cellphone_text_read_base",
        name = "Checking Phone",
        duration = 12000,
        flag = 49
    },
    {
        dict = "amb@world_human_sit_ups@male@idle_a",
        anim = "idle_a",
        name = "Exercising (Sit-ups)",
        duration = 18000,
        flag = 1
    },
    {
        dict = "amb@world_human_push_ups@male@idle_a",
        anim = "idle_a",
        name = "Exercising (Push-ups)",
        duration = 16000,
        flag = 1
    },
    {
        dict = "amb@world_human_yoga@male@base",
        anim = "base_a",
        name = "Stretching/Yoga",
        duration = 20000,
        flag = 1
    },
    {
        dict = "mp_player_intdrink",
        anim = "loop_bottle",
        name = "Drinking Water",
        duration = 10000,
        flag = 49
    },
    {
        dict = "amb@world_human_stand_mobile@male@text@base",
        anim = "base",
        name = "Texting",
        duration = 14000,
        flag = 49
    },
    {
        dict = "amb@world_human_leaning@male@wall@back@foot_up@base",
        anim = "base",
        name = "Leaning Against Wall",
        duration = 25000,
        flag = 1
    },
    {
        dict = "rcmnigel1bnmt_1b",
        anim = "base_tyler_idle",
        name = "Thinking",
        duration = 15000,
        flag = 1
    }
}

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function StopIdleAnimation()
    if isPlayingIdleAnim and currentIdleAnim then
        local ped = PlayerPedId()
        ClearPedTasks(ped)
        isPlayingIdleAnim = false
        currentIdleAnim = nil
        print("^3[AFK Animations]^7 Idle animation stopped")
    end
end

local function PlayRandomIdleAnimation()
    if isPlayingIdleAnim then return end
    
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped, false) or 
       IsPedSwimming(ped) or 
       IsPedClimbing(ped) or 
       IsPedRagdoll(ped) or
       IsEntityDead(ped) or
       IsPedBeingStunned(ped) or
       GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
        return
    end
    
    local randomAnim = idleAnimations[math.random(1, #idleAnimations)]
    
    LoadAnimDict(randomAnim.dict)
    
    TaskPlayAnim(ped, randomAnim.dict, randomAnim.anim, 8.0, -8.0, randomAnim.duration, randomAnim.flag, 0, false, false, false)
    
    isPlayingIdleAnim = true
    currentIdleAnim = randomAnim
    
    print("^2[AFK Animations]^7 Started idle animation: " .. randomAnim.name)
    
    SetTimeout(randomAnim.duration, function()
        if isPlayingIdleAnim and currentIdleAnim == randomAnim then
            isPlayingIdleAnim = false
            currentIdleAnim = nil
        end
    end)
end

local function HasPlayerMoved(playerPed, currentPos)
    if not prevPos then
        return false
    end
    
    local distance = #(currentPos - prevPos)
    return distance > 0.5 or 
           IsPedRunning(playerPed) or 
           IsPedSprinting(playerPed) or 
           IsPedJumping(playerPed) or
           IsControlPressed(0, 32) or  -- W
           IsControlPressed(0, 33) or  -- S
           IsControlPressed(0, 34) or  -- A
           IsControlPressed(0, 35) or  -- D
           IsControlPressed(0, 21) or  -- Shift
           IsControlPressed(0, 22)     -- Space
end

CreateThread(function()
    while true do
        Wait(Config.AFKIdleCheck or 2000)
        
        if LocalPlayer.state.isLoggedIn then
            local playerPed = PlayerPedId()
            local currentPos = GetEntityCoords(playerPed)
            local currentTime = GetGameTimer()
            
            if HasPlayerMoved(playerPed, currentPos) then
                lastMovementTime = currentTime
                idleTimer = 0
                
                if isPlayingIdleAnim then
                    StopIdleAnimation()
                end
            else
                if lastMovementTime == 0 then
                    lastMovementTime = currentTime
                end
                
                idleTimer = currentTime - lastMovementTime
                
                if idleTimer >= (Config.AFKIdleTime or 60000) and not isPlayingIdleAnim then
                    PlayRandomIdleAnimation()
                end
            end
            
            prevPos = currentPos
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StopIdleAnimation()
    end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    prevPos = nil
    time = nil
    isPlayingIdleAnim = false
    currentIdleAnim = nil
    idleTimer = 0
    lastMovementTime = 0
end)
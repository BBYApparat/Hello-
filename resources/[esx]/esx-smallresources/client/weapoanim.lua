-- Initialize Config and AnimWeapons if not already defined
Config = Config or {}
Config.AnimWeapons = Config.AnimWeapons or {
    -- Melee
    WEAPON_KNIFE = false,           -- If it is set to true it will use the jerrycan style.
    WEAPON_NIGHTSTICK = false,
    WEAPON_HAMMER = false,
    WEAPON_BAT = false,
    WEAPON_GOLFCLUB = false,
    WEAPON_CROWBAR = false,
    WEAPON_BOTTLE = false,
    WEAPON_DAGGER = false,
    WEAPON_HATCHET = false,
    WEAPON_KNUCKLE = false,
    WEAPON_MACHETE = false,
    WEAPON_FLASHLIGHT = false,
    WEAPON_SWITCHBLADE = false,
    WEAPON_POOLCUE = false,
    WEAPON_PIPEWRENCH = false,
    WEAPON_BATTLEAXE = false,
    WEAPON_STONE_HATCHET = false,

    -- Handguns
    WEAPON_PISTOL = true,
    WEAPON_COMBATPISTOL = true,
    WEAPON_APPISTOL = true,
    WEAPON_PISTOL50 = true,
    WEAPON_SNSPISTOL = true,
    WEAPON_HEAVYPISTOL = true,
    WEAPON_VINTAGEPISTOL = true,
    WEAPON_STUNGUN = true,
    WEAPON_FLAREGUN = true,
    WEAPON_MARKSMANPISTOL = true,
    WEAPON_REVOLVER = true,
    WEAPON_DOUBLEACTION = true,
    WEAPON_RAYPISTOL = true,
    WEAPON_CERAMICPISTOL = true,
    WEAPON_NAVYREVOLVER = true,

    -- SMGs
    WEAPON_MICROSMG = true,
    WEAPON_SMG = true,
    WEAPON_ASSAULTSMG = true,
    WEAPON_COMBATPDW = true,
    WEAPON_MACHINEPISTOL = true,
    WEAPON_MINISMG = true,
    WEAPON_RAYCARBINE = true,

    -- Shotguns
    WEAPON_PUMPSHOTGUN = true,
    WEAPON_SAWNOFFSHOTGUN = true,
    WEAPON_ASSAULTSHOTGUN = true,
    WEAPON_BULLPUPSHOTGUN = true,
    WEAPON_MUSKET = true,
    WEAPON_HEAVYSHOTGUN = true,
    WEAPON_DBSHOTGUN = true,
    WEAPON_AUTOSHOTGUN = true,

    -- Assault Rifles
    WEAPON_ASSAULTRIFLE = true,
    WEAPON_CARBINERIFLE = true,
    WEAPON_ADVANCEDRIFLE = true,
    WEAPON_SPECIALCARBINE = true,
    WEAPON_BULLPUPRIFLE = true,
    WEAPON_COMPACTRIFLE = true,
    WEAPON_MILITARYRIFLE = true,
    WEAPON_HEAVYRIFLE = true,
    WEAPON_TACTICALRIFLE = true,

    -- LMGs
    WEAPON_MG = true,
    WEAPON_COMBATMG = true,
    WEAPON_GUSENBERG = true,

    -- Sniper Rifles
    WEAPON_SNIPERRIFLE = true,
    WEAPON_HEAVYSNIPER = true,
    WEAPON_MARKSMANRIFLE = true,
    WEAPON_PRECISIONRIFLE = true,

    -- Heavy Weapons
    WEAPON_RPG = true,
    WEAPON_GRENADELAUNCHER = true,
    WEAPON_GRENADELAUNCHER_SMOKE = true,
    WEAPON_MINIGUN = true,
    WEAPON_FIREWORK = true,
    WEAPON_RAILGUN = true,
    WEAPON_HOMINGLAUNCHER = true,
    WEAPON_COMPACTLAUNCHER = true,
    WEAPON_RAYMINIGUN = true,
    WEAPON_EMPLAUNCHER = true,

    -- Throwables
    WEAPON_GRENADE = false,
    WEAPON_STICKYBOMB = false,
    WEAPON_SMOKEGRENADE = false,
    WEAPON_BZGAS = false,
    WEAPON_MOLOTOV = false,
    WEAPON_FIREEXTINGUISHER = false,
    WEAPON_PETROLCAN = false,
    WEAPON_BALL = false,
    WEAPON_FLARE = false,
    WEAPON_SNOWBALL = false,
    WEAPON_PIPEBOMB = false
}

local JerrycanAnimLoaded = false

-- Function to handle weapon animation
local function handleWeaponAnimation(weaponName)
    local ped = PlayerPedId()
    
    -- Check if Config and AnimWeapons exist and if weapon should use animation
    if Config and Config.AnimWeapons and weaponName and Config.AnimWeapons[weaponName] then
        -- Load jerrycan animation if not already loaded
        if not JerrycanAnimLoaded then
            RequestClipSet("move_ped_wpn_jerrycan_generic")
            while not HasClipSetLoaded("move_ped_wpn_jerrycan_generic") do
                Wait(0)
            end
            JerrycanAnimLoaded = true
        end

        -- Apply the animation
        if HasClipSetLoaded("move_ped_wpn_jerrycan_generic") then
            SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 0.50)
        end
    else
        -- Reset animation if weapon doesn't need it
        ResetPedWeaponMovementClipset(ped, 0.0)
    end
end

-- Event handler for ox_inventory weapon changes
AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon and weapon.name then
        handleWeaponAnimation(weapon.name)
    else
        -- No weapon equipped, reset animation
        local ped = PlayerPedId()
        ResetPedWeaponMovementClipset(ped, 0.0)
    end
end)

-- Alternative event handler for standard ESX weapon changes (fallback)
AddEventHandler('esx:setWeapon', function(weapon, ammo)
    if weapon and weapon.name then
        handleWeaponAnimation(weapon.name)
    else
        local ped = PlayerPedId()
        ResetPedWeaponMovementClipset(ped, 0.0)
    end
end)

-- Thread to monitor weapon changes (additional safety net)
CreateThread(function()
    local lastWeapon = nil
    
    while true do
        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)
        
        if currentWeapon ~= lastWeapon then
            local weaponName = nil
            
            -- Convert weapon hash to name
            for name, hash in pairs(GetHashKey) do
                if GetHashKey(name) == currentWeapon then
                    weaponName = name
                    break
                end
            end
            
            if weaponName then
                handleWeaponAnimation(weaponName)
            else
                ResetPedWeaponMovementClipset(ped, 0.0)
            end
            
            lastWeapon = currentWeapon
        end
        
        Wait(1000) -- Check every second
    end
end)
local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_BREAD',
	'WEAPON_FLASHLIGHT',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_STUNGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_HUNTINGRIFLE'
}

local holsterableWeapons = {
	--'WEAPON_STUNGUN',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL'
}

local holstered = true
local canFire = true
local lastWeapon = nil
local currWeapon = GetHashKey('WEAPON_UNARMED')
local currentHoldster = nil
ped = nil
local pos, rot
local forced = false
local timeoutHolster = false

RegisterNetEvent('weapons:ResetHolster', function()
	holstered = true
	canFire = true
	currWeapon = GetHashKey('WEAPON_UNARMED')
	currentHoldster = nil
end)

RegisterNetEvent('weapons:TimeoutFiring', function(timer)
	canFire = false
	Wait(timer)
	canFire = true
end)

CreateThread(function()
	while true do
		ped = PlayerPedId()
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		Wait(1000)
	end
end)

CreateThread(function()
	while true do
		local shouldNotContinue = false
		while not ped or not ESX or not PlayerData or not PlayerData.job or not PlayerData.job.name do 
			Wait(300) 
		end
		local sleep = 300
		if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedFalling(ped) and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) then
			if GetVehiclePedIsEntering(ped) ~= 0 then
				shouldNotContinue = true
				if json.encode(getLastPedWeapon()) ~= "[]" then
					lastWeapon = getLastPedWeapon()
				end
				Wait(500)
				currWeapon = GetHashKey("WEAPON_UNARMED")
			end
			if currWeapon ~= GetSelectedPedWeapon(ped) and not IsPedInAnyVehicle(ped, false) and GetVehiclePedIsEntering(ped) == 0 then
				sleep = 10
				if not shouldNotContinue then
					pos = GetEntityCoords(ped, true)
					rot = GetEntityHeading(ped)
					local newWeap = GetSelectedPedWeapon(ped)
					SetCurrentPedWeapon(ped, currWeapon, true)
					local isEnteringVehicle = exports.es_extended:IsEnteringVehicle()
					if CheckWeapon(newWeap) then
						if holstered and not isEnteringVehicle then
							if Config.PoliceJobs[PlayerData.job.name] then
								canFire = false
								currentHoldster = GetPedDrawableVariation(ped, 7)
								loadAnim("rcmjosh4")
								TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
								Wait(200)
								SetCurrentPedWeapon(ped, newWeap, true)
								if IsWeaponHolsterable(newWeap) then
									if currentHoldster == 8 then
										SetPedComponentVariation(ped, 7, 2, 0, 2)
									elseif currentHoldster == 1 then
										SetPedComponentVariation(ped, 7, 3, 0, 2)
									elseif currentHoldster == 6 then
										SetPedComponentVariation(ped, 7, 5, 0, 2)
									end
								end
								currWeapon = newWeap
								Wait(200)
								ClearPedTasks(ped)
								holstered = false
								canFire = true
							else
								canFire = false
								loadAnim("reaction@intimidation@1h")
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
								Wait(500)
								SetCurrentPedWeapon(ped, newWeap, true)
								currWeapon = newWeap
								Wait(1200)
								ClearPedTasks(ped)
								holstered = false
								canFire = true
							end
						elseif newWeap ~= currWeapon and CheckWeapon(currWeapon) and not isEnteringVehicle then
							if Config.PoliceJobs[PlayerData.job.name] then
								canFire = false
								loadAnim("reaction@intimidation@cop@unarmed")
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
								Wait(500)
								if IsWeaponHolsterable(currWeapon) then
									SetPedComponentVariation(ped, 7, currentHoldster, 0, 2)
								end
								SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
								currentHoldster = GetPedDrawableVariation(ped, 7)
								loadAnim("rcmjosh4")
								TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
								Wait(300)
								SetCurrentPedWeapon(ped, newWeap, true)
								if IsWeaponHolsterable(newWeap) then
									if currentHoldster == 8 then
										SetPedComponentVariation(ped, 7, 2, 0, 2)
									elseif currentHoldster == 1 then
										SetPedComponentVariation(ped, 7, 3, 0, 2)
									elseif currentHoldster == 6 then
										SetPedComponentVariation(ped, 7, 5, 0, 2)
									end
								end
								Wait(500)
								currWeapon = newWeap
								ClearPedTasks(ped)
								holstered = false
								canFire = true
							else
								canFire = false
								loadAnim("reaction@intimidation@1h")
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
								Wait(1000)
								SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
								Wait(500)
								SetCurrentPedWeapon(ped, newWeap, true)
								currWeapon = newWeap
								Wait(1000)
								ClearPedTasks(ped)
								holstered = false
								canFire = true
							end
						else
							if not isEnteringVehicle then
								if Config.PoliceJobs[PlayerData.job.name] then
									SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
									currentHoldster = GetPedDrawableVariation(ped, 7)
									loadAnim("rcmjosh4")
									TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(300)
									SetCurrentPedWeapon(ped, newWeap, true)
									if IsWeaponHolsterable(newWeap) then
										if currentHoldster == 8 then
											SetPedComponentVariation(ped, 7, 2, 0, 2)
										elseif currentHoldster == 1 then
											SetPedComponentVariation(ped, 7, 3, 0, 2)
										elseif currentHoldster == 6 then
											SetPedComponentVariation(ped, 7, 5, 0, 2)
										end
									end
									currWeapon = newWeap
									Wait(300)
									ClearPedTasks(ped)
									holstered = false
									canFire = true
								else
									SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
									loadAnim("reaction@intimidation@1h")
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
									Wait(500)
									SetCurrentPedWeapon(ped, newWeap, true)
									currWeapon = newWeap
									Wait(800)
									ClearPedTasks(ped)
									holstered = false
									canFire = true
								end
							end
						end
					else
						if not isEnteringVehicle then
							if not holstered and CheckWeapon(currWeapon) then
								if Config.PoliceJobs[PlayerData.job.name] then
									canFire = false
									loadAnim("reaction@intimidation@cop@unarmed")
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
									Wait(1000)
									if IsWeaponHolsterable(currWeapon) then
										SetPedComponentVariation(ped, 7, currentHoldster, 0, 2)
									end
									SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
									ClearPedTasks(ped)
									SetCurrentPedWeapon(ped, newWeap, true)
									holstered = true
									canFire = true
									currWeapon = newWeap
								else
									canFire = false
									loadAnim("reaction@intimidation@1h")
									TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
									Wait(1200)
									SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
									ClearPedTasks(ped)
									SetCurrentPedWeapon(ped, newWeap, true)
									holstered = true
									canFire = true
									currWeapon = newWeap
								end
							else
								SetCurrentPedWeapon(ped, newWeap, true)
								holstered = false
								canFire = true
								currWeapon = newWeap
							end
						end
					end
				end
			end
		end
		Wait(sleep)
	end
end)

CreateThread(function()
	while true do
		while not ped do 
			Wait(300) 
		end
		local sleep = 300
		if not canFire then
			sleep = 3
			DisableControlAction(0, 75, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(ped, true)
		end
		Wait(sleep)
	end
end)

CreateThread(function()
    if Config.EnableShake then
        while true do
            while not ped do
                Wait(100)
            end
            local sleep = 300
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= GetHashKey("WEAPON_UNARMED") then
                if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then		
                    if IsPedShooting(ped) then
						ESX.SetIAm(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
                    end
                else
                    if Config.Shakes[weapon] then
						sleep = 3
                        if IsPedShooting(ped) then
                            ShakeGameplayCam(Config.Shakes[weapon].cam, Config.Shakes[weapon].rate)
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end
end)

CreateThread(function()
    if Config.EnableRecoil then
        while true do
            while not ped do
                Wait(100)
            end
            local sleep = 300
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= GetHashKey("WEAPON_UNARMED") and IsPedShooting(ped) and not IsPedDoingDriveby(ped) then
                local _,wep = GetCurrentPedWeapon(PlayerPedId())
                _,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
                if Config.recoils[wep] and Config.recoils[wep] ~= 0 then
                    sleep = 3
                    tv = 0
                    if GetFollowPedCamViewMode() ~= 4 then
                        repeat 
                            Wait(0)
                            p = GetGameplayCamRelativePitch()
                            SetGameplayCamRelativePitch(p+0.1, 0.2)
                            tv = tv+0.1
                        until tv >= Config.recoils[wep]
                    else
                        repeat 
                            Wait(0)
                            p = GetGameplayCamRelativePitch()
                            if Config.recoils[wep] > 0.1 then
                                SetGameplayCamRelativePitch(p+0.6, 1.2)
                                tv = tv+0.6
                            else
                                SetGameplayCamRelativePitch(p+0.016, 0.333)
                                tv = tv+0.1
                            end
                        until tv >= Config.recoils[wep]
                    end
                end
            end
            Wait(sleep)
        end
    end
end)

local weapon_types = {
    [970310034] = "Rifle",
    [416676503] = "Handgun",
    [860033945] = "Shotguns",
    [3337201093] = "Sub-Machine",
    [1159398588] = "Light Machine Gun",
    [2725924767] = "Heavy Weapon",
    [3082541095] = "Sniper Rifles",
    [690389602] = "Stun-gun",
    [1548507267] = "Throwable",
    [3566412244] = "Melee Weapon",
    [2685387236] = "Knuckle Duster",
    -- [4257178988] = "Fire Extinguisher",
    -- [1548507267] = "Jerry Can",
}

CreateThread(function()
    local unarmed = GetHashKey('WEAPON_UNARMED')
    local current_weapon, weapon_group
	if not Config.EnableWeaponWhipping then
		while true do
			local sleep = 300
			current_weapon = GetSelectedPedWeapon(ped)
			weapon_group = GetWeapontypeGroup(weapon_hash) or nil
			if IsPedArmed(ped, 4) or IsPedArmed(ped, 6) or (GetSelectedPedWeapon(ped) ~= unarmed and weapon_group and weapon_types[weapon_group]) or IsPlayerFreeAiming(ped) then
				sleep = 3
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end
			Wait(sleep)
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

function IsWeaponHolsterable(weap)
	for i = 1, #holsterableWeapons do
		if GetHashKey(holsterableWeapons[i]) == weap then
			return true
		end
	end
	return false
end

function canFireWeapon()
	return canFire
end
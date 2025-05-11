local myMask = nil
local sgMask = nil
local IsAnimated = false
local isInIDMenu = false
local isInLicenseMenu = false
local shouldstopBleeding = false
local bleedTimer = 0
local lastKnownHealth = 0

--Bleeding

local loadAnim = function(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
	end
end

local loadModel = function(model)
	if not HasModelLoaded(model) then
		RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
	end
end

CreateThread(function()
	StatSetInt(GetHashKey("MP0_STAMINA"), 0, true)
	Wait(3000)
	while true do
		Wait(5000)
		local player = PlayerPedId()
		local health = GetEntityHealth(player)
		if bleedTimer > 0 then
			setBleedingOff()
		else
			if health <= 130 and health > 90 then
				setBleedingOn(player)
			elseif health > 130 then
				setBleedingOff()
			end
		end
	end
end)

CreateThread(function()
	while true do
		if shouldstopBleeding then
			if lastKnownHealth > 0 and lastKnownHealth ~= GetEntityHealth(PlayerPedId()) then
				lastKnownHealth = 0
				shouldstopBleeding = false
			end
		end
		Wait(500)
	end
end)

RegisterNetEvent('setbleedingoff', function()
    setBleedingOff()
end)

function setBleedingOn(ped)
	if shouldstopBleeding then 
		if effect then
			ClearTimecycleModifier()
			effect = false
		end	
		return
	end
    if GetEntityHealth(ped) > 90 then
		ESX.ShowNotification(Lang("bleeding"), "error", 4500)
        SetEntityHealth(ped, GetEntityHealth(ped) - 2)
        if not effect then
            SetTimecycleModifier('glasses_Scuba')
            SetTimecycleModifierStrength(0.8)
            effect = true
        end
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.2)
        Wait(7500)
    end
end

function setBleedingOff()
	if effect then
		effect = false
		ClearTimecycleModifier()
	end
end

function TimeoutBleeding(timer)
	bleedTimer = timer * 60000
	while true do
		Wait(1000)
		bleedTimer = bleedTimer - 1000
		if bleedTimer <= 0 then
			bleedTimer = 0
			return
		end
	end
end

--Stamina

UnleaseStamina = function(timer)
	local temp_timer = timer
	while true do
		Wait(1000)
		temp_timer = temp_timer - 1
		if temp_timer <= 0 then
			return 
		end
		ResetPlayerStamina(PlayerId()) 
	end
end

TimeoutUserStamina = function(timer)
	local temp_timer = timer
	while true do
		Wait(1000)
		temp_timer = temp_timer - 1000
		if temp_timer <= 0 then
			SetPlayerMaxStamina(PlayerId(), 100.0)
			return
		end
	end
end

--Healing

HealPedTimer = function(_type)
	if _type == "painkiller" then
		local fullTimer = 80000
		local healevery = 20000
		local healamount = 10
		while true do
			local ped = PlayerPedId()
			local health = GetEntityHealth(ped)
			if health >= 200 then
				SetEntityHealth(ped, 200)
				return
			end
			SetEntityHealth(ped, health + healamount)
			fullTimer = fullTimer - healevery
			if fullTimer == 0 then return end
			Wait(healevery)
		end
	end
end 

local IsEating = function()
	return IsAnimated
end

exports('IsEating', IsEating)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

local FoodProps = {
	burger = 'prop_cs_burger_01',
	chips = 'v_ret_ml_chips4',
	chocolate = 'prop_choc_ego',
	cupcake = 'ng_proc_food_ornge1a',
	donut = 'prop_amb_donut',
	fries = 'prop_food_bs_chips',
	hotdog = 'prop_cs_hotdog_01',
	pills = 'prop_cs_pills',
	taco = 'prop_taco_01',
	toast = 'prop_sandwich_01',
}

local DrinkProps = {
	bottle = 'prop_ld_flow_bottle',
	soda = 'ng_proc_sodacan_01a',
	cocacola = 'prop_ecola_can',
	sprite = 'ng_proc_sodacan_01b',
	icetea = 'prop_ld_can_01',
	coffee = 'prop_fib_coffee',
	milk = 'prop_cs_milk_01',
	beer = 'prop_amb_beer_bottle',
	shot = 'prop_cs_shot_glass',
	glass = 'prop_sh_tall_glass',
	winebottle = 'prop_wine_bot_01',
	vodkabottle = 'prop_vodka_bottle',
	whiskeybottle = 'prop_cs_whiskey_bottle',
	tequilabottle = 'prop_tequila_bottle',
	rumbottle = 'prop_rum_bottle',
	cognacbottle = 'prop_bottle_cognac',
	whitewinebottle = 'prop_wine_white',
	energydrink = 'prop_energy_drink',
}

local function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end

local function CokeBaggyEffect()
    local startStamina = 20
    local ped = PlayerPedId()
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

RegisterNetEvent('esx_basicneeds:usedCokeSniff', function(item)
    local ped = PlayerPedId()
	ProgressBar(Lang("cocaine_use_item"), math.random(5000, 8000), { whileDead = false, canCancel = false, movement = false, dict = "switch@trevor@trev_smoking_meth", anim = "trev_smoking_meth_loop", flags = 49}, function(cancelled)
		StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
		TriggerServerEvent("esx:removeItem", item.name, 1, item.slot)
		CokeBaggyEffect()
	end)
end)

RegisterNetEvent("esx_basicneeds:onFirstAidKit", function(item)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	local pos = GetEntityCoords(ped)
	if IsPlayerDead(PlayerId()) then
		return
	end
	if IsPedInAnyVehicle(ped, false) then
		ESX.ShowNotification(Lang("cant_use_firstaid_invehicle"), "error", 5000)
		return
	end
	local model1 = GetHashKey("v_ret_ta_firstaid")
	loadModel(model1)
	local vec = GetEntityForwardVector(ped)
    local new_pos = { x = pos.x + vec.x, y = pos.y + vec.y, z = pos.z - 1.0}
	local prop1 = CreateObject(model1, new_pos.x, new_pos.y, new_pos.z, true)
	PlaceObjectOnGroundProperly(prop1)
	local model = GetHashKey("alcaprop_medic_bandage")
	loadModel(model)
	local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true)
	SetEntityCollision(prop, false)
	local boneIndex = GetPedBoneIndex(ped, 18905)
	AttachEntityToEntity(prop, ped, boneIndex, 0.14, 0.02, 0.02, 98.0, -104.0, -158.0, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(model)
	local dict, anim = "self@bandage@leg", "self_leg_clip"
	SetTimeout(500, function()
		loadAnim(dict)
		TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)	
	end)
	ProgressBar(Lang("firstaid_use_item"), 10000, { whileDead = false, canCancel = false, movement = false}, function(cancelled)
		ClearPedTasks(PlayerPedId())
		RemoveAnimDict(dict)
		DetachEntity(prop)
		DeleteEntity(prop)
		DeleteEntity(prop1)
		SetEntityHealth(PlayerPedId(), 200)
		TriggerServerEvent("esx:removeItem", item.name, 1, item.slot)
		ESX.ShowNotification(Lang("healed_firstaid"), "inform", 5000)
	end)
end)

RegisterNetEvent("esx_basicneeds:onVitamin", function(item)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	local pos = GetEntityCoords(ped)
	if IsPlayerDead(PlayerId()) then
		return
	end
	local newHealth = health + 25
	if newHealth > 200 then
		newHealth = 200
	end
	local model = GetHashKey("alcaprop_medic_tylenal")
	loadModel(model)
	local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true)
	SetEntityCollision(prop, false)
	local boneIndex = GetPedBoneIndex(ped, 18905)
	AttachEntityToEntity(prop, ped, boneIndex, 0.16, 0.04, 0.02, -8.0, 168.0, 186.0, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(model)
	local dict, anim = "eat@pills@anim", "eat_pills_clip"
	SetTimeout(100, function()
		loadAnim(dict)
		TaskPlayAnim(ped, dict, anim, 8.0, -8, 3800, 49, 0, 0, 0, 0)
		Wait(3800)
		DetachEntity(prop)
		DeleteEntity(prop)
		ClearPedTasks(ped)
	end)
	ProgressBar(Lang("vitamin_use_item"), 4000, {whileDead = false, canCancel = false}, function(cancelled)
		ClearPedTasks(PlayerPedId())
		RemoveAnimDict(dict)
		SetEntityHealth(PlayerPedId(), newHealth)
		TriggerServerEvent("esx:removeItem", item.name, 1, item.slot)
		ESX.ShowNotification(Lang("healed_vitamin"), "inform", 5000)
	end)
end)

RegisterNetEvent("esx_basicneeds:onBleedingBandage", function(item)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	local pos = GetEntityCoords(ped)
	if IsPlayerDead(PlayerId()) then
		return
	end
	if health > 130 or health < 90 then
		ESX.ShowNotification(Lang("no_bleeding"), "error", 5000)
		return
	end
	if shouldstopBleeding then
		ESX.ShowNotification(Lang("recently_patched_bleeding"), "error", 5000)
		return
	end
	local model = GetHashKey("alcaprop_medic_bandage")
	loadModel(model)
	local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true)
	SetEntityCollision(prop, false)
	local boneIndex = GetPedBoneIndex(ped, 18905)
	AttachEntityToEntity(prop, ped, boneIndex, 0.14, 0.02, 0.02, 98.0, -104.0, -158.0, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(model)
	local dict, anim = "bandage@animation", "bandage_selfarm_clip"
	SetTimeout(500, function()
		loadAnim(dict)
		TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)	
	end)
	ProgressBar(Lang("bleedingbandage_use_item"), 7000, {whileDead = false, canCancel = false}, function(cancelled)
		ClearPedTasks(PlayerPedId())
		RemoveAnimDict(dict)
		shouldstopBleeding = true
		DetachEntity(prop)
		DeleteEntity(prop)
		lastKnownHealth = GetEntityHealth(PlayerPedId())
		TriggerServerEvent("esx:removeItem", item.name, 1, item.slot)
		ESX.ShowNotification(Lang("patched_bleeding"), "inform", 5000)
	end)
end)

RegisterNetEvent('esx_basicneeds:onEat', function(details)
	local prop = GetHashKey('prop_cs_burger_01')
	local armor = 0
	if details and details.prop_name then
		prop = GetHashKey(FoodProps[details.prop_name])
	end
	if details and details.armor then
		armor = details.armor
	end
	if not IsAnimated then
		IsAnimated = true
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local model = prop
		loadModel(model)
		local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true)
		SetEntityCollision(prop, false)
		local boneIndex = GetPedBoneIndex(ped, 18905)
		AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(model)
		local dict = 'mp_player_inteat@burger'
		local anim = 'mp_player_int_eat_burger_fp'
		SetTimeout(500, function()
			loadAnim(dict)
			TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)	
		end)
		ProgressBar((Lang("eating_use_item")):format(ESX.Shared.Items[details.name].label), 7000, {whileDead = false, canCancel = false}, function(cancelled)
			if armor > 0 then
				local temp_armor = GetPedArmour(ped)
				SetPedArmour(ped, temp_armor + armor)
			end
			IsAnimated = false
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			RemoveAnimDict(dict)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('esx_basicneeds:onDrink', function(details)
	print(json.encode(details))
	local prop = GetHashKey('prop_ld_flow_bottle')
	local armor = 0
	if details and details.prop_name then
		prop = GetHashKey(DrinkProps[details.prop_name])
	end
	if not IsAnimated then
		IsAnimated = true
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local model = prop
		loadModel(model)
		local prop = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true, true, true)
		SetEntityCollision(prop, false)
		local boneIndex = GetPedBoneIndex(ped, 57005)
		AttachEntityToEntity(prop, ped, boneIndex, 0.15, 0.07, -0.011, 250.0, 180.0, 35.0, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(model)
		local dict = "amb@world_human_drinking@beer@male@idle_a"
		local main = "idle_c"
		if IsPedInAnyVehicle(ped, false) then
			dict = "amb@code_human_in_car_mp_actions@drink@std@rds@base"
			main = "idle_a"
		end
		SetTimeout(500, function()
			loadAnim(dict)
			TaskPlayAnim(ped, dict, main, 8.0, -8, -1, 49, 0, 0, 0, 0)		
		end)
		ProgressBar((Lang("drinking_use_item")):format(ESX.Shared.Items[details.name].label), 7000, {whileDead = false, canCancel = false}, function(cancelled)
			if armor > 0 then
				local temp_armor = GetPedArmour(ped)
				SetPedArmour(ped, temp_armor + armor)
			end
			IsAnimated = false
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			RemoveAnimDict(dict)
			DeleteObject(prop)
		end)
	end
end)

RegisterNetEvent('consumables:useLockpick', function(item)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if item.name == "advancedlockpick" then
		-- local currentHouse = exports.housing:isCloseToRobbableHouse()
		-- if exports.robberies:currentlyInBank() then
		-- 	TriggerEvent('consumables:bankLockpick', item)
		-- elseif currentHouse then
		-- 	TriggerEvent('houserobberies:tryLockpickHouse', currentHouse, item)
		-- end
	elseif item.name == "lockpick" then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		if vehicle == 0 or vehicle == nil then
			vehicle = GetClosestVehicle(coords, 8.0, 0, 12294)
		end
		if vehicle > 0 then
			local vehCo = GetEntityCoords(vehicle)
			if #(vehCo - coords) < 3.0 then
				if GetVehicleDoorLockStatus(vehicle) == 2 then
					TriggerEvent("esx:lockpickUsed", item)
				else 
					ESX.ShowNotification(Lang("veh_already_unlocked"), 'error', 5000)
				end
			end
		end
	end
end)

--Vests

RegisterNetEvent('esx_basicneeds:heavybulletproof', function()
	local playerPed = PlayerPedId()
	ProgressBar(Lang("vest_use_item"), 5000, {whileDead = false, canCancel = false, dict = "clothingtie", anim = "try_tie_negative_a", flags = 49}, function(cancelled)
		if not cancelled then
			TriggerServerEvent('esx:removeItem', 'heavybulletproof', 1)
			AddArmourToPed(playerPed, 200)
			SetPedArmour(playerPed, 200)
			ClearPedTasks(playerPed)
		else
			ClearPedTasks(playerPed)
		end
	end)
end)

RegisterNetEvent('esx_basicneeds:bulletproof', function()
	local playerPed = PlayerPedId()
	local armor = GetPedArmour(playerPed)
	ProgressBar(Lang("vest_use_item"), 3500, {whileDead = false, canCancel = false, dict = "clothingtie", anim = "try_tie_negative_a", flags = 49}, function(cancelled)
		if not cancelled then
			TriggerServerEvent('esx:removeItem', 'bulletproof', 1)
			if armor + 100 <= 200 then
				AddArmourToPed(playerPed, 100)
			else
				SetPedArmour(playerPed, 200)
			end
		else
			ClearPedTasks(playerPed)
		end
	end)
end)

RegisterNetEvent('esx_basicneeds:bulletproof_mini', function()
	local playerPed = PlayerPedId()
	local earmor = GetPedArmour(playerPed)
	ProgressBar(Lang("vest_use_item"), 2500, {whileDead = false, canCancel = false, dict = "clothingtie", anim = "try_tie_negative_a", flags = 49}, function(cancelled)
		if not cancelled then
			if earmor < 150 then
				earmor = earmor + 50
				AddArmourToPed(playerPed, earmor)
				SetPedArmour(playerPed, earmor)
				TriggerServerEvent('esx:removeItem', 'bulletproof_mini', 1)
			else
				earmor = 200
				AddArmourToPed(playerPed, earmor)
				SetPedArmour(playerPed, earmor)
				TriggerServerEvent('esx:removeItem', 'bulletproof_mini', 1)
			end
		else
			ClearPedTasks(playerPed)
		end
	end)
end)

RegisterNetEvent('esx_basicneeds:vest', function()
	local playerPed = PlayerPedId()
	ProgressBar(Lang("vest_use_item"), 2500, {whileDead = false, canCancel = false, dict = "clothingtie", anim = "try_tie_negative_a", flags = 49}, function(cancelled)
		if not cancelled then
			TriggerServerEvent('esx:removeItem', 'vest', 1)
			AddArmourToPed(playerPed, 100)
			SetPedArmour(playerPed, 100)
		else
			ClearPedTasks(playerPed)
		end
	end)
end)

RegisterNetEvent('used:id_card', function(data) 
	local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
	if #(data.pos - pos) < 3.0 then 
		if ESX.Config.UseUIforIDCard then
			local id_ped = GetPlayerPed(GetPlayerFromServerId(data.id))
			if DoesEntityExist(id_ped) then
				local mugshot = RegisterPedheadshot(id_ped)
				while not IsPedheadshotReady(mugshot) do
                    Wait(100)
                end
                local txdString = GetPedheadshotTxdString(mugshot)
				local data = {
					mugshot = txdString,
					mugshotId = mugshot,
					firstname = data.name.first,
					lastname = data.name.last,
					birthdate = data.dob,
					gender = data.sex
				}
				SendNUIMessage({
					action = "show_id",
					values = data					
				})
				UnregisterPedheadshot(mugshot)
				isInIDMenu = true
			end
		else
			local ped = GetPlayerPed(GetPlayerFromServerId(data.id))
			local title = ' Card:'
			local name = 'Name: '..data.name.first..' '..data.name.last
			local message = 'Birth: '..data.dob
			local sex = "Male"
			if data.sex == "F" or data.sex == "f" then
				sex = "Female"
			end
			local message2 = 'Gender: '..sex
			TriggerEvent('chat:addMessage', {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; font-weight:bold;box-shadow: 0px 2px 5px 0px rgb(0, 0, 0), 0px 2px 5px 0px rgba(0, 0, 0, 0.50); background-color: rgba(0, 0, 255, 0.6); border-radius: 8px;"><i class="fas fa-passport"></i>{0}<br> {1} <br> {2} <br> {3}</div>',
                args = { title, name, message, message2 }
            })
		end
	end
end)

RegisterNetEvent('used:license', function(data) 
	local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
	if #(data.pos - pos) < 3.0 then 
		if ESX.Config.UseUIforIDCard then
			local id_ped = GetPlayerPed(GetPlayerFromServerId(data.id))
			if DoesEntityExist(id_ped) then
				local mugshot = RegisterPedheadshot(id_ped)
				while not IsPedheadshotReady(mugshot) do
                    Wait(100)
                end
                local txdString = GetPedheadshotTxdString(mugshot)
				local data = {
					mugshot = txdString,
					mugshotId = mugshot,
					firstname = data.name.first,
					lastname = data.name.last,
					birthdate = data.dob,
					gender = data.sex,
					type = data.type,
					licenses = data.licenses
				}
				SendNUIMessage({
					action = "show_license",
					values = data					
				})
				UnregisterPedheadshot(mugshot)
				isInLicenseMenu = true
			end
		else
			local ped = GetPlayerPed(GetPlayerFromServerId(data.id))
			local message = 'Birth: '..data.dob
			local sex = "Male"
			if data.sex == "F" or data.sex == "f" then
				sex = "Female"
			end
			local text = "<br>"
			for i=1,#data.licenses do
				local temp_license = data.licenses[i]
				if i == #data.licenses then
					text = text.." <strong> "..temp_license.."</strong>"
				else
					text = text.." <strong> "..temp_license.."</strong> <br>"
				end
			end
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.5vw; margin: 0.5vw; font-weight:bold;box-shadow: 0px 2px 5px 0px rgb(0, 0, 0), 0px 2px 5px 0px rgba(0, 0, 0, 0.50); background-color: rgba(0, 0, 255, 0.6); border-radius: 8px;"><i class="fas fa-car"></i><strong>{0}:</strong><br><br><strong>First Name:</strong> {1} <br><strong>Last Name:</strong> {2} <br><strong>Birth:</strong> {3} <br><strong>Gender:</strong> {4} <br> <strong>Licenses:</strong>'..text..'</div></div>',
				args = {' License', data.name.first, data.name.last, message, sex}
			})
		end
	end
end)

CreateThread(function()
	while true do
		local sleep = 300
		if isInIDMenu then 
			sleep = 3
			if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 194) or IsControlJustReleased(0, 202) then
				isInIDMenu = false
				SendNUIMessage({action = "hide_id"})
			end
		end
		if isInLicenseMenu then
			sleep = 3
			if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 194) or IsControlJustReleased(0, 202) then
				isInLicenseMenu = false
				SendNUIMessage({action = "hide_license"})
			end
		end
		Wait(sleep)
	end
end)

local walkstickused = false
local currentWalkingStick = nil

RegisterNetEvent('walkingstick:used',function()
	ClearPedTasks(PlayerPedId())
	CreateThread(function()
        if not walkstickused then
            local ped = PlayerPedId()
            local propName = "prop_cs_walking_stick"
            local coords = GetEntityCoords(ped)
            local prop = GetHashKey(propName)
            local dict = "cellphone@"
            local name = "cellphone_call_to_text"
            RequestWalking("move_lester_caneup")
            SetPedMovementClipset(ped, "move_lester_caneup", 1.0)
			loadAnim(dict)
			loadModel(prop)
            currentWalkingStick = CreateObject(prop, coords, true, false, false)
            local netid = ObjToNet(currentWalkingStick)
            AttachEntityToEntity(currentWalkingStick, ped, GetPedBoneIndex(ped, 57005), 0.15, 0.0, -0.00, 0.0, 266.0, 0.0, false, false, false, true, 2, true)
            walkstickused = true
        else
            ResetPedMovementClipset(PlayerPedId())
            walkstickused = false
            ClearPedSecondaryTask(PlayerPedId())
            SetModelAsNoLongerNeeded(GetHashKey("prop_cs_walking_stick"))
            SetEntityAsMissionEntity(currentWalkingStick, true, false)
            DetachEntity(NetToObj(currentWalkingStick), 1, 1)
            DeleteEntity(NetToObj(currentWalkingStick))
            DeleteEntity(currentWalkingStick)
            currentWalkingStick = nil
			TriggerEvent("emotes:setLastKnownWalkingStyle")
        end
    end)
end)

RemoveWalkingStick = function()
	if currentWalkingStick and walkstickused then
		ResetPedMovementClipset(PlayerPedId())
		walkstickused = false
		ClearPedSecondaryTask(PlayerPedId())
		SetModelAsNoLongerNeeded(GetHashKey("prop_cs_walking_stick"))
		SetEntityAsMissionEntity(currentWalkingStick, true, false)
		DetachEntity(currentWalkingStick, 1, 1)
		DeleteEntity(currentWalkingStick)
		currentWalkingStick = nil
		TriggerEvent("emotes:setLastKnownWalkingStyle")
	end
end

function RequestWalking(set)
	if not HasAnimSetLoaded(set) then
		RequestAnimSet(set)
		while not HasAnimSetLoaded(set) do
			Wait(0)
		end
	end
end

local isDoingYoga = false

CreateThread(function()
	local yogamats = {}
	for k, v in pairs(Config.YogaMats) do
		table.insert(yogamats, v)
	end
	exports[Config.TargetResource]:AddTargetModel(yogamats, {
        distance = 1.25,
        options = {
            {
                icon = "fa-solid fa-arrow-up-from-bracket",
                label = "Pick Up",
				event = 'basicneeds:pickupmat',
				canInteract = function(entity)
					if DoesEntityExist(entity) and not isDoingYoga then
						return true
					end
					return false
				end,
            },
            {
                event = 'basicneeds:lotusflower',
                icon = "fa-solid fa-lungs",
                label = "Do Yoga",
				canInteract = function(entity)
					if DoesEntityExist(entity) and not isDoingYoga then
						return true
					end
					return false
				end,
            },
        },
    }) 
end)

RegisterNetEvent('basicneeds:pickupmat', function(data)
	local entity = data.entity
	local ped = PlayerPedId()
	local dict, anim = "amb@medic@standing@kneel@base", "base"
	local dict2, anim2 = "anim@gangops@facility@servers@bodysearch@", "player_search"
	loadAnim(dict)
	loadAnim(dict2)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(ped, dict2, anim2, 8.0, -8.0, -1, 48, 0, false, false, false)
    Wait(5000)
    ClearPedTasks(ped)
    TriggerServerEvent('basicneeds:pickupmat', NetworkGetNetworkIdFromEntity(entity),GetEntityModel(entity))
    RemoveAnimDict(dict)
    RemoveAnimDict(dict2)
end)

RegisterNetEvent('basicneeds:lotusflower',function()
	local ped = PlayerPedId()
	if isDoingYoga then return end
	isDoingYoga = true
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_YOGA', 0, true)
	ProgressBar(Lang("doing_yoga"), 40000, {whileDead = false, canCancel = true, movement = true}, function(cancelled)
		if not cancelled then
			ClearPedTasks(ped)
			isDoingYoga = false
			TriggerEvent('esx_status:remove', "stress", 10000)
		else
			ClearPedTasks(ped)
			isDoingYoga = false
		end
	end)
end)

AllowedGrounds = {
    [21] = true,
    [32] = true,
    [35] = true,
    [40] = true,
    [85] = true,
    [33] = true,
    [46] = true,
    [48] = true,
    [47] = true,
    [18] = true
}

TryPlantMat = function(pos, cb)
    local vehtodelete
    local value
    local coords = GetEntityCoords(PlayerPedId())
	if AllowedGrounds then
		local new_pos = { x = coords.x, y = coords.y, z = coords.z }
		ESX.Game.SpawnLocalVehicle('bmx', new_pos , 0.0, function(veh)  
			SetEntityVisible(veh, false)
			SetEntityNoCollisionEntity(veh, PlayerPedId())
			SetEntityCollision(veh, true, true) 
			SetVehicleOnGroundProperly(veh)
			vehtodelete = veh
		end)
		while not vehtodelete do Wait(100) end
		local m_id = GetVehicleWheelSurfaceMaterial(vehtodelete, 1)  
		if AllowedGrounds[m_id] then
			value = true
		else
			value = false
		end
		ESX.Game.DeleteVehicle(vehtodelete)
		while value == nil do Wait(100) end
	else
		value = false
	end
    cb(value)
end

RegisterNetEvent('basicneeds:yogamat', function(item, model)
    local ped = PlayerPedId()
	local new_pos = GetEntityCoords(ped)
	TryPlantMat(new_pos, function(canPlant)
		if canPlant then
			TriggerServerEvent('esx:removeItem', item.name, 1, item.slot)
			local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.85)
			local x, y, z = table.unpack(offset)
			loadModel(model)
			local dict, anim = 'amb@medic@standing@kneel@base', "base"
			local dict2, anim2 = 'anim@gangops@facility@servers@bodysearch@', 'player_search'
			loadAnim(dict)
			loadAnim(dict2)
			TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
			TaskPlayAnim(ped, dict2, anim2, 8.0, -8.0, -1, 48, 0, false, false, false)
			Wait(2500)
			ClearPedTasks(ped)
			local yogaMat = CreateObjectNoOffset(model, x, y, z, true, false)
			SetModelAsNoLongerNeeded(model)
			PlaceObjectOnGroundProperly(yogaMat)
			RemoveAnimDict(dict)
			RemoveAnimDict(dict2)
		end
	end)
end)

local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local binoculars = false
local fov = (fov_max+fov_min)*0.5
local keybindEnabled = false -- When enabled, binocular are available by keybind
local binocularKey = 73 -- X
local storeBinoclarKey = 177 -- Backspace
local prop_binoc = nil

CreateThread(function()
    while true do
        Wait(3000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)
        if binoculars then
            binoculars = true
			local boneIndex = GetPedBoneIndex(ped, 28422)
			local pedCo = GetEntityCoords(ped, true)
			local x, y, z = table.unpack(pedCo)
			local model = GetHashKey("prop_binoc_01")
			loadModel(model)
			prop_binoc = CreateObject(model, x, y, z + 0.2, true)
			AttachEntityToEntity(prop_binoc, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
			CreateThread(function()
				TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BINOCULARS", 0, 1)
				PlayAmbientSpeech1(ped, "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
			end)
			SetModelAsNoLongerNeeded(model)
            Wait(2000)
            SetTimecycleModifier("default")
            SetTimecycleModifierStrength(0.3)
            local scaleform = RequestScaleformMovie("BINOCULARS")
            while not HasScaleformMovieLoaded(scaleform) do
                Wait(10)
            end
            local vehicle = GetVehiclePedIsIn(ped)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
            AttachCamToEntity(cam, ped, 0.0,0.0,1.0, true)
            SetCamRot(cam, 0.0,0.0,GetEntityHeading(ped))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, 1, 0)
            PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
            PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
            PopScaleformMovieFunctionVoid()
            while binoculars and not IsEntityDead(ped) and (GetVehiclePedIsIn(ped) == vehicle) and IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_BINOCULARS") and true do
                if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ClearPedTasks(PlayerPedId())
                    binoculars = false
                end
                local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                CheckInputRotation(cam, zoomvalue)
                HandleZoom(cam)
                HideHUDThisFrame()
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                Wait(1)
            end
            binoculars = false
            ClearTimecycleModifier()
            fov = (fov_max+fov_min)*0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
			Wait(2500)
			DetachEntity(prop_binoc)
			DeleteObject(prop_binoc)
			prop_binoc = nil
        end
    end
end)

RegisterNetEvent('esx_basicneeds:binoculars', function()
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		return
	end
    binoculars = not binoculars
    if not binoculars then
        ClearPedTasks(PlayerPedId())
    end
end)

function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

function HandleZoom(cam)
    local ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
    end
end

local takePhoto = false

RegisterCommand('repairme', function()
	DestroyMobilePhone()
	CellCamActivate(false, false)
	takePhoto = false
end)

local function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNetEvent('inventory:client:polaroid', function(hook, itemData)
	local frontCam = false
	takePhoto = true
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    while takePhoto do
		Wait(0)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        EnableAllControlActions(0)
        if IsControlJustPressed(1, 27) then -- Toogle Mode
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then -- CANCEL
            DestroyMobilePhone()
            CellCamActivate(false, false)
			takePhoto = false
        elseif IsDisabledControlJustPressed(1, 176) then -- TAKE.. PIC
			if hook and HasItem("polaroid_paper", 1) then
				exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function(data)
					local image = json.decode(data)
					local url = image.attachments[1].proxy_url
					DestroyMobilePhone()
					CellCamActivate(false, false)
					TriggerServerEvent('inventory:server:savePhoto', url, itemData)
				end)
			else
				takePhoto = false
				return
			end
            takePhoto = false
        end
    end
end)

RegisterNetEvent('anims:client:bandage1', function()
	ExecuteCommand('e bandage1')
	ESX.ShowNotification('Press [X] anytime to cancel')
end)

RegisterNetEvent('anims:client:radio_look', function()
	ExecuteCommand('e radio_look')
	ESX.ShowNotification('Press [X] anytime to cancel')
end)

RegisterNetEvent('anims:client:surgery', function()
	ExecuteCommand('e surgery')
	ESX.ShowNotification('Press [X] anytime to cancel')
end)

RegisterNetEvent('anims:client:syringe', function()
	ExecuteCommand('e syringe')
end)

RegisterNetEvent('anims:client:thermo', function()
	ExecuteCommand('e thermo')
	ESX.ShowNotification('Press [X] anytime to cancel')
end)

RegisterNetEvent('anims:client:defibrillator', function()
	ExecuteCommand('e defibrillator')
end)

RegisterNetEvent('boostingtab:use')
AddEventHandler('boostingtab:use', function()
    ExecuteCommand('boosting')
end)


RegisterNetEvent("onMechanic:useItem", function(item)
    for i=1,#Config.MechanicItems do
        if Config.MechanicItems[i].name == item.name then
            Config.MechanicItems[i].onUse(nil, item)
        end
    end
end)
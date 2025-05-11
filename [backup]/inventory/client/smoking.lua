local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168,["F11"] = 344, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local StartSmoke = false
local give = false
local liquid = false
local propsmoke_net = nil
local mouthsmoke_net = nil
local success = false
local WeedEffect = false
local ReductionEffect = false
local timer = false
local weed = false
local hand = false
local mouth = false
local particleDict = "core"
local particleName = "exp_grd_bzgas_smoke"
local temp_size
local smoking_type = nil

local multiplier = 0.0
local joint = 0.1159949
local bong = 0.5359949
local minusphase4 = 0.014048
local maxhighdone = 0.8309426647617
local maxhigh = 0.9309426647617
local minhigh = 0.1249949

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do 
		Wait(0) 
	end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

local loadProp = function(model)
	if not HasModelLoaded(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end
	end
end

local loadPtfx = function(effect)
	if not HasNamedPtfxAssetLoaded(effect) then
		RequestNamedPtfxAsset(effect)
		while not HasNamedPtfxAssetLoaded(effect) do
			Wait(0)
		end
	end
end

RegisterNetEvent('smoking_sys::checkbong', function(item)
	TriggerServerEvent('smoking_sys:server:checkbong', item)
end)

CreateThread(function()
	while true do
		Wait(300)
		if not StartSmoke then
			if smoking_type then
				smoking_type = nil
			end
		end
	end
end)

RemoveVape = function()
	if smoking_type and smoking_type == "vape" then
		local playerPed = PlayerPedId()
		StartSmoke = false
		ClearPedTasks(playerPed)
		mouth = false
		hand = false
		timer = false
		give = false
		Wait(1500)
		DetachEntity(NetToObj(propsmoke_net), 1, 1)
		DeleteEntity(NetToObj(propsmoke_net))
		propsmoke_net = nil
		smoking_type = nil
	end
end

RemoveBong = function()
	if smoking_type and smoking_type == "bong" then
		local playerPed = PlayerPedId()
		StartSmoke = false
		ClearPedTasks(playerPed)
		mouth = false
		hand = false
		timer = false
		give = false
		Wait(1500)
		DetachEntity(NetToObj(propsmoke_net), 1, 1)
		DeleteEntity(NetToObj(propsmoke_net))
		propsmoke_net = nil
		smoking_type = nil
	end
end

RegisterNetEvent('smoking_sys:client:Smoke', function(item, size, prop, type, time)
	temp_size = size
	if StartSmoke == true then
		ESX.ShowNotification("You already smoke", 'error')
	else
		smoking_type = type
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		if type == 'cigarette' then
			playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
			Wait(1000)
			local model = GetHashKey(prop)
			local model2 = GetHashKey('ex_prop_exec_lighter_01')
			loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9, true, true, true)
			local bone1 = GetPedBoneIndex(playerPed, 64097)
			AttachEntityToEntity(mainprop, playerPed, bone1, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			Wait(800)
			loadProp(model2)
			lighter = CreateObject(model2, x, y, z + 0.9, true, true, true)
			local bone2 = GetPedBoneIndex(playerPed, 4089)
			AttachEntityToEntity(lighter, playerPed, bone2, 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
			playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
			Wait(800)
            SetModelAsNoLongerNeeded(model)
            SetModelAsNoLongerNeeded(model2)
			local netid = ObjToNet(mainprop)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			timer = true
			StartSmoke = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'cigar' then
			playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
			Wait(1000)
			local model = GetHashKey(prop)
			local model2 = GetHashKey('ex_prop_exec_lighter_01')
			loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9, true, true, true)
			local bone1 = GetPedBoneIndex(playerPed, 64097)
			local bone2 = GetPedBoneIndex(playerPed, 4089)
			AttachEntityToEntity(mainprop, playerPed, bone1, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
			Wait(800)
			loadProp(model2)
			lighter = CreateObject(model2, x, y, z + 0.9, true, true, true)
			AttachEntityToEntity(lighter, playerPed, bone2, 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
			playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
			Wait(800)
			local netid = ObjToNet(mainprop)
            SetModelAsNoLongerNeeded(model)
            SetModelAsNoLongerNeeded(model2)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			timer = true
			StartSmoke = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'joint' then
			playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
			Wait(1000)
			local model = GetHashKey(prop)
			local model2 = GetHashKey('ex_prop_exec_lighter_01')
			loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9, true, true, true)
			local bone1 = GetPedBoneIndex(playerPed, 64097)
			local bone2 = GetPedBoneIndex(playerPed, 4089)
			AttachEntityToEntity(mainprop, playerPed, bone1, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			Wait(800)
			loadProp(model2)
			lighter = CreateObject(model2, x, y, z + 0.9, true, true, true)
			AttachEntityToEntity(lighter, playerPed, bone2, 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)
			playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
			Wait(800)
			local netid = ObjToNet(mainprop)
			SetNetworkIdExistsOnAllMachines(netid, true)
            SetModelAsNoLongerNeeded(model)
            SetModelAsNoLongerNeeded(model2)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			timer = true
			StartSmoke = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'vape' then
			local model = GetHashKey(prop)
			loadProp(model)
			local bone1 = GetPedBoneIndex(playerPed, 18905)
			mainprop = CreateObject(model, x, y, z + 0.9, true, true, true)
			AttachEntityToEntity(mainprop, playerPed, bone1, 0.13, 0.04, 0.0, 0.0, -140.0, -140.0, true, true, false, true, 1, true)
			local netid = ObjToNet(mainprop)
            SetModelAsNoLongerNeeded(model)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			StartSmoke = true
			hand = true
		end
		if type == 'bong' then
			local model = GetHashKey(prop)
			loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9, true, true, true)
			local bone1 = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(mainprop, playerPed, bone1, 0.10, -0.25, 0.0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
			local netid = ObjToNet(mainprop)
            SetModelAsNoLongerNeeded(model)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			StartSmoke = true
			hand = true
		end
		while true do
			Wait(1)
			if StartSmoke then
				if Config.Smoking.DisableCombatButtons then
					DisablePlayerFiring(PlayerId(), true)
					DisableControlAction(0,229, true)
					DisableControlAction(0,223, true)
					DisableControlAction(0,142, true)
					DisableControlAction(0,25, true)
					DisableControlAction(0,347, true)
				end
				if hand then
					if give then
						ESX.ShowHelpNotification("~INPUT_PICKUP~Give ~INPUT_VEH_DUCK~Cancel")
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 2.5 then
							target_id = GetPlayerPed(closestPlayer)
							playerX, playerY, playerZ = table.unpack(GetEntityCoords(target_id))
							DrawMarker(0, playerX, playerY, playerZ+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 10, 255, 0, 100, true, true, 2, true, false, false, false)
							if IsControlJustPressed(0, Config.Smoking.ConfirmGiveButton) then
								DetachEntity(NetToObj(propsmoke_net), 1, 1)
								if type == 'joint' or type == 'cigarette' or type == 'cigar' then
									TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
								end
								Wait(100)
								DeleteEntity(NetToObj(propsmoke_net))
								propsmoke_net = nil
								TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
								TriggerServerEvent('smoking_sys:server:Receiver', GetPlayerServerId(closestPlayer), item, temp_size, prop, type, time)
								ClearPedTasks(playerPed)
								StartSmoke = false
								mouth = false
								timer = false
								hand = false
								give = false
								playAnim("mp_common","givetake1_a", 1800)
								break
							end
						elseif IsControlJustPressed(0, Config.Smoking.CancelGiveButton) then
							give = false
							ClearPedTasks(playerPed)
							Wait(200)
						end
					else
						if type == 'vape' then
							ESX.ShowHelpNotification("~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Hide                           ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Charge | "..temp_size.." ml")
						else
							if type == 'bong' then
								ESX.ShowHelpNotification('~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Hide                           ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Charge | '..temp_size..' g')
							else
								ESX.ShowHelpNotification('~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Throw                          ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Mouth')
							end
						end
					end
				end
				if mouth then
					ESX.ShowHelpNotification('~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Throw ~INPUT_SCRIPTED_FLY_ZDOWN~Hand')
				end
				if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
					if temp_size <= 0 then
						temp_size = 0
						Wait(200)
						StartSmoke = false
						if mouth then
							playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
                            local bone = GetPedBoneIndex(playerPed, 64097)
							if type == 'cigarette' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
							end
							if type == 'cigar' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
							end
							if type == 'joint' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
							end
						end
						TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
						mouth = false
						hand = false
						timer = false
						give = false
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						Wait(2000)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						break
					end
				end
				if IsPedInAnyVehicle(playerPed, true) then
					local playerVeh = GetVehiclePedIsIn(playerPed, false)
					RollDownWindow(playerVeh, 0)
				end
				if IsEntityInWater(playerPed) then
					StartSmoke = false
					TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
					if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
					end
					mouth = false
					hand = false
					timer = false
					give = false
					DetachEntity(NetToObj(propsmoke_net), 1, 1)
					Wait(2000)
					DeleteEntity(NetToObj(propsmoke_net))
					propsmoke_net = nil
				end
				if not give and not exports["nh-context"]:inMenu() and IsControlJustPressed(0, Config.Smoking.SmokeButton) then
					if multiplier >= 0.9009426647617 then
						if type == 'joint' or type == 'bong' then
							ESX.ShowNotification('I\'ve had enough', 'error')
						end
					else
						if hand then
                            local model = GetHashKey('prop_cigar_01')
                            loadProp(model)
							mouthsmokeprop = CreateObject(model, x, y, z + 0.9, true, true, true)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							AttachEntityToEntity(mouthsmokeprop, playerPed, bone, 0.005, 0.05, 0.003, 30.0, 0.0, 110.0, true, true, false, true, 1, true)
							local netidsmoke = ObjToNet(mouthsmokeprop)
							SetNetworkIdExistsOnAllMachines(netidsmoke, true)
                            SetModelAsNoLongerNeeded(model)
							NetworkSetNetworkIdDynamic(netidsmoke, true)
							SetNetworkIdCanMigrate(netidsmoke, false)
							mouthsmoke_net = netidsmoke
							hand = false
							if type == 'bong' or type == 'vape' then
								if temp_size < 0.5 then
									temp_size = 0
									ESX.ShowNotification('You have it empty', 'error', 3000)
									hand = true
									DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
									DeleteEntity(NetToObj(mouthsmoke_net))
									mouthsmoke_net = nil
								else
									if type == 'bong' then
										playAnim('anim@safehouse@bong', 'bong_stage1', 7000)
										Wait(7500)
										TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
										temp_size = temp_size - Config.Smoking.BongSizeRemove
										Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
										hand = true
										TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
										DoScreenFadeOut(250)
										Wait(1000)
										DoScreenFadeIn(250)
										if Config.Smoking.AddArmor then
											SetPedArmour(PlayerPedId(), Config.Smoking.Armor)
										end
										TriggerEvent('esx_status:remove', "stress", 45000)
										WeedEffect = true
										ReductionEffect = true
										multiplier = multiplier + bong
										Wait(300)
										DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
										DeleteEntity(NetToObj(mouthsmoke_net))
									else
										playAnim('mp_player_inteat@burger', 'mp_player_int_eat_burger', 1000)
										Wait(900)
										TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
										temp_size = temp_size - Config.Smoking.VapeSizeRemove
										Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
										hand = true
										TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
										Wait(300)
										DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
										DeleteEntity(NetToObj(mouthsmoke_net))
										mouthsmoke_net = nil
									end
								end
							else
								playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a', 2800)
								Wait(2800)
								TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
								temp_size = temp_size - math.random(Config.Smoking.SizeRemove.min, Config.Smoking.SizeRemove.max)
								Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
								hand = true
								if type == 'joint' then
									WeedEffect = true
									ReductionEffect = true
									multiplier = multiplier + joint
								end
								TriggerEvent('esx_status:remove', "stress", 30000)
								if type == 'joint' and Config.Smoking.AddArmor then
									SetPedArmour(playerPed, Config.Smoking.Armor)
								end
								TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
								Wait(300)
								DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
								DeleteEntity(NetToObj(mouthsmoke_net))
								mouthsmoke_net = nil
							end
						end
						if mouth then
							mouth = false
							Wait(1000)
                            local model = GetHashKey('prop_cigar_01')
                            loadProp(model)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							mouthsmokeprop = CreateObject(model, x, y, z+0.9,  true,  true, true)
							AttachEntityToEntity(mouthsmokeprop, playerPed, bone, 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
							local netidsmoke = ObjToNet(mouthsmokeprop)
							SetNetworkIdExistsOnAllMachines(netidsmoke, true)
							NetworkSetNetworkIdDynamic(netidsmoke, true)
                            SetModelAsNoLongerNeeded(model)
							SetNetworkIdCanMigrate(netidsmoke, false)
							mouthsmoke_net = netidsmoke
							TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
							temp_size = temp_size - math.random(Config.Smoking.SizeRemove.min, Config.Smoking.SizeRemove.max)
							Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
							TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
							TriggerEvent('esx_status:remove', "stress", 30000)
							if type == 'joint' and Config.Smoking.AddArmor then
								SetPedArmour(playerPed, Config.Smoking.Armor)
							end
							Wait(300)
							mouth = true
							DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
							DeleteEntity(NetToObj(mouthsmoke_net))
							mouthsmoke_net = nil
						end
					end
				elseif not give and IsControlJustPressed(0, Config.Smoking.ThrowButton) then
					if mouth then
						ClearPedTasks(playerPed)
						playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
                        local bone = GetPedBoneIndex(playerPed, 64097)
						Wait(800)
						if type == 'cigarette' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
						if type == 'cigar' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
						end
						if type == 'joint' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
					end
					if type == 'bong' or type == 'vape' then
						StartSmoke = false
						ClearPedTasks(playerPed)
						mouth = false
						hand = false
						timer = false
						give = false
						Wait(1500)
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						break
					else
						ClearPedTasks(playerPed)
						StartSmoke = false
						Wait(800)
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
						TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
						mouth = false
						hand = false
						timer = false
						give = false
						Wait(2000)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						break
					end
				elseif not mouth and IsControlJustPressed(0, Config.Smoking.GiveButton) then
					give = true
				elseif not give and hand and IsControlJustPressed(0, Config.Smoking.MouthButton) then
					if type == 'vape' then
						if temp_size >= Config.Smoking.MaxLiquid then
							ESX.ShowNotification('It wont fit there anymore', 'error')
						else
							local elements = {}
							table.insert(elements,{
								header = "Refill Vape",
								disabled = true
							})
							for u=1,#Config.Smoking.Liquids do
								local itemData = Config.Smoking.Liquids[u]
								if HasItem(itemData, 1) then
									table.insert(elements, {
										header = ESX.Shared.Items[itemData].label,
										context = "Press to refill your tsibuk",
										event = "smoking_sys:server:CheckItem",
										server = true,
										args = {type, itemData}
									})
								end
							end
							TriggerEvent('nh-context:createMenu', elements)
						end
					else
						if type == 'bong' then
							if temp_size >= Config.Smoking.MaxWeed then
								ESX.ShowNotification("It wont fit there anymore", 'error')
							else
								menuOpen = true
								hand = false
								local playerPed = PlayerPedId()
								local elements = {}
								table.insert(elements,{
									header = "Refill Bong",
									disabled = true
								})
								for k, v in pairs(Config.Smoking.BongReloadItems) do
									if HasItem(v.Items, 1) then
										local labels = v.ItemsLabel
										table.insert(elements, {
											header = labels,
											context = "Press to use it on bong",
											event = "smoking_sys::checkbong",
											args = {v.Items}
										})
									end
								end
								TriggerEvent('nh-context:createMenu', elements)
							end
						else
							mouth = true
							hand = false
							playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
							Wait(800)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							if type == 'cigarette' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
							end
							if type == 'cigar' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.010, 0.0, 0.0, 50.0, 0.0, -80.0, true, true, false, true, 1, true)
							end
							if type == 'joint' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.010, 0.0, 0.0, 50.0, 0.0, 80.0, true, true, false, true, 1, true)
							end
						end
					end
				elseif not give and mouth and IsControlJustPressed(0, Config.Smoking.HandButton) then
					mouth = false
					hand = true
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
					Wait(1100)
                    local bone = GetPedBoneIndex(playerPed, 64097)
					if type == 'cigarette' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
					if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
					if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				end
			else
				break
			end
		end
	end
end)

RegisterNetEvent('smoking_sys:client:Receiver', function(item, size, prop, type, time)
	temp_size = size
	if StartSmoke == true then
		ESX.ShowNotification('You already smoke', 'error')
	else
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		playAnim("mp_common","givetake1_a", 1800)
		TriggerServerEvent('smoking_sys:server:AddItem', item, temp_size, prop, type, time)
		if type == 'cigarette' then
            local model = GetHashKey(prop)
            loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9,  true,  true, true)
            local bone = GetPedBoneIndex(playerPed, 64097)
			AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			Wait(800)
            SetModelAsNoLongerNeeded(model)
			local netid = ObjToNet(mainprop)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			StartSmoke = true
			timer = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'cigar' then
            local model = GetHashKey(prop)
            loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9,  true,  true, true)
            local bone = GetPedBoneIndex(playerPed, 64097)
			AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
			Wait(800)
            SetModelAsNoLongerNeeded(model)
			local netid = ObjToNet(mainprop)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			StartSmoke = true
			timer = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'joint' then
            local model = GetHashKey(prop)
            loadProp(model)
			mainprop = CreateObject(model, x, y, z+0.9,  true,  true, true)
            local bone = GetPedBoneIndex(playerPed, 64097)
			AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
			Wait(800)
            SetModelAsNoLongerNeeded(model)
			local netid = ObjToNet(mainprop)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			Wait(1300)
			DetachEntity(lighter, 1, 1)
			DeleteObject(lighter)
			Wait(1000)
			TriggerServerEvent("smoking_sys:server:StartPropSmoke", propsmoke_net, type)
			StartSmoke = true
			timer = true
			TriggerEvent('smoking_sys:client:RemoveSize', item, temp_size, prop, type, time)
			hand = true
		end
		if type == 'vape' then
            local model = GetHashKey(prop)
            loadProp(model)
			mainprop = CreateObject(model, x, y, z + 0.9,  true,  true, true)
            local bone = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(mainprop, playerPed, bone, 0.13, 0.04, 0.0, 0.0, -140.0, -140.0, true, true, false, true, 1, true)
			local netid = ObjToNet(mainprop)
            SetModelAsNoLongerNeeded(model)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			StartSmoke = true
			hand = true
		end
		if type == 'bong' then
            local model = GetHashKey(prop)
            loadProp(model)
			mainprop = CreateObject(model, x, y, z+0.9,  true,  true, true)
            local bone = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(mainprop, playerPed, bone, 0.10, -0.25, 0.0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
			local netid = ObjToNet(mainprop)
            SetModelAsNoLongerNeeded(model)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			propsmoke_net = netid
			StartSmoke = true
			hand = true
		end
		while true do
			Wait(1)
			if StartSmoke then
				if Config.Smoking.DisableCombatButtons then
					DisablePlayerFiring(PlayerId(), true)
					DisableControlAction(0, 229, true)
					DisableControlAction(0, 223, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 25, true)
					DisableControlAction(0, 347, true)
				end
				if hand then
					if give then
						ESX.ShowHelpNotification('~INPUT_PICKUP~Give ~INPUT_VEH_DUCK~Cancel')
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 2.5 then
							target_id = GetPlayerPed(closestPlayer)
							playerX, playerY, playerZ = table.unpack(GetEntityCoords(target_id))
							DrawMarker(0, playerX, playerY, playerZ + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 10, 255, 0, 100, true, true, 2, true, false, false, false)
							if IsControlJustPressed(0, Config.Smoking.ConfirmGiveButton) then
								DetachEntity(NetToObj(propsmoke_net), 1, 1)
								if type == 'joint' or type == 'cigarette' or type == 'cigar' then
									TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
								end
								Wait(100)
								DeleteEntity(NetToObj(propsmoke_net))
								propsmoke_net = nil
								TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
								TriggerServerEvent('smoking_sys:server:Receiver', GetPlayerServerId(closestPlayer), item, temp_size, prop, type, time)
								ClearPedTasks(playerPed)
								StartSmoke = false
								mouth = false
								timer = false
								hand = false
								give = false
								playAnim("mp_common","givetake1_a", 1800)
								break
							end
						elseif IsControlJustPressed(0, Config.Smoking.CancelGiveButton) then
							give = false
							ClearPedTasks(playerPed)
							Wait(200)
						end
					else
						if type == 'vape' then
							ESX.ShowHelpNotification("~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Hide                           ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Charge | "..size.." ml")
						else
							if type == 'bong' then
								ESX.ShowHelpNotification("~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Hide                           ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Charge | "..size.." g")
							else
								ESX.ShowHelpNotification("~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Throw                          ~INPUT_VEH_FLY_ATTACK_CAMERA~Give ~INPUT_SCRIPTED_FLY_ZUP~Mouth")
							end
						end
					end
				end
				if mouth then
					ESX.ShowHelpNotification("~INPUT_PARACHUTE_DEPLOY~Smoke ~INPUT_VEH_DUCK~Throw ~INPUT_SCRIPTED_FLY_ZDOWN~Hand")
				end
				if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
					if temp_size <= 0 then
						temp_size = 0
						if mouth then
							playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
                            local bone = GetPedBoneIndex(playerPed, 64097)
							if type == 'cigarette' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
							end
							if type == 'cigar' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
							end
							if type == 'joint' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
							end
						end
						StartSmoke = false
						mouth = false
						hand = false
						timer = false
						give = false
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
						TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						Wait(2000)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						TriggerEvent('esx_status:remove', "stress", 30000)
						if type == 'joint' and Config.Smoking.AddArmor then
							SetPedArmour(PlayerPedId(), Config.Smoking.Armor)
						end
						break
					end
				end
				if IsPedInAnyVehicle(playerPed, true) then
					local playerVeh = GetVehiclePedIsIn(playerPed, false)
					RollDownWindow(playerVeh, 0)
				end
				if IsEntityInWater(playerPed) then
					StartSmoke = false
					TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
					if type == 'cigarette' or type == 'cigar' or  type == 'joint' then
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
					end
					mouth = false
					hand = false
					timer = false
					give = false
					DetachEntity(NetToObj(propsmoke_net), 1, 1)
					Wait(2000)
					DeleteEntity(NetToObj(propsmoke_net))
					propsmoke_net = nil
				end
				if not give and not exports["nh-context"]:inMenu() and IsControlJustPressed(0, Config.Smoking.SmokeButton) then
					if type == 'joint' or type == 'bong' and multiplier > 0.9009426647617 then 
						ESX.ShowNotification('I ve had enough', 'error')
					else
						if hand then
                            local model = GetHashKey('prop_cigar_01')
                            loadProp(model)
							mouthsmokeprop = CreateObject(model, x, y, z+0.9,  true,  true, true)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							AttachEntityToEntity(mouthsmokeprop, playerPed, bone, 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
                            SetModelAsNoLongerNeeded(model)
							local netidsmoke = ObjToNet(mouthsmokeprop)
							SetNetworkIdExistsOnAllMachines(netidsmoke, true)
							NetworkSetNetworkIdDynamic(netidsmoke, true)
							SetNetworkIdCanMigrate(netidsmoke, false)
							mouthsmoke_net = netidsmoke
							hand = false
							if type == 'bong' or type == 'vape' then
								if temp_size < 0.5 then
									temp_size = 0
									ESX.ShowNotification('You have it empty', 'error')
									hand = true
									DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
									DeleteEntity(NetToObj(mouthsmoke_net))
									mouthsmoke_net = nil
								else
									if type == 'bong' then
										playAnim('anim@safehouse@bong', 'bong_stage1', 7000)
										Wait(7500)
										TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
										temp_size = temp_size - Config.Smoking.BongSizeRemove
										Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
										hand = true
										TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
										DoScreenFadeOut(250)
										Wait(1000)
										DoScreenFadeIn(250)
										if Config.Smoking.AddArmor then
											SetPedArmour(PlayerPedId(), Config.Smoking.Armor)
										end
										TriggerEvent('esx_status:remove', "stress", 45000)
										WeedEffect = true
										ReductionEffect = true
										multiplier = multiplier + bong
										Wait(300)
										DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
										DeleteEntity(NetToObj(mouthsmoke_net))
									else
										playAnim('mp_player_inteat@burger', 'mp_player_int_eat_burger', 1000)
										Wait(900)
										TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
										temp_size = temp_size - Config.Smoking.VapeSizeRemove
										Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
										hand = true
										TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
										Wait(300)
										DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
										DeleteEntity(NetToObj(mouthsmoke_net))
										mouthsmoke_net = nil
									end
								end
							else
								playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a', 2800)
								Wait(2800)
								TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
								temp_size = temp_size - math.random(Config.Smoking.SizeRemove.min, Config.Smoking.SizeRemove.max)
								Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
								hand = true
								if type == 'joint' then
									WeedEffect = true
									ReductionEffect = true
									multiplier = multiplier + joint
								end
								TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
								Wait(300)
								DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
								DeleteEntity(NetToObj(mouthsmoke_net))
								mouthsmoke_net = nil
							end
						end
						if mouth then
							mouth = false
							Wait(1000)
                            local model = GetHashKey('prop_cigar_01')
                            loadProp(model)
							mouthsmokeprop = CreateObject(model, x, y, z + 0.9, true, true, true)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							AttachEntityToEntity(mouthsmokeprop, playerPed, bone, 0.030, 0.05, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
							local netidsmoke = ObjToNet(mouthsmokeprop)
                            SetModelAsNoLongerNeeded(model)
							SetNetworkIdExistsOnAllMachines(netidsmoke, true)
							NetworkSetNetworkIdDynamic(netidsmoke, true)
							SetNetworkIdCanMigrate(netidsmoke, false)
							mouthsmoke_net = netidsmoke
							TriggerServerEvent("smoking_sys:server:StartMouthSmoke", mouthsmoke_net, type)
							temp_size = temp_size - math.random(Config.Smoking.SizeRemove.min, Config.Smoking.SizeRemove.max)
							Wait(math.random(Config.Smoking.ExhaleTime.min, Config.Smoking.ExhaleTime.max))
							TriggerServerEvent("smoking_sys:server:StopMouthSmoke", mouthsmoke_net)
							Wait(300)
							mouth = true
							DetachEntity(NetToObj(mouthsmoke_net), 1, 1)
							DeleteEntity(NetToObj(mouthsmoke_net))
							mouthsmoke_net = nil
						end
					end
				elseif not give and IsControlJustPressed(0, Config.Smoking.ThrowButton) then
					if mouth then
						ClearPedTasks(playerPed)
						playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
						Wait(800)
                        local bone = GetPedBoneIndex(playerPed, 64097)
						if type == 'cigarette' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
						if type == 'cigar' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
						end
						if type == 'joint' then
							AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						end
					end
					if type == 'bong' or type == 'vape' then
						StartSmoke = false
						ClearPedTasks(playerPed)
						mouth = false
						hand = false
						give = false
						timer = false
						Wait(1500)
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						break
					else
						ClearPedTasks(playerPed)
						StartSmoke = false
						Wait(800)
						DetachEntity(NetToObj(propsmoke_net), 1, 1)
						TriggerServerEvent('smoking_sys:server:RemoveItem', item, temp_size, prop, type, time)
						TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
						mouth = false
						hand = false
						give = false
						timer = false
						Citizen.Wait(2000)
						DeleteEntity(NetToObj(propsmoke_net))
						propsmoke_net = nil
						break
					end
				elseif not mouth and IsControlJustPressed(0, Config.Smoking.GiveButton) then
					give = true
				elseif not give and hand and IsControlJustPressed(0, Config.Smoking.MouthButton) then
					if type == 'vape' then
						if temp_size > Config.Smoking.MaxLiquid then
							ESX.ShowNotification('It wont fit there anymore', 'error')
						else
							TriggerServerEvent('smoking_sys:server:CheckItem', type)
							Wait(1000)
							if liquid then
								playAnim('mp_arresting', 'a_uncuff', 2000)
								Wait(1500)
								temp_size = temp_size + Config.Smoking.AddLiquidInVape
								liquid = false
							end
						end
					else
						if type == 'bong' then
							if temp_size >= Config.Smoking.MaxWeed then
								ESX.ShowNotification('It wont fit there anymore', 'error')
							else
								menuOpen = true
								hand = false
								local playerPed = PlayerPedId()
								local elements = {}
								table.insert(elements,{
									header = "Refill Bong",
									disabled = true
								})
								for k, v in pairs(Config.Smoking.BongReloadItems) do
									if HasItem(v.Items, 1) then
										local labels = v.ItemsLabel
										table.insert(elements, {
											header = labels,
											context = "Press to use it on bong",
											event = "smoking_sys::checkbong",
											args = {v.Items}
										})
									end
								end
								TriggerEvent('nh-context:createMenu', elements)
							end
						else
							mouth = true
							hand = false
							playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
							Wait(800)
                            local bone = GetPedBoneIndex(playerPed, 47419)
							if type == 'cigarette' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
							end
							if type == 'cigar' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.010, 0.0, 0.0, 50.0, 0.0, -80.0, true, true, false, true, 1, true)
							end
							if type == 'joint' then
								AttachEntityToEntity(mainprop, playerPed, bone, 0.010, 0.0, 0.0, 50.0, 0.0, 80.0, true, true, false, true, 1, true)
							end
						end
					end
				elseif not give and mouth and IsControlJustPressed(0, Config.Smoking.HandButton) then
					mouth = false
					hand = true
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
					Wait(1100)
                    local bone = GetPedBoneIndex(playerPed, 64097)
					if type == 'cigarette' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
					if type == 'cigar' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, -100.0, true, true, false, true, 1, true)
					end
					if type == 'joint' then
						AttachEntityToEntity(mainprop, playerPed, bone, 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
					end
				end
			else
				break
			end
		end
	end
end)

RegisterNetEvent('smoking_sys:client:CigarettesUnPack', function(source)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1000)
	Wait(800)
    local model = GetHashKey('prop_cigar_pack_01')
    loadProp(model)
	pack = CreateObject(model, x, y, z + 0.9, true, true, true)
    SetModelAsNoLongerNeeded(model)
    local bone = GetPedBoneIndex(playerPed, 64016)
	AttachEntityToEntity(pack, playerPed, bone, 0.020, -0.05, -0.010, 100.0, 0.0, 0.0, true, true, false, true, 1, true)
	playAnim('mp_arresting', 'a_uncuff', 3000)
	Wait(3000)
	DetachEntity(pack, 1, 1)
	Wait(2000)
	DeleteObject(pack)
end)

RegisterNetEvent('smoking_sys:client:AddLiquid', function()
	liquid = true
	Wait(1000)
	playAnim('mp_arresting', 'a_uncuff', 2000)
	Wait(1500)
	temp_size = temp_size + Config.Smoking.AddLiquidInVape
	liquid = false
end)

RegisterNetEvent('smoking_sys:client:AddBong', function(type)
	weed = true
	Wait(500)
	playAnim('mp_arresting', 'a_uncuff', 2000)
	Wait(1500)
	temp_size = temp_size + Config.Smoking.AddWeedInBong
	weed = false
	hand = true
end)

RegisterNetEvent('smoking_sys:client:RemoveSize', function(item, size, prop, type, time)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	while true do
		Wait(time)
		if timer then
			ClearPedTasks(playerPed)
			timer = false
			StartSmoke = false
			Wait(800)
			DetachEntity(NetToObj(propsmoke_net), 1, 1)
			mouth = false
			hand = false
			Wait(2000)
			TriggerServerEvent("smoking_sys:server:StopPropSmoke", propsmoke_net)
			Wait(500)
			DeleteEntity(NetToObj(propsmoke_net))
			propsmoke_net = nil
			break
		else
			break
		end
	end
end)

RegisterNetEvent("smoking_sys:client:StartPropSmoke", function(propsmokeid, type)
	if NetworkDoesNetworkIdExist(propsmokeid) then
		local entity = NetToObj(propsmokeid)
		if DoesEntityExist(entity) then
			loadPtfx(particleDict)
			UseParticleFxAssetNextCall(particleDict)
			if type == 'cigarette' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.CigaretteSmoke, false, false, false)
			end
			if type == 'cigar' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, 0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.CigarSmoke, false, false, false)
			end
			if type == 'joint' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.090, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.JointSmoke, false, false, false)
			end
		end
	end
end)

RegisterNetEvent("smoking_sys:client:StopPropSmoke", function(propsmokeid)
	if NetworkDoesNetworkIdExist(propsmokeid) then
		local entity = NetToObj(propsmokeid)
		if DoesEntityExist(entity) then
			RemoveParticleFxFromEntity(entity)
		end
	end
end)

RegisterNetEvent("smoking_sys:client:StartMouthSmoke", function(mouthsmokeid, type)
	if NetworkDoesNetworkIdExist(mouthsmokeid) then
		local entity = NetToObj(mouthsmokeid)
		if DoesEntityExist(entity) then
			loadPtfx(particleDict)
			UseParticleFxAssetNextCall(particleDict)
			if type == 'cigarette' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.CigaretteExhale, false, false, false)
			end
			if type == 'cigar' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, 0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.CigarExhale, false, false, false)
			end
			if type == 'joint' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.JointExhale, false, false, false)
			end
			if type == 'vape' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.VapeExhale, false, false, false)
			end
			if type == 'bong' then
				local particleEffect = StartParticleFxLoopedOnEntity(particleName, entity, -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Smoking.BongExhale, false, false, false)
			end
		end
	end
end)

RegisterNetEvent("smoking_sys:client:StopMouthSmoke", function(mouthsmokeid)
	if NetworkDoesNetworkIdExist(mouthsmokeid) then
		local entity = NetToObj(mouthsmokeid)
		Wait(2000)
		if DoesEntityExist(entity) then
			RemoveParticleFxFromEntity(entity)
		end
	end
end)

CreateThread(function(source)
	while true do
		Wait(100)
		if WeedEffect then
			local playerPed = PlayerPedId()
			if multiplier > maxhigh then
				multiplier = 0.9309426647617
				RequestAnimSet("move_m@business@a")
				SetPedMovementClipset(PlayerPedId(), "move_m@business@a", true)
				SetFacialIdleAnimOverride(playerPed, 'mood_sulk_1')
				if multiplier < 0.4309426647617 then
					ResetPedMovementClipset(PlayerPedId())
					TriggerEvent("emotes:setLastKnownWalkingStyle")
				end
			else
				SetTimecycleModifier("spectator9")
				SetPedIsDrunk(PlayerPedId(), true)
				SetPedMotionBlur(PlayerPedId(), true)
				SetTimecycleModifierStrength(multiplier)
			end
		end
	end
end)

CreateThread(function(source)
	while true do
		Wait(15000)
		local player = PlayerId()
		if ReductionEffect then
			if multiplier > minhigh then
				SetTimecycleModifier("spectator9")
				SetTimecycleModifierStrength(multiplier)
				multiplier = multiplier - minusphase4
				if multiplier < minhigh	then
					WeedEffect = false
					ReductionEffect = false
					ClearFacialIdleAnimOverride(player)
					ResetPedMovementClipset(PlayerPedId())
					TriggerEvent("emotes:setLastKnownWalkingStyle")
					ClearTimecycleModifier()
					ResetScenarioTypesEnabled()
					SetPedIsDrunk(PlayerPedId(), false)
					SetPedMotionBlur(PlayerPedId(), false)
				end
			end
		end
	end
end)
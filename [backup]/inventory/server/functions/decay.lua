local StartDecayItems = function()
	local players = GetPlayers()
	for k, src in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(src)
		if xPlayer then
			local atleast1ChangeMade = false
			local inv = xPlayer.inventory
			if inv ~= nil and next(inv) ~= nil then
				for k,item in pairs(inv) do
					local itemInfo = ESX.Shared.Items[item.name]
					if itemInfo.type == "expiring" then
						if (item and not item.info) or (item and not item.info.quality and not item.info.time) then
							atleast1ChangeMade = true
							item.info = {
								time = os.time(),
								quality = 100
							}
						end
					else
						if item and item.info and type(item.info) == "table" and item.info ~= "" and item.info.quality and item.info.time and item.info.quality > 0 then
							local timePassed = os.time() - item.info.time
							local counter = math.floor(timePassed / 4320) -- 4320 -> EXAMPLE FOR 1 Day (-> 1 hour is / 180)
							if counter >= 1 then
								local itemInfo = ESX.Shared.Items[item.name]
								if itemInfo.itemtype == "expiring" then
									atleast1ChangeMade = true
									local new_quality = ESX.Math.Round(item.info.quality - (5 * counter))
									if new_quality <= 0 then
										item.info.quality = 0
										item.info.time = nil
									else
										item.info.quality = new_quality
										item.info.time = os.time()
									end
								end
							end
						end
					end
				end
			end
			if atleast1ChangeMade then
				xPlayer.updateInventory(inv)
			end
		end
	end
	print('Decaying items Completed')
end

CreateThread(function()
	StartDecayItems()
	while true do
		Wait(300000)
		StartDecayItems()
	end
end)

local StartDecayFunc = function(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		local atleast1ChangeMade = false
		local inv = xPlayer.inventory
		if inv ~= nil and next(inv) ~= nil then
			for k,item in pairs(inv) do
				if item and item.info and type(item.info) == "table" and item.info ~= "" and item.info.quality and item.info.time and item.info.quality > 0 then
					local timePassed = os.time() - item.info.time
					local counter = math.floor(timePassed / 4320) -- 4320 -> EXAMPLE FOR 1 Day (-> 1 hour is / 180)
					if counter >= 1 then
						local itemInfo = ESX.Shared.Items[item.name]
						if itemInfo.itemtype == "expiring" then
							atleast1ChangeMade = true
							local new_quality = ESX.Math.Round(item.info.quality - (5 * counter))
							if new_quality <= 0 then
								item.info.quality = 0
								item.info.time = nil
							else
								item.info.quality = new_quality
								item.info.time = os.time()
							end
						end
					end
				end
			end
		end
		if atleast1ChangeMade then
			xPlayer.updateInventory(inv)
		end
	end
end

AddEventHandler('inventory:startDecayFunction', function(src)
    StartDecayFunc(src)
end)
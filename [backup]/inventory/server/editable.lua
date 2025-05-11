Lang = function(str)
	return Locales["en"][str] or ""
end

-- This is just a check if items are real just to avoid cheaters

GetJobCraftingItems = function(jobName, craftingTable) 
    local items = {}
    return items
end

-- This is an example function for extra crafting usage. My example is the warehouses. Put your extra code here. Also see Config.Warehouses as an example.

TryCraftItems = function(src, itemData, fromAmount, toSlot, otherLabel)
    local itemData = nil
    -- for k,v in pairs(Config.Warehouses) do
    --     if v.label == otherLabel then
    --         itemData = Config.Warehouses[k].items[fromSlot]
    --         break
    --     end
    -- end
    if itemData and itemData.costs and hasCraftItems(src, itemData.costs, fromAmount) then
        TriggerClientEvent("inventory:client:CraftItems", src, itemData.name, itemData.costs, fromAmount, toSlot, otherLabel)
        return true
    end

    return false
end

-- Just the log system for everything
--[[
Example of data sending:
logData = {
    color = 32768, 
    title = 'Drop Logs',
    message = "**".. GetPlayerName(src) .. "** ("..src..') - '..Player.identifier.." stacked items from Drop \n Name: **"..fromItemData.name.."**\n Amount: **" .. fromAmount .."**\n Slot: **"..toSlot.."\n Drop ID: **"..toInventory..'**'
}
]]
SendLog = function(logId, logData)
    TriggerEvent("esx:sendLog", logId, logData) -- Example event
end

-- Getting User licenses

GetUserLicenses = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local licenses = xPlayer.getUserLicenses()
    return licenses
end

IsVendingItemWhitelisted = function(item, src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.job
	local jobShop = ESX.Jobs[job.name].getItems()
	for k,v in pairs(jobShop) do
		if v.name == item then
			return true
		end
	end
    local jobData = ESX.Jobs[job.name].getRecipes()
    for k,v in pairs(jobData) do
        if k == item then
            return true
        end
    end
    return false
end

getItemInformations = function(name)
	return Config.ItemInformations[name] or nil
end

exports("getItemInformations", getItemInformations)

FirstUpper = function(str)
	return (str:gsub("^%l", string.upper))
end

ExtractStringData = function(data)
	local temp_data = {}
	if data then
		for k,v in pairs(data) do
			if v.slot then
				temp_data[tostring(v.slot)] = {
					name = v.name,
					amount = v.amount,
					info = v.info,
					slot = v.slot
				}
			end
		end
	end
	return temp_data
end

ExtractData = function(data)
	local temp_data = {}
	if data then
		for k,v in pairs(data) do
			if v.slot then
				temp_data[v.slot] = {
					name = v.name,
					amount = v.amount,
					info = v.info,
					slot = v.slot
				}
			end
		end
	end
	return temp_data
end
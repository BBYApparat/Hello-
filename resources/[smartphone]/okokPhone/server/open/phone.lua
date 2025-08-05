--[[
In this function we can prevent players from using the phone if certain conditions are met.
To do so, return false if the condition is met.
]]
---@return boolean
function canUsePhone(source)
	if Player(source).state.cuffed then return false end
	if Player(source).state["okokPoliceJob:isHandcuffed"] == true then return false end

	-- Check if standalone
	if not Utils.framework then
		return true
	end

	return true
end

function genPhoneNumber()
	local prefix = Config.PhoneNumber.prefix
	local phoneNumber = prefix
	for i = 1, (Config.PhoneNumber.length - #prefix) do
		phoneNumber = phoneNumber .. math.random(0, 9)
	end
	return phoneNumber
end

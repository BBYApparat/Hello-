local Handsups = {}

RegisterServerEvent('esx_thief:update', function(bool)
	local src = source
	Handsups[tostring(src)] = bool
end)

ESX.RegisterServerCallback('esx_thief:getValue', function(source, cb, targetSID)
	local xTarget = ESX.GetPlayerFromId(targetSID)
	if xTarget.isDead() then
		cb(true)
	else
		if Handsups[tostring(targetSID)] then
			cb(true)
		else
			cb(false)
		end
	end
end)
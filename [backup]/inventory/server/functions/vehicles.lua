IsVehicleOwned = function(plate)
	plate = ESX.Shared.Trim(plate)
    return CachedPlates[plate]
end

exports('IsVehicleOwned', IsVehicleOwned)

local AddVehicleToList = function(plate, isFakeplate)
	plate = ESX.Shared.Trim(plate)
    if not CachedPlates[plate] then
		if isFakeplate then
			isFakeplate = ESX.Shared.Trim(isFakeplate)
	        CachedPlates[plate] = isFakeplate
		else
			CachedPlates[plate] = plate
		end
    end
end

exports("AddVehicleToList", AddVehicleToList)

local GetPlateFromFakeplate = function(plate)
	if not CachedPlates[plate] then
		return plate
	else
		return CachedPlates[plate]
	end
end

exports('GetPlateFromFakeplate', GetPlateFromFakeplate)

local GetFakeplateFromPlate = function(fakeplate)
	fakeplate = ESX.Shared.Trim(fakeplate)
	for k,v in pairs(CachedPlates) do
		if ESX.Shared.Trim(tostring(v)) == tostring(fakeplate) then
			return k
		end
	end
	return nil
end

exports('GetFakeplateFromPlate', GetFakeplateFromPlate)

local RemoveVehicleFromList = function(plate, isFakeplate)
	plate = plate
    if CachedPlates[plate] or CachedPlates[plate] == isFakeplate then
        CachedPlates[plate] = nil
    end
end

AddEventHandler('inventory:swapPlateData', function(plate, newPlate)
	if CachedPlates[plate] then
		CachedPlates[plate] = nil
	end
	CachedPlates[newPlate] = plate
end)

exports("RemoveVehicleFromList", RemoveVehicleFromList)
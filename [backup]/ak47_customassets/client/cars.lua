local ped, pos = PlayerPedId(), vector3(0,0,0)

CreateThread(function()
	while true do
		Wait(500)
		ped = PlayerPedId()
		pos = GetEntityCoords(ped)
	end
end)

CreateThread(function()
    while true do
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
		SetGarbageTrucks(0)
		SetRandomBoats(0)
		Wait(3)
	end
end)
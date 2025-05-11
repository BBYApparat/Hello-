RegisterNetEvent('ak47_carboosting:notify', function(msg, type)
	Notify(msg, type)
end)

function DrawTxt(x, y, z, text)
    local boolean, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.32, 0.32); SetTextFont(4); SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING"); SetTextCentre(1); AddTextComponentString(text)
    DrawText(_x, _y)
end
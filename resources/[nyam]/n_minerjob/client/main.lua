local Rocks, spawnedRocks, currentZone = {}, 0, nil

local function onEnter(self)
    currentZone = self.currentZone
    SpawnRocks()
end

local function onExit()
    currentZone = nil
    DeleteRocks()
end

CreateThread(function()
    for zone, data in pairs(Config.Mining.zones) do
        lib.zones.sphere({
            coords = data.center,
            radius = data.radius,
            debug = false,
            onEnter = onEnter,
            onExit = onExit,
            currentZone = zone
        })
        Core.CreateBlip(data.blip)
    end
end)

function HitRock(rockObjId)
    Core.MakeEntityFaceEntity(playerPed, nearbyObject)
    local randomTimer = math.random(1500, 2000)
    TriggerEvent("togglesingle", "pickaxe", false)
    if lib.progressCircle({
        label = Lang("progbar.mining_rock", {current = Rocks[rockObjId].hits, max = Config.Options.maxHits}),
        duration = randomTimer,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'melee@large_wpn@streamed_core',
            clip = 'ground_attack_on_spot',
            flag = 49
        },
        prop = {
            model = `prop_tool_pickaxe`,
            bone = 28422,
            pos = vec3(0.0, 0.0, 0.0),
            rot = vec3(-90.0, 0.0, 0.0)
        },
    }) then 
        TriggerEvent("togglesingle", "pickaxe", true)
        Rocks[rockObjId].hits = Rocks[rockObjId].hits + 1

        ManageTarget(rockObjId)

        if Rocks[rockObjId].hits >= Config.Options.maxHits then
            SetEntityAsMissionEntity(rockObjId, false, true)
            DeleteObject(rockObjId)
            TriggerServerEvent("n_minerjob:rockDestroyed", Rocks[rockObjId], currentZone)
            Rocks[rockObjId] = nil
            spawnedRocks = spawnedRocks - 1
            if spawnedRocks <= Config.Mining.zones[currentZone].minRocks then
                DeleteRocks()
                SpawnRocks(currentZone)
            end
        end
     else
        Core.Notify("Canceled", "error")
    end
end

function SpawnRocks()
    if Config.Mining.zones[currentZone].coords then -- manual
        Config.Mining.zones[currentZone].coords = exports.n_snippets:Shuffly(Config.Mining.zones[currentZone].coords)
        if Config.Mining.zones[currentZone].maxRocks > #Config.Mining.zones[currentZone].coords then
            Config.Mining.zones[currentZone].maxRocks = #Config.Mining.zones[currentZone].coords
        end
        for i = 1, Config.Mining.zones[currentZone].maxRocks do
            if ValidateRocksCoord(Config.Mining.zones[currentZone].coords[i]) then
                local obj = CreateObject(Config.Mining.zones[currentZone].object, Config.Mining.zones[currentZone].coords[i], false, false, true)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                PlaceObjectOnGroundProperly(obj)
                
                spawnedRocks = spawnedRocks + 1
                Rocks[obj] = {hits = 0, coords = vec3(Config.Mining.zones[currentZone].coords[i].x, Config.Mining.zones[currentZone].coords[i].y, Config.Mining.zones[currentZone].coords[i].z)}
                
                ManageTarget(obj)
            end
        end
    else -- dynamic zone
        for i = 1, Config.Mining.zones[currentZone].maxRocks do
            local rockCoords = GenerateRocksCoords()
            if Core.IsSpawnPointClear(rockCoords, 5.0) then
                local obj = CreateObject(Config.Mining.zones[currentZone].object, rockCoords, false, false, true)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                PlaceObjectOnGroundProperly(obj)
                
                spawnedRocks = spawnedRocks + 1
                Rocks[obj] = {hits = 0, coords = vec3(rockCoords.x, rockCoords.y, rockCoords.z)}
                
                ManageTarget(obj)
            end
        end
    end
end

function ManageTarget(rockObjId)
    Core.Target.removeLocalEntity({entity = rockObjId})
    Core.Target.addLocalEntity({
        entity = rockObjId,
        options = {
            {
                label = Lang("targets.must_have_item", {item = "Pickaxe"}),
                icon = "fas fa-exclamation-triangle",
                distance = 2.5,
                canInteract = function()
                    return exports.ox_inventory:GetItemCount("pickaxe") <= 0 or not exports.ox_inventory:GetItemCount("pickaxe")
                end,
            },
            {
                label = Lang("targets.hit_rock", {current = Rocks[rockObjId].hits, max = Config.Options.maxHits}),
                icon = "fa-solid fa-hammer",
                distance = 2.5,
                items = "pickaxe",
                canInteract = function()
                    return exports.ox_inventory:GetItemCount("pickaxe") > 0
                end,
                onSelect = function()
                    HitRock(rockObjId)
                end,
            },
        }
    })
end

function DeleteRocks()
    for rockObjId, v in pairs(Rocks) do
        SetEntityAsMissionEntity(rockObjId, false, true)
        DeleteObject(rockObjId)
    end
    Rocks, spawnedRocks = {}, 0
end

function ValidateRocksCoord(newRockCoords)
	if spawnedRocks > 0 then
		for rockObjId, rockData in pairs(Rocks) do
			if #(newRockCoords - rockData.coords) < 5.0 then
				return false
			end
		end

		if #(newRockCoords - Config.Mining.zones[currentZone].center) > Config.Mining.zones[currentZone].maxSpawnRadius then
			return false
		end

		return true
	else
		return true
	end
end

function GenerateRocksCoords()
	while true do
		local rockCoordX, rockCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(Config.Mining.zones[currentZone].maxSpawnRadius - (Config.Mining.zones[currentZone].maxSpawnRadius*2), Config.Mining.zones[currentZone].maxSpawnRadius)

		Wait(0)

		math.randomseed(GetGameTimer())
		local modY = math.random(Config.Mining.zones[currentZone].maxSpawnRadius - (Config.Mining.zones[currentZone].maxSpawnRadius*2), Config.Mining.zones[currentZone].maxSpawnRadius)

		rockCoordX = Config.Mining.zones[currentZone].center.x + modX
		rockCoordY = Config.Mining.zones[currentZone].center.y + modY

		local coordZ = GetCoordZ(rockCoordX, rockCoordY)
		local coord = vector3(rockCoordX, rockCoordY, coordZ)

		if ValidateRocksCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 70.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for rockObjId, v in pairs(Rocks) do
            SetEntityAsMissionEntity(rockObjId, false, true)
            DeleteObject(rockObjId)
		end
	end
end)
local function onEnter(self)
    if Config.Objects[self.zoneId] then
        local object = Config.Objects[self.zoneId]
            
        local ent = GetClosestObjectOfType(object.coords.x, object.coords.y, object.coords.z, 2.0, object.model, false, false, false)
        SetEntityAsMissionEntity(ent, true, true)
        DeleteObject(ent)
        SetEntityAsNoLongerNeeded(ent)
    end
end

function ManageEntities()
    for _zoneId, object in pairs(Config.Objects) do
        local sphere = lib.zones.sphere({
            coords = object.coords,
            radius = object.radius,
            onEnter = onEnter,
            zoneId = _zoneId
        })
    end
end
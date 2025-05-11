local CraftingTables = {}

local function onEnterCraft(self)
    if self.hasObject then
        SpawnCraftingTable(self.craftingTableId)
    end
end
 
local function onExitCraft(self)
    if self.hasObject then
        DespawnCraftingTable(self.craftingTableId)
    end
end

function DespawnCraftingTables()
    for tableId in pairs(CraftingTables) do
        DeleteEntity(CraftingTables[tableId])
        CraftingTables[tableId] = nil
    end
end

function DespawnCraftingTable(craftingTableId)
    DeleteEntity(CraftingTables[craftingTableId])
    CraftingTables[craftingTableId] = nil
end

function SpawnCraftingTable(craftingTableId)
    local myTable = Config.Crafting[craftingTableId]
    
    if CraftingTables[craftingTableId] and DoesEntityExist(CraftingTables[craftingTableId]) then return end
    
    if myTable.object then
        Core.SpawnEntity({
            object = myTable.object,
            coords = myTable.coords,
            networked = false
        }, function(entity)
            CraftingTables[craftingTableId] = entity
            
            SetEntityHeading(entity, myTable.coords.w)
            PlaceObjectOnGroundProperly(entity)
            FreezeEntityPosition(entity, true)
            Core.Target.addLocalEntity({
                entity = entity,
                options = {
                    {
                        label = myTable.label,
                        icon = myTable.icon,
                        distance = 2.5,
                        canInteract = function()
                            return (myTable.jobGrades == "locked" and myTable.jobs[PlayerData.job.name] and myTable.jobs[PlayerData.job.name][PlayerData.job.grade])
                            or (myTable.jobGrades == "open" and myTable.jobs[PlayerData.job.name]) or not myTable.jobs
                        end,
                        onSelect = function()
                            exports.ox_inventory:openInventory('crafting', { id = craftingTableId, index = 1 })
                        end,
                    }
                }
            })
        end)
    else
        -- Need to impliment target for position than entity.
    end
end

CreateThread(function()
    Config.Crafting = lib.callback.await('n_snippets:getCrafting')

    for craftingTableId, table in pairs(Config.Crafting) do 
        lib.zones.sphere({
            coords = vec3(table.coords.x, table.coords.y, table.coords.z),
            radius = 25,
            debug = false,
            onEnter = onEnterCraft,
            onExit = onExitCraft,
            craftingTableId = craftingTableId,
            hasObject = table.object
        })
        
        if not table.object then
            Core.Target.AddPosition({
                coords = vec3(table.coords.x, table.coords.y, table.coords.z),
                heading = table.coords.w,
                debug = false,
                minZ = table.coords.z-1.0,
                maxZ = table.coords.z+1.0,
                distance = table.distance,
                size = table.distance,
                options = {
                    {
                        label = table.label,
                        icon = table.icon,
                        distance = table.distance,
                        offset = vec3(1.25, 1.25, 1.25),
                        offsetSize = table.distance,
                        canInteract = function()
                            return (table.jobGrades == "locked" and table.jobs[PlayerData.job.name] and table.jobs[PlayerData.job.name][PlayerData.job.grade])
                            or (table.jobGrades == "open" and table.jobs[PlayerData.job.name]) or (table.jobs == nil or not table.jobs)
                        end,
                        onSelect = function()
                            exports.ox_inventory:openInventory('crafting', { id = craftingTableId, index = 1 })
                        end,
                    }
                }
            })
        end

        if table.blip then Core.CreateBlip(table.blip) end

        exports.ox_inventory:createCraftingBench(craftingTableId, {items = table.items})
    end
end)
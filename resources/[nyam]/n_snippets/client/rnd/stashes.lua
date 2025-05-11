CreateThread(function()
    Config.Stashes = lib.callback.await('n_snippets:getStashes')
    
    for category, stashes in pairs(Config.Stashes) do
        for index, stash in pairs(stashes) do
            if not stash.doNotRegister then 
                Core.Target.AddPosition({
                    id = stash.id,
                    coords = vec3(stash.coords.x, stash.coords.y, stash.coords.z),
                    heading = stash.coords.w,
                    debug = false,
                    minZ = stash.coords.z-1.0,
                    maxZ = stash.coords.z+1.0,
                    distance = 1.5,
                    size = 1.5,
                    options = {
                        {
                            label = Lang("stash.open_"..stash.type, {stash = stash.label}),
                            icon = "fa-solid fa-box",
                            distance = 1.5,
                            offset = vec3(1.25, 1.25, 1.25),
                            offsetSize = 1.50,
                            canInteract = function()
                                return (stash.jobGrades == "locked" and stash.jobs[PlayerData.job.name] and stash.jobs[PlayerData.job.name][PlayerData.job.grade])
                                or (stash.jobGrades == "open" and stash.jobs[PlayerData.job.name])
                            end,
                            onSelect = function()
                                exports.ox_inventory:openInventory('stash', stash.id)
                            end,
                        }
                    }
                })
            end
        end
    end
end)
CreateThread(function()
    for category, stashes in pairs(Config.Stashes) do
        for index, stash in pairs(stashes) do
            local jobs = stash.jobs
            
            Config.Stashes[category][index].jobs = {}

            if stash.jobGrades and type(stash.jobGrades) == "table" then
                for jobIndex, job in pairs(jobs) do
                    for gradeIndex, grade in pairs(stash.jobGrades) do
                        if not Config.Stashes[category][index].jobs[job] then Config.Stashes[category][index].jobs[job] = {} end
                        
                        Config.Stashes[category][index].jobs[job][grade] = true

                    end 
                end
                Config.Stashes[category][index].jobGrades = "locked"
            elseif stash.jobGrades and stash.jobGrades == "all" then
                for jobIndex, job in pairs(jobs) do
                    Config.Stashes[category][index].jobs[job] = true
                end
                Config.Stashes[category][index].jobGrades = "open"
            else
                Config.Stashes[category][index].doNotRegister = true
            end
        end
    end

    SetupStashes()
end)

function SetupStashes()
    for category, stashes in pairs(Config.Stashes) do
        local personal = false

        if category == "personal" then personal = true end
        
        for index, stash in pairs(stashes) do
            if not stash.doNotRegister then
                exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.inventory.slots, stash.inventory.weight*1000, personal)
            end
        end
    end
end

lib.callback.register('n_snippets:getStashes', function(source)
    return Config.Stashes
end)
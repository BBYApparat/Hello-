RegisterNetEvent("n_snippets:animations:startSmoking", function()
    local dict = "amb@world_human_smoking@female@enter"
    local anim = "enter"
    Core.RequestAnim(dict)
    TaskPlayAnim(cache.ped, dict, anim, 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    Wait(8500)
    if PlayerData.sex == "m" then
        local anims = {'smoke2', 'smoke3', 'smoke6'}
        local selectedAnim = anims[math.random(1, #anims)]

        exports.rpemotes:EmoteCommandStart(selectedAnim)
    else
        local anims = {'smoke2', 'smoke4'}
        local selectedAnim = anims[math.random(1, #anims)]

        exports.rpemotes:EmoteCommandStart(selectedAnim)
    end
end)
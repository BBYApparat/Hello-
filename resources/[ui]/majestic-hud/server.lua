-- Initialize Server Framework
local Framework = require('frameworks.server.' .. Config.framework)

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local Player = Framework.getPlayer(src)
    if not Player then return end
    
    local Job, JobType = Framework.getPlayerJob(Player)
    if Framework.isJobWhitelisted(Job, JobType, Config.stressWLJobs) then return end
    
    Framework.addPlayerStress(src, amount)
    Framework.notify(src, 'Stress Gain', 'error', 1500)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    if Config.DisableStress then return end
    local src = source
    local Player = Framework.getPlayer(src)
    if not Player then return end
    
    Framework.removePlayerStress(src, amount)
    Framework.notify(src, 'Stress Removed', 'success', 1500)
end)
local isDead = false

exports('isDead', function()
    if Config.Framework == "qb" then
        local PlayerData = Core.Functions.GetPlayerData()
        if PlayerData.metadata['ishandcuffed'] or PlayerData.metadata['inlaststand'] or PlayerData.metadata['isdead'] then
            return true
        end
    end
    return isDead
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)
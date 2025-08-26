local ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory

-- Give rewards to player
RegisterServerEvent('junkyard_scraper:giveRewards')
AddEventHandler('junkyard_scraper:giveRewards', function(items, stage)
    local source = source
    local player = ESX.GetPlayerFromId(source)
    
    if not player then
        if Config.Debug then
            print(string.format('[Junkyard Scraper] Player %d not found', source))
        end
        return
    end
    
    if Config.Debug then
        print(string.format('[Junkyard Scraper] Giving rewards to %s for stage %d', player.getName(), stage))
    end
    
    -- Give items to player
    for _, item in pairs(items) do
        if ox_inventory:CanCarryItem(source, item.name, item.count) then
            ox_inventory:AddItem(source, item.name, item.count)
            
            if Config.Debug then
                print(string.format('[Junkyard Scraper] Gave %dx %s to %s', item.count, item.name, player.getName()))
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Junkyard Scraper',
                description = string.format('Cannot carry %dx %s - inventory full!', item.count, item.name),
                type = 'error'
            })
            
            if Config.Debug then
                print(string.format('[Junkyard Scraper] Could not give %dx %s to %s - inventory full', item.count, item.name, player.getName()))
            end
        end
    end
end)

-- Get player XP
RegisterServerEvent('junkyard_scraper:getPlayerXP')
AddEventHandler('junkyard_scraper:getPlayerXP', function()
    local source = source
    local player = ESX.GetPlayerFromId(source)
    
    if not player then return end
    
    MySQL.query('SELECT junkyard_xp FROM users WHERE identifier = ?', {
        player.getIdentifier()
    }, function(result)
        local xp = 0
        if result[1] and result[1].junkyard_xp then
            xp = result[1].junkyard_xp
        end
        
        TriggerClientEvent('junkyard_scraper:receivePlayerXP', source, xp)
        
        if Config.Debug then
            print(string.format('[Junkyard Scraper] Sent %d XP to %s', xp, player.getName()))
        end
    end)
end)

-- Complete job and save XP
RegisterServerEvent('junkyard_scraper:completeJob')
AddEventHandler('junkyard_scraper:completeJob', function(xpEarned)
    local source = source
    local player = ESX.GetPlayerFromId(source)
    
    if not player then return end
    
    MySQL.query('SELECT junkyard_xp FROM users WHERE identifier = ?', {
        player.getIdentifier()
    }, function(result)
        local currentXP = 0
        if result[1] and result[1].junkyard_xp then
            currentXP = result[1].junkyard_xp
        end
        
        local newXP = currentXP + xpEarned
        
        MySQL.update('UPDATE users SET junkyard_xp = ? WHERE identifier = ?', {
            newXP, player.getIdentifier()
        }, function(affectedRows)
            if affectedRows > 0 then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Junkyard Scraper',
                    description = string.format('Earned %d XP! Total: %d XP', xpEarned, newXP),
                    type = 'success'
                })
                
                -- Check for level up
                if currentXP < Config.XPFor5Vehicles and newXP >= Config.XPFor5Vehicles then
                    TriggerClientEvent('ox_lib:notify', source, {
                        title = 'LEVEL UP!',
                        description = string.format('You can now scrap %d vehicles per job!', Config.MaxVehiclesWithBonus),
                        type = 'inform'
                    })
                end
                
                if Config.Debug then
                    print(string.format('[Junkyard Scraper] %s earned %d XP (Total: %d)', player.getName(), xpEarned, newXP))
                end
            end
        end)
    end)
end)

-- Server initialization
CreateThread(function()
    -- Check if junkyard_xp column exists, create if not
    MySQL.query('SHOW COLUMNS FROM users LIKE "junkyard_xp"', {}, function(result)
        if #result == 0 then
            MySQL.query('ALTER TABLE users ADD COLUMN junkyard_xp INT DEFAULT 0', {}, function()
                if Config.Debug then
                    print('[Junkyard Scraper] Added junkyard_xp column to users table')
                end
            end)
        end
    end)
    
    if Config.Debug then
        print('[Junkyard Scraper] Server initialized')
    end
end)
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

-- Server initialization
CreateThread(function()
    if Config.Debug then
        print('[Junkyard Scraper] Server initialized')
    end
end)
local ESX = exports['es_extended']:getSharedObject()

-- Make envelope a usable item
ESX.RegisterUsableItem('envelope', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Remove the envelope
    if exports.ox_inventory:RemoveItem(source, 'envelope', 1) then
        -- Random rewards from opening envelope
        local rewardType = math.random(1, 100)
        
        if rewardType <= 70 then
            -- 70% chance for money
            local amount = math.random(100, 500)
            xPlayer.addMoney(amount)
            
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Envelope Opened',
                description = ('You found $%d inside!'):format(amount),
                type = 'success'
            })
        elseif rewardType <= 85 then
            -- 15% chance for valuable item
            local items = {'watch', 'goldchain', 'phone'}
            local item = items[math.random(#items)]
            
            if exports.ox_inventory:CanCarryItem(source, item, 1) then
                exports.ox_inventory:AddItem(source, item, 1)
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Envelope Opened',
                    description = ('You found a %s inside!'):format(item),
                    type = 'success'
                })
            else
                -- Give money if can't carry item
                xPlayer.addMoney(250)
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Envelope Opened',
                    description = 'You found $250 inside!',
                    type = 'success'
                })
            end
        else
            -- 15% chance for nothing
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Empty',
                description = 'The envelope was empty!',
                type = 'error'
            })
        end
    end
end)
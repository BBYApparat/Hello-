function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(Config.PaycheckInterval)
            for player, xPlayer in pairs(ESX.Players) do
                local jobLabel = xPlayer.job.label
                local job = xPlayer.job.grade_name
                local salary = xPlayer.job.grade_salary
                local playerSalary = xPlayer.job.grade_salary
                
                -- VIP bonus calculation (keeping from original)
                if GetResourceState("n_vip") == "started" then
                    if xPlayer.getMeta("vip") == 1 then
                        local increasedSalary = (exports.n_vip:getConfig().VIP.salary.amount*0.01)
                        playerSalary = playerSalary + (playerSalary*increasedSalary)
                    end
                end
                
                if salary > 0 then
                    if job == "unemployed" then -- unemployed
                        -- Use randol_paycheck system instead of direct bank deposit
                        exports.randol_paycheck:AddToPaycheck(xPlayer.identifier, playerSalary)
                        
                        -- Add notification for unemployment benefits
                        TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'), TranslateCap('received_help', playerSalary),
                            'CHAR_BANK_MAZE', 9)
                        
                        -- Keep logging if enabled
                        if Config.LogPaycheck then
                            ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                                { name = "Player", value = xPlayer.name, inline = true },
                                { name = "ID", value = xPlayer.source, inline = true },
                                { name = "Amount", value = playerSalary, inline = true },
                            })
                        end
                    elseif Config.EnableSocietyPayouts then -- possibly a society
                        TriggerEvent("esx_society:getSociety", xPlayer.job.name, function(society)
                            if society ~= nil then -- verified society
                                TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
                                    if account.money >= salary then -- does the society have money to pay its employees?
                                        -- Use randol_paycheck system instead of direct bank deposit
                                        exports.randol_paycheck:AddToPaycheck(xPlayer.identifier, playerSalary)
                                        account.removeMoney(salary)
                                        
                                        -- Add notification for society job salary
                                        TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'),
                                            TranslateCap('received_salary', playerSalary), 'CHAR_BANK_MAZE', 9)
                                        
                                        -- Keep logging if enabled
                                        if Config.LogPaycheck then
                                            ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                                { name = "Player", value = xPlayer.name, inline = true },
                                                { name = "ID", value = xPlayer.source, inline = true },
                                                { name = "Amount", value = playerSalary, inline = true },
                                            })
                                        end
                                    else
                                        -- Notify player that company has no money
                                        TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), '', TranslateCap('company_nomoney'), 'CHAR_BANK_MAZE', 1)
                                    end
                                end)
                            else -- not a society
                                -- Use randol_paycheck system instead of direct bank deposit
                                exports.randol_paycheck:AddToPaycheck(xPlayer.identifier, playerSalary)
                                
                                -- Add notification for regular job salary
                                TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'), TranslateCap('received_salary', playerSalary),
                                    'CHAR_BANK_MAZE', 9)
                                
                                -- Keep logging if enabled
                                if Config.LogPaycheck then
                                    ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                        { name = "Player", value = xPlayer.name, inline = true },
                                        { name = "ID", value = xPlayer.source, inline = true },
                                        { name = "Amount", value = playerSalary, inline = true },
                                    })
                                end
                            end
                        end)
                    else -- generic job
                        -- Use randol_paycheck system instead of direct bank deposit
                        exports.randol_paycheck:AddToPaycheck(xPlayer.identifier, playerSalary)
                        
                        -- Add notification for generic job salary
                        TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'), TranslateCap('received_salary', playerSalary),
                            'CHAR_BANK_MAZE', 9)
                        
                        -- Keep logging if enabled
                        if Config.LogPaycheck then
                            ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                                { name = "Player", value = xPlayer.name, inline = true },
                                { name = "ID", value = xPlayer.source, inline = true },
                                { name = "Amount", value = playerSalary, inline = true },
                            })
                        end
                    end
                end
            end
        end
    end)
end
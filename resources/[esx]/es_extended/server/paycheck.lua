function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(Config.PaycheckInterval)
            for player, xPlayer in pairs(ESX.Players) do
                local jobLabel = xPlayer.job.label
                local job = xPlayer.job.grade_name
                local salary = xPlayer.job.grade_salary
                local playerSalary = xPlayer.job.grade_salary
                
                if GetResourceState("n_vip") == "started" then
                    if xPlayer.getMeta("vip") == 1 then
                        local increasedSalary = (exports.n_vip:getConfig().VIP.salary.amount*0.01)
                        playerSalary = playerSalary + (playerSalary*increasedSalary)
                    end
                end
                
                if salary > 0 then
                    if job == "unemployed" then -- unemployed
                        xPlayer.addAccountMoney("bank", playerSalary, "Welfare Check")
                        if Config.LogPaycheck then
                            ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                                { name = "Player", value = xPlayer.name, inline = true },
                                { name = "ID", value = xPlayer.source, inline = true },
                                { name = "Amount", value = salary, inline = true },
                            })
                        end
                    elseif Config.EnableSocietyPayouts then -- possibly a society
                        TriggerEvent("esx_society:getSociety", xPlayer.job.name, function(society)
                            if society ~= nil then -- verified society
                                TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
                                    if account.money >= salary then -- does the society money to pay its employees?
                                        xPlayer.addAccountMoney("bank", playerSalary, "Paycheck")
                                        account.removeMoney(salary)
                                        if Config.LogPaycheck then
                                            ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                                { name = "Player", value = xPlayer.name, inline = true },
                                                { name = "ID", value = xPlayer.source, inline = true },
                                                { name = "Amount", value = salary, inline = true },
                                            })
                                        end

                                    else
                                        print(company_nomoney)
                                    end
                                end)
                            else -- not a society
                                xPlayer.addAccountMoney("bank", playerSalary, "Paycheck")
                                if Config.LogPaycheck then
                                    ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                        { name = "Player", value = xPlayer.name, inline = true },
                                        { name = "ID", value = xPlayer.source, inline = true },
                                        { name = "Amount", value = salary, inline = true },
                                    })
                                end
                            end
                        end)
                    else -- generic job
                        xPlayer.addAccountMoney("bank", playerSalary, "Paycheck")
                        if Config.LogPaycheck then
                            ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                                { name = "Player", value = xPlayer.name, inline = true },
                                { name = "ID", value = xPlayer.source, inline = true },
                                { name = "Amount", value = salary, inline = true },
                            })
                        end
                    end
                end
            end
        end
    end)
end

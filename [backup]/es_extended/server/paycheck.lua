-- paycheck.lua

-- Function to start the paycheck distribution process
function StartPayCheck()
  -- Create a thread to run the paycheck distribution continuously
  CreateThread(function()
    while true do
      -- Wait for the configured interval before processing paychecks
      Wait(Config.PaycheckInterval)

      -- Get the list of extended players from the ESX framework
      local xPlayers = ESX.GetExtendedPlayers()

      -- Iterate through each extended player
      for i = 1, #(xPlayers) do
        local xPlayer = xPlayers[i]
        local job = xPlayer.job.grade_name
        local salary = xPlayer.job.grade_salary

        -- Check if the player has a valid job with a positive salary
        if salary > 0 then
          -- Check the player's job to determine the type of payment
          if job == 'unemployed' then -- unemployed
            -- Add the salary to the player's bank account
            xPlayer.addAccountMoney('bank', salary)

            -- Notify the player about the state aid received
            TriggerClientEvent('qs-smartphone:client:notify', xPlayer.source, {
              title = 'State Aid',
              text = '$' .. salary,
              icon = "./img/apps/bank.png",
              timeout = 3500
            })
          elseif Config.EnableSocietyPayouts then -- possibly a society
            -- Attempt to get the society associated with the player's job
            TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
              if society ~= nil then -- verified society
                -- Attempt to get the shared account of the society
                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
                  -- Check if the society has enough money to pay its employees
                  if account.money >= salary then
                    -- Add the salary to the player's bank account and deduct it from the society's account
                    xPlayer.addAccountMoney('bank', salary)
                    account.removeMoney(salary)

                    -- Notify the player about the deposited salary
                    TriggerClientEvent('qs-smartphone:client:notify', xPlayer.source, {
                      title = 'Pay deposited in the bank',
                      text = '$' .. salary,
                      icon = "./img/apps/bank.png",
                      timeout = 3500
                    })
                  else
                    -- Notify the player if the society doesn't have enough money to pay its employees
                    TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Bank', 'The company does not have enough money.', 5000, 'error')
                  end
                end)
              else
                -- If the job is not associated with a society, add the salary to the player's bank account
                xPlayer.addAccountMoney('bank', salary)

                -- Notify the player about the deposited salary
                TriggerClientEvent('qs-smartphone:client:notify', xPlayer.source, {
                  title = 'Pay deposited in the bank',
                  text = '$' .. salary,
                  icon = "./img/apps/bank.png",
                  timeout = 3500
                })
              end
            end)
          else
            -- If society payouts are not enabled, add the salary to the player's bank account
            xPlayer.addAccountMoney('bank', salary)

            -- Notify the player about the deposited salary
            TriggerClientEvent('qs-smartphone:client:notify', xPlayer.source, {
              title = 'Pay deposited in the bank',
              text = '$' .. salary,
              icon = "./img/apps/bank.png",
              timeout = 3500
            })
          end
        end
      end
    end
  end)
end
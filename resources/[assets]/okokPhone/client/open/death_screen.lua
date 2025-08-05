RegisterNuiCallback('notifyEmergencyServices', function(_, cb)
      pcall(function()
            if isResourceRunning('ps-dispatch') then     -- Project Sloth
                  exports['ps-dispatch']:InjuriedPerson()
            elseif isResourceRunning('qs-dispatch') then -- Quasar
                  exports['qs-dispatch']:InjuriedPerson()
            end
      end)


      -- Send phone notification
      triggerServerEvent('notifyEmergencyServices')
      cb(true)
end)

-- SaltyChat

---@type table<number,string>
local callChannels = {}

---@param id number
RegisterNetEvent('okokPhone:Server:SetCallChannel', function(id)
      local src = tonumber(source) --[[ @as number ]]
      local callId = tostring(id) --[[ @as string ]]
      if id == 0 then
            exports['saltychat']:RemovePlayerFromCall(callChannels[src], src)
            callChannels[src] = nil
            return
      end
      callChannels[src] = callId
      exports['saltychat']:AddPlayerToCall(callId, src)
end)

RegisterNetEvent("okokPhone:Server:RemovePlayerFromRadio", function(radioChannel)
      exports["saltychat"]:RemovePlayerRadioChannel(tonumber(source), radioChannel)
end)

--[[ Death Events 💀 ]]

AddEventHandler('esx:onPlayerSpawn', function()
      TriggerEvent('okokPhone:Client:playerRevived')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData) end)

AddEventHandler('pma-voice:radioActive', function(state)
      TriggerEvent('okokPhone:Client:radioActive', state)
end)

---@param target number The radio partner
RegisterNetEvent('pma-voice:setTalkingOnRadio', function(target, state)
      TriggerEvent('okokPhone:Client:radioIncoming', state)
end)

AddEventHandler("SaltyChat_RadioTrafficStateChanged",
      function(primaryReceive, primaryTransmit, secondaryReceive, secondaryTransmit)
            local isTalking = primaryTransmit or secondaryTransmit
            local incoming = primaryReceive or secondaryReceive
            TriggerEvent("okokPhone:Client:radioActive", isTalking)
            TriggerEvent("okokPhone:Client:radioIncoming", incoming)
      end)


--- ESX
AddEventHandler('esx:setPlayerData', function(key, val, last)
      -- Framework.PlayerData[key] = val
end)

---
RegisterNetEvent('QBCore:Client:OnSharedUpdate', function(tableName, key, value)
      Framework.Shared[tableName][key] = value
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
      getFramework() -- Refreshes the framework object,
end)

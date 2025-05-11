AddEventHandler('playerSpawned', function()
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(PlayerPedId(), true, true)
end)

AddEventHandler('playerSpawned', function()
  local ped = PlayerPedId()
  SetEntityInvincible(ped, false)
end)

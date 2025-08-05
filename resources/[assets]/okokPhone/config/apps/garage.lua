--[[ Garage App ]]
return {
  BringVehicle = {
    enabled = true,
    disableValet = false,       -- Skips the npc bringing the vehicle and spawn the player inside the vehicle
    price = 10000,
    drivingStyleFlag = 4456508, -- Still unsure whats the best flag for this but 786603 seems to work
    spawnDistance = 20,         -- Distance from the player to spawn the vehicle
  },
  CustomVehicleImageFailSafe = {
    url = 'https://cfx-nui-okokgarage/web/img/vehicles/', -- Change this if you have custom vehicles images stored somewhere else
    fileExtension = 'png',                                -- png, jpg, jpeg, webp
  },
}

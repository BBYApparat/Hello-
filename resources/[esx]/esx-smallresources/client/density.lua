local density = {
    ['parked'] = 0.2,       -- Lower value for fewer parked cars
    ['vehicle'] = 0.5,      -- Lower value for fewer moving vehicles
    ['multiplier'] = 0.4,   -- Random vehicle multiplier set lower for fewer cars overall
    ['peds'] = 0.6,         -- Lower value for fewer walking pedestrians
    ['scenario'] = 0.1,     -- Lower value for fewer scenario NPCs (e.g., interacting with the environment)
}

CreateThread(function()
	while true do
		SetParkedVehicleDensityMultiplierThisFrame(density['parked'])
		SetVehicleDensityMultiplierThisFrame(density['vehicle'])
		SetRandomVehicleDensityMultiplierThisFrame(density['multiplier'])
		SetPedDensityMultiplierThisFrame(density['peds'])
		SetScenarioPedDensityMultiplierThisFrame(density['scenario'], density['scenario']) -- Walking NPC Density
		Wait(0)
	end
end)

function DecorSet(Type, Value)
    if Type == 'parked' then
        density['parked'] = Value
    elseif Type == 'vehicle' then
        density['vehicle'] = Value
    elseif Type == 'multiplier' then
        density['multiplier'] = Value
    elseif Type == 'peds' then
        density['peds'] = Value
    elseif Type == 'scenario' then
        density['scenario'] = Value
    end
end

exports('DecorSet', DecorSet)

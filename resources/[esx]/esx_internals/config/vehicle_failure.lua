Config.deformationMultiplier = 0.4				-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
Config.deformationExponent = 0.1					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
Config.collisionDamageExponent = 0.1				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
Config.damageFactorEngine = 2.0					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
Config.damageFactorBody = 3.0				-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
Config.damageFactorPetrolTank = 8.0				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
Config.engineDamageExponent = 0.9				-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
Config.weaponsDamageMultiplier = 2.0				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
Config.degradingHealthSpeedFactor = 6			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
Config.cascadingFailureSpeedFactor = 8.0			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8
Config.degradingFailureThreshold = 600.0			-- Below this value, slow health degradation will set in
Config.cascadingFailureThreshold = 160.0			-- Below this value, health cascading failure will set in
Config.engineSafeGuard = 100.0				-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.
Config.torqueMultiplierEnabled = true				-- Decrease engine torque as engine gets more and more damaged
Config.limpMode = false				-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
Config.limpModeMultiplier = 0.19					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25
Config.preventVehicleFlip = true					-- If true, you can't turn over an upside down vehicle
Config.sundayDriver = false				-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
Config.sundayDriverAcceleratorCurve = 7.5			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
Config.sundayDriverBrakeCurve = 5.0			-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers
Config.compatibilityMode = true				-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)
Config.randomTireBurstInterval = 0				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled

-- Class Damagefactor Multiplier
-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
-- Use it to increase or decrease damage for each class
Config.classDamageMultiplier = {
    [0] 	= 	0.4,		--	0: Compacts
    [1]		=	0.4,		--	1: Sedans
    [2]		=	0.4,		--	2: SUVs
    [3]		=	0.4,		--	3: Coupes
    [4]		=	0.3,		--	4: Muscle
    [5]		=	0.4,		--	5: Sports Classics
    [6]		=	0.4,		--	6: Sports
    [7]		=	0.5,		--	7: Super
    [8]		=	0.2,		--	8: Motorcycles
    [9]		=	0.4,		--	9: Off-road
    [10]	=	0.3,		--	10: Industrial
    [11]	=	0.4,		--	11: Utility
    [12]	=	0.3,		--	12: Vans
    [13]	=	0.0,		--	13: Cycles
    [14]	=	0.5,		--	14: Boats
    [15]	=	0.6,		--	15: Helicopters
    [16]	=	0.6,		--	16: Planes
    [17]	=	0.3,		--	17: Service
    [18]	=	0.3,		--	18: Emergency
    [19]	=	0.3,		--	19: Military
    [20]	=	0.4,		--	20: Commercial
    [21]	=	0.4			--	21: Trains
}
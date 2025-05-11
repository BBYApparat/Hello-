Config.Skelly = true --Enable/Disable Skelly System
Config.SaveInterval = 60 --seconds

Config.DamageMultiplier      = 1.0
Config.FixAllDamageOnCheckIn = true
Config.FixAllDamageOnRevive  = false


Config.DamageNotify = true
Config.DamageNotifyInterval = 60 --seconds

--[[
	Items like neckbrace will remove 80% damage by default and you have to take a Paracetamol to reduce left 20%
	Paracetamol timeCycle means it will remove damage within that cycle of time
]]

Config.DrivingDifficultyOnArmInjury = true -- Hand brake, steering wheel
Config.DrivingDifficultyOnLegInjury = true -- Leg brake, acceleration

Config.MaxRecoilShakeOnArmDamage = 0.1 --to disable make it 0.0 or disable from Config.DamageEffects

Config.DamageEffects = {
	head  = true,
	chest = true,
	arms  = true,
	legs  = true,
}

Config.Bandage = {
	addHealth = 25,
	delay = 2, --seconds
	pauseDamageEffect = {
		head  = true,
		chest = true,
		arms  = true,
		legs  = true,
	},
	duration = 5 * 60, --seconds [damage effects will be paused for 5 minutes]
}

Config.Firstaid = {
	addHealth = 85,
	delay = 5, --seconds
	pauseDamageEffect = {
		head  = true,
		chest = true,
		arms  = true,
		legs  = true,
	},
	duration = 5 * 60, --seconds [damage effects will be paused for 5 minutes]
	healDamage = {
		head  = 80,
		chest = 80,
		arms  = 80,
		legs  = 80,
	}
}

Config.Medikit = {
	addHealth = 100,
	delay = 10, --seconds
	pauseDamageEffect = {
		head  = true,
		chest = true,
		arms  = true,
		legs  = true,
	},
	duration = 2 * 60, --seconds [damage effects will be paused for 2 minutes]
	healDamage = {
		head  = 100,
		chest = 100,
		arms  = 100,
		legs  = 100,
	}
}

Config.Paracetamol = {
	timeCycle = 5 * 60, --will take 5 minutes
	fixValue = 29, --will fix last 29% damage
}

Config.Morphine30 = {
	pauseDamageEffectsFor = 30 * 60, --seconds [30 minutes]
	motionBlur = true,
	colorfullScreen = true,
	screenShake = true,
	sideEffectDuration = 3 * 60, --seconds [2 minutes]
}

Config.Morphine10 = {
	pauseDamageEffectsFor = 15 * 60, --seconds [15 minutes]
	motionBlur = true,
	colorfullScreen = true,
	screenShake = true,
	sideEffectDuration = 2 * 60, --seconds [2 minutes]
}

Config.ItemUse = {
	neckbrace = {
		remove = true, 
		delay = 3, --use delay
		duration = 3 * 60, --will take 3 minutes to reduce damage
		fix = 'head', 
		fixValue = 80, 
		message = 'Applying Neckbrace...', 
	},
	bodybandage = {
		remove = true, 
		delay = 3, --use delay
		duration = 3 * 60, --will take 3 minutes to reduce damage
		fix = 'chest', 
		fixValue = 80, 
		message = 'Applying Body Bandage...', 
	},
	armbrace = {
		remove = true, 
		delay = 3, --use delay
		duration = 3 * 60, --will take 3 minutes to reduce damage
		fix = 'arms', 
		fixValue = 80, 
		message = 'Applying Armbrace...', 
	},
	legbrace = {
		remove = true, 
		delay = 3, --use delay
		duration = 3 * 60, --will take 3 minutes to reduce damage
		fix = 'legs', 
		fixValue = 80, 
		message = 'Applying Legbrace...', 
	},
}


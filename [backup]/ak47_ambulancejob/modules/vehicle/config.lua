Config.Vehicles = {
	--PillBox
	{
		zone 		= vector3(297.35, -606.62, 43.26),  		--zone position
		rotation 	= 68.43,									--zone rotation
		size 		= vector3(10.0, 6.0, 2.0),					--zone size
		spawn 		= vector4(295.05, -607.27, 43.01, 68.43), 	--vehicle spawn point with heading
		vehicles = {
			{model = 'ambulance', label = 'Ambulance', rank = 0, props = {modLivery = 0}}, --props is optional
			{model = 'fordambo',  label = 'Ford E450', rank = 0, props = {modLivery = 0}},
		}
	},
	{
		zone 		= vector3(326.18, -588.72, 28.8),
		rotation 	= 340.0,
		size 		= vector3(10.0, 6.0, 2.0),
		spawn 		= vector4(327.15, -585.89, 28.57, 340.0),
		vehicles = {
			{model = 'ambulance', label = 'Ambulance', rank = 0, props = {modLivery = 0}}, --props is optional
			{model = 'fordambo',  label = 'Ford E450', rank = 0, props = {modLivery = 0}},
		}
	},
	{
		zone 		= vector3(352.04, -588.14, 74.16),
		rotation 	= 0.0,
		size 		= vector3(10.0, 10.0, 5.0),
		spawn 		= vector4(351.82, -588.08, 74.16, 70.0),
		vehicles = {
			{model = 'polmav', label = 'EMS Helicopter', rank = 0, props = {modLivery = 1}},
		}
	},

	--[[
	--Central Hospital
	{
		zone 		= vector3(331.58, -1468.54, 29.1),  		--zone position
		rotation 	= 230.0,									--zone rotation
		size 		= vector3(4.0, 6.0, 2.0),					--zone size
		spawn 		= vector4(331.58, -1468.54, 29.1, 230.0), 	--vehicle spawn point with heading
		vehicles = {
			{model = 'ambulance', label = 'Ambulance', rank = 0, props = {modLivery = 0}}, --props is optional
			{model = 'fordambo',  label = 'Ford E450', rank = 0, props = {modLivery = 0}},
		}
	},
	{
		zone 		= vector3(313.33, -1465.35, 46.51),
		rotation 	= 320.0,
		size 		= vector3(10.0, 10.0, 5.0),
		spawn 		= vector4(313.33, -1465.35, 46.51, 320.0),
		vehicles = {
			{model = 'polmav', label = 'EMS Helicopter', rank = 0, props = {modLivery = 1}},
		}
	},
	{
		zone 		= vector3(299.4, -1453.52, 46.51),
		rotation 	= 320.0,
		size 		= vector3(10.0, 10.0, 5.0),
		spawn 		= vector4(299.4, -1453.52, 46.51, 320.0),
		vehicles = {
			{model = 'polmav', label = 'EMS Helicopter', rank = 0, props = {modLivery = 1}},
		}
	},
	]]
}
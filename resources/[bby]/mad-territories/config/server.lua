return {
	--gang names must match the names in the core, you can add more depending on the graffiti in the stream folder or if you know how to do more graffiti, you can add it too
	gangs = {
		["ballas"] = {spraymodel = "sprays_ballas"},
		["vagos"] = {spraymodel = "sprays_vagos"},
		["lostmc"] = {spraymodel = "sprays_lost"},
	},

	addReputation = 1, --how much reputation you earn after selling in your zone (max reputation is 1000 so if you sell 1000 times you will have max rep)
	removeReputation = 1, --how much reputation you remove after selling in other zone

	robNpcMoney = {min = 50, max= 70} --how much money you will get for robbing npcs

}
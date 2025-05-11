Config.YogaMats = {
    ['yogamat_blue'] = GetHashKey('prop_yoga_mat_01'),
    ['yogamat_black'] = GetHashKey('prop_yoga_mat_02'),
    ['yogamat_red'] = GetHashKey('prop_yoga_mat_03')
}

Config.CommonItems = {
    ["foodstore"] = {
        ["cocacola"] = true,
        ["water"] = true,
        ["orangeade"] = true,
        ["lemonade"] = true,
        ["energydrink"] = true,
        ["freshorangejuice"] = true,
    },
    ["mechanic"] = {
        ["repairkit"] = true,
        ["advancedrepairkit"] = true,
        ["cleaningkit"] = true,
    },
    ["club"] = {
        ["vodka"] = true,
        ["rhum"] = true,
        ["gin"] = true,
        ["jagermeister"] = true,
        ["whisky"] = true,
        ["tequila"] = true,
    },
}

Config.NotMetalWeapons = {
    [GetHashKey('weapon_petrolcan')] = true,
    [GetHashKey('weapon_bat')] = true,
    [GetHashKey('weapon_salty')] = true,
    [GetHashKey('weapon_poolcue')] = true,
}

Config.Buds = {
	["highgradewetbud"] = 18000,
	["lowgradewetbud"] = 28800,
}

Config.BudStashes = {
	"motel",
	"house"
}

Config.DryBuds = {
	["lowgradewetbud"] = "lowdrybud",
	["highgradewetbud"] = "highdrybud"
}

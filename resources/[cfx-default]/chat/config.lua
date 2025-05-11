Config = {}
Config.DateFormat = '%H:%M' -- To change the date format check this website - https://www.lua.org/pil/22.1.html
Config.StaffGroups = {
	'superadmin',
	'admin',
	'mod',
}

Config.roleList = {
    {'0', "[Newbie] "},
    {'941430719668969522', "^7[Civilian] "},
    {'941430692313710643', "^4[LSPD] "},
    {'941430692875735060', "^2[EMS] "},
    {'941430691265126500', "^2[Streamer] "},
    {'941430682708738098', "^8[Staff] "},
    {'941430668846563388', "^1[Head Admin] "},
    {'941430667533746206', "^1[Owner] "},
}
--------------------------------
-- [Clear Player Chat]

Config.AllowPlayersToClearTheirChat = true
Config.ClearChatCommand = 'clear'

--------------------------------
-- [Staff]

Config.EnableStaffCommand = true
Config.StaffCommand = 'st'
Config.AllowStaffsToClearEveryonesChat = true
Config.ClearEveryonesChatCommand = 'clearall'

-- [Staff Only Chat]

Config.EnableStaffOnlyCommand = true
Config.StaffOnlyCommand = 'so'

--------------------------------
-- [Advertisements]

Config.EnableAdvertisementCommand = true
Config.AdvertisementCommand = 'ad'
Config.AdvertisementPrice = 1000
Config.AdvertisementCooldown = 5 -- in minutes

--------------------------------
-- [Twitch]

Config.EnableTwitchCommand = true
Config.TwitchCommand = 'twitch'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.TwitchList = {
	'steam:110000118a12j8a' -- Example, change this
}

--------------------------------
-- [Youtube]

Config.EnableYoutubeCommand = true
Config.YoutubeCommand = 'yt'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.YoutubeList = {
	'steam:110000118a12j8a' -- Example, change this
}

--------------------------------
-- [Twitter]

Config.EnableTwitterCommand = true
Config.TwitterCommand = 'twt'

--------------------------------
-- [Police]

Config.EnablePoliceCommand = true
Config.PoliceCommand = 'pol'
Config.PoliceJobName = 'police'

--------------------------------
-- [Ambulance]

Config.EnableAmbulanceCommand = true
Config.AmbulanceCommand = 'ems'
Config.AmbulanceJobName = 'ambulance'

--------------------------------
-- [OOC]

Config.EnableOOCCommand = false
Config.OOCCommand = 'ooc'
Config.OOCDistance = 20.0

--------------------------------
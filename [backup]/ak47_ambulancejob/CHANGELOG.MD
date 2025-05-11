## 1.1
	-ak47_ambulancejob:onFinishCheckin added (modules/checkin/client/customizable.lua)
## 1.2
	-boss menu adjustment
## 1.3
	-wardrobe added
## 1.4
	-txAdmin revive support
## 1.5
	-wheelchair & stretcher remove adjustment
## 1.6
	-small adjustment in animation
## 1.7
	-remove item adjustment
## 1.8
	-stretcher offset adjustment for default ambulance
## 1.9
	-medicalbag & medicinebox exploit fixed
## 2.0
	-new stretcher prop
	-replaced prop converted to addon prop
	-stretcher/wheelchair to bed glitch fixed
## 2.1
	-stretcher heading adjustment for transport vehicle
## 2.2
	-character switch bug fixed
	-add society money fixed
## 2.3
	-skellyfix synced
## 2.4
	-Disable force respawn button when enough ems available
	-Block qs-inventory when player dead
## 2.5
	-morphine10 fixed
## 2.6
	-checkin distance increased
## 2.7
	-DisableDeadControls() call has been fixed
## 2.8
	-saline add health fixed
## 2.9
	-multiple job supported
## 3.0
	-saline will add food, water and remove stress
## 3.1
	-down log webhook fixed
	Replace:  
		=> modules/death/server/log.lua
## 3.2
	-ak47_ambulancejob:onForceRespawn added
	Replace:  
		=> modules/death/client/death.lua
		=> modules/death/client/customizable.lua
## 3.2.1
	-disable autospawn from spawmanager
	Replace:  
		=> utils/client.lua
## 3.3
    -revive or checkin will give 100% food, water and relieve 100% stress
## 3.4
    -combat log auto respawn added
    -combat log punishment added
    Replace:  
		=> config.lua
		=> modules/main/client/main.lua
		=> modules/main/server/main.lua
## 3.5
    -player will get hold E option after brain dead 
    Replace:  
		=> modules/death/client/death.lua
## 3.6
    -m-Insurance support added
    Replace:  
		=> modules/main/server/main.lua
		=> utils/server.lua
## 3.7
    -bug after brain dead fixed
    Replace:  
		=> modules/death/client/death.lua
		=> locales/en.lua
## 3.8
    -applybandage translation fixed
    Replace:  
		=> modules/skelly/client/treatment.lua
		=> locales/en.lua
## 3.9
    -combat log auto respawn fixed
    Replace:  
		=> modules/main/client/main.lua
## 4.0
    -codem-apperance support added
    Replace:  
		=> modules/wardrobe/config.lua
		=> modules/wardrobe/client/wardrobe.lua
## 4.1
    -crawl movement added when down
    Replace:  
		=> config.lua
		=> modules/death/client/dead.lua
## v4.2
    -ak47_vehiclekeys support added
    Replace:  
        => modules/vehicle/client/customizable.lua
        => modules/vehicle/client/vehicle.lua
## v4.3
    -Config.AutoRespawnAfterBrainDead is now functional
    Replace:  
        => modules/death/client/dead.lua
## v4.4
    -mute dead player
    Replace:  
        => config.lua
        => modules/main/server/main.lua
## v4.5
    -mute dead player mumble error fixed
    Replace:  
        => modules/death/client/customizable.lua
        => modules/main/server/main.lua
## v4.6
    -back to server side to fix mute dead player
    Replace:  
        => modules/death/client/customizable.lua
        => modules/main/server/main.lua
## v4.7
    -auto crutch after checkin (require ak47_crutch)
    Replace:  
        => config.lua
        => modules/checkin/client/customizable.lua
## v4.8
    -GetSkellyDamages export added (check documentation)
    Replace:  
        => modules/skelly/client/skelly.lua
## v4.9
    -negative balance support in checking
    Replace:  
        => modules/checkin/config.lua
        => modules/checkin/client/checkin.lua
        => utils/server.lua
## v5.0
    -dead player will stay inside the vehicle
    Replace:  
        => modules/death/client/dead.lua
## v5.1
    -discord log fixed
    Replace:  
        => webhooks.lua
        => modules/death/client/log.lua
## v5.2
    -delete transport ambulance, npc adjusted
    -give firstaid & medikit to patient with target option
    Replace:  
        => config.lua
        => locales/en.lua
        => modules/death/client/dead.lua
        => modules/skelly/client/kit.lua
        => modules/skelly/client/treatment.lua
        => modules/skelly/server/skelly.lua
## v5.3
    -object management improved
    Replace:  
        => modules/medicalbag/client/medicalbag.lua
        => modules/medicinebox/client/medicinebox.lua
        => modules/saline/client/saline.lua
        => modules/saline/server/saline.lua
        => modules/stretcher/client/streature.lua
        => modules/wheelchair/client/wheelchair.lua
## v5.3.1
    -medicinebox problem fixed
    Replace:  
        => modules/medicinebox/client/medicinebox.lua
## v5.4
    - cause of damage added
    Replace:  
        => locales/en.lua
        => modules/death/config.lua
        => modules/skelly/client/kit.lua
        => modules/skelly/client/skelly.lua
        => modules/skelly/client/treatment.lua
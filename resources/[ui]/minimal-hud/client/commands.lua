local interface = require("modules.interface.client")

RegisterCommand("togglehud", function()
	interface.toggle()
end, false)

RegisterCommand("testvoice", function()
	interface.message("setPlayerState", {
		isTalking = true,
		talkingOnRadio = false,
		onRadio = false,
		onPhone = false,
		voiceRange = 2
	})
end, false)

RegisterCommand("testvoiceradio", function()
	interface.message("setPlayerState", {
		isTalking = true,
		talkingOnRadio = true,
		onRadio = true,
		onPhone = false,
		voiceRange = 2
	})
end, false)

RegisterCommand("testvoicephone", function()
	interface.message("setPlayerState", {
		isTalking = true,
		talkingOnRadio = false,
		onRadio = false,
		onPhone = true,
		voiceRange = 2
	})
end, false)

RegisterCommand("testvoiceoff", function()
	interface.message("setPlayerState", {
		isTalking = false,
		talkingOnRadio = false,
		onRadio = false,
		onPhone = false,
		voiceRange = 2
	})
end, false)

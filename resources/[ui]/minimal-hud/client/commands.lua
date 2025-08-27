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

RegisterCommand("debugvoice", function()
	local playerId = PlayerId()
	local isTalking = MumbleIsPlayerTalking(playerId) == 1
	local onRadio = LocalPlayer.state['radioChannel'] and LocalPlayer.state['radioChannel'] > 0 or false
	local onPhone = LocalPlayer.state['callChannel'] and LocalPlayer.state['callChannel'] > 0 or false
	
	print("=== VOICE DEBUG ===")
	print("isTalking:", isTalking)
	print("talkingOnRadio:", _G.talkingOnRadio or false)
	print("onRadio:", onRadio)
	print("onPhone:", onPhone)
	print("voiceRange:", _G.voiceRange or 2)
	print("==================")
end, false)

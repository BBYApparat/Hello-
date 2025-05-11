$('#heartbeat').trigger('pause');

function fadeOutAudio() {
	$('#heartbeat').trigger('pause');
}

function play(volume) {
	document.getElementById("heartbeat").currentTime = 0;
	$("#heartbeat").prop("muted", false);
	document.getElementById("heartbeat").volume = volume;
	$('#heartbeat').trigger('play');
}

function updateVolume(volume) {
	document.getElementById("heartbeat").volume = volume;
}

function updatePlaybackSpeed(state) {
	myaudio = document.getElementById("heartbeat");
	myaudio.playbackRate = state;
}

function message(type, state) {
	if (type === "fadeOutAudio") fadeOutAudio();
	if (type === "play") play(state);
	if (type === "updateVolume") updateVolume(state);
	if (type === "updatePlaybackSpeed") updatePlaybackSpeed(state);
}

window.addEventListener('message', function(event) {
	var item = event.data;
	message(item.type, item.status);
});
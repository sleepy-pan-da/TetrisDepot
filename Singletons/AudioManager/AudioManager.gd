extends Node2D

onready var sfx : Node2D = $SFX
onready var music : Node2D = $Music

func _ready() -> void:
	playTheme()


func playSfx(soundName : String) -> void:
	var audio : AudioStreamPlayer = sfx.get_node(soundName)
	if not audio:
		print("Audio {soundName} not found".format({"soundName": soundName}))
		return
	audio.play()


func playClearBlkSfx(soundName : String) -> void:
	var clearBlk : Node2D = sfx.get_node("ClearBlocks")
	
	# stops all playing clearBlk audios
	for childAudio in clearBlk.get_children():
		if childAudio is AudioStreamPlayer:
			childAudio.stop()

	var audio : AudioStreamPlayer = clearBlk.get_node(soundName)
	if not audio:
		print("Audio {soundName} not found".format({"soundName": soundName}))
		return
	audio.play()


func playTheme() -> void:
	var audio : AudioStreamPlayer = music.get_node("Theme")
	if not audio:
		print("Audio {soundName} not found".format({"soundName": "Theme"}))
		return
	audio.play()


func changeTempoOfMusic(speedMultiplier : float) -> void:
	var audio : AudioStreamPlayer = music.get_node("Theme")
	if not audio:
		print("Audio {soundName} not found".format({"soundName": "Theme"}))
		return
	
	audio.pitch_scale = speedMultiplier
	AudioServer.get_bus_effect(1, 0).pitch_scale = 1.0 / speedMultiplier
	
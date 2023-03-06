extends Node2D

onready var sfx = $SFX
onready var music = $Music

func playSfx(soundName : String) -> void:
	var audio : AudioStreamPlayer = sfx.get_node(soundName)
	if not audio:
		print("Audio {soundName} not found".format({"soundName": soundName}))
		return
	audio.play()
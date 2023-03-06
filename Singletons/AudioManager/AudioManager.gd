extends Node2D

onready var sfx : Node2D = $SFX
onready var music : Node2D = $Music

# func _ready():

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
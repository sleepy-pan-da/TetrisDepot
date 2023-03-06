extends VBoxContainer

onready var playButton : Button = $Play
export(String) var pathToNextScene 

func _on_Play_pressed() -> void:
	get_tree().change_scene(pathToNextScene)
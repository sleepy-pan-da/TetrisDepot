extends VBoxContainer

onready var playButton : Button = $Play
export(String) var pathToGameScene
export(String) var pathToTutorialScene



func _on_Play_pressed() -> void:
	get_tree().change_scene(pathToGameScene)

func _on_Tutorial_pressed() -> void:
	get_tree().change_scene(pathToTutorialScene)
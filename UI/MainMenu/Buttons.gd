extends VBoxContainer

onready var playButton : Button = $Play
export(String) var pathToGameScene
export(String) var pathToTutorialScene
export(NodePath) var pathToSettings
var settings : Control

func _ready() -> void:
	settings = get_node(pathToSettings)


func _on_Play_pressed() -> void:
	get_tree().change_scene(pathToGameScene)


func _on_Tutorial_pressed() -> void:
	get_tree().change_scene(pathToTutorialScene)


func _on_Settings_pressed() -> void:
	settings.show()

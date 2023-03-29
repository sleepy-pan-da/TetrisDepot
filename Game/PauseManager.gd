extends Node

export(NodePath) var settingsPath
var settings : Control


func _ready() -> void:
	settings = get_node(settingsPath)
	settings.connect("pressedBack", self, "unpause")


func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("pause"):
		if not get_tree().paused:
			get_tree().paused = true
			settings.show()
		else:
			settings.hide()
			unpause()


func unpause() -> void:
	get_tree().paused = false

extends VBoxContainer

export(String) var pathToZenScene
export(String) var pathToTutorialScene
export(String) var pathToTimeAttackScene
export(NodePath) var pathToSettings
var settings : Control

func _ready() -> void:
	settings = get_node(pathToSettings)


func _on_Zen_pressed() -> void:
	get_tree().change_scene(pathToZenScene)


func _on_Tutorial_pressed() -> void:
	get_tree().change_scene(pathToTutorialScene)


func _on_TimeAttack_pressed() -> void:
	get_tree().change_scene(pathToTimeAttackScene)


func _on_Settings_pressed() -> void:
	settings.show()

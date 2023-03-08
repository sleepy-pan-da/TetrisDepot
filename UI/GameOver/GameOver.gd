extends Control

export(String) var pathToMainMenu 


func _ready() -> void:
	EventManager.connect("gameOver", self, "onGameOver")


func onGameOver() -> void:
	show()


func _on_TryAgain_pressed() -> void:
	get_tree().reload_current_scene()


func _on_Quit_pressed() -> void:
	AudioManager.changeTempoOfMusic(1)
	get_tree().change_scene(pathToMainMenu)
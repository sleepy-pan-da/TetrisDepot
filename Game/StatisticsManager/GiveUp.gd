extends Button


func _on_GiveUpButton_pressed() -> void:
	EventManager.emit_signal("gameOver")
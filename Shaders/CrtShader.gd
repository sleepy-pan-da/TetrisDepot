extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.connect("updateCrtShaderStatus", self, "updateStatus")
	updateStatus()
	

func updateStatus() -> void:
	visible = CrtManager.isCrtToggled
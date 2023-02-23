extends TextureRect

var hasOverlappingBlock : bool = false


func _ready():
	EventManager.connect("droppedBlockIntoSpeechBubble", self, "updateSpeechBubble")
		

# Called when a block is dropped on it
func updateSpeechBubble(_droppedBlockName : String) -> void:
	if not hasOverlappingBlock: return
	EventManager.emit_signal("updatedAnyStockSpeechBubble")


func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("Block"):
		hasOverlappingBlock = true


func _on_Area2D_area_exited(area : Area2D):
	if area.is_in_group("Block"):
		hasOverlappingBlock = false
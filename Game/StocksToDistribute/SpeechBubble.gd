# Contains blockIcons and handles their logic
extends NinePatchRect

export(PackedScene) var blockIcon
onready var gridContainer : GridContainer = $GridContainer
var blockMap = {} # key = blockName, val = [qty, refToBlockIcon]
var hasOverlappingBlock : bool = false


func _ready():
	EventManager.connect("droppedBlockIntoSpeechBubble", self, "updateSpeechBubble")


# Each blockIcon in speechbubble is unique for this to work
func generateBlockIcon(blockLogoName : String, newQty : int):
	var newBlockIcon : Node = blockIcon.instance()
	if not newBlockIcon.has_method("setUp"):
		newBlockIcon.queue_free()
		print("Error generating block icon in speech bubble")
		return
	
	gridContainer.add_child(newBlockIcon)
	var successfullySetUp : bool = newBlockIcon.setUp(blockLogoName, newQty)
	if not successfullySetUp:
		print("BlockIcon not successfully setup")
		newBlockIcon.queue_free()
		return
	blockMap[blockLogoName] = [newQty, newBlockIcon]
		

# Called when a block is dropped on it
func updateSpeechBubble(droppedBlockName) -> void:
	if not hasOverlappingBlock: return

	# check if dropped block is in blockMap
	if not (droppedBlockName in blockMap):
		print("dropped {str} not in blockMap".format({"str": droppedBlockName}))
		EventManager.emit_signal("updatedSpeechBubble", false, null)
		return
	
	# update the respective blockIcon
	blockMap[droppedBlockName][0] -= 1
	var newQty : int = blockMap[droppedBlockName][0]
	if newQty <= 0:
		blockMap[droppedBlockName][1].queue_free()
		blockMap.erase(droppedBlockName)
	else:
		blockMap[droppedBlockName][1].updateQtyLabel(newQty)
	
	EventManager.emit_signal("updatedSpeechBubble", true, droppedBlockName)
	if blockMap.size() == 0: queue_free()


func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("Block"):
		hasOverlappingBlock = true


func _on_Area2D_area_exited(area : Area2D):
	if area.is_in_group("Block"):
		hasOverlappingBlock = false


func _on_SpeechBubble_tree_exited():
	# update StocksToDistribute to spawn another speechBubble
	EventManager.emit_signal("finishedSpeechBubble")
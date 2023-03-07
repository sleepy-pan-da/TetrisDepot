extends Area2D

export(Color, RGB) var origColour : Color
export(Color, RGB) var disabledColour : Color
export(String) var blockName : String

var blockDestroyedVFX = load("res://Game/VFX/DestroyedBlock.tscn")
var dragging : bool = false
var numOfOverlappingIllegalAreas : int = 0
var isInGridArea : bool = false
var isInSpeechBubble : bool = false
var prevPos : Vector2
var prevRotationInDegrees : int
var refToHeldStocks : Node

signal onDragOrDrop

func _ready() -> void:
	connect("onDragOrDrop", self, "setDragState")
	EventManager.connect("updatedSpeechBubble", self, "updateBlockStatus")
	EventManager.connect("updatedAnyStockSpeechBubble", self, "deleteBlock")

	prevPos = global_position
	prevRotationInDegrees = 0


func _process(_delta):
	if dragging:
		var mousePos : Vector2 = get_viewport().get_mouse_position()
		global_position = Vector2(stepify(mousePos.x, 64), stepify(mousePos.y, 64))


func setDragState():
	changeAlpha(1)
	dragging = !dragging
	z_index = 1 if dragging else 0 # render the dragged block on top of the other blocks


# to drag
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("onDragOrDrop")


func _on_mouse_entered() -> void:
	if not dragging: changeAlpha(0.3)


func _on_mouse_exited() -> void:
	changeAlpha(1)


func changeAlpha(newAlpha : float) -> void:
	modulate.a = newAlpha


# to drop
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if event.button_index == BUTTON_LEFT and dragging:
			emit_signal("onDragOrDrop")
			if isInGridArea and numOfOverlappingIllegalAreas == 0: # successfully dropped block
				prevPos = global_position
				prevRotationInDegrees =  int(rotation_degrees) % 360
				reparentIfNeeded()
				AudioManager.playSfx("PlaceBlock")
			elif isInSpeechBubble:
				EventManager.emit_signal("droppedBlockIntoSpeechBubble", blockName)
			else:
				print("resetted")
				reset()
	elif Input.is_action_just_pressed("rotate") and dragging:
		# rotate(PI/2)
		# rotate(deg2rad(90))
		rotation_degrees += 90
		rotation_degrees = int(rotation_degrees) % 360 # need to see if this fixes the float bug in rotation
		AudioManager.playSfx("RotateBlock")


# when this happens, it means that something is in the way of the block	 
func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("Outer") or area.is_in_group("Block"):
		numOfOverlappingIllegalAreas += 1
		if dragging: modulate = disabledColour
	elif area.is_in_group("Inner"):
		isInGridArea = true
	elif area.is_in_group("SpeechBubble"):
		isInSpeechBubble = true


func _on_Area2D_area_exited(area : Area2D):
	if area.is_in_group("Outer") or area.is_in_group("Block"):
		numOfOverlappingIllegalAreas -= 1
		if numOfOverlappingIllegalAreas == 0: modulate = origColour
	elif area.is_in_group("Inner"):
		isInGridArea = false
	elif area.is_in_group("SpeechBubble"):
		isInSpeechBubble = false


func updateBlockStatus(updatedSpeechBubbleStatus : bool, _blockName : String):
	if not isInSpeechBubble: return
	if updatedSpeechBubbleStatus:
		deleteBlock()
	else:
		reset()


func deleteBlock() -> void:
	if not isInSpeechBubble: return
	queue_free()


func reset():
	toggleMonitoringAndMonitorable(false)
	returnToPrevPositionAndRotation()
	toggleMonitoringAndMonitorable(true)	
	numOfOverlappingIllegalAreas = 0
	isInGridArea = false
	isInSpeechBubble = false
	modulate = origColour


func toggleMonitoringAndMonitorable(toggleState : bool):
	monitoring = toggleState
	monitorable = toggleState


func returnToPrevPositionAndRotation():
	global_position = prevPos
	rotation_degrees = prevRotationInDegrees


func setRefToHeldStocks(ref : Node):
	refToHeldStocks = ref


func reparentIfNeeded():
	var parent : Node = get_parent()
	if not parent: return
	
	if parent.is_in_group("StockToTake"):
		var tempGlobalPosition : Vector2 = global_position
		parent.remove_child(self)
		refToHeldStocks.add_child(self)
		self.global_position = tempGlobalPosition
		EventManager.emit_signal("tookStock")


func returnGlobalCoordsOfEachBox():
	var res = []
	for child in get_children():
		if child is Sprite:
			# when rotated, the components of global_position might be floats instead of ints
			res.append(Vector2(round(child.global_position.x), round(child.global_position.y)))
	return res


func destroy() -> void:
	var blkDestroyedVFX = blockDestroyedVFX.instance()
	get_parent().add_child(blkDestroyedVFX)
	blkDestroyedVFX.setColour(returnColorOfDestroyedBlk())
	blkDestroyedVFX.global_position = global_position
	queue_free()


func returnColorOfDestroyedBlk() -> Color:
	match blockName:
		"IBlock":
			print("IBlock color")
			return Color("#6A4C93")
		"JBlock":
			print("JBlock color")
			return Color("#1982C4")
		"LBlock":
			print("LBlock color")
			return Color("#52A675")
		"OBlock":
			print("OBlock color")
			return Color("#FFCA3A")
		"SBlock":
			print("SBlock color")
			return Color("#287271")
		"TBlock":
			print("TBlock color")
			return Color("#FF924C")
		"ZBlock":
			print("ZBlock color")
			return Color("#FF595E")
	return Color("#000000")

	
		

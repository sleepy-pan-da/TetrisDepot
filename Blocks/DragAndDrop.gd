extends Area2D


export(Color, RGB) var origColour : Color
export(Color, RGB) var disabledColour : Color
export(String) var blockName : String
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
	dragging = !dragging
	z_index = 1 if dragging else 0 # render the dragged block on top of the other blocks


# to drag
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("onDragOrDrop")


# to drop
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if event.button_index == BUTTON_LEFT and dragging:
			emit_signal("onDragOrDrop")
			if isInGridArea and numOfOverlappingIllegalAreas == 0: # successfully dropped block
				prevPos = global_position
				prevRotationInDegrees =  int(rotation_degrees) % 360
				reparentIfNeeded()
			elif isInSpeechBubble:
				EventManager.emit_signal("droppedBlockIntoSpeechBubble", blockName)
			else:
				print("resetted")
				reset()
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE and dragging:
			rotate(PI/2)


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
	global_rotation_degrees = prevRotationInDegrees


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

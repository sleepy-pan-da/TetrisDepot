extends Area2D


export(Color, RGB) var origColour
export(Color, RGB) var disabledColour
var dragging : bool = false
var numOfOverlappingAreas : int = 0

signal onDragOrDrop

func _ready() -> void:
	connect("onDragOrDrop", self, "setDragState")


func _process(_delta):
	if dragging:
		var mousePos : Vector2 = get_viewport().get_mouse_position()
		self.position = Vector2(stepify(mousePos.x, 64), stepify(mousePos.y, 64))


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
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE and dragging:
			rotate(PI/2)


# when this happens, it means that something is in the way of the block	 
func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("Outer") or area.is_in_group("Block"):
		numOfOverlappingAreas += 1
	if dragging:
		modulate = disabledColour

func _on_Area2D_area_exited(_area : Area2D):
	numOfOverlappingAreas -= 1
	if numOfOverlappingAreas == 0:
		modulate = origColour

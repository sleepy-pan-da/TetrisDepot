extends Node2D

var dragStart : Vector2 = Vector2.ZERO
var dragEnd : Vector2 = Vector2.ZERO
var dragging : bool = false


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			dragging = true
			dragStart = stepifyPos(event.position)
		else:
			dragging = false
			updateStatus(dragStart, stepifyPos(event.position), dragging)
			
			var selectRect = RectangleShape2D.new()
			selectRect.extents = (dragEnd-dragStart)/2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.collide_with_areas = true
			query.set_shape(selectRect)
			query.transform = Transform2D(0, (dragEnd+dragStart)/2)
			var selectedBlocks = space.intersect_shape(query)
			print(selectedBlocks)

	if dragging:
		if event is InputEventMouseMotion:
			updateStatus(dragStart, stepifyPos(event.position), dragging)


func stepifyPos(pos : Vector2) -> Vector2:
	return Vector2(stepify(pos.x, 64), stepify(pos.y, 64))


func _draw() -> void:
	if dragging:
		draw_rect(Rect2(dragStart, dragEnd-dragStart), Color(1,1,1), false, 5)
		

func updateStatus(start : Vector2, end : Vector2, isDragging : bool) -> void:
	dragStart = start
	dragEnd = end
	dragging = isDragging
	update()

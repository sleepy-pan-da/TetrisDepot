extends Node2D

var dragStart : Vector2 = Vector2.ZERO
var dragEnd : Vector2 = Vector2.ZERO
var dragging : bool = false
var canDelete : bool = false
var mapOfSelectedBlocks = {} 


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			dragging = true
			dragStart = stepifyPos(event.position)
		else:
			dragging = false
			if canDelete: deleteBlocks()
			updateStatus(dragStart, stepifyPos(event.position), dragging, false)

			
	if dragging:
		if event is InputEventMouseMotion:
			if stepifyPos(event.position) == dragEnd: return
			# this looks funny but u need to draw the new rect first before being able to check if can delete
			updateStatus(dragStart, stepifyPos(event.position), dragging, false)
			updateStatus(dragStart, stepifyPos(event.position), dragging, checkIfCanDeleteBlocksInRect())


func stepifyPos(pos : Vector2) -> Vector2:
	return Vector2(stepify(pos.x, 64), stepify(pos.y, 64))


func _draw() -> void:
	if dragging:
		if canDelete: draw_rect(Rect2(dragStart, dragEnd-dragStart), Color(0,1,0), false, 5)
		else: draw_rect(Rect2(dragStart, dragEnd-dragStart), Color(1,1,1), false, 5)
			

func updateStatus(start : Vector2, end : Vector2, isDragging : bool, isDeletable : bool) -> void:
	dragStart = start
	dragEnd = end
	dragging = isDragging
	canDelete = isDeletable
	update()


func checkIfCanDeleteBlocksInRect() -> bool:
	# Get selected colliders in drawn rect2d
	var selectRect = RectangleShape2D.new()
	selectRect.extents = (dragEnd-dragStart)/2
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.set_shape(selectRect)
	query.transform = Transform2D(0, (dragEnd+dragStart)/2)
	var selectedColliders = space.intersect_shape(query, 64) # 64 is needed for max colliders

	# Filter for set of unique area2Ds to get selected blocks
	mapOfSelectedBlocks = {}
	var withinGridArea : bool = false 
	for collider in selectedColliders:
		if collider["collider"].is_in_group("Inner"): withinGridArea = true
		if collider["collider"].is_in_group("Block") and not collider["collider_id"] in mapOfSelectedBlocks:
			mapOfSelectedBlocks[collider["collider_id"]] = collider["collider"]
	if not withinGridArea: return false
	#print(mapOfSelectedBlocks)
	#print("Num of enclosed blocks: " + str(len(mapOfSelectedBlocks.values())))
	
	# Compute num of rows/cols
	var rectWidth : float = abs(selectRect.extents.x*2)
	var rectHeight : float = abs(selectRect.extents.y*2)
	var rows : float = rectHeight/64
	var cols : float = rectWidth/64
	
	#print("Rows:{rows}, Cols:{cols}".format({"rows": rows, "cols": cols}))
	if rows <= 0 or cols <= 0:
		print("Rows/Cols too small")
		return false
	
	# coordRef is the topleft coord of the drawn rect
	# Helps in transposing global coords into grid coords
	var coordRef : Vector2 = Vector2(min(dragStart.x, dragEnd.x), min(dragStart.y, dragEnd.y)) + Vector2(32, 32)

	#print(coordRef)
	#print("Start coord:{dragStart}, End coord:{dragEnd}".format({"dragStart": dragStart, "dragEnd": dragEnd}))

	# Create 2d matrix of rows x cols
	var grid = []
	for i in range(rows):
		grid.append([])
		for _j in range(cols):
			grid[i].append(false)
	
	for blk in mapOfSelectedBlocks.values():
		var globalCoordsOfEachBox = blk.returnGlobalCoordsOfEachBox()
		# transpose the global coords into grid coords and mark accordingly
		for coord in globalCoordsOfEachBox:
			var i : int = (coord.y - coordRef.y)/64 # row
			var j : int = (coord.x - coordRef.x)/64 # col
			#print("i:{i}, j:{j}".format(({"i":i, "j":j})))
			
			# check if block's box exceeds rect boundary
			if not (0<=i and i<rows) or not (0<=j and j<cols):
				#print("Block exceeds rect boundary")
				return false
			grid[i][j] = true
	
	# check for unmarked grids
	for i in range(rows):
		for j in range(cols):
			if not grid[i][j]:
				print("There are empty spaces in coord:{i},{j} in drawn rect".format(({"i":i,"j":j})))
				return false
	
	return true


func deleteBlocks() -> void:
	# delete the blocks enclosed in the drawn rect
	
	computeScoreAndTimeEarned()

	for blk in mapOfSelectedBlocks.values():
		blk.destroy()


func computeScoreAndTimeEarned() -> void:
	var scoreEarned : int = 0
	var timeIncremented : int = computeTimeIncremented(len(mapOfSelectedBlocks.values()))
	scoreEarned += computeScoreForNumberOfBlocksRemovedAtOneGo(len(mapOfSelectedBlocks.values()))
	# get number of unique block types to compute score
	var blockTypes = {}
	for blk in mapOfSelectedBlocks.values():
		if not blk.blockName in blockTypes:
			blockTypes[blk.blockName] = null
	scoreEarned += computeScoreForNumberOfUniqueBlockTypesRemovedAtOneGo(blockTypes.size())
	
	print("scoreEarned:{i}, timeIncremented:{j}".format(({"i":scoreEarned, "j":timeIncremented})))
	EventManager.emit_signal("computedTimeEarnedFromDeletingBlocks", timeIncremented)
	EventManager.emit_signal("computedScoreEarnedFromDeletingBlocks", scoreEarned)


func computeScoreForNumberOfBlocksRemovedAtOneGo(numberOfBlocks : int) -> int:
	return int(pow(2, numberOfBlocks-1))


func computeTimeIncremented(numberOfBlocks : int) -> int:
	# 16 +80s
	# 12-15 +60s
	# 8-11 + 40s
	# 5-7 +30s
	# 4 +10
	# 3 +5s
	# 2 +1s
	# 1 +0s  
	if numberOfBlocks <= 1:
		return 0
	elif numberOfBlocks <= 2:
		return 1
	elif numberOfBlocks <= 3:
		return 3
	elif numberOfBlocks <= 4:
		return 5
	elif numberOfBlocks <= 7:
		return 10
	elif numberOfBlocks <= 11:
		return 20
	elif numberOfBlocks <= 15:
		return 40
	else:
		return 80


func computeScoreForNumberOfUniqueBlockTypesRemovedAtOneGo(numberOfBlockTypes : int) -> int:
	return int(pow(5, numberOfBlockTypes-1))
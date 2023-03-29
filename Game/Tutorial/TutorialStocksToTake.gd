extends Node2D

export(Array, PackedScene) var blocks
export(NodePath) var pathToHeldStocks
onready var heldStocks : Node = get_node(pathToHeldStocks)
var map = {"LBlock": 2, "JBlock": 1, "SBlock": 4, "IBlock": 0}
signal takenAllStocks



func _ready() -> void:
	EventManager.connect("tookStock", self, "onTookStock")
	spawn2LBlocks()


func spawn2LBlocks() -> void:
	for i in range(2):
		var curChild : Position2D = get_child(i)
		var block : Node = spawnBlock("LBlock")
		if not block: return
		curChild.add_child(block)


func spawnNextWaveOfBlocks(instructionI : int) -> void:
	if instructionI == 2: spawnLBlockJBlockSBlock()
	elif instructionI == 4: spawnIBlock()
	else: print("no more wave to spawn")


func spawnBlock(blockName : String) -> Node:
	if not blockName in map:
		print("block name not in map")
		return null
	var i : int = map[blockName]
	var block : Node = blocks[i].instance()
	if block.has_method("setRefToHeldStocks"):
		block.setRefToHeldStocks(heldStocks)
	return block


func spawnLBlockJBlockSBlock() -> void:
	for i in range(3):
		var curChild : Position2D = get_child(i)
		var block : Node
		if i == 0: block = spawnBlock("LBlock")
		elif i == 1: block = spawnBlock("JBlock")
		else: block = spawnBlock("SBlock")
		if not block: return
		curChild.add_child(block)


func spawnIBlock() -> void:
	var curChild : Position2D = get_child(0)
	var block : Node = spawnBlock("IBlock")
	if not block: return
	curChild.add_child(block)


func onTookStock() -> void:
	# check if all stocks are taken
	var remainingBlock : int = 0 
	for child in get_children():
		if child is Position2D and child.get_child_count() == 1:
			remainingBlock += 1
	
	# all stocks are taken
	if remainingBlock == 0:
		emit_signal("takenAllStocks")

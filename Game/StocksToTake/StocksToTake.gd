extends Node2D

export(Array, PackedScene) var blocks
export(NodePath) var pathToHeldStocks
onready var heldStocks : Node = get_node(pathToHeldStocks)


func _ready() -> void:
	EventManager.connect("tookStock", self, "replenishEmptyStocks")
	replenishEmptyStocks()


func replenishEmptyStocks() -> void:
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateStock(child)


func generateStock(parentNode : Node) -> void:
	var i : int = generateRandonIndexForStock()
	var stock : Node = blocks[i].instance()
	if stock.has_method("setRefToHeldStocks"):
		stock.setRefToHeldStocks(heldStocks)
	parentNode.add_child(stock)


# FOR REFERENCE
# var pool = {
# 	"IBlock": 0, 
# 	"JBlock": 0,
# 	"LBlock": 0,
# 	"OBlock": 0,
# 	"SBlock": 0,
# 	"TBlock": 0,
# 	"ZBlock": 0
# }

func generateRandonIndexForStock() -> int:
	randomize()
	var i : int = randi()%100 + 1
	if i >= 84:
		return 0 # IBlock
	elif i >= 67:
		return 3 # OBlock
	elif i >= 50:
		return 1 # JBlock
	elif i >= 33:
		return 2 # LBlock
	elif i >= 16:
		return 5 # TBlock
	else:
		var coinToss : int = randi()%2
		if coinToss: return 4 # SBlock
		else: return 6 # ZBlock
extends Node2D

export(Array, PackedScene) var blocks
export(NodePath) var pathToHeldStocks
onready var heldStocks : Node = get_node(pathToHeldStocks)
var pool = {
	"IBlock": 0, 
	"JBlock": 0,
	"LBlock": 0,
	"OBlock": 0,
	"SBlock": 0,
	"TBlock": 0,
	"ZBlock": 0
}
# maps block to i in blocks
var blockMap = {
	"IBlock": 0, 
	"JBlock": 1,
	"LBlock": 2,
	"OBlock": 3,
	"SBlock": 4,
	"TBlock": 5,
	"ZBlock": 6
}


func _ready() -> void:
	EventManager.connect("tookStock", self, "replenishEmptyStocks")
	EventManager.connect("subtractedFromStocksToDistributePool", self, "updatePool")
	EventManager.connect("readyStocksToDistribute", self, "replenishEmptyStocks")
	# replenishEmptyStocks()


func replenishEmptyStocks() -> void:
	print(pool)
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateStock(child)


func updatePool(blockType : String, amountToAdd : int) -> void:
	if not blockType in pool: 
		print("{str} not in StocksToTakePool".format({"str": blockType}))
		return
	pool[blockType] += amountToAdd


func generateStock(parentNode : Node) -> void:
	randomize()
	var blockType : String = returnRandomBlockFromPool()
	var i : int = blockMap[blockType]
	var stock : Node = blocks[i].instance()
	# update the pool
	pool[blockType] -= 1
	
	if stock.has_method("setRefToHeldStocks"):
		stock.setRefToHeldStocks(heldStocks)
	parentNode.add_child(stock)


func returnRandomBlockFromPool() -> String:
	randomize()
	var blockTypes = pool.keys()
	var blockType : String = blockTypes[randi() % blockTypes.size()]
	while pool[blockType] <= 0:
		blockType = blockTypes[randi() % blockTypes.size()]
	return blockType

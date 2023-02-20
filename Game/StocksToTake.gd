extends Node2D

export(Array, PackedScene) var blocks
export(NodePath) var pathToHeldStocks
onready var heldStocks : Node = get_node(pathToHeldStocks)
# var pool = {} # it's like a set of some sort determined by the stocks to disseminate


func _ready() -> void:
	EventManager.connect("tookStock", self, "replenishEmptyStocks")
	replenishEmptyStocks()


func replenishEmptyStocks() -> void:
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateStock(child)


func generateStock(parentNode) -> void:
	randomize()
	var randIndex: int = randi() % blocks.size()
	var stock : Node = blocks[randIndex].instance()
	
	if stock.has_method("setRefToHeldStocks"):
		stock.setRefToHeldStocks(heldStocks)
	parentNode.add_child(stock)



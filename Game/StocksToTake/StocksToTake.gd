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
	randomize()
	var i : int = randi()%len(blocks)
	var stock : Node = blocks[i].instance()
	if stock.has_method("setRefToHeldStocks"):
		stock.setRefToHeldStocks(heldStocks)
	parentNode.add_child(stock)
extends Node2D

export(Array, PackedScene) var blocks
export(NodePath) var pathToHeldStocks
export(bool) var isZenMode : bool = false
onready var heldStocks : Node = get_node(pathToHeldStocks)
onready var textLabel : Label = $Label 
const STARTINGBLOCKCOUNT : int = 20
var bagOfBlocks : Array = []
var zenBlkCount : int = STARTINGBLOCKCOUNT


func _ready() -> void:
	if not isZenMode:
		EventManager.connect("tookStock", self, "replenishEmptyStocks")
		replenishEmptyStocks()
	else:
		EventManager.connect("tookStock", self, "decrementZenBlkCount")
		EventManager.connect("tookStock", self, "replenishEmptyStocksForZen")
		EventManager.connect("computedBlocksEarnedFromDeletingBlocks", self, "incrementZenBlkCount")
		updateTextLabelAboutBlkCount()
		replenishEmptyStocksForZen()


func replenishEmptyStocks() -> void:
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateStock(child)


func replenishEmptyStocksForZen() -> void:
	var replenishesLeft : int = zenBlkCount
	for child in get_children():
		if child is Position2D and child.get_child_count() > 0:
			replenishesLeft -= 1

	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			if replenishesLeft <= 0:
				print("Cannot replenish block")
				return
			replenishesLeft -= 1
			generateStock(child)


# func replenishEmptyStockBasedOnAddedZenBlockCount(addedCount : int) -> void:
# 	if not isZenMode: return
	
# 	var replenishesLeft : int = addedCount 	
# 	for child in get_children():
# 		if child is Position2D and child.get_child_count() == 0:
# 			if replenishesLeft <= 0:
# 				return
# 			replenishesLeft -= 1
# 			generateStock(child)


func generateStock(parentNode : Node) -> void:
	# var i : int = generateRandonIndexForStock()
	if bagOfBlocks.empty():
		bagOfBlocks = generateBagOfBlocks()

	var i : int = bagOfBlocks.pop_front()
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


func generateBagOfBlocks() -> Array:
	var bag = []
	for i in range(7):
		bag.append(i)
	randomize()
	bag.shuffle()
	print("Generated new bag: {bag}".format({"bag": bag}))
	return bag


func decrementZenBlkCount() -> void:
	if isZenMode:
		zenBlkCount -= 1
		zenBlkCount = int(max(zenBlkCount, 0))
		updateTextLabelAboutBlkCount()


func incrementZenBlkCount(toAdd : int) -> void:
	if isZenMode:
		zenBlkCount += toAdd
		zenBlkCount = int(max(zenBlkCount, 0))
		updateTextLabelAboutBlkCount()
		replenishEmptyStocksForZen()


func updateTextLabelAboutBlkCount() -> void:
	textLabel.text = "{zenBlkCount} LEFT TO TAKE".format({"zenBlkCount": zenBlkCount})

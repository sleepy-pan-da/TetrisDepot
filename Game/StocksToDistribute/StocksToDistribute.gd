extends Node2D

export(PackedScene) var speechBubble
# key -> stockType, val -> qty
var pool = {
	"IBlock": 0, 
	"JBlock": 0,
	"LBlock": 0,
	"OBlock": 0,
	"SBlock": 0,
	"TBlock": 0,
	"ZBlock": 0
}


func _ready() -> void:
	EventManager.connect("updatedSpeechBubble", self, "updatePool")
	initPool()
	replenishSpeechBubbles()
	EventManager.emit_signal("readyStocksToDistribute")


func updatePool(updatedSpeechBubbleSuccessfully : bool) -> void:
	if not updatedSpeechBubbleSuccessfully: return
	
	print("hi")
	# find a stockType that is 0
	for key in pool:
		if pool[key] == 0:
			pool[key] += 1
			print(pool)
			return
	var blockTypes = pool.keys()
	var key : String = blockTypes[randi()%len(blockTypes)]
	pool[key] += 1
	print(pool)



func initPool() -> void:
	randomize()
	for key in pool:
		pool[key] = 3 #randi()%3 + 1 
	print(pool)


func replenishSpeechBubbles() -> void:
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateSpeechBubble(child)


func generateSpeechBubble(parentNode : Node) -> void:
	var newSpeechBubble : Node = speechBubble.instance()
	if not newSpeechBubble.has_method("generateBlockIcon"):
		newSpeechBubble.queue_free()
		print("Error generating speechbubble in stocks to distribute")
		return
	
	parentNode.add_child(newSpeechBubble)
	var dic = returnRandomBlockAndCountFromPool(2)
	for key in dic:
		newSpeechBubble.generateBlockIcon(key, dic[key])
		# update the pool
		pool[key] -= dic[key]
		EventManager.emit_signal("subtractedFromStocksToDistributePool", key, dic[key])


# Returns dictionary of blockType(key) and count(val)
func returnRandomBlockAndCountFromPool(numOfUniqueBlocks : int) -> Dictionary:
	randomize()
	
	var res = {} 
	while res.size() < numOfUniqueBlocks:
		var blockTypes = pool.keys()
		var blockType : String = blockTypes[randi() % blockTypes.size()]
		while pool[blockType] <= 1:
			blockType = blockTypes[randi() % blockTypes.size()]
		
		if blockType in res: continue
		var count = max(2, randi()%pool[blockType] + 1)
		res[blockType] = count
	return res

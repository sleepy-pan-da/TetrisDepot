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
	EventManager.connect("finishedSpeechBubble", self, "replenishSpeechBubbles")
	replenishSpeechBubbles()


func updatePool(updatedSpeechBubbleSuccessfully : bool, blockName : String) -> void:
	if not updatedSpeechBubbleSuccessfully: return
	pool[blockName] = max(0, pool[blockName]-1)
	print("updated stocksToDistributePool {str}".format({"str":pool}))


func replenishSpeechBubbles() -> void:
	for child in get_children():
		if child is Position2D and child.get_child_count() == 0:
			generateSpeechBubble(child)


# generated speechbubble's blocktypes are unique among speechbubbles
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
		pool[key] += dic[key]


# Returns dictionary of blockType(key) and count(val)
func returnRandomBlockAndCountFromPool(numOfUniqueBlocks : int) -> Dictionary:
	randomize()
	
	var res = {} 
	while res.size() < numOfUniqueBlocks:
		var blockTypes = pool.keys()
		var blockType : String = blockTypes[randi() % blockTypes.size()]
		# we want unique blocktypes from the pool
		while pool[blockType] > 0 or blockType in res:
			blockType = blockTypes[randi() % blockTypes.size()]
		
		var count : int = randi()%2+1 
		res[blockType] = count
	return res

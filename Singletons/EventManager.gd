extends Node

# Event bus for distant nodes to communicate using signals.
# This is intended for cases where connecting the nodes directly creates more coupling
# or increases code complexity substantially.

# Instead of manually connecting signals, this globalscript acts as an interface to manage and pass signals 
# between different scenes. A sample use case would be the fishes. As fishes are randomly spawned,
# it will be a hassle to connect their signals to GameLevelTemplate everytime a new fish is spawned.
# This globalscript therefore helps solve this problem.


# connected from DragAndDrop.gd to StocksToTake.gd
signal tookStock() 

# connected from SpeechBubble.gd to DragAndDrop.gd
signal droppedBlockIntoSpeechBubble(blockName) 

# connected from SpeechBubble.gd to DragAndDrop.gd
# connected from SpeechBubble.gd to StocksToDistribute.gd
# status -> boolean to indicate whether block is dropped successfully
signal updatedSpeechBubble(status)

# connected from StocksToDistribute.gd to StocksToTake.gd
signal subtractedFromStocksToDistributePool(blockType, amountSubtracted)
signal readyStocksToDistribute()
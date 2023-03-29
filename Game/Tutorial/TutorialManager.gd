extends Node2D


onready var stocksToTake : Node2D = $TutorialStocksToTake
onready var instructions : Control = $CanvasLayer2/Instructions
onready var selectDraw : Node2D = $SelectDraw
onready var endButton : Button = $CanvasLayer2/EndButton
export(String) var pathToMainMenu 


func _ready() -> void:
	stocksToTake.connect("takenAllStocks", instructions, "updateInstruction")
	selectDraw.connect("deletedBlocksForTutorial", instructions, "updateInstruction")
	instructions.connect("toSpawnNewWaveOfBlocks", stocksToTake, "spawnNextWaveOfBlocks")
	instructions.connect("endOfTutorial", self, "updateButtonText")


func updateButtonText() -> void:
	endButton.text = "END TUTORIAL"


func _on_Button_pressed() -> void:
	get_tree().change_scene(pathToMainMenu)
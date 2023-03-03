extends Control

onready var timeLabel : Node = $VBoxContainer/Time
onready var scoreLabel : Node = $VBoxContainer/Score
var curScore : int = 0
	
	
func _ready() -> void:
	resetStats()
	timeLabel.reset()
	EventManager.connect("computedScoreEarnedFromDeletingBlocks", self, "addScore")


func resetStats() -> void:
	curScore = 0
	scoreLabel.updateLabel(curScore)


func addScore(additionalScore : int) -> void:
	curScore += additionalScore
	scoreLabel.updateLabel(curScore)

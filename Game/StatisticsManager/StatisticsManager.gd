extends Control

onready var timeLabel : Node = $VBoxContainer/Time
onready var scoreLabel : Node = $VBoxContainer/Score
var curScore : int = 0
	
	
func _ready() -> void:
	reset()
	EventManager.connect("computedScoreEarnedFromDeletingBlocks", self, "addScore")


func reset() -> void:
	curScore = 0
	scoreLabel.updateLabel(curScore)
	timeLabel.reset()


func addScore(additionalScore : int) -> void:
	curScore += additionalScore
	scoreLabel.updateLabel(curScore)

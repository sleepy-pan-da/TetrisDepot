extends Control

onready var timeLabel : Label = $VBoxContainer/Time
onready var scoreLabel : Label = $VBoxContainer/Score
var curScore : int = 0
	
	
func _ready() -> void:
	reset()
	EventManager.connect("computedScoreEarnedFromDeletingBlocks", self, "addScore")


func reset() -> void:
	curScore = 0
	scoreLabel.updateLabel(curScore)
	if timeLabel.visible: # it will be hidden for zen mode
		timeLabel.reset()


func addScore(additionalScore : int) -> void:
	curScore += additionalScore
	scoreLabel.updateLabel(curScore)

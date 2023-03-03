extends Label

onready var timer : Timer = $Timer
const INITIAL_TIME_LEFT_IN_SECONDS : int = 300
var curTimeLeftInSec : int = 0


func _ready() -> void:
	EventManager.connect("computedTimeEarnedFromDeletingBlocks", self, "addTimeLeft")


func reset() -> void:
	curTimeLeftInSec = INITIAL_TIME_LEFT_IN_SECONDS
	updateLabel()
	timer.start()


func addTimeLeft(additionalTime : int) -> void:
	curTimeLeftInSec += additionalTime
	updateLabel()
	timer.start()


func updateLabel() -> void:
	text = "TIME LEFT: " + str(curTimeLeftInSec) + "s"


func _on_Timer_timeout() -> void:
	curTimeLeftInSec -= 1
	updateLabel()
	if curTimeLeftInSec > 0: timer.start()
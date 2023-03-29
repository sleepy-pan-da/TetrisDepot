extends Label

onready var timer : Timer = $Timer
const INITIAL_TIME_LEFT_IN_SECONDS : int = 180
var curTimeLeftInSec : int = 0


func _ready() -> void:
	EventManager.connect("computedTimeEarnedFromDeletingBlocks", self, "addTimeLeft")


func reset() -> void:
	curTimeLeftInSec = INITIAL_TIME_LEFT_IN_SECONDS
	updateLabel()
	timer.start()
	AudioManager.changeTempoOfMusic(1)


func addTimeLeft(additionalTime : int) -> void:
	curTimeLeftInSec += additionalTime
	if curTimeLeftInSec > 120:
		AudioManager.changeTempoOfMusic(1)
	elif curTimeLeftInSec > 60 and curTimeLeftInSec <= 120:
		AudioManager.changeTempoOfMusic(1.1)
	elif curTimeLeftInSec > 45 and curTimeLeftInSec <= 60:
		AudioManager.changeTempoOfMusic(1.2)
	elif curTimeLeftInSec > 30 and curTimeLeftInSec <= 45:
		AudioManager.changeTempoOfMusic(1.3)
	elif curTimeLeftInSec > 15 and curTimeLeftInSec <= 30:
		AudioManager.changeTempoOfMusic(1.4)
	else:
		AudioManager.changeTempoOfMusic(1.5)
	updateLabel()
	timer.start()


func updateLabel() -> void:
	text = "TIME LEFT: " + str(curTimeLeftInSec) + "s"


func _on_Timer_timeout() -> void:
	curTimeLeftInSec -= 1
	updateLabel()
	if curTimeLeftInSec > 0:
		match curTimeLeftInSec:
			120:
				AudioManager.changeTempoOfMusic(1.1)
			60:
				AudioManager.changeTempoOfMusic(1.2)
			45:
				AudioManager.changeTempoOfMusic(1.3)
			30:
				AudioManager.changeTempoOfMusic(1.4)
			15:
				AudioManager.changeTempoOfMusic(1.5)
		timer.start()
	else: EventManager.emit_signal("gameOver")
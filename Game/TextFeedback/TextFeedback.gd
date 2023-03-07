extends Label

onready var tween : Tween = $"Tween"


func setText(score : int, time: int) -> void:
	text = "+{score}pts\n+{time}s".format({"score": score, "time": time})


func popUp() -> void:
	tween.interpolate_property(self, "rect_scale", Vector2(0,0), Vector2(1,1), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_completed(_object, key):
	if key == ":rect_scale":
		fadeOut()
	else:
		queue_free()


func fadeOut() -> void:
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
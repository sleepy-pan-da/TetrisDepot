extends Node2D

onready var vfx : Particles2D = $Particles2D


func _ready() -> void:
	print("generated vfx")
	makeUnique()
	vfx.emitting = true
	vfx.one_shot = true


func makeUnique() -> void:
	vfx.process_material = vfx.process_material.duplicate()
 

func setColour(color : Color) -> void:
	vfx.process_material.color = color


func _on_Timer_timeout() -> void:
	queue_free()

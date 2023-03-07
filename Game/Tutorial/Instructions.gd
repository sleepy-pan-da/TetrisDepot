extends Control

export(Array, String, MULTILINE) var instructions
onready var label : Label = $Label
var i : int = 0
signal toSpawnNewWaveOfBlocks

func _ready() -> void:
	updateLabel(instructions[0])


func updateInstruction() -> void:
	i += 1
	if i >= len(instructions): return
	updateLabel(instructions[i])

	if i == 2: emit_signal("toSpawnNewWaveOfBlocks")



func updateLabel(newString : String) -> void:
	label.text = newString


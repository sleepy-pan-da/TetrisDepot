extends Control

onready var masterSlider : HSlider = $Volumes/Master/MasterSlider
onready var musicSlider : HSlider = $Volumes/Music/MusicSlider
onready var sfxSlider : HSlider = $Volumes/Sfx/SfxSlider

signal pressedBack

func _ready() -> void:
	updateSettingFields()


func updateSettingFields() -> void:
	masterSlider.value = db2linear(AudioManager.getMasterBusVolumeDb())
	musicSlider.value = db2linear(AudioManager.getMusicBusVolumeDb())
	sfxSlider.value = db2linear(AudioManager.getSfxBusVolumeDb())


func _on_Back_pressed() -> void:
	emit_signal("pressedBack")
	hide()


func _on_MasterSlider_value_changed(value : float) -> void:
	# print("Master:{val}".format({"val": value}))
	AudioManager.setMasterBusVolumeDb(linear2db(value))


func _on_MusicSlider_value_changed(value : float) -> void:
	# print("Music:{val}".format({"val": value}))
	AudioManager.setMusicBusVolumeDb(linear2db(value))


func _on_SfxSlider_value_changed(value : float) -> void:
	# print("Sfx:{val}".format({"val": value}))
	AudioManager.setSfxBusVolumeDb(linear2db(value))


func _on_CRTCheckBox_toggled(toggleState : bool) -> void:
	print("Crt:{state}".format({"state": toggleState}))
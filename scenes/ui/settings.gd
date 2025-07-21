extends Control
@onready var music_check: CheckBox = $MusicCheckBox
@onready var back_btn:     Button   = $HBoxContainer/BackButton
@onready var save_btn:     Button   = $HBoxContainer/SaveButton

func _ready() -> void:
	# Show the current value when we arrive
	music_check.button_pressed = SettingsStore.enable_music

	back_btn.pressed.connect(_go_back)
	save_btn.pressed.connect(_save_and_back)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _save_and_back() -> void:
	SettingsStore.enable_music = music_check.button_pressed
	if !SettingsStore.enable_music:
		Music.stop()
	get_tree().change_scene_to_file("res://scenes/title.tscn")

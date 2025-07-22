extends Control

@onready var godot_label: Label = $VBoxContainer/GodotLabel
@onready var exit_btn:     Button   = $VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/ExitButton

const HAND_SMALL_POINT = preload("res://PlaceholderAssets/hand_small_point.svg")

func _ready() -> void:
	# connect the exit btn
	exit_btn.pressed.connect(_on_exit_button_pressed)

	# show the godot version
	var version = Engine.get_version_info()
	godot_label.text = "Godot v " + str(version.major) + "." + str(version.minor) + "." + str(version.patch)

	# if music is enabled and not playing, play the title song
	if SettingsStore.enable_music && !Music.playing:
		Music.stream = preload("res://assets/music/title--fade-out--2025-07-07.ogg")
		Music.play()
		
	Input.set_custom_mouse_cursor(HAND_SMALL_POINT, 0, Vector2(10, 10))	

func _on_play_button_pressed():

	# if music is enabled and playing, stop it
	if SettingsStore.enable_music && Music.playing:
		Music.stop()

	# change to the game scene
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_settings_button_pressed():

	# change to the settings scene
	get_tree().change_scene_to_file("res://scenes/utility/settings.tscn")


func _on_exit_button_pressed() -> void:

	# exit the game
	get_tree().quit()

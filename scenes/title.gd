extends Control

@onready var godot_label: Label = $VBoxContainer/GodotLabel

func _ready() -> void:

	# show the godot version
	var version = Engine.get_version_info()
	godot_label.text = "Godot v " + str(version.major) + "." + str(version.minor) + "." + str(version.patch)

	# if music is enabled and not playing, play the title song
	if SettingsStore.enable_music && !Music.playing:
		Music.stream = preload("res://assets/music/title--fade-out--2025-07-07.ogg")
		Music.play()

func _on_play_button_pressed():

	# if music is enabled and playing, stop it
	if SettingsStore.enable_music && Music.playing:
		Music.stop()

	# change to the game scene
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_settings_button_pressed():

	# change to the settings scene
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

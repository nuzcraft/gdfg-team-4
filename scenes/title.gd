extends Control

@onready var godot_label: Label = $VBoxContainer/GodotLabel

func _ready() -> void:
	var version = Engine.get_version_info()
	godot_label.text = "Godot v " + str(version.major) + "." + str(version.minor) + "." + str(version.patch)


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/prototype_01.tscn")

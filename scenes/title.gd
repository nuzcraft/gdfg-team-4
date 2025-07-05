extends Control

@onready var godot_label: Label = $VBoxContainer/GodotLabel

func _ready() -> void:
	var version = Engine.get_version_info()
	godot_label.text = "Godot v " + str(version.major) + "." + str(version.minor) + "." + str(version.patch)

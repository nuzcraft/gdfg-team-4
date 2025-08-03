extends Control

@onready var TitleScreenButton: Button = $MarginContainer/VBoxContainer/TitleScreenButton
@onready var RestartButton: Button = $MarginContainer/VBoxContainer/RestartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/BugsKilledLabel.text = str(Globals.enemies_killed)
	$MarginContainer/VBoxContainer/HBoxContainer2/CrystalsCollectedLabel.text = str(Globals.crystals_collected)
	$MarginContainer/VBoxContainer/HBoxContainer3/LevelNumberLabel.text = str(Globals.current_level)


func _on_title_screen_button_pressed():
	get_tree().change_scene_to_file("res://scenes/utility/title.tscn")


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

extends Control

@onready var Crystals := $TextPopUp/VBoxContainer/Info/GemsCount/Value
@onready var Level := $TextPopUp/VBoxContainer/Info/CurrentLevel/Value

func _ready():
	Crystals.text = str(Globals.crystals_collected - Globals.crystals_spent)
	@onready var Level.text = 



func _on_title_screen_button_pressed():
	get_tree().change_scene_to_file("res://scenes/utility/title.tscn")


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

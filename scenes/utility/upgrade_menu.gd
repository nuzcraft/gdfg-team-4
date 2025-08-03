extends Control

func _ready():
	$TextPopUp/VBoxContainer/Info/CrystalsCount/Value.text = str(Globals.crystals_collected - Globals.crystals_spent)
	$TextPopUp/VBoxContainer/Info/CurrentLevel/Value.text = str(Globals.current_level)


func _on_continue_button_pressed() -> void:
	print('pause')
	hide()
	get_tree().paused = false

extends Node2D
class_name Level

const TARGET_ROUND_B = preload("res://PlaceholderAssets/target_round_b.svg")
const MAX_LEVELS = 3

var lava_aoe_scene = preload("res://scenes/aoes/lava_aoe.tscn")

func _ready() -> void:
	Input.set_custom_mouse_cursor(TARGET_ROUND_B, 0, Vector2(30, 30))
	for enemy in $Enemies.get_children():
		if enemy is LavaAnt:
			enemy.target = $Hero
			enemy.connect("lava_aoe", _on_lava_ant_lava_aoe)
	Globals.player_health = 100
	Globals.player_max_health = 100
	Globals.player_armor = 0
	Globals.player_max_armor = 100

func _process(_delta):
	if (_enemy_wave_cleared()):
		_next_level()
		queue_free()

func create_lava_aoe(pos):
	var aoe = lava_aoe_scene.instantiate() as Area2D
	aoe.position = pos
	aoe.is_in_group("FireArea")
	$AOEs.add_child(aoe)

func _on_lava_ant_lava_aoe(pos):
	create_lava_aoe(pos)

func _enemy_wave_cleared() -> bool:
	var enemies = $Enemies.get_children()
	if enemies.size() == 0:
		return true
	else:
		return false

func _next_level():
	var scene_name: String = str(get_tree().current_scene.name)
	var scene_file: String = str(get_tree().current_scene.scene_file_path)
	var regex = RegEx.new()
	regex.compile("Level(\\d+)")
	var name_result = regex.search(scene_name)
	regex.compile("res://scenes/levels/level(\\d+).tscn")
	var file_result = regex.search(scene_file)
	if name_result and file_result:
		var num := int(name_result.get_string(1))
		if num < MAX_LEVELS:
			var file_num := int(file_result.get_string(1))
			if num == file_num:
				var next_level := "res://scenes/levels/level" + str(num + 1) + ".tscn"
				print("Switching to: ", next_level)
				get_tree().change_scene_to_file(next_level)
			else:
				push_error("Level name does not match file name")
		else:
			print("Game over")
			get_tree().change_scene_to_file('res://scenes/title.tscn')
	else:
		push_error("Level name didn't match expected pattern.")
	

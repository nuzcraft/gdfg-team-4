extends Node
class_name Splitting

@export var split_scale_factor: float = 0.5
@export var smallest_scale_factor: float = 0.5 
@export var spawn_offset: float = 20.0

var tracked_enemies: Array[CharacterBody2D] = []

func _ready() -> void:
	for enemy in get_children():
		tracked_enemies.append(enemy)
		enemy.tree_exiting.connect(_on_enemy_exiting.bind(enemy))

func _process(delta: float) -> void:
	if get_children().size() == 0:
		queue_free()

func _on_enemy_exiting(enemy: CharacterBody2D):
	tracked_enemies.erase(enemy)
	_spawn_smaller_enemies(enemy)

func _spawn_smaller_enemies(old_enemy: CharacterBody2D) -> void:
	if old_enemy.scaling <= smallest_scale_factor:
		return
	else:
		var new_enemy_scene := load(old_enemy.get_scene_file_path())
		for i in range(2):
			var new_enemy = new_enemy_scene.instantiate()
			# set spawn position
			var use_spawn_offset: float
			if i == 0:
				use_spawn_offset = spawn_offset
			else:
				use_spawn_offset = -spawn_offset
			use_spawn_offset *= old_enemy.scaling
			new_enemy.position.y = old_enemy.position.y
			new_enemy.position.x = old_enemy.position.x + use_spawn_offset
			# set scaling
			new_enemy.scaling = old_enemy.scaling * split_scale_factor
			# set target
			new_enemy.target = old_enemy.target
			# create enemy
			add_child.call_deferred(new_enemy)
			new_enemy.tree_exiting.connect(_on_enemy_exiting.bind(new_enemy))
			tracked_enemies.append(new_enemy)
			#connect aoe signals
			if new_enemy.has_signal("lava_aoe"):
				get_parent().connect("lava_aoe", Callable(get_parent(), "_on_lava_ant_lava_aoe"))
				new_enemy.connect("lava_aoe", Callable(get_parent(), "_on_lava_ant_lava_aoe"))

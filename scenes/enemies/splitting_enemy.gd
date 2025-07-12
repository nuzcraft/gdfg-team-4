extends Node

@export var split_scale_factor: float = 0.5
@export var smallest_scale_factor: float = 0.25
@export var spawn_offset: float = 10.0

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
	_spawn_smaller_enemies(
		enemy.get_scene_file_path(), enemy.scaling, enemy.position, enemy.target
	)

func _spawn_smaller_enemies(scene:String, scaling: float, position: Vector2, target: Node2D) -> void:
	if scaling <= smallest_scale_factor:
		return
	else:
		var new_enemy_scene := load(scene)
		for i in range(2):
			var new_enemy = new_enemy_scene.instantiate()
			var use_spawn_offset: float
			if i == 0:
				use_spawn_offset = spawn_offset
			else:
				use_spawn_offset = -spawn_offset
			use_spawn_offset *= scaling
			new_enemy.position.x = position.x + use_spawn_offset
			new_enemy.scaling = scaling * split_scale_factor
			new_enemy.target = target
			add_child.call_deferred(new_enemy)
			tracked_enemies.append(new_enemy)

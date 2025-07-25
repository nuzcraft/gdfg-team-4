extends Node2D
class_name Spawner

@export var spawn_scene: PackedScene
@export var min_spawn: int = 2
@export var max_spawn: int = 4
@export var max_distance: int = 100

const ACID_SLUG = preload("res://scenes/enemies/acid_slug.tscn")
const ICE_BEETLE = preload("res://scenes/enemies/ice_beetle.tscn")
const LAVA_ANT = preload("res://scenes/enemies/lava_ant.tscn")
const SPLITTING_ENEMY = preload("res://scenes/enemies/splitting_enemy.tscn")

func _ready() -> void:
	var r = randf()
	if r < 0.3:
		spawn_scene = LAVA_ANT
	elif r < 0.6:
		spawn_scene = ACID_SLUG
	elif r < 0.9:
		spawn_scene = ICE_BEETLE
	else:
		spawn_scene = LAVA_ANT
		#TODO fix splitting enemy spawner
		#spawn_scene = SPLITTING_ENEMY
		#min_spawn = 1
		#max_spawn = 1
			
func spawn():
	var scene = spawn_scene.instantiate()
	if scene is Splitting:
		var r = randf()
		if r < 0.33:
			scene.add_child(LAVA_ANT.instantiate())
			scene.add_child(LAVA_ANT.instantiate())
			scene.add_child(LAVA_ANT.instantiate())
		elif r < 0.66:
			scene.add_child(ACID_SLUG.instantiate())
			scene.add_child(ACID_SLUG.instantiate())
			scene.add_child(ACID_SLUG.instantiate())
		else:
			scene.add_child(ICE_BEETLE.instantiate())
			scene.add_child(ICE_BEETLE.instantiate())
			scene.add_child(ICE_BEETLE.instantiate())
	return scene

extends Node
class_name Weapon

@export var speed_curve : Curve
@export var speed := 1000.0
@export var total_ttl := 2.0
@export var cooldown := 0.5
@export var projectile_image: Texture2D
@export var collision_shape: Shape2D
@export var offset: Vector2
@export var damage:= 10

var in_cooldown := false
var projectile_scene: PackedScene

func _ready():
	projectile_scene = preload("res://scenes/projectile.tscn")

func fire(position, direction):
	if in_cooldown:
		return

	var projectile = projectile_scene.instantiate()
	projectile.position = position + offset.rotated(get_parent().get_rotation())
	projectile.direction = direction
	projectile.weapon = self
	get_tree().get_root().add_child(projectile)

	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false

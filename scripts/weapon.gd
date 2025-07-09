extends Node2D
class_name Weapon

@export var speed_curve : Curve
@export var speed := 1000.0
@export var total_ttl := 1.0
@export var cooldown := 0.5
@export var damage:= 10

var in_cooldown := false
const projectile_scene := preload("res://scenes/projectile.tscn")

func aim_at(direction):
	var angle = rad_to_deg(direction.angle())
	if direction.x < 0.0:
		rotation_degrees = 180 - angle
	else:
		rotation_degrees = angle

	z_index = -1 if (direction.y < 0.0) else 0

func fire(position, direction):
	if in_cooldown:
		return

	var projectile = projectile_scene.instantiate()
	projectile.position = $NozzleOffset.global_position
	projectile.direction = direction
	projectile.weapon = self
	get_tree().get_root().add_child(projectile)

	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false

extends Node2D
class_name Weapon

@export var speed_curve : Curve
@export var speed := 1000.0
@export var total_ttl := 1.0
@export var cooldown := 0.5
@export var damage:= 10
@export var from_enemy := false

var in_cooldown := false
const projectile_scene := preload("res://scenes/weapons/projectile.tscn")

func aim_at(direction):
	var angle = rad_to_deg(direction.angle())
	if direction.x < 0.0:
		$Sprite2D.flip_v = true
		$NozzleOffset.position.y = 24
		#rotation_degrees = 180 - angle
	else:
		$Sprite2D.flip_v = false
		$NozzleOffset.position.y = -24.0
	rotation_degrees = angle

	z_index = -1 if (direction.y < 0.0) else 0

func fire(direction):
	if in_cooldown:
		return
	
	var projectile = projectile_scene.instantiate()
	projectile.position = $NozzleOffset.global_position
	projectile.direction = direction
	
	projectile.weapon = _create_weapon_data()
	get_tree().get_root().add_child(projectile)
	Globals.add_screenshake(0.1)
	
	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false

func _create_weapon_data() -> WeaponData:
	var weapon_data = WeaponData.new()
	weapon_data.speed_curve = speed_curve 
	weapon_data.speed = speed 
	weapon_data.total_ttl = total_ttl 
	weapon_data.cooldown = cooldown 
	weapon_data.damage = damage
	weapon_data.from_enemy = from_enemy
	weapon_data.projectile_texture = get_node("ProjectileType/Sprite2D").texture
	weapon_data.projectile_shape = get_node("ProjectileType/CollisionShape2D").shape
	return weapon_data

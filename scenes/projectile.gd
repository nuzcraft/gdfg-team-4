extends Area2D
class_name Projectile

var weapon: WeaponData
var ttl := 0.0
var direction: Vector2

var projectile: Texture2D
var collision_shape: Shape2D

func _ready():
	rotate(direction.angle())
	
	ttl = weapon.total_ttl
	$Sprite.texture = weapon.projectile_texture
	$CollisionShape.shape = weapon.projectile_shape
	
func _physics_process(delta):
	if !is_inside_tree():
		queue_free()
	else:
		ttl = ttl - delta
		if ttl <= 0.0:
			queue_free()
		else:
			var speed_factor := weapon.speed_curve.sample_baked(ttl/weapon.total_ttl) * weapon.speed
			position = position + speed_factor * delta * direction
			$Sprite.modulate = Color(1,1,1,sqrt(ttl/weapon.total_ttl))

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(weapon.damage)
	queue_free()

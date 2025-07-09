extends Area2D
class_name Projectile

var weapon: Weapon
var ttl := 0.0
var direction: Vector2

func _ready():
	rotate(direction.angle())
	
	ttl = weapon.total_ttl
	$Sprite.texture = weapon.projectile_image
	$CollisionShape.shape = weapon.collision_shape
	
func _physics_process(delta):
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

extends Area2D
class_name Projectile

var weapon: Weapon
var ttl := 0.0
var direction: Vector2

var projectile: Texture2D
var collision_shape: Shape2D

func _ready():
	rotate(direction.angle())
	
	ttl = weapon.total_ttl
	$Sprite.texture = weapon.get_node("ProjectileType/Sprite2D").texture
	$CollisionShape.shape = weapon.get_node("ProjectileType/CollisionShape2D").shape
	
func _physics_process(delta):
	ttl = ttl - delta
	if ttl <= 0.0 or !is_inside_tree() or !weapon.is_inside_tree():
		queue_free()
	else:
		var speed_factor := weapon.speed_curve.sample_baked(ttl/weapon.total_ttl) * weapon.speed
		position = position + speed_factor * delta * direction
		$Sprite.modulate = Color(1,1,1,sqrt(ttl/weapon.total_ttl))

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(weapon.damage)
	queue_free()

extends Area2D
class_name Projectile

var weapon: Weapon
var ttl := 0.0
var direction: Vector2

func _ready():
	#TODO: This rotation is wrong
	look_at(direction)
	
	ttl = weapon.total_ttl
	$Sprite.texture = weapon.projectile
	
func _physics_process(delta):
	ttl = ttl - delta
	if ttl <= 0.0:
		queue_free()
	else:
		var speed_factor := weapon.speed_curve.sample_baked(ttl/weapon.total_ttl) * weapon.speed
		position = position + speed_factor * delta * direction

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(weapon.damage)
		queue_free()

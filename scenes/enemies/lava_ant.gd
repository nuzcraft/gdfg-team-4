extends CharacterBody2D
class_name LavaAnt

signal lava_aoe

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: int = 300
var vulnerable: bool = true
var player_near: bool = false
var health: int = 20

func _ready() -> void:
	animated_sprite_2d.play("default")

func hit(damage):
	if vulnerable:
		animation_player.play("hit")
		vulnerable = false
		$HitTimer.start()
		health -= damage
	if health <= 0:
		explode()

func _process(delta):
	if player_near:
		speed = 200
	else :
		speed = 300
	if health <= 0 or (animation_player.current_animation == 'primed' and animation_player.is_playing()):
		speed = 0
	var direction = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	move_and_slide()


func _on_attack_area_2d_body_entered(body):
	if body.name == "Hero":
		player_near = true
		$ExplodeTimer.start()
		animation_player.play("primed")

func _on_attack_area_2d_body_exited(_body):
	player_near =  false

func explode():
	animation_player.play("RESET")
	animated_sprite_2d.play("explode")

func _on_explode_timer_timeout():
	if player_near:
		explode()

func summon_lava_aoe():
	lava_aoe.emit(position)
	print("sent lava signal")

func _on_hit_timer_timeout():
	vulnerable = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explode":
		summon_lava_aoe()
		queue_free()

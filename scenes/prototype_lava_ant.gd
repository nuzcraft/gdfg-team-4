extends CharacterBody2D

var speed: int = 300
var vulnerable: bool = true
var player_near: bool = false

var health = 20

signal lava_aoe

func hit():
	if vulnerable:
		vulnerable = false
		$HitTimer.start()
		health -= 10
	if health <= 0:
		summon_lava_aoe()
		await  get_tree().create_timer(0.4).timeout
		queue_free()

func _process(delta):
	if player_near:
		speed = 200
	else :
		speed = 300
	var direction = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	move_and_slide()


func _on_attack_area_2d_body_entered(body):
	player_near = true
	$ExplodeTimer.start()
	print(body)


func _on_attack_area_2d_body_exited(_body):
	player_near =  false

func explode():
	summon_lava_aoe()
	await  get_tree().create_timer(0.4).timeout
	queue_free()


func _on_explode_timer_timeout():
	if player_near:
		explode()

func summon_lava_aoe():
	lava_aoe.emit(position)
	print("sent lava signal")

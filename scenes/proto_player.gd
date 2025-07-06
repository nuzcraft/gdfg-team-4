extends CharacterBody2D

var can_shoot: bool = true
var can_melee: bool = true


@export var max_speed: int =500
var speed: int = max_speed

func _process(_delta):
	#input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	look_at(get_global_mouse_position())
	var playerDirection = (get_global_mouse_position() - position).normalized()
	
	#Range attack input
	#if Input.is_action_pressed("primaryAction") and can_shoot:
	#	pass
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass

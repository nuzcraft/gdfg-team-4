extends CharacterBody2D

var can_shoot: bool = true
var can_melee: bool = true


@export var max_speed: int =500
var speed: int = max_speed

@export var max_health: int = 100
var health: int = max_health

@export var primary_weapon: Weapon

signal lava_aoe

var facing = 1.0

func _process(_delta):
	#input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position

	# Player faces the same direction as the weapon
	var mouse_direction = (get_global_mouse_position() - position).normalized()
	primary_weapon.aim_at(mouse_direction)
	
	if sign(mouse_direction.x) != facing:
		scale.x = -scale.x
		facing = -facing
	
	#Range attack input
	if Input.is_action_pressed("primaryAction") and can_shoot:
		primary_weapon.fire(global_position, mouse_direction)
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass

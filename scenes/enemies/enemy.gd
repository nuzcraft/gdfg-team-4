extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var target: Node2D
@export var scaling: float = 1

@export var idle_speed: int = 100
@export var pursuit_speed: int = 300
var speed: int = 0
var vulnerable: bool = true
var player_near: bool = false
@export var health: int = 10
var target_pos: Vector2
var home_pos: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var can_shoot: bool = true

var weapon: Weapon
var shot_timer: Timer

enum {
	IDLE,
	SHOOTING,
	PURSUIT,
	DEAD
}
var state = IDLE

func _ready() -> void:
	rng.randomize()
	animated_sprite_2d.play("default")
	for child in get_children():
		if child is Weapon:
			weapon = child
			shot_timer = $ShotTimer
	# scaling
	scale = Vector2(scaling, scaling)
	idle_speed += ((1 - scaling) * 2) * idle_speed
	pursuit_speed += ((1 - scaling) * 1.5) * pursuit_speed
	if scaling > 0.75:
		health *= 3
	elif scaling > 0.5:
		health *= 2
	switch_state(IDLE)

func hit(damage):
	if vulnerable:
		animation_player.play("RESET")
		animation_player.play("hit")
		vulnerable = false
		$HitTimer.start()
		health -= damage
		switch_state(PURSUIT)
	if health <= 0:
		switch_state(DEAD)



func _process(_delta):
	match state:
		PURSUIT:
			target_pos = target.position
		SHOOTING:
			if can_shoot:
				target_pos = target.position
				var _target_dir = (target_pos - position).normalized()
				weapon.fire(_target_dir)
				can_shoot = false
				shot_timer.start()

func _physics_process(_delta: float) -> void:
	if target_pos:
		navigation_agent_2d.target_position = target_pos
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = position.direction_to(next_path_position)
	if animated_sprite_2d.animation == 'default':
		if direction.x >= 0.25:
			animated_sprite_2d.flip_h = true
		elif direction.x <= -0.25:
			animated_sprite_2d.flip_h = false
		if direction.y >= 0.1:
			animated_sprite_2d.frame = 0
		elif direction.y <= -0.25:
			animated_sprite_2d.frame = 1
	
	velocity = direction * speed
	move_and_slide()


func _on_attack_area_2d_body_entered(body):
	if body.name == "Hero":
		switch_state(PURSUIT)
		player_near = true

func _on_attack_area_2d_body_exited(_body):
	player_near =  false

func _on_hit_timer_timeout():
	vulnerable = true
		
func switch_state(state_enum) -> void:
	match state_enum:
		IDLE:
			state = IDLE
			animation_player.play("RESET")
			home_pos = position
			target_pos = Vector2(rng.randf() * 500, rng.randf() * 500) + home_pos
			speed = idle_speed
		SHOOTING:
			state = SHOOTING
		PURSUIT:
			state = PURSUIT
			speed = pursuit_speed
		DEAD:
			state = DEAD
			speed = 0
			queue_free()
			
func _on_navigation_agent_2d_target_reached() -> void:
	match state:
		IDLE:
			target_pos = Vector2(rng.randf() * 500, rng.randf() * 500) + home_pos

func _on_shot_timer_timeout():
	can_shoot = true
	

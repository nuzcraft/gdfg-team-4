extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var target: Node2D
@export var scaling: float = 1

@export var idle_speed: int = 100
@export var pursuit_speed: int = 300
var collision_tilemap: TileMapLayer
var speed: int = 0
var vulnerable: bool = true
var player_near: bool = false
@export var health: int = 10
#var target_pos: Vector2
var navigating: bool
var home_pos: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var attacking: bool = false
var melee_damage: int = 1

@onready var ray: RayCast2D = $RayCast2D

enum {
	IDLE,
	PURSUIT,
	DEAD
}
var state = IDLE

func _ready() -> void:
	rng.randomize()
	scaling = randf_range(0.5, 2.0)
	animated_sprite_2d.play("default")
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
			navigation_agent_2d.target_position = target.position
			navigating = true

var melee_count = 0
func _physics_process(_delta: float) -> void:
	if navigating:
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
		
	if not attacking:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is Hero:
				attacking = true
				collider.hit(melee_damage)
	if attacking and melee_count < 60:
		melee_count += 1
	else:
		attacking = false
		melee_count = 0
		

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
			navigation_agent_2d.target_position = get_nearby_target_pos()
			navigating = true
			speed = idle_speed
		PURSUIT:
			state = PURSUIT
			speed = pursuit_speed
		DEAD:
			Globals.enemies_killed += 1
			state = DEAD
			speed = 0
			navigating = false
			queue_free()
			
func _on_navigation_agent_2d_target_reached() -> void:
	navigating = false
	match state:
		IDLE:
			navigation_agent_2d.target_position = get_nearby_target_pos()
			navigating = true
			
func get_nearby_target_pos(max_dist: int = 5) -> Vector2:
	if collision_tilemap:
		var tile_position: Vector2i = collision_tilemap.local_to_map(home_pos)
		var nearby_tile_positions: Array[Vector2i]
		for i in range(-3, 3):
			for j in range(-3, 3):
				nearby_tile_positions.append(tile_position + Vector2i(i, j))
		for k in nearby_tile_positions.size():
			var try_pos: Vector2i = nearby_tile_positions.pick_random()
			var tile_data: TileData = collision_tilemap.get_cell_tile_data(try_pos)
			if tile_data:
				var nav_pol: NavigationPolygon = tile_data.get_navigation_polygon(0)
				if nav_pol:
					return collision_tilemap.map_to_local(try_pos)
		return home_pos
	return home_pos

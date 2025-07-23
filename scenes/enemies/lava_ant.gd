extends Enemy
class_name LavaAnt

signal lava_aoe

# new states for lava ant
enum {
	PRIMED = 4
}

func _ready() -> void:
	super._ready()
	
func _on_attack_area_2d_body_entered(body):
	if body.name == "Hero":
		switch_state(PRIMED)
		player_near = true

func explode():
	animation_player.play("RESET")
	animated_sprite_2d.play("explode")
	Globals.add_screenshake(0.3)

func _on_explode_timer_timeout():
	if player_near:
		switch_state(DEAD)
	else:
		animation_player.play("RESET")
		switch_state(PURSUIT)

func summon_lava_aoe():
	lava_aoe.emit(position, scaling)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explode":
		summon_lava_aoe()
		queue_free()
		
func switch_state(state_enum) -> void:
	match state_enum:
		PRIMED:
			state = PRIMED
			speed = 0
			$ExplodeTimer.start()
			animation_player.play("primed")
		DEAD:
			state = DEAD
			speed = 0
			explode()
		_:
			super.switch_state(state_enum)
			
func _on_navigation_agent_2d_target_reached() -> void:
	match state:
		IDLE:
			target_pos = Vector2(rng.randf() * 500, rng.randf() * 500) + home_pos

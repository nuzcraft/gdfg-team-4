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
	for body in $AttackArea2D.get_overlapping_bodies():
		if body is Enemy:
			if body is not LavaAnt:
				body.hit(5)
		elif body is Hero:
			body.hit(5)

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
		Globals.signal_enemy_died(enemy_name, position, scaling)
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

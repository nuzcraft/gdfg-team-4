extends Enemy
class_name IceBeetle

var can_shoot: bool = true

var weapon: Weapon
var shot_timer: Timer

# new states for ice beetle
enum {
	SHOOTING = 4
}

func _ready() -> void:
	super._ready()
	weapon = $Weapon
	shot_timer = $ShotTimer

func _on_attack_area_2d_body_entered(body):
	if body is Hero:
		switch_state(SHOOTING)

func _on_attack_area_2d_body_exited(body):
	if body is Hero:
		switch_state(IDLE)

func _process(delta):
	match state:
		SHOOTING:
				if can_shoot:
					target_pos = target.position
					var _target_dir = (target_pos - position).normalized()
					weapon.fire(_target_dir)
					can_shoot = false
					shot_timer.start()
		_:
			super._process(delta)

func switch_state(state_enum) -> void:
	match state_enum:
		SHOOTING:
			state = SHOOTING
		_:
			super.switch_state(state_enum)

func _on_shot_timer_timeout():
	can_shoot = true

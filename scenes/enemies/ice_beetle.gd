extends Enemy
class_name IceBeetle

func _on_attack_area_2d_body_entered(body):
	if body is Hero:
		switch_state(SHOOTING)

func _on_attack_area_2d_body_exited(body):
	if body is Hero:
		switch_state(IDLE)

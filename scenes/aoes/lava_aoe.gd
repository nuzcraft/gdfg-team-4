extends Area2D

#<<<<<<< HEAD

enum burn_state{
	Start,
	Hold,
	End
}

func _ready():
	pass

func _on_body_entered(body):
	if body.has_method("burn"):
		body.burn(burn_state.Start)

func _on_body_exited(body):
	if body.has_method("burn"):
		body.burn(burn_state.End)
#=======


func _on_despawn_timer_timeout() -> void:
	queue_free()
#>>>>>>> 4ab65722292bb4a282e9a4cfa85b5278d2622ac5

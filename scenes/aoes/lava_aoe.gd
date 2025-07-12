extends Area2D


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

extends BaseAOE

<<<<<<< HEAD
func _ready():
	pass
=======
enum burn_state{
	Start,
	Hold,
	End
}

func _on_body_entered(body):
	if body.has_method("burn"):
		body.burn(burn_state.Start)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("burn"):
		body.burn(burn_state.End)
>>>>>>> origin/elija

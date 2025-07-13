extends Area2D

func _on_body_entered(body):
	if body.has_method("burn"):
		body.burn()
		await get_tree().create_timer(0.5).timeout
		body.burn()

func _on_despawn_timer_timeout() -> void:
	queue_free()

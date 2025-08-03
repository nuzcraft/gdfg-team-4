extends Node2D
class_name Portal

signal portal

func _ready():
	$DirectionalArrow.get_node('Sprite2D').self_modulate = Color(0,0,1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Hero:
		$Timer.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Hero:
		$Timer.stop()

func _on_timer_timeout() -> void:
	emit_signal('portal')

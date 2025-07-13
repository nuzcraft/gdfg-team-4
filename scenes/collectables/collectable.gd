extends Node2D
class_name Collectable

@export var type: String = "collectable"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Hero:
		collect()
		
func collect():
	# animation for collection
	Globals.collectable_collected(type)
	queue_free()

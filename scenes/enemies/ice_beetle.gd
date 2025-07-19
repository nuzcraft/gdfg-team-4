extends Enemy
class_name IceBeetle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _on_ice_timer_timeout() -> void:
	Globals.place_ice_aoe(position, scaling)
	$IceTimer.start()


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.

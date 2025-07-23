extends Enemy
class_name AcidSlug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _on_acid_timer_timeout() -> void:
	Globals.place_acid_aoe(position, scaling)
	$AcidTimer.start()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = 1.5*safe_velocity
	move_and_slide()

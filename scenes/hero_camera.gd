extends Camera2D

@export var follow_speed = 5.0  # Adjust for desired speed
@export var mouse_offset_scale = 0.5 # Adjust for desired effect
@export var max_offset = 200 # Limit distance from 

var target_position: Vector2
var starting_offset: Vector2
var shake: float = 0.0

func _ready():
	target_position = global_position
	starting_offset = offset

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var hero: Hero = get_parent()
	var home_position = hero.global_position + starting_offset
	var move_offset = (mouse_pos - home_position) * mouse_offset_scale
	target_position = home_position + move_offset
	var new_gp = floor(global_position.lerp(target_position, follow_speed * delta))
	if abs(move_offset.x) < max_offset:
		global_position.x = new_gp.x
	if abs(move_offset.y) < max_offset:
		global_position.y = new_gp.y
		
	if shake:
		shake = max(shake - 0.8 * delta, 0)
		screenshake()
		
func add_shake(amount: float) -> void:
	shake = min(shake + amount, 1.0)
		
func screenshake() -> void:
	var max_shake_offset := Vector2(50, 50)
	var power := 2
	var amount := pow(shake, power)
	offset.x = starting_offset.x + (max_shake_offset.x * amount * randi_range(-1, 1))
	offset.y = starting_offset.y + (max_shake_offset.y * amount * randi_range(-1, 1))

extends Node

var mouse_pos: Vector2
var sensitivity := 500.0			# pixels per second at full tilt
var deadzone := 0.15
var device_id := 0

#const AXIS_RIGHT_X := 3			# example: 3 for Xbox
#const AXIS_RIGHT_Y := 4			# example: 4 for Xbox

func _ready() -> void:
	mouse_pos = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	var axis_x := Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_X)
	var axis_y := Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_Y)

	var v := Vector2(axis_x, axis_y)
	if v.length() > deadzone:
		v = v.normalized()
		mouse_pos += v * sensitivity * delta
		mouse_pos = mouse_pos.clamp(Vector2.ZERO, get_viewport().get_visible_rect().size)
		Input.warp_mouse(mouse_pos)

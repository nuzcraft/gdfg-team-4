# HealthBar.gd
extends Control

const RED = Color(1,0,0)
const BLUE = Color(0,0,1)
@export var is_enemy: bool = false

@onready var bar: ProgressBar = $Bar

@export var max_health: int = 100:
	set(value):
		$Bar.max_value = value

var _health: int = max_health
@export var health: int = max_health:
	set(value):
		_health = clamp(value, 0, max_health)
		bar.value = _health


func _ready() -> void:
	bar.show_percentage = false
	bar.min_value = 0
	bar.max_value = max_health
	var sb = StyleBoxFlat.new()
	if is_enemy:
		sb.bg_color = RED
	else:
		sb.bg_color = BLUE
	bar.add_theme_stylebox_override('fill', sb)
	bar.value = _health

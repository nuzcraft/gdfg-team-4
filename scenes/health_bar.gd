# HealthBar.gd
extends Control

const RED = Color(1,0,0)
const BLUE = Color(0,0,1)
@export var is_player: bool = false:
	set(value):
		if value:
			sb.bg_color = BLUE
		else:
			sb.bg_color = RED

@onready var bar: ProgressBar = $Bar
var sb = StyleBoxFlat.new()

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
	sb.bg_color = RED
	bar.add_theme_stylebox_override('fill', sb)

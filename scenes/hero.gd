extends CharacterBody2D
class_name Hero

var can_shoot: bool = true
var can_melee: bool = true
var currently_in_lava: bool = false


@export var max_speed: int =500
var speed: int = max_speed


@export var primary_weapon: Weapon

var facing = 1.0
var shake: float = 0.0
var camera_base_offset: Vector2

func _ready():
	Globals.screenshake.connect(_on_screenshake)
	camera_base_offset = $Camera2D.offset

func _process(delta):
	#input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position

	# Player faces the same direction as the weapon
	var mouse_direction = (get_global_mouse_position() - position).normalized()
	primary_weapon.aim_at(mouse_direction)
	
	if sign(mouse_direction.x) != facing:
		scale.x = -scale.x
		facing = -facing
	
	#Range attack input
	if Input.is_action_just_pressed("primaryAction") and can_shoot:
		primary_weapon.fire(mouse_direction)
		Globals.add_screenshake(0.2)
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass
	if shake:
		shake = max(shake - 0.8 * delta, 0)
		screenshake()

func burn():
	Globals.player_health -= 5
	currently_in_lava = true
	$Label.text = "Burning"
	
func _on_screenshake(amount: float) -> void:
	shake = min(shake + amount, 1.0)
	
func screenshake() -> void:
	var max_offset := Vector2(50, 50)
	var power := 2
	var amount := pow(shake, power)
	print(amount)
	$Camera2D.offset.x = camera_base_offset.x + (max_offset.x * amount * randi_range(-1, 1))
	$Camera2D.offset.y = camera_base_offset.y + (max_offset.y * amount * randi_range(-1, 1))
	

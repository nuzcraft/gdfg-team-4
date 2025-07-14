extends CharacterBody2D
class_name Hero

var can_shoot: bool = true
var can_melee: bool = true
var currently_in_lava: bool = false
var alive: bool = true
var crystals_collected: int = 0


@export var max_speed: int =500
var speed: int = max_speed


@export var primary_weapon: Weapon

var facing = 1.0
var shake: float = 0.0
var camera_base_offset: Vector2

func _ready():
	Globals.screenshake.connect(_on_screenshake)
	camera_base_offset = $Camera2D.offset
	Globals.collected.connect(_on_collectable_collected)

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

#func burn():
	#Globals.player_health -= 5
	#currently_in_lava = true
	#$Label.text = "Burning"

func _on_screenshake(amount: float) -> void:
	shake = min(shake + amount, 1.0)
	
func screenshake() -> void:
	var max_offset := Vector2(50, 50)
	var power := 2
	var amount := pow(shake, power)
	$Camera2D.offset.x = camera_base_offset.x + (max_offset.x * amount * randi_range(-1, 1))
	$Camera2D.offset.y = camera_base_offset.y + (max_offset.y * amount * randi_range(-1, 1))
	
func _on_collectable_collected(type: String):
	if type == "crystal":
		crystals_collected += 1
		#print("num collected: ", crystals_collected)
		$Hud/HBoxContainer/CrystalLabel.text = str(crystals_collected)

func die():
	if alive:
		#print("Player died.")
		alive=false

func take_damage(n: int):
	if Globals.player_health<=n:
		die()
	else:
		Globals.player_health -= n
		#print("Player has "+str(Globals.player_health)+" health.")

var lava_pools: int = 0
var burn_count: int = 0
var is_in_lava: bool = false

enum burn_state{
	Start,
	Hold,
	End
}

func burn(input:burn_state):
	if(burn_state.Start&&!is_in_lava):
		$Label.text = "Burning"
		burn_count=0
		is_in_lava=true
		await get_tree().create_timer(0.1)
		burn(burn_state.Hold)
	if(burn_state.Hold&&is_in_lava):
		Globals.player_health -= 1
		await get_tree().create_timer(0.1)
		burn(burn_state.Hold)
	if(burn_state.Hold&&!is_in_lava&&burn_count>0):
		Globals.player_health -= 1
		burn_count -=1
		await get_tree().create_timer(0.1)
		burn(burn_state.Hold)
	if(burn_state.End):
		is_in_lava=false
		burn_count=10

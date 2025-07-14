extends CharacterBody2D
class_name Hero

var can_shoot: bool = true
var can_melee: bool = true
#<<<<<<< HEAD
var alive: bool = true
#=======
var crystals_collected: int = 0
#>>>>>>> 4ab65722292bb4a282e9a4cfa85b5278d2622ac5


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
	if shake:
		shake = max(shake - 0.8 * delta, 0)
		screenshake()
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass
#<<<<<<< HEAD
func die():
	if self.alive:
		#print("Player died.")
		self.alive=false

func take_damage(n: int):
	if Globals.player_health<=n:
		self.die()
	else:
		Globals.player_health -= n
		#print("Player has "+str(Globals.player_health)+" health.")

var lava_pools: int = 0
var burn_count: int = 0
enum call_state{
	Start,
	Hold,
	End
}
func burn(input:int):
	if(input==call_state.Start&&self.lava_pools<=0):
		$Label.text = "Burning"
		self.burn_count=0
		self.lava_pools+=1
		print("player is in "+str(self.lava_pools)+" lava pools")
		self.burn(call_state.Hold)
	elif(input==call_state.Start&&self.lava_pools>=1):
		self.lava_pools+=1
		print("player is in "+str(self.lava_pools)+" lava pools")
	elif (input==call_state.Hold&&self.lava_pools>=1):
		self.take_damage(1)
		await get_tree().create_timer(0.25).timeout
		self.burn(call_state.Hold)
	elif (input==call_state.Hold&&self.lava_pools<=0&&burn_count>=1):
		self.take_damage(1)
		self.burn_count-=1
		await get_tree().create_timer(0.25).timeout
		self.burn(call_state.Hold)
	elif(input==call_state.End):
		self.lava_pools-=1
		print("player is in "+str(self.lava_pools)+" lava pools")
		if lava_pools<=0:
			burn_count=10


	
func _on_screenshake(amount: float) -> void:
	shake = min(shake + amount, 0.5)
	
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

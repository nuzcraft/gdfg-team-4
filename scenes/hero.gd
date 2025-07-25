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

func _ready():
	Globals.screenshake.connect(_on_screenshake)
	Globals.collected.connect(_on_collectable_collected)

func _process(_delta):
	# Player faces the same direction as the weapon
	var mouse_direction = (get_global_mouse_position() - position).normalized()
	primary_weapon.aim_at(mouse_direction)
	
	if sign(mouse_direction.x) != facing:
		$Sprite2D.scale.x = -$Sprite2D.scale.x
		facing = -facing

func _physics_process(delta):
	#input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	var mouse_direction = (get_global_mouse_position() - position).normalized()
	#Range attack input
	if Input.is_action_just_pressed("primaryAction") and can_shoot:
		primary_weapon.fire(mouse_direction)
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass

func _on_screenshake(amount: float) -> void:
	$Camera2D.add_shake(amount)
	
func _on_collectable_collected(type: String):
	if type == "crystal":
		crystals_collected += 1
		#print("num collected: ", crystals_collected)
		$Hud/HBoxContainer/CrystalLabel.text = str(crystals_collected)

func die():
	if alive:
		#print("Player died.")
		alive=false

func hit(damage: int):
	if Globals.player_health<=damage:
		die()
	else:
		Globals.player_health -= damage
		#print("Player has "+str(Globals.player_health)+" health.")

var is_in_lava: bool = false
var is_in_acid: bool = false

enum call_state{
	Start,
	Hold,
	End
}

func burn(input:call_state):
	match input:
		call_state.Start:
			$Label.text = "Burning"
			is_in_lava=true
			burn(call_state.Hold)
		call_state.Hold:
			if is_in_lava:
				Globals.player_health -= 1
				await get_tree().create_timer(1.0).timeout
				burn(call_state.Hold)
		call_state.End:
			is_in_lava = false
			await damage_over_time(2, 5, 2.0, 'Burning')
			$Label.text = "Player"

func acidify(input: call_state):
	match input:
		call_state.Start:
			$Label.text = "Acidic"
			is_in_acid=true
			acidify(call_state.Hold)
		call_state.Hold:
			if is_in_acid:
				Globals.player_health -= 2
				await get_tree().create_timer(1.0).timeout
				acidify(call_state.Hold)
		call_state.End:
			is_in_acid = false
			$Label.text = "Player"
#
func damage_over_time(damage: int, num_hits: int, wait_time: float, effect: String):
	$Label.text = effect
	for i in num_hits:
		Globals.player_health -= damage
		await get_tree().create_timer(wait_time).timeout
	$Label.text = "Player"

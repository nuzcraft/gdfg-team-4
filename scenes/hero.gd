extends CharacterBody2D

var can_shoot: bool = true
var can_melee: bool = true


@export var max_speed: int =500
var speed: int = max_speed


@export var primary_weapon: Weapon

var facing = 1.0

func _process(_delta):
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
	if Input.is_action_pressed("primaryAction") and can_shoot:
		primary_weapon.fire(global_position, mouse_direction)
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass
var is_in_lava: bool = false
var burn_count: int = 0
enum burn_state{
	Start,
	Hold,
	End
}
func burn(input:burn_state):
	if(burn_state.Start&&!self.is_in_lava):
		$Label.text = "Burning"
		self.burn_count=0
		self.is_in_lava=true
		await get_tree().create_timer(0.1)
		self.burn(burn_state.Hold)
	if(burn_state.Hold&&self.is_in_lava):
		Globals.player_health -= 1
		await get_tree().create_timer(0.1)
		self.burn(burn_state.Hold)
	if(burn_state.Hold&&!self.is_in_lava&&self.burn_count>0):
		Globals.player_health -= 1
		self.burn_count -=1
		await get_tree().create_timer(0.1)
		self.burn(burn_state.Hold)
	if(burn_state.End):
		self.is_in_lava=false
		self.burn_count=10

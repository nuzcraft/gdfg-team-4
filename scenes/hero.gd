extends CharacterBody2D
class_name Hero

var can_shoot: bool = true
var can_melee: bool = true
var alive: bool = true


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
		primary_weapon.fire(mouse_direction)
	
	#Melee attack input
	#if Input.is_action_pressed("secondaryAction") and can_melee:
	#	pass
func die():
	if self.alive:
		print("Player died.")
		self.alive=false

func take_damage(n: int):
	if Globals.player_health<=n:
		self.die()
	else:
		Globals.player_health -= n
		print("Player has "+str(Globals.player_health)+" health.")

var lava_pools: int = 0
var burn_count: int = 0
enum burn_state{
	Start,
	Hold,
	End
}
func burn(input:int):
	if(input==burn_state.Start&&self.lava_pools<=0):
		$Label.text = "Burning"
		self.burn_count=0
		self.lava_pools+=1
		print("player is in "+str(self.lava_pools)+" lava pools")
		await get_tree().create_timer(0.25).timeout
		self.burn(burn_state.Hold)
	if(input==burn_state.Start&&self.lava_pools>=1):
		self.lava_pools+=1
		print("player is in "+str(self.lava_pools)+" lava pools")
	if(input==burn_state.Hold&&self.lava_pools>=1):
		self.take_damage(1)
		await get_tree().create_timer(0.25).timeout
		self.burn(burn_state.Hold)
	if(input==burn_state.Hold&&self.lava_pools<=0&&burn_count>=1):
		self.take_damage(1)
		self.burn_count-=1
		await get_tree().create_timer(0.25).timeout
		self.burn(burn_state.Hold)
	if(input==burn_state.End):
		self.lava_pools-=1
		print("player is in "+str(self.lava_pools)+" lava pools")
		if lava_pools<=0:
			burn_count=10

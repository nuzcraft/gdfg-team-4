extends CharacterBody2D
class_name Hero

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_shoot: bool = true
var can_melee: bool = true
var currently_in_lava: bool = false
var crystals_collected: int = 0
var teleporting: bool = false

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
	if teleporting:
		return
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
	if type == "armor":
		Globals.player_armor = Globals.player_max_armor

func die():
	get_tree().change_scene_to_file("res://scenes/utility/end_screen.tscn")

func hit(damage: int):
	if Globals.player_health<=damage:
		die()
	else:
		animation_player.play("hit")
		var cur_armor = Globals.player_armor
		if  cur_armor > damage:
			Globals.player_armor -= damage
		else:
			var remainder = damage - cur_armor
			Globals.player_armor = 0
			Globals.player_health -= damage

func teleport_in():
	teleporting = true
	_on_teleport('in')

func teleport_out():
	teleporting = true
	$PlasmaRifle.hide()
	$Label.hide()
	_on_teleport('out')

func _on_teleport(type):
	var start : float
	var end : float
	$Sprite2D.material.set_shader_parameter("flash_color", Color.WHITE)
	match type:
		'in':
			start = 1.0
			end = 0.0
		'out':
			start = 0.0
			end = 1.0
	var t = create_tween().tween_method(
		func(v):
			$Sprite2D.material.set_shader_parameter("progress", v),
		start,
		end,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	teleporting = false

var is_in_lava: bool = false
var is_in_acid: bool = false
var is_burning_after: bool = false

enum call_state{
	Start,
	Hold,
	End
}

func burn(input:call_state):
	match input:
		call_state.Start:
			if not is_in_lava:
				$Label.text = "Burning"
				is_in_lava=true
				burn(call_state.Hold)
		call_state.Hold:
			if is_in_lava and not is_in_acid:
				if Globals.player_health <= 1:
					die()
					return
				Globals.player_health -= 1
				animation_player.play("burning")
				await get_tree().create_timer(1.0).timeout
				burn(call_state.Hold)
		call_state.End:
			is_in_lava = false
			if not is_burning_after:
				is_burning_after = true
				await damage_over_time(2, 5, 2.0, 'Burning')
			$Label.text = "Player"

func acidify(input: call_state):
	match input:
		call_state.Start:
			if not is_in_acid:
				$Label.text = "Acidic"
				is_in_acid=true
				acidify(call_state.Hold)
		call_state.Hold:
			if is_in_acid and not is_in_lava:
				if Globals.player_health <= 2:
					die()
					return
				Globals.player_health -= 2
				animation_player.play("acidic")
				await get_tree().create_timer(1.0).timeout
				acidify(call_state.Hold)
		call_state.End:
			is_in_acid = false
			$Label.text = "Player"
#
func damage_over_time(damage: int, num_hits: int, wait_time: float, effect: String):
	$Label.text = effect
	for i in num_hits:
		if not is_in_lava:
			if Globals.player_health <= damage:
				die()
				return
			Globals.player_health -= damage
			if effect == "Burning":
				animation_player.play("burning")
			await get_tree().create_timer(wait_time).timeout
			if effect == "Burning":
				is_burning_after = false
	$Label.text = "Player"

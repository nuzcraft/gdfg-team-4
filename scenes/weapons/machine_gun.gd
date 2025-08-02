extends Weapon

func fire(direction):
	if in_cooldown:
		return
	
	var projectile = projectile_scene.instantiate()
	projectile.position = $NozzleOffset.global_position
	projectile.direction = direction
	
	projectile.weapon = _create_weapon_data()
	get_tree().get_root().add_child(projectile)
	Globals.add_screenshake(0.1)
	
	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false
	
	if Input.is_action_pressed("primaryAction"):
		fire((get_global_mouse_position() - global_position).normalized())

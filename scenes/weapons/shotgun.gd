extends Weapon

const rotate_amount: float = 10.0

func fire(direction):
	if in_cooldown:
		return
	
	var projectile1 = projectile_scene.instantiate()
	var projectile2 = projectile_scene.instantiate()
	var projectile3 = projectile_scene.instantiate()
	
	projectile1.position = $NozzleOffset.global_position
	projectile1.direction = direction
	projectile1.weapon = _create_weapon_data()
	
	projectile2.position = $NozzleOffset.global_position
	projectile2.direction = direction.rotated(deg_to_rad(rotate_amount))
	projectile2.weapon = _create_weapon_data()
	
	projectile3.position = $NozzleOffset.global_position
	projectile3.direction = direction.rotated(deg_to_rad(-rotate_amount))
	projectile3.weapon = _create_weapon_data()
	
	
	get_tree().get_root().add_child(projectile1)
	get_tree().get_root().add_child(projectile2)
	get_tree().get_root().add_child(projectile3)
	
	Globals.add_screenshake(0.1)
	
	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false

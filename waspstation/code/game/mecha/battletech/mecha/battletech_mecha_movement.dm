/obj/battletech/mecha/proc/play_stepsound()
	if(throttle < battletech.get_low_throttle_threshold(src))
		if(slowstep)
			playsound(src, slowstep, 40, 1)
	else
		if(stepsound)
			playsound(src, stepsound, 40, 1)

/obj/battletech/mecha/proc/play_twist_sound()
	if(torso_twist_sound)
		playsound(src, torso_twist_sound, 40, 1)

/obj/battletech/mecha/Process_Spacemove(var/space_move_dir = 0)
	. = ..()
	if(.)
		return TRUE

	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(movement_dir, 180)))
				step_silent = TRUE
				if(occupant)
					to_chat(occupant, "<span class='info'>You push off [backup] to propel yourself.</span>")
		return TRUE

	return FALSE

/obj/battletech/mecha/relaymove(mob/user, direction)
	if(powerplant.is_disabled())
		return
	if(!direction)
		return
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You climb out from [src].</span>")
		return 0
	if(internal_tank?.connected_port)
		if(world.time - last_error_message > 20)
			occupant_message("<span class='warning'>Unable to move while connected to the air system port!</span>")
			last_error_message = world.time
		return 0
	if(construction_state)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Maintenance protocols in effect.</span>")
			last_message = world.time
		return

	determine_movement_action(mob/user, direction)

/obj/battletech/mecha/determine_movement_action(mob/user, direction)
	var/move_angle = dir2angle(direction)
	var/dir_angle = dir2angle(movement_dir)
	var/delta = abs(dir_angle - move_angle)
	switch(delta)
		// Throttle up/down since it's the same axis of movement
		if(delta == 0)
			throttle_up()
		if(delta == 180)
			throttle_down()
		// Rotate left/right since it's the same axis of movement
		if(delta == 90)
			rotate_left()
		if(delta == 270)
			rotate_right()
		// Do both
		if(delta == 45)
			throttle_up()
			rotate_left()
		if(delta == 135)
			throttle_down()
			rotate_left()
		if(delta == 225)
			throttle_down()
			rotate_right()
		if(delta == 315)
			throttle_up()
			rotate_right()

/obj/battletech/mecha/movement_capable()
	if(powerplant.is_disabled())
		return FALSE
	if(!mech_chassis[BT_CHASSIS_LLEG] || !mech_chassis[BT_CHASSIS_RLEG])
		return FALSE
	if(mech_chassis[BT_CHASSIS_LLEG].is_disabled() || mech_chassis[BT_CHASSIS_RLEG].is_disabled())
		return FALSE
	return TRUE

/obj/battletech/mecha/can_rotate()
	return movement_capable()

/obj/battletech/mecha/can_manip_throttle()
	if(!movement_capable())
		throttle = 0
		return FALSE
	return TRUE

/obj/battletech/mecha/throttle_up()
	if(!can_manip_throttle())
		return
	if(throttle + throttle_increment_amount > powerplant.get_max_throttle())
		return
	throttle += throttle_increment_amount
	throttle_dirty = TRUE

/obj/battletech/mecha/throttle_down()
	if(!can_manip_throttle())
		return
	if(throttle - throttle_increment_amount > powerplant.get_min_throttle())
		return

	throttle -= throttle_increment_amount
	throttle_dirty = TRUE

/obj/battletech/mecha/rotation_on_cooldown(last_tick)
	var/cooldown = battletech.calculate_traverse_rate(src)
	if(world.time >= last_rotate_tick + cooldown)
		return TRUE
	else
		return FALSE

/obj/battletech/mecha/rotate(degrees)
	if(!can_rotate())
		return
	if(rotation_on_cooldown())
		return
	last_rotate_tick = world.time
	var/dir = angle2dir(dir2angle(movement_dir) + degrees)
	setDir(dir)
	if(turnsound)
		playsound(src, turnsound, 40, TRUE)

/obj/battletech/mecha/rotate_left()
	return rotate(90)

/obj/battletech/mecha/rotate_right()
	return rotate(-90)

/obj/battletech/mecha/Bump(var/atom/obstacle)
	if(..())
		return
	if(bumpsmash && pilot)
		if(control_config.group_fire)
			return //No Kirk double-punch for you!
		else
			if(control_config.equipment_selected())
				obstacle.mech_melee_attack(src)
				melee_last_hit = world.time
				if(!obstacle || obstacle.CanPass(src, get_step(src, movement_dir)))
					step(src, dir)
	else if(isobj(obstacle))
		var/obj/O = obstacle
		if(!O.anchored && O.move_resist <= move_force)
			step(obstacle, movement_dir)
	else if(ismob(obstacle))
		var/mob/M = obstacle
		if(M.move_resist <= move_force)
			step(obstacle, movement_dir)

/obj/battletech/mecha/process_movement()
	if(throttle_dirty)
		movement_tickrate = battletech.calculate_movement_speed(src)
		throttle_dirty = FALSE
	if(world.time > movement_tickrate + movement_last_tick)
		. = step(src, movement_dir)
		if(. && !step_silent)
			play_stepsound()
		step_silent = FALSE
	else
		return

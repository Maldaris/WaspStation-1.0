/obj/battletech/mecha/proc/play_stepsound()
	if(src.throttle < BT_RUN_THRESHOLD)
		if(src.slowstep)
			playsound(src, src.slowstep, 40, 1)
	else
		if(stepsound)
			playsound(src, src.stepsound, 40, 1)

/obj/battletech/mecha/proc/play_twist_sound()
	if(torso_twist_sound)
		playsound(src, torso_twist_sound, 40, 1)

/obj/battletech/mecha/proc/play_sprint_transition(up = TRUE)
	playsound(src, up ? sprint_transition_up : sprint_transition_down, 40)

/obj/battletech/mecha/Process_Spacemove(var/space_move_dir = 0)
	. = ..()
	if(.)
		return TRUE

	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(movement_dir, 180)))
				step_silent = TRUE
				if(pilot)
					to_chat(pilot, "<span class='info'>You push off [backup] to propel yourself.</span>")
		return TRUE

	return FALSE

/obj/battletech/mecha/relaymove(mob/user, direction)
	if(!movement_capable())
		return
	if(!direction)
		return
	if(user != pilot) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You climb out from [src].</span>")
		return 0
	if(internal_tank?.connected_port)
		if(world.time - last_error_message > 20)
			occupant_message("<span class='warning'>Unable to move while connected to the air system port!</span>")
			last_error_message = world.time
		return 0
	if(maintenance_state != MECHA_LOCKED)
		if(world.time - last_error_message > 20)
			occupant_message("<span class='danger'>Maintenance protocols in effect.</span>")
			last_error_message = world.time
		return

	return determine_movement_action(user, direction)

/obj/battletech/mecha/proc/determine_movement_action(mob/user, direction)
	var/move_angle = dir2angle(direction)
	var/dir_angle = dir2angle(movement_dir)
	var/delta = abs(dir_angle - move_angle)
	switch(delta)
		// Throttle up/down since it's the same axis of movement
		if(0)
			throttle_up()
			return 1
		if(180)
			throttle_down()
			return 1
		// Rotate left/right since it's the same axis of movement
		if(90)
			rotate_left()
			return 1
		if(270)
			rotate_right()
			return 1
		// Do both
		if(45)
			throttle_up()
			rotate_left()
			return 1
		if(135)
			throttle_down()
			rotate_left()
			return 1
		if(225)
			throttle_down()
			rotate_right()
			return 1
		if(315)
			throttle_up()
			rotate_right()
			return 1
	return 0

/obj/battletech/mecha/proc/movement_capable()
	if(powerplant.is_disabled())
		return FALSE
	if(!mech_chassis[BT_CHASSIS_LLEG] || !mech_chassis[BT_CHASSIS_RLEG])
		return FALSE
	if(mech_chassis[BT_CHASSIS_LLEG].is_disabled() || mech_chassis[BT_CHASSIS_RLEG].is_disabled())
		return FALSE
	return TRUE

/obj/battletech/mecha/proc/can_rotate()
	return movement_capable()

/obj/battletech/mecha/proc/can_manip_throttle()
	if(!movement_capable())
		throttle = 0
		return FALSE
	return TRUE

/obj/battletech/mecha/proc/throttle_up()
	if(!can_manip_throttle())
		return
	if(throttle + throttle_increment_amount > powerplant.get_max_throttle())
		throttle = powerplant.get_max_throttle()
		throttle_dirty = TRUE
		return
	if(throttle + throttle_increment_amount > 50 && throttle <= 50)
		play_sprint_transition(TRUE)
	throttle += throttle_increment_amount
	throttle_dirty = TRUE

/obj/battletech/mecha/proc/throttle_down()
	if(!can_manip_throttle())
		return
	if(throttle - throttle_increment_amount > powerplant.get_min_throttle())
		throttle = powerplant.get_min_throttle()
		throttle_dirty = TRUE
		return
	if(throttle - throttle_increment_amount <= 50 && throttle > 50)
		src.play_sprint_transition(FALSE)
	throttle -= throttle_increment_amount
	throttle_dirty = TRUE

/obj/battletech/mecha/proc/rotation_on_cooldown(last_tick)
	var/cooldown = GLOB.battletech.calculate_traverse_rate(src)
	if(world.time >= last_rotate_tick + cooldown)
		return TRUE
	else
		return FALSE

/obj/battletech/mecha/proc/rotate(degrees)
	if(!can_rotate())
		return
	if(rotation_on_cooldown())
		return
	last_rotate_tick = world.time
	var/dir = angle2dir(dir2angle(movement_dir) + degrees)
	setDir(dir)
	if(turnsound)
		playsound(src, turnsound, 40, TRUE)

/obj/battletech/mecha/proc/rotate_left()
	return rotate(45)

/obj/battletech/mecha/proc/rotate_right()
	return rotate(-45)

/obj/battletech/mecha/Bump(var/atom/obstacle)
	if(..())
		return
	if(bumpsmash && pilot)
		if(control_config.group_fire)
			return //No Kirk double-punch for you!
		else
			if(control_config.equipment_selected())
				obstacle.mech_melee_attack(src)

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
#define bt_diagonal_move_macro(dir) (dir & (dir - 1))
/obj/battletech/mecha/proc/process_movement()
	if(!movement_capable())
		return
	if(throttle > 0 && !powerplant.is_shutdown())
		var/true_throttle = throttle
		if(powerplant.is_overloaded())
			true_throttle = min(10, throttle)
			throttle_dirty = TRUE
		if(mech_chassis[BT_CHASSIS_LLEG].is_disabled())
			true_throttle = max(10, true_throttle / 2)
			throttle_dirty = TRUE
		if(mech_chassis[BT_CHASSIS_RLEG].is_disabled())
			true_throttle = max(10, true_throttle / 2)
			throttle_dirty = TRUE
		if(throttle_dirty)
			movement_tickrate = GLOB.battletech.calculate_movement_speed(src)
			throttle_dirty = FALSE
		if(world.time >= (movement_tickrate * bt_diagonal_move_macro(movement_dir) ? 1.41421356237 : 1) + movement_last_tick)
			step(src, movement_dir)
			if(!step_silent)
				src.play_stepsound()
			movement_last_tick = world.time
#undef bt_diagonal_move_macro

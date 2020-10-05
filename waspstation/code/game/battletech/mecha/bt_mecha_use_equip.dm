/obj/battletech/mecha/proc/click_action(atom/target, mob/user, params)
	if(!pilot || pilot != user)
		return
	if(!locate(/turf) in list(target,target.loc)) // Prevents inventory from being drilled
		return
	if(is_currently_ejecting)
		return
	if(user.incapacitated())
		return
	if(maintenance_state)
		occupant_message("<span class='warning'>Maintenance protocols in effect.</span>")
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	var/fov = get_bt_mech_fov(src)
	var/obj/battletech/chassis/head/mech_head = mech_chassis[BT_CHASSIS_HEAD]
	if(!(dir_to_target in fov))
		return
	if(!mech_head)
		//no headless chickenwalkers here
		return
	else if(mech_head.internal_damage & MECHA_INT_CONTROL_LOST)
		if(!target)
			return
		target = pick(view(3, target))

	if(!Adjacent(target) && control_config.equipment_selected())
		if(control_config.group_fire)
			if(control_config.all_ranged())
				if(control_config.action(target, params))
					control_config.start_cooldown()
				return
			else
				to_chat(user, "<span class='warning'>Warning: Selected group cannot be fired at range, one or more equipment selected is not ranged.</span>")
				return
		else
			if(control_config.single_ranged())
				if(control_config.action(target, params))
					control_config.start_cooldown()
					control_config.cycle_to_next()
				return
			else
				to_chat(user, "<span class='notice'>Warning: Selected equipment cannot be fired at range, cycling to next.</span>")
				control_config.cycle_to_next()
				return
	else if(control_config.equipment_selected())
		if(control_config.group_fire)
			if(control_config.action(target, params))
				control_config.start_cooldown()
			return
		else
			if(control_config.action(target, params))
				control_config.start_cooldown()
				control_config.cycle_to_next()
			return
	else
		if(mech_head.internal_damage & MECHA_INT_CONTROL_LOST)
			var/list/possible_targets = oview(1, src)
			if(!length(possible_targets))
				return
			target = pick(possible_targets)
		var/obj/battletech/mecha/target_mech = target
		if(target_mech && isbtmech(target_mech))
			if(target_mech.mecha_class <= src.mecha_class)
				target_mech.bt_mech_melee_kick(src)
				melee_on_cooldown = TRUE
				addtimer(VARSET_CALLBACK(src, melee_on_cooldown, FALSE), melee_cooldown_duration)
				return
			else
				to_chat(user, "<span class='notice'>Warning: Target mecha outclasses yours. Target's myomer reflex will withstand any melee attack.")
				return
// returns a list of valid directions based on the movement direction and torso twist angle
/obj/battletech/mecha/proc/get_bt_mech_fov(obj/battletech/mecha/mech)
	var/dir = mech.movement_dir
	var source_angle = dir2angle(dir) + mech.torso_twist_angle
	return list(
		angle2dir(source_angle - mech.field_of_view[0]),
		angle2dir(source_angle),
		angle2dir(source_angle + mech.field_of_view[1])
	)

/obj/battletech/mecha/proc/range_action(atom/target)
	return

/obj/battletech/mecha/onMouseMove(object,location,control,params)
	if(!pilot || !pilot.client || pilot.incapacitated())
		return // I don't know what's going on.
	//TODO inhand check for control joystick

	var/list/params_list = params2list(params)
	var/sl_list = splittext(params_list["screen-loc"],",")
	var/sl_x_list = splittext(sl_list[1], ":")
	var/sl_y_list = splittext(sl_list[2], ":")
	var/view_list = isnum(pilot.client.view) ? list("[pilot.client.view*2+1]","[pilot.client.view*2+1]") : splittext(pilot.client.view, "x")
	var/dx = text2num(sl_x_list[1]) + (text2num(sl_x_list[2]) / world.icon_size) - 1 - text2num(view_list[1]) / 2
	var/dy = text2num(sl_y_list[1]) + (text2num(sl_y_list[2]) / world.icon_size) - 1 - text2num(view_list[2]) / 2
	if(sqrt(dx*dx+dy*dy) > 1)
		torso_twist_desired_angle = 90 - ATAN2(dx, dy)
	else
		torso_twist_desired_angle = null

/obj/battletech/mecha/proc/bt_mech_melee_kick(obj/battletech/mecha/attacking_mech)
	return

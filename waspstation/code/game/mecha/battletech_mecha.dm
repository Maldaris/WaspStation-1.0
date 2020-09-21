

/obj/battletech/mecha
	name = "mecha"
	desc = "Battletech Mecha"
	icon = 'icons/mecha/mecha.dmi'
	density = TRUE
	opacity = 1
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	layer = BELOW_MOB_LAYER
	infra_luminosity = 15
	force = 5
	flags_1 = HEAR_1

	// Defines powerplants and base stat ceilings
	var/mecha_class = BT_MECH_LIGHT

	//if the mecha starts on a ruin, don't automatically give it a tracking beacon to prevent metagaming.
	var/ruin_mecha = FALSE

	var/mob/living/carbon/pilot = null

	// Powerplant of the mech defining movement tickrate
	// Powergrid output, and other statistics
	var/obj/battletech/engine/powerplant = null
	//Scalar multiplier on powerplant.max_velocity used to compute actual movement tickrate
	var/throttle = 0

	// Scalar clamped angle between -90 and 90
	// used to compute hit detection and true view cone angle
	var/torso_twist_angle = 0
	// Rate per second of torso twist rotation
	var/torso_twist_traverse_rate = 15
	var/field_of_view = list(-90, 90)

	var/movement_dir = 2
	//listof /obj/battletech/chassis
	var/list/mech_chassis = list(
		"head" = null, "c_torso" = null, "l_torso" = null, "r_torso" = null,
		"l_leg" = null, "r_leg" = null, "l_arm" = null, "r_arm" = null
	)

	var/datum/battletech/control_scheme/control_config
	var/list/selected_equipment

	// Bitflags: BT_MECHA_UNPOWERED, BT_MECHA_EMP, BT_MECHA_SHUTDOWN, BT_MECHA_POWERPLANT_HACKED
	var/shutdown_state = 0

	var/maintenance_state = MECHA_LOCKED

	// Bitchin' Betty, status narrator
	var/datum/battletech/betty/bitchin_betty

	var/melee_cooldown_duration = 10
	var/melee_on_cooldown = FALSE

	var/list/proc_res = list()
	var/datum/effect_system/spark_spread/spark_system = new

	var/lights = FALSE
	var/lights_power = 6

	//Atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port = null

	var/obj/item/radio/mech/radio
	var/list/trackers = list()

	// Initialized by construction, using heatsink count/thermal rating.
	var/max_temperature = 0

	var/wreckage

	//Used for disabling mech step sounds while using thrusters or pushing off lockers
	var/step_silent = FALSE
	var/stepsound = 'sound/mecha/mechstep.ogg'
	var/slowstep = 'sound/mecha/mechstep.ogg'
	var/turnsound = 'sound/mecha/mechturn.ogg'
	var/torso_twist_sound = 'sound/mecha/mechturn.ogg'

	var/enter_delay = 40
	var/exit_delay = 20
	var/destruction_sleep_duration = 20
	var/enclosed = TRUE // Rarely will this ever not be true
	var/silicon_icon_state = null
	var/is_currently_ejecting = FALSE

	var/datum/action/innate/battletech/mecha/mech_eject/eject_action = new
	var/datum/action/innate/battletech/mecha/mech_toggle_internals/internals_action = new
	var/datum/action/innate/battletech/mecha/mech_fire_mode_toggle/fire_mode_toggle = new
	var/datum/action/innate/battletech/mecha/mech_weapon_type_cycle/weapon_type_cycle = new
	var/datum/action/innate/battletech/mecha/mech_open_configuration/open_configuration = new
	var/datum/action/innate/battletech/mecha/mech_overheat_shutdown/overheat_shutdown = new
	var/datum/action/innate/battletech/mecha/mech_override_overheat_shutdown/overheat_shutdown_override = new
	var/datum/action/innate/battletech/mecha/mech_toggle_jump_jets/toggle_jump_jets = new

	var/pilot_sight_flags = 0
	var/mouse_pointer

	hud_possible = list(DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD)

/obj/battletech/mecha/Initialize()
	. = ..()
	events = new
	icon_state += "-open"
	add_radio()
	add_cabin()
	if (enclosed)
		add_airtank()
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	smoke_system.set_up(3, src)
	smoke_system.attach(src)
	START_PROCESSING(SSobj, src)
	GLOB.poi_list |= src
	log_message("[src.name] created.", LOG_MECHA)
	GLOB.bt_mechas_list += src
	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

/obj/battletech/mecha/Destroy()
	if(pilot)
		pilot.SetSleeping(destruction_sleep_duration)
	go_out()
	var/mob/living/silicon/ai/AI
	for(var/mob/M in src)
		if(isAI(M))
			pilot = null
			AI = M
		else
			M.forceMove(loc)
	for(var/obj/battletech/chassis/section in mech_chassis)
		section.detach_equipment(loc)
		qdel(section)
	if(powerplant)
		qdel(powerplant)
	if(AI)
		AI.gib()
	STOP_PROCESSING(SSobj, src)
	GLOB.poi_list.Remove(src)
	if(loc)
		loc.assume_air(cabin_air)
		air_update_turf()
	else
		qdel(cabin_air)
	cabin_air = null
	qdel(spark_system)
	spark_system = null

	GLOB.bt_mechas_list -= src
	return ..()

/obj/battletech/mecha/update_icon_state()
	if(silicon_pilot && silicon_icon_state)
		icon_state = silicon_icon_state

/obj/battletech/mecha/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = TRUE

/obj/battletech/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.set_temperature(T20C)
	cabin_air.set_volume(200)
	cabin_air.set_moles(/datum/gas/oxygen, O2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))
	cabin_air.set_moles(/datum/gas/nitrogen, N2STANDARD*cabin_air.return_volume()/(R_IDEAL_GAS_EQUATION*cabin_air.return_temperature()))
	return cabin_air

/obj/battletech/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/battletech/mecha/CheckParts(list/parts_list)
	return powerplant.CheckParts()

/obj/battletech/mecha/proc/can_use(mob/user)
	if(user != pilot)
		return 0
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

/obj/mecha/examine(mob/user)

/obj/mecha/process()
	if(cabin_air && cabin_air.return_volume() > 0)
		var/delta = cabin_air.return_temperature() - T20C
		cabin_air.set_temperature(cabin_air.return_temperature() - max(-10, min(10, round(delta/4,0.1))))

	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.return_temperature() > 0)
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = return_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)

	if(pilot)
		powerplant.update_throttle_alerts()
		powerplant.update_powerplant_alerts()

		var/list/chassis_damage = list();
		for(var/c in mech_chassis)
			var/battletech/chassis/part = c
			if(part)
				if(part.state == BT_CHASSIS_DESTROYED)
					chassis_damage[part.type] = BT_CHASSIS_DESTROYED
				else if(part.state == BT_CHASSIS_PRISTINE)
					chassis_damage[part.type] = BT_CHASSIS_PRISTINE
				else
					chassis_damage[part.type] = BT_CHASSIS_DAMAGED
		update_chassis_alert(chassis_damage)

		var/atom/checking = pilot.loc
		// recursive check to handle all cases regarding very nested pilots,
		// such as brainmob inside brainitem inside MMI inside mecha
		while (!isnull(checking))
			if (isturf(checking))
				// hit a turf before hitting the mecha, seems like they have
				// been moved out
				pilot.clear_alert("throttle")
				pilot.clear_alert("powerplant alerts")
				pilot.clear_alert("chassis doll")
				RemoveActions(pilot, human_pilot=1)
				pilot = null
				break
			else if (checking == src)
				break  // all good
			checking = checking.loc


	if(!enclosed && pilot?.incapacitated())
		visible_message("<span class='warning'>[pilot] tumbles out of the cockpit!</span>")
		go_out() //Maybe we should install seat belts?

	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

/obj/battletech/mecha/fire_act()
	. = ..()
	if (pilot && !enclosed && !silicon_pilot)
		if (pilot.fire_stacks < 5)
			pilot.fire_stacks++
		pilot.IgniteMob()

/obj/battletech/mecha/proc/drop_item()
	return

/obj/battletech/mecha/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	if(speaker == pilot)
		if(radio?.broadcasting)
			radio.talk_into(speaker, text, , spans, message_language)
		//flick speech bubble
		var/list/speech_bubble_recipients = list()
		for(var/mob/M in get_hearers_in_view(7,src))
			if(M.client)
				speech_bubble_recipients.Add(M.client)
		INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, image('icons/mob/talk.dmi', src, "machine[say_test(raw_message)]",MOB_LAYER+1), speech_bubble_recipients, 30)

/obj/battletech/mecha/proc/click_action(atom/target, mob/user, params)
	if(!pilot || pilot != user)
		return
	if(!locate(/turf) in list(target,target.loc)) // Prevents inventory from being drilled
		return
	if(is_currently_ejecting)
		return
	if(user.incapacitated())
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	var/fov = get_bt_mech_fov(src)
	if(!dir_to_target in visual_radius)
		return
	if(!mech_chassis["head"])
		//no headless chickenwalkers here
		return
	else if(mech_chassis["head"].internal_damage & MECHA_INT_CONTROL_LOST)
		if(!target)
			return
		target = pick(view(3, target))

	var/mob/living/L = user
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
		if(mech_chassis["head"].internal_damage & MECHA_INT_CONTROL_LOST)
			var/list/possible_targets = oview(1, src)
			if(!length(possible_targets))
				return
			target = pick(possible_targets)
		var/obj/battletech/mech/target_mech = target
		if(target_mech && isbtmech(target_mech))
			if(target_mech.class <= src.class)
				target.bt_mech_melee_kick(src)
				melee_on_cooldown = TRUE
				addtimer(VARSET_CALLBACK(src, melee_on_cooldown, FALSE), melee_cooldown_duration)
				return
			else
				to_chat(user, "<span class='notice'>Warning: Target mecha outclasses yours. Target's myomer reflex will withstand any melee attack.")
				return
		else
			target.bt_mech_melee_kick(src)
			melee_on_cooldown = TRUE
			addtimer(VARSET_CALLBACK(src, melee_on_cooldown, FALSE), melee_cooldown_duration)
			return

// returns a list of valid directions based on the movement direction and torso twist angle
/obj/battletech/mecha/proc/get_bt_mech_fov(obj/battletech/mecha/mech)
	var/dir = mech.movement_dir
	var source_angle = dir2angle(dir) + mech.torso_twist_angle
	return list(
		angle2dir(source_angle - mech.fov[0]),
		angle2dir(source_angle),
		angle2dir(source_angle + mech.fov[1])
	)

/obj/battletech/mecha/proc/range_action(atom/target)
	return

/obj/battletech/mecha/proc/play_stepsound()
	if(throttle < 20)
		if(slowstep)
			playsound(src, slowstep, 40, 1)
	else
		if(stepsound)
			playsound(src, stepsound, 40, 1)

/obj/battletech/mecha/proc/play_twist_sound()
	if(torso_twist_sound)
		playsound(src, torso_twist_sound, 40, 1)

/obj/battletech/mecha/Move(atom/newloc, direct)
	. = ..()
	if(.)
		events.fireEvent("onMove", get_turf(src))
	if(internal_tank?.disconnect())
		occupant_message("<span class='warning'>Air port connection has been severed!</span>")
		log_message("Lost connection to gas port.", LOG_MECHA)

/obj/battletech/mecha/Process_Spacemove(var/space_movement_dir = 0)
	. = ..()
	if(.)
		return TRUE

	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(space_movement_dir, 180)))
				step_silent = TRUE
				if(occupant)
					to_chat(occupant, "<span class='info'>You push off [backup] to propel yourself.</span>")
		return TRUE

	if(can_move <= world.time && active_thrusters && space_movement_dir && active_thrusters.thrust(space_movement_dir))
		step_silent = TRUE
		return TRUE

	return FALSE

/obj/battletech/mecha/relaymove(mob/user, direction)

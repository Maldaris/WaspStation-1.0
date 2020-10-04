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
	var/cur_tonnage = 0
	var/max_tonnage = 0

	//if the mecha starts on a ruin, don't automatically give it a tracking beacon to prevent metagaming.
	var/ruin_mecha = FALSE

	var/mob/living/carbon/pilot = null

	// Powerplant of the mech defining movement tickrate
	// Powergrid output, and other statistics
	var/obj/battletech/chassis/engine/powerplant = null

	//Scalar multiplier on powerplant.max_velocity used to compute actual movement tickrate
	var/throttle = 0
	var/throttle_increment_amount = 10
	var/throttle_dirty = FALSE
	var/sprinting = FALSE

	var/movement_tickrate = INFINITY
	var/movement_last_tick = 0

	var/last_rotate_tick = 0

	// Scalar clamped angle between -90 and 90
	// used to compute hit detection and true view cone angle
	var/torso_twist_angle = 0
	// Rate per second of torso twist rotation
	var/torso_twist_traverse_rate
	var/torso_twist_desired_angle = 0
	var/field_of_view = list(-90, 90)

	var/movement_dir = 2
	var/list/obj/battletech/chassis/mech_chassis = list(
		BT_CHASSIS_HEAD = null,
		BT_CHASSIS_CTORSO = null,
		BT_CHASSIS_LTORSO = null,
		BT_CHASSIS_RTORSO = null,
		BT_CHASSIS_LLEG = null,
		BT_CHASSIS_RLEG = null,
		BT_CHASSIS_LARM = null,
		BT_CHASSIS_RARM = null
	)

	var/datum/battletech/control_scheme/control_config
	// Bitflags: BT_MECHA_UNPOWERED, BT_MECHA_EMP, BT_MECHA_SHUTDOWN, BT_MECHA_POWERPLANT_HACKED
	var/shutdown_state = 0

	var/last_error_message = 0

	var/maintenance_state = MECHA_LOCKED

	var/melee_cooldown_duration = 10
	var/melee_on_cooldown = FALSE
	var/bumpsmash = FALSE

	var/list/proc_res = list()
	var/datum/effect_system/spark_spread/spark_system = new
	var/datum/effect_system/smoke_spread/smoke_system = new

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

	var/datum/events/events //Wasp - Readded for Smartwire Revert

	//Used for disabling mech step sounds while using thrusters or pushing off lockers
	var/step_silent = FALSE
	var/stepsound = 'sound/mecha/mechstep.ogg'
	var/slowstep = 'sound/mecha/mechstep.ogg'
	var/turnsound = 'sound/mecha/mechturn.ogg'
	var/torso_twist_sound = 'waspstation/sound/mecha/mechtwist.ogg'
	var/sprint_transition_up = 'waspstation/sound/mecha/sprint_transition_up.ogg'
	var/sprint_transition_down = 'waspstation/sound/mecha/sprint_transition_down.ogg'

	var/enter_delay = 40
	var/exit_delay = 20
	var/destruction_sleep_duration = 20
	var/enclosed = TRUE // Rarely will this ever not be true
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
	// for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
	// 	diag_hud.add_to_hud(src)
	// diag_hud_set_mechhealth()
	// diag_hud_set_mechcell()
	// diag_hud_set_mechstat()

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
	return

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
	powerplant.CheckParts()

/obj/battletech/mecha/proc/can_use(mob/user)
	if(user != pilot)
		return 0
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

/obj/battletech/mecha/examine(mob/user)

/obj/battletech/mecha/process()
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
		update_throttle_alerts()
		powerplant.update_powerplant_alerts()

		var/list/chassis_damage = list();
		for(var/c in mech_chassis)
			var/obj/battletech/chassis/part = c
			if(part)
				if(part.damage == BT_CHASSIS_DESTROYED)
					chassis_damage[part.slot] = BT_CHASSIS_DESTROYED
				else if(part.damage == BT_CHASSIS_PRISTINE)
					chassis_damage[part.slot] = BT_CHASSIS_PRISTINE
				else
					chassis_damage[part.slot] = BT_CHASSIS_DAMAGED
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

	// diag_hud_set_mechhealth()
	// diag_hud_set_mechcell()
	// diag_hud_set_mechstat()

	process_movement()

/obj/battletech/mecha/fire_act()
	. = ..()
	if (pilot && !enclosed)
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

/obj/battletech/mecha/proc/occupant_message(message as text)
	if(message)
		if(pilot && pilot.client)
			to_chat(pilot, "[icon2html(src, pilot)] [message]")

/obj/battletech/mecha/proc/go_out()
	return

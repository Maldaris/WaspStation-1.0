

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

	var/movement_dir = 2

	var/list/mech_chassis = list(
		"head" = null, "c_torso" = null, "l_torso" = null, "r_torso" = null,
		"l_leg" = null, "r_leg" = null, "l_arm" = null, "r_arm" = null
	)
	// Bitflags: BT_MECHA_UNPOWERED, BT_MECHA_EMP, BT_MECHA_SHUTDOWN, BT_MECHA_POWERPLANT_HACKED
	var/shutdown_state = 0

	var/maintenance_state = MECHA_LOCKED

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
	var/turnsound = 'sound/mecha/mechturn.ogg'

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
		powerplant.meltdown(src, loc)
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
	var/internal_temp_regulation = 1



	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

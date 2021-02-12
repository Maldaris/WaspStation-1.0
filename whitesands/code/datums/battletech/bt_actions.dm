/datum/action/innate/battletech
	icon_icon = 'whitesands/icons/mob/actions/battletech/actions.dmi'

/datum/action/innate/battletech/mecha
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUN | AB_CHECK_CONSCIOUS
	icon_icon = 'whitesands/icons/mob/actions/battletech/actions_mecha.dmi'
	var/obj/battletech/mecha/mech

/datum/action/innate/battletech/mecha/Grant(mob/living/L, obj/battletech/mecha/M)
	if(M)
		mech = M
	..()

/datum/action/innate/battletech/mecha/Destroy()
	mech = null
	return ..()

/datum/action/innate/battletech/mecha/mech_eject
	name = "Eject From Mech"
	button_icon_state = "mech_eject"

/datum/action/innate/battletech/mecha/mech_eject/Activate()
	if(!owner)
		return
	if(!mech || !mech.pilot != owner)
		return
	if(!mech.powerplant.is_shutdown())
		button_icon_state = "mech_eject_emergency-progress"
		GLOB.bt_bitchin_betty.play_sound(mech, "eject")
		GLOB.bt_bitchin_betty.play_sound(mech, "ejecting")
	else
		button_icon_state = "mech_eject-progress"
		GLOB.bt_bitchin_betty.play_sound(owner, "shutdown")
	mech.container_resist(mech.pilot)

/datum/action/innate/battletech/mecha/mech_eject/proc/refresh()
	if(!owner)
		return
	if(!mech || !mech.pilot != owner)
		return

	if(mech.powerplant.is_shutdown())
		button_icon_state = "mech_eject[mech.is_currently_ejecting ? "-progress" : ""]"
	else
		button_icon_state = "mech_eject[mech.is_currently_ejecting ? "-progress" : ""]"

/datum/action/innate/battletech/mecha/mech_toggle_internals
	name = "Toggle Internal Airtank Usage"
	button_icon_state = "mech_internals_off"

/datum/action/innate/battletech/mecha/mech_toggle_internals/Activate()
	if(!owner || !mech || mech.pilot != owner)
		return
	mech.use_internal_tank = !mech.use_internal_tank
	button_icon_state = "mech_internals_[mech.use_internal_tank ? "on" : "off"]"
	mech.occupant_message("<span class='notice'>Now taking air from [mech.use_internal_tank?"internal airtank":"environment"].</span>")
	mech.log_message("Now taking air from [mech.use_internal_tank?"internal airtank":"environment"].", LOG_MECHA)
	UpdateButtonIcon()

/datum/action/innate/battletech/mecha/mech_fire_mode_toggle
	name = "Toggle Fire Mode"
	button_icon_state = "mech_fire_mode_group"

/datum/action/innate/battletech/mecha/mech_fire_mode_toggle/Activate()
	if(!owner || !mech || mech.pilot != owner)
		return
	mech.control_config.group_fire = !mech.control_config.group_fire
	button_icon_state = "mech_fire_mode_[mech.control_config.group_fire ? "group" : "chain"]"
	GLOB.bt_bitchin_betty.play_sound(owner, "[mech.control_config.group_fire ? "group" : "chain"]_fire")
	UpdateButtonIcon()

/datum/action/innate/battletech/mecha/mech_weapon_type_cycle
	name = "Cycle Next Equipment"
	button_icon_state = "mech_cycle_next_equipment"

/datum/action/innate/battletech/mecha/mech_weapon_type_cycle/Activate()
	if(!owner || !mech || mech.pilot != owner)
		return
	mech.control_config.cycle_to_next()
	GLOB.bt_bitchin_betty.play_sound(owner, "button_press")

/datum/action/innate/battletech/mecha/mech_open_configuration

/datum/action/innate/battletech/mecha/mech_open_configuration/Activate()

/datum/action/innate/battletech/mecha/mech_shutdown
	name = "Shutdown"
	button_icon_state = "mech_shutdown"
/datum/action/innate/battletech/mecha/mech_override_overheat_shutdown
	name = "Toggle Shutdown Override"
	button_icon_state = "mech_shutdown_override"
/datum/action/innate/battletech/mecha/mech_toggle_jump_jets
	name = "Toggle Jump Jets"
	button_icon_state = "mech_toggle_jump_jets"

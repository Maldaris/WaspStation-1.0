/datum/action/innate/battletech
	icon_icon = 'waspstation/icons/mob/actions/battletech/actions.dmi'

/datum/action/innate/battletech/mecha
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUN | AB_CHECK_CONSCIOUS
	icon_icon = 'waspstation/icons/mob/actions/battletech/actions_mecha.dmi'
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
	mech.container_resist(mech.pilot)

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
/datum/action/innate/battletech/mecha/mech_weapon_type_cycle
/datum/action/innate/battletech/mecha/mech_open_configuration
/datum/action/innate/battletech/mecha/mech_shutdown
/datum/action/innate/battletech/mecha/mech_override_overheat_shutdown
/datum/action/innate/battletech/mecha/mech_toggle_jump_jets
	name = "Toggle Jump Jets"
	button_icon_state = "mech_toggle_jump_jets"

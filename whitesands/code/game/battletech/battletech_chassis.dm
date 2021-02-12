/obj/battletech/chassis
	name = "chassis component"
	desc = "A component used in the construction of a Battlemech"
	icon = 'whitesands/icons/obj/battletech/mecha.dmi'
	density = TRUE
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	layer = MOB_LAYER

	var/mecha_class = BT_MECH_LIGHT
	// Measured in tons
	var/weight = 1
	var/slot = null
	var/installed = FALSE
	var/installed_mech = null
	var/disabled = FALSE
	var/damage = BT_CHASSIS_PRISTINE
	var/datum/battletech/equipment/armor/armor_dat = new
	var/datum/battletech/equipment/structure/structure_dat = new
	var/mutable_appearance/appearance

/obj/battletech/chassis/New()
	appearance = mutable_appearance(src.icon_state, src.icon)

/obj/battletech/chassis/update_icon()
	if(!installed_mech)
		return FALSE
	if(!appearance)
		appearance = mutable_appearance(src.icon_state, src.icon)
		installed_mech.add_overlay(appearance)
	else if(src.icon_state !== appearance.icon_state || src.icon !== appearance.icon)
		intalled_mech.cut_overlay(appearance)
		appearance.icon = mutable_appearance(src.icon_state, src.icon)
		installed_mech.add_overlay(appearance)
	return TRUE

/obj/battletech/chassis/proc/is_disabled()
	return disabled

/obj/battletech/chassis/proc/on_mounted(mech)
	var/obj/battletech/mecha/M = mech
	if (!mech || istype(M))
		installed_mech = mech
	else
		return FALSE

	installed_mech.add_overlay(src.appearance)

/obj/battletech/chassis/proc/on_unmounted()
	if (!installed_mech || !istype(installed_mech))
		return TRUE
	else
		installed_mech.cut_overlay(src.appearance)

/obj/battletech/chassis/proc/detach_equipment(equip)
	return

/obj/battletech/chassis/head
	name = "chassis component - head"
	desc = "A head component used in the construction of a Battlemech. Contains a cockpit and computer interface"
	slot = BT_CHASSIS_HEAD

/obj/battletech/chassis/center_torso
	name = "chassis component - center torso"
	desc = "a center torso component used in the construction of a Battlemech. Contains mounting brackets for a fusion powerplant"
	slot = BT_CHASSIS_CTORSO
	icon_state = "torso"

/obj/battletech/chassis/left_torso
	name = "chassis component - left torso"
	desc = "a left torso component used in the construction of a Battlemech. Contains heavy weapon and equipment mounts."
	slot = BT_CHASSIS_LTORSO

/obj/battletech/chassis/right_torso
	name = "chassis component - right torso"
	desc = "a right torso component used in the construction of a Battlemech. Contains heavy weapon and equipment mounts."
	slot = BT_CHASSIS_RTORSO

/obj/battletech/chassis/left_leg
	name = "chassis component - left leg"
	desc = "a left leg component used in the construction of a Battlemech. Contains the primary myomer drivers for movement."
	slot = BT_CHASSIS_LLEG
	icon_state = "legs"
	var/obj/item/stock_parts/capacitor/capacitor

/obj/battletech/chassis/right_leg
	name = "chassis component - right leg"
	desc = "a left leg component used in the construction of a Battlemech. Contains the primary myomer drivers for movement."
	slot = BT_CHASSIS_RLEG
	icon_state = "legs"
	var/obj/item/stock_parts/capacitor/capacitor

/obj/battletech/chassis/left_arm
	name = "chassis component - left arm"
	desc = "a left arm component used in the construction of a Battlemech. Contains weapon and equipment mounts."
	slot = BT_CHASSIS_LARM
	icon_state = "arm_L"

/obj/battletech/chassis/right_arm
	name = "chassis component - right arm"
	desc = "a right arm component used in the construction of a Battlemech. Contains weapon and equipment mounts."
	slot = BT_CHASSIS_RARM
	icon_state = "arm_R"

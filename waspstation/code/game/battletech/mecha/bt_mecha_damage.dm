/obj/battletech/mecha/proc/check_control_damage()
	var/obj/battletech/chassis/head/mech_head = mech_chassis[BT_CHASSIS_HEAD]
	if(mech_head.internal_damage & MECHA_INT_CONTROL_LOST)
		return TRUE
	return FALSE

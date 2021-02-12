/obj/battletech/mecha/proc/check_control_damage()
	var/obj/battletech/chassis/head/mech_head = mech_chassis[BT_CHASSIS_HEAD]
	if(mech_head.diasbled)
		return TRUE
	return FALSE

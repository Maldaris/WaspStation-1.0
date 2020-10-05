/obj/battletech/mecha/process_pilot_ui()
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
			clear_pilot_ui()
			pilot = null
			break
		else if (checking == src)
			break  // all good
		checking = checking.loc

/obj/battletech/mecha/clear_pilot_ui()
	pilot.clear_alert("throttle")
	pilot.clear_alert("powerplant alerts")
	pilot.clear_alert("chassis doll")
	RemoveActions(pilot, human_pilot=1)

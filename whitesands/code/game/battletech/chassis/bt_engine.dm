/obj/battletech/chassis/engine
	var/movement_points = list(4, 6)
	var/overloaded = FALSE
	var/shutdown = TRUE

/obj/battletech/chassis/engine/proc/is_overloaded()
	return overloaded

/obj/battletech/chassis/engine/proc/is_shutdown()
	return shutdown

/obj/battletech/chassis/engine/proc/update_powerplant_alerts()
	return

/obj/battletech/chassis/engine/proc/get_min_throttle()
	return 0

/obj/battletech/chassis/engine/proc/get_max_throttle()
	return 100

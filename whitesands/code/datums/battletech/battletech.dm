
// Global namespace for a bunch of helper procs and constants associated with them
// Eventually some of these might inherit from config values if dee wants the ability to tweak.
/datum/battletech
	// Base traversal rate for turning in degrees per second
	var/mecha_class_traverse_rate = list(
		BT_MECH_LIGHT = 90,
		BT_MECH_MEDIUM = 80,
		BT_MECH_HEAVY = 60,
		BT_MECH_ASSAULT = 40
	)
	// Base torso twist rate for twising in degrees per second
	var/mecha_class_torso_twist_rate = list(
		BT_MECH_LIGHT = 45,
		BT_MECH_MEDIUM = 35,
		BT_MECH_HEAVY = 30,
		BT_MECH_ASSAULT = 25,
	)
	// Base tonnage for each class
	var/mech_class_base_tonnage = list(
		BT_MECH_LIGHT = 30,
		BT_MECH_MEDIUM = 50,
		BT_MECH_HEAVY = 70,
		BT_MECH_ASSAULT = 95,
	)
	// Movement Points from original BT game
	// Base values that are used if movement_points is not set by the powerplant itself.
	var/mech_class_max_velocity_modifier = list(
		BT_MECH_LIGHT = list(6, 9),
		BT_MECH_MEDIUM = list(5, 8),
		BT_MECH_HEAVY = list(4, 6),
		BT_MECH_ASSAULT = list(3, 5)
	)
	// Determined by the manipulator in each leg
	// tonnage scaling is averaged out.
	var/myomer_level_scaling = list(0.8, 1, 1.1, 1.25)
	var/sprint_coeff = 10.8 // kph // classic BT's kph -> hex / 2
	var/normal_movement_coeff = 5.4 // classic BT's kph -> hex / 2

/**
	kph -> m/s = x / 3.6
	1 tile = ~2 meters, for sake of balance, we're making this 5:1 ratio
	kph -> t/s = f(x) = x / (10 * 3.6) = x / 30 = 0.027777... * x
	t/s -> t/ds = f(x) / 10 = 0.0027777... * x
	therefore kph2tpds = 0.0027777... * x
**/
/datum/battletech/proc/kph2tpds(kph)
	return 0.0027777 * kph

/datum/battletech/proc/calculate_movement_speed(btmech)
	var/obj/battletech/mecha/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null
	if(!mech_class_max_velocity_modifier[mecha.mecha_class] && !mecha.powerplant.movement_points)
		return null
	if(mecha.throttle <= BT_RUN_THRESHOLD) // walking speed
		if(mecha.powerplant.movement_points)
			var/movement_points = mecha.powerplant.movement_points
			return kph2tpds(movement_points[0] * normal_movement_coeff) * (mecha.throttle/100)
		else
			return kph2tpds(mech_class_max_velocity_modifier[mecha.mecha_class][0] * normal_movement_coeff) * (mecha.throttle/100)
	else if(mecha.sprinting && !mecha.powerplant.is_overloaded()) // sprinting speed
		if(mecha.powerplant.movement_points)
			var/movement_points = mecha.powerplant.movement_points
			return kph2tpds(movement_points[0] * sprint_coeff) * (mecha.throttle/100)
		else
			return kph2tpds(mech_class_max_velocity_modifier[mecha.mecha_class][0] * sprint_coeff) * (mecha.throttle/100)
	else // running speed
		if(mecha.powerplant.movement_points)
			var/movement_points = mecha.powerplant.movement_points
			return kph2tpds(movement_points[1] * normal_movement_coeff) * (mecha.throttle/100)
		else
			return kph2tpds(mech_class_max_velocity_modifier[mecha.mecha_class][1] * normal_movement_coeff) * (mecha.throttle/100)

/**
	Calculates the rate at which a mech should be able to turn
	Returns a tick rate in deciseconds for SSObj processing or null if the argument is invalid
	Based off the forumla:
		mecha_class_traverse_rate * tonnage_ratio * (1/2 * throttle ratio)
	where mecha_class_traverse_rate is determined by mech class
	the result of which is converted from seconds to deciseconds
**/
/datum/battletech/proc/calculate_traverse_rate(btmech)
	var/obj/battletech/mecha/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null
	if(!mecha_class_traverse_rate[mecha.mecha_class])
		return null

	var/tonnage_ratio = mecha.max_tonnage / clamp(mecha.cur_tonnage, 1, mecha.max_tonnage)
	var/throttle_ratio = 50 / clamp(mecha.throttle, 1, 100)
	return clamp((mecha_class_traverse_rate[mecha.mecha_class] * tonnage_ratio * throttle_ratio) / 10, 1, 45)

/**
	Calculates the rate at which a mech should be able to torso twist
	Returns a tick rate in deciseconds for SSObj processing or null if the argument is invalid
	Based off the forumla:
		mecha_class_torso_twist_rate
	where the mecha_class_traverse_rate is determined by mech class
	the result of which is converted from seconds to deciseconds
**/
/datum/battletech/proc/calculate_torso_twist_rate(btmech)
	var/obj/battletech/mecha/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null
	if(!mecha_class_traverse_rate[mecha.mecha_class])
		return null

	return clamp(mecha_class_torso_twist_rate[mecha.mecha_class] / 10, 1, 45)

/**
	Calculates the max tonnage for a given mech
	Based off the forumla:
		1/2 * (left_myomer_bonus + right_myomer_bonus) * (mech_class_base_tonnage)
**/
/datum/battletech/proc/calculate_max_tonnage(btmech)
	var/obj/battletech/mecha/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null

	if(!mech_class_base_tonnage[mecha.mecha_class])
		return null

	var/obj/battletech/chassis/left_leg/lleg = mecha.mech_chassis[BT_CHASSIS_LLEG]
	var/obj/battletech/chassis/right_leg/rleg = mecha.mech_chassis[BT_CHASSIS_RLEG]

	if(!lleg || !rleg || !isbtchassis(lleg) || !isbtchassis(rleg))
		return 0
	// How much energy can the leg dump into the myomer to contract it?
	var/component_rating_l = myomer_level_scaling[lleg.capacitor.get_part_rating()]
	var/component_rating_r = myomer_level_scaling[rleg.capacitor.get_part_rating()]

	var/rating_modifier = (component_rating_l + component_rating_r) / 2

	return rating_modifier * mech_class_base_tonnage[mecha.mecha_class]

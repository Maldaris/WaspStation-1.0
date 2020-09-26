
// Global namespace for a bunch of helper procs and constants associated with them
// Eventually some of these might inherit from config values if dee wants the ability to tweak.
/datum/battletech
	// Base traversal rate for turning in degrees per second
	mecha_class_traverse_rate = list(
		BT_MECH_LIGHT = 90
		BT_MECH_MEDIUM = 80
		BT_MECH_HEAVY = 60
		BT_MECH_ASSAULT = 40
	)
	// Base torso twist rate for twising in degrees per second
	mecha_class_torso_twist_rate = list(
		BT_MECH_LIGHT = 45
		BT_MECH_MEDIUM = 35
		BT_MECH_HEAVY = 30
		BT_MECH_ASSAULT = 25
	)
	// Base tonnage for each class
	mech_class_base_tonnage = list(
		BT_MECH_LIGHT = 30
		BT_MECH_MEDIUM = 50
		BT_MECH_HEAVY = 70
		BT_MECH_ASSAULT = 95
	)
	// Determined by the manipulator in each leg
	// tonnage scaling is averaged out.
	myomer_level_scaling = list(0.8, 1, 1.1, 1.25)

/**
	Calculates the rate at which a mech should be able to turn
	Returns a tick rate in deciseconds for SSObj processing or null if the argument is invalid
	Based off the forumla:
		mecha_class_traverse_rate * tonnage_ratio * (1/2 * throttle ratio)
	where mecha_class_traverse_rate is determined by mech class
	the result of which is converted from seconds to deciseconds
**/
/datum/battletech/calculate_traverse_rate(btmech)
	var/obj/battletech/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null
	if(!mecha_class_traverse_rate[mecha.mecha_class])
		return null

	var/tonnage_ratio = mecha.max_tonnage / clamp(mecha.cur_tonnage, 1, mecha.max_tonnage)
	var/throttle_ratio = 50 / clamp(mecha.cur_throttle, 1, 100)
	return clamp((mecha_class_traverse_rate[mecha.mecha_class] * tonnage_ratio * throttle_ratio) / 10, 1, 45)

/**
	Calculates the rate at which a mech should be able to torso twist
	Returns a tick rate in deciseconds for SSObj processing or null if the argument is invalid
	Based off the forumla:
		mecha_class_torso_twist_rate
	where the mecha_class_traverse_rate is determined by mech class
	the result of which is converted from seconds to deciseconds
**/
/datum/battletech/calculate_torso_twist_rate(btmech)
	var/obj/battletech/mecha = btmech
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
/datum/battletech/calculate_max_tonnage(btmech)
	var/obj/battletech/mecha = btmech
	if(!mecha || isbtmech(mecha))
		return null

	if(!mech_class_tonnage_base[mecha.mecha_class])
		return null

	var/obj/battletech/chassis/leg/lleg = mecha.mech_chassis[BT_CHASSIS_LLEG]
	var/obj/battletech/chassis/leg/rleg = mecha.mech_chassis[BT_CHASSIS_RLEG]

	if(!lleg || !rleg || !isbtchassis(lleg) || !isbtchassis(rleg))
		return 0

	var/component_rating_l = myomer_level_scaling[lleg.manip.get_part_rating()]
	var/component_rating_r = myomer_level_scaling[rleg.manip.get_part_rating()]

	var/rating_modifier = (component_rating_l + component_rating_r) / 2

	return rating_modifier * mech_class_base_tonnage[mecha.mecha_class]


/datum/battletech/betty
	sound_map = list(

	)
/datum/battletech/betty/play_sound(target)
	if(!target || !isplayer(target))

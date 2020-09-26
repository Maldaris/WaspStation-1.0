/obj/battletech/chassis
	name = "chassis component"
	desc = "A component used in the construction of a Battlemech"
	icon = 'waspstation/icons/battletech/chassis.dmi'
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

/obj/battletech/chassis/head
	name = "chassis component - head"
	desc = "A head component used in the construction of a Battlemech. Contains a cockpit and computer interface"
	slot = BT_CHASSIS_HEAD

/obj/battletech/chassis/center_torso
	name = "chassis component - center torso"
	desc = "a center torso component used in the construction of a Battlemech. Contains mounting brackets for a fusion powerplant"
	slot = BT_CHASSIS_CTORSO

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
	slot = BT_CHASSIS_LEFT_LEG

/obj/battletech/chassis/right_leg
	name = "chassis component - right leg"
	desc = "a left leg component used in the construction of a Battlemech. Contains the primary myomer drivers for movement."
	slot = BT_CHASSIS_RIGHT_LEG

/obj/battletech/chassis/left_arm
	name = "chassis component - left arm"
	desc = "a left arm component used in the construction of a Battlemech. Contains weapon and equipment mounts."
	slot = BT_CHASSIS_LEFT_ARM

/obj/battletech/chassis/right_arm
	name = "chassis component - right arm"
	desc = "a right arm component used in the construction of a Battlemech. Contains weapon and equipment mounts."
	slot = BT_CHASSIS_RIGHT_ARM

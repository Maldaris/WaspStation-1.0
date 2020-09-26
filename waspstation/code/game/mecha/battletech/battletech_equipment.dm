/obj/battletech/equipment
	name = "battletech equipment"
	desc = "a piece of battletech equipment"
	icon = "waspstation/icon/battletech/equipment.dm"
	density = FALSE
	opacity = 1
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	resistance_flags = FIRE_PROOF | ACID_PROOF
	layer = BELOW_MOB_LAYER

	var/type = BT_EQUIPMENT_BASE
	var/weight = 1
	var/powergrid = 10
	var/slot_type = BT_EQUIPMENT_SLOT_OMNI

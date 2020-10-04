/datum/battletech/control_scheme
	var/obj/battletech/mecha/source_mech
	var/group_fire = FALSE
	var/chain_fire_index = 0
	var/on_general_cooldown = FALSE
	var/list/obj/battletech/equipment/selected_equipment = list()

/datum/battletech/control_scheme/New()
	. = ..()

/datum/battletech/control_scheme/Destroy()
	. = ..()

/datum/battletech/control_scheme/proc/equipment_selected()
	if(group_fire)
		return selected_equipment.len > 0;
	else
		return selected_equipment.len > 0 && selected_equipment[chain_fire_index]

/datum/battletech/control_scheme/proc/all_ranged()
	if(!group_fire)
		return FALSE
	for(var/i in selected_equipment)
		var/obj/battletech/equipment/E = i
		if(!E || !isbtequipment(E) || !E.is_ranged)
			return FALSE
	return TRUE

/datum/battletech/control_scheme/proc/single_ranged()
	if(group_fire)
		return FALSE
	else
		return selected_equipment[chain_fire_index] && selected_equipment[chain_fire_index].is_ranged

/datum/battletech/control_scheme/proc/action(atom/target, params)
	return

/datum/battletech/control_scheme/proc/start_cooldown()
	for(var/i in selected_equipment)
		var/obj/battletech/equipment/E = i
		if(!E || !isbtequipment(E))
			continue
		E.start_cooldown()

/datum/battletech/control_scheme/proc/cycle_to_next()
	if(chain_fire_index + 1 >= selected_equipment.len)
		chain_fire_index = 0
	else
		chain_fire_index++

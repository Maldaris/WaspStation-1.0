/obj/machinery/mineral/dcm_drill
	name = "deep core mining drill"
	desc = "A machine that drills deep undeground on a planet for mining ores that are otherwise rare or nonexistent on the surface."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	var/datum/component/remote_materials/materials
	var/upgraded_remote_materials = FALSE
	var/ore_bearing_type = null
	var/ore_bearing_rate = 0.1

/obj/machinery/mineral/dcm_drill/Initialize(mapload)
	. = ..()
	if (.upgradedRemoteConnection())
		materials = AddComponent(/datum/component/remote_materials, "dcmd", mapload)
	.analyzeArea()

/obj/machinery/mineral/dcm_drill/Destroy()
	materials = null
	return ..()

/obj/machinery/minera/dcm_drill/analyzeArea()
	// Determines whether or not the area is ore-bearing and at what quality.

/obj/machinery/mineral/dcm_drill/examine(mob/user)
	. = ..()
	if(!materials?.silo)
		. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
	else if(materials?.on_hold())
		. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		return
	var/datum/material/ore = pick(ore_rates)
	mat_container.insert_amount_mat((ore_rates[ore] * 1000), ore)

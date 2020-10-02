/obj/machinery/mineral/dcm_drill
	name = "deep core mining drill"
	desc = "A machine that drills deep undeground on a planet for mining ores that are otherwise rare or nonexistent on the surface."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/deep_core_miner
	layer = BELOW_OBJ_LAYER
	var/datum/component/remote_materials/materials
	var/ore_bearing_type = null
	var/ore_bearing_rate = 0.1
	var/guaranteed_ores = list(
		/datum/material/iron = 1,
		/datum/material/glass = 1,
		/datum/material/silver = 0.75,
		/datum/material/gold = 0.75
	)

/obj/machinery/mineral/dcm_drill/Initialize(mapload)
	. = ..()
	refreshParts()
	materials = AddComponent(/datum/component/remote_materials, "dcmd", mapload)
	analyzeArea()

/obj/machinery/mineral/dcm_drill/Destroy()
	materials = null
	return ..()

/obj/machinery/minera/dcm_drill/analyzeArea()
	// Determines whether or not the area is ore-bearing and at what quality.
	var/area/anchored_zone = get_area(src)
	if(anchored_zone && isarea(anchored_zone))
		if(istype(anchored_zone, /area/ruin/unpowered/lavaland/ore_node))
			var/area/ruin/unpowered/lavaland/ore_node/node = anchored_zone
			ore_bearing_type = node.material_type
			ore_bearing_rate = node.material_rate
			src.visible_message("<span class='notice'>\The [src] chirps in affirmation, detecing [ore_bearing_type.name] ore in the area! Extraction should begin shortly.</span>")
		else
			src.visible_message("<span class='warning'>\The [src] beeps in error, as it cannot find any deep core deposits in this area.</span>")
	else
		src.visible_message("<span class='warning'>\The [src] is not able to determine the ore-bearing area it is placed in. Firmware updates may be required.</span>")

/obj/machinery/mineral/dcm_drill/examine(mob/user)
	. = ..()
	if(!materials?.silo)
		. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
	else if(materials?.on_hold())
		. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"

/obj/machinery/mineral/dcm_drill/refreshParts()


/obj/machinery/mineral/dcm_drill/process()
	if(!materials?.silo || materials?.on_hold())
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		return

/obj/machinery/power/dcm_drill/examine(mob/user)
	. += ..()
	if(anchored)
		. += "<span class='info'>It's currently anchored to the floor, you can unsecure it with a <b>wrench</b>.</span>"
	else
		. += "<span class='info'>It's not anchored to the floor. You can secure it in place with a <b>wrench</b>.</span>"
	if(panel_open)
		. += "<span class='info'>It's maintenence panel is exposed. You can seal the cover with a <b>screwdriver</b>.</span>"
	if(in_range(user, src) || isobserver(user))
		if(!materials?.silo)
			. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
		else if(materials?.on_hold())
			. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"
		if(!active)
			. += "<span class='notice'>Its status display is currently turned off.</span>"
		else if(!powered)
			. += "<span class='notice'>Its status display is glowing faintly.</span>"

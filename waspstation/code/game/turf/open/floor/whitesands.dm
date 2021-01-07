/turf/open/floor/plating/asteroid/whitesands
	name = "salted sand"
	baseturfs = /turf/open/floor/plating/asteroid/whitesands
	icon = 'waspstation/icons/turf/floors/whitesands/ws_floors.dmi'
	icon_state = "sand"
	icon_plating = "sand"
	environment_type = WHITESANDS_SAND_ENV
	initial_gas_mix = OPENTURF_LOW_PRESSURE //Fallback, and used to tell the AACs that this is the exterior
	digResult = /obj/item/stack/ore/glass

/turf/open/floor/plating/asteroid/whitesands/Initialize()
	..()
	if (GLOB.ws_planet_atmos.ws_moles_amount == null)
		GLOB.ws_planet_atmos.New()
	air = GLOB.ws_planet_atmos
	update_air_ref()

/turf/open/floor/plating/asteroid/whitesands/dried
	name = "dried sand"
	baseturfs = /turf/open/floor/plating/asteroid/whitesands/dried
	icon_state = "dried_up"
	icon_plating = "dried_up"
	environment_type = WHITESANDS_DRIED_ENV
	digResult = /obj/item/stack/ore/glass

/turf/open/floor/plating/asteroid/whitesands/remove_air(amount)
	return return_air()

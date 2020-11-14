/* OVERMAP TURFS */
/turf/open/overmap
	icon = 'waspstation/icons/turf/overmap.dmi'
	icon_state = "overmap0"
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/overmap/edge
	opacity = 1
	density = 1

//this is completely unnecessary but it looks interesting
/turf/open/overmap/Initialize()
	. = ..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == SSovermap.size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == SSovermap.size)
			numbers += "-"
	if(y == 1 || y == SSovermap.size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('waspstation/icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == SSovermap.size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == SSovermap.size)
			I.pixel_x = 5*i + 2
		overlays += I
/* OVERMAP AREA */
/area/overmap
	name = "Overmap"
	icon_state = "yellow"
	requires_power = FALSE
	noteleport = TRUE
	blob_allowed = FALSE
	flags_1 = NONE

/**
  * # Overmap objects
  *
  * Everything visible on the overmap: stations, ships, ruins, events, and more.
  *
  * This base class should be the parent of all objects present on the overmap.
  * For the control counterparts, see [/obj/machinery/computer/helm].
  * For the shuttle counterparts (ONLY USED FOR SHIPS), see [/obj/docking_port/mobile].
  *
  */
/obj/structure/overmap
	name = "overmap object"
	desc = "An unknown celestial object."
	icon = 'waspstation/icons/effects/overmap.dmi'
	icon_state = "object"
	///ID, literally the most important thing
	var/id
	///~~If we need to render a map for cameras and helms for this object~~ basically can you look at and use this as a ship or station
	var/render_map = FALSE
	///The range of the view shown to helms and viewscreens (subject to be relegated to something else)
	var/sensor_range = 4
	///Integrity percentage, do NOT modify. Use [/obj/structure/overmap/proc/receive_damage] instead.
	var/integrity = 100
	///Armor value, reduces integrity damage taken
	var/overmap_armor = 1
	///List of other overmap objects in the same tile
	var/list/close_overmap_objects = list()

	// Stuff needed to render the map
	var/map_name
	var/obj/screen/map_view/cam_screen
	var/obj/screen/plane_master/lighting/cam_plane_master
	var/obj/screen/background/cam_background

/obj/structure/overmap/Initialize(mapload, _id = null)
	. = ..()
	LAZYADD(SSovermap.overmap_objects, src)
	if(id == MAIN_OVERMAP_OBJECT_ID)
		name = station_name()
	if(_id)
		id = _id
	if(!id)
		id = "overmap_object_[SSovermap.ships.len + 1]"
	if(render_map)	// Initialize map objects
		map_name = "overmap_[id]_map"
		cam_screen = new
		cam_screen.name = "screen"
		cam_screen.assigned_map = map_name
		cam_screen.del_on_map_removal = FALSE
		cam_screen.screen_loc = "[map_name]:1,1"
		cam_plane_master = new
		cam_plane_master.name = "plane_master"
		cam_plane_master.assigned_map = map_name
		cam_plane_master.del_on_map_removal = FALSE
		cam_plane_master.screen_loc = "[map_name]:CENTER"
		cam_background = new
		cam_background.assigned_map = map_name
		cam_background.del_on_map_removal = FALSE
		update_screen()

/obj/structure/overmap/Destroy()
	. = ..()
	LAZYREMOVE(SSovermap.overmap_objects, src)
	if(render_map)
		QDEL_NULL(cam_screen)
		QDEL_NULL(cam_plane_master)
		QDEL_NULL(cam_background)

/**
  * Done to ensure the connected helms are updated appropriately
  */
/obj/structure/overmap/Move(atom/newloc, direct)
	. = ..()
	update_screen()

/**
  * Updates the screen object, which is displayed on all connected helms
  */
/obj/structure/overmap/proc/update_screen()
	if(render_map)
		var/list/visible_turfs = list()
		for(var/turf/T in view(sensor_range, src))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)
		return TRUE

/**
  * When something crosses another overmap object, add it to the nearby objects list, which are used by events and docking
  */
/obj/structure/overmap/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(istype(loc, /turf/) && istype(AM, /obj/structure/overmap))
		var/obj/structure/overmap/other = AM
		if(other == src)
			return
		other.close_overmap_objects += src
		close_overmap_objects += other

/**
  * See [/obj/structure/overmap/Crossed]
  */
/obj/structure/overmap/Uncrossed(atom/movable/AM, atom/newloc)
	. = ..()
	if(istype(loc, /turf/) && istype(AM, /obj/structure/overmap))
		var/obj/structure/overmap/other = AM
		if(other == src)
			return
		other.close_overmap_objects -= src
		close_overmap_objects -= other

/**
  * Reduces overmap object integrity by X amount, divided by armor
  * * amount - amount of damage to apply to the ship
  */
/obj/structure/overmap/proc/recieve_damage(amount)
	integrity = max(integrity - (amount / overmap_armor), 0)
	//TODO: add check for if there's no mobs in a ship with no integrity to delete (or make into a ruin?)

/**
  * ## Z-level linked overmap object
  *
  * These are exactly what they say on the tin, overmap objects that are linked to one or more z-levels.
  * There is nothing special on this side, but overmap ships treat them differently from all other overmap objects,
  * such as the fact they can dock on said z-level.
  *
  */
/obj/structure/overmap/level
	///List of linked Z-levels (z number), used to dock
	var/list/linked_levels = list()
	render_map = TRUE //this is done because it's not expensive to load the map once since levels don't move

/obj/structure/overmap/level/Initialize(mapload, _id, list/_zs)
	if(_zs)
		LAZYADD(linked_levels, _zs)
	else if(!linked_levels)
		WARNING("Overmap zlevel initialized with no linked level")
		return INITIALIZE_HINT_QDEL
	..()

/obj/structure/overmap/level/ruin
	name = "energy signature"
	desc = "A strange energy signature. Could be anything, or nothing at all."
	icon_state = "event"

/obj/structure/overmap/level/main //there should only be ONE of these in a given game.
	name = "Space Station 13"
	desc = "Nanotrasen's top-secret plasma research and extraction facility. Most likely the reason you're here."
	icon_state = "station"
	id = MAIN_OVERMAP_OBJECT_ID

/**
  * Ensures there is only ONE main station object
  */
/obj/structure/overmap/level/main/Initialize(mapload, _id, list/_zs)
	if(SSovermap.main)
		WARNING("Multiple main overmap objects spawned, deleting extras.")
		return INITIALIZE_HINT_QDEL
	else
		SSovermap.main = src
	..()

/obj/structure/overmap/level/planet
	name = "planet"
	desc = "An unknown planet."
	icon_state = "globe"

/obj/structure/overmap/level/planet/lavaland
	name = "Lavaland"
	desc = "A lava-covered planet known for its plentiful natural resources among dangerous fauna."
	id = AWAY_OVERMAP_OBJECT_ID_LAVALAND
	color = COLOR_ORANGE

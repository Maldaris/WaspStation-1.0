
#define CASCADE_EVENT_COUNTDOWN 54000 // 1 hour 30 minutes
#define CASCADE_SATURATION_COUNTDOWN 9000 // 15 minutes

#define CINEMATIC_BLUESPACE_CATACLYSM 15
/datum/cinematic/bluespace_cataclysm
	id = CINEMATIC_BLUESPACE_CATACLYSM
	is_global = TRUE
	cleanup_time = 300

/datum/cinematic/bluespace_cataclysm/New()
	screen = new(src)

/datum/cinematic/bluespace_cataclysm/content()
	flick("intro_cataclysm", screen)
	sleep(30)
	cinematic_sound((sound('sound/effects/cascade.ogg')))
	flick("void", screen)
	special()
	screen.icon_state = "summary_cataclysm"

/datum/game_mode/cataclysm
	name = "Bluespace Cataclysmic Event"
	votable = 0
	title_icon = null
	announce_span = "warning"
	announce_text = "The End of the Universe"
	recommended_enemies = 1
	antag_flag = ROLE_TRAITOR
	allow_persistence_save = FALSE

	var/armageddon_timer
	var/saturation_timer
	var/saturation_complete = FALSE

/datum/game_mode/cataclysm/proc/start_countdown()
	armageddon_timer = addtimer(CALLBACK(src, .proc/trigger_cascade), CASCADE_EVENT_COUNTDOWN, TIMER_UNIQUE)

/datum/game_mode/cataclysm/proc/trigger_cascade()
	// Update parallax colors for all players to reflect the hell they're now in
	for (var/client/C in GLOB.clients)
		var/mob/viewmob = C.mob
		if (!istype(viewmob))
			continue
		var/obj/screen/plane_master/PM = viewmob.hud_used.plane_masters["[PLANE_SPACE]"]
		if (!istype(PM))
			continue
		PM.color = list(
			0,0,0,0,
			0,0,0,0,
			0,0,0,0,
			0,0.4,1,1) // Looks like RGBA? Currently #0066FF
	for (var/atom/L in GLOB.nukeop_start)
		var/turf/T = get_turf(L)
		T.ChangeTurf(/turf/closed/indestructable/bluespace_cascade)
	priority_announce("Warning! Bluespace Cascade Event detected in close proximity to the station. Begin evacuation immediately!")
	saturation_timer = addtimer(CALLBACK(src, .proc/trigger_saturation), CASCADE_SATURATION_COUNTDOWN, TIMER_UNIQUE)

/datum/game_mode/cataclysm/proc/trigger_saturation()
	// all things must come to an end
	priority_announce("Warning! Final bluespace satuaration has completed! Universal spatial breakdown imminent!")
	Cinematic(CINEMATIC_BLUESPACE_CATACLYSM, world, CALLBACK(src, .proc/complete_saturation))

/datum/game_mode/cataclysm/proc/complete_saturation()
	saturation_complete = TRUE

/datum/game_mode/cataclysm/generate_station_goals()
	station_goals += new /datum/station_goal/spatial_emmigration

/datum/game_mode/cataclysm/check_finished()
	return saturation_complete

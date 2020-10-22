/*
	"Bitchin' Betty" is the nickname of the vox narrator from the MechWarrior games.

	Because the default play_sound procs are kinda trash at enabling serial or concurrent sounds,
	it makes more sense to bake these macros into this datum based off of the playsound and
	playsound_local functions.

	The upside to this is we can tune Betty to sound/work exactly as we need. Falloff/Frequency
	variations don't matter, and same with external ranges, as well as ignoring positional sound.
*/

#define CHANNEL_BETTY 1010
#define CHANNEL_COCKPIT_SOUNDS 1009
#define CHANNEL_MOVEMENT_SOUNDS 1008

/datum/battletech/betty
	var/sound_map = list(
		"group_fire" = list(
			file = 'waspstation/sound/battletech/betty/group_fire.wav',
			channel = CHANNEL_BETTY
		),
		"chain_fire" = list(
			'waspstation/sound/battletech/betty/chain_fire.wav',
			channel = CHANNEL_BETTY
		),
		"button_press" = list(
			file = 'waspstation/sound/battletech/betty/button_press.wav',
			channel = CHANNEL_COCKPIT_SOUNDS,
			wait = 0
		),
		"enabled" = list(
			file = 'waspstation/sound/battletech/betty/enabled.wav',
			channel = CHANNEL_BETTY
		),
		"disabled" = list(
			file = 'waspstation/sound/battletech/betty/disabled.wav',
			channel = CHANNEL_BETTY
		),
		"critical_hit" = list(
			file = 'waspstation/sound/battletech/betty/critical_hit.wav',
			channel = CHANNEL_BETTY
		),
		"heat_level_critical" = list(
			file = 'waspstation/sound/battletech/betty/heat_level_critical.wav',
			channel = CHANNEL_BETTY
		),
		"heat_sink" = list(
			file = 'waspstation/sound/battletech/betty/heat_sink.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"engine" = list(
			file = 'waspstation/sound/battletech/betty/engine.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"left_arm" = list(
			file = 'waspstation/sound/battletech/betty/left_arm.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"right_arm" = list(
			file = 'waspstation/sound/battletech/betty/right_arm.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"left_leg" = list(
			file = 'waspstation/sound/battletech/betty/left_leg.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"right_leg" = list(
			file = 'waspstation/sound/battletech/betty/right_leg.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"left_torso" = list(
			file = 'waspstation/sound/battletech/betty/left_torso.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"right_torso" = list(
			file = 'waspstation/sound/battletech/betty/left_torso.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"head" = list(
			// We're lacking sound for the head so reuse center torso.
			file = 'waspstation/sound/battletech/betty/center_torso.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		),
		"center_torso" = list(
			file = 'waspstation/sound/battletech/betty/center_torso.wav',
			channel = CHANNEL_BETTY,
			component = TRUE
		)
	)

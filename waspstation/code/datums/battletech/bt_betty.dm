/datum/battletech/betty
	var/sound_map = list(
		"group_fire" = 'waspstation/sound/battletech/betty/group_fire.wav',
		"chain_fire" = 'waspstation/sound/battletech/betty/chain_fire.wav',
		"button_press" = 'waspstation/sound/battletech/betty/button_press.wav',
		"enabled" = 'waspstation/sound/battletech/betty/enabled.wav',
		"disabled" = 'waspstation/sound/battletech/betty/disabled.wav'
	)

/datum/battletech/betty/proc/play_sound(mech, sound_name)
	if(!mech)
		return
	if(!sound_map[sound_name])
		return
	playsound(mech, sound_map[sound_name], 40)


/datum/battletech/betty/proc/play_sound_enabled(mech, sound_name)
	play_sound(mech, sound_name)
	play_sound(mech, "enabled")

/datum/battletech/betty/proc/play_sound_disabled(mech, sound_name)
	play_sound(mech, sound_name)
	play_sound(mech, "disabled")

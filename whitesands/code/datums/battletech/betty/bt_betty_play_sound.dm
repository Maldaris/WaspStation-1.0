/datum/battletech/betty/proc/can_play_sound(mech, sound_name)
	var/obj/battletech/mecha/M = mech
	if(!M || !isbtmech(M) || !M.pilot || !M.pilot.client)
		return FALSE

	if(!sound_map[sound_name])
		return FALSE

	return TRUE

/datum/battletech/betty/proc/load_sound(sound_name)
	var/list/props = sound_map[sound_name]
	var/sound/S = sound(props["file"])
	S.channel = props["channel"] || SSsounds.random_available_channel()
	if(S.channel != CHANNEL_BETTY)
		S.wait = props["wait"]
	else
		S.wait = 1 // Phrases spoken serially
	if(props["volume"] == 0)
		return // No Sound
	S.volume = props["volume"] || 40
	return S

/datum/battletech/betty/proc/play_sound(obj/battletech/mecha/mech, sound_name)
	if(!can_play_sound(mech, sound_name))
		return

	var/sound/S = load_sound(sound_name)

	SEND_SOUND(mech.pilot, S)

/datum/battletech/betty/proc/play_sound_enabled(obj/battletech/mecha/mech, sound_name)
	if(!can_play_sound(mech, sound_name))
		return

	var/sound/thing = load_sound(sound_name)
	var/sound/enabled = load_sound("enabled")
	enabled.wait = 1
	// If we're not playing this sound on the betty channel, make sure
	// the phrase plays after the supplied sound.
	if(thing.channel != CHANNEL_BETTY)
		enabled.channel = thing.channel

	SEND_SOUND(mech.pilot, thing)
	SEND_SOUND(mech.pilot, enabled)

/datum/battletech/betty/proc/play_sound_disabled(obj/battletech/mecha/mech, sound_name)
	if(!can_play_sound(mech, sound_name))
		return

	var/sound/thing = load_sound(sound_name)
	var/sound/disabled = load_sound("disabled")
	disabled.wait = 1
	// If we're not playing this sound on the betty channel, make sure
	// the phrase plays after the supplied sound.
	if(thing.channel != CHANNEL_BETTY)
		disabled.channel = thing.channel

	SEND_SOUND(mech.pilot, thing)
	SEND_SOUND(mech.pilot, disabled)

/datum/battletech/betty/proc/play_critical_hit(obj/battletech/mecha/mech, section)
	if(!can_play_sound(mech, section))
		return

	var/list/section_props = sound_map[section]

	if(!section_props || !section_props["component"])
		return

	var/sound/critical_hit = load_sound("critical_hit")
	var/sound/section = load_sound(section)

	section.channel = CHANNEL_BETTY
	section.wait = 1

	SEND_SOUND(mech.pilot, critical_hit)
	SEND_SOUND(mech.pilot, section)

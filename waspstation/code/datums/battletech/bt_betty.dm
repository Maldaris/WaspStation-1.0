/datum/battletech/betty
	var/sound_map = list()

/datum/battletech/betty/proc/play_sound(target)
	if(!target)
		return

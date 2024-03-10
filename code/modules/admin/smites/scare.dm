/datum/smite/scare
	name = "Scare"

/datum/smite/scare/proc/get_random_sound()
	var/sounds = list(
		'white/master/sound/effects/scream1.ogg',
		'white/master/sound/effects/scream2.ogg',
		'white/master/sound/effects/scream3.ogg',
		'white/master/sound/effects/scream4.ogg',
		'white/master/sound/effects/scream5.ogg',
		'white/master/sound/effects/scream6.ogg',
		'white/master/sound/effects/scream7.ogg',
		'white/master/sound/effects/scream8.ogg',
		'white/master/sound/effects/scream9.ogg',
		'white/master/sound/effects/scream10.ogg'
	)

	return pick(sounds)

/atom/movable/screen/fullscreen/screamer
	icon = 'white/valtos/icons/ruzone_went_up.dmi'
	plane = SPLASHSCREEN_PLANE
	screen_loc = "CENTER-7,SOUTH"
	icon_state = ""

/datum/smite/scare/effect(client/user, mob/living/target)
	. = ..()
	if(!isliving(target))
		to_chat(user, span_warning("Это можно использовать только на /mob/living."), confidential = TRUE)
		return

	var/mob/living/dude = target
	to_chat(dude, span_danger("БУ!"))

	var/list/screens = list(dude.hud_used.get_plane_master(FLOOR_PLANE), dude.hud_used.get_plane_master(GAME_PLANE), dude.hud_used.get_plane_master(LIGHTING_PLANE))
	for(var/atom/movable/screen/plane_master/whole_screen in screens)
		dude.overlay_fullscreen("screamer", /atom/movable/screen/fullscreen/screamer, rand(1, 23))
		dude.clear_fullscreen("screamer", rand(15, 60))

	playsound(dude, get_random_sound(), 100)


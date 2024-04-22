/datum/quirk/bad_touch
	name = "Недотрога"
	desc = "Не люблю обниматься. Будет предпочтительнее, если меня оставят в покое."
	icon = "tg-bad-touch"
	mob_trait = TRAIT_BADTOUCH
	value = -1
	gain_text = span_danger("Просто хочу чтобы меня оставили в покое.")
	lose_text = span_notice("Меня не помешало бы крепко обнять.")
	medical_record_text = "Пациент негативно реагирует на физические прикосновения. Предварительный диагноз: гаптофобия."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	hardcore_value = 1
	mail_goodies = list(/obj/item/reagent_containers/spray/pepper) // show me on the doll where the bad man touched you

/datum/quirk/bad_touch/add(client/client_source)
	RegisterSignals(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT), PROC_REF(uncomfortable_touch))

/datum/quirk/bad_touch/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT))

/// Causes a negative moodlet to our quirk holder on signal
/datum/quirk/bad_touch/proc/uncomfortable_touch(datum/source)
	SIGNAL_HANDLER

	if(quirk_holder.stat == DEAD)
		return

	new /obj/effect/temp_visual/annoyed(quirk_holder.loc)
	if(quirk_holder.mob_mood.sanity <= SANITY_NEUTRAL)
		quirk_holder.add_mood_event("bad_touch", /datum/mood_event/very_bad_touch)
	else
		quirk_holder.add_mood_event("bad_touch", /datum/mood_event/bad_touch)

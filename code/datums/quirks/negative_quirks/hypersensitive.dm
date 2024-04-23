/datum/quirk/hypersensitive
	name = "Нытик"
	desc = "Хорошо это или плохо, но происходящие события оказывают сильное влияние на мое настроение."
	icon = FA_ICON_FLUSHED
	value = -2
	gain_text = span_danger("Мне хочется создать одну огромную проблему из всего.")
	lose_text = span_notice("Мне больше не хочется устраивать драму.")
	medical_record_text = "Пациент демонстрирует резкие перепады настроения."
	hardcore_value = 3
	mail_goodies = list(/obj/effect/spawner/random/entertainment/plushie_delux)

/datum/quirk/hypersensitive/add(client/client_source)
	if (quirk_holder.mob_mood)
		quirk_holder.mob_mood.mood_modifier += 0.5

/datum/quirk/hypersensitive/remove()
	if (quirk_holder.mob_mood)
		quirk_holder.mob_mood.mood_modifier -= 0.5

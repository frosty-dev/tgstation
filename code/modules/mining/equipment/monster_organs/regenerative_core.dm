/**
 * On use in hand, heals you over time and removes injury movement debuffs. Also makes you a bit sad.
 * On use when implanted, fully heals. Automatically fully heals if you would enter crit.
 */
/obj/item/organ/internal/monster_core/regenerative_core
	name = "регенеративное ядро"
	desc = "Всё, что осталось от главы улья. Может помочь вам продолжать двигаться, но быстро станет бесполезным."
	desc_preserved = "Всё, что осталось от главы улья. Стабилизировано, позволяет вам полностью восстановиться без опасности разложения."
	desc_inert = "Всё, что осталось от главы улья. Разложилось и полностью бесполезно."
	user_status = /datum/status_effect/regenerative_core
	actions_types = list(/datum/action/cooldown/monster_core_action/regenerative_core)
	icon_state = "hivelord_core"
	icon_state_inert = "hivelord_core_decayed"

/obj/item/organ/internal/monster_core/regenerative_core/preserve(implanted = FALSE)
	if (implanted)
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "implanted"))
	else
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "stabilizer"))
	return ..()

/obj/item/organ/internal/monster_core/regenerative_core/go_inert()
	. = .. ()
	if (!.)
		return
	SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "inert"))

/obj/item/organ/internal/monster_core/regenerative_core/on_life(seconds_per_tick, times_fired)
	. = ..()
	if (owner.health <= owner.crit_threshold)
		trigger_organ_action(TRIGGER_FORCE_AVAILABLE)

/obj/item/organ/internal/monster_core/regenerative_core/on_triggered_internal()
	owner.revive(HEAL_ALL)
	qdel(src)

/// Log applications and apply moodlet.
/obj/item/organ/internal/monster_core/regenerative_core/apply_to(mob/living/target, mob/user)
	target.add_mood_event(MOOD_CATEGORY_LEGION_CORE, /datum/mood_event/healsbadman)
	if (target != user)
		target.visible_message(span_notice("[user] заставляет [target] использовать [src]... Чёрные щупальца обвивают и укрепляют [target.ru_ego()]!"))
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "used", "other"))
	else
		to_chat(user, span_notice("Начинаю наносить [src] на себя. Отвратительные щупальца обвивают вас вместе и дают силы двигаться, но насколько долго?"))
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "used", "self"))
	return ..()

/// Different graphics/desc for the lavaland legion
/obj/item/organ/internal/monster_core/regenerative_core/legion
	desc = "Странный камень, который трещит от энергии. Может быть использован для полного восстановления, но быстро станет бесполезным."
	desc_preserved = "Ядро стабилизировано, позволяя вам использовать его для полного восстановления без опасности разложения."
	desc_inert = "Ядро разложилось и полностью бесполезно."
	icon_state = "legion_core"
	icon_state_inert = "legion_core_decayed"
	icon_state_preserved = "legion_core_stable"

/// Action used by the regenerative core
/datum/action/cooldown/monster_core_action/regenerative_core
	name = "Восстановление"
	desc = "Полностью восстановит ваше тело, потребляя ваше регенеративное ядро в процессе. \
		Этот процесс запустится автоматически, если вы сильно ранены."
	button_icon_state = "legion_core_stable"

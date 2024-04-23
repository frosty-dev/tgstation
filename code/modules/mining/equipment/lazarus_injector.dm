/**
 * Players can revive simplemobs with this.
 *
 * In-game item that can be used to revive a simplemob once. This makes the mob friendly.
 * Becomes useless after use.
 * Becomes malfunctioning when EMP'd.
 * If a hostile mob is revived with a malfunctioning injector, it will be hostile to everyone except whoever revived it and gets robust searching enabled.
 */
/obj/item/lazarus_injector
	name = "инъектор Лазаря"
	desc = "Инъектор с коктейлем из наномашин и химических веществ. Он может воскрешать животных из мертвых, заставляя их становиться дружелюбными по отношению к пользователю. К сожалению, этот процесс бесполезен для высших форм жизни и невероятно дорог, поэтому эти инъекторы лежали на складе, пока один из руководителей не решил, что они станут отличной мотивацией для некоторых сотрудников."
	icon = 'icons/obj/medical/syringe.dmi'
	icon_state = "lazarus_hypo"
	inhand_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	///Can this still be used?
	var/loaded = TRUE
	///Injector malf?
	var/malfunctioning = FALSE
	///So you can't revive boss monsters or robots with it
	var/revive_type = SENTIENCE_ORGANIC

/obj/item/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!loaded || !proximity_flag)
		return

	if(SEND_SIGNAL(target, COMSIG_ATOM_ON_LAZARUS_INJECTOR, src, user) & LAZARUS_INJECTOR_USED)
		return

	if(!isliving(target))
		return

	var/mob/living/target_animal = target
	if(!target_animal.compare_sentience_type(revive_type)) // Will also return false if not a basic or simple mob, which are the only two we want anyway
		to_chat(user, span_info("[capitalize(src.name)] не действует на данный вид существ."))
		return
	if(target_animal.stat != DEAD)
		return

	target_animal.lazarus_revive(user, malfunctioning)
	expend(target_animal, user)

/obj/item/lazarus_injector/proc/expend(atom/revived_target, mob/user)
	user.visible_message(span_notice("[user] производит инъекцию препарата в [revived_target], воскрешая его."))
	SSblackbox.record_feedback("tally", "lazarus_injector", 1, revived_target.type)
	loaded = FALSE
	playsound(src,'sound/effects/refill.ogg',50,TRUE)
	icon_state = "lazarus_empty"

/obj/item/lazarus_injector/emp_act()
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!malfunctioning)
		malfunctioning = TRUE

/obj/item/lazarus_injector/examine(mob/user)
	. = ..()
	if(!loaded)
		. += span_info("[src] пуст.")
	if(malfunctioning)
		. += span_info("Дисплей мигает и сбоит.")

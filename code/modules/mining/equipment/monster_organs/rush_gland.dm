/// Health under which implanted gland will automatically activate
#define HEALTH_DANGER_ZONE 30

/**
 * On use in hand, makes you run really fast for 5 seconds and ignore injury movement decrease.
 * On use when implanted, run for longer and ignore all negative movement. Automatically triggers if health is low (to escape).
 */
/obj/item/organ/internal/monster_core/rush_gland
	name = "гланды ускорения"
	desc = "Набухшие надпочечники лобстера. Вы можете сжать их, чтобы получить всплеск энергии."
	desc_preserved = "Набухшие надпочечники лобстера. Они сохранены, позволяя вам использовать их для ускорения, когда вам это нужно."
	desc_inert = "Сморщенные надпочечники лобстера."
	icon_state = "lobster_gland"
	icon_state_preserved = "lobster_gland_stable"
	icon_state_inert = "lobster_gland_decayed"
	user_status = /datum/status_effect/lobster_rush
	actions_types = list(/datum/action/cooldown/monster_core_action/adrenal_boost)

/obj/item/organ/internal/monster_core/rush_gland/on_life(seconds_per_tick, times_fired)
	. = ..()
	if (owner.health <= HEALTH_DANGER_ZONE)
		trigger_organ_action()

/obj/item/organ/internal/monster_core/rush_gland/on_insert(mob/living/carbon/organ_owner)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_GOLIATH_TENTACLED_GRABBED, PROC_REF(trigger_organ_action))

/obj/item/organ/internal/monster_core/rush_gland/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_GOLIATH_TENTACLED_GRABBED)

/obj/item/organ/internal/monster_core/rush_gland/on_triggered_internal()
	owner.apply_status_effect(/datum/status_effect/lobster_rush/extended)

/**
 * Status effect: Makes you run really fast and ignore speed penalties for a short duration.
 * If you run into a wall indoors you will fall over and lose the buff.
 * If you run into someone you both fall over.
 */
/datum/status_effect/lobster_rush
	id = "lobster_rush"
	duration = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/lobster_rush
	var/spawned_last_move = FALSE

/atom/movable/screen/alert/status_effect/lobster_rush
	name = "Скорость лобстера"
	desc = "Чувствую адреналин!"
	icon_state = "lobster"

/datum/status_effect/lobster_rush/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move))
	RegisterSignal(owner, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))
	owner.add_traits(list(TRAIT_IGNORESLOWDOWN, TRAIT_TENTACLE_IMMUNE), TRAIT_STATUS_EFFECT(id))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/lobster_rush)
	to_chat(owner, span_notice("Чувствую, как сердце бьется быстрее!"))

/datum/status_effect/lobster_rush/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_BUMP))
	owner.remove_traits(list(TRAIT_IGNORESLOWDOWN, TRAIT_TENTACLE_IMMUNE), TRAIT_STATUS_EFFECT(id))
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/lobster_rush)
	to_chat(owner, span_notice("Пульс возвращается к норме."))

/// Spawn an afterimage every other step, because every step was too many
/datum/status_effect/lobster_rush/proc/on_move()
	SIGNAL_HANDLER
	if (!spawned_last_move)
		new /obj/effect/temp_visual/decoy/fading(owner.loc, owner)
	spawned_last_move = !spawned_last_move

/datum/status_effect/lobster_rush/proc/on_bump(mob/living/source, atom/target)
	SIGNAL_HANDLER
	if (!target.density)
		return
	if (isliving(target))
		source.visible_message(span_warning("[source] врезается в [target]!"))
		smack_into(source)
		smack_into(target)
		qdel(src)
		return
	if (lavaland_equipment_pressure_check(get_turf(source)))
		return
	smack_into(source)
	source.visible_message(span_warning("[source] врезается в [target]!"))
	qdel(src)

/datum/status_effect/lobster_rush/proc/smack_into(mob/living/target)
	target.Knockdown(5 SECONDS)
	target.apply_damage(40, STAMINA)
	target.apply_damage(20, BRUTE, spread_damage = TRUE)

/// You get a longer buff if you take the time to implant it in yourself
/datum/status_effect/lobster_rush/extended
	duration = 5 SECONDS

/// Action used by the rush gland
/datum/action/cooldown/monster_core_action/adrenal_boost
	name = "Адреналиновый удар"
	desc = "Активируйте вашу железу ускорения, чтобы получить всплеск скорости. \
		Столкновения с объектами могут быть опасными."
	button_icon_state = "lobster_gland_stable"
	cooldown_time = 90 SECONDS

#undef HEALTH_DANGER_ZONE

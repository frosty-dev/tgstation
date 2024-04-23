/datum/surgery/revival
	name = "Нейронная реанимация"
	desc = "Экспериментальная хирургическая операция, которая позволяет вернуть пациента к жизни, даже спустя продолжительное время, главное чтобы тело было в относительно целом состоянии."
	requires_bodypart_type = NONE
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living)
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/revive,
		/datum/surgery_step/close,
	)

/datum/surgery/revival/can_start(mob/user, mob/living/target)
	if(!..())
		return FALSE
	if(target.stat != DEAD)
		return FALSE
	if(HAS_TRAIT(target, TRAIT_SUICIDED) || HAS_TRAIT(target, TRAIT_HUSK) || HAS_TRAIT(target, TRAIT_DEFIB_BLACKLISTED))
		return FALSE
	if(!is_valid_target(target))
		return FALSE
	return TRUE

/// Extra checks which can be overridden
/datum/surgery/revival/proc/is_valid_target(mob/living/patient)
	if (iscarbon(patient))
		return FALSE
	if (!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE
	return TRUE

/datum/surgery_step/revive
	name = "разряд (дефибриллятор)"
	implements = list(
		/obj/item/shockpaddles = 100,
		/obj/item/melee/touch_attack/shock = 100,
		/obj/item/melee/baton/security = 75,
		/obj/item/gun/energy = 60)
	repeatable = TRUE
	time = 5 SECONDS
	success_sound = 'sound/magic/lightningbolt.ogg'
	failure_sound = 'sound/magic/lightningbolt.ogg'

/datum/surgery_step/revive/tool_check(mob/user, obj/item/tool)
	. = TRUE
	if(istype(tool, /obj/item/shockpaddles))
		var/obj/item/shockpaddles/paddles = tool
		if((paddles.req_defib && !paddles.defib.powered) || !HAS_TRAIT(paddles, TRAIT_WIELDED) || paddles.cooldown || paddles.busy)
			to_chat(user, span_warning("Вам необходимо держать электроды в обеих руках, а [paddles.defib] должен быть заряжен!"))
			return FALSE
	if(istype(tool, /obj/item/melee/baton/security))
		var/obj/item/melee/baton/security/baton = tool
		if(!baton.active)
			to_chat(user, span_warning("[baton] должен быть активирован!"))
			return FALSE
	if(istype(tool, /obj/item/gun/energy))
		var/obj/item/gun/energy/egun = tool
		if(egun.chambered && istype(egun.chambered, /obj/item/ammo_casing/energy/electrode))
			return TRUE
		else
			to_chat(user, span_warning("Неоткуда взять разряд!"))
			return FALSE

/datum/surgery_step/revive/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Готовлюсь послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
		span_notice("[user] готовится послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
		span_notice("[user] готовится послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]."))
	target.notify_ghost_cloning("Кто-то пытается послать разряд в мой мозг.", source = target)

/datum/surgery_step/revive/play_preop_sound(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/shockpaddles))
		playsound(tool, 'sound/machines/defib_charge.ogg', 75, 0)
	else
		..()

/datum/surgery_step/revive/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(user, target, span_notice("Успешно послал[user.ru_a()] разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]...") ,
		span_notice("[user] успешно послал[user.ru_a()] разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]...") ,
		span_notice("[user] успешно послал[user.ru_a()] разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]..."))
	target.grab_ghost()
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(target.revive())
		on_revived(user, target)
		return TRUE

	target.visible_message(span_warning("...[target.ru_who()] содрогается и замирает."))
	return FALSE

/// Called when you have been successfully raised from the dead
/datum/surgery_step/revive/proc/on_revived(mob/surgeon, mob/living/patient)
	patient.visible_message(span_notice("...[patient] проснись и пой!"))
	patient.emote("gasp")
	if(HAS_MIND_TRAIT(surgeon, TRAIT_MORBID) && ishuman(surgeon)) // Contrary to their typical hatred of resurrection, it wouldn't be very thematic if morbid people didn't love playing god
		var/mob/living/carbon/human/morbid_weirdo = surgeon
		morbid_weirdo.add_mood_event("morbid_revival_success", /datum/mood_event/morbid_revival_success)

/datum/surgery_step/revive/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует.") ,
		span_notice("[user] послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует.") ,
		span_notice("[user] послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует."))
	return FALSE

/// Additional revival effects if the target has a brain
/datum/surgery/revival/carbon
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon)

/datum/surgery/revival/carbon/is_valid_target(mob/living/carbon/patient)
	var/obj/item/organ/internal/brain/target_brain = patient.get_organ_slot(ORGAN_SLOT_BRAIN)
	return !isnull(target_brain)

/datum/surgery_step/revive/carbon

/datum/surgery_step/revive/carbon/on_revived(mob/surgeon, mob/living/patient)
	. = ..()
	patient.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 199) // MAD SCIENCE

/datum/surgery_step/revive/carbon/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	. = ..()
	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 180)

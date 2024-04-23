/datum/surgery/eye_surgery
	name = "Глазная хирургия"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EYES
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_eyes,
		/datum/surgery_step/close,
	)

//fix eyes
/datum/surgery_step/fix_eyes
	name = "исправьте глаза (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/eye_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/eyes/target_eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	if(!target_eyes)
		to_chat(user, span_warning("Довольно сложно оперировать чьи-то глаза, если у [target.ru_who()] их нет."))
		return FALSE
	return TRUE

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю исправлять глаза [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает исправлять глаза [target.ru_who()].") ,
		span_notice("[user] начинает операцию на глазах [target.ru_who()]."))
	display_pain(target, "Чувствую резкую боль в глазах!")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/internal/eyes/target_eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	user.visible_message(span_notice("[user] успешно исправил[user.ru_a()] [target.ru_who()] глаза!") , span_notice("Успешно исправил глаза [skloname(target.name, RODITELNI, target.gender)]."))
	display_results(user, target, span_notice("Успешно исправил[user.ru_a()] глаза [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно исправил[user.ru_a()] глаза [target.ru_who()]!") ,
		span_notice("[user] завершил операцию на глазах [target.ru_who()]."))
	display_pain(target, "Зрение размывается, но с каждой секундой я вижу окружающее все четче!")
	target.remove_status_effect(/datum/status_effect/temporary_blindness)
	target.set_eye_blur_if_lower(70 SECONDS) //this will fix itself slowly.
	target_eyes.set_organ_damage(0) // heals nearsightedness and blindness from eye damage
	return ..()

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_by_type(/obj/item/organ/internal/brain))
		display_results(user, target, span_warning("Случайно уколол[user.ru_a()] [skloname(target.name, RODITELNI, target.gender)] прямо в мозг!") ,
			span_warning("[user] случайно уколол[user.ru_a()] [target.ru_who()] прямо в мозг!") ,
			span_warning("[user] случайно уколол[user.ru_a()] [target.ru_who()] прямо в мозг!"))
		display_pain(target, "Чувствую чудовищную боль прямо у себя в мозге!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(user, target, span_warning("Случайно уколол[user.ru_a()] [skloname(target.name, RODITELNI, target.gender)] прямо в мозг! Ну, точнее уколол бы, если бы у [target.ru_who()] был мозг.") ,
			span_warning("[user] случайно уколол[user.ru_a()] [target.ru_who()] прямо в мозг! Ну, точнее уколол бы, если бы у [target.ru_who()] был мозг.") ,
			span_warning("[user] случайно уколол[user.ru_a()] [target.ru_who()] прямо в мозг!"))
		display_pain(target, "Чувствую чудовищную боль прямо у себя в голове!") // dunno who can feel pain w/o a brain but may as well be consistent
	return FALSE

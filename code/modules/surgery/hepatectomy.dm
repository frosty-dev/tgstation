/datum/surgery/hepatectomy
	name = "Реконструкция: Гепатэктомия"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	organ_to_manipulate = ORGAN_SLOT_LIVER
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/hepatectomy,
		/datum/surgery_step/close,
	)

/datum/surgery/hepatectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/liver/target_liver = target.get_organ_slot(ORGAN_SLOT_LIVER)
	if(target_liver)
		if(target_liver.damage > 50 && !target_liver.operated)
			return TRUE
	return FALSE

////hepatectomy, removes damaged parts of the liver so that the liver may regenerate properly
//95% chance of success, not 100 because organs are delicate
/datum/surgery_step/hepatectomy
	name = "удалите поврежденную долю печени (скальпель)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 52
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/hepatectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)]."))

	display_pain(target, "Моя печень горит ужасной, колющей болью!")

/datum/surgery_step/hepatectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/human_target = target
	var/obj/item/organ/internal/liver/target_liver = target.get_organ_slot(ORGAN_SLOT_LIVER)
	human_target.setOrganLoss(ORGAN_SLOT_LIVER, 10) //not bad, not great
	if(target_liver)
		target_liver.operated = TRUE
	display_results(user, target, span_notice("Успешно удаляю поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил[user.ru_a()] поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил[user.ru_a()] поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Боль медленно утихает.")
	return ..()

/datum/surgery_step/hepatectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/human_target = target
	human_target.adjustOrganLoss(ORGAN_SLOT_LIVER, 15)
	display_results(user, target, span_warning("Случайно удаляю здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] случайно удалил[user.ru_a()] здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] случайно удалил[user.ru_a()] здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!"))
	display_pain(target, "Чувствую острую боль от надреза в своей печени!")

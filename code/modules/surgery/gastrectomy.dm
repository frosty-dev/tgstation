/datum/surgery/gastrectomy
	name = "Реконструкция: Гастрэктомия"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	organ_to_manipulate = ORGAN_SLOT_STOMACH
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/gastrectomy,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/close,
	)

/datum/surgery/gastrectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/stomach/target_stomach = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(target_stomach)
		if(target_stomach.damage > 50 && !target_stomach.operated)
			return TRUE
	return FALSE

////Gastrectomy, because we truly needed a way to repair stomachs.
//95% chance of success to be consistent with most organ-repairing surgeries.
/datum/surgery_step/gastrectomy
	name = "удалить нижнюю часть двенадцатиперстной кишки (скальпель)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 52
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/gastrectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю вырезать часть поврежденного желудка [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] делает надрез желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] делает надрез желудка [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Чувствую резкую боль в животе!")

/datum/surgery_step/gastrectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/target_human = target
	var/obj/item/organ/internal/stomach/target_stomach = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	target_human.setOrganLoss(ORGAN_SLOT_STOMACH, 20) // Stomachs have a threshold for being able to even digest food, so I might tweak this number
	if(target_stomach)
		target_stomach.operated = TRUE
	display_results(user, target, span_notice("Успешно извлекаю поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно извлекает поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно извлекает поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Боль в животе ослабевает и немного утихает.")
	return ..()

/datum/surgery_step/gastrectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/target_human = target
	target_human.adjustOrganLoss(ORGAN_SLOT_STOMACH, 15)
	display_results(user, target, span_warning("Вырезал[user.ru_a()] неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] вырезал[user.ru_a()] неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] вырезал[user.ru_a()] неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Больно! Дьявол, это очень больно!")

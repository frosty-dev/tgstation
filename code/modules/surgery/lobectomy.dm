/datum/surgery/lobectomy
	name = "Реконструкция: Лобэктомия"	//not to be confused with lobotomy
	organ_to_manipulate = ORGAN_SLOT_LUNGS
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy,
		/datum/surgery_step/close,
	)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/lungs/target_lungs = target.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(target_lungs)
		if(target_lungs.damage > 60 && !target_lungs.operated)
			return TRUE
	return FALSE


//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "отсеките поврежденный сегмент легкого (скальпель)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 42
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю делать надрез в легких [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Чувствую колющую боль в груди!")

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/internal/lungs/target_lungs = human_target.get_organ_slot(ORGAN_SLOT_LUNGS)
		target_lungs.operated = TRUE
		human_target.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(user, target, span_notice("Успешно удаляю наиболее поврежденный сегмент легких [human_target].") ,
			span_notice("Поврежденный сегмент легких [human_target] был успешно удален."),
			"")
		display_pain(target, "Грудь адски болит, но дышать стало немного проще.")
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(user, target, span_warning("Я ошибаюсь и повреждаю здоровую часть легкого [human_target]!") ,
			span_warning("[user] ошибается!") ,
			span_warning("[user] ошибается!"))
		display_pain(target, "Чувствую колющую боль в груди. У меня сбилось дыхание и теперь мне больно дышать!")
		human_target.losebreath += 4
		human_target.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
